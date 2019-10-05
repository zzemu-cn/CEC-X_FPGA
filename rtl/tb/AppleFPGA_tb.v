`timescale 1 ns / 1 ns

module top_tb;

reg				CLK50MHZ;

// FLASH
wire	[18:0]	FLASH_ADDRESS;
wire	[7:0]	FLASH_DATA;
wire	FLASH_CE_N;
wire	FLASH_OE_N;
wire	FLASH_WE_N;

// Main RAM Common
wire [17:0]	RAM_ADDRESS;
wire			RAM_RW_N;

// Main RAM bank 0
wire	[15:0]	RAM_DATA0;
wire			RAM0_CS_N;
wire			RAM0_BE0_N;
wire			RAM0_BE1_N;
wire			RAM_OE_N;

// Main RAM bank 1
wire	[15:0]	RAM_DATA1;
wire			RAM1_CS_N;
wire			RAM1_BE0_N;
wire			RAM1_BE1_N;

// VGA
wire			RED;
wire			GREEN;
wire			BLUE;
wire			H_SYNC;
wire			V_SYNC;

// PS/2
reg 			ps2_clk;
reg				ps2_data;

// Serial Ports
//wire			TXD1;
//wire			RXD1;

// Display
wire [3:0]	DIGIT_N;
wire [7:0]	SEGMENT_N;

// LEDs
wire [7:0]	LED;

// Apple Perpherial
wire			SPEAKER;
reg				[3:0]	PADDLE;
reg				[2:0]	P_SWITCH;
wire	[7:0]	DTOA_CODE;

// Extra Buttons and Switches
reg [7:0]		SWITCH;				//  7 System type 1	Not used
											//  6 System type 0	Not used
											//  5 Serial Port speed
											//  4 Swap floppy
											//  3 Write protect floppy 2
											//  2 Write protect floppy 1
											//  1 CPU_SPEED[1]
											//  0 CPU_SPEED[0]

reg [3:0]		BUTTON;				//  3 RESET
											//  2 Not used
											//  1 Closed Apple
											//  0 Open Apple 


parameter period = 20;

initial
	begin
        CLK50MHZ = 0;
        #(period)
        forever
        	#(period/2) CLK50MHZ = !CLK50MHZ;
	end

initial
	begin
        #500000 $finish;
	end


initial
	begin
//		SWITCH = 8'b000_0000;
		SWITCH = 8'b000_0010;
		BUTTON = 4'b1000;
		#100 BUTTON = 4'b0000;
	end


initial
begin
        $dumpfile("applefpga.dump");
        $dumpvars(0, DUT0, RAM_U0, RAM_U1, FLASH_U0);
end


IS61LV25616 RAM_U0(.A(RAM_ADDRESS), .IO(RAM_DATA0), .CE_(RAM0_CS_N), .OE_(RAM_OE_N), .WE_(RAM_RW_N), .LB_(RAM0_BE0_N), .UB_(RAM0_BE1_N));
IS61LV25616 RAM_U1(.A(RAM_ADDRESS), .IO(RAM_DATA1), .CE_(RAM1_CS_N), .OE_(RAM_OE_N), .WE_(RAM_RW_N), .LB_(RAM1_BE0_N), .UB_(RAM1_BE1_N));

mem_flash_tb FLASH_U0(
.clk(CLK50MHZ),
.rst(1'b0),
.adr(FLASH_ADDRESS),
.dat(FLASH_DATA),
.oe_n(FLASH_OE_N),
.ce_n(FLASH_CE_N)
);


AppleFPGA DUT0(
CLK50MHZ,
// FLASH
FLASH_ADDRESS,
FLASH_DATA,
FLASH_CE_N,
FLASH_OE_N,
FLASH_WE_N,
// RAM, ROM, and Peripherials
RAM_DATA0,				// 16 bit data bus to RAM 0
RAM_DATA1,				// 16 bit data bus to RAM 1
RAM_ADDRESS,			// Common address
RAM_RW_N,				// Common RW
RAM0_CS_N,				// Chip Select for RAM 0
RAM1_CS_N,				// Chip Select for RAM 1
RAM0_BE0_N,				// Byte Enable for RAM 0
RAM0_BE1_N,				// Byte Enable for RAM 0
RAM1_BE0_N,				// Byte Enable for RAM 1
RAM1_BE1_N,				// Byte Enable for RAM 1
RAM_OE_N,
// VGA
RED,
GREEN,
BLUE,
H_SYNC,
V_SYNC,
// PS/2
ps2_clk,
ps2_data,
//Serial Ports
//TXD1,
//RXD1,
// Display
DIGIT_N,
SEGMENT_N,
// LEDs
LED,
// Apple Perpherial
//SPEAKER,
//PADDLE,
//P_SWITCH,
//DTOA_CODE,
// Extra Buttons and Switches
SWITCH,
BUTTON
);

endmodule
