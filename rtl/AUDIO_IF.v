module AUDIO_IF (
	//	Audio Side
	oAUD_BCLK,
	oAUD_DACLRCK,
	oAUD_DACDAT,
	oAUD_ADCLRCK,
	iAUD_ADCDAT,
	//	Control Signals
	iSPK_A,
	iSPK_B,
	iCASS_OUT,
	oCASS_IN_L,
	oCASS_IN_R,
	// System
	iCLK_18_4,
	iRST_N
);

//parameter	REF_CLK			=	18432000;	//	18.432	MHz
//parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
//parameter	CHANNEL_NUM		=	2;			//	Dual Channel

parameter	SND_SAMPLE_DATA	=	48;


// REF_CLK/(SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1)

//	Audio Side
(*keep*)output			oAUD_BCLK;
output				oAUD_DACDAT;
output				oAUD_DACLRCK;
output				oAUD_ADCLRCK;
input				iAUD_ADCDAT;
//	Control Signals
input				iSPK_A;
input				iSPK_B;
input		[1:0]	iCASS_OUT;
output				oCASS_IN_L;
output				oCASS_IN_R;
// System
input				iCLK_18_4;
input				iRST_N;

//input [9:0] iRight;
//input [9:0] iLeft;

//output [7:0] sample_high8;

(*keep*)wire				BCLK;
(*keep*)wire		[4:0]	BCLK_CONT;
(*keep*)wire				LRCK;

(*preserve*)reg		[(DATA_WIDTH-1):0]	latched_adc_serial_data_L;
(*preserve*)reg		[(DATA_WIDTH-1):0]	latched_adc_serial_data_R;

//	Internal Registers and Wires
//reg		[3:0]	SEL_Cont;
////////	DATA Counter	////////
reg		[5:0]	Snd_Cont;

////////////////////////////////////
//wire		[DATA_WIDTH-1:0]	Snd_Out;


reg		SPK_A;
reg		SPK_B;
reg		CASS_OUT;

wire 	[15:0]	sample;


// CLOCK Generator

AUDIO_CLOCK AUD_CLOCK(
	//	Audio Side
	BCLK,
	BCLK_CONT,
	LRCK,
	//	Control Signals
	iCLK_18_4,
	iRST_N
);

assign	oAUD_BCLK = BCLK;
assign	oAUD_DACLRCK = LRCK;
assign	oAUD_ADCLRCK = LRCK;


// DAC

//////////////////////////////////////////////////
//////////	Sin LUT ADDR Generator	//////////////
always@(negedge LRCK or negedge iRST_N)
begin
	if(!iRST_N)
	Snd_Cont	<=	0;
	else
	begin
		if(Snd_Cont < SND_SAMPLE_DATA-1 )
		Snd_Cont	<=	Snd_Cont+1;
		else
		Snd_Cont	<=	0;
	end
end

/*
//////////////////////////////////////////////////
//////////	16 Bits PISO MSB First	//////////////
always@(negedge oAUD_BCLK or negedge iRST_N)
begin
	if(!iRST_N)
		SEL_Cont	<=	0;
	else
		SEL_Cont	<=	SEL_Cont+1;
end
*/

assign	oAUD_DACDAT	= sample[~BCLK_CONT[3:0]];

//assign	sample = Snd_Out;
//assign	sample = LRCK ? (latched_adc_serial_data_L) : (latched_adc_serial_data_R);

// 左喇叭发声，右录音输入
//assign	sample = LRCK ? ((iSPK_A==iSPK_B)?16'h0000:iSPK_A?16'h6000:16'hA000) : (latched_adc_serial_data_L);
assign	sample = LRCK ? ( (iCASS_OUT[0]==iCASS_OUT[1]) ? 16'h0000 : (iCASS_OUT[1]?16'h6000:16'hA000) ) : ((iSPK_A==iSPK_B)?16'h0000:iSPK_A?16'h6000:16'hA000);

//////////////////////////////////////////////////
////////////	Sin Wave ROM Table	//////////////

// 未使用，打算改善喇叭输入的音质
/*
//wave_gen_brass snd_tbl
//wave_gen_ramp snd_tbl
//wave_gen_string snd_tbl
//wave_gen_square	snd_tbl
wave_gen_sin snd_tbl
(
	.ramp(Snd_Cont),
	.music_o(Snd_Out)
);
*/

// ADC

(*keep*)reg							reg_adc_left;
(*preserve*)reg		[(DATA_WIDTH-1):0]	adc_serial_data_L;
(*preserve*)reg		[(DATA_WIDTH-1):0]	adc_serial_data_R;

(*preserve*)reg		[(DATA_WIDTH-1+1):0]			avg_adc_serial_data_L;
(*preserve*)reg		[(DATA_WIDTH-1+1):0]			avg_adc_serial_data_R;


(*keep*)wire is_left_ch = ~LRCK;

always@(posedge BCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		reg_adc_left <= is_left_ch;
	end
	else
	begin
		if (reg_adc_left ^ is_left_ch)
		begin		// channel change
			reg_adc_left <= is_left_ch;
		end

		// serial bit to reg

		if(BCLK_CONT == 0)
		begin
			if(LRCK)
			begin
				//adc_serial_data_L[(DATA_WIDTH-1):0] <= {iAUD_ADCDAT,15'b0};
				adc_serial_data_L[(DATA_WIDTH-1):0] <= {15'b0,iAUD_ADCDAT};
			end
			else
			begin
				//adc_serial_data_R[(DATA_WIDTH-1):0] <= {iAUD_ADCDAT,15'b0};
				adc_serial_data_R[(DATA_WIDTH-1):0] <= {15'b0,iAUD_ADCDAT};
			end
		end
		else
		begin
			if(LRCK)
			begin
				//adc_serial_data_L[(DATA_WIDTH-1):0] <= {iAUD_ADCDAT, adc_serial_data_L[(DATA_WIDTH-1):1]};
				adc_serial_data_L[(DATA_WIDTH-1):0] <= {adc_serial_data_L[(DATA_WIDTH-1-1):0],iAUD_ADCDAT};
				//adc_serial_data_L[(DATA_WIDTH-1):0] <= {adc_serial_data_L[14:0],iAUD_ADCDAT};
			end
			else
			begin
				//adc_serial_data_R[(DATA_WIDTH-1):0] <= {iAUD_ADCDAT, adc_serial_data_R[(DATA_WIDTH-1):1]};
				adc_serial_data_R[(DATA_WIDTH-1):0] <= {adc_serial_data_R[(DATA_WIDTH-1-1):0],iAUD_ADCDAT};
				//adc_serial_data_R[(DATA_WIDTH-1):0] <= {adc_serial_data_R[14:0],iAUD_ADCDAT};
			end
		end

		if(BCLK_CONT == 16)
		begin  // write data to adcfifo
			if(LRCK)
				latched_adc_serial_data_L <= adc_serial_data_L;
			else
				latched_adc_serial_data_R <= adc_serial_data_R;
			// 计算与上一个采样的平均数,左右通道最高7位相加
			if(LRCK)
			begin
				//avg_adc_serial_data_L <= {1'b0,~latched_adc_serial_data_L[15],latched_adc_serial_data_L[14:0]} + {1'b0,~adc_serial_data_L[15],adc_serial_data_L[14:0]};
				avg_adc_serial_data_L <= {~latched_adc_serial_data_L[15],latched_adc_serial_data_L[14:0]} + {~adc_serial_data_L[15],adc_serial_data_L[14:0]};
			end
			else
			begin
				//avg_adc_serial_data_R <= {1'b0,~latched_adc_serial_data_R[15],latched_adc_serial_data_R[14:0]} + {1'b0,~adc_serial_data_R[15],adc_serial_data_R[14:0]};
				avg_adc_serial_data_R <= {~latched_adc_serial_data_R[15],latched_adc_serial_data_R[14:0]} + {~adc_serial_data_R[15],adc_serial_data_R[14:0]};
			end
		end
	end
end

//assign oCASS_IN_L = avg_adc_serial_data_L[16] && avg_adc_serial_data_L[15];
//assign oCASS_IN_L = avg_adc_serial_data_L[16] && (avg_adc_serial_data_L[15:14]!=2'b0);
assign oCASS_IN_L = avg_adc_serial_data_L[16] && (avg_adc_serial_data_L[15:13]!=3'b0);
//assign oCASS_IN_L = avg_adc_serial_data_L[16] && (avg_adc_serial_data_L[15:12]!=4'b0);

//assign oCASS_IN_R = avg_adc_serial_data_R[16] && avg_adc_serial_data_R[15];
//assign oCASS_IN_R = avg_adc_serial_data_R[16] && (avg_adc_serial_data_R[15:14]!=2'b0);
//assign oCASS_IN_R = avg_adc_serial_data_R[16] && (avg_adc_serial_data_R[15:13]!=3'b0);
//assign oCASS_IN_R = avg_adc_serial_data_R[16] && (avg_adc_serial_data_R[15:12]!=4'b0);

//assign oCASS_IN_L = (~latched_adc_serial_data_L[15]) && (latched_adc_serial_data_L[14:12]!=3'b0);
//assign oCASS_IN_R = (~latched_adc_serial_data_R[15]) && (latched_adc_serial_data_R[14:12]!=3'b0);

// 防止信号被优化
assign oCASS_IN_R = (avg_adc_serial_data_L==17'b0) && (avg_adc_serial_data_R==17'b0);

endmodule
