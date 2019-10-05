/*****************************************************************************
* Convert PS/2 keyboard to ASCII keyboard
******************************************************************************/

module APPLE_KEYBOARD
(
	input				KB_CLK,
	input				SYS_RESET_N,
	input				RESET_N,
	input				CLR_STB,

	input				PS2_KBCLK,
	input				PS2_KBDAT,

	output				A_KEY_PRESSED,
	output	reg			APPLE_PRESSED,
	output	reg	[6:0]	ASCII,
	output	reg			CAPS,
	output				L_SHIFT,
	output				R_SHIFT,
	output				L_ALT,
	output				R_ALT,
	output				RESET_KEY_N
);

reg		[79:0]		KEY;
reg		[71:0]		LAST_KEY;
reg					CAPS_CLK;
wire	[7:0]		SCAN;
wire				PRESS;
wire				EXTENDED;

reg		[16:0]		RESET_KEY_COUNT;

assign RESET_KEY_N = RESET_KEY_COUNT[16];

assign	L_SHIFT=KEY[1];
assign	R_SHIFT=KEY[2];
assign	L_ALT=KEY[7];
assign	R_ALT=KEY[44];


`ifdef SIMULATE
initial
	begin
		LAST_KEY = 72'b0;
	end
`endif

always @(posedge KB_CLK or posedge CLR_STB)
begin
	if(CLR_STB)
		APPLE_PRESSED <= 1'b0;
	else
	if(LAST_KEY != {KEY[78:45],KEY[43:8],KEY[5:4]})
	begin
		LAST_KEY <= {KEY[78:45],KEY[43:8],KEY[5:4]};
		APPLE_PRESSED <= APPLE_PRESSED | PRESS;
	end
	else
	// 处理组合键 Ctrl Reset Test
	// Test 键先按时，读键盘操作会清标志；这里强制设置读取标志
	if( {KEY[6], KEY[79], KEY[72], RESET_N}==4'b1110)
		APPLE_PRESSED <= 1'b1;
end
	
assign A_KEY_PRESSED = (KEY[79:1] == 79'h0000000000000000)	?	1'b0:	1'b1;

always @(posedge KB_CLK or negedge SYS_RESET_N)
begin
	if(~SYS_RESET_N)
	begin
		KEY <= 80'h1;
		CAPS_CLK <= 1'b0;
		ASCII <= 7'h20;
		RESET_KEY_COUNT <= 17'h1FFFF;
	end
	else
	begin
		KEY[0] <= CAPS;

		if(RESET_KEY_COUNT[16]==1'b0)
			RESET_KEY_COUNT <= RESET_KEY_COUNT+1;

		case(SCAN)

		8'h07:
		begin
			KEY[79] <= PRESS;	// F12 Reset
			if(PRESS && (KEY[6]==PRESS) && (KEY[79]!=PRESS))
				RESET_KEY_COUNT <= 17'h0;
		end

		8'h78:
		begin
			KEY[72] <= PRESS;	// F11 Test
			if(PRESS && (KEY[72]!=PRESS))
				ASCII <= 7'h16;
		end

		8'h01:
		begin
			KEY[71] <= PRESS;	// F9 Quit
			if(PRESS && (KEY[71]!=PRESS))
				ASCII <= 7'h03;
		end

		8'h05:
		begin
			KEY[70] <= PRESS;	// F1
			if(PRESS && (KEY[70]!=PRESS))
				ASCII <= 7'h01;
		end

		8'h06:
		begin
			KEY[69] <= PRESS;	// F2
			if(PRESS && (KEY[69]!=PRESS))
				ASCII <= 7'h0C;
		end
		8'h04:
		begin
			KEY[68] <= PRESS;	// F3
			if(PRESS && (KEY[68]!=PRESS))
				ASCII <= 7'h17;
		end
		8'h0C:
		begin
			KEY[67] <= PRESS;	// F4
			if(PRESS && (KEY[67]!=PRESS))
				ASCII <= 7'h14;
		end
		8'h03:
		begin
			KEY[66] <= PRESS;	// F5
			if(PRESS && (KEY[66]!=PRESS))
				ASCII <= 7'h06;
		end


		8'h83:
		begin
			KEY[65] <= PRESS;	// F7 中文
			if(PRESS && (KEY[65]!=PRESS))
				ASCII <= 7'h1F;
		end

		8'h0A:
		begin
			KEY[64] <= PRESS;	// F8 西文
			if(PRESS && (KEY[64]!=PRESS))
				ASCII <= 7'h11;
		end

		8'h16:
		begin
			KEY[63] <= PRESS;	// 1 !
			if(PRESS && (KEY[63]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h21;
				else
					ASCII <= 7'h31;
			end
		end
		8'h1E:
		begin
			KEY[62] <= PRESS;	// 2 @
			if(PRESS && (KEY[62]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h40;
				else
					ASCII <= 7'h32;
			end
		end
		8'h26:
		begin
			KEY[61] <= PRESS;	// 3 #
			if(PRESS && (KEY[61]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h23;
				else
					ASCII <= 7'h33;
			end
		end
		8'h25:
		begin
			KEY[60] <= PRESS;	// 4 $
			if(PRESS && (KEY[60]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h24;
				else
					ASCII <= 7'h34;
			end
		end
		8'h2E:
		begin
			KEY[59] <= PRESS;	// 5 %
			if(PRESS && (KEY[59]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h25;
				else
					ASCII <= 7'h35;
			end
		end
		8'h36:
		begin
			KEY[58] <= PRESS;	// 6 ^
			if(PRESS && (KEY[58]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h5E;
				else
					ASCII <= 7'h36;
			end
		end
		8'h3D:
		begin
			KEY[57] <= PRESS;	// 7 &
			if(PRESS && (KEY[57]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h26;
				else
					ASCII <= 7'h37;
			end
		end
		8'h0D:
		begin
			KEY[56] <= PRESS;	// TAB
			if(PRESS && (KEY[56]!=PRESS))
					ASCII <= 7'h09;
		end
		8'h3E:
		begin
			KEY[55] <= PRESS;	// 8 *
			if(PRESS && (KEY[55]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h2A;
				else
					ASCII <= 7'h38;
			end
		end
		8'h46:
		begin
			KEY[54] <= PRESS;	// 9 (
			if(PRESS && (KEY[54]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h28;
				else
					ASCII <= 7'h39;
			end
		end
		8'h45:
		begin
			KEY[53] <= PRESS;	// 0 )
			if(PRESS && (KEY[53]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h29;
				else
					ASCII <= 7'h30;
			end
		end
		8'h4E:
		begin
			KEY[52] <= PRESS;	// - _
			if(PRESS && (KEY[52]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h5F;
				else
					ASCII <= 7'h2D;
			end
		end
		8'h55:
		begin
			KEY[51] <= PRESS;	// = +
			if(PRESS && (KEY[51]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h2B;
				else
					ASCII <= 7'h3D;
			end
		end
		8'h66:
		begin
			KEY[50] <= PRESS;	// backspace
			if(PRESS && (KEY[50]!=PRESS))
			begin
				ASCII <= 7'h08;
			end
		end
		8'h0E:
		begin
			KEY[49] <= PRESS;	// ` ~
			if(PRESS && (KEY[49]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h7E;
				else
					ASCII <= 7'h60;
			end
		end
		8'h5D:
		begin
			KEY[48] <= PRESS;	// \ |
			if(PRESS && (KEY[48]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h7C;
				else
					ASCII <= 7'h5C;
			end
		end
		8'h49:
		begin
			KEY[47] <= PRESS;	// . >
			if(PRESS && (KEY[47]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h3E;
				else
					ASCII <= 7'h2E;
			end
		end
		8'h4b:
		begin
			KEY[46] <= PRESS;	// L
			if(PRESS && (KEY[46]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0C;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4C;
					else
						ASCII <= 7'h6C;
				end
			end
		end
		8'h44:
		begin
			KEY[45] <= PRESS;	// O
			if(PRESS && (KEY[45]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0F;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4F;
					else
						ASCII <= 7'h6F;
				end
			end
		end
//		8'h11			KEY[44] <= PRESS; // line feed (really right ALT (Extended) see below
		8'h5A:
		begin
			KEY[43] <= PRESS;	// CR
			if(PRESS && (KEY[43]!=PRESS))
			begin
				ASCII <= 7'h0D;
			end
		end
		8'h54:
		begin
			KEY[42] <= PRESS;	// [ {
			if(PRESS && (KEY[42]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h7B;
				else
					ASCII <= 7'h5B;
			end
		end
		8'h5B:
		begin
			KEY[41] <= PRESS;	// ] }
			if(PRESS && (KEY[41]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h7D;
				else
					ASCII <= 7'h5D;
			end
		end
		8'h52:
		begin
			KEY[40] <= PRESS;	// ' "
			if(PRESS && (KEY[40]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h22;
				else
					ASCII <= 7'h27;
			end
		end
		8'h1D:
		begin
			KEY[39] <= PRESS;	// W
			if(PRESS && (KEY[39]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h17;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h57;
					else
						ASCII <= 7'h77;
				end
			end
		end
		8'h24:
		begin
			KEY[38] <= PRESS;	// E
			if(PRESS && (KEY[38]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h05;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h45;
					else
						ASCII <= 7'h65;
				end
			end
		end
		8'h2D:
		begin
			KEY[37] <= PRESS;	// R
			if(PRESS && (KEY[37]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h12;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h52;
					else
						ASCII <= 7'h72;
				end
			end
		end
		8'h2C:
		begin
			KEY[36] <= PRESS;	// T
			if(PRESS && (KEY[36]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h14;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h54;
					else
						ASCII <= 7'h74;
				end
			end
		end
		8'h35:
		begin
			KEY[35] <= PRESS;	// Y
			if(PRESS && (KEY[35]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h19;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h59;
					else
						ASCII <= 7'h79;
				end
			end
		end
		8'h3C:
		begin
			KEY[34] <= PRESS;	// U
			if(PRESS && (KEY[34]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h15;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h55;
					else
						ASCII <= 7'h75;
				end
			end
		end
		8'h43:
		begin
			KEY[33] <= PRESS;	// I
			if(PRESS && (KEY[33]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h09;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h49;
					else
						ASCII <= 7'h69;
				end
			end
		end
		8'h75:
		begin
			KEY[32] <= PRESS;	// up
			ASCII <= 7'h0B;
		end
		8'h1B:
		begin
			KEY[31] <= PRESS;	// S
			if(PRESS && (KEY[31]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h13;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h53;
					else
						ASCII <= 7'h73;
				end
			end
		end
		8'h23:
		begin
			KEY[30] <= PRESS;	// D
			if(PRESS && (KEY[30]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h04;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h44;
					else
						ASCII <= 7'h64;
				end
			end
		end
		8'h2B:
		begin
			KEY[29] <= PRESS;	// F
			if(PRESS && (KEY[29]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h06;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h46;
					else
						ASCII <= 7'h66;
				end
			end
		end
		8'h34:
		begin
			KEY[28] <= PRESS;	// G
			if(PRESS && (KEY[28]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h07;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h47;
					else
						ASCII <= 7'h67;
				end
			end
		end
		8'h33:
		begin
			KEY[27] <= PRESS;	// H
			if(PRESS && (KEY[27]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h08;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h48;
					else
						ASCII <= 7'h68;
				end
			end
		end
		8'h3B:
		begin
			KEY[26] <= PRESS;	// J
			if(PRESS && (KEY[26]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0A;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4A;
					else
						ASCII <= 7'h6A;
				end
			end
		end
		8'h42:
		begin
			KEY[25] <= PRESS;	// K
			if(PRESS && (KEY[25]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0B;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4B;
					else
						ASCII <= 7'h6B;
				end
			end
		end
		8'h74:
		begin
			KEY[24] <= PRESS;	// right
			ASCII <= 7'h15;
		end
		8'h22:
		begin
			KEY[23] <= PRESS;	// X
			if(PRESS && (KEY[23]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h18;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h58;
					else
						ASCII <= 7'h78;
				end
			end
		end
		8'h21:
		begin
			KEY[22] <= PRESS;	// C
			if(PRESS && (KEY[22]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h03;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h43;
					else
						ASCII <= 7'h63;
				end
			end
		end
		8'h2a:
		begin
			KEY[21] <= PRESS;	// V
			if(PRESS && (KEY[21]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h16;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h56;
					else
						ASCII <= 7'h76;
				end
			end
		end
		8'h32:
		begin
			KEY[20] <= PRESS;	// B
			if(PRESS && (KEY[20]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h02;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h42;
					else
						ASCII <= 7'h62;
				end
			end
		end
		8'h31:
		begin
			KEY[19] <= PRESS;	// N
			if(PRESS && (KEY[19]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0E;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4E;
					else
						ASCII <= 7'h6E;
				end
			end
		end
		8'h3a:
		begin
			KEY[18] <= PRESS;	// M
			if(PRESS && (KEY[18]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h0D;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h4D;
					else
						ASCII <= 7'h6D;
				end
			end
		end
		8'h41:
		begin
			KEY[17] <= PRESS;	// , <
			if(PRESS && (KEY[17]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h3C;
				else
					ASCII <= 7'h2C;
			end
		end
		8'h6B:
		begin
			KEY[16] <= PRESS;	// left
			ASCII <= 7'h08;
		end
		8'h15:
		begin
			KEY[15] <= PRESS;	// Q
			if(PRESS && (KEY[15]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h11;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h51;
					else
						ASCII <= 7'h71;
				end
			end
		end
		8'h1C:
		begin
			KEY[14] <= PRESS;	// A
			if(PRESS && (KEY[14]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h01;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h41;
					else
						ASCII <= 7'h61;
				end
			end
		end
		8'h1A:
		begin
			KEY[13] <= PRESS;	// Z
			if(PRESS && (KEY[13]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h1A;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h5A;
					else
						ASCII <= 7'h7A;
				end
			end
		end
		8'h29:
		begin
			KEY[12] <= PRESS;	// Space
			ASCII <= 7'h20;
		end
		8'h4A:
		begin
			KEY[11] <= PRESS;	// / ?
			if(PRESS && (KEY[11]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h3F;
				else
					ASCII <= 7'h2F;
			end
		end
		8'h4C:
		begin
			KEY[10] <= PRESS;	// ; :
			if(PRESS && (KEY[10]!=PRESS))
			begin
				if(KEY[1] || KEY[2])
					ASCII <= 7'h3A;
				else
					ASCII <= 7'h3B;
			end
		end
		8'h4D:
		begin
			KEY[9] <= PRESS;	// P
			if(PRESS && (KEY[9]!=PRESS))
			begin
				if(KEY[6])
					ASCII <= 7'h10;
				else
				begin
					if(CAPS || KEY[1] || KEY[2])
						ASCII <= 7'h50;
					else
						ASCII <= 7'h70;
				end
			end
		end
		8'h72:
		begin
			KEY[8] <= PRESS;	// down
			ASCII <= 7'h0A;
		end
		8'h11:
		begin
			if(~EXTENDED)
						KEY[7] <= PRESS;	// Repeat really left ALT
			else
						KEY[44] <= PRESS;	// LF really right ALT
		end
		8'h14:		KEY[6] <= PRESS;	// Ctrl either left or right
		8'h76:
		begin
			KEY[5] <= PRESS;	// Esc
			if(PRESS && (KEY[5]!=PRESS))
			begin
				ASCII <= 7'h1B;
			end
		end
//		8'h2C:		KEY[4] <= PRESS;	// na
//		8'h35:		KEY[3] <= PRESS;	// na
		8'h12:		KEY[2] <= PRESS;	// L-Shift
		8'h59:		KEY[1] <= PRESS;	// R-Shift
		8'h58:		CAPS_CLK <= PRESS;	// Caps
		endcase
	end
end

always @(posedge CAPS_CLK or negedge SYS_RESET_N)
begin
	if(~SYS_RESET_N)
		CAPS <= 1'b0;
		//CAPS <= 1'b1;
	else
		CAPS <= ~CAPS;
end


ps2_keyboard KEYBOARD(
		.RESET_N(SYS_RESET_N),
		.CLK(KB_CLK),
		.PS2_CLK(PS2_KBCLK),
		.PS2_DATA(PS2_KBDAT),
		.RX_SCAN(SCAN),
		.RX_PRESSED(PRESS),
		.RX_EXTENDED(EXTENDED)
);

endmodule 
