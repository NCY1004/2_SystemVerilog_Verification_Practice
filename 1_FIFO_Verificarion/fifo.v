module fifo (
	input 					clock		,
	input 					rst		,
	input 					rd			,
	input 					wr			,
	input			[7:0]		data_in	,
	output reg	[7:0] 	data_out ,
	output reg 				full     ,
	output reg				empty
);

reg 	[3:0] 	wptr = 0,rptr = 0;
reg	[4:0]
always @ (posedge clock)
if (rst) begin
	data_out <= 0;
   wr_ptr <= 0;
   rd_ptr <= 0;
   // 메모리 초기화
   for (int i = 0; i < 32; i = i + 1) begin
      mem[i] <= 1'b0;
   end
end
else begin
   if ((wr == 1'b1) && (full == 1'b0)) begin // 데이터를 Memory에 Write
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
   end
   else if ((rd == 1'b1) && (empty == 1'b0)) begin // Memory로부터 데이터를 Read
      data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
   end
end

assign empty = ((wr_ptr - rd_ptr) == 0) ;  //
assign full = ((wr_ptr - rd_ptr) == 31);

endmodule
