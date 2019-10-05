// 使用预读机制，在水平回扫开始，读取内存到 vram_buf
// 目的是隔离显示模块和内存访问之间的时钟依赖
// 因使用的双口RAM，视频模块读取的地址和预取操作的地址可能会有冲突。更进一步的设计是使用缓冲区切换来避免访问冲突。

// 预取 64 个字节，在水平回扫发生时开始
// 预取方式，因读取的速度快于内存预取的速度，不会出现双口RAM的读写冲突问题read-during-write。

module apple_vram_buf
{
	input		clk,
	output	reg	rd_en,

	// 触发信号
	input	trg,

	output	[15:0]		ADDRESS,
	input				HSYNC_N,
	input				VSYNC_N,
	input				RESET_N
}

/*******************************************************
* Generate Address
* text address
*				Skip V_ADD[0] because we want two lines exactly the same
*				Skip V_ADD[3:1] for text, use for HGR
********************************************************/
assign	TENBIT_ADDRESS =	({V_ADD[6:4],RAM_ADD[6:0]});

assign	ADDRESS =	(APPLE_VID == 1'b0)								?	{3'b100,V_ADD[6:1],RAM_ADD[6:0]}:
					({TEXT,HI_RES,MIXED,MM_POS,CLOCK}== 5'b01000)	?	{1'b0,SECONDARY,~SECONDARY,V_ADD[3:1],TENBIT_ADDRESS}:
					({TEXT,HI_RES,MIXED,MM_POS,CLOCK}== 5'b01010)	?	{1'b0,SECONDARY,~SECONDARY,V_ADD[3:1],TENBIT_ADDRESS}:
					({TEXT,HI_RES,MIXED,MM_POS,CLOCK}== 5'b01100)	?	{1'b0,SECONDARY,~SECONDARY,V_ADD[3:1],TENBIT_ADDRESS}:
																		{4'b0000,SECONDARY,~SECONDARY,TENBIT_ADDRESS};  // Change to 4'b0000 for Apple

wire	[1:0]		MODE;

/********************************************************
* Set video mode
*********************************************************/
assign MODE =	(CLOCK | ((TEXT  | (MIXED & MM_POS)) & APPLE_VID))	?	2'b00:
				((HI_RES & ~DHRES) | ~APPLE_VID)					?	2'b10:
				(DHRES)												?	2'b11:
																		2'b01;

asyn_ram#(.DWIDTH(8),.AWIDTH(6))	vram_buf
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


	always @(posedge clk)
	begin
		if(trg)
		begin
			cnt		<=	40;
			rd_en	<=	1'b1;
		end

		if(rd_en)
		begin

		addr	<=	addr+1;
			rd_en	<=	1'b0;
		end
	end

	always @(posedge clk)
		if(cnt!=0)
		begin
			if(rd_en)
			// 读取
		end
	end


	// line
	reg	[9:0]	line_count;

	// 需要一个计数器，来计算偏移
	always @(negedge HSYNC_N or negedge VSYNC_N or negedge RESET_N)
	begin
		if(~RESET_N)
		begin
			// on reset set line counter to 0
			line_count	<=	10'd0;
			fitch_buf	<=	1'b0;
		end
		else
		if(~VSYNC_N)
		begin
			line_count <= 10'd0;
			fitch_buf	<=	1'b0;
		end
		else
		begin
			line_count <= line_count + 1;

			// 开始取缓冲数据
			if(line_count==2+(520-463)-1)
				fitch_buf	<=	1'b1;

			// 预取 192 行的数据
			if(line_count==2+(520-463)+192+192-1)
				fitch_buf	<=	1'b0;

			// 垂直回扫 2 行，从58行开始显示
			if(line_count==2+(520-463)-1)
				V_ADD	<=	0;
			if()

			case (MODE)
			2'b00:				// Text Mode
			begin
				if(ALT)
			end
			2'b01:				// Low Res Graphics
			begin
			end
			2'b10:				// Hi Res Graphics
			begin
			end
			2'b11:				// DHGR
			begin
			end
		end
	end

	// VSYNC 垂直回扫发生，地址重置
	// HSYNC 水平回扫发生，地址调整（加偏移）

endmodule
