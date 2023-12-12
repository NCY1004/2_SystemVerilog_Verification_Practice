interface fifo_if;
	logic 				clock, rst, rd, wr	;
	logic		[7:0] 	data_in, data_out		;
	logic 				full, empty				;
endinterface



class transaction;
	rand bit rd, wr;			//DUT의 Input 포트에만 랜덤
	rand bit [7:0] data_in;
	bit full, empty;
	bit [7:0] data_out;
	
	constraint wr_rd {
		rd != wr;						//Write Enable 신호와 같지 않다
		wr dist {0:/50 , 1:/50};	//Enable 신호 0,1 각각 50프로 비율
		rd dist {0:/50 , 1:/50}; 
	}

	constraint datain{
		//data_in > 1;
		//data_in < 5;
		data_in inside {[1:5]};
	}

	function void display(input string tag);
     $display("[%0s] : WR : %0b\t RD:%0b\t DATAWR : %0d\t DATARD : %0d\t FULL : %0b\t EMPTY : %0b @ %0t", tag, wr, rd, data_in, data_out, full, empty,$time); //문자열을 수신하면 출력
  endfunction

   function transaction copy();
		copy = new();
		copy.rd = this.rd;
		copy.wr = this.wr;
		copy.data_in = this.data_in;
		copy.full = this.full;
		copy.empty = this.empty;
		copy.data_out = this.data_out;
	endfunction

endclass

class generator;
	transaction tr;
	mailbox #(transaction) mbx;
	
	function new(mailbox #(transaction) mbx);
		this.mbx = mbx;
		tr = new(); //mailbox 와 trasaction 간의 연결
	endfunction

	event next; //다음 랜덤값 생성요청수신 이벤트
	event done; //랜덤값 생성 종료

	int count =0;
		
	task run();
		repeat(count) begin
			assert(tr.randomize) else $error ("Randomization failed"); //assert 는 randomize 매서드를 자동으로 호출하고 그조건이 참인지 확인 또한 assert는 일반적으로 True가 되는 조건을 선언하므로, true일 때 딱히 할 말이 없을때 바로 else 선언
			mbx.put(tr.copy); // generator 클래스에서 랜덤값 생성시 copy 사용 (Generator 가 생성한 랜덤값을 mailbox 에 안전하게 전달용도 -> 다른클래스가 랜덤가 랜덤값 생성할 경우가 생기므로 copy 매서드를 사용하여 생성)
			tr.display("GEN:");
			@(next); // 다음 randomize 요청 트리거 수진
		end
 		->done;	// 랜덤값 생성 종료	

	endtask
endclass

class driver;
	virtual fifo_if fif; //dut와 연결
	
	mailbox #(transaction) mbx;
	transaction datac;
	event next;

	function new (mailbox #(transaction) mbx);
		this.mbx=mbx;
	endfunction
	
	task reset();
		fif.rst <= 1'b1; //리셋신호
		fif.rd <= 1'b0;
		fif.wr <= 1'b0;
		fif.data_in <= 1'b0;
		repeat(5) @ (posedge fif.clock);
			fif.rst <=1'b0; //5사이클 동안 리셋신호 제거

	endtask

	task run();
		forever begin
			mbx.get (datac);

			datac.display("DRV");

			fif.rd <= datac.rd;
			fif.wr <= datac.wr;
			fif.data_in <= datac.data_in;
			repeat(2) @(posedge fif.clock); // 안정적으로 2사이클동안 DUT에 데이터 신호를 보냄
			->next; 
		end
	endtask

endclass

class monitor;
	virtual fifo_if fif;

	mailbox #(transaction) mbx;
	transaction tr;
	
	event next;

	function new(mailbox #(transaction) mbx);
		this.mbx = mbx;
	endfunction

	task run();
		tr = new();
		forever begin
			repeat (2) @(posedge fif.clock);
			tr.wr = fif.wr; //Transaction 으로 할당이 안정적으로 하기 위하여 Blocking 문사용
			tr.rd = fif.rd;
			tr.data_in = fif.data_in;
			tr.data_out = fif.data_out;
			tr.full = fif.full;
			tr.empty = fif.empty;

			mbx.put(tr);

			tr.display ("mon");

		end

	endtask
endclass

class scoreboard;
   mailbox #(transaction) mbx;
   transaction tr;

   function new(mailbox #(transaction) mbx);
      this.mbx = mbx;
   endfunction

   event next;

   bit [7:0] din[$]; // Queue 변수
   bit [7:0] temp;

   task run();
      mbx.get(tr);
      tr.display("Sco");

      if (tr.wr == 1'b1) begin
         din.push_front(tr.data_in); // data_in을 din 큐 변수의 맨 앞에 추가
         $display("[SCO] : DATA STORED IN QUEUE: %0d", tr.data_in);
      end

      if (tr.rd == 1'b1) begin

         if (tr.empty == 1'b0) begin // din이 비어있지 않은 경우
            temp = din.pop_back; // din의 가장 마지막 요소를 temp로 이동

            if (tr.data_out == temp)
               $display("[SCO] : DATA MATCH");
            else
               $error("[SCO] : DATA MISMATCH");
         end
         else begin
            $display("[SCO] : FIFO IS EMPTY");
         end
			->next;
      end
      
   endtask

endclass

class environment;
	generator gen;
	driver drv;
	monitor mon;
	scoreboard sco;

	mailbox #(transaction) gdmbx; // generator, Driver 용 
	mailbox #(transaction) msmbx; // Monitor, Scoreboard 용

	event nextgs; //generator 이벤트 트리거용 (다음 generator 발생요청)

	virtual fifo_if fif; //Test BenchTop 연결 용도로 environment 내부에도 인터페이스 선언

	function new(virtual fifo_if fif); // 인터페이스에서 데이터를 파싱하기 위해 사용자 함수 선언

		gdmbx = new(); //mailbox 연결
		gen = new(gdmbx);
		drv = new(gdmbx);

		msmbx = new();
		mon = new(msmbx);
		sco = new(msmbx);

		this.fif = fif; //Environtment 인터페이스와 driver/monitor 간의 연결

		drv.fif = this.fif;
		mon.fif = this.fif; 

		gen.next = nextgs; //Generator , Scoreboard 간 이벤트 연결
		sco.next = nextgs;
	endfunction

	task pre_test(); //test 전
		drv.reset();
	endtask
	
	task test(); // test 중
		fork
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_any
	endtask

	task post_test(); // test 후
		wait(gen.done.triggered);
			$finish();
	endtask

	task run(); //test 시퀀스 함수
		pre_test();
		test();
		post_test();
	endtask
endclass


module tb;
	fifo_if fif();
	
	fifo dut (
	.clock(fif.clock),
	.rst(fif.rst),
	.rd(fif.rd),
	.wr(fif.wr),
	.data_in(fif.data_in),
	.data_out(fif.data_out),
	.full(fif.full),
	.empty(fif.empty)	
	);

	initial begin
		fif.clock = 1'b0;
	end

	always #10 fif.clock = ~fif.clock;
	
	environment env;

	initial begin
		env = new(fif); //environment 의 인터페이스와 연결	
		env.gen.count = 20;
		env.run();	
	end

   initial begin
		$fsdbDumpvars;	//Verdi 디비깅 파일 생성
      #2000;
      $finish();      
  end
    

endmodule
