cd ../ip
foreach script [glob */script.tcl] { exec vivado_hls -f $script }


cd ../Pynq-Z1/sha1_pynq/overlays
source sha1_overlay.tcl
add_files -norecurse [make_wrapper -files [get_files "[current_bd_design].bd"] -top]

set_property top sha1_overlay_bd_wrapper [current_fileset]

update_compile_order -fileset sources_1


launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
file copy -force sha1_overlay/sha1_overlay.runs/impl_1/sha1_overlay_bd_wrapper.bit sha1_overlay.bit
file copy -force sha1_overlay/sha1_overlay.srcs/sources_1/bd/sha1_overlay_bd/hw_handoff/sha1_overlay_bd.hwh sha1_overlay.hwh
close_project

