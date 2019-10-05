module mem_tb (
	input					clk,
	input					rst,
	input		[$aw_:0]		adr,
	input		[$dw_:0]		dat_i,
	output		[$dw_:0]		dat_o,
	input					we,
	input					en
);

	// �ڴ�
	reg		[7:0]	Mem	[0:$MemSize];

	initial $readmemh("$datfile",Mem);

	// д����
	always @(posedge clk)
		if (en&&we)
			Mem[adr] <= dat_i;

	// ������
	assign dat_o = (en && ~we)?Mem[adr]:$dw'bz;

endmodule
