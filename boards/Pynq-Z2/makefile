all: bitstream

bitstream:
	vivado -mode batch -source build_all.tcl -notrace
clean:
	rm -rf sha1_pynq/overlays/sha1_overlay *.jou *.log
