############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
open_project garble_if
set_top garble_if
add_files garble_if.h
add_files garble_if.c
add_files -tb tb_garble_if.c
open_solution "solution1"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10 -name default
#source "./garble_if/solution1/directives.tcl"
csim_design -compiler gcc
csynth_design
cosim_design
export_design -rtl verilog -format ip_catalog
