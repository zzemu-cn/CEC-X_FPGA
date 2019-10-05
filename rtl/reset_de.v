/*

CLK 输入 50MHz 时

RESET_N			下拉时间最小 50MHz/65536/512
RESET_AHEAD_N	下拉时间提前恢复时间 50MHz/65536/256

*/

module RESET_DE(
	CLK,			// 50MHz
	SYS_RESET_N,
	RESET_N,		// 50MHz/65536/512
	RESET_AHEAD_N	// 提前恢复，可以接 FLASH_RESET_N
);


input				CLK;
input				SYS_RESET_N;
output				RESET_N;
output				RESET_AHEAD_N;


wire	RESET_N;
wire	RESET_AHEAD_N;

reg		[15:0]		SLOW_CNT;
reg		[8:0]		RESET_COUNT;

(*keep*)wire	CNT_CLK;
wire	RESET_DE_N;
wire	RESET_AHEAD_DE_N;

reg		[7:0]	stop_cnt;
reg		[7:0]	cur_cnt;

// 时钟周期约 1 ms
assign CNT_CLK = SLOW_CNT[15];

assign RESET_N = (stop_cnt==(cur_cnt^8'h55));

assign RESET_AHEAD_N	=	(	(stop_cnt==(cur_cnt^8'h55))
							||( (stop_cnt==(cur_cnt^8'hAA)) && RESET_COUNT[8] ) );


`ifdef SIMULATE
initial
	begin
		SLOW_CNT = 16'b0;
	end
`endif

// 50MHz/65536
always @ (posedge CLK)
	SLOW_CNT <= SLOW_CNT+1;


// RESET_COUNT计数至少循环1次

// 50MHz/65536/1024
always @ (posedge CNT_CLK or negedge SYS_RESET_N)
begin
	if(~SYS_RESET_N)
	begin
		RESET_COUNT	<=	9'h0FF;
		stop_cnt	<=	8'hF0;
		cur_cnt		<=	8'h0F;
	end
	else
	begin
		// 系统加电后，相同的概率不大
 		if( stop_cnt!=(cur_cnt^8'h55) )
		begin
			RESET_COUNT		<=	RESET_COUNT+1;

			if(RESET_COUNT==9'h1FE)
				if(stop_cnt==(cur_cnt^8'hAA))
					stop_cnt	<=	cur_cnt^8'h55;
				else
					stop_cnt	<=	cur_cnt^8'hAA;
		end
	end
end

endmodule
