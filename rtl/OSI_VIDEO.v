`timescale 1 ns / 1 ns

module VIDEO
(
CLK,						// Bit clock (25 MHz)
ADDRESS,					// Video RAM address
DATA,						// Video RAM data
RED,
GREEN,
BLUE,
H_SYNC,
V_SYNC,
VROM_ADDRESS,			// Video ROM address
VROM_DATA,				// Video ROM data
OSI_GRAPHICS,			// Graphics mode
CLOCK,					// CLOCK display switch (line 33)
CLK_1HZ
);
input				CLK;						// 25 MHz
output [10:0]	ADDRESS;
input  [15:0]	DATA;
output			RED;
output			GREEN;
output			BLUE;
output			H_SYNC;
reg				H_SYNC;
output			V_SYNC;
reg				V_SYNC;
output [10:0]	VROM_ADDRESS;
input	 [7:0]	VROM_DATA;
input				OSI_GRAPHICS;
input				CLK_1HZ;
output			CLOCK;

reg				H_BLANKING;
reg				V_BLANKING;
reg				MEMORY_ENABLE;			// Video RAM enable
reg	[15:0]	CHARACTER;
reg	[15:0]	PIXELS;
reg	[9:0]		H_ADD;
reg	[9:0]		V_ADD;
reg				CLOCK;
wire				DOT;
/*****************************************************************************
* READ Video RAM and latch the character
******************************************************************************/
assign ADDRESS = {V_ADD[7:3],H_ADD[8:3]};				// 64 x 32 = {v(32), h(64)}
always @(negedge CLK)
begin
//	Start RAM read, on pixel 0
	if(H_ADD[2:0] == 3'b000)
		MEMORY_ENABLE <= 1'b1;
	else
		MEMORY_ENABLE <= 1'b0;
// Capture RAM character, on pixel 1
	if(MEMORY_ENABLE)
		CHARACTER <= DATA;
	else
		CHARACTER <= CHARACTER;
end
/*****************************************************************************
* Read the video ROM
******************************************************************************/
assign VROM_ADDRESS = {CHARACTER[7:0], V_ADD[2:0]};
always @(negedge CLK)
begin
	if(H_ADD[2:0] == 3'b111)
	begin
		if(~OSI_GRAPHICS)
			PIXELS <= {CHARACTER[15:8], VROM_DATA};
	end
end
/*****************************************************************************
* Color Video Signals
*
*	PIXELS[7:0]		= Horizontal Dots
*	PIXELS[8] 		= Inverse video
*  PIXELS[11:9]	= Foreground color Blue, Green, Red
*  PIXELS[12]		= Blinking
*	PIXELS[15:13]	= Background color Blue, Green, Red
*
*
* Maybe later, add border color by modifying blanking color map
******************************************************************************/
assign DOT		=	PIXELS[H_ADD[2:0]];
assign RED		=	(V_BLANKING | H_BLANKING)								?	1'b0:				// Border
						(DOT ^ (PIXELS[8] ^	(PIXELS[12] & CLK_1HZ)))	?  PIXELS[9]:		// Foreground
																							PIXELS[13];		// Background

assign GREEN	=	(V_BLANKING | H_BLANKING)								?	1'b0:
						(DOT ^ (PIXELS[8] ^	(PIXELS[12] & CLK_1HZ)))	?  PIXELS[10]:
																							PIXELS[14];

assign BLUE		=	(V_BLANKING | H_BLANKING)								?	1'b0:
						(DOT ^ (PIXELS[8] ^	(PIXELS[12] & CLK_1HZ)))	?  PIXELS[11]:
																							PIXELS[15];
/****************************************************
* Horizontal
* This needs to be fixed as H_ADD is 10 bits but the case is 11
* Also check to make sure the total is divisable by 8 for pixel count
* because the CPU clock is synced with pixel counts
* maybe do all of this at 50 MHZ
*****************************************************/
always @(negedge CLK)
	case(H_ADD)
		10'd7:										// 8 - First Pixel
		begin
			H_BLANKING <= 1'b0;					// Turn off blanking
			H_SYNC <= 1'b1;						// Not H Sync
			H_ADD  <= 10'd8;						// Next step
		end
		10'd519:										// 520 - First non-Pixel
		begin
			H_BLANKING <= 1'b1;					// Turn on blanking
			H_SYNC <= 1'b1;						// Not H Sync
			H_ADD  <= 10'd520;
		end
		10'd605:										// 604 = 660 - 56 = Start HSync
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b0;						// Start H Sync
			H_ADD  <= 10'd606;
		end
		10'd701:										// 700 = 756 - 56 = End HSync
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b1;						// End H Sync
			H_ADD  <= 10'd702;
		end
		10'd799:										//  End Frame
		begin
			H_BLANKING <= 1'b1;
			H_SYNC <= 1'b1;
			H_ADD  <= 10'd0;
		end
		default:
			H_ADD <= H_ADD + 1;
	endcase
/*******************************************************
* Verticle
********************************************************/
always @(negedge H_SYNC)
	case(V_ADD)
		10'd000:
		begin
			V_BLANKING <= 1'b0;					// Turn off blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_ADD  <= 10'd001;
		end
		10'd255:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_ADD  <= 10'd256;
		end
		10'd263:
		begin
			V_BLANKING <= 1'b0;					// Turn off blanking
			CLOCK <= 1'b1;
			V_SYNC <= 1'b1;						// No V Sync
			V_ADD  <= 10'd264;
		end
		10'd271:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_ADD  <= 10'd272;
		end
		10'd391:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b0;						// V Sync
			V_ADD  <= 10'd392;
		end
		10'd393:
		begin
			V_BLANKING <= 1'b1;					// Turn on blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// V Sync
			V_ADD  <= 10'd394;
		end
		10'd520:
		begin
			V_BLANKING <= 1'b0;					// Turn off blanking
			CLOCK <= 1'b0;
			V_SYNC <= 1'b1;						// No V Sync
			V_ADD  <= 10'd000;
		end
		default:
			V_ADD <= V_ADD + 1;
	endcase
endmodule


