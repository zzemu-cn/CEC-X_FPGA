module I2C_AV_Config (	//	Host Side
						iCLK,
						iRST_N,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT	);
//	Host Side
input		iCLK;
input		iRST_N;
//	I2C Side
output		I2C_SCLK;
inout		I2C_SDAT;
//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[23:0]	mI2C_DATA;
reg			mI2C_CTRL_CLK;
reg			mI2C_GO;
wire		mI2C_END;
wire		mI2C_ACK;
reg	[15:0]	LUT_DATA;
reg	[5:0]	LUT_INDEX;
reg	[3:0]	mSetup_ST;

reg  [9:0] tv_reset_delay_count;

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	LUT Data Number
//parameter	LUT_SIZE	=	51;
//parameter	LUT_SIZE	=	32;
parameter	LUT_SIZE	=	34;
//	Audio Data Index
/*
parameter	Dummy_DATA	=	0;
parameter	SET_LIN_L	=	1;
parameter	SET_LIN_R	=	2;
parameter	SET_HEAD_L	=	3;
parameter	SET_HEAD_R	=	4;
parameter	A_PATH_CTRL	=	5;
parameter	D_PATH_CTRL	=	6;
parameter	POWER_ON	=	7;
parameter	SET_FORMAT	=	8;
parameter	SAMPLE_CTRL	=	9;
parameter	SET_ACTIVE	=	10;
*/

//	Audio Data Index
parameter	Dummy_DATA	=	0;
parameter	REG_REST	=	1;
parameter	SET_LIN_L	=	2;
parameter	SET_LIN_R	=	3;
parameter	SET_HEAD_L	=	4;
parameter	SET_HEAD_R	=	5;
parameter	A_PATH_CTRL	=	6;
parameter	D_PATH_CTRL	=	7;
parameter	POWER_ON	=	8;
parameter	SET_FORMAT	=	9;
parameter	SAMPLE_CTRL	=	10;
parameter	SET_ACTIVE	=	11;

//	Video Data Index
parameter	SET_VIDEO	=	12; 
parameter   VIDEO_RESET       = SET_VIDEO + 1;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
						.ACK(mI2C_ACK),				//	ACK
						.RESET(iRST_N)	);
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
		tv_reset_delay_count <= 10'd0;
	end
	else
	begin
	// TV i2c software reset . Add by Dee
	   if(LUT_INDEX == VIDEO_RESET)  //generate a reset for TV IC
		begin
			case(mSetup_ST)
         0:	begin
					mI2C_DATA	<=	{8'h40,16'h0F80}; //TV Reset; chip reset, loads all I2C bits with default values
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)	begin
					   mSetup_ST	<=	2;
						mI2C_GO	<=	0;
               end
				end
			2: begin
						if(!mI2C_ACK)   // wait for ack ...  or? egnore ?
						  mSetup_ST	<=	3;
				end
			3:	begin
					if(tv_reset_delay_count >= 10'd200) // delay 10ms :Executing a software reset takes approximately 2 ms. 
					begin                                   //             However, it is recommended to wait 5 ms before any 
					                                        //             further I2C writes are performed.
					  	mSetup_ST	<=	0;                  
					   LUT_INDEX	<=	LUT_INDEX + 1;
						tv_reset_delay_count <= 0;
					end
					else 
					begin
					tv_reset_delay_count <= tv_reset_delay_count + 1'b1;
					end

				end
		   endcase

		end	
		else if(LUT_INDEX < LUT_SIZE) 
		begin
		
			case(mSetup_ST)
			0:	begin
					if(LUT_INDEX<SET_VIDEO)
					mI2C_DATA	<=	{8'h34,LUT_DATA};
					else
					mI2C_DATA	<=	{8'h40,LUT_DATA};
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
					begin
						if(!mI2C_ACK)
						mSetup_ST	<=	2;
						else
						mSetup_ST	<=	0;							
						mI2C_GO		<=	0;
					end
				end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
				end
			endcase
		end
	end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////	
always
begin
	case(LUT_INDEX)
/*
	//	Audio Config Data
	SET_LIN_L	:	LUT_DATA	<=	16'h001A;
	SET_LIN_R	:	LUT_DATA	<=	16'h021A;
	SET_HEAD_L	:	LUT_DATA	<=	16'h047B;
	SET_HEAD_R	:	LUT_DATA	<=	16'h067B;
	A_PATH_CTRL	:	LUT_DATA	<=	16'h08F8;
	D_PATH_CTRL	:	LUT_DATA	<=	16'h0A06;
	POWER_ON	:	LUT_DATA	<=	16'h0C00;
	SET_FORMAT	:	LUT_DATA	<=	16'h0E01;
	SAMPLE_CTRL	:	LUT_DATA	<=	16'h1002;
	SET_ACTIVE	:	LUT_DATA	<=	16'h1201;
*/

	//	Audio Config Data
	Dummy_DATA	:	LUT_DATA	<=	16'h0000;
	REG_REST	:	LUT_DATA	<=	16'h1E00;
	SET_LIN_L	:	LUT_DATA	<=	16'h001A;
	SET_LIN_R	:	LUT_DATA	<=	16'h021A;
	SET_HEAD_L	:	LUT_DATA	<=	16'h047B;
	SET_HEAD_R	:	LUT_DATA	<=	16'h067B;
	//A_PATH_CTRL	:	LUT_DATA	<=	16'h08F8;
	//A_PATH_CTRL	:	LUT_DATA	<=	16'h080A;	// 缺省值，可以载入录音
	A_PATH_CTRL	:	LUT_DATA	<=	16'h0812;		// 关闭BYPASS，打开DACSEL，可以载入录音，和播放
	D_PATH_CTRL	:	LUT_DATA	<=	16'h0A06;
	POWER_ON	:	LUT_DATA	<=	16'h0C00;
	SET_FORMAT	:	LUT_DATA	<=	16'h0E01;
	SAMPLE_CTRL	:	LUT_DATA	<=	16'h1002;
	SET_ACTIVE	:	LUT_DATA	<=	16'h1201;

	//	Video Config Data
	SET_VIDEO+2	:	LUT_DATA	   <=	16'h0000;//04
	SET_VIDEO+3	:	LUT_DATA	   <=	16'hc301;	
    SET_VIDEO+4	:	LUT_DATA	   <=	16'hc480;	
    SET_VIDEO+5	:	LUT_DATA	   <=	16'h0457;
	SET_VIDEO+6	:	LUT_DATA	   <=	16'h1741;
	SET_VIDEO+7	:	LUT_DATA	   <=	16'h5801;
	SET_VIDEO+8	:	LUT_DATA	   <=	16'h3da2;
	SET_VIDEO+9	:	LUT_DATA	   <=	16'h37a0;
	SET_VIDEO+10	:	LUT_DATA	   <=	16'h3e6a;
	SET_VIDEO+11	:	LUT_DATA	   <=	16'h3fa0;
	SET_VIDEO+12	:	LUT_DATA	   <=	16'h0e80;
	SET_VIDEO+13	:	LUT_DATA	   <=	16'h5581;
	SET_VIDEO+14	:	LUT_DATA	   <=	16'h37A0;   // Polarity regiser
	SET_VIDEO+15	:	LUT_DATA	   <=	16'h0880;	// Contrast Register 
	SET_VIDEO+16	:	LUT_DATA	   <=	16'h0a18;	// Brightness Register 
	SET_VIDEO+17	:	LUT_DATA	   <=	16'h2c8e;	// AGC Mode control
	SET_VIDEO+18	:	LUT_DATA	   <=	16'h2df8;   // Chroma Gain Control 1 
	SET_VIDEO+19	:	LUT_DATA	   <=	16'h2ece;	// Chroma Gain Control 2 
	SET_VIDEO+20	:	LUT_DATA	   <=	16'h2ff4;	// Luma Gain Control 1
	SET_VIDEO+21	:	LUT_DATA	   <=	16'h30b2;	// Luma Gain Control 2
	SET_VIDEO+22	:	LUT_DATA	   <=	16'h3102;
	SET_VIDEO+23	:	LUT_DATA	   <=	16'h0e00;
	

	default:		LUT_DATA	<=	16'd0 ;
	endcase
end
////////////////////////////////////////////////////////////////////
endmodule