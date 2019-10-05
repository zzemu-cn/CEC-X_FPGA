library verilog;
use verilog.vl_types.all;
entity IS61LV25616 is
    generic(
        dqbits          : integer := 16;
        memdepth        : integer := 262143;
        addbits         : integer := 18;
        Toha            : integer := 2;
        Tsa             : integer := 2;
        Taa             : integer := 10;
        Thzce           : integer := 3;
        Thzwe           : integer := 5
    );
    port(
        A               : in     vl_logic_vector;
        IO              : inout  vl_logic_vector;
        \CE_\           : in     vl_logic;
        \OE_\           : in     vl_logic;
        \WE_\           : in     vl_logic;
        \LB_\           : in     vl_logic;
        \UB_\           : in     vl_logic
    );
end IS61LV25616;
