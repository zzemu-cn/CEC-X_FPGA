library verilog;
use verilog.vl_types.all;
entity R65C02_TC is
    port(
        clk_clk_i       : in     vl_logic;
        d_i             : in     vl_logic_vector(7 downto 0);
        irq_n_i         : in     vl_logic;
        nmi_n_i         : in     vl_logic;
        rdy_i           : in     vl_logic;
        rst_rst_n_i     : in     vl_logic;
        so_n_i          : in     vl_logic;
        a_o             : out    vl_logic_vector(15 downto 0);
        d_o             : out    vl_logic_vector(7 downto 0);
        rd_o            : out    vl_logic;
        sync_o          : out    vl_logic;
        wr_o            : out    vl_logic
    );
end R65C02_TC;
