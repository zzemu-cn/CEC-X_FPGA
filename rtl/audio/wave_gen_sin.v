module wave_gen_sin(
input  [5:0] ramp,
output reg [15:0]music_o
);


always@(ramp[5:0])
begin
    case(ramp[5:0])
 0 :music_o=16'h0;
 1 :music_o=16'h322;
 2 :music_o=16'h63D;
 3 :music_o=16'h948;
 4 :music_o=16'hC3D;
 5 :music_o=16'hF13;
 6 :music_o=16'h11C5;
 7 :music_o=16'h144A;
 8 :music_o=16'h169E;
 9 :music_o=16'h18B9;
 10 :music_o=16'h1A98;
 11 :music_o=16'h1C36;
 12 :music_o=16'h1D8E;
 13 :music_o=16'h1E9D;
 14 :music_o=16'h1F61;
 15 :music_o=16'h1FD7;
 16 :music_o=16'h1FFF;
 17 :music_o=16'h1FD8;
 18 :music_o=16'h1F63;
 19 :music_o=16'h1EA1;
 20 :music_o=16'h1D93;
 21 :music_o=16'h1C3C;
 22 :music_o=16'h1AA0;
 23 :music_o=16'h18C2;
 24 :music_o=16'h16A7;
 25 :music_o=16'h1454;
 26 :music_o=16'h11CF;
 27 :music_o=16'hF1F;
 28 :music_o=16'hC49;
 29 :music_o=16'h955;
 30 :music_o=16'h64A;
 31 :music_o=16'h32F;
 32 :music_o=16'hD;
 33 :music_o=16'hFFFFFCEA;
 34 :music_o=16'hFFFFF9CF;
 35 :music_o=16'hFFFFF6C3;
 36 :music_o=16'hFFFFF3CE;
 37 :music_o=16'hFFFFF0F7;
 38 :music_o=16'hFFFFEE45;
 39 :music_o=16'hFFFFEBBF;
 40 :music_o=16'hFFFFE96B;
 41 :music_o=16'hFFFFE74E;
 42 :music_o=16'hFFFFE56E;
 43 :music_o=16'hFFFFE3CF;
 44 :music_o=16'hFFFFE276;
 45 :music_o=16'hFFFFE166;
 46 :music_o=16'hFFFFE0A1;
 47 :music_o=16'hFFFFE029;
 48 :music_o=16'hFFFFE000;
 49 :music_o=16'hFFFFE025;
 50 :music_o=16'hFFFFE099;
 51 :music_o=16'hFFFFE15A;
 52 :music_o=16'hFFFFE267;
 53 :music_o=16'hFFFFE3BD;
 54 :music_o=16'hFFFFE558;
 55 :music_o=16'hFFFFE735;
 56 :music_o=16'hFFFFE94F;
 57 :music_o=16'hFFFFEBA1;
 58 :music_o=16'hFFFFEE25;
 59 :music_o=16'hFFFFF0D5;
 60 :music_o=16'hFFFFF3AA;
 61 :music_o=16'hFFFFF69E;
 62 :music_o=16'hFFFFF9A9;
 63 :music_o=16'hFFFFFCC3;
default	:music_o=0;
	endcase
end
endmodule
