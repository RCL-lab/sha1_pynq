############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
open_project sha1_hls
set_top sha1_control
add_files sha1_hls/sha1_control.c
add_files sha1_hls/sha1_control.h
add_files -tb sha1_hls/tb_sha1_control.c
open_solution "solution1"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10 -name default
#source "./sha-1_hls/solution1/directives.tcl"
#csim_design -compiler gcc
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog -description "sha1_interface" -display_name "sha1_interface"
exit
