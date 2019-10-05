module wave_gen_brass(
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
 6 :music_o=16'h0;
 7 :music_o=16'h366;
 8 :music_o=16'h782;
 9 :music_o=16'hC60;
 10 :music_o=16'h1208;
 11 :music_o=16'h183A;
 12 :music_o=16'h1E44;
 13 :music_o=16'h23EB;
 14 :music_o=16'h299B;
 15 :music_o=16'h2EDE;
 16 :music_o=16'h3339;
 17 :music_o=16'h36B0;
 18 :music_o=16'h38CC;
 19 :music_o=16'h38FD;
 20 :music_o=16'h3766;
 21 :music_o=16'h34AA;
 22 :music_o=16'h30FA;
 23 :music_o=16'h2C38;
 24 :music_o=16'h2697;
 25 :music_o=16'h2056;
 26 :music_o=16'h1984;
 27 :music_o=16'h1224;
 28 :music_o=16'hA8A;
 29 :music_o=16'h385;
 30 :music_o=16'hFFFFFDA8;
 31 :music_o=16'hFFFFF8E0;
 32 :music_o=16'hFFFFF4F2;
 33 :music_o=16'hFFFFF192;
 34 :music_o=16'hFFFFEE42;
 35 :music_o=16'hFFFFEB00;
 36 :music_o=16'hFFFFE84A;
 37 :music_o=16'hFFFFE650;
 38 :music_o=16'hFFFFE50C;
 39 :music_o=16'hFFFFE496;
 40 :music_o=16'hFFFFE48C;
 41 :music_o=16'hFFFFE47C;
 42 :music_o=16'hFFFFE465;
 43 :music_o=16'hFFFFE412;
 44 :music_o=16'hFFFFE361;
 45 :music_o=16'hFFFFE2CC;
 46 :music_o=16'hFFFFE2BC;
 47 :music_o=16'hFFFFE31C;
 48 :music_o=16'hFFFFE3E9;
 49 :music_o=16'hFFFFE515;
 50 :music_o=16'hFFFFE678;
 51 :music_o=16'hFFFFE7D8;
 52 :music_o=16'hFFFFE91B;
 53 :music_o=16'hFFFFEA5E;
 54 :music_o=16'hFFFFEBC1;
 55 :music_o=16'hFFFFED67;
 56 :music_o=16'hFFFFEF6D;
 57 :music_o=16'hFFFFF1FA;
 58 :music_o=16'hFFFFF4F2;
 59 :music_o=16'hFFFFF7D9;
 60 :music_o=16'hFFFFFA78;
 61 :music_o=16'hFFFFFCD7;
 62 :music_o=16'hFFFFFEF7;
 63 :music_o=16'hDA;
default	:music_o=0;
	endcase
end
endmodule
