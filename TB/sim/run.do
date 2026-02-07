if {[file exists work]} {
    vdel -all
}
vlib work
vmap work work
vlog -ccflags "-DQUESTA" C:/uvm_1.2/uvm-1.2-master/src/dpi/uvm_dpi.cc
#vlog ../rtl/eth_mac_rtl.svh
vlog +incdir+C:/uvm_1.2/uvm-1.2-master/src C:/uvm_1.2/uvm-1.2-master/src/uvm_pkg.sv
vlog ../top/top.sv +incdir+C:/uvm_1.2/uvm-1.2-master/src \
+incdir+../../rtl \
+incdir+../top \
+incdir+../wb_proc \
+incdir+../wb_mem \
+incdir+../mii \
+incdir+../phy \
+incdir+../sbd \
+incdir+../reg_model
#set test_name ethmac_fd_rx_test 
#set test_name ethmac_100mbps_fd_tx_test 
#set test_name ethmac_fd_tx_rx_test
#set test_name mac_mii_write_ctrl_data
#set test_name ctrl_frame_test
set test_name tx_ctrl_frame_test

vopt top +cover=fcbest -o $test_name

vsim -voptargs=+acc -coverage $test_name +UVM_TESTNAME=$test_name -l log_rx.txt

coverage save -onexit $test_name.ucdb

#add wave -r sim:/top/*
do wave.do
run -all
#quit


