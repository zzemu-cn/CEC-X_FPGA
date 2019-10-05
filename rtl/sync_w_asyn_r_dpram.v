module sync_w_asyn_r_dpram
#(parameter DWIDTH=8,AWIDTH=6)
(
	input					wr_clk,
	input					wr_en,
	input	[AWIDTH-1:0]	wr_addr,
	input	[DWIDTH-1:0]	wr_data,

	input					rd_clk,
//	input	rd_en,
	input	[AWIDTH-1:0]	rd_addr,
	output	[DWIDTH-1:0]	rd_data
);

	reg[DWIDTH-1:0]	rw_mem[2**AWIDTH-1:0];
	//reg[AWIDTH-1:0] raddr;

	always@(posedge wr_clk)
	begin
		if(wr_en)
			rw_mem[wr_addr]	<=	wr_data;
	end

/*
	always@(posedge rd_clk)
	begin
		//if(rd_en) begin
			raddr	<=	rd_addr;
	end

	assign	rd_data	=	rw_mem[raddr];
*/
	assign	rd_data	=	rw_mem[rd_addr];

endmodule 
