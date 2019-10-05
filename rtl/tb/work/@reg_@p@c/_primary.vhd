library verilog;
use verilog.vl_types.all;
entity Reg_PC is
    port(
        adr_i           : in     vl_logic_vector(15 downto 0);
        clk_clk_i       : in     vl_logic;
        ld_i            : in     vl_logic_vector(1 downto 0);
        ld_pc_i         : in     vl_logic;
        offset_i        : in     vl_logic_vector(15 downto 0);
        rst_rst_n_i     : in     vl_logic;
        sel_pc_in_i     : in     vl_logic;
        sel_pc_val_i    : in     vl_logic_vector(1 downto 0);
        adr_nxt_pc_o    : out    vl_logic_vector(15 downto 0);
        adr_pc_o        : out    vl_logic_vector(15 downto 0)
    );
end Reg_PC;
