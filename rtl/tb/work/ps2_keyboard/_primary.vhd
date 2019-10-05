library verilog;
use verilog.vl_types.all;
entity ps2_keyboard is
    port(
        CLK             : in     vl_logic;
        RESET_N         : in     vl_logic;
        PS2_CLK         : in     vl_logic;
        PS2_DATA        : in     vl_logic;
        RX_PRESSED      : out    vl_logic;
        RX_EXTENDED     : out    vl_logic;
        RX_SCAN         : out    vl_logic_vector(7 downto 0)
    );
end ps2_keyboard;
