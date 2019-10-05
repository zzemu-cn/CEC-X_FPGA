`define		ST_READY				6'd0

`define		ST_UART_DECODE			6'd1
`define		ST_UART_RX				6'd2
`define		ST_UART_TX				6'd3

// 设置地址和计数
`define		ST_UART_SET_A_CNT				6'd4
`define		ST_UART_SET_A0					6'd5
`define		ST_UART_SET_A1					6'd6
`define		ST_UART_SET_A2					6'd7
`define		ST_UART_SET_CNT					6'd8
`define		ST_UART_SET_CHK					6'd9

// 读取地址和计数
`define		ST_UART_GET_A_CNT				6'd10
`define		ST_UART_GET_A0					6'd11
`define		ST_UART_GET_A1					6'd12
`define		ST_UART_GET_A2					6'd13
`define		ST_UART_GET_CNT					6'd14
`define		ST_UART_GET_CHK					6'd15


// 读地址和计数的值
`define		ST_BUF_GET_A_CNT				6'd18

// 写地址和计数的值
`define		ST_BUF_SET_A_CNT				6'd19


// 写入软驱缓冲
`define		ST_BUF_WR						6'd21
`define		ST_BUF_WR_LOOP					6'd22
`define		ST_BUF_WR_OP					6'd23
`define		ST_BUF_WR_MEM					6'd24
`define		ST_BUF_WR_WAIT					6'd25
`define		ST_BUF_WR_CNT					6'd26
`define		ST_BUF_WR_CHK					6'd27


// 读取软驱缓冲
`define		ST_BUF_RD						6'd31
`define		ST_BUF_RD_LOOP					6'd32
`define		ST_BUF_RD_MEM					6'd33
`define		ST_BUF_RD_WAIT					6'd34
`define		ST_BUF_RD_TX					6'd35
`define		ST_BUF_RD_CNT					6'd36
`define		ST_BUF_RD_CHK					6'd37


// 读 BYTE 的值
`define		ST_BUF_RD_B						6'd41
`define		ST_BUF_RD_B_OP					6'd42
`define		ST_BUF_RD_B_MEM					6'd43
`define		ST_BUF_RD_B_WAIT				6'd44
`define		ST_BUF_RD_B_TX					6'd45
`define		ST_BUF_RD_B_CHK					6'd46


// 写 BYTE 的值
`define		ST_BUF_WR_B						6'd51
`define		ST_BUF_WR_B_DAT					6'd52
`define		ST_BUF_WR_B_OP					6'd53
`define		ST_BUF_WR_B_MEM					6'd54
`define		ST_BUF_WR_B_WAIT				6'd55
`define		ST_BUF_WR_B_CHK					6'd56


module UART_IF(
	//
	MEM_A,
	MEM_WR,
	MEM_DAT,
	MEM_Q,
	MEM_RDY,
	MEM_WAIT,
	MEM_CS,
	//
	MEM_RD,

	//	Control Signals

    /*
     * UART: 115200 bps, 8N1
     */
    UART_RXD,
    UART_TXD,

	// Clock: 10MHz 50MHz
	CLK,
	RST_N
);

//
output	reg		[23:0]	MEM_A;
output	reg				MEM_WR;
output	reg		[7:0]	MEM_DAT;
input			[7:0]	MEM_Q;

input					MEM_RDY;		// 收到读取信号的下个周期必须完成读取操作
output	reg				MEM_WAIT;
output	reg				MEM_CS;

output	reg				MEM_RD;

input	wire			UART_RXD;
output	wire			UART_TXD;

input CLK;
input RST_N;


reg		[5:0]	ST;
reg		[5:0]	RET_ST;
reg		[5:0]	RET_ST_SUCC;
wire	[5:0]	RET_ST_FAIL	=	`ST_READY;

reg		[7:0]	MEM_BUF;


reg		[7:0]	UART_DAT;
reg		[19:0]	KEY_DELAY;


reg		[7:0]	DAT_CHK;
reg		[7:0]	BUF_CNT;
reg		[23:0]	BUF_A;
//reg		[7:0]	BUF_WR_DAT;



reg		[7:0]	uart_tx_tdata;
reg				uart_tx_tvalid;
wire			uart_tx_tready;

wire	[7:0]	uart_rx_tdata;
wire			uart_rx_tvalid;
reg				uart_rx_tready;

reg		[23:12]	BUF_A_INC_H;
reg		[12:0]	BUF_A_INC_L;

uart
uart_inst (
    .clk(CLK),
    .rst(~RST_N),
    // AXI input
    .s_axis_tdata(uart_tx_tdata),
    .s_axis_tvalid(uart_tx_tvalid),
    .s_axis_tready(uart_tx_tready),
    // AXI output
    .m_axis_tdata(uart_rx_tdata),
    .m_axis_tvalid(uart_rx_tvalid),
    .m_axis_tready(uart_rx_tready),
    // uart
    .rxd(UART_RXD),
    .txd(UART_TXD),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
	// 10MHz
    //.prescale(10000000/(57600*8))
	// 50MHz
    .prescale(50000000/(57600*8))
);

//9600 19200 38400 57600 115200


`ifdef SIM

/*
 * easy to read names in simulator output
 */
reg [8*6-1:0] statename;

always @*
    case( ST )
            `ST_READY:					statename = "READY";
            `ST_UART_DECODE:			statename = "UART_DECODE";
            `ST_UART_RX:				statename = "UART_RX";
            `ST_UART_TX:				statename = "UART_TX";

            `ST_BUF_WR:					statename = "BUF_WR";

            `ST_BUF_RD:					statename = "BUF_RD";

			default:					statename = "UNKNOWN";
    endcase

//always @( PC )
//      $display( "%t, PC:%04x IR:%02x A:%02x X:%02x Y:%02x S:%02x C:%d Z:%d V:%d N:%d P:%02x", $time, PC, IR, A, X, Y, S, C, Z, V, N, P );

`endif


always @(posedge CLK or negedge RST_N)
begin
	if(~RST_N)
	begin
		ST				<=	`ST_READY;
		RET_ST			<=	`ST_READY;

		MEM_A			<=	0;
		MEM_WR			<=	1'b0;
		MEM_RD			<=	1'b0;

		MEM_WAIT		<=	1'b0;
		MEM_CS			<=	1'b0;

        uart_tx_tdata	<=	8'b0;
        uart_tx_tvalid	<=	1'b0;
        uart_rx_tready	<=	1'b1;
	end
	else
	begin
		case(ST)
			`ST_READY:
			begin
				MEM_A			<=	0;
				MEM_WR			<=	1'b0;
				MEM_RD			<=	1'b0;

				MEM_WAIT		<=	1'b0;
				MEM_CS			<=	1'b0;

				uart_tx_tvalid	<=	1'b0;

				if (uart_rx_tvalid) begin
					// send byte back out
					UART_DAT		<=	uart_rx_tdata;
					ST				<=	`ST_UART_DECODE;
				end
			end

/////////////////////////////////////////////

		`ST_UART_DECODE:
		begin
			RET_ST			<=	`ST_READY;
			case(UART_DAT)
				8'h00:	// 同步
					ST			<=	`ST_READY;
				8'h01:	// 读缓冲
					ST			<=	`ST_BUF_RD;
				8'h02:	// 写缓冲
					ST			<=	`ST_BUF_WR;
				8'h03:	// 读一个字节
					ST			<=	`ST_BUF_RD_B;
				8'h04:	// 写一个字节
					ST			<=	`ST_BUF_WR_B;
				8'h05:	// 读地址和计数器
					ST			<=	`ST_BUF_GET_A_CNT;
				8'h06:	// 设置地址和计数器
					ST			<=	`ST_BUF_SET_A_CNT;
				default:
					ST			<=	`ST_READY;
			endcase
		end

/////////////////////////////////////////////
		`ST_UART_RX:
		begin
			// ready to receive byte
			if (uart_rx_tvalid) begin
				UART_DAT		<=	uart_rx_tdata;
				ST				<=	RET_ST;
			end
		end

		`ST_UART_TX:
		begin
			if (uart_tx_tvalid) begin
				if (uart_tx_tready) begin
					uart_tx_tvalid	<=	1'b0;
					ST				<=	RET_ST;
				end
			end
		end


/////////////////////////////////////////////
/////////////////////////////////////////////
		`ST_UART_SET_A_CNT:
		begin
			RET_ST			<=	`ST_UART_SET_A0;
			ST				<=	`ST_UART_RX;
		end

		`ST_UART_SET_A0:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_A[7:0]		<=	UART_DAT;
			RET_ST			<=	`ST_UART_SET_A1;
			ST				<=	`ST_UART_RX;
		end

		`ST_UART_SET_A1:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_A[15:8]		<=	UART_DAT;
			RET_ST			<=	`ST_UART_SET_A2;
			ST				<=	`ST_UART_RX;
		end

		`ST_UART_SET_A2:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_A[23:16]	<=	UART_DAT;
			RET_ST			<=	`ST_UART_SET_CNT;
			ST				<=	`ST_UART_RX;
		end

		`ST_UART_SET_CNT:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_CNT			<=	UART_DAT;
			RET_ST			<=	`ST_UART_SET_CHK;
			ST				<=	`ST_UART_RX;
		end

		`ST_UART_SET_CHK:
		begin
			if(	DAT_CHK==UART_DAT ) begin
				// 接收正常
				uart_tx_tdata	<=	8'd0;
				RET_ST			<=	RET_ST_SUCC;
			end else begin
				// 接收出错
				uart_tx_tdata	<=	8'd1;
				RET_ST			<=	RET_ST_FAIL;
			end

			uart_tx_tvalid	<=	1'b1;
			ST				<=	`ST_UART_TX;
		end

/////////////////////////////////////////////
		`ST_UART_GET_A_CNT:
		begin
			ST				<=	`ST_UART_GET_A0;
		end

		`ST_UART_GET_A0:
		begin
			DAT_CHK			<=	DAT_CHK^BUF_A[7:0];
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	BUF_A[7:0];
			RET_ST			<=	`ST_UART_GET_A1;
			ST				<=	`ST_UART_TX;
		end

		`ST_UART_GET_A1:
		begin
			DAT_CHK			<=	DAT_CHK^BUF_A[15:8];
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	BUF_A[15:8];
			RET_ST			<=	`ST_UART_GET_A2;
			ST				<=	`ST_UART_TX;
		end

		`ST_UART_GET_A2:
		begin
			DAT_CHK			<=	DAT_CHK^BUF_A[23:16];
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	BUF_A[23:16];
			RET_ST			<=	`ST_UART_GET_CNT;
			ST				<=	`ST_UART_TX;
		end

		`ST_UART_GET_CNT:
		begin
			DAT_CHK			<=	DAT_CHK^BUF_CNT;
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	BUF_CNT;
			RET_ST			<=	`ST_UART_GET_CHK;
			ST				<=	`ST_UART_TX;
		end

		`ST_UART_GET_CHK:
		begin
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	DAT_CHK;
			RET_ST			<=	RET_ST_SUCC;
			ST				<=	`ST_UART_TX;
		end


/////////////////////////////////////////////
/////////////////////////////////////////////
		`ST_BUF_GET_A_CNT:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_READY;
			ST				<=	`ST_UART_GET_A_CNT;
		end

/////////////////////////////////////////////
		`ST_BUF_SET_A_CNT:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_READY;
			ST				<=	`ST_UART_SET_A_CNT;
		end

/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
		`ST_BUF_WR:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_BUF_WR_LOOP;
			ST				<=	`ST_UART_SET_A_CNT;
		end

		`ST_BUF_WR_LOOP:
		begin
			// 读写循环
			BUF_CNT			<=	BUF_CNT-1;
			// 在之后的内存读取后计算校验值
			// DAT_CHK			<=	DAT_CHK^UART_DAT;
			RET_ST			<=	`ST_BUF_WR_OP;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_OP:
		begin
				// 地址状态要提前1个时钟周期准备，供读写锁存
				MEM_WAIT		<=	1'b1;

				DAT_CHK			<=	DAT_CHK^UART_DAT;

				MEM_A			<=	BUF_A;
				MEM_DAT			<=	UART_DAT;
				MEM_WR			<=	1'b1;
				MEM_CS			<=	1'b1;
				ST				<=	`ST_BUF_WR_MEM;
		end

		`ST_BUF_WR_MEM:
		begin
				ST				<=	`ST_BUF_WR_WAIT;
		end

		`ST_BUF_WR_WAIT:
		begin
				if(MEM_RDY)
				begin
					BUF_A_INC_H		<=	BUF_A[23:12]+1;
					BUF_A_INC_L		<=	{1'b0,BUF_A[11:0]}+1;

					MEM_WAIT		<=	1'b0;
					MEM_WR			<=	1'b0;
					MEM_CS			<=	1'b0;
					ST				<=	`ST_BUF_WR_CNT;
				end
		end

		// 判断计数器是否为零
		`ST_BUF_WR_CNT:
		begin
			//BUF_A			<=	BUF_A+1;
			if(BUF_A_INC_L[12])
			begin
				BUF_A	<=	{BUF_A_INC_H[23:12],	BUF_A_INC_L[11:0]};
			end
			else
			begin
				BUF_A	<=	{BUF_A[23:12],			BUF_A_INC_L[11:0]};
			end

			if(BUF_CNT==0)	begin
				ST				<=	`ST_BUF_WR_CHK;
			end else begin
				ST				<=	`ST_BUF_WR_LOOP;
			end
		end

		`ST_BUF_WR_CHK:
		begin
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	DAT_CHK;
			RET_ST			<=	`ST_READY;
			ST				<=	`ST_UART_TX;
		end

/////////////////////////////////////////////
		`ST_BUF_RD:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_BUF_RD_LOOP;
			ST				<=	`ST_UART_SET_A_CNT;
		end

		`ST_BUF_RD_LOOP:
		begin
				// 地址状态要提前1个时钟周期准备，供读写锁存
				MEM_WAIT		<=	1'b1;

				MEM_A			<=	BUF_A;
				MEM_WR			<=	1'b0;
				MEM_CS			<=	1'b1;
				ST				<=	`ST_BUF_RD_MEM;
		end

		`ST_BUF_RD_MEM:
		begin
			ST				<=	`ST_BUF_RD_WAIT;
		end

		`ST_BUF_RD_WAIT:
		begin
				if(MEM_RDY)
				begin
					MEM_WAIT		<=	1'b0;
					MEM_WR			<=	1'b0;
					MEM_CS			<=	1'b0;

					MEM_BUF			<=	MEM_Q;
					ST				<=	`ST_BUF_RD_TX;
				end
		end

		`ST_BUF_RD_TX:
		begin
			// 读循环
			BUF_CNT			<=	BUF_CNT-1;
			BUF_A_INC_H		<=	BUF_A[23:12]+1;
			BUF_A_INC_L		<=	{1'b0,BUF_A[11:0]}+1;

			// 在之后的内存读取后计算校验值
			DAT_CHK			<=	DAT_CHK^MEM_BUF;
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	MEM_BUF;
			RET_ST			<=	`ST_BUF_RD_CNT;
			ST				<=	`ST_UART_TX;
		end

		// 判断计数器是否为零
		`ST_BUF_RD_CNT:
		begin
			//BUF_A			<=	BUF_A+1;
			if(BUF_A_INC_L[12])
			begin
				BUF_A	<=	{BUF_A_INC_H[23:12],	BUF_A_INC_L[11:0]};
			end
			else
			begin
				BUF_A	<=	{BUF_A[23:12],			BUF_A_INC_L[11:0]};
			end

			if(BUF_CNT==0)	begin
				ST				<=	`ST_BUF_RD_CHK;
			end else begin
				ST				<=	`ST_BUF_RD_LOOP;
			end
		end

		`ST_BUF_RD_CHK:
		begin
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	DAT_CHK;
			RET_ST			<=	`ST_READY;
			ST				<=	`ST_UART_TX;
		end


/////////////////////////////////////////////
		`ST_BUF_RD_B:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_BUF_RD_B_OP;
			ST				<=	`ST_UART_SET_A_CNT;
		end

		`ST_BUF_RD_B_OP:
		begin
				// 地址状态要提前1个时钟周期准备，供读写锁存
				MEM_WAIT		<=	1'b1;

				MEM_A			<=	BUF_A;
				MEM_WR			<=	1'b0;
				MEM_CS			<=	1'b1;
				ST				<=	`ST_BUF_RD_B_MEM;
		end

		`ST_BUF_RD_B_MEM:
		begin
			MEM_BUF			<=	MEM_Q;
			ST				<=	`ST_BUF_RD_B_WAIT;
		end

		`ST_BUF_RD_B_WAIT:
		begin
				if(MEM_RDY)
				begin
					MEM_WAIT		<=	1'b0;
					MEM_WR			<=	1'b0;
					MEM_CS			<=	1'b0;

					MEM_BUF			<=	MEM_Q;
					ST				<=	`ST_BUF_RD_B_TX;
				end
		end

		`ST_BUF_RD_B_TX:
		begin
			// 在之后的内存读取后计算校验值
			DAT_CHK			<=	DAT_CHK^MEM_BUF;
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	MEM_BUF;
			RET_ST			<=	`ST_BUF_RD_B_CHK;
			ST				<=	`ST_UART_TX;
		end

		`ST_BUF_RD_B_CHK:
		begin
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	DAT_CHK;
			RET_ST			<=	`ST_READY;
			ST				<=	`ST_UART_TX;
		end

/////////////////////////////////////////////
		`ST_BUF_WR_B:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST_SUCC		<=	`ST_BUF_WR_B_OP;
			ST				<=	`ST_UART_SET_A_CNT;
		end

		`ST_BUF_WR_B_DAT:
		begin
			RET_ST			<=	`ST_BUF_WR_B_OP;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_B_OP:
		begin
				// 地址状态要提前1个时钟周期准备，供读写锁存
				DAT_CHK			<=	DAT_CHK^UART_DAT;
				MEM_WAIT		<=	1'b1;

				MEM_A			<=	BUF_A;
				MEM_DAT			<=	UART_DAT;
				MEM_WR			<=	1'b1;
				MEM_CS			<=	1'b1;
				ST				<=	`ST_BUF_WR_B_MEM;
		end

		`ST_BUF_WR_B_MEM:
		begin
				ST				<=	`ST_BUF_WR_B_WAIT;
		end

		`ST_BUF_WR_B_WAIT:
		begin
				if(MEM_RDY)
				begin
					MEM_WAIT		<=	1'b0;
					MEM_WR			<=	1'b0;
					MEM_CS			<=	1'b0;

					ST				<=	`ST_BUF_WR_B_CHK;
				end
		end

		`ST_BUF_WR_B_CHK:
		begin
			uart_tx_tvalid	<=	1'b1;
			uart_tx_tdata	<=	DAT_CHK;
			RET_ST			<=	`ST_READY;
			ST				<=	`ST_UART_TX;
		end

/////////////////////////////////////////////
		default:
			ST				<=	ST+1;
		endcase
	end
end

endmodule
