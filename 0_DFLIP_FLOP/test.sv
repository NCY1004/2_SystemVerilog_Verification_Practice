interface dff_if;
	logic	clk;
	logic rst;
	logic din;
	logic dout;
endinterface

///////////////////////////////////////////////////////////

class transaction;
	rand bit din;	//random din
	bit dout;
	
	function transaction copy();
		copy = new(); //create a new transaction object
		copy.din = this.din; //copy input value
		copy.dout = this.dout;	//copy the output value 
	endfunction

	function void display (input string tag);
		$display("[%0s] : DIN : %0d DOUT : %0b", tag, din ,dout); //display transaction information
	endfunction
endclass

/////////////////////////////////////////////////////////////////////

class generator;
	transaction tr;
	mailbox #(transaction) mbx;	//mailbox to send data to the driver
	mailbox #(transaction) mbxref;	//mailbox to send data to the scoreboard for compare with golden data;

	event sconext; //Event to sense the completion of scoreboard work
	event done; //Event to trigger when the requested number of stimuli is applied

	int count;	//Stimulus count

	function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
		this.mbx = mbx;	//initialize the mailbox for driver
		this.mbxref = mbxref; //initialize the mailbox for the scroeboard
		tr = new(); // create transaction object
	endfunction

	task run();
		repeat (count) begin
			assert(tr.randomize) else $error ("[GEN] : Randomization Failed");
			tr.din = 1'bx;
			mbx.put(tr.copy); //put a copy of the transaction into the driver mailbox
 			mbxref.put(tr.copy); //put a copy of the transaction into the scoreboard mailbox
			tr.display("GEN"); //display transaction information
			@(sconext); //wait for the scoreboard's completion signal
 		end
		->done;
	endtask
endclass

///////////////////////////////////////////////////////////////////////////

class driver;
	transaction tr;
	mailbox #(transaction) mbx; // create a mailbox to receive data from generator

	virtual dff_if vif; //Virtual interface for DUT

	function new(mailbox #(transaction) mbx);
		this.mbx = mbx;		// Initialize the mailbox for receiving data
	endfunction

	task reset();
		vif.rst <= 1'b1; //Assert reset signal
		repeat(5) @ (posedge vif.clk); // wait for 5 clock cycles
		vif.rst <= 1'b0; //Deassert reset signal
		@(posedge vif.clk); // wait for one more clock cycle
		$display("[DRV : RESET DONE"); //Display reset completion Massage
	endtask

	task run();
		forever begin
			mbx.get(tr); //get a Transaction from the generator
			vif.din <= tr.din; // input dut from the transaction
			@(posedge vif.clk); // wait for the rising edge of the clock
			tr.display ("DRV");
			vif.din <= 1'b0; // Set Dut input 0
			@(posedge vif.clk); //wait for the rising edge of the clock

		end
	endtask 
	
endclass		  

////////////////////////////////////////////////////////////////////////////

class monitor;
	transaction tr;	// Define a transaction object
	mailbox #(transaction) mbx;
	
	virtual dff_if vif; // Virtual interface for DUT

	function new(mailbox #(transaction) mbx);                             
   	this.mbx = mbx;      // Initialize the mailbox for sending data to the scoreboard 
	endfunction                                                           
	
	task run();
		tr =new();
		forever begin
			repeat(2) @(posedge vif.clk); // wait for two rising edges
			tr.dout = vif.dout; // capture DUT output
			mbx.put(tr);	//send the captured data to the scoreboard
			tr.display("MON");	//Display transaction information
		end
	endtask
endclass

/////////////////////////////////////////////////////////////////////////////////

class scoreboard;
	transaction tr;	// Define a transaction object
	transaction trref;	// Define a reference transaction object for comparson

	mailbox #(transaction) mbx;
	mailbox #(transaction) mbxref; // Create a mailbox to receive reference data from the generator

	event sconext;

	function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
   	this.mbx = mbx; // Initialize the mailbox for receiving data from the driver
  		this.mbxref = mbxref; // Initialize the mailbox for receiving reference data from the generator
   endfunction

   task run();
		forever begin
			mbx.get(tr);	//get a transaction from the driver
			mbxref.get(trref);	//get a reference from the generator
		
			tr.display("SCO"); //Display the driver's transaction
			trref.display("REF"); //Display the reference transaction

			if(tr.dout == trref.din)
					  $display("[SCO] : DATA MATCHED"); //compare data
			else
					  $display("[SCO] : DATA MISMATCHED");
			$display ("-------------------------------------------------");
			->sconext;	// Signal completation of scoreboard work
		end
    endtask
endclass

////////////////////////////////////////////////////////////////////////////////

class environment;
	generator gen;		//generator instance
	driver drv;		//Driver instance
	monitor mon;	//Monitor instance
	scoreboard sco;	//Scoreboard instance
	event next;	// Event to signal communication between generator and scoreboard

 	mailbox #(transaction) gdmbx; // Mailbox for communication between generator and driver
   mailbox #(transaction) msmbx; // Mailbox for communication between monitor and scoreboard
   mailbox #(transaction) mbxref; // Mailbox for communication between generator and scoreboard

	virtual dff_if vif;	//Virtual interface for DUT

	function new(virtual dff_if vif);
		gdmbx = new();
		mbxref = new();
		gen = new(gdmbx, mbxref);	//	Initialize the generator
		drv = new(gdmbx);	//	Initialize the driver

		msmbx = new();
		mon = new(msmbx);	// Initialize the monitor 
		sco = new(msmbx, mbxref);	// Initialize the scoreboard 
		
		this.vif = vif;	//Set the virtual interface for DUT
		drv.vif = this.vif;	// connect the virtual interface to the driver
		mon.vif = this.vif;	// connect the virtual interface to the monitor
		
		gen.sconext = next; // Set the communication event between generator and scoreboard
    	sco.sconext = next; // Set the communication event between scoreboard and generator
   endfunction

	task pre_test();
		drv.reset(); // Perform the driver reset
	endtask
	
	task test();
		fork
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_any
	endtask
	
	task post_test();
		wait(gen.done.triggered); //wait for generator to complete
		$finish();// Finish simulation
	endtask

  	task run();
   	 pre_test(); // Run pre-test setup
       test(); // Run the test
    	 post_test(); // Run post-test cleanup
   endtask
endclass

////////////////////////////////////////////////////

module tb;
  dff_if vif(); // Create DUT interface
  dff dut(
  		.clk(vif.clk),
	  	.rst(vif.rst),
		.din(vif.din),
		.dout(vif.dout)		
         ); // Instantiate DUT

  initial begin
  		vif.clk <= 0; //Initial clock signal
  end

  always #10 vif.clk <= ~vif.clk;

  environment env;

  initial begin
   	env = new(vif); //Initialize the envrionment with the DUT
		env.gen.count = 30; // Set the generator's stimulus count
		env.run();	//Run the environment
  end
	
  initial begin
		$fsdbDumpvars;	// Generate verdi file
  end

endmodule
