`timescale 1 ns / 1 ns

module mem_flash_tb (
	input					clk,
	input					rst,
	input		[18:0]		adr,
	output		[7:0]		dat,
	input					oe_n,
	input					ce_n
);

	// �ڴ� 512KB 524288
	reg		[7:0]	Mem	[0:524287];

//	initial $readmemh("tb/CEC-I.d",Mem);
	initial $readmemh("/CEC-X/rtl/tb/CEC-I.selftest.d",Mem);

	// ������
	assign dat = (!ce_n && !oe_n)?Mem[adr]:8'bz;

endmodule
