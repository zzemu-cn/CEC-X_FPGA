/*****************************************************************************
* gbfpgaapple APPLE ][e core.
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
*******************************************************************************/
module glb6850(
RESET_N,
RX_CLK,
TX_CLK,
E,
DI,
DO,
CS,
RW_N,
RS,
TXDATA,
RXDATA,
RTS,
CTS,
DCD
);

input					RESET_N;
input					RX_CLK;
input					TX_CLK;
input					E;
input		[7:0]		DI;
output	[7:0]		DO;
input					CS;
input					RS;
input					RW_N;
output				TXDATA;
input					RXDATA;
output				RTS;
input					CTS;
input					DCD;

reg		[7:0]		TX_BUFFER;
reg		[7:0]		TX_REG;
wire		[7:0]		RX_BUFFER;
reg		[10:0]	RX_REG;
wire		[7:0]		STATUS_REG;
reg		[7:0]		CTL_REG;
wire		[2:0]		CONTROL;
wire					TX_DONE;
reg					TX_START;
wire					RX_READY;
reg					TDRE;
reg					RDRF;
reg		[1:0]		TX_CLK_DIV;
reg		[1:0]		RX_CLK_DIV;
wire					TX_CLK_X;
wire					RX_CLK_X;
wire					FRAME;
wire					OVERRUN;
wire		[1:0]		COUNTER_DIVIDE;
wire					WORD_SELECT;
wire		[1:0]		TX_CTL;
wire					RXIE;
wire					RESET_X;
wire					STOP;
wire					PARITY_ERR;
wire					PAR_DIS;

always @ (negedge TX_CLK)
	TX_CLK_DIV <= TX_CLK_DIV +1'b1;

always @ (posedge RX_CLK)
	RX_CLK_DIV <= RX_CLK_DIV +1'b1;

assign TX_CLK_X = (COUNTER_DIVIDE == 2'b10) ?	TX_CLK_DIV[1]:
																TX_CLK;
assign RX_CLK_X = (COUNTER_DIVIDE == 2'b10) ?	RX_CLK_DIV[1]:
																RX_CLK;

assign RESET_X = (COUNTER_DIVIDE == 2'b11) ?	1'b0:
															RESET_N;
//							IRQ   PE
assign STATUS_REG = {1'b0, RX_REG[10], RX_REG[9], RX_REG[8], CTS, DCD, TDRE, RDRF};
assign CONTROL = {RW_N, CS, RS};
assign DO =	({E, CONTROL} == 4'b1110)	?	STATUS_REG:
														RX_REG[7:0];

assign COUNTER_DIVIDE = CTL_REG[1:0];
assign WORD_SELECT =	CTL_REG[4];
assign TX_CTL = CTL_REG[6:5];
assign RXIE = CTL_REG[7];
assign RTS = (TX_CTL == 2'b10);
assign STOP =	(CTL_REG[4:2] == 3'b000) ? 1'b1:
					(CTL_REG[4:2] == 3'b001) ? 1'b1:
					(CTL_REG[4:2] == 3'b100) ? 1'b1: 1'b0;
assign PAR_DIS =(CTL_REG[4:2] == 3'b100) ? 1'b1:
					 (CTL_REG[4:2] == 3'b101) ? 1'b1: 1'b0;

always @ (negedge E or negedge RESET_X)
begin
	if(!RESET_X)
	begin
		RDRF <= 1'b0;
		TX_BUFFER <= 8'h00;
		CTL_REG <= 8'h00;
		TDRE <= 1'b1;
		TX_START <= 1'b0;
	end
	else
	begin
		if(CONTROL == 3'b111)						// Read RX Data register
			RDRF <= 1'b0;
		else if(~RDRF & RX_READY)
			RDRF <= 1'b1;

		if(CONTROL == 3'b011)						// Write TX data register
			TX_REG <= DI;

		if(CONTROL == 3'b010)						// Write CTL register
			CTL_REG <= DI;

		if(~TDRE & TX_DONE & ~TX_START)
		begin
			TX_BUFFER <= TX_REG;
			TX_START <= 1'b1;
		end
		else if(~TX_DONE)
			TX_START <= 1'b0;

		if(~TDRE & TX_DONE & ~TX_START)
			TDRE <= 1'b1;
		else if(CONTROL == 3'b011)				// Write TX data register
			TDRE <= 1'b0;

		if(~RDRF & RX_READY)						// Read RX Data register
		begin
			RX_REG <= {(PARITY_ERR & !PAR_DIS), OVERRUN, FRAME, RX_BUFFER};
		end
	end
end

UART_TX TX(
.BAUD_CLK(TX_CLK_X),
.RESET_N(RESET_X),
.TX_DATA(TXDATA),
.TX_START(TX_START),
.TX_DONE(TX_DONE),
.TX_STOP(STOP),
.TX_WORD(WORD_SELECT),
.TX_PAR_DIS(PAR_DIS),
.TX_PARITY(CTL_REG[2]),
.TX_BUFFER(TX_BUFFER)
);

UART_RX RX(
.RESET_N(RESET_X),
.BAUD_CLK(RX_CLK_X),
.E(E),
.REG_READ(CONTROL == 3'b111),
.RX_DATA(RXDATA),
.RX_BUFFER(RX_BUFFER),
.RX_READY(RX_READY),
.RX_WORD(WORD_SELECT),
.RX_PAR_DIS(PAR_DIS),
.RX_PARITY(CTL_REG[2]),
.PARITY_ERR(PARITY_ERR),
.OVERRUN(OVERRUN),
.FRAME(FRAME)
);

endmodule
