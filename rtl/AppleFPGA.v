/*****************************************************************************
* AppleFPGA APPLE ][e core.
*
*
* Ver 1.0
* July 2006
* Latest version from gbfpgaapple.tripod.com
*
******************************************************************************
*
* CPU section copyrighted by Daniel Wallner
*
******************************************************************************
*
* Apple ][e compatible system on a chip
*
* Version : 1.0
*
* Copyright (c) 2006 Gary Becker (gary_l_becker@yahoo.com)
*
* All rights reserved
*
* Redistribution and use in source and synthezised forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* Redistributions in synthesized form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
*
* Neither the name of the author nor the names of other contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*
* Please report bugs to the author, but before you do so, please
* make sure that this is not a derivative work and that
* you have the latest version of this file.
*
* The latest version of this file can be found at:
*      http://gbfpgaapple.tripod.com
*
* Limitations :
*
*  AppleFPGA is not designed to share the C800-CFFF address space.
*  There is enough ROM space in the C400-C4FF to store a few routines
*  for the C700 (Serial Drive) ROM.
*
* File history :
*
*  0.9 	First release (ALPHA)
*  0.95	Second release (BETA)
*  1.0	Full release
*
******************************************************************************/

`timescale 1 ns / 1 ns


// DE1 512K SRAM (256K*16bit) IS61LV25616
// DE2 512K SRAM (256K*16bit) IS61LV25616
// DE2-70 2M SSRAM (512K*32bit)
// DE2-115 2M SRAM (1M*16bit) IS61WV102416

// DE1 DE2 FLASH 4M
// DE0 DE2-70 DE2-115 FLASH 8M

// 通过 DE2_ControlPanel_v2.0.3 只能读写 FLASH 2M 数据，超过部分为 FF
// 通过 DE2_ControlPanel_v2.0.1 可以读写 FLASH 4M 数据


// 选择开发板
//`define	DE1
//`define	DE2

// 跳过按键。个人的DE2开发板按键失灵，需要跳过。
//`define	SKIP_BTN


`ifdef DE1

`define CLOCK_27MHZ
`define AUDIO_WM8731

`define VGA_RESISTOR
`define VGA_BIT12

`define UART_CHIP

`endif


`ifdef DE2

`define CLOCK_27MHZ
`define AUDIO_WM8731

`define VGA_ADV7123
`define VGA_BIT30

`define UART_CHIP

`endif

// 标准的 nib 格式 232960 = 6656 * 35
// 6656 1A00H

/*
// AppleFPGA 的参数 39 * 6312 = 246168
`define	FD_MAX_LEN		17'h1E0CC
`define	FD_TRACK_LEN	(13'h18A8-1)
`define	FD_TRACK_STEP	12'h62A

// 39*2		0 --- 76
`define	FD_MAX_TRACK_NO	8'd76

// 拆分，为满足时许
// (13'h18A8-1)
`define	FD_TRACK_LEN_H	(5'h18)
`define	FD_TRACK_LEN_L	(8'hA7)
*/


// 调整后的的参数 39 * 6656 = 259584
// 39*6656 /1024 = 253.5K

`define	FD_MAX_LEN		17'h1FB00
`define	FD_TRACK_LEN	(13'h1A00-1)
`define	FD_TRACK_STEP	12'h680

// 39*2		0 --- 76
`define	FD_MAX_TRACK_NO	8'd76

// 拆分，为满足时许
// (13'h1A00-1)
`define	FD_TRACK_LEN_H	(5'h19)
`define	FD_TRACK_LEN_L	(8'hFF)


module AppleFPGA(
	CLK50MHZ,
`ifdef CLOCK_27MHZ
	CLK27MHZ,
`endif

`ifdef DE2
	TD_RESET,
`endif

	// FLASH
	FL_ADDRESS,
	//FLASH_ADDRESS,
	FLASH_DATA,
	FLASH_CE_N,
	FLASH_OE_N,
	FLASH_WE_N,
	// de1 de2
	//FLASH_BYTE_N,
	//FLASH_DQ15,
	FLASH_RESET_N,
	//FLASH_RY,
	//FLASH_WP_N,

	//RAM, ROM, and Peripherials
	RAM_DATA0,			// 16 bit data bus to RAM 0
	RAM_ADDRESS,		// Common address
	RAM_RW_N,			// Common RW
	RAM_OE_N,
	RAM0_CS_N,			// Chip Select for RAM 0
	RAM0_BE0_N,			// Byte Enable for RAM 0
	RAM0_BE1_N,			// Byte Enable for RAM 0
	// RAM_DATA1,		// 16 bit data bus to RAM 1
	// RAM1_CS_N,		// Chip Select for RAM 1
	// RAM1_BE0_N,		// Byte Enable for RAM 1
	// RAM1_BE1_N,		// Byte Enable for RAM 1

	// VGA
`ifdef VGA_RESISTOR
	VGA_RED,
	VGA_GREEN,
	VGA_BLUE,
	VGA_HS,
	VGA_VS,
`endif

`ifdef VGA_ADV7123
	VGA_DAC_RED,
	VGA_DAC_GREEN,
	VGA_DAC_BLUE,
	VGA_HS,
	VGA_VS,
	VGA_DAC_BLANK_N,
	VGA_DAC_SYNC_N,
	VGA_DAC_CLOCK,
`endif

`ifdef AUDIO_WM8731
	////////////////	Audio CODEC		////////////////////////
	AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
	AUD_ADCDAT,						//	Audio CODEC ADC Data
	AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
	AUD_DACDAT,						//	Audio CODEC DAC Data
	AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
	AUD_XCK,						//	Audio CODEC Chip Clock
`endif

	// AUDIO_WM8731
	// ADV7180
	////////////////////	I2C		////////////////////////////
	AV_I2C_SDAT,					//	I2C Data
	AV_I2C_SCLK,					//	I2C Clock

	// PS/2
	PS2_KBCLK,
	PS2_KBDAT,
	//Serial Ports
	//TXD1,
	//RXD1,

    /*
     * UART: 115200 bps, 8N1
     */
`ifdef UART_CHIP_EXT
	UART_RTS,
	UART_CTS,
`endif

`ifdef UART_CHIP
	UART_RXD,
	UART_TXD,
`endif

	// Display
	//DIGIT_N,
	//SEGMENT_N,
	// LEDs
	LED,
	// Apple Perpherial
	//SPEAKER,
	//PADDLE,
	//P_SWITCH,
	//DTOA_CODE,
	// Extra Buttons and Switches
	SWITCH,
	// de1
	BUTTON_N
	//BUTTON
);

input				CLK50MHZ;

`ifdef CLOCK_27MHZ
input				CLK27MHZ;
`endif

`ifdef DE2
output	wire		TD_RESET	=	1'b1;
`endif

// FLASH
// digilent spartan3
//output	[18:0]	FLASH_ADDRESS;
//input	[7:0]	FLASH_DATA;
//output	FLASH_CE_N;
//output	FLASH_OE_N;
//output	FLASH_WE_N;

// de2
output	[21:0]	FL_ADDRESS;
wire	[21:0]	FLASH_ADDRESS;
//output	[21:0]	FLASH_ADDRESS;
//input	[15:0]	FLASH_DATA;
input	[7:0]	FLASH_DATA;
output	FLASH_CE_N;
output	FLASH_OE_N;
output	FLASH_WE_N;

//output	FLASH_BYTE_N;
//output	FLASH_DQ15;
output	FLASH_RESET_N;
//input	FLASH_RY;
//output	FLASH_WP_N;


// Main RAM Common
output	reg	[17:0]	RAM_ADDRESS;
output	reg			RAM_RW_N;
output				RAM_OE_N;

// Main RAM bank 0
//inout	reg	[15:0]	RAM_DATA0;

inout		[15:0]	RAM_DATA0;
output	reg			RAM0_CS_N;
output	reg			RAM0_BE0_N;
output	reg			RAM0_BE1_N;


// Main RAM bank 1
//inout	[15:0]	RAM_DATA1;
//output			RAM1_CS_N;
//wire			RAM1_BE0_N;
//output			RAM1_BE1_N;
//output			RAM1_BE0_N;
//output			RAM1_BE1_N;
//wire	[15:0]	RAM_DATA1;
//wire			RAM1_CS_N;
//wire			RAM1_BE0_N;
//wire			RAM1_BE1_N;

// VGA

`ifdef VGA_RESISTOR
// de0 de1
`ifdef VGA_BIT12
output	wire	[3:0]	VGA_RED;
output	wire	[3:0]	VGA_GREEN;
output	wire	[3:0]	VGA_BLUE;
`endif

output	wire			VGA_HS;
output	wire			VGA_VS;
`endif


`ifdef VGA_ADV7123
// de2
`ifdef VGA_BIT30
output	wire	[9:0]	VGA_DAC_RED;
output	wire	[9:0]	VGA_DAC_GREEN;
output	wire	[9:0]	VGA_DAC_BLUE;
`endif

`ifdef VGA_BIT24
output	wire	[7:0]	VGA_DAC_RED;
output	wire	[7:0]	VGA_DAC_GREEN;
output	wire	[7:0]	VGA_DAC_BLUE;
`endif
output	reg				VGA_HS;
output	reg				VGA_VS;
output	wire			VGA_DAC_BLANK_N;
output	wire			VGA_DAC_SYNC_N;
output	wire			VGA_DAC_CLOCK;
`endif


wire			RED;
wire			GREEN;
wire			BLUE;

// VGA
wire	[7:0]		VGA_OUT_RED;
wire	[7:0]		VGA_OUT_GREEN;
wire	[7:0]		VGA_OUT_BLUE;

wire				VGA_OUT_BLANK;

// PS/2
input 				PS2_KBCLK;
input				PS2_KBDAT;

// Serial Ports
//output			TXD1;
//input				RXD1;

// Display
//output [3:0]	DIGIT_N;
//output [7:0]	SEGMENT_N;

wire [7:0]	SEGMENT_N;

`ifdef AUDIO_WM8731

////////////////////	Audio CODEC		////////////////////////////
// ADC
inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data

// DAC
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output	wire	AUD_DACDAT;				//	Audio CODEC DAC Data

inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output	wire	AUD_XCK;				//	Audio CODEC Chip Clock

`endif


// AUDIO_WM8731
// ADV7180
////////////////////////	I2C		////////////////////////////////
inout			AV_I2C_SDAT;
output			AV_I2C_SCLK;


`ifdef UART_CHIP
input		UART_RXD;
output		UART_TXD;
`endif

`ifdef UART_CHIP_EXT
output		UART_CTS = 1'bz;
input		UART_RTS;
`endif


// LEDs
output [9:0]	LED;

// Apple Perpherial
//output			SPEAKER;
//input		[3:0]	PADDLE;
wire		[3:0]	PADDLE;
//input		[2:0]	P_SWITCH;
wire		[2:0]	P_SWITCH;
//output	[7:0]	DTOA_CODE;
wire		PADDLE_RESET;


//assign		PADDLE		=	4'b0000;
assign		PADDLE		=	4'b1111;

//assign		P_SWITCH	= 3'b000;
assign		P_SWITCH	= 3'b111;

// Extra Buttons and Switches
input	[9:0]		SWITCH;				//  7 System type 1	Not used
										//  6 System type 0	Not used
										//  5 Serial Port speed
										//  4 Swap floppy
										//  3 Write protect floppy 2
										//  2 Write protect floppy 1
										//  1 CPU_SPEED[1]
										//  0 CPU_SPEED[0]

//input	[3:0]		BUTTON;				//  3 RESET
										//  2 Not used
										//  1 Closed Apple
										//  0 Open Apple

input	[3:0]		BUTTON_N;
wire	[3:0]		BUTTON;

reg		[7:0]		DTOA_CODE;

reg		[7:0]		CLK_CNT;

reg		[4:0]		KB_CLK_CNT;

reg					CPU_CLK;
reg					CPU_CLK_N;

// RESET 时 CLK 时钟不能停止，有些 6502 cpu core 依赖于此特性。
reg		[4:0]		RESET_CLK_CNT;


`ifdef CLOCK_27MHZ
//(*keep*)wire				VGA_CLK;
wire				VGA_CLK;
`else
reg					VGA_CLK;
`endif

wire				VGA_OUT_HS;
wire				VGA_OUT_VS;

/*
(*keep*)wire		KB_CLK;
reg					CLK_1HZ;
reg					CLK_1KHZ;
reg					CLK_1MHZ;
*/

reg					KB_CLK;
wire				CLK_1HZ;
wire				CLK_1KHZ;
wire				CLK_1MHZ;

reg					RAM_RDY_VID;
reg					RAM_RDY_UART;

reg					RAM_CS_CPU;
reg					RAM_CS_FD_WR;
wire				UART_BUF_WAIT;
wire				UART_BUF_CS;

reg		[6:0]		COM1_CLOCK;
wire				RTS1;
//reg		[16:0]		RESET_KEY_COUNT;
wire				RESET_KEY_N;
wire				SYS_RESET_N;
(*keep*)wire				RESET_N;
(*keep*)wire				PH_2	=	~CPU_CLK;
//reg					RAM0_CS_Y;
reg					COM1_CLK;
// Processor
wire				IRQ;
wire				NMI;
(*keep*)wire				RW_N;
wire				SYNC;
(*keep*)wire	[7:0]		DATA_IN;
(*keep*)wire	[7:0]		DATA_OUT;
(*keep*)wire	[15:0]		ADDRESS;
(*keep*)wire	[7:0]		CPU_BANK;

wire				ADDRESS_0123;
wire				ADDRESS_4567;
wire				ADDRESS_89AB;
wire				ADDRESS_CDEF;
wire				ADDRESS_DEF;
wire				ADDRESS_CX;
wire				ADDRESS_TXT;
wire				ADDRESS_HR;

wire	ENA_C3S;
wire	ENA_C0S;
wire	ENA_C0I;
(*keep*)wire	EN_ROM;

wire				SLOT_3IO;	// CEC-I
wire				SLOT_4IO;	// Clock
wire				SLOT_6IO;	// Floppy
wire				SLOT_7IO;	// Serial Port Prodos drive

wire				ROM_RW;
wire				APPLE_C0;
wire				APPLE_STATUS_BIT;

//wire				STB;
wire				A_KEY_PRESSED;
wire				APPLE_PRESSED;
wire		[6:0]	ASCII;
wire				CAPS;
wire				L_SHIFT;
wire				R_SHIFT;
wire				L_ALT;
wire				R_ALT;

wire				SHIFT_KEY;
wire				CLR_STB;


wire	[7:0]		VROM_DATA;
(*keep*)wire				V_BLANKING;
(*keep*)wire				H_BLANKING;

wire				VROM_CLK;
wire	[11:0]		VROM_ADDRESS;
wire	[7:0]		DATA_COM1;

reg		[7:0]		CEC_C0B0;

reg					ARAM_RD;
reg					ARAM_WR;
reg					SLOTCXROM;
reg					ALT_ZP;
reg					SLOTC3ROM;
reg					STORE_80;
reg					ALT_CHAR;
reg					TEXT_80;
wire				OPEN_APL;
wire				CLOSED_APL;
reg					TEXT;
reg					MIXED;
reg					SECONDARY;
reg					HGR;
reg					DHRES;
reg					SPEAKER;
(*keep*)wire				RAM0_CS_X;
reg		[3:0]		DIGIT_N;
reg		[3:0]		YEARS_TENS;
reg		[3:0]		YEARS_ONES;
reg					MONTHS_TENS;
reg		[3:0]		MONTHS_ONES;
reg		[2:0]		DAY_WEEK;
reg		[1:0]		DAYS_TENS;
reg		[3:0]		DAYS_ONES;
reg		[1:0]		HOURS_TENS;
reg		[3:0]		HOURS_ONES;
reg		[2:0]		MINUTES_TENS;
reg		[3:0]		MINUTES_ONES;
reg		[2:0]		SECONDS_TENS;
reg		[3:0]		SECONDS_ONES;
reg		[7:0]		DEB_COUNTER;
reg		[24:0]		TIME;

/*
reg		[5:0]		TIME_1US;
reg		[9:0]		TIME_1MS;
reg		[9:0]		TIME_1S;
*/

//reg	[14:0]		TIME;
reg		[42:0]		TIME_SET;
wire	[7:0]		CLK_IN;
wire	[7:0]		CLOCK_MUX;
reg					ROM_WR_EN;
reg		[2:0]		USER_C;
//wire	[15:0]		APPLE_ADDRESS;
//wire				CLK_MOD;
reg		[12:0]		FLOPPY_BYTE;
reg		[4:0]		FLOPPY_CLK;
reg		[1:0]		STEPPER1;
reg		[1:0]		STEPPER2;
reg		[7:0]		TRACK1_NO;
reg		[7:0]		TRACK2_NO;
reg		[16:0]		TRACK1;
reg		[16:0]		TRACK2;
(*keep*)wire	[16:0]		TRACK;
wire	[16:0]		TRACK1_UP;
wire	[16:0]		TRACK1_DOWN;
wire	[16:0]		TRACK2_UP;
wire	[16:0]		TRACK2_DOWN;
//wire	[17:0]		FLOPPY_ADDRESS;
reg		[17:0]		FLOPPY_ADDRESS;
reg		[7:0]		FLOPPY_WRITE_DATA;
reg		[7:0]		LAST_WRITE_DATA;
(*keep*)wire	[7:0]		FLOPPY_RD_DATA;
(*keep*)wire	[7:0]		FLOPPY_DATA;
(*keep*)wire				FLOPPY_READ;
(*keep*)wire				FLOPPY_WRITE;
wire				FLOPPY_WP_READ;
wire				FLOPPY_VALID;
reg					PHASE0;
reg					PHASE0_1;
reg					PHASE0_2;
reg					PHASE1;
reg					PHASE1_1;
reg					PHASE1_2;
reg					PHASE2;
reg					PHASE2_1;
reg					PHASE2_2;
reg					PHASE3;
reg					PHASE3_1;
reg					PHASE3_2;
reg					DRIVE1;
reg					MOTOR;
reg					Q6;
reg					Q7;
wire				DRIVE1_EN;
wire				DRIVE2_EN;
wire				DRIVE1_X;
wire				DRIVE2_X;
wire				DRIVE_SWAP;
wire				DRIVE1_FLOPPY_WP;
wire				DRIVE2_FLOPPY_WP;

//	读取的 RAM 数据
reg		[7:0]		RAM_DATA0_FD;

reg					LC_BANK1;
reg					LC_BANK2;
reg					LC_BANK1_W;
reg					LC_BANK2_W;
reg					LC_BANK;
//reg		[4:0]		BANK;
//wire	[1:0]		BANK_ADDRESS;
reg					LC_WE;
//wire				APPLE_TXT_RAM;
//wire				APPLE_HR_RAM;
//wire				APPLE_LC_RAM;
//wire				APPLE_ZP_RAM;
//wire				APPLE_MAIN_RAM;
reg		[4:0]		JOY_TIMER;

// cassette

(*keep*)wire	[1:0]	CASS_OUT;
(*keep*)wire			CASS_IN;
(*keep*)wire			CASS_IN_L;
(*keep*)wire			CASS_IN_R;


wire				wr_o, rd_o;


reg		[7:0]		LATCHED_FLASH_BANK;

(*keep*)wire				VID_BUF_VRAM_FETCH_WAIT;
(*keep*)wire				VID_BUF_VRAM_CS;
wire	[7:0]		VID_BUF_VRAM_DATA;
wire	[15:0]		VID_BUF_VRAM_ADDR;

(*keep*)wire	[15:0]		VID_BUF_VID_ADDR;
(*keep*)wire	[7:0]		VID_BUF_VID_DATA;
(*keep*)wire				VID_BUF_VID_RD;


wire		[23:0]	UART_BUF_A;
wire				UART_BUF_WR;
wire		[7:0]	UART_BUF_DAT;


wire RAM_BE0_N_VID;
wire RAM_BE0_N_UART;
wire RAM_BE0_N_FD;
wire RAM_BE0_N_CPU;

wire RAM_BE1_N_VID;
wire RAM_BE1_N_UART;
wire RAM_BE1_N_FD;
wire RAM_BE1_N_CPU;

wire RAM_CS_N_VID;
wire RAM_CS_N_UART;
wire RAM_CS_N_FD;
wire RAM_CS_N_CPU;

wire	[17:0]	RAM_ADDRESS_VID;
wire	[17:0]	RAM_ADDRESS_UART;
wire	[17:0]	RAM_ADDRESS_FD;
wire	[17:0]	RAM_ADDRESS_CPU;

reg		[15:0]	RAM_DATA_W;

//(*preserve*)reg		[7:0]	LATCHED_RAM0_DATA;

`ifdef AUDIO_WM8731
wire	AUD_CTRL_CLK;
`endif

//	下面这几个信号都是用在RAM初始化
reg		[21:0]	FLASH_PORT_ADDR;
reg				FLASH_PORT_EN;
reg				RAM_PORT_EN;


//(*keep*)wire		trap;

//(*preserve*)reg		SIGNAL_CLOCK;

//assign	trap	=	(VID_BUF_VID_ADDR==16'h0400 && (~VGA_OUT_HS) && (~VGA_OUT_VS));
//assign	trap	=	(VID_BUF_VID_ADDR==16'h07D0 && VID_BUF_VID_RD);
//assign	trap	=	(RW_N&&(ADDRESS==16'hC0EC));
//assign	trap	=	~(FLOPPY_READ&&MOTOR);
//assign	trap	=	(RW_N&&(ADDRESS==16'h0800));
//assign	trap	=	(LATCHED_RAM0_DATA==8'h00);
assign	trap	=	(ADDRESS==16'h04E2);

`ifdef SIMULATE
//assign	P_SWITCH = 3'b000;
assign	P_SWITCH = 3'b111;

//assign	PADDLE = 4'b0000;
assign	PADDLE = 4'b1111;
`endif

assign FLASH_CE_N = 1'b0;
//assign FLASH_OE_N = 1'b0;
//assign FLASH_OE_N = 1'b1;
//assign FLASH_OE_N = PH_2;
assign FLASH_OE_N = FLASH_PORT_EN	?	1'b0	:	~RW_N;
assign FLASH_WE_N = 1'b1;

// de2
//assign FLASH_BYTE_N = 1'b0;
//assign FLASH_RESET_N = RESET_N;
//assign FLASH_RESET_N = 1'b1;
//assign led = FLASH_RY;
//assign FLASH_WP_N = 1'b0;


assign IRQ = 1'b1;
assign NMI = 1'b1;


`ifdef SKIP_BTN
assign	BUTTON		=	4'b0000;
`else
assign BUTTON		=	~BUTTON_N;
`endif

assign SYS_RESET_N = ~BUTTON[0];
//assign RESET_KEY_N = RESET_KEY_COUNT[16];

RESET_DE RESET_DE(
	.CLK(CLK50MHZ),			// 50MHz
	.SYS_RESET_N(SYS_RESET_N && RESET_KEY_N),
	.RESET_N(RESET_N),		// 50MHz/32/65536
	.RESET_AHEAD_N(FLASH_RESET_N)	// 提前恢复，可以接 FL_RESET_N
);

/*
assign SYS_RESET_N = !BUTTON[0];
assign RESET_KEY_N = RESET_KEY_COUNT[16];

assign RESET_N = SYS_RESET_N && RESET_KEY_N;

assign FLASH_RESET_N = SYS_RESET_N && (RESET_KEY_COUNT[16:15]!=2'b00);
*/

`ifdef SIMULATE
initial
	begin
		DIGIT_N = 4'b1110;
	end
`endif

always @ (posedge VGA_OUT_HS)					// Anything > 200 HZ
 case(DIGIT_N)
  4'b1110:	DIGIT_N <= 4'b1101;
  4'b1101:	DIGIT_N <= 4'b1011;
  4'b1011:	DIGIT_N <= 4'b0111;
  default:  DIGIT_N <= 4'b1110;
 endcase

assign SEGMENT_N =	(DIGIT_N == 4'b1110) ?	{RESET_N, 7'b0110000}:	//E
					(DIGIT_N == 4'b1101) ?	{RESET_N, 7'b0110001}:	//[
					(DIGIT_N == 4'b1011) ?	{RESET_N, 7'b0000111}:	//]
											{RESET_N, 7'b0001000};	//A
// LEDs
//
//	0	Floppy PH_3
//	1	Floppy PH_2
//	2	Floppy PH_1
//	3	Floppy PH_0
//	4	ROMs write enabled
//	5	Floppy drive 1 busy
//	6	Floppy drive 2 busy
//	7	Serial drive busy


//assign LED = {ADDRESS_CDEF|ADDRESS_89AB, ADDRESS_4567|ADDRESS_0123, A_KEY_PRESSED, CLK_1HZ, Q7, Q6, DRIVE_SWAP, DRIVE1, MOTOR, RESET_N};
//assign LED = { trap, OPEN_APL|CLOSED_APL|SHIFT_KEY, A_KEY_PRESSED, CLK_1HZ, Q7, Q6, DRIVE_SWAP, DRIVE1, MOTOR, RESET_N};
//assign LED = { trap, SHIFT_KEY, A_KEY_PRESSED, CLK_1HZ, Q7, Q6, DRIVE_SWAP, DRIVE1, MOTOR, RESET_N};
//assign LED = { trap, CAPS, A_KEY_PRESSED, CLK_1HZ, Q7, Q6, DRIVE_SWAP, DRIVE1, MOTOR, RESET_N};
//assign LED = { 1'b0, A_KEY_PRESSED, 4'b0, DRIVE1, MOTOR, CAPS, RESET_N};

//assign LED = { SIGNAL_CLOCK, A_KEY_PRESSED, 4'b0, DRIVE1, MOTOR, CAPS, RESET_N};

//assign LED = {SLOT_7IO, DRIVE2_X, DRIVE1_X, ROM_WR_EN, PHASE3, PHASE2, PHASE1, PHASE0};
//assign LED = {EN_ROM, A_KEY_PRESSED, DRIVE2_X, DRIVE1_X, PHASE3, PHASE2, PHASE1, PHASE0, 1'b1, 1'b1};
//assign LED = {EN_ROM, ADDRESS_DEF, ADDRESS_89AB, SLOTC3ROM, ALT_ZP, SLOTCXROM, ARAM_RD, ARAM_WR };
//assign LED = {EN_ROM, ADDRESS_DEF, ADDRESS_89AB, LC_BANK1, LC_BANK2, ALT_ZP, ARAM_RD, ARAM_WR };
//assign LED = {CPU_CLK, CLK_MOD, VGA_CLK, ROM_WR_EN, PHASE3, PHASE2, PHASE1, PHASE0};

assign LED = { A_KEY_PRESSED, 5'b0, DRIVE1, MOTOR, CAPS, RESET_N};

assign	VID_BUF_VRAM_DATA = RAM_DATA0[7:0];

/*****************************************************************
* Generates the Clocks from the 50 MHz clock
*
* VGA_CLK is 25 MHz (VGA pixel clock)
*
* SWITCH		1		0
* 				ON		ON			Stop
*				ON		OFF			CPU_CLK = 10 MHz
* 				OFF		ON			CPU_CLK = 2.083 MHz
* 				OFF		OFF			CPU_CLK = 1.042 MHz
******************************************************************/

`ifdef SIMULATE
initial
	begin
		VGA_CLK = 1'b0;
		CLK_CNT = 8'b0;
		COM1_CLK = 1'b0;
		COM1_CLOCK = 7'h00;
	end
`endif


`ifdef CLOCK_27MHZ

// 偶然发现，在一块 DE2 板子（VGA_ADV7123）上发现 VGA 时钟 25MHZ 会不稳定，而 27MHZ 显示正常。其它 DE2 板子正常。
// 官网的例子中，使用的是 27MHZ 时钟给 VGA 模块。

//VGA_Audio_PLL  VGA_AUDIO_PLL(.inclk0(CLK27MHZ),.c0(VGA_CLK),.c1(AUD_CTRL_CLK));

`ifdef AUDIO_WM8731
VGA_Audio_PLL  VGA_AUDIO_PLL(.inclk0(CLK27MHZ),.c0(),.c1(AUD_CTRL_CLK));
`endif

assign	VGA_CLK	=	CLK27MHZ;

`else

always @(negedge CLK50MHZ)
	VGA_CLK <= !VGA_CLK;

`endif

clock_gen	CLKGEN
(
	.CLK(CLK50MHZ),	// 50MHZ 60MHZ
	.CLK_5MHZ_TICK(),
	.CLK_1MHZ_TICK(),
	.CLK_1KHZ_TICK(),
	.CLK_1HZ_TICK(),
	.CLK_HALF(),
	.CLK_5MHZ(),
	.CLK_1MHZ(CLK_1MHZ),
	.CLK_1KHZ(CLK_1KHZ),
	.CLK_1HZ(CLK_1HZ)
);

// 下面这个状态机控制系统整体的进度。先响应视频模块读取SRAM的请求，然后处理其它内存请求。
// 视频模块：先从内存SRAM读取，再写入行缓冲区。
// SRAM ISSI IS61LV25616AL-10TL 读取需要 10ns

// 以下循环最小5个周期，是为了FLASH能完成读取

// 主状态机操作列表
// 00: CPU_CLK=0 RAM：VIDEO VRAM读取
// 01: CPU_CLK=0 RAM：准备 CPU 需要的数据
// 02: CPU_CLK=1 CPU 操作
// 03: CPU_CLK=0 RAM：CPU 信号线开始有效输出
// 04: CPU_CLK=0 RAM：UART 读写

// 05 --- 09: CPU_CLK=0 RAM：VIDEO VRAM读取
// 17 --- 2F: CPU_CLK=0

// 解决约束问题
reg		[8:0]	FLASH_PORT_ADDR_H_INC;
reg		[9:0]	FLASH_PORT_ADDR_L_INC;


// reset clock
always @(posedge CLK50MHZ)
begin
	RESET_CLK_CNT			<=	RESET_CLK_CNT + 1;
end

// system clock
always @(posedge CLK50MHZ or negedge RESET_N)
if(~RESET_N)
begin
		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	0;
		RAM_DATA_W		<=	16'b0;

		RAM_RDY_VID		<=	1'b0;
		RAM_CS_CPU		<=	1'b0;
		RAM_CS_FD_WR	<=	1'b0;
		RAM_RDY_UART	<=	1'b0;

		FLASH_PORT_EN	<=	1'b0;
		RAM_PORT_EN		<=	1'b0;

		//SIGNAL_CLOCK	<=	1'b0;

		CPU_CLK			<=	RESET_CLK_CNT[4];
		CPU_CLK_N		<=	~RESET_CLK_CNT[4];
		CLK_CNT			<=	8'hFE;

//		CPU_CLK			<=	1'b0;
//		CPU_CLK_N		<=	1'b1;
//		CLK_CNT			<=	(DRIVE_SWAP)?8'h70:8'h00;
//		CLK_CNT			<=	(DRIVE_SWAP)?8'h70:8'h30;
//		CLK_CNT			<=	8'h00;
//		CLK_CNT			<=	8'h30;
end
else
begin
	case (CLK_CNT[7:0])
	8'h00:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b0;
		RAM_CS_CPU		<=	1'b1;	// 当前周期操作

		RAM0_BE0_N		<=	RAM_BE0_N_CPU;
		RAM0_BE1_N		<=	RAM_BE1_N_CPU;
		RAM0_CS_N		<=	RAM_CS_N_CPU;
		//RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	RW_N;
		RAM_ADDRESS		<=	RAM_ADDRESS_CPU;
		//RAM_DATA_W		<=	{FLOPPY_WRITE_DATA[7:0], DATA_OUT[7:0]};
		RAM_DATA_W		<=	{8'b0, DATA_OUT[7:0]};

		//PH_2	<= 1'b1;
		CPU_CLK		<=	1'b0;
		CPU_CLK_N	<=	1'b1;
		CLK_CNT <= 8'h01;
	end

	8'h01:
	begin
		// 当前状态：RAM：准备 CPU 需要的数据
		RAM_CS_CPU		<=	1'b0;

		RAM_CS_FD_WR	<=	1'b1;	// 当前周期操作


/*
		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
*/

		RAM0_BE0_N		<=	RAM_BE0_N_FD;
		RAM0_BE1_N		<=	RAM_BE1_N_FD;
		//RAM0_CS_N		<=	~FLOPPY_WRITE;
		RAM0_CS_N		<=	1'b0;
		RAM_RW_N		<=	~FLOPPY_WRITE;
		RAM_ADDRESS		<=	RAM_ADDRESS_FD;
		//RAM_DATA_W		<=	{FLOPPY_WRITE_DATA[7:0], DATA_OUT[7:0]};
		RAM_DATA_W		<=	{FLOPPY_WRITE_DATA[7:0], 8'b0};

		//PH_2	<= 1'b0;
		CPU_CLK		<=	1'b1;
		CPU_CLK_N	<=	1'b0;
		CLK_CNT <= 8'h02;
	end

	8'h02:
	begin
		// CPU_CLK : 拉高

		// 当前状态：*** CPU 操作 （CPU 锁存信号线数据）***
		// 当前状态：*** CPU 信号线开始输出 ***

		// 软盘控制器数据写入或读取RAM
		RAM_CS_CPU		<=	1'b0;
		RAM_CS_FD_WR	<=	1'b0;

		RAM_RDY_UART	<=	1'b1;	// 可以下个周期操作

		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;

		RAM_ADDRESS		<=	18'b0;
		RAM_DATA_W		<=	16'b0;

		RAM_DATA0_FD	<=	RAM_DATA0[15:8];
		//LATCHED_RAM0_DATA	<=	(RAM0_BE0_N) ? RAM_DATA0[15:8]:RAM_DATA0[7:0];


		//PH_2	<= 1'b1;
		CPU_CLK		<=	1'b0;
		CPU_CLK_N	<=	1'b1;
		CLK_CNT <= 8'h03;
	end


	8'h03:
	begin
		// CPU_CLK : 拉低

		// 当前状态：*** CPU 信号线开始有效输出 ***
		// 软开关开始有效输出
		RAM_CS_CPU		<=	1'b0;

		// 锁存读入的软盘数据 RAM_DATA0_FD

		// RAM：FLOPPY 写入操作
		RAM_CS_FD_WR	<=	1'b0;
		RAM_RDY_UART	<=	1'b0;

		RAM_RDY_VID		<=	1'b1;	// 可以下个周期操作  CLK_CNT==8'h00 或 CLK_CNT==8'h05 操作

/*
		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
*/


		RAM0_BE0_N		<=	RAM_BE0_N_UART;
		RAM0_BE1_N		<=	RAM_BE1_N_UART;
		//RAM0_CS_N		<=	~UART_BUF_WAIT;
		//RAM_RW_N		<=	~UART_BUF_WAIT;		// UART数据写入RAM
		RAM0_CS_N		<=	~UART_BUF_CS;
		RAM_RW_N		<=	~UART_BUF_WR;		// UART数据写入RAM
		RAM_ADDRESS		<=	RAM_ADDRESS_UART;
		RAM_DATA_W		<=	{UART_BUF_DAT,8'b0};

		//SIGNAL_CLOCK	<=	1'b0;

		//PH_2	<= 1'b0;
		//CPU_CLK	<=	1'b0;
		//CPU_CLK_N	<=	1'b1;
		CLK_CNT <= 8'h04;
	end

	8'h04:
	begin
		// 当前状态：RAM：UART 读写
		RAM_CS_CPU		<=	1'b0;

		RAM0_BE0_N		<=	RAM_BE0_N_VID;
		RAM0_BE1_N		<=	RAM_BE1_N_VID;
		RAM0_CS_N		<=	~VID_BUF_VRAM_FETCH_WAIT;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	RAM_ADDRESS_VID;
		RAM_DATA_W		<=	16'b0;
		
		//SIGNAL_CLOCK	<=	~RAM_RW_N;

		//PH_2	<= 1'b0;
		//CPU_CLK	<=	1'b0;
		//CPU_CLK_N	<=	1'b1;
		if(SWITCH[1:0] == 2'b10)
		begin
			RAM_RDY_VID		<=	1'b0;
			CLK_CNT <= 8'h00;
		end
		else
		begin
			RAM_RDY_VID		<=	1'b1;	// 可以下个周期操作 CLK_CNT==8'h06 开始操作，一直到 CLK_CNT==8'h09
			CLK_CNT <= 8'h05;
		end
	end

	8'h05:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b1;

		RAM0_BE0_N		<=	RAM_BE0_N_VID;
		RAM0_BE1_N		<=	RAM_BE1_N_VID;
		RAM0_CS_N		<=	~VID_BUF_VRAM_FETCH_WAIT;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	RAM_ADDRESS_VID;
		RAM_DATA_W		<=	16'b0;
		//RAM_DATA0

		CLK_CNT <= 8'h06;
	end

	8'h06:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b1;

		RAM0_BE0_N		<=	RAM_BE0_N_VID;
		RAM0_BE1_N		<=	RAM_BE1_N_VID;
		RAM0_CS_N		<=	~VID_BUF_VRAM_FETCH_WAIT;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	RAM_ADDRESS_VID;
		//RAM_DATA0

		CLK_CNT <= 8'h07;
	end

	8'h07:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b1;

		RAM0_BE0_N		<=	RAM_BE0_N_VID;
		RAM0_BE1_N		<=	RAM_BE1_N_VID;
		RAM0_CS_N		<=	~VID_BUF_VRAM_FETCH_WAIT;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	RAM_ADDRESS_VID;
		//RAM_DATA0

		CLK_CNT <= 8'h08;
	end

	8'h08:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b0;

		RAM0_BE0_N		<=	RAM_BE0_N_VID;
		RAM0_BE1_N		<=	RAM_BE1_N_VID;
		RAM0_CS_N		<=	~VID_BUF_VRAM_FETCH_WAIT;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	RAM_ADDRESS_VID;
		//RAM_DATA0

		CLK_CNT <= 8'h09;
	end

	8'h09:
	begin
		// 当前状态：RAM：VIDEO VRAM读取
		RAM_RDY_VID		<=	1'b0;

		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
		//RAM_ADDRESS	<=	18'b0;
		//RAM_DATA0

		CLK_CNT <= 8'h0A;
	end

	8'h17:
	begin
		if(SWITCH[1:0] == 2'b01)
			CLK_CNT <= 8'h00;
		else
			CLK_CNT <= 8'h18;
	end

	8'h2F:
	begin
		if(SWITCH[1:0] == 2'b00)
			CLK_CNT <= 8'h00;
		else
			CLK_CNT <= 8'hFF;
	end

	// 清除内存
	8'h30:
	begin
		//RAM_ADDRESS		<=	18'h003F3;
		RAM0_BE0_N		<=	1'b0;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b0;
		RAM_RW_N		<=	1'b0;
		RAM_ADDRESS		<=	18'h00000;
		RAM_DATA_W		<=	16'b0;

		CLK_CNT <= 8'h31;
	end

	8'h31:
	begin
		//RAM0_BE0_N		<=	1'b0;
		//RAM0_BE1_N		<=	1'b1;
		//RAM0_CS_N		<=	1'b0;
		//RAM_RW_N		<=	1'b0;
		RAM_ADDRESS		<=	{2'b0,{RAM_ADDRESS[15:0]}+1};
		//RAM_DATA_W		<=	16'b0;

		if(RAM_ADDRESS[15:0]==16'hffff)
			CLK_CNT <= 8'h32;
	end

	8'h32:
	begin
		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
		//RAM_ADDRESS		<=	18'h00000;
		//RAM_DATA_W		<=	16'b0;

		CLK_CNT			<=	(DRIVE_SWAP)?8'h70:8'h00;
	end

	// 读入 FLASH 内容到 RAM
	// 测试
	8'h70:
	begin
		FLASH_PORT_EN	<=	1'b1;
		if(SWITCH[5])
			FLASH_PORT_ADDR	<=	22'H3C0000;		// LodeRunner.nib
		else
			FLASH_PORT_ADDR	<=	22'H380000;		// DOS.nib
		RAM_PORT_EN		<=	1'b0;

		CLK_CNT <= 8'h71;
	end


	8'h78:
	begin
		RAM_PORT_EN		<=	1'b1;

		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b0;
		RAM0_CS_N		<=	1'b0;
		RAM_RW_N		<=	1'b0;
		RAM_ADDRESS		<=	FLASH_PORT_ADDR[17:0];
		RAM_DATA_W		<=	{FLASH_DATA,8'b0};

		FLASH_PORT_ADDR_H_INC[8:0]	<=	 9'd1 + FLASH_PORT_ADDR[17:9];
		FLASH_PORT_ADDR_L_INC[9:0]	<=	10'd1 + FLASH_PORT_ADDR[ 8:0];

		CLK_CNT <= 8'h79;
	end

	8'h79:
	begin
		// 当前状态：写入 RAM
		RAM_PORT_EN		<=	1'b0;

		RAM0_BE0_N		<=	1'b1;
		RAM0_BE1_N		<=	1'b1;
		RAM0_CS_N		<=	1'b1;
		RAM_RW_N		<=	1'b1;
		RAM_ADDRESS		<=	0;

		//FLASH_PORT_ADDR[17:0]	<=	FLASH_PORT_ADDR[17:0] + 1;
		FLASH_PORT_ADDR[17:0]	<=	{ FLASH_PORT_ADDR_L_INC[9]?FLASH_PORT_ADDR_H_INC:FLASH_PORT_ADDR[17:9], FLASH_PORT_ADDR_L_INC[8:0] };

		if(FLASH_PORT_ADDR[17:0]==18'h3FFFF)
		begin
			FLASH_PORT_EN	<=	1'b0;
			CLK_CNT <= 8'h7A;
		end
		else
		begin
			FLASH_PORT_EN	<=	1'b1;
			CLK_CNT <= 8'h71;
		end
	end

	8'h7F:
	begin
		CLK_CNT <= 8'h00;
	end

	8'hFE:
	begin
		CPU_CLK		<=	1'b0;
		CPU_CLK_N	<=	1'b1;
		if(RESET_CLK_CNT==5'b11111)
			CLK_CNT <= 8'h30;
//			CLK_CNT <= 8'h00;
	end

/*
	8'hFF:
	begin
		if(SWITCH[1:0] == 2'b11)
			CLK_CNT <= 8'hFF;
		else
			CLK_CNT <= 8'h00;
	end
*/
	default:
	begin
		CLK_CNT <= CLK_CNT + 1'b1;
	end
	endcase
end

always @(posedge CLK50MHZ)
	begin
		case (COM1_CLOCK)
		7'h00:
		begin
			COM1_CLK <= !COM1_CLK;
			COM1_CLOCK <= 7'h01;
		end
		7'h1A:											// 50/(27*2) = 925925.93 921600/16 = 57600
		begin
			if(!SWITCH[5])
				COM1_CLOCK <= 7'h00;
			else
				COM1_CLOCK <= 7'h1B;
		end
		7'h51:											// 50/(82*2) = 304878.05 307200/16 = 19200
		begin
				COM1_CLOCK <= 7'h00;
		end
		default:
			COM1_CLOCK <= COM1_CLOCK + 1'b1;
		endcase
	end

/*****************************************************************************
* 6502 Processor
******************************************************************************/

// apple2fpga 1.2 cpu6502
// 可以正常工作，读取软盘

assign RW_N = ~wr_o;

cpu65xx
#(
.pipelineOpcode("false"),
.pipelineAluMux("false"),
.pipelineAluOut("false")
)
CPU6502(
	.clk(CPU_CLK),
	.enable(1'b1),
	.reset(~RESET_N),
	.nmi_n(1'b1),
	.irq_n(1'b1),
	.so_n(1'b1),

	.di(DATA_IN),
	.do(DATA_OUT),
	.addr(ADDRESS),
	.we(wr_o),

	.debugOpcode(),
	.debugPc(),
	.debugA(),
	.debugX(),
	.debugY(),
	.debugS()
);


/*****************************************************************************
* Enables for internal memory
******************************************************************************/

assign ADDRESS_0123 = (ADDRESS[15:14] == 2'b00)?1'b1:1'b0;
assign ADDRESS_4567 = (ADDRESS[15:14] == 2'b01)?1'b1:1'b0;
assign ADDRESS_89AB = (ADDRESS[15:14] == 2'b10)?1'b1:1'b0;
assign ADDRESS_CDEF = (ADDRESS[15:14] == 2'b11)?1'b1:1'b0;
assign ADDRESS_DEF	= (ADDRESS[15:12] == 4'hF) ? 1'b1 : (ADDRESS[15:12] == 4'hE) ? 1'b1 : (ADDRESS[15:12] == 4'hD) ? 1'b1 : 1'b0;
assign ADDRESS_CX	= (ADDRESS[15:12] == 4'hC) ? (ADDRESS[11:8] == 4'h0) ? 1'b0 : 1'b1 : 1'b0;
//assign ADDRESS_TXT	= (ADDRESS[15:10] == 6'b0000_01)?1'b1:1'b0;
//assign ADDRESS_HR	= (ADDRESS[15:13] == 3'b001)?1'b1:1'b0;


// C100 - C7FF Slot ROMs
assign ENA_C0S =		({SLOTCXROM, ADDRESS[15:8]} == 9'h0C1)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h0C2)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h0C4)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h0C5)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h0C6)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h0C7)						?	1'b1:
																									1'b0;

assign ENA_C3S =		({SLOTC3ROM, SLOTCXROM, ADDRESS[15:8]} == 10'h2C3)						?	1'b1:1'b0;

// C100 - CFFF Internal ROM
assign ENA_C0I =		( ADDRESS_CX && ( SLOTCXROM || {SLOTC3ROM, ADDRESS[11:8]} == 5'h03 ) ) ? 1'b1 : 1'b0;

/*
assign ENA_C0I =		({SLOTCXROM, ADDRESS[15:8]} == 9'h1C1)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C2)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C3)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C4)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C5)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C6)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C7)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C8)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1C9)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CA)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CB)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CC)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CD)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CE)						?	1'b1:
						({SLOTCXROM, ADDRESS[15:8]} == 9'h1CF)						?	1'b1:
																									1'b0;
*/

assign EN_ROM	=		(ARAM_RD && (ADDRESS_4567||ADDRESS_89AB))
//						|| (ADDRESS_DEF && ALT_ZP && !LC_WE && (LC_BANK1||LC_BANK2))
						|| (ADDRESS_DEF && ALT_ZP && (LC_BANK1||LC_BANK2))
						|| (ADDRESS_DEF && ({LC_BANK1, LC_BANK2} == 2'b00))
						|| ENA_C0I || ENA_C3S
						|| ENA_C0S ? 1'b1: 1'b0;

/*
1'b0,ADDRESS[0],CEC_C0B0[3:0],ADDRESS[13:1] // 4 5 6 7 字库 字节内容逆序
3'b100,~CEC_C0B0[5],1'b0,ADDRESS[13:0] // 8 9 a b 码表  Q6 = 0 U35  Q6 = 1 U7
3'b100,1'b0,1'b1,ADDRESS[13:0] // d e f 系统 U7
3'b100,1'b1,1'b1,ADDRESS[13:0] // d e f 汉字 U35
3'b100,1'b1,1'b1,ADDRESS[13:0] // C0I  U35 4300 43FF 汉字
3'b100,1'b1,1'b1,ADDRESS[13:0] // C0I  U35 4600 46FF 汉字
*/

// 字库 ARAM_RD ADDRESS_4567
// 码表 ARAM_RD ADDRESS_89AB
// 汉字处理程序  ALT_ZP ADDRESS_DEF !LC_WE LC_BANK1|LC_BANK2
// 系统ROM  {LC_BANK1, LC_BANK2} == 2'b0

// U7   2'b100,1'b0
// U35  2'b100,1'b1
// ENA_C3I

//nor在存储半字数据的时候高8位于低8位互换
//assign FL_ADDRESS[21:0] = {FLASH_ADDRESS[21:1],~FLASH_ADDRESS[0]};
//assign FL_ADDRESS[21:0] = {5'h04, 16'h7FFC, 1'b0};
//assign FL_ADDRESS[21:0] = {18'b0,ADDRESS[3:0]};

assign FL_ADDRESS[21:0] =		FLASH_PORT_EN									?	FLASH_PORT_ADDR		:	{FLASH_ADDRESS[21:0]}	;

assign FLASH_ADDRESS[21:19]	=	LATCHED_FLASH_BANK[2:0];
assign FLASH_ADDRESS[18:0]	=
	(ARAM_RD && ADDRESS_4567)													?	{1'b0,ADDRESS[0],CEC_C0B0[3:0],ADDRESS[13:1]}	:
	(ARAM_RD && ADDRESS_89AB)													?	{3'b100,~CEC_C0B0[5],1'b0,ADDRESS[13:0]}		:
	//	( (ALT_ZP && ADDRESS_DEF && (!LC_WE) && (LC_BANK1||LC_BANK2) ) || ENA_C0S || ENA_C3S )	?	{3'b100,1'b1,1'b1,ADDRESS[13:0]}	:
	( (ALT_ZP && ADDRESS_DEF && (LC_BANK1||LC_BANK2) ) || ENA_C0S || ENA_C3S )	?	{3'b100,1'b1,1'b1,ADDRESS[13:0]}				:
																					{3'b100,1'b0,1'b1,ADDRESS[13:0]}				;
//                               : ( (ALT_ZP && ADDRESS_DEF && !LC_WE && (LC_BANK1||LC_BANK2) ) || ENA_C0S ) ? {3'b100,1'b1,1'b1,ADDRESS[13:0]}
//                                                                                                          : ( ({LC_BANK1, LC_BANK2} == 2'b00) && ADDRESS_DEF || ENA_C0I ) ?  {3'b100,1'b0,1'b1,ADDRESS[13:0]} : 19'bz;


// C060 Text Color and ROM write enable
// Write a color value into this location to change text screen color
// This also write enables the ROMs
// Color =
// read from this location to write protect the ROMs
always @ (posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		ROM_WR_EN <= 1'b0;
		USER_C <= 3'd2;
	end
	else
		case ({RW_N, ADDRESS})
			17'H0C060:
			begin
				USER_C <= DATA_OUT[2:0];		// Set user Color
//				ROM_WR_EN <= 1'b1;				// Apple write protect ROM
			end
			17'H0C070:	DTOA_CODE <= DATA_OUT[7:0];
//			17'H1C060:	ROM_WR_EN <= 1'b0;				// Apple write protect ROM
		endcase
end


always @ (posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		CEC_C0B0 <= 8'b0;
	end
	else
		case ({RW_N, ADDRESS})
			17'H0C0B0:
				CEC_C0B0 <= DATA_OUT;
		endcase
end


/*****************************************************************************
* Apple Memory Enables
*****************************************************************************/

assign APPLE_C0	= (ADDRESS[15:7]	== 9'b110000000)							?	1'b1:
																									1'b0;

assign SLOT_3IO	= (ADDRESS[15:4]	== 12'hC0B)									?	1'b1:
																									1'b0;

assign SLOT_4IO	= (ADDRESS[15:4]	== 12'hC0C)									?	1'b1:
																									1'b0;

assign SLOT_6IO	= (ADDRESS[15:4]	== 12'hC0E)									?	1'b1:
																									1'b0;

assign SLOT_7IO	= (ADDRESS[15:4]	== 12'hC0F)									?	1'b1:
																									1'b0;

/*****************************************************************************
* Most of the standard 2E mode selection bits
******************************************************************************/

assign OPEN_APL =			L_ALT				// Left ALT key decoded
						| 	!P_SWITCH[0]		// Paddle button 0
						|	BUTTON[1];			// Push button 0
//						|	BUTTON[0];			// Push button 0

assign CLOSED_APL =	 		R_ALT				// Right ALT key decoded
						|	!P_SWITCH[1]		// Paddle button 1
						|	BUTTON[2];			// Push button 1
//						|	BUTTON[1];			// Push button 1

assign SHIFT_KEY	=		L_SHIFT
						|	R_SHIFT
//						|	CAPS					//AppleWin does not have this
						|	!P_SWITCH[2]
						|	BUTTON[3];
//						|	BUTTON[2];

assign APPLE_STATUS_BIT =			({APPLE_C0, ADDRESS[7:0]} == 9'h100)	?	APPLE_PRESSED:
									({APPLE_C0, ADDRESS[7:0]} == 9'h110)	?	A_KEY_PRESSED:
									({APPLE_C0, ADDRESS[7:0]} == 9'h111)	?	LC_BANK:
									({APPLE_C0, ADDRESS[7:0]} == 9'h112)	?	(LC_BANK1 | LC_BANK2):
									({APPLE_C0, ADDRESS[7:0]} == 9'h113)	?	ARAM_RD:
									({APPLE_C0, ADDRESS[7:0]} == 9'h114)	?	ARAM_WR:
									({APPLE_C0, ADDRESS[7:0]} == 9'h115)	?	SLOTCXROM:
									({APPLE_C0, ADDRESS[7:0]} == 9'h116)	?	ALT_ZP:
									({APPLE_C0, ADDRESS[7:0]} == 9'h117)	?	SLOTC3ROM:
									({APPLE_C0, ADDRESS[7:0]} == 9'h118)	?	STORE_80:
									({APPLE_C0, ADDRESS[7:0]} == 9'h119)	?	V_BLANKING:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11A)	?	TEXT:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11B)	?	MIXED:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11C)	?	SECONDARY:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11D)	?	HGR:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11E)	?	ALT_CHAR:
									({APPLE_C0, ADDRESS[7:0]} == 9'h11F)	?	TEXT_80:
//									({APPLE_C0, ADDRESS[7:0]} == 9'h160)	?	P_SWITCH[2]:
									({APPLE_C0, ADDRESS[7:0]} == 9'h161)	?	OPEN_APL:
									({APPLE_C0, ADDRESS[7:0]} == 9'h162)	?	CLOSED_APL:
									({APPLE_C0, ADDRESS[7:0]} == 9'h163)	?	SHIFT_KEY:
									({APPLE_C0, ADDRESS[7:0]} == 9'h164)	?	!PADDLE[0]:
									({APPLE_C0, ADDRESS[7:0]} == 9'h165)	?	!PADDLE[1]:
									({APPLE_C0, ADDRESS[7:0]} == 9'h166)	?	!PADDLE[2]:
									({APPLE_C0, ADDRESS[7:0]} == 9'h167)	?	!PADDLE[3]:
									({APPLE_C0, ADDRESS[7:0]} == 9'h17F)	?	DHRES:
																				1'b1;

always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		TEXT_80 <= 1'b0;
		ALT_CHAR <= 1'b0;
		TEXT	<= 1'b1;
		MIXED <= 1'b0;
		SECONDARY <= 1'b0;
		DHRES <= 1'b0;
		HGR <= 1'b0;
		SPEAKER <= 1'b0;
		STORE_80 <= 1'b0;
		ARAM_RD <= 1'b0;
		ARAM_WR <= 1'b0;
		SLOTCXROM <= 1'b0;
		ALT_ZP <= 1'b0;
`ifdef SIMULATE
//		SLOTC3ROM <= 1'b1;
		SLOTC3ROM <= 1'b0;
`else
		SLOTC3ROM <= 1'b0;
`endif
		// 复位期间设置，避免拨动开关引起错误
		LATCHED_FLASH_BANK		<=	{4'b0,SWITCH[9:6]} + 2;		//	+2 跳过 1024KB 的 LASER310 数据区
	end
	else
	begin
			if(~RW_N)
			begin
				case({APPLE_C0, ADDRESS[7:0]})
				9'h100:		STORE_80 <= 1'b0;	// 只有写操作
				9'h101:		STORE_80 <= 1'b1;	// 只有写操作
				9'h102:		ARAM_RD <= 1'b0;
				9'h103:		ARAM_RD <= 1'b1;
				9'h104:		ARAM_WR <= 1'b0;
				9'h105:		ARAM_WR <= 1'b1;
				9'h106:		SLOTCXROM <= 1'b0;
				9'h107:		SLOTCXROM <= 1'b1;
				9'h108:		ALT_ZP <= 1'b0;
				9'h109:		ALT_ZP <= 1'b1;
				9'h10A:		SLOTC3ROM <= 1'b0;
				9'h10B:		SLOTC3ROM <= 1'b1;
				9'h10C:		TEXT_80 <= 1'b0;			// Text 40 Mode // 只有写操作
				9'h10D:		TEXT_80 <= 1'b1;			// Text 80 Mode // 只有写操作
				9'h10E:		ALT_CHAR <= 1'b0;			// Text 40 Mode // 只有写操作
				9'h10F:		ALT_CHAR <= 1'b1;			// Text 80 Mode // 只有写操作
				9'h150:		TEXT <= 1'b0;			// Set Graphics Mode
				9'h151:		TEXT <= 1'b1;			// Set Text Mode
				9'h152:		MIXED <= 1'b0;			// Set Full Screen Graphics Mode
				9'h153:		MIXED <= 1'b1;			//	Set Mixed-Screen Graphics Mode
				9'h154:		SECONDARY <= 1'b0;	//	Set HI-RES Page 2 off
				9'h155:		SECONDARY <= 1'b1;	//	Set HI-RES Page 2 on
				9'h156:		HGR <= 1'b0;			//	Set HI-RES mode off
				9'h157:		HGR <= 1'b1;			//	Set HI-RES mode on
				9'h15E:		DHRES <= 1'b1;					// Clear Game I/O AN-3 output = 1
				9'h15F:		DHRES <= 1'b0;					// Set Game I/O AN-3 output = 0
				endcase
			end
			else
			begin
				case({APPLE_C0, ADDRESS[7:0]})
				9'h102:		ARAM_RD <= 1'b0;
				9'h103:		ARAM_RD <= 1'b1;
				9'h104:		ARAM_WR <= 1'b0;
				9'h105:		ARAM_WR <= 1'b1;
				9'h106:		SLOTCXROM <= 1'b0;
				9'h107:		SLOTCXROM <= 1'b1;
				9'h108:		ALT_ZP <= 1'b0;
				9'h109:		ALT_ZP <= 1'b1;
				9'h10A:		SLOTC3ROM <= 1'b0;
				9'h10B:		SLOTC3ROM <= 1'b1;

				9'h130:		SPEAKER <= ~SPEAKER;
				9'h150:		TEXT <= 1'b0;			// Set Graphics Mode
				9'h151:		TEXT <= 1'b1;			// Set Text Mode
				9'h152:		MIXED <= 1'b0;			// Set Full Screen Graphics Mode
				9'h153:		MIXED <= 1'b1;			//	Set Mixed-Screen Graphics Mode
				9'h154:		SECONDARY <= 1'b0;	//	Set HI-RES Page 2 off
				9'h155:		SECONDARY <= 1'b1;	//	Set HI-RES Page 2 on
				9'h156:		HGR <= 1'b0;			//	Set HI-RES mode off
				9'h157:		HGR <= 1'b1;			//	Set HI-RES mode on
				9'h15E:		DHRES <= 1'b1;					// Clear Game I/O AN-3 output = 1
				9'h15F:		DHRES <= 1'b0;					// Set Game I/O AN-3 output = 0
				endcase
			end
	end
end

/*****************************************************************************
* RAM Drive card 384k
*
* Looks like RAMWorks III card with 1 Bank of 256K
* and 3 more banks of 64K
******************************************************************************/

/*

always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
		BANK <= 5'b00000;
	else
		if({RW_N, ADDRESS[15:0]} == 17'h0C073)
			BANK <= {(DATA_OUT[7]|DATA_OUT[6]|DATA_OUT[5]|DATA_OUT[4]),DATA_OUT[3:0]};
end

*/

/*****************************************************************************
* Joystick interface
* Replace charging cap with R-2R Ladder Digital to Analog Converter
* The original timing would change digital values every 11 clock cycles
* Calculated 13.5 uS with our circuit
* Since our circuit is different count starts at 28
******************************************************************************/
assign PADDLE_RESET = ({RW_N, ADDRESS[15:0]} == 17'h1C070)			?	1'b0:
																							1'b1;

`ifdef SIMULATE
initial
	begin
		DTOA_CODE = 8'h00;
	end
`endif

parameter	OFFSET =	8'hB8;
parameter	RANGE  =	5'h12;

always @(posedge CPU_CLK or negedge PADDLE_RESET)
	if(!PADDLE_RESET)
		JOY_TIMER <= 5'b00000;
	else
		case (JOY_TIMER)
			RANGE:
				JOY_TIMER <= 5'b00000;
			default:
				JOY_TIMER <= JOY_TIMER + 1'b1;
		endcase

always @(negedge JOY_TIMER[4] or negedge PADDLE_RESET)
begin
	if(!PADDLE_RESET)
		DTOA_CODE <= OFFSET;
	else
		case(DTOA_CODE)
		8'h00:	DTOA_CODE <= 8'h00;
		default:	DTOA_CODE <= DTOA_CODE - 1'b1;
		endcase
end

/*****************************************************************************
* Language Card Memory
*
*           $C080 ;LC RAM bank2, Read and WR-protect RAM
*ROMIN =    $C081 ;LC RAM bank2, Read ROM instead of RAM,
*                 ;two or more successive reads WR-enables RAM
*           $C082 ;LC RAM bank2, Read ROM instead of RAM,
*                 ;WR-protect RAM
*LCBANK2 =  $C083 ;LC RAM bank2, Read RAM
*                 ;two or more successive reads WR-enables RAM
*           $C088 ;LC RAM bank1, Read and WR-protect RAM
*           $C089 ;LC RAM bank1, Read ROM instead of RAM,
*                 ;two or more successive reads WR-enables RAM
*           $C08A ;LC RAM bank1, Read ROM instead of RAM,
*                 ;WR-protect RAM
*LCBANK1 =  $C08B ;LC RAM bank1, Read RAM
*                 ;two or more successive reads WR-enables RAM
*           $C084-$C087 are echoes of $C080-$C083
*           $C08C-$C08F are echoes of $C088-$C08B
*
******************************************************************************/

always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		LC_BANK1 <= 1'b0;
		LC_BANK2 <= 1'b0;
		LC_BANK1_W <= 1'b0;
		LC_BANK2_W <= 1'b0;
		LC_BANK	<= 1'b0;
		LC_WE <= 1'b0;
	end
	else
	begin
		case(ADDRESS[15:0])
		16'hC080:							// Read RAM bank 2 no write
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b1;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b0;
		end
		16'hC081:							// Read ROM write RAM bank 2 (RR)
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= LC_WE | !RW_N;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b1;
		end
		16'hC082:							// Read ROM no write
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b0;
		end
		16'hC083:							// Read bank 2 write bank 2(RR)
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b1;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= LC_WE | !RW_N;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b1;
		end
		16'hC084:							// Read bank 2 no write
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b1;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b0;
		end
		16'hC085:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= LC_WE | !RW_N;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b1;
		end
		16'hC086:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b0;
		end
		16'hC087:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b1;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= LC_WE | !RW_N;
			LC_BANK	<= 1'b1;
			LC_WE <= 1'b1;
		end
		16'hC088:
		begin
			LC_BANK1 <= 1'b1;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b0;
		end
		16'hC089:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= LC_WE | !RW_N;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b1;
		end
		16'hC08A:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b0;
		end
		16'hC08B:
		begin
			LC_BANK1 <= 1'b1;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= LC_WE | !RW_N;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b1;
		end
		16'hC08C:
		begin
			LC_BANK1 <= 1'b1;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b0;
		end
		16'hC08D:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= LC_WE | !RW_N;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b1;
		end
		16'hC08E:
		begin
			LC_BANK1 <= 1'b0;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= 1'b0;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b0;
		end
		16'hC08F:
		begin
			LC_BANK1 <= 1'b1;
			LC_BANK2 <= 1'b0;
			LC_BANK1_W <= LC_WE | !RW_N;
			LC_BANK2_W <= 1'b0;
			LC_BANK	<= 1'b0;
			LC_WE <= 1'b1;
		end
		endcase
	end
end

/*****************************************************************************
* Data bus mux
******************************************************************************/
/*
assign DATA_IN	=	(EN_ROM)		?	(ADDRESS_4567?{FLASH_DATA[0],FLASH_DATA[1],FLASH_DATA[2],FLASH_DATA[3],FLASH_DATA[4],FLASH_DATA[5],FLASH_DATA[6],FLASH_DATA[7]}:FLASH_DATA):
					(APPLE_C0)		?	{APPLE_STATUS_BIT, ASCII}	:
					(SLOT_4IO)		?	CLK_IN						:
					(SLOT_7IO)		?	DATA_COM1					:
					(SLOT_6IO)		?	FLOPPY_DATA					:
					(!RAM0_BE0_N)	?	RAM_DATA0[7:0]				:
					(!RAM0_BE1_N)	?	RAM_DATA0[15:8]				:
										8'h00						;
*/

assign DATA_IN	=	(EN_ROM)		?	(ADDRESS_4567?{FLASH_DATA[0],FLASH_DATA[1],FLASH_DATA[2],FLASH_DATA[3],FLASH_DATA[4],FLASH_DATA[5],FLASH_DATA[6],FLASH_DATA[7]}:FLASH_DATA):
					(APPLE_C0)		?	{APPLE_STATUS_BIT, ASCII}	:
//					(SLOT_4IO)		?	CLK_IN						:
//					(SLOT_7IO)		?	DATA_COM1					:
					(SLOT_6IO)		?	FLOPPY_DATA					:
					(RAM_BE0_N_CPU)	?	8'h00	:	RAM_DATA0[7:0]	;
//					(!RAM0_BE0_N)	?	RAM_DATA0[7:0]				:
//					(!RAM0_BE1_N)	?	RAM_DATA0[15:8]				:
//										8'h00						;

/*****************************************************************************
* 32 Bit output data to external RAM
******************************************************************************/

/*
assign	RAM_DATA0	=	RAM_PORT_EN	?	{FLASH_DATA, 8'bz}	:
						RAM_RW_N	?	16'bZ				:
										{ (UART_BUF_WR?UART_BUF_DAT[7:0]:FLOPPY_WRITE_DATA[7:0]), DATA_OUT[7:0] };
*/

/*
assign	RAM_DATA0	=	RAM_PORT_EN	?	{FLASH_DATA, 8'bz}	:
						RAM_RW_N	?	16'bZ				:
										{ (UART_BUF_WR?UART_BUF_DAT[7:0]:FLOPPY_WRITE_DATA[7:0]), DATA_OUT[7:0] };
*/

assign	RAM_DATA0	=	RAM_RW_N	?	16'bZ	:	RAM_DATA_W;

/*****************************************************************************
* Other external RAM signals
******************************************************************************/
/*
assign APPLE_MAIN_RAM	=	({APPLE_ZP_RAM, APPLE_TXT_RAM, ADDRESS[15:12]} == 6'h00)	?	1'b1:
									(ADDRESS[15:12] == 4'h1)											?	1'b1:
									({APPLE_HR_RAM, ADDRESS[15:12]} == 5'h02)						?	1'b1:
									({APPLE_HR_RAM, ADDRESS[15:12]} == 5'h03)						?	1'b1:
									(ADDRESS[15:12] == 4'h4)											?	1'b1:
									(ADDRESS[15:12] == 4'h5)											?	1'b1:
									(ADDRESS[15:12] == 4'h6)											?	1'b1:
									(ADDRESS[15:12] == 4'h7)											?	1'b1:
									(ADDRESS[15:12] == 4'h8)											?	1'b1:
									(ADDRESS[15:12] == 4'h9)											?	1'b1:
									(ADDRESS[15:12] == 4'hA)											?	1'b1:
									(ADDRESS[15:12] == 4'hB)											?	1'b1:
																													1'b0;

assign APPLE_ZP_RAM		=	(ADDRESS[15:8] == 8'h00)											?	1'b1:				// 0000 - 00FF
									(ADDRESS[15:8]	== 8'h01)											?	1'b1:				// 0100 - 01FF
																													1'b0;

assign APPLE_HR_RAM		=	({STORE_80, HGR,	ADDRESS[15:13]} == 5'b11001)				?  1'b1:
																											 		1'b0;

assign APPLE_TXT_RAM		=	({STORE_80, ADDRESS[15:10]}	== 7'b1000001)					?  1'b1:
																													1'b0;
assign APPLE_LC_RAM		=	(ADDRESS[15:12] == 4'hF)											?	1'b1:
									(ADDRESS[15:12] == 4'hE)											?	1'b1:
									(ADDRESS[15:12] == 4'hD)											?	1'b1:
																													1'b0;
*/

//assign RAM0_CS_N = !(CLK_MOD | (RW_N & !RAM0_CS_X) | !RAM0_CS_Y);

// RAM enables
/*
assign RAM0_CS_X = 	(ADDRESS[15] == 1'b0)													?	1'b0:		// 0000 - 7FFF
					(ADDRESS[15:13] == 3'b100)												?	1'b0:		// 8000 - 9FFF
					(ADDRESS[15:13] == 3'b101)												?	1'b0:		// A000 - BFFF
//					({SLOT_6IO, ADDRESS[3:0]} == 5'h1C)										?	1'b0:		// Floppy
					(ADDRESS[15:12] == 4'b1101)												?	1'b0:		// D000 - DFFF
					(ADDRESS[15:13] == 3'b111)												?	1'b0:		// E000 - FFFF
																								1'b1;
*/
assign RAM0_CS_X = 	(ADDRESS[15:12] == 4'hC);	// C000 - CFFF

// Modifies the RAM chip select for 20 nS
// This is used to cause a transistion to the memory CS
// when apple video reads
/*
always @(negedge CLK50MHZ)
begin
	case (CLK_CNT)
	8'h01:
	begin
		RAM0_CS_Y <= RW_N | RAM0_CS_X;
	end
	8'h02:
	begin
		RAM0_CS_Y <= 1'b1;
	end
	default:
		RAM0_CS_Y <= 1'b1;
	endcase
end
*/

assign RAM_OE_N = 1'b0;

/*
assign RAM_RW_N =	(VID_BUF_VRAM_CS)	?	1'b1:			// Video always reads from memory
					(FLOPPY_WRITE)		?	1'b0:			// When we write to a floppy we are actually reading a registar
					(UART_BUF_WR)			?	1'b0:
											RW_N;			// Normal RW
*/

/*****************************************************************************
* RAM Address MUX
******************************************************************************/

assign RAM_ADDRESS_VID	=		{2'b00, VID_BUF_VRAM_ADDR[15:0]};
assign RAM_ADDRESS_UART	=		UART_BUF_A[17:0];
assign RAM_ADDRESS_FD	=		FLOPPY_ADDRESS;
//assign RAM_ADDRESS_CPU	=		(SLOT_6IO)												?	FLOPPY_ADDRESS									:
assign RAM_ADDRESS_CPU	=
					({((LC_BANK2 & RW_N) | (LC_BANK2_W & !RW_N)), ADDRESS[15:12]} == 5'h1D)	?	{2'b00, ADDRESS[15:13], 1'b0, ADDRESS[11:0]}	:
																							{2'b00, ADDRESS[15:0]}							;

/*
//								Video
assign RAM_ADDRESS =		(VID_BUF_VRAM_CS)												?	{2'b00, VID_BUF_VRAM_ADDR[15:0]}						:
//								Floppy
							(UART_BUF_CS)													?	UART_BUF_A[17:0]												:
//							({PH_2, SLOT_6IO} == 2'b11)										?	FLOPPY_ADDRESS											:
							(SLOT_6IO)														?	FLOPPY_ADDRESS											:

							//								Language Card bank 2
//			({PH_2, ((LC_BANK2 & RW_N) | (LC_BANK2_W & !RW_N)), ADDRESS[15:12]} == 6'h3D)	?	{BANK_ADDRESS, ADDRESS[15:13], 1'b0, ADDRESS[11:0]}:
//																														{BANK_ADDRESS, ADDRESS[15:0]};
//			({PH_2, ((LC_BANK2 & RW_N) | (LC_BANK2_W & !RW_N)), ADDRESS[15:12]} == 6'h3D)	?	{2'b00, ADDRESS[15:13], 1'b0, ADDRESS[11:0]}			:
			({((LC_BANK2 & RW_N) | (LC_BANK2_W & !RW_N)), ADDRESS[15:12]} == 5'h1D)	?	{2'b00, ADDRESS[15:13], 1'b0, ADDRESS[11:0]}					:
																								{2'b00, ADDRESS[15:0]}									;
*/

//assign RAM1_CS_N =	!((FLOPPY_READ | FLOPPY_WRITE) & PH_2);


assign RAM_CS_N_VID		=	~VID_BUF_VRAM_FETCH_WAIT;
assign RAM_CS_N_UART	=	~UART_BUF_WAIT;
//assign RAM_CS_N_FD		=	~FLOPPY_WRITE;
assign RAM_CS_N_FD		=	1'b0;
//assign RAM_CS_N_CPU		=	~( (~RAM0_CS_X) | (FLOPPY_READ&RW_N) );
assign RAM_CS_N_CPU		=	RAM0_CS_X;


//assign RAM0_CS_N = !(CLK_MOD | (RW_N & !RAM0_CS_X) | !RAM0_CS_Y);
/*
assign RAM0_CS_N =	!(VID_BUF_VRAM_CS | (RAM_CS_CPU&(!RAM0_CS_X)) | (RAM_CS_CPU&FLOPPY_READ) | (RAM_CS_FD_WR&FLOPPY_WRITE) | (UART_BUF_CS&UART_BUF_WR));
*/

//assign RAM0_CS_N =	!(VID_BUF_VRAM_CS | (RW_N & !RAM0_CS_X) | !RAM0_CS_Y);
//assign RAM1_CS_N =	!((FLOPPY_READ | FLOPPY_WRITE) & PH_2);

/*
assign BANK_ADDRESS =	({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h01F)	?	2'b01:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h02F)	?	2'b10:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h03F)	?	2'b11:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h04F)	?	2'b01:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h08F)	?	2'b10:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h0CF)	?	2'b11:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h01E)?	2'b01:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h02E)?	2'b10:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h03E)?	2'b11:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h04E)?	2'b01:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h08E)?	2'b10:
						({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h0CE)?	2'b11:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0000111)							?	2'b01:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0001011)							?	2'b10:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0001111)							?	2'b11:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0010011)							?	2'b01:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0100011)							?	2'b10:
						({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0110011)							?	2'b11:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b00001111)					?	2'b01:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b00010111)					?	2'b10:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b00011111)					?	2'b11:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b00100111)					?	2'b01:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b01000111)					?	2'b10:
						({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b01100111)					?	2'b11:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b00001110)					?	2'b01:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b00010110)					?	2'b10:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b00011110)					?	2'b11:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b00100110)					?	2'b01:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b01000110)					?	2'b10:
						({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b01100110)					?	2'b11:
																																2'b00;
*/

//							( CLK_MOD	 		== 1'b1)																?	1'b0:


assign RAM_BE0_N_VID	=	1'b0;
assign RAM_BE0_N_UART	=	1'b1;
assign RAM_BE0_N_FD		=	1'b1;

// 有问题
//assign RAM_BE0_N_CPU	=	RAM0_CS_X;


assign RAM_BE0_N_CPU	=	// Language Card Area reads
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 4'b1011)			?	1'b0:
							// Language Card Area writes
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 4'b1010)		?	1'b0:
							// Main RAM
              				({(ADDRESS_4567||ADDRESS_89AB), ARAM_RD, RW_N} == 3'b101)				?	1'b0:
              				({(ADDRESS_4567||ADDRESS_89AB), ARAM_WR, RW_N} == 3'b100)				?	1'b0:
							ADDRESS_0123															?	1'b0:
																										1'b1;


assign RAM_BE1_N_VID	=	1'b1;
assign RAM_BE1_N_UART	=	1'b0;
//assign RAM_BE1_N_FD		=	~FLOPPY_WRITE;
assign RAM_BE1_N_FD		=	1'b0;
//assign RAM_BE1_N_CPU	=	~(FLOPPY_READ&&RW_N);	// CPU只能读取，写入时先写入寄存器
// CPU只能读取，写入时先写入寄存器
assign RAM_BE1_N_CPU	=	1'b1;


/*
assign RAM0_BE0_N =			// Video
							(VID_BUF_VRAM_CS)														?	1'b0:
							// Language Card Area reads
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 4'b1011)			?	1'b0:
							// Language Card Area writes
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 4'b1010)		?	1'b0:
							// Main RAM
              				({(ADDRESS_4567||ADDRESS_89AB), ARAM_RD, RW_N} == 3'b101)				?	1'b0:
              				({(ADDRESS_4567||ADDRESS_89AB), ARAM_WR, RW_N} == 3'b100)				?	1'b0:
							ADDRESS_0123															?	1'b0:
																										1'b1;
*/

/*
assign RAM0_BE0_N =	// Video
							( CLK_MOD	 		== 1'b1)																?	1'b0:
							// Language Card Area reads
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 4'b1011)		?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h04F)		?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h08F)		?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 9'h0CF)		?	1'b0:
							// Language Card Area writes
							({ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 4'b1010)	?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h04E)	?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h08E)	?	1'b0:
					({BANK, ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 9'h0CE)	?	1'b0:
							// ZP and stack
							({APPLE_ZP_RAM, ALT_ZP} == 2'b10)												?	1'b0:
					({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0010011)											?	1'b0:
					({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0100011)											?	1'b0:
					({BANK, APPLE_ZP_RAM, ALT_ZP} == 7'b0110011)											?	1'b0:
				 			// Video Memory Text and lowres
							({APPLE_TXT_RAM, SECONDARY} == 2'b10)											?	1'b0:
							// Hires
							({APPLE_HR_RAM, SECONDARY} == 2'b10)											?	1'b0:
							// Main RAM
							({APPLE_MAIN_RAM, ARAM_RD, RW_N} == 3'b101)									?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b00100111)								?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b01000111)								?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_RD, RW_N} == 8'b01100111)								?	1'b0:
							({APPLE_MAIN_RAM, ARAM_WR, RW_N} == 3'b100)									?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b00100110)								?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b01000110)								?	1'b0:
					({BANK, APPLE_MAIN_RAM, ARAM_WR, RW_N} == 8'b01100110)								?	1'b0:
																															1'b1;
*/

//							( CLK_MOD	 		== 1'b1)														?	1'b0:

/*
assign RAM0_BE1_N =			(((RAM_CS_CPU&FLOPPY_READ) | (RAM_CS_FD_WR&FLOPPY_WRITE))&DRIVE1_EN | (UART_BUF_CS&UART_BUF_WR))	?	1'b0	:	1'b1;
*/

/*
assign RAM0_BE1_N =	// Video
							( CLK_MOD	 		== 1'b1)																?	1'b0:
							// Language Card Area reads
				({BANK[4:2], ADDRESS_DEF, ALT_ZP, (LC_BANK1 | LC_BANK2), RW_N} == 7'b0001111)	?	1'b0:
							// Language Card Area writes
				({BANK[4:2], ADDRESS_DEF, ALT_ZP, (LC_BANK1_W | LC_BANK2_W), RW_N} == 7'b0001110)	?	1'b0:
							// ZP and stack
				({BANK[4:2], APPLE_ZP_RAM, ALT_ZP} == 5'b00011)											?	1'b0:
				 			// Video Memory Text and lowres
							({APPLE_TXT_RAM, SECONDARY} == 2'b11)											?	1'b0:
							// Hires
							({APPLE_HR_RAM, SECONDARY} == 2'b11)											?	1'b0:
							// Main RAM
				({BANK[4:2], APPLE_MAIN_RAM, ARAM_RD, RW_N} == 6'b000111)								?	1'b0:
				({BANK[4:2], APPLE_MAIN_RAM, ARAM_WR, RW_N} == 6'b000110)								?	1'b0:
																															1'b1;

assign RAM1_BE0_N =	!DRIVE1_EN;																				// Byte 0 Enable for RAM 1
assign RAM1_BE1_N =	!DRIVE2_EN;																				// Byte 1 Enable for RAM 1
*/

assign ROM_RW = 	ROM_WR_EN & ~RW_N;

/*****************************************************************************
* ROMs
* List Groups
******************************************************************************/
`ifndef SIMULATE

//`include "c:\\CEC-X\\rtl\\chargen.v"

char_rom_altera CHAR_ROM(
	.address(VROM_ADDRESS),	// 11-bit Address Input
	//.clock(CLK50MHZ),			// Clock
	.clock(VROM_CLK),			// Clock
	.q({VROM_DATA[0],VROM_DATA[1],VROM_DATA[2],VROM_DATA[3],VROM_DATA[4],VROM_DATA[5],VROM_DATA[6],VROM_DATA[7]})			// 8-bit Data Output
);

`endif

/*****************************************************************************
* Hardware Clock
******************************************************************************/
assign CLK_IN =	({SLOT_4IO, ADDRESS[3:0]}== 5'b10000)	?	8'h32					:	// Year thousand
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10001)	?	8'h30					:	// Year hundreds
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10010)	?	{4'h3,  YEARS_TENS}		:	// Year tens
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10011)	?	{4'h3,  YEARS_ONES}		:	// Year ones
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10100)	?	{7'h18, MONTHS_TENS}	:	// Month tens
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10101)	?	{4'h3,  MONTHS_ONES}	:	// Month ones
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10110)	?	{5'h06, DAY_WEEK}		:	// Day of week
				({SLOT_4IO, ADDRESS[3:0]}== 5'b10111)	?	{6'h0C, DAYS_TENS}		:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11000)	?	{4'h3,  DAYS_ONES}		:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11001)	?	{6'h0C, HOURS_TENS}		:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11010)	?	{4'h3,  HOURS_ONES}		:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11011)	?	{5'h06, MINUTES_TENS}	:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11100)	?	{4'h3,  MINUTES_ONES}	:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11101)	?	{5'h06, SECONDS_TENS}	:
				({SLOT_4IO, ADDRESS[3:0]}== 5'b11110)	?	{4'h3,  SECONDS_ONES}	:
															DEB_COUNTER;				/*Not needed for Apple*/

always @ (posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
		TIME_SET <= 43'h000000;
	else
		case({SLOT_4IO, RW_N, ADDRESS[3:0]})
		6'b100000:	TIME_SET[42]    <= DATA_OUT[7];				// set
		6'b100001:	TIME_SET[42]    <= DATA_OUT[7];				// set
		6'b100010:	TIME_SET[41:38] <= DATA_OUT[3:0];			// Years tens
		6'b100011:	TIME_SET[37:34] <= DATA_OUT[3:0];			// Years ones
		6'b100100:	TIME_SET[33]    <= DATA_OUT[0];				// Months tens
		6'b100101:	TIME_SET[32:29] <= DATA_OUT[3:0];			// Months ones
		6'b100110:	TIME_SET[28:26] <= DATA_OUT[2:0];			// Day of Week
		6'b100111:	TIME_SET[25:24] <= DATA_OUT[1:0];			// Days tens
		6'b101000:	TIME_SET[23:20] <= DATA_OUT[3:0];			// Days ones
		6'b101001:	TIME_SET[19:18] <= DATA_OUT[1:0];			// Hours tens
		6'b101010:	TIME_SET[17:14] <= DATA_OUT[3:0];			// Hours ones
		6'b101011:	TIME_SET[13:11] <= DATA_OUT[2:0];			// Minutes tens
		6'b101100:	TIME_SET[10:7]  <= DATA_OUT[3:0];			// Minutes ones
		6'b101101:	TIME_SET[6:4]   <= DATA_OUT[2:0];			// Seconds tens
		6'b101110:	TIME_SET[3:0]   <= DATA_OUT[3:0];			// Seconds ones
		endcase
end

`ifdef SIMULATE
initial
	begin
		DEB_COUNTER <= 8'H00;
		TIME <= 25'H000_0000;
		YEARS_TENS <= 4'H0;
		YEARS_ONES <= 4'H0;
		MONTHS_TENS <= 1'H0;
		MONTHS_ONES <= 4'H0;
		DAY_WEEK <= 3'H0;
		DAYS_TENS <= 2'H0;
		DAYS_ONES <= 4'H0;
		HOURS_TENS <= 2'H0;
		HOURS_ONES <= 4'H0;
		MINUTES_TENS <= 3'H0;
		MINUTES_ONES <= 4'H0;
		SECONDS_TENS <= 3'H0;
		SECONDS_ONES <= 4'H0;

	end
`endif

/*

always @ (posedge CLK50MHZ)
begin
	case(TIME_1US)
	6'd24:	begin	TIME_1US <= 6'd25;	CLK_1MHZ <= 1'b0;	end
	6'd49:	begin	TIME_1US <= 6'd0;	CLK_1MHZ <= 1'b1;	end
	default:	TIME_1US <= TIME_1US + 1;
	endcase
end

always @ (posedge CLK_1MHZ)
begin
	case(TIME_1MS)
	10'd499:	begin	TIME_1MS <= 10'd500;	CLK_1KHZ	<=	1'b0;	end
	10'd999:	begin	TIME_1MS <= 10'd0;		CLK_1KHZ	<=	1'b1;	end
	default:	TIME_1MS <= TIME_1MS + 1;
	endcase
end

always @ (posedge CLK_1KHZ)
begin
	case(TIME_1S)
	10'd499:	begin	TIME_1S <= 10'd500;	CLK_1HZ	<=	1'b0;	end
	10'd999:	begin	TIME_1S <= 10'd0;	CLK_1HZ	<=	1'b1;	end
	default:	TIME_1S <= TIME_1S + 1;
	endcase
end

*/

/*

always @ (posedge VGA_CLK)
begin
	case(TIME)
	25'H17D_783F:	TIME <= 25'H000_0000;
	default:	TIME <= TIME + 1;
	endcase
end

assign CLK_1HZ = TIME[24];

always @ (posedge TIME[0])
	DEB_COUNTER <= DEB_COUNTER + 1;

always @ (posedge TIME_1MS[1])
	DEB_COUNTER <= DEB_COUNTER + 1;

*/

always @ (posedge CLK_1KHZ)
	DEB_COUNTER <= DEB_COUNTER + 1;

/*

always @ (negedge CLK_1HZ or posedge TIME_SET[42])
begin
	if(TIME_SET[42])
	begin
		SECONDS_ONES <= TIME_SET[3:0];
		SECONDS_TENS <= TIME_SET[6:4];
	end
	else
	begin
		case(SECONDS_ONES)
		4'D9:	SECONDS_ONES <= 4'D0;
		default:	SECONDS_ONES <= SECONDS_ONES + 1;
		endcase

		case(SECONDS_TENS)
		3'D5:
			if(SECONDS_ONES == 4'H9)
				SECONDS_TENS <= 3'D0;
		default:
			if(SECONDS_ONES == 4'H9)
				SECONDS_TENS <= SECONDS_TENS + 1;
		endcase
	end
end

always @ (negedge SECONDS_TENS[2] or posedge TIME_SET[42])
begin
	if(TIME_SET[42])
	begin
		MINUTES_ONES <= TIME_SET[10:7];
		MINUTES_TENS <= TIME_SET[13:11];
	end
	else
	begin
		case(MINUTES_ONES)
		4'D9:	MINUTES_ONES <= 4'D0;
		default:	MINUTES_ONES <= MINUTES_ONES + 1;
		endcase

		case(MINUTES_TENS)
		3'D5:
			if(MINUTES_ONES == 4'H9)
				MINUTES_TENS <= 3'D0;
		default:
			if(MINUTES_ONES == 4'H9)
				MINUTES_TENS <= MINUTES_TENS + 1;
		endcase
	end
end

always @ (negedge MINUTES_TENS[2] or posedge TIME_SET[42])
begin
	if(TIME_SET[42])
	begin
		HOURS_ONES <= TIME_SET[17:14];
		HOURS_TENS <= TIME_SET[19:18];
	end
	else
	begin
		case(HOURS_ONES)
		4'D9:	HOURS_ONES <= 4'D0;
		4'D3:
			if(HOURS_TENS == 2'D2)
				HOURS_ONES <= 4'D0;
			else
				HOURS_ONES <= 4'D4;
		default:	HOURS_ONES <= HOURS_ONES + 1;
		endcase

		case(HOURS_TENS)
		2'D2:
			if(HOURS_ONES == 4'H3)
				HOURS_TENS <= 2'D0;
		default:
			if(HOURS_ONES == 4'H9)
				HOURS_TENS <= HOURS_TENS + 1;
		endcase
	end
end

always @ (negedge HOURS_TENS[1] or posedge TIME_SET[42])
begin
	if(TIME_SET[42])
	begin
		YEARS_TENS <= TIME_SET[41:38];
		YEARS_ONES <= TIME_SET[37:34];
		MONTHS_TENS <= TIME_SET[33];
		MONTHS_ONES <= TIME_SET[32:29];
		DAY_WEEK <= TIME_SET[28:26];
		DAYS_TENS <= TIME_SET[25:24];
		DAYS_ONES <= TIME_SET[23:20];
	end
	else
	begin
		if(DAY_WEEK == 3'h6)
			DAY_WEEK <= 3'h0;
		else
			DAY_WEEK <= DAY_WEEK + 1;

		case(DAYS_ONES)
		4'D9:	DAYS_ONES <= 4'D0;
		4'D1:
			if(DAYS_TENS == 2'D3)
				DAYS_ONES <= 4'D1;
			else
				DAYS_ONES <= 4'D2;
		default:	DAYS_ONES <= DAYS_ONES + 1;
		endcase

		case(DAYS_TENS)
		2'D3:
			if(DAYS_ONES == 4'D1)
				DAYS_TENS <= 2'D0;
		default:
			if(DAYS_ONES == 4'D9)
				DAYS_TENS <= DAYS_TENS + 1;
		endcase
	end
end

*/

/*****************************************************************************
* Convert PS/2 keyboard to ASCII keyboard
******************************************************************************/

//assign KB_CLK = KB_CLK_CNT[4];

`ifdef SIMULATE
initial
	begin
		KB_CLK_CNT = 5'b0;
	end
`endif
/*
always @ (posedge CLK50MHZ)				//	50 MHz
	KB_CLK_CNT <= KB_CLK_CNT + 1;			//	50/32 = 1.5625 MHz
*/

/*
always @ (posedge CLK50MHZ)				//	50 MHz
begin
	KB_CLK_CNT <= KB_CLK_CNT + 1;			//	50/32 = 1.5625 MHz
	case(KB_CLK_CNT)
	5'd0:	KB_CLK	<=	1'b1;
	5'd16:	KB_CLK	<=	1'b0;
	endcase
end
*/

always @ (posedge CLK50MHZ)
begin
	KB_CLK			<=	KB_CLK_CNT[4];
	KB_CLK_CNT		<=	KB_CLK_CNT + 1;		//	50/32 = 1.5625 MHz
end

assign CLR_STB =	(SYS_RESET_N == 1'b0)				?	1'b1:
					({APPLE_C0, ADDRESS[6:0]} == 8'h90)	?	1'b1:
															1'b0;

APPLE_KEYBOARD	A_KEYBOARD
(
	KB_CLK,
	SYS_RESET_N,
	RESET_N,
	CLR_STB,

	PS2_KBCLK,
	PS2_KBDAT,

	A_KEY_PRESSED,
	APPLE_PRESSED,
	ASCII,
	CAPS,
	L_SHIFT,
	R_SHIFT,
	L_ALT,
	R_ALT,

	RESET_KEY_N
);

/*****************************************************************************
* Serial Ports
******************************************************************************/
`ifndef SIMULATE

/*
glb6850 COM1(
.RESET_N(RESET_N),
.RX_CLK(COM1_CLK),
.TX_CLK(COM1_CLK),
.E(PH_2),
.DI(DATA_OUT),
.DO(DATA_COM1),
.CS(SLOT_7IO),
.RW_N(RW_N),
.RS(ADDRESS[0]),
.TXDATA(TXD1),
.RXDATA(RXD1),
.RTS(RTS1),
.CTS(RTS1),
.DCD(RTS1)
);
*/

`endif

/*****************************************************************************
* Floppy
******************************************************************************/

// CPU 写入软盘 IO ：
// 第1个 CPU_CLK 延，CPU 发出请求；
// 第2个 CPU_CLK 延，有效数据DATA_OUT写入FLOPPY_WRITE_DATA；同时写入 RAM，由锁存的FLOPPY_WRITE_DATA提供数据

// 6312 bytes per track
// New byte every 32 CPU clock cycles
// or 8 bits * 4 clock cycles
always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		FLOPPY_CLK <= 5'b00000;
		LAST_WRITE_DATA <= 8'b0;
	end
	else
	begin
		FLOPPY_CLK <= FLOPPY_CLK + 1'b1;
/*
		if(FLOPPY_WRITE)
		begin
			FLOPPY_CLK <= FLOPPY_CLK + 1'b1;
			LAST_WRITE_DATA <= FLOPPY_WRITE_DATA;
			//assign FLOPPY_VALID 	=	(FLOPPY_CLK[4:3]==2'b00);
			//(FLOPPY_CLK[4:3]==2'b00)
		end
		else
		begin
			if(!(Q7 && (FLOPPY_CLK == 5'b00000) && (LAST_WRITE_DATA == 8'hFF)))
				FLOPPY_CLK <= FLOPPY_CLK + 1'b1;
		end
*/
	end
end

always @(posedge FLOPPY_CLK[4])
begin
	case(FLOPPY_BYTE)
	`FD_TRACK_LEN:
	begin
		FLOPPY_BYTE <= 13'h0000;
		FLOPPY_ADDRESS <=	{TRACK, 1'b0};
	end
	default:
	begin
		FLOPPY_BYTE <= FLOPPY_BYTE + 1'b1;
		FLOPPY_ADDRESS <= {TRACK, 1'b0} + {5'b00000, FLOPPY_BYTE};
	end
	endcase
end

/*
always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		LAST_WRITE_DATA	<=	8'b0;
	end
	else
	begin
		if(FLOPPY_WRITE)
			LAST_WRITE_DATA	<=	FLOPPY_WRITE_DATA;
	end
end
*/

/*
reg	FLOPPY_POS_MOVE;

reg	FLOPPY_BYTE_END;
reg	FLOPPY_BYTE_END_H;
reg	FLOPPY_BYTE_END_L;


wire		[4:0]	FLOPPY_BYTE_H_INC;
wire		[8:0]	FLOPPY_BYTE_L_INC;

assign		FLOPPY_BYTE_H_INC		=	5'd1 + FLOPPY_BYTE[12:8];
assign		FLOPPY_BYTE_L_INC		=	9'd1 + FLOPPY_BYTE[7:0];


always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		FLOPPY_CLK			<=	5'b00000;

		FLOPPY_POS_MOVE		<=	1'b0;

		//FLOPPY_BYTE_END			<= 1'b0;
		FLOPPY_BYTE_END_H		<= 1'b0;
		FLOPPY_BYTE_END_L		<= 1'b0;
	end
	else
	begin
		//FLOPPY_BYTE_END		<=	(FLOPPY_BYTE==`FD_TRACK_LEN);
		FLOPPY_BYTE_END_H		<=	(FLOPPY_BYTE[12:8]==`FD_TRACK_LEN_H);
		FLOPPY_BYTE_END_L		<=	(FLOPPY_BYTE[ 7:0]==`FD_TRACK_LEN_L);


		if(FLOPPY_WRITE)
		begin
			FLOPPY_CLK		<=	FLOPPY_CLK + 1'b1;

			if(FLOPPY_CLK==5'b01111)
				FLOPPY_POS_MOVE		<=	1'b1;
			else
				FLOPPY_POS_MOVE		<=	1'b0;

		end
		else
		begin
			if(!(Q7 && (FLOPPY_CLK == 5'b00000) && (LAST_WRITE_DATA == 8'hFF)))
			begin
				FLOPPY_CLK			<=	FLOPPY_CLK + 1'b1;

				if(FLOPPY_CLK==5'b01111)
					FLOPPY_POS_MOVE		<=	1'b1;
				else
					FLOPPY_POS_MOVE		<=	1'b0;
			end
			else
			begin
				FLOPPY_POS_MOVE		<=	1'b0;
			end
		end
	end
end

always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		FLOPPY_BYTE		<=	13'h0000;
	end
	else
	begin
		if(FLOPPY_POS_MOVE)
		begin
			//if(FLOPPY_CLK==5'b10000 && (FLOPPY_BYTE==`FD_TRACK_LEN))
			//if(FLOPPY_BYTE==`FD_TRACK_LEN)
			//if(FLOPPY_BYTE_END)
			if(FLOPPY_BYTE_END_H&&FLOPPY_BYTE_END_L)
				FLOPPY_BYTE		<=	13'h0000;
			else
			begin
				//FLOPPY_BYTE		<=	FLOPPY_BYTE + 1'b1;
				FLOPPY_BYTE		<=	{ FLOPPY_BYTE_L_INC[8]?FLOPPY_BYTE_H_INC:FLOPPY_BYTE[12:8], FLOPPY_BYTE_L_INC[7:0] };
			end
		end
	end
end

*/


always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		PHASE0 <= 1'b0;
		PHASE1 <= 1'b0;
		PHASE2 <= 1'b0;
		PHASE3 <= 1'b0;
		MOTOR  <= 1'b0;
		DRIVE1 <= 1'b1;
		FLOPPY_WRITE_DATA <= 8'h00;
	end
	else
	begin
		case ({SLOT_6IO, ADDRESS[3:0]})
		5'h10:	PHASE0 <= 1'b0;
		5'h11:	PHASE0 <= 1'b1;
		5'h12:	PHASE1 <= 1'b0;
		5'h13:	PHASE1 <= 1'b1;
		5'h14:	PHASE2 <= 1'b0;
		5'h15:	PHASE2 <= 1'b1;
		5'h16:	PHASE3 <= 1'b0;
		5'h17:	PHASE3 <= 1'b1;
		5'h18:	MOTOR  <= 1'b0;
		5'h19:	MOTOR  <= 1'b1;
		5'h1A:	DRIVE1 <= 1'b1;
		5'h1B:	DRIVE1 <= 1'b0;
		5'h1C:	Q6 <= 1'b0;
		5'h1D:
		begin
				FLOPPY_WRITE_DATA <= DATA_OUT[7:0];
				Q6 <= 1'b1;
		end
		5'h1E:	Q7 <= 1'b0;
		5'h1F:
		begin
				FLOPPY_WRITE_DATA <= DATA_OUT[7:0];
				Q7 <= 1'b1;
		end

		endcase
	end
end

assign DRIVE1_X =  DRIVE1 & MOTOR;
assign DRIVE2_X = !DRIVE1 & MOTOR;

assign DRIVE1_FLOPPY_WP	=	SWITCH[2];
assign DRIVE2_FLOPPY_WP	=	SWITCH[3];
assign DRIVE_SWAP		=	SWITCH[4];


//assign DRIVE1_EN = (DRIVE_SWAP ^  DRIVE1) & MOTOR;
//assign DRIVE2_EN = (DRIVE_SWAP ^ !DRIVE1) & MOTOR;

assign DRIVE1_EN = (DRIVE1) & MOTOR;
assign DRIVE2_EN = (~DRIVE1) & MOTOR;

assign FLOPPY_READ		= ({Q7, SLOT_6IO, ADDRESS[3:0]} == 6'h1C)	?	1'b1	:	1'b0;
assign FLOPPY_WRITE		= ({Q7, SLOT_6IO, ADDRESS[3:0]} == 6'h3C)	?	1'b1	:	1'b0;
assign FLOPPY_WP_READ	= ({Q6, SLOT_6IO, ADDRESS[3:0]} == 6'h3E)	?	1'b1	:	1'b0;

//assign FLOPPY_VALID 	=	(!FLOPPY_CLK[4] & !FLOPPY_CLK[3]);
assign FLOPPY_VALID 	=	(FLOPPY_CLK[4:3]==2'b00);

/*
assign FLOPPY_RD_DATA	=	DRIVE1_EN	?	{FLOPPY_VALID, RAM_DATA1[6:0]}:
							DRIVE2_EN	?	{FLOPPY_VALID, RAM_DATA1[14:8]}:
											8'H00;
*/

assign FLOPPY_RD_DATA	=	DRIVE1_EN	?	{FLOPPY_VALID, RAM_DATA0_FD[6:0]}:
											8'H00;

assign FLOPPY_DATA		=	(FLOPPY_READ)							?	FLOPPY_RD_DATA:
							({DRIVE1_EN, FLOPPY_WP_READ} == 2'b11)	?	{DRIVE1_FLOPPY_WP, 7'h00}:
							({DRIVE2_EN, FLOPPY_WP_READ} == 2'b11)	?	{DRIVE2_FLOPPY_WP, 7'h00}:
							(FLOPPY_WRITE)							?	FLOPPY_WRITE_DATA:
																		8'h00;

/*
assign TRACK		=	(DRIVE1_EN)		?	TRACK1:
						(DRIVE2_EN)		?	TRACK2:
											TRACK;
*/
assign TRACK		=	(DRIVE1_EN)		?	TRACK1:
						(DRIVE2_EN)		?	TRACK2:
											17'b0;

assign TRACK1_UP	= TRACK1 + `FD_TRACK_STEP;
assign TRACK1_DOWN	= TRACK1 - `FD_TRACK_STEP;
assign TRACK2_UP	= TRACK2 + `FD_TRACK_STEP;
assign TRACK2_DOWN	= TRACK2 - `FD_TRACK_STEP;


//assign FLOPPY_ADDRESS = {TRACK, 1'b0} + {5'b00000, FLOPPY_BYTE};


//always @ (posedge PH_2)
always @(negedge CPU_CLK)
begin
	PHASE0_1 <= PHASE0;
	PHASE0_2 <= PHASE0_1;					// Delay 2 clock cycles
	PHASE1_1 <= PHASE1;
	PHASE1_2 <= PHASE1_1;					// Delay 2 clock cycles
	PHASE2_1 <= PHASE2;
	PHASE2_2 <= PHASE2_1;					// Delay 2 clock cycles
	PHASE3_1 <= PHASE3;
	PHASE3_2 <= PHASE3_1;					// Delay 2 clock cycles
end

always @(posedge CPU_CLK or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		STEPPER1 <= 2'b00;
		STEPPER2 <= 2'b00;
		TRACK1 <= 17'd00000;
		TRACK2 <= 17'd00000;

		TRACK1_NO <= 8'd0;
		TRACK2_NO <= 8'd0;
	end
	else
	begin
//		if(DRIVE1^DRIVE_SWAP)
		if(DRIVE1)
		begin
			case ({PHASE0_2, PHASE1_2, PHASE2_2, PHASE3_2})
			4'b1000:
			begin
				if(STEPPER1 == 2'b11)
				begin
					//if(TRACK1 != `FD_MAX_LEN)
					if(TRACK1_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK1 <= TRACK1_UP;
						TRACK1_NO <= TRACK1_NO+1;
						STEPPER1 <= 2'b00;
					end
				end
				else
				if(STEPPER1 == 2'b01)
				begin
					//if(TRACK1 != 17'h0)
					if(TRACK1_NO != 8'd0)
					begin
						TRACK1 <= TRACK1_DOWN;
						TRACK1_NO <= TRACK1_NO-1;
						STEPPER1 <= 2'b00;
					end
				end
			end
			4'b0100:
			begin
				if(STEPPER1 == 2'b00)
				begin
					//if(TRACK1 != `FD_MAX_LEN)
					if(TRACK1_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK1 <= TRACK1_UP;
						TRACK1_NO <= TRACK1_NO+1;
						STEPPER1 <= 2'b01;
					end
				end
				else
				if(STEPPER1 == 2'b10)
				begin
					//if(TRACK1 != 17'h0)
					if(TRACK1_NO != 8'd0)
					begin
						TRACK1 <= TRACK1_DOWN;
						TRACK1_NO <= TRACK1_NO-1;
						STEPPER1 <= 2'b01;
					end
				end
			end
			4'b0010:
			begin
				if(STEPPER1 == 2'b01)
				begin
					//if(TRACK1 != `FD_MAX_LEN)
					if(TRACK1_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK1 <= TRACK1_UP;
						TRACK1_NO <= TRACK1_NO+1;
						STEPPER1 <= 2'b10;
					end
				end
				else
				if(STEPPER1 == 2'b11)
				begin
					//if(TRACK1 != 17'h0)
					if(TRACK1_NO != 8'd0)
					begin
						TRACK1 <= TRACK1_DOWN;
						TRACK1_NO <= TRACK1_NO-1;
						STEPPER1 <= 2'b10;
					end
				end
			end
			4'b0001:
			begin
				if(STEPPER1 == 2'b10)
				begin
					//if(TRACK1 != `FD_MAX_LEN)
					if(TRACK1_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK1 <= TRACK1_UP;
						TRACK1_NO <= TRACK1_NO+1;
						STEPPER1 <= 2'b11;
					end
				end
				else
				if(STEPPER1 == 2'b00)
				begin
					//if(TRACK1 != 17'h0)
					if(TRACK1_NO != 8'd0)
					begin
						TRACK1 <= TRACK1_DOWN;
						TRACK1_NO <= TRACK1_NO-1;
						STEPPER1 <= 2'b11;
					end
				end
			end
			endcase
		end
/*
		else
		begin
			case ({PHASE0_2, PHASE1_2, PHASE2_2, PHASE3_2})
			4'b1000:
			begin
				if(STEPPER2 == 2'b11)
				begin
					//if(TRACK2 != `FD_MAX_LEN)
					if(TRACK2_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK2 <= TRACK2_UP;
						TRACK2_NO <= TRACK2_NO+1;
						STEPPER2 <= 2'b00;
					end
				end
				else
				if(STEPPER2 == 2'b01)
				begin
					//if(TRACK2 != 17'h0)
					if(TRACK2_NO != 8'd0)
					begin
						TRACK2 <= TRACK2_DOWN;
						TRACK2_NO <= TRACK2_NO-1;
						STEPPER2 <= 2'b00;
					end
				end
			end
			4'b0100:
			begin
				if(STEPPER2 == 2'b00)
				begin
					//if(TRACK2 != `FD_MAX_LEN)
					if(TRACK2_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK2 <= TRACK2_UP;
						TRACK2_NO <= TRACK2_NO+1;
						STEPPER2 <= 2'b01;
					end
				end
				else
				if(STEPPER2 == 2'b10)
				begin
					//if(TRACK2 != 17'h0)
					if(TRACK2_NO != 8'd0)
					begin
						TRACK2 <= TRACK2_DOWN;
						TRACK2_NO <= TRACK2_NO-1;
						STEPPER2 <= 2'b01;
					end
				end
			end
			4'b0010:
			begin
				if(STEPPER2 == 2'b01)
				begin
					//if(TRACK2 != `FD_MAX_LEN)
					if(TRACK2_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK2 <= TRACK2_UP;
						TRACK2_NO <= TRACK2_NO+1;
						STEPPER2 <= 2'b10;
					end
				end
				else
				if(STEPPER2 == 2'b11)
				begin
					//if(TRACK2 != 17'h0)
					if(TRACK2_NO != 8'd0)
					begin
						TRACK2 <= TRACK2_DOWN;
						TRACK2_NO <= TRACK2_NO-1;
						STEPPER2 <= 2'b10;
					end
				end
			end
			4'b0001:
			begin
				if(STEPPER2 == 2'b10)
				begin
					//if(TRACK2 != `FD_MAX_LEN)
					if(TRACK2_NO != `FD_MAX_TRACK_NO)
					begin
						TRACK2 <= TRACK2_UP;
						TRACK2_NO <= TRACK2_NO+1;
						STEPPER2 <= 2'b11;
					end
				end
				else
				if(STEPPER2 == 2'b00)
				begin
					//if(TRACK2 != 17'h0)
					if(TRACK2_NO != 8'd0)
					begin
						TRACK2 <= TRACK2_DOWN;
						TRACK2_NO <= TRACK2_NO-1;
						STEPPER2 <= 2'b11;
					end
				end
			end
			endcase
		end
*/
	end
end

/*****************************************************************************
* Video
******************************************************************************/

/*
assign CLOCK_MUX =	(APPLE_ADDRESS[5:0] == 6'd7) ?	{6'b101100, HOURS_TENS}:
							(APPLE_ADDRESS[5:0] == 6'd8) ?	{4'b1011, HOURS_ONES}:
							(APPLE_ADDRESS[5:0] == 6'd9) ?	 8'hBA:
							(APPLE_ADDRESS[5:0] == 6'd10) ?	{5'b10110, MINUTES_TENS}:
							(APPLE_ADDRESS[5:0] == 6'd11) ?	{4'b1011, MINUTES_ONES}:
							(APPLE_ADDRESS[5:0] == 6'd12) ?	 8'hBA:
							(APPLE_ADDRESS[5:0] == 6'd13) ?	{5'b10110, SECONDS_TENS}:
							(APPLE_ADDRESS[5:0] == 6'd14) ?	{4'b1011, SECONDS_ONES}:
																		 8'hA0;


							(VID_BUF_VID_ADDR[5:0] == 6'd15) ?	{4'b1011, DATA_IN[ 7: 4]} + ((DATA_IN[ 7: 4]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd16) ?	{4'b1011, DATA_IN[ 3: 0]} + ((DATA_IN[ 3: 0]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd18) ?	{4'b1011, DATA_OUT[ 7: 4]} + ((DATA_OUT[ 7: 4]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd19) ?	{4'b1011, DATA_OUT[ 3: 0]} + ((DATA_OUT[ 3: 0]>4'd9)?8'd7:8'd0):

*/

assign CLOCK_MUX =			(VID_BUF_VID_ADDR[5:0] == 6'd1) ?	{6'b101100, HOURS_TENS}:
							(VID_BUF_VID_ADDR[5:0] == 6'd2) ?	{4'b1011, HOURS_ONES}:
							(VID_BUF_VID_ADDR[5:0] == 6'd3) ?	 8'hBA:
							(VID_BUF_VID_ADDR[5:0] == 6'd4) ?	{5'b10110, MINUTES_TENS}:
							(VID_BUF_VID_ADDR[5:0] == 6'd5) ?	{4'b1011, MINUTES_ONES}:
							(VID_BUF_VID_ADDR[5:0] == 6'd6) ?	 8'hBA:
							(VID_BUF_VID_ADDR[5:0] == 6'd7) ?	{5'b10110, SECONDS_TENS}:
							(VID_BUF_VID_ADDR[5:0] == 6'd8) ?	{4'b1011, SECONDS_ONES}:

							(VID_BUF_VID_ADDR[5:0] == 6'd10) ?	{4'b1011, ADDRESS[15:12]} + ((ADDRESS[15:12]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd11) ?	{4'b1011, ADDRESS[11: 8]} + ((ADDRESS[11: 8]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd12) ?	{4'b1011, ADDRESS[ 7: 4]} + ((ADDRESS[ 7: 4]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd13) ?	{4'b1011, ADDRESS[ 3: 0]} + ((ADDRESS[ 3: 0]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd15) ?	{4'b1011, TRACK1_NO[ 7: 4]} + ((TRACK1_NO[ 7: 4]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd16) ?	{4'b1011, TRACK1_NO[ 3: 0]} + ((TRACK1_NO[ 3: 0]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd18) ?	{4'b1011, TRACK2_NO[ 7: 4]} + ((TRACK2_NO[ 7: 4]>4'd9)?8'd7:8'd0):
							(VID_BUF_VID_ADDR[5:0] == 6'd19) ?	{4'b1011, TRACK2_NO[ 3: 0]} + ((TRACK2_NO[ 3: 0]>4'd9)?8'd7:8'd0):
																		 8'hA0;


vram_buf vram_buf(
	.sys_clk(CLK50MHZ),
	.vid_clk(VGA_CLK),

	// 系统读取接口
	.vram_rdy(RAM_RDY_VID),		// 收到读取信号的下个周期必须完成读取操作
	.vram_addr(VID_BUF_VRAM_ADDR),
	.vram_fetch_wait(VID_BUF_VRAM_FETCH_WAIT),
	.vram_cs(VID_BUF_VRAM_CS),
	.vram_data(VID_BUF_VRAM_DATA),
//	.vram_data(RAM_DATA0[7:0]),

	// 视频读取接口
	.vid_en(VID_BUF_VID_RD),
	.vid_addr(VID_BUF_VID_ADDR),
	.vid_data(VID_BUF_VID_DATA),

	// 触发信号
	.VSYNC_N(VGA_OUT_VS),
	.HSYNC_N(VGA_OUT_HS),
//	.V_BLANKING(V_BLANKING),
//	.H_BLANKING(H_BLANKING),
	.RESET_N(RESET_N)
);

APPLE_VIDEO A_VIDEO(
		.CLK(VGA_CLK),
		.APPLE_VID(1'b1),
		.ADDRESS(VID_BUF_VID_ADDR),
		.DATA(VID_BUF_VID_DATA),
		.CHAR_CLK(VROM_CLK),
		.CHAR_ADD(VROM_ADDRESS),
		.CHAR_DATA(VROM_DATA),
		.CLK_MOD(VID_BUF_VID_RD),
		.RED(RED),
		.GREEN(GREEN),
		.BLUE(BLUE),
		.VSYNC(VGA_OUT_VS),
		.HSYNC(VGA_OUT_HS),
		.CLOCK_MUX(CLOCK_MUX),
		.TEXT(TEXT),
		.MIXED(MIXED),
		.TEXT_80(TEXT_80),
		.SECONDARY((SECONDARY & ~STORE_80)),
		.HI_RES(HGR),
		.ALT_CHAR(ALT_CHAR),
		.DHRES(DHRES),
		.TEXT_COLOR(USER_C),
		.V_BLANKING(V_BLANKING),
		.H_BLANKING(H_BLANKING),
		.CEC_C0B0_COLOR(CEC_C0B0[4]),
		.CLK_1HZ(CLK_1HZ)
);

assign	VGA_OUT_RED		=	{RED,	7'b0};
assign	VGA_OUT_GREEN	=	{GREEN,	7'b0};
assign	VGA_OUT_BLUE	=	{BLUE,	7'b0};

`ifdef VGA_RESISTOR

`ifdef VGA_BIT12
assign VGA_RED = VGA_OUT_RED[7:4];
assign VGA_GREEN = VGA_OUT_GREEN[7:4];
assign VGA_BLUE = VGA_OUT_BLUE[7:4];
`endif

assign VGA_HS = VGA_OUT_HS;
assign VGA_VS = VGA_OUT_VS;

`endif

`ifdef VGA_ADV7123

`ifdef VGA_BIT24
assign VGA_DAC_RED = VGA_OUT_RED;
assign VGA_DAC_GREEN = VGA_OUT_GREEN;
assign VGA_DAC_BLUE = VGA_OUT_BLUE;
`endif

`ifdef VGA_BIT30
assign VGA_DAC_RED = {VGA_OUT_RED,2'b0};
assign VGA_DAC_GREEN = {VGA_OUT_GREEN,2'b0};
assign VGA_DAC_BLUE = {VGA_OUT_BLUE,2'b0};
`endif


assign VGA_DAC_CLOCK = ~VGA_CLK;
assign VGA_DAC_BLANK_N = VGA_OUT_HS & VGA_OUT_VS;
assign VGA_DAC_SYNC_N =	1'b1;			//	This pin is unused

always @(negedge VGA_CLK)
	begin
		VGA_HS <= VGA_OUT_HS;
		VGA_VS <= VGA_OUT_VS;
	end

`endif

`ifdef AUDIO_WM8731

AUDIO_IF AUD_IF(
	//	Audio Side
	.oAUD_BCLK(AUD_BCLK),
	.oAUD_DACLRCK(AUD_DACLRCK),
	.oAUD_DACDAT(AUD_DACDAT),
	.oAUD_ADCLRCK(AUD_ADCLRCK),
	.iAUD_ADCDAT(AUD_ADCDAT),
	//	Control Signals
	.iSPK_A(SPEAKER),
	//.iSPK_B(~SPEAKER),
	.iSPK_B(1'b0),
	.iCASS_OUT(CASS_OUT),
	.oCASS_IN_L(CASS_IN_L),
	.oCASS_IN_R(CASS_IN_R),
	// System
	.iCLK_18_4(AUD_CTRL_CLK),
	.iRST_N(RESET_N)
);

assign	AUD_XCK = AUD_CTRL_CLK;

`endif

`ifdef AUDIO_WM8731
assign	CASS_IN			=	CASS_IN_L;
`endif


UART_IF FD_BUF_UART_IF(
	//
	.MEM_A(UART_BUF_A),
	.MEM_WR(UART_BUF_WR),
	.MEM_DAT(UART_BUF_DAT),
	.MEM_Q(RAM_DATA0[15:8]),
	.MEM_RDY(RAM_RDY_UART),
	.MEM_WAIT(UART_BUF_WAIT),
	.MEM_CS(UART_BUF_CS),
	//
	.MEM_RD(),

	//	Control Signals

    /*
     * UART: 115200 bps, 8N1
     */
    .UART_RXD(UART_RXD),
    .UART_TXD(UART_TXD),

	// Clock: 10MHz 50MHz
	.CLK(CLK50MHZ),
	.RST_N(RESET_N)
);


`ifdef DE1

// AUDIO_WM8731

I2C_AUD_Config AUD_I2C_U(
	//	Host Side
	.iCLK(CLK50MHZ),
	//.iRST_N(RESET_N),
	.iRST_N(1'b1),
	//	I2C Side
	.I2C_SCLK(AV_I2C_SCLK),
	.I2C_SDAT(AV_I2C_SDAT)
);

`endif


`ifdef DE2

// AUDIO_WM8731
// ADV7180
// 有个老的DE2开发板需要设置 ADV7180，否则显示画面不稳定(产生CLK27MHZ信号)

I2C_AV_Config AV_I2C_U(
	//	Host Side
	.iCLK(CLK50MHZ),
	//.iRST_N(RESET_N),
	.iRST_N(1'b1),
	//	I2C Side
	.I2C_SCLK(AV_I2C_SCLK),
	.I2C_SDAT(AV_I2C_SDAT)
);

`endif


endmodule
