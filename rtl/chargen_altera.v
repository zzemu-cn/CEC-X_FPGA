module RAM1P(
    input     [6:0]  address,
    input            clock,
    input     [7:0]  data,
    input            wren,
    output    [7:0]  q
);

(*  ram_init_file = "charrom.mif" *)  reg [7:0] mem[127:0];

always@(posedge clock)
    if(wren) mem[address] <= data;  /*在时钟的上升沿写入数据*/
    
assign q = mem[address]; 
endmodule
