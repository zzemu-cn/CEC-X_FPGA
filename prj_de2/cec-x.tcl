# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II 64-Bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition
# File: D:\CEC-X\cec-x.tcl
# Generated on: Mon Nov 05 10:35:57 2018

package require ::quartus::project

set_location_assignment PIN_L22 -to SWITCH[0]
set_location_assignment PIN_L21 -to SWITCH[1]
set_location_assignment PIN_M22 -to SWITCH[2]
set_location_assignment PIN_V12 -to SWITCH[3]
set_location_assignment PIN_W12 -to SWITCH[4]
set_location_assignment PIN_U12 -to SWITCH[5]
set_location_assignment PIN_U11 -to SWITCH[6]
set_location_assignment PIN_M2 -to SWITCH[7]
set_location_assignment PIN_M1 -to SWITCH[8]
set_location_assignment PIN_L2 -to SWITCH[9]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[0]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[1]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[2]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[3]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[4]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[5]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[6]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[7]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[8]
set_instance_assignment -name IO_STANDARD LVTTL -to SWITCH[9]
set_location_assignment PIN_R22 -to BUTTON[0]
set_location_assignment PIN_R21 -to BUTTON[1]
set_location_assignment PIN_T22 -to BUTTON[2]
set_location_assignment PIN_T21 -to BUTTON[3]
set_location_assignment PIN_R20 -to LED[0]
set_location_assignment PIN_R19 -to LED[1]
set_location_assignment PIN_U19 -to LED[2]
set_location_assignment PIN_Y19 -to LED[3]
set_location_assignment PIN_T18 -to LED[4]
set_location_assignment PIN_V19 -to LED[5]
set_location_assignment PIN_Y18 -to LED[6]
set_location_assignment PIN_U18 -to LED[7]
set_location_assignment PIN_R18 -to LED[8]
set_location_assignment PIN_R17 -to LED[9]
set_instance_assignment -name IO_STANDARD LVTTL -to BUTTON[0]
set_instance_assignment -name IO_STANDARD LVTTL -to BUTTON[1]
set_instance_assignment -name IO_STANDARD LVTTL -to BUTTON[2]
set_instance_assignment -name IO_STANDARD LVTTL -to BUTTON[3]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[0]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[1]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[2]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[3]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[4]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[5]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[6]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[7]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[8]
set_instance_assignment -name IO_STANDARD LVTTL -to LED[9]
set_location_assignment PIN_L1 -to CLK50MHZ
set_instance_assignment -name IO_STANDARD LVTTL -to CLK50MHZ
set_location_assignment PIN_H15 -to ps2_clk
set_location_assignment PIN_J14 -to ps2_data
set_instance_assignment -name IO_STANDARD LVTTL -to ps2_clk
set_instance_assignment -name IO_STANDARD LVTTL -to ps2_data
set_location_assignment PIN_D9 -to VGA_RED[0]
set_location_assignment PIN_C9 -to VGA_RED[1]
set_location_assignment PIN_A7 -to VGA_RED[2]
set_location_assignment PIN_B7 -to VGA_RED[3]
set_location_assignment PIN_B8 -to VGA_GREEN[0]
set_location_assignment PIN_C10 -to VGA_GREEN[1]
set_location_assignment PIN_B9 -to VGA_GREEN[2]
set_location_assignment PIN_A8 -to VGA_GREEN[3]
set_location_assignment PIN_A9 -to VGA_BLUE[0]
set_location_assignment PIN_D11 -to VGA_BLUE[1]
set_location_assignment PIN_A10 -to VGA_BLUE[2]
set_location_assignment PIN_B10 -to VGA_BLUE[3]
set_location_assignment PIN_A11 -to VGA_HS
set_location_assignment PIN_B11 -to VGA_VS
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_RED[0]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_RED[1]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_RED[2]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_RED[3]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_GREEN[0]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_GREEN[1]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_GREEN[2]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_GREEN[3]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_BLUE[0]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_BLUE[1]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_BLUE[2]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_BLUE[3]
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_HS
set_instance_assignment -name IO_STANDARD LVTTL -to VGA_VS
set_location_assignment PIN_AB20 -to FLASH_ADDRESS[0]
set_location_assignment PIN_AA14 -to FLASH_ADDRESS[1]
set_location_assignment PIN_Y16 -to FLASH_ADDRESS[2]
set_location_assignment PIN_R15 -to FLASH_ADDRESS[3]
set_location_assignment PIN_T15 -to FLASH_ADDRESS[4]
set_location_assignment PIN_U15 -to FLASH_ADDRESS[5]
set_location_assignment PIN_V15 -to FLASH_ADDRESS[6]
set_location_assignment PIN_W15 -to FLASH_ADDRESS[7]
set_location_assignment PIN_R14 -to FLASH_ADDRESS[8]
set_location_assignment PIN_Y13 -to FLASH_ADDRESS[9]
set_location_assignment PIN_R12 -to FLASH_ADDRESS[10]
set_location_assignment PIN_T12 -to FLASH_ADDRESS[11]
set_location_assignment PIN_AB14 -to FLASH_ADDRESS[12]
set_location_assignment PIN_AA13 -to FLASH_ADDRESS[13]
set_location_assignment PIN_AB13 -to FLASH_ADDRESS[14]
set_location_assignment PIN_AA12 -to FLASH_ADDRESS[15]
set_location_assignment PIN_AB12 -to FLASH_ADDRESS[16]
set_location_assignment PIN_AA20 -to FLASH_ADDRESS[17]
set_location_assignment PIN_U14 -to FLASH_ADDRESS[18]
set_location_assignment PIN_V14 -to FLASH_ADDRESS[19]
set_location_assignment PIN_U13 -to FLASH_ADDRESS[20]
set_location_assignment PIN_R13 -to FLASH_ADDRESS[21]
set_location_assignment PIN_AB16 -to FLASH_DATA[0]
set_location_assignment PIN_AA16 -to FLASH_DATA[1]
set_location_assignment PIN_AB17 -to FLASH_DATA[2]
set_location_assignment PIN_AA17 -to FLASH_DATA[3]
set_location_assignment PIN_AB18 -to FLASH_DATA[4]
set_location_assignment PIN_AA18 -to FLASH_DATA[5]
set_location_assignment PIN_AB19 -to FLASH_DATA[6]
set_location_assignment PIN_AA19 -to FLASH_DATA[7]
set_location_assignment PIN_AA15 -to FLASH_OE_N
set_location_assignment PIN_W14 -to FLASH_RESET_N
set_location_assignment PIN_Y14 -to FLASH_WE_N
set_location_assignment PIN_AA3 -to RAM_ADDRESS[0]
set_location_assignment PIN_AB3 -to RAM_ADDRESS[1]
set_location_assignment PIN_AA4 -to RAM_ADDRESS[2]
set_location_assignment PIN_AB4 -to RAM_ADDRESS[3]
set_location_assignment PIN_AA5 -to RAM_ADDRESS[4]
set_location_assignment PIN_AB10 -to RAM_ADDRESS[5]
set_location_assignment PIN_AA11 -to RAM_ADDRESS[6]
set_location_assignment PIN_AB11 -to RAM_ADDRESS[7]
set_location_assignment PIN_V11 -to RAM_ADDRESS[8]
set_location_assignment PIN_W11 -to RAM_ADDRESS[9]
set_location_assignment PIN_R11 -to RAM_ADDRESS[10]
set_location_assignment PIN_T11 -to RAM_ADDRESS[11]
set_location_assignment PIN_Y10 -to RAM_ADDRESS[12]
set_location_assignment PIN_U10 -to RAM_ADDRESS[13]
set_location_assignment PIN_R10 -to RAM_ADDRESS[14]
set_location_assignment PIN_T7 -to RAM_ADDRESS[15]
set_location_assignment PIN_Y6 -to RAM_ADDRESS[16]
set_location_assignment PIN_Y5 -to RAM_ADDRESS[17]
set_location_assignment PIN_AB5 -to RAM0_CS_N
set_location_assignment PIN_AA6 -to RAM_DATA0[0]
set_location_assignment PIN_AB6 -to RAM_DATA0[1]
set_location_assignment PIN_AA7 -to RAM_DATA0[2]
set_location_assignment PIN_AB7 -to RAM_DATA0[3]
set_location_assignment PIN_AA8 -to RAM_DATA0[4]
set_location_assignment PIN_AB8 -to RAM_DATA0[5]
set_location_assignment PIN_AA9 -to RAM_DATA0[6]
set_location_assignment PIN_AB9 -to RAM_DATA0[7]
set_location_assignment PIN_Y9 -to RAM_DATA0[8]
set_location_assignment PIN_W9 -to RAM_DATA0[9]
set_location_assignment PIN_V9 -to RAM_DATA0[10]
set_location_assignment PIN_U9 -to RAM_DATA0[11]
set_location_assignment PIN_R9 -to RAM_DATA0[12]
set_location_assignment PIN_W8 -to RAM_DATA0[13]
set_location_assignment PIN_V8 -to RAM_DATA0[14]
set_location_assignment PIN_U8 -to RAM_DATA0[15]
set_location_assignment PIN_Y7 -to RAM0_BE0_N
set_location_assignment PIN_T8 -to RAM_OE_N
set_location_assignment PIN_W7 -to RAM0_BE1_N
set_location_assignment PIN_AA10 -to RAM_RW_N
