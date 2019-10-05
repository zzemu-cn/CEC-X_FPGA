module wave_gen_string(
input  [5:0] ramp,
output reg [15:0]music_o
);


always@(ramp[5:0])
begin
    case(ramp[5:0])
 0 :music_o=16'h0;
 1 :music_o=16'h0;
 2 :music_o=16'h0;
 3 :music_o=16'h0;
 4 :music_o=16'h0;
 5 :music_o=16'h0;
 6 :music_o=16'h246;
 7 :music_o=16'hC36;
 8 :music_o=16'hCFC;
 9 :music_o=16'hC17;
 10 :music_o=16'hAEE;
 11 :music_o=16'hAA0;
 12 :music_o=16'hBB8;
 13 :music_o=16'hBAE;
 14 :music_o=16'h9E4;
 15 :music_o=16'h834;
 16 :music_o=16'h789;
 17 :music_o=16'hA89;
 18 :music_o=16'h115A;
 19 :music_o=16'h19D4;
 20 :music_o=16'h2316;
 21 :music_o=16'h2825;
 22 :music_o=16'h24BA;
 23 :music_o=16'h1D2E;
 24 :music_o=16'h143B;
 25 :music_o=16'hE10;
 26 :music_o=16'h1345;
 27 :music_o=16'h1E4B;
 28 :music_o=16'h2392;
 29 :music_o=16'h1E0A;
 30 :music_o=16'hF4A;
 31 :music_o=16'h37F;
 32 :music_o=16'h1E0;
 33 :music_o=16'h560;
 34 :music_o=16'h9B7;
 35 :music_o=16'hF84;
 36 :music_o=16'h16D8;
 37 :music_o=16'h1B1D;
 38 :music_o=16'h1B6C;
 39 :music_o=16'h1B5D;
 40 :music_o=16'h175E;
 41 :music_o=16'hD34;
 42 :music_o=16'h33A;
 43 :music_o=16'hFFFFFCF5;
 44 :music_o=16'hFFFFFAC0;
 45 :music_o=16'hFFFFF9B0;
 46 :music_o=16'hFFFFF3FE;
 47 :music_o=16'hFFFFF103;
 48 :music_o=16'hFFFFF394;
 49 :music_o=16'hFFFFEBEE;
 50 :music_o=16'hFFFFDD00;
 51 :music_o=16'hFFFFD7D4;
 52 :music_o=16'hFFFFE07A;
 53 :music_o=16'hFFFFEA88;
 54 :music_o=16'hFFFFE8BA;
 55 :music_o=16'hFFFFE507;
 56 :music_o=16'hFFFFE4C4;
 57 :music_o=16'hFFFFE68E;
 58 :music_o=16'hFFFFEBB8;
 59 :music_o=16'hFFFFED46;
 60 :music_o=16'hFFFFF2B2;
 61 :music_o=16'hFFFFF899;
 62 :music_o=16'hFFFFF4AF;
 63 :music_o=16'hFFFFFAA7;
default	:music_o=0;
	endcase
end
endmodule
