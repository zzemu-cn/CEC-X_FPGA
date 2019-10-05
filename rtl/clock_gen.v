// CLK 50MHZ 60MHZ

`define	CLK_50MHZ
//`define	CLK_60MHZ

module clock_gen
(
	input				CLK,	// 50MHZ 60MHZ
	output	reg			CLK_5MHZ_TICK,
	output	reg			CLK_1MHZ_TICK,
	output	reg			CLK_1KHZ_TICK,
	output	reg			CLK_1HZ_TICK,
	output	reg			CLK_HALF,
	output	reg			CLK_5MHZ,
	output	reg			CLK_1MHZ,
	output	reg			CLK_1KHZ,
	output	reg			CLK_1HZ
);

reg		[24:0]		TIME;
reg		[2:0]		TIME_1US;
reg		[12:0]		TIME_1MS;
reg		[22:0]		TIME_1S;

reg		[2:0]		ST;

always @ (posedge CLK)
begin
`ifdef	CLK_50MHZ
	if(ST==3'd4)
`endif
`ifdef	CLK_60MHZ
	if(ST==3'd5)
`endif
	begin
		CLK_5MHZ		<=	~CLK_5MHZ;
		CLK_5MHZ_TICK	<=	~CLK_5MHZ;

		// 1MHZ
		if(TIME_1US==3'd4)
		begin
			CLK_1MHZ		<=	~CLK_1MHZ;
			CLK_1MHZ_TICK	<=	~CLK_1MHZ;
			TIME_1US		<=	0;
		end
		else
		begin
			TIME_1US		<=	TIME_1US + 1;
		end

		// 1KHZ
		if(TIME_1MS==13'd4999)
		begin
			CLK_1KHZ		<=	~CLK_1KHZ;
			CLK_1KHZ_TICK	<=	~CLK_1KHZ;
			TIME_1MS		<=	0;
		end
		else
		begin
			TIME_1MS		<=	TIME_1MS + 1;
		end

		// 1HZ
		if(TIME_1S==23'd4999999)
		begin
			CLK_1HZ			<=	~CLK_1HZ;
			CLK_1HZ_TICK	<=	~CLK_1KHZ;
			TIME_1S			<=	0;
		end
		else
		begin
			TIME_1S			<=	TIME_1S + 1;
		end

		ST	<=	3'b0;
	end
	else
	begin
		CLK_1MHZ_TICK	<=	1'b0;
		CLK_1KHZ_TICK	<=	1'b0;
		CLK_1HZ_TICK	<=	1'b0;
		CLK_5MHZ_TICK	<=	1'b0;

		ST	<=	ST+1;
	end

	CLK_HALF	<=	~CLK_HALF;
end

endmodule
