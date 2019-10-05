library verilog;
use verilog.vl_types.all;
entity mem_flash_tb is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        adr             : in     vl_logic_vector(18 downto 0);
        dat             : out    vl_logic_vector(7 downto 0);
        oe_n            : in     vl_logic;
        ce_n            : in     vl_logic
    );
end mem_flash_tb;
