module wave_gen_x2(
input  [5:0] ramp,
output reg [15:0]music_o
);


always@(ramp[5:0])
begin
    case(ramp[5:0])
 0 :music_o=16'h3FFF;
 1 :music_o=16'h3C0F;
 2 :music_o=16'h383F;
 3 :music_o=16'h348F;
 4 :music_o=16'h30FF;
 5 :music_o=16'h2D8F;
 6 :music_o=16'h2A3F;
 7 :music_o=16'h270F;
 8 :music_o=16'h23FF;
 9 :music_o=16'h210F;
 10 :music_o=16'h1E3F;
 11 :music_o=16'h1B8F;
 12 :music_o=16'h18FF;
 13 :music_o=16'h168F;
 14 :music_o=16'h143F;
 15 :music_o=16'h120F;
 16 :music_o=16'hFFF;
 17 :music_o=16'hE0F;
 18 :music_o=16'hC3F;
 19 :music_o=16'hA8F;
 20 :music_o=16'h8FF;
 21 :music_o=16'h78F;
 22 :music_o=16'h63F;
 23 :music_o=16'h50F;
 24 :music_o=16'h3FF;
 25 :music_o=16'h30F;
 26 :music_o=16'h23F;
 27 :music_o=16'h18F;
 28 :music_o=16'hFF;
 29 :music_o=16'h8F;
 30 :music_o=16'h3F;
 31 :music_o=16'hF;
 32 :music_o=16'h0;
 33 :music_o=16'hF;
 34 :music_o=16'h3F;
 35 :music_o=16'h8F;
 36 :music_o=16'hFF;
 37 :music_o=16'h18F;
 38 :music_o=16'h23F;
 39 :music_o=16'h30F;
 40 :music_o=16'h3FF;
 41 :music_o=16'h50F;
 42 :music_o=16'h63F;
 43 :music_o=16'h78F;
 44 :music_o=16'h8FF;
 45 :music_o=16'hA8F;
 46 :music_o=16'hC3F;
 47 :music_o=16'hE0F;
 48 :music_o=16'hFFF;
 49 :music_o=16'h120F;
 50 :music_o=16'h143F;
 51 :music_o=16'h168F;
 52 :music_o=16'h18FF;
 53 :music_o=16'h1B8F;
 54 :music_o=16'h1E3F;
 55 :music_o=16'h210F;
 56 :music_o=16'h23FF;
 57 :music_o=16'h270F;
 58 :music_o=16'h2A3F;
 59 :music_o=16'h2D8F;
 60 :music_o=16'h30FF;
 61 :music_o=16'h348F;
 62 :music_o=16'h383F;
 63 :music_o=16'h3C0F;
default	:music_o=0;
	endcase
end
endmodule
