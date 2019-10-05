library verilog;
use verilog.vl_types.all;
entity RegBank_AXY is
    port(
        clk_clk_i       : in     vl_logic;
        d_regs_in_i     : in     vl_logic_vector(7 downto 0);
        load_regs_i     : in     vl_logic;
        rst_rst_n_i     : in     vl_logic;
        sel_rb_in_i     : in     vl_logic_vector(1 downto 0);
        sel_rb_out_i    : in     vl_logic_vector(1 downto 0);
        sel_reg_i       : in     vl_logic_vector(1 downto 0);
        d_regs_out_o    : out    vl_logic_vector(7 downto 0);
        q_a_o           : out    vl_logic_vector(7 downto 0);
        q_x_o           : out    vl_logic_vector(7 downto 0);
        q_y_o           : out    vl_logic_vector(7 downto 0)
    );
end RegBank_AXY;
