@rem iverilog -DSIMULATE=1 -DCPU65C02=1 -c modules.f -o applefpga.tb
@del applefpga.tb
iverilog -DSIMULATE=1 -DCPU65C02=1 -c modules.selftest.f -o applefpga.tb

vvp applefpga.tb

gtkwave applefpga.dump