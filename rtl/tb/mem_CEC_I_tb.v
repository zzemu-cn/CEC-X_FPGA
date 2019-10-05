module mem_CEC_I_tb (
	input					clk,
	input					rst,
	input		[18:0]		adr,
	inout		[7:0]		dat,
	input					wr,
	input					en
);

	// �ڴ�
	reg		[7:0]	Mem	[0:524287];

	initial $readmemh("tb/cec_i.d",Mem);

	// д����
	always @(posedge clk)
		if (en&&we)
			Mem[adr] <= dat_i;

	// ������
	assign dat_o = (en && ~we)?Mem[adr]:8'bz;

endmodule
