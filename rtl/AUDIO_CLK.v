module AUDIO_CLOCK (
					//	Audio Side
					BCLK,
					BCLK_CONT,
					LRCK,
					//	Control Signals
				    iCLK_18_4,
					iRST_N
					);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

//	Audio Side
output	reg				LRCK;
output	reg				BCLK;
output	reg		[4:0]	BCLK_CONT;

input					iCLK_18_4;
input					iRST_N;

//	Internal Registers and Wires
reg	[3:0]	BCLK_DIV;

////////////	AUD_BCLK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCLK_DIV		<=	0;
		BCLK			<=	0;
	end
	else
	begin
		if( BCLK_DIV >= REF_CLK/(SAMPLE_RATE*(DATA_WIDTH+2)*CHANNEL_NUM*2)-1 )
		begin
			BCLK_DIV		<=	0;
			BCLK			<=	~BCLK;
		end
		else
			BCLK_DIV		<=	BCLK_DIV+1;
	end
end

//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
always@(posedge BCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCLK_CONT	<=	0;
		LRCK		<=	0;
	end
	else
	begin
		if(BCLK_CONT==(DATA_WIDTH+1))
		begin
			BCLK_CONT	<=	0;
			LRCK		<=	~LRCK;
		end
		else
		begin
			BCLK_CONT	<=	BCLK_CONT+1;
		end
	end
end

endmodule


