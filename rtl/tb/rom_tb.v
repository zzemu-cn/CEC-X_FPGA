module rom_b (
	input					clk,
	input					rst,
	input		[$aw_:0]		adr,
	input		[$dw_:0]		dat_i,
	output		[$dw_:0]		dat_o,
	input					we,
	input					en
);

	// ÄÚ´æ
	reg		[7:0]	Mem	[0:$MemSize];

	initial \$readmemh("$datfile",Mem);

	// Ð´²Ù×÷
	always @(posedge clk)
		if (en&&we)
			Mem[adr] <= dat_i;

	// ¶Á²Ù×÷
	assign dat_o = (en && ~we)?Mem[adr]:$dw'bz;

endmodule
