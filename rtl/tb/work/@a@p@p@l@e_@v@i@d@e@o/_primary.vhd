library verilog;
use verilog.vl_types.all;
entity APPLE_VIDEO is
    generic(
        COLOR_16_RED    : integer := 43522;
        COLOR_16_GREEN  : integer := 61568;
        COLOR_16_BLUE   : integer := 51396;
        COLOR_H_RED     : integer := 5544;
        COLOR_H_GREEN   : integer := 3696;
        COLOR_H_BLUE    : integer := 5160
    );
    port(
        CLK             : in     vl_logic;
        APPLE_VID       : in     vl_logic;
        ADDRESS         : out    vl_logic_vector(15 downto 0);
        DATA            : in     vl_logic_vector(15 downto 0);
        CHAR_ADD        : out    vl_logic_vector(10 downto 0);
        CHAR_DATA       : in     vl_logic_vector(7 downto 0);
        CLK_MOD         : out    vl_logic;
        RED             : out    vl_logic;
        GREEN           : out    vl_logic;
        BLUE            : out    vl_logic;
        HSYNC           : out    vl_logic;
        VSYNC           : out    vl_logic;
        CLOCK_MUX       : in     vl_logic_vector(7 downto 0);
        TEXT            : in     vl_logic;
        MIXED           : in     vl_logic;
        TEXT_80         : in     vl_logic;
        SECONDARY       : in     vl_logic;
        ALT_CHAR        : in     vl_logic;
        HI_RES          : in     vl_logic;
        DHRES           : in     vl_logic;
        TEXT_COLOR      : in     vl_logic_vector(2 downto 0);
        V_BLANKING      : out    vl_logic;
        CLK_1HZ         : in     vl_logic
    );
end APPLE_VIDEO;
