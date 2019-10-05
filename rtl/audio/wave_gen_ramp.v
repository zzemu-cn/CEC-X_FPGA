module ramp_wave_gen(
input  [5:0] ramp,
output reg [15:0]music_o
);


always@(ramp[5:0])
begin
    case(ramp[5:0])
0 :music_o=16'hFFFFC000;
 1 :music_o=16'hFFFFC200;
 2 :music_o=16'hFFFFC400;
 3 :music_o=16'hFFFFC600;
 4 :music_o=16'hFFFFC800;
 5 :music_o=16'hFFFFCA00;
 6 :music_o=16'hFFFFCC00;
 7 :music_o=16'hFFFFCE00;
 8 :music_o=16'hFFFFD000;
 9 :music_o=16'hFFFFD200;
 10 :music_o=16'hFFFFD400;
 11 :music_o=16'hFFFFD600;
 12 :music_o=16'hFFFFD800;
 13 :music_o=16'hFFFFDA00;
 14 :music_o=16'hFFFFDC00;
 15 :music_o=16'hFFFFDE00;
 16 :music_o=16'hFFFFE000;
 17 :music_o=16'hFFFFE200;
 18 :music_o=16'hFFFFE400;
 19 :music_o=16'hFFFFE600;
 20 :music_o=16'hFFFFE800;
 21 :music_o=16'hFFFFEA00;
 22 :music_o=16'hFFFFEC00;
 23 :music_o=16'hFFFFEE00;
 24 :music_o=16'hFFFFF000;
 25 :music_o=16'hFFFFF200;
 26 :music_o=16'hFFFFF400;
 27 :music_o=16'hFFFFF600;
 28 :music_o=16'hFFFFF800;
 29 :music_o=16'hFFFFFA00;
 30 :music_o=16'hFFFFFC00;
 31 :music_o=16'hFFFFFE00;
 32 :music_o=16'h0;
 33 :music_o=16'h1FF;
 34 :music_o=16'h3FF;
 35 :music_o=16'h5FF;
 36 :music_o=16'h7FF;
 37 :music_o=16'h9FF;
 38 :music_o=16'hBFF;
 39 :music_o=16'hDFF;
 40 :music_o=16'hFFF;
 41 :music_o=16'h11FF;
 42 :music_o=16'h13FF;
 43 :music_o=16'h15FF;
 44 :music_o=16'h17FF;
 45 :music_o=16'h19FF;
 46 :music_o=16'h1BFF;
 47 :music_o=16'h1DFF;
 48 :music_o=16'h1FFF;
 49 :music_o=16'h21FF;
 50 :music_o=16'h23FF;
 51 :music_o=16'h25FF;
 52 :music_o=16'h27FF;
 53 :music_o=16'h29FF;
 54 :music_o=16'h2BFF;
 55 :music_o=16'h2DFF;
 56 :music_o=16'h2FFF;
 57 :music_o=16'h31FF;
 58 :music_o=16'h33FF;
 59 :music_o=16'h35FF;
 60 :music_o=16'h37FF;
 61 :music_o=16'h39FF;
 62 :music_o=16'h3BFF;
 63 :music_o=16'h3DFF;
default	:music_o=0;
	endcase
end
endmodule
