library verilog;
use verilog.vl_types.all;
entity FSM_NMI is
    generic(
        state_type_idle : integer := 0;
        state_type_idle1: integer := 1;
        state_type_idle2: integer := 2;
        state_type_IMP  : integer := 3
    );
    port(
        clk_clk_i       : in     vl_logic;
        fetch_i         : in     vl_logic;
        nmi_n_i         : in     vl_logic;
        rst_rst_n_i     : in     vl_logic;
        nmi_o           : out    vl_logic
    );
end FSM_NMI;
