library verilog;
use verilog.vl_types.all;
entity Reg_SP is
    port(
        adr_low_i       : in     vl_logic_vector(7 downto 0);
        clk_clk_i       : in     vl_logic;
        ld_low_i        : in     vl_logic;
        ld_sp_i         : in     vl_logic;
        rst_rst_n_i     : in     vl_logic;
        sel_sp_as_i     : in     vl_logic;
        sel_sp_in_i     : in     vl_logic;
        adr_sp_o        : out    vl_logic_vector(15 downto 0)
    );
end Reg_SP;
