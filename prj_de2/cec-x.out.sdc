## Generated SDC file "cec-x.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Mon Nov 05 11:05:41 2018"

##
## DEVICE  "EP2C20F484C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {sys_clk} -period 20 -waveform { 0 10 } [get_ports {CLK50MHZ}]
create_clock -name {clk_27} -period 37.037 [get_ports {CLK27MHZ}]
#create_clock -name "clk_27" -period 37.000 [get_ports {CLK27MHZ}]

#create_clock -name {vga_clk} -period 40 -waveform { 0 20 } [get_nets {VGA_CLK}]
#create_clock -name {vga_clk} -period 39.000 -waveform { 0 19.500 } [get_nets {VGA_CLK}]

#create_clock -name {vga_clk} -period 37.037 [get_nets {VID_BUF_VID_RD}]

#create_clock -name {cpu_clk} -period 40	-waveform { 0 20 } [get_nets {CPU_CLK}]
create_clock -name {cpu_clk} -period 100	-waveform { 0 20 } [get_nets {CPU_CLK}]

create_clock -name {floppy_clk}	-period 1000	-waveform { 0 200 }	[get_nets {FLOPPY_CLK[4]}]

create_clock -name {kb_clk} -period 640 -waveform { 0 320 } [get_nets {KB_CLK}]

#create_clock -name {clk1hz}  -period 1000000000 -waveform { 0 500000000 } [get_nets {CLK_1HZ}]
#create_clock -name {clk1khz} -period 1000000    -waveform { 0 500000 }    [get_nets {CLK_1KHZ}]
create_clock -name {clk1hz}  -period 1000000 -waveform { 0 500000 } [get_nets {CLK_1HZ}]
#create_clock -name {clk1khz} -period 1000000 -waveform { 0 500000 } [get_nets {CLK_1KHZ}]
#create_clock -name {clk1mhz} -period 1000 -waveform { 0 500 } [get_nets {CLK_1MHZ}]

create_clock -name {clk_aud} -period 53.879 [get_ports {AUD_CTRL_CLK}]

#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {vga_clk} -group {kb_clk} -group {clk1hz}
#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {floppy_clk} -group {kb_clk} -group {clk1hz}
#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {vga_clk} -group {floppy_clk} -group {kb_clk} -group {clk1hz} -group {clk_aud}
#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {floppy_clk} -group {kb_clk} -group {clk1hz} -group {clk_aud}
#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {floppy_clk} -group {kb_clk} -group {clk1hz} -group {clk_aud}
set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk} -group {clk_27} -group {kb_clk} -group {floppy_clk} -group {clk_aud}
#set_clock_groups -asynchronous -group {sys_clk} -group {cpu_clk,kb_clk} -group {clk_27} -group {floppy_clk} -group {clk_aud}

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {VGA_AUDIO_PLL|altpll_component|pll|clk[0]} -source [get_pins {VGA_AUDIO_PLL|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 14 -divide_by 15 -master_clock {clk_27} [get_pins {VGA_AUDIO_PLL|altpll_component|pll|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

