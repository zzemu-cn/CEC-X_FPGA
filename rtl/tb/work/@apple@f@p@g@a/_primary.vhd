library verilog;
use verilog.vl_types.all;
entity AppleFPGA is
    generic(
        OFFSET          : integer := 184;
        \RANGE\         : integer := 18
    );
    port(
        CLK50MHZ        : in     vl_logic;
        FLASH_ADDRESS   : out    vl_logic_vector(18 downto 0);
        FLASH_DATA      : in     vl_logic_vector(7 downto 0);
        FLASH_CE_N      : out    vl_logic;
        FLASH_OE_N      : out    vl_logic;
        FLASH_WE_N      : out    vl_logic;
        RAM_DATA0       : inout  vl_logic_vector(15 downto 0);
        RAM_DATA1       : inout  vl_logic_vector(15 downto 0);
        RAM_ADDRESS     : out    vl_logic_vector(17 downto 0);
        RAM_RW_N        : out    vl_logic;
        RAM0_CS_N       : out    vl_logic;
        RAM1_CS_N       : out    vl_logic;
        RAM0_BE0_N      : out    vl_logic;
        RAM0_BE1_N      : out    vl_logic;
        RAM1_BE0_N      : out    vl_logic;
        RAM1_BE1_N      : out    vl_logic;
        RAM_OE_N        : out    vl_logic;
        RED             : out    vl_logic;
        GREEN           : out    vl_logic;
        BLUE            : out    vl_logic;
        H_SYNC          : out    vl_logic;
        V_SYNC          : out    vl_logic;
        ps2_clk         : in     vl_logic;
        ps2_data        : in     vl_logic;
        DIGIT_N         : out    vl_logic_vector(3 downto 0);
        SEGMENT_N       : out    vl_logic_vector(7 downto 0);
        LED             : out    vl_logic_vector(7 downto 0);
        SWITCH          : in     vl_logic_vector(7 downto 0);
        BUTTON          : in     vl_logic_vector(3 downto 0)
    );
end AppleFPGA;
