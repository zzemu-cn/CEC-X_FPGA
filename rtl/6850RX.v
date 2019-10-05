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

module UART_RX(
RESET_N,
BAUD_CLK,
E,
REG_READ,
RX_DATA,
RX_BUFFER,
RX_READY,
RX_WORD,
RX_PAR_DIS,
RX_PARITY,
PARITY_ERR,
OVERRUN,
FRAME
);
input					RESET_N;
input					BAUD_CLK;
input					E;
input					REG_READ;
input					RX_DATA;
output	[7:0]		RX_BUFFER;
reg		[7:0]		RX_BUFFER;
output				RX_READY;
reg					RX_READY;
input					RX_WORD;
input					RX_PAR_DIS;
input					RX_PARITY;
output				PARITY_ERR;
reg					PARITY_ERR;
output				OVERRUN;
reg					OVERRUN;
output				FRAME;
reg					FRAME;
reg		[5:0]		STATE;
reg		[2:0]		BIT;
reg		[1:0]		READ_STATE;


always @ (negedge E or negedge RESET_N)
begin
	if(~RESET_N)
	begin
		RX_READY <= 1'b0;
		READ_STATE <= 2'b00;
	end
	else
		case (READ_STATE)
		2'b00:
		begin
			if(STATE == 6'b111000)			//Stop bit 
			begin
				RX_READY <= 1'b1;
				READ_STATE <= 2'b01;
			end
		end
		2'b01:
		begin
			if(REG_READ)
			begin
				RX_READY <= 1'b0;
				READ_STATE <= 2'b10;
			end
		end
		2'b10:
		begin	
			if(STATE != 6'b111000)
				READ_STATE <= 2'b00;
		end
		endcase
end

always @ (posedge BAUD_CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		RX_BUFFER <= 8'h00;
		STATE <= 6'b000000;
		OVERRUN <= 1'b0;
		FRAME <= 1'b0;
		BIT <= 3'b000;
	end
	else
	begin
		case (STATE)
		6'b000000:
		begin
			BIT <= 3'b000;
			if(~RX_DATA)
				STATE <= 6'b000001;
		end
		6'b010111:
		begin
			RX_BUFFER[BIT] <= RX_DATA;
			OVERRUN <= RX_READY;
			STATE <= 6'b011000;
		end
		6'b011111:
		begin
			if(BIT == 3'b111)
				STATE <= 6'b100000;
			else
			begin
				if((BIT == 3'b110) && !RX_WORD)
					STATE <= 6'b100000;
				else
				begin
					BIT <= BIT + 1;
					STATE <= 6'b010000;
				end
			end
		end
		6'b100000:
		begin
			if(RX_PAR_DIS)
				STATE <= 6'b110001;		// get stop
			else
				STATE <= 6'b100001;		// get parity
		end
		6'b100111:
		begin
			PARITY_ERR <=((((RX_BUFFER[0] ^ RX_BUFFER[1])
							 ^  (RX_BUFFER[2] ^ RX_BUFFER[3]))
							 ^ ((RX_BUFFER[4] ^ RX_BUFFER[5])
							 ^  (RX_BUFFER[6] ^ (RX_BUFFER[7] & RX_WORD))))	// clear bit #8 if only 7 bits
							 ^  (RX_PARITY ^ RX_DATA));
			STATE <= 6'b101000;
		end
		6'b110111:							// stop bit
		begin
			OVERRUN <= 1'b0;
			FRAME <= !RX_DATA;			// if data != 1 then not stop bit
			STATE <= 6'b111000;
		end
		6'b111000:
		begin
			if(RX_DATA)						// wait until data = 1
				STATE <= 6'b000000;
		end
		default: STATE <= STATE + 1;
		endcase
	end
end
endmodule
