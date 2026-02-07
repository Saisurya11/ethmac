if {[file exists work]} {
    vdel -all
}
set file_name [open "tests.txt" r]
while { [gets $file_name test_name]>=0 } {

# --- 1. UNCOMMENT ONE TEST NAME ---
# You must set this variable. I have uncommented the one from your log.
# set test_name ethmac_fd_rx_test 
#set test_name ethmac_100mbps_fd_tx_test
# set test_name ethmac_fd_tx_rx_test
# set test_name mac_mii_write_ctrl_data
# set test_name ethmac_reg_write_read_test

vlib work
vmap work work

# --- 2. COMPILE ---
vlog -ccflags "-DQUESTA" C:/uvm_1.2/uvm-1.2-master/src/dpi/uvm_dpi.cc

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

# --- 3. OPTIMIZE (VOPT) ---
# Compiles "top" into an optimized snapshot named "$test_name"
vopt top +cover=fcbest -o $test_name

# --- 4. SIMULATE (VSIM) ---
# FIX: Removed "work.top". We only load "$test_name" (the optimized version).
vsim -voptargs=+acc -coverage $test_name +UVM_TESTNAME=$test_name -l log_rx.txt

# --- 5. RUN ---
coverage save -onexit $test_name.ucdb

# add wave -r sim:/top/*
do wave.do
run -all
}

vcov merge final.ucdb ethmac_reg_read_test.ucdb ethmac_reg_write_read_test.ucdb ethmac_reg_read_test_reg_model.ucdb ethmac_reg_write_read_reg_model_test.ucdb ethmac_reg_BD_write_read_reg_model_test.ucdb ethmac_10mbps_fd_tx_test.ucdb ethmac_100mbps_fd_tx_test.ucdb ethmac_fd_rx_test.ucdb ethmac_fd_tx_rx_test.ucdb mac_coll_hd_test.ucdb mac_mii_write_ctrl_data.ucdb ctrl_frame_test.ucdb

#vcov merge final.ucdb ethmac_10mbps_fd_tx_test.ucdb ethmac_100mbps_fd_tx_test.ucdb ethmac_fd_rx_test.ucdb
