// 使用预读机制，在水平回扫开始，读取内存到 vram_buf
// 目的是隔离显示模块和内存访问之间的时钟依赖
// 因使用的双口RAM，视频模块读取的地址和预取操作的地址可能会有冲突。更进一步的设计是使用缓冲区切换来避免访问冲突。

// 预取 64 个字节，在水平回扫发生时开始
// 预取方式，因读取的速度快于内存预取的速度，不会出现双口RAM的读写冲突问题read-during-write。
// 另外，还可以只预取1个字节。发生读取，就开始读取下个字节。

// 预取地址的计算方式可以用计算法和记录上次读取位置两种方式。
// 通用的预取地址，可以建个480个地址缓冲区。每行的第1个读取时记录下地址，供下次预读使用。这样页面会晚一帧。
// 如果是单页面的缓冲区，像LASER310，只需要累加计算缓冲区就行。苹果2的页面地址不连续，所以不容易简单确定起始地址。

// 该模块采用记录上次预读位置的方式。

`define	READ_ADDR_NULL	16'hFFFF
`define	READ_ADDR_NULL_H	8'hFF
`define	READ_ADDR_NULL_L	8'hFF


// 从水平回扫开始计数，用于确定视频缓冲区读取位置
// 这个值是每行第一次读取缓冲区数据前的一个位置，调试得到的。有效读取在水平回扫期间已经开始。

// 在模块apple_video.v中，H_ADD计数为0前的一个周期，缓冲区地址已经设置为第1个位置
`define	VID_PIX_RDY_START	10'h040

`define	BUF_FETCH_NUM		64


module vram_buf
#(parameter VAWIDTH=16,DWIDTH=8,AWIDTH=6)
(
	input			sys_clk,
	input			vid_clk,

	// 系统读取接口
	input						vram_rdy,			// 收到读取信号的下个周期必须完成读取操作
	output	reg	[VAWIDTH-1:0]	vram_addr,
	output	reg					vram_fetch_wait,	// 准备从外部vram取数据，便于外部模块提前生成读取信号
	output	reg					vram_cs,
	input		[DWIDTH-1:0]	vram_data,


	// 视频读取接口
	(*keep*)input	wire			vid_en,
	input		[VAWIDTH-1:0]	vid_addr,
	output		[DWIDTH-1:0]	vid_data,

	// 触发信号
	input			VSYNC_N,
	input			HSYNC_N,
//	input			V_BLANKING,
//	input			H_BLANKING,
	input			RESET_N
);

// vid_en 不加 (*keep*) 会被优化掉

reg		[9:0]			vid_line_count;
reg		[9:0]			last_vid_line_count;


reg		[9:0]			vid_pix_count;
reg						vid_pix_rdy;

reg						vid_pix_rst;
reg						vid_pix_rst_first;


reg		[VAWIDTH-1:0]	last_vid_line_first_addr;

(*keep*)wire	[VAWIDTH-1:0]	vid_line_addr;


reg		[VAWIDTH-1:0]	last_vram_addr;

reg						vid_line_first_addr_wr_en;

reg						line_data_wr_en;

reg						vram_wr;
reg		[AWIDTH-1:0]	vram_addr_buf;
reg		[DWIDTH-1:0]	vram_data_buf;

reg		[VAWIDTH-1:0]	vram_addr_keep;

/*******************************************************
* Generate Address
********************************************************/

// 地址记录
// 写入使用 vid_clk
// 读取使用 sys_clk

sync_w_asyn_r_dpram #(.DWIDTH(VAWIDTH),.AWIDTH(10))	vid_line_addr_buf
(
	.wr_clk(vid_clk),
	.wr_en(vid_line_first_addr_wr_en),
	.wr_addr(last_vid_line_count),
	.wr_data(last_vid_line_first_addr),

	.rd_clk(sys_clk),
//	.rd_en(),
	.rd_addr(vid_line_count),
	.rd_data(vid_line_addr)
);

// 读取缓冲
// 写入使用 sys_clk
// 读取使用 vid_clk
sync_w_asyn_r_dpram #(.DWIDTH(DWIDTH),.AWIDTH(AWIDTH))		line_data_buf
(
	.wr_clk(sys_clk),
	.wr_en(vram_wr),
	.wr_addr(vram_addr_buf[AWIDTH-1:0]),
	.wr_data(vram_data_buf),

	.rd_clk(vid_clk),
//	.rd_en(),
	.rd_addr(vid_addr[AWIDTH-1:0]),
	.rd_data(vid_data)
);


(*preserve*)reg		[7:0]	fetch_cnt;
(*preserve*)reg		[2:0]	ST;

// 可以设置预取初始值，防止读取IO，产生误操作
// 对于 apple2 可以屏蔽最高一位，即地址范围为 0000 --- 7FFF ，也不会产生误操作


// 把视频缓冲区数据提前读入line_data_buf
// 当前是逐个字节读取，可以优化为块读写，类似于DMA

reg line_connt_equ0; 
reg line_connt_equ1;

reg vram_addr_equ_l;
reg vram_addr_equ_h;

reg vram_addr_null_l;
reg vram_addr_null_h;

always @(posedge sys_clk or negedge RESET_N)
	if(~RESET_N)
	begin
		vram_fetch_wait	<=	1'b0;
		vram_cs			<=	1'b0;
		vram_wr			<=	1'b0;
		ST				<=	3'd0;
	end
	else
	begin
		case(ST)
/*
// 不能满足时钟约束，比较运算修改为两部分
			3'd0:
			begin
				vram_wr				<=	1'b0;

				if(last_vid_line_count!=vid_line_count)
				begin
					ST				<=	3'd1;
				end
			end
*/
			3'd0:
			begin
				vram_wr				<=	1'b0;

				line_connt_equ0 <= (last_vid_line_count[4:0]==vid_line_count[4:0]);
				line_connt_equ1 <= (last_vid_line_count[9:5]==vid_line_count[9:5]);

				ST				<=	3'd1;
			end

			3'd1:
			begin
				vram_wr				<=	1'b0;

				if(line_connt_equ0 && line_connt_equ1)
				begin
					ST				<=	3'd0;
				end
				else
				begin
					ST				<=	3'd2;
				end
			end

			3'd2:
			begin
				// 读取地址
				vram_addr		<=	vid_line_addr;

				// 为时钟约束
				vram_addr_equ_l	<=	(vid_line_addr[7:0]==last_vram_addr[7:0]);
				vram_addr_equ_h	<=	(vid_line_addr[VAWIDTH-1:8]==last_vram_addr[VAWIDTH-1:8]);

				vram_addr_null_l	<=	(vid_line_addr[7:0]==`READ_ADDR_NULL_L);
				vram_addr_null_h	<=	(vid_line_addr[VAWIDTH-1:8]==`READ_ADDR_NULL_H);

				ST				<=	3'd3;
			end
			3'd3:
			begin
				//if(vram_addr==last_vram_addr)
				if(vram_addr_equ_l&&vram_addr_equ_h)
				begin
					ST				<=	3'd0;
				end
				else
				begin
					last_vram_addr		<=	vram_addr;
					fetch_cnt			<=	0;
					//if(vram_addr==`READ_ADDR_NULL)
					if(vram_addr_null_l&&vram_addr_null_h)
					begin
						ST					<=	3'd0;
					end
					else
					begin
						vram_fetch_wait		<=	1'b1;
						ST					<=	3'd4;
					end
				end
			end
			3'd4:
			begin
				// 等待读取
				vram_wr				<=	1'b0;
				if(vram_rdy)
				begin
					if(fetch_cnt==`BUF_FETCH_NUM-1)	// 预读完成
					begin
						vram_fetch_wait		<=	1'b0;
					end
					vram_addr			<=	vram_addr+1;
					vram_addr_keep		<=	vram_addr;
					fetch_cnt			<=	fetch_cnt+1;
					vram_cs				<=	1'b1;
					ST					<=	3'd5;
				end
			end
			3'd5:
			begin
				// 写入读入的数据

				vram_wr				<=	1'b1;
				vram_addr_buf		<=	vram_addr_keep[AWIDTH-1:0];
				vram_data_buf		<=	vram_data;

				if(fetch_cnt==`BUF_FETCH_NUM)	// 预读完成
				begin
					vram_cs				<=	1'b0;
					ST					<=	3'd0;
				end
				else
				begin
					if(vram_rdy)	// 连续读取
					begin
						if(fetch_cnt==`BUF_FETCH_NUM-1)	// 预读完成
						begin
							vram_fetch_wait		<=	1'b0;
						end
						vram_addr			<=	vram_addr+1;
						vram_addr_keep		<=	vram_addr;
						fetch_cnt			<=	fetch_cnt+1;
						vram_cs				<=	1'b1;
					end
					else
					begin
						vram_cs				<=	1'b0;
						ST					<=	3'd4;
					end
				end
			end
			default:
				ST					<=	3'd0;
		endcase
	end



// 保存每行第1次有效读取地址
// 有效读取：用于显示的数据
// 没有读取，则保存为 FFFF
reg	first_read;

always @(posedge vid_clk)
begin
	if(vid_pix_rst)
	begin
		first_read		<=	1'b1;

		// 写入上一行的有效读取缓冲区地址
		vid_line_first_addr_wr_en	<=	1'b1;
	end
	else
	begin
		if(vid_line_first_addr_wr_en)
		begin
			last_vid_line_first_addr	<=	`READ_ADDR_NULL;
			last_vid_line_count			<=	vid_line_count;

			vid_line_first_addr_wr_en	<=	1'b0;
		end
		else
		begin
			// 第一次有效读取缓冲区
			if(first_read && vid_pix_rdy && vid_en)
			begin
				first_read					<=	1'b0;
				last_vid_line_first_addr	<=	vid_addr;
			end
		end
	end
end


// 需要一个行计数器，来计算偏移
always @(negedge HSYNC_N or negedge VSYNC_N)
begin
	if(~VSYNC_N)
	begin
		vid_line_count	<=	10'd0;
	end
	else
	begin
		vid_line_count	<=	vid_line_count + 1;
	end
end


// 从水平回扫开始计数，用于确定视频缓冲区读取位置
always @(posedge vid_clk or negedge HSYNC_N)
begin
	if(~HSYNC_N)
	begin
		vid_pix_count		<=	10'd0;
		vid_pix_rdy			<=	1'b0;
	end
	else
	begin
		vid_pix_count		<= vid_pix_count + 1;
		if(vid_pix_count==`VID_PIX_RDY_START)
			vid_pix_rdy			<=	1'b1;
	end
end


// 进入水平回扫产生一个周期的信号
always @(posedge vid_clk)
begin
	if((~HSYNC_N) && vid_pix_rst_first)
	begin
		vid_pix_rst			<=	vid_pix_rst_first;
		vid_pix_rst_first	<=	1'b0;
	end
	else
	begin
		vid_pix_rst			<=	1'b0;
		vid_pix_rst_first	<=	HSYNC_N;
	end
end

// VSYNC 垂直回扫发生，地址重置
// HSYNC 水平回扫发生，地址调整

endmodule
