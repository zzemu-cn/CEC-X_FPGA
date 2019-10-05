module wave_gen_square(
input  [5:0] ramp,
output reg [15:0]music_o
);


always@(ramp[5:0])
begin
    case(ramp[5:0])
 0 :music_o=16'hFFFFE000;
 1 :music_o=16'hFFFFE000;
 2 :music_o=16'hFFFFE000;
 3 :music_o=16'hFFFFE000;
 4 :music_o=16'hFFFFE000;
 5 :music_o=16'hFFFFE000;
 6 :music_o=16'hFFFFE000;
 7 :music_o=16'hFFFFE000;
 8 :music_o=16'hFFFFE000;
 9 :music_o=16'hFFFFE000;
 10 :music_o=16'hFFFFE000;
 11 :music_o=16'hFFFFE000;
 12 :music_o=16'hFFFFE000;
 13 :music_o=16'hFFFFE000;
 14 :music_o=16'hFFFFE000;
 15 :music_o=16'hFFFFE000;
 16 :music_o=16'hFFFFE000;
 17 :music_o=16'hFFFFE000;
 18 :music_o=16'hFFFFE000;
 19 :music_o=16'hFFFFE000;
 20 :music_o=16'hFFFFE000;
 21 :music_o=16'hFFFFE000;
 22 :music_o=16'hFFFFE000;
 23 :music_o=16'hFFFFE000;
 24 :music_o=16'hFFFFE000;
 25 :music_o=16'hFFFFE000;
 26 :music_o=16'hFFFFE000;
 27 :music_o=16'hFFFFE000;
 28 :music_o=16'hFFFFE000;
 29 :music_o=16'hFFFFE000;
 30 :music_o=16'hFFFFE000;
 31 :music_o=16'hFFFFE000;
 32 :music_o=16'h1FFF;
 33 :music_o=16'h1FFF;
 34 :music_o=16'h1FFF;
 35 :music_o=16'h1FFF;
 36 :music_o=16'h1FFF;
 37 :music_o=16'h1FFF;
 38 :music_o=16'h1FFF;
 39 :music_o=16'h1FFF;
 40 :music_o=16'h1FFF;
 41 :music_o=16'h1FFF;
 42 :music_o=16'h1FFF;
 43 :music_o=16'h1FFF;
 44 :music_o=16'h1FFF;
 45 :music_o=16'h1FFF;
 46 :music_o=16'h1FFF;
 47 :music_o=16'h1FFF;
 48 :music_o=16'h1FFF;
 49 :music_o=16'h1FFF;
 50 :music_o=16'h1FFF;
 51 :music_o=16'h1FFF;
 52 :music_o=16'h1FFF;
 53 :music_o=16'h1FFF;
 54 :music_o=16'h1FFF;
 55 :music_o=16'h1FFF;
 56 :music_o=16'h1FFF;
 57 :music_o=16'h1FFF;
 58 :music_o=16'h1FFF;
 59 :music_o=16'h1FFF;
 60 :music_o=16'h1FFF;
 61 :music_o=16'h1FFF;
 62 :music_o=16'h1FFF;
 63 :music_o=16'h1FFF;
default	:music_o=0;
	endcase
end
endmodule
