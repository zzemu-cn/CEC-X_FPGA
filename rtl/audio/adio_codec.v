module adio_codec (
output			oAUD_DATA,
output			oAUD_LRCK,
output	reg		oAUD_BCK,
input key1_on,
input key2_on,
input key3_on,
input key4_on,

input	[1:0]	iSrc_Select,
input			iCLK_18_4,
input			iRST_N,
input   [15:0]	sound1,
input   [15:0]	sound2,
input   [15:0]	sound3,
input   [15:0]	sound4,

input           instru

						);				

parameter	REF_CLK			=	18432000;	//	18.432	MHz
parameter	SAMPLE_RATE		=	48000;		//	48		KHz
parameter	DATA_WIDTH		=	16;			//	16		Bits
parameter	CHANNEL_NUM		=	2;			//	Dual Channel

parameter	SIN_SAMPLE_DATA	=	48;



////////////	Input Source Number	//////////////
parameter	SIN_SANPLE		=	0;
//////////////////////////////////////////////////
//	Internal Registers and Wires
reg		[3:0]	BCK_DIV;
reg		[8:0]	LRCK_1X_DIV;
reg		[7:0]	LRCK_2X_DIV;
reg		[6:0]	LRCK_4X_DIV;
reg		[3:0]	SEL_Cont;
////////	DATA Counter	////////
reg		[5:0]	SIN_Cont;
////////////////////////////////////
reg							LRCK_1X;
reg							LRCK_2X;
reg							LRCK_4X;

////////////	AUD_BCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		BCK_DIV		<=	0;
		oAUD_BCK	<=	0;
	end
	else
	begin
		if(BCK_DIV >= REF_CLK/(SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1 )
		begin
			BCK_DIV		<=	0;
			oAUD_BCK	<=	~oAUD_BCK;
		end
		else
		BCK_DIV		<=	BCK_DIV+1;
	end
end
//////////////////////////////////////////////////
////////////	AUD_LRCK Generator	//////////////
always@(posedge iCLK_18_4 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LRCK_1X_DIV	<=	0;
		LRCK_2X_DIV	<=	0;
		LRCK_4X_DIV	<=	0;
		LRCK_1X		<=	0;
		LRCK_2X		<=	0;
		LRCK_4X		<=	0;
	end
	else
	begin
		//	LRCK 1X
		if(LRCK_1X_DIV >= REF_CLK/(SAMPLE_RATE*2)-1 )
		begin
			LRCK_1X_DIV	<=	0;
			LRCK_1X	<=	~LRCK_1X;
		end
		else
		LRCK_1X_DIV		<=	LRCK_1X_DIV+1;
		//	LRCK 2X
		if(LRCK_2X_DIV >= REF_CLK/(SAMPLE_RATE*4)-1 )
		begin
			LRCK_2X_DIV	<=	0;
			LRCK_2X	<=	~LRCK_2X;
		end
		else
		LRCK_2X_DIV		<=	LRCK_2X_DIV+1;		
		//	LRCK 4X
		if(LRCK_4X_DIV >= REF_CLK/(SAMPLE_RATE*8)-1 )
		begin
			LRCK_4X_DIV	<=	0;
			LRCK_4X	<=	~LRCK_4X;
		end
		else
		LRCK_4X_DIV		<=	LRCK_4X_DIV+1;		
	end
end
assign	oAUD_LRCK	=	LRCK_1X;
//////////////////////////////////////////////////
//////////	Sin LUT ADDR Generator	//////////////
always@(negedge LRCK_1X or negedge iRST_N)
begin
	if(!iRST_N)
	SIN_Cont	<=	0;
	else
	begin
		if(SIN_Cont < SIN_SAMPLE_DATA-1 )
		SIN_Cont	<=	SIN_Cont+1;
		else
		SIN_Cont	<=	0;
	end
end


///////////////////Wave-Source generate////////////////
////////////Timbre selection & SoundOut///////////////
	wire [15:0]music1_ramp;
	wire [15:0]music2_ramp;
	wire [15:0]music1_sin;
	wire [15:0]music2_sin;
	wire [15:0]music3_ramp;
	wire [15:0]music4_ramp;
	wire [15:0]music3_sin;
	wire [15:0]music4_sin;
	wire [15:0]music1=(instru)?music1_ramp:music1_sin;
	wire [15:0]music2=(instru)?music2_ramp:music2_sin;
	wire [15:0]music3=(instru)?music3_ramp:music3_sin;
	wire [15:0]music4=(instru)?music4_ramp:music4_sin;
	wire [15:0]sound_o;
	assign sound_o=music1+music2+music3+music4;	
	always@(negedge oAUD_BCK or negedge iRST_N)begin
		if(!iRST_N)
			SEL_Cont	<=	0;
		else
			SEL_Cont	<=	SEL_Cont+1;
	end
	assign	oAUD_DATA	=	((key4_on|key3_on|key2_on|key1_on) && (iSrc_Select==SIN_SANPLE))	?	sound_o[~SEL_Cont]	:0;

//////////Ramp address generater//////////////
	reg  [15:0]ramp1;
	reg  [15:0]ramp2;
	reg  [15:0]ramp3;
	reg  [15:0]ramp4;
	wire [15:0]ramp_max=60000;
//////CH1 Ramp//////
	always@(negedge key1_on or negedge LRCK_1X)begin
	if (!key1_on)
		ramp1=0;
	else if (ramp1>ramp_max) ramp1=0;
	else ramp1=ramp1+sound1;
	end

//////CH2 Ramp//////
	always@(negedge key2_on or negedge LRCK_1X)begin
	if (!key2_on)
		ramp2=0;
	else if (ramp2>ramp_max) ramp2=0;
	else ramp2=ramp2+sound2;
	end

//////CH3 Ramp/////
	always@(negedge key3_on or negedge LRCK_1X)begin
	if (!key3_on)
		ramp3=0;
	else if (ramp3>ramp_max) ramp3=0;
	else ramp3=ramp3+sound3;
	end

//////CH3 Ramp/////
	always@(negedge key4_on or negedge LRCK_1X)begin
	if (!key4_on)
		ramp4=0;
	else if (ramp4>ramp_max) ramp4=0;
	else ramp4=ramp4+sound4;
	end

////////////Ramp address assign//////////////
	wire [5:0]ramp1_ramp=(instru)?ramp1[15:10]:0;
	wire [5:0]ramp2_ramp=(instru)?ramp2[15:10]:0;
	wire [5:0]ramp3_ramp=(instru)?ramp3[15:10]:0;
	wire [5:0]ramp4_ramp=(instru)?ramp4[15:10]:0;
	wire [5:0]ramp1_sin=(!instru)?ramp1[15:10]:0;
	wire [5:0]ramp2_sin=(!instru)?ramp2[15:10]:0;
	wire [5:0]ramp3_sin=(!instru)?ramp3[15:10]:0;
	wire [5:0]ramp4_sin=(!instru)?ramp4[15:10]:0;

////////String-wave Timbre///////
	wave_gen_string r1(
		.ramp(ramp1_ramp),
		.music_o(music1_ramp)
	);
	wave_gen_string r2(
		.ramp(ramp2_ramp),
		.music_o(music2_ramp)
	);
	wave_gen_string r3(
		.ramp(ramp3_ramp),
		.music_o(music3_ramp)
	);
	wave_gen_string r4(
		.ramp(ramp4_ramp),
		.music_o(music4_ramp)
	);

/////////Brass-wave Timbre////////
	wave_gen_brass s1(
		.ramp(ramp1_sin),
		.music_o(music1_sin)
	);
	wave_gen_brass s2(
		.ramp(ramp2_sin),
		.music_o(music2_sin)
	);
	wave_gen_brass s3(
		.ramp(ramp3_sin),
		.music_o(music3_sin)
	);
	wave_gen_brass s4(
		.ramp(ramp4_sin),
		.music_o(music4_sin)
	);

endmodule