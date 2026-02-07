if {[file exists work]} {
    vdel -all
}
set file_name [open "tests.txt" r]
while { [gets $file_name test_name]>=0 } {
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
    vsim -voptargs=+acc work.top -l $test_name.txt +UVM_TESTNAME=$test_name
    #add wave -r sim:/top/*
    do wave.do
    run -all
}
#quit


