import os
f=open("tests.txt","r")
list_file=f.readlines()
count=0
for line in list_file:
  #line.strip()
   print(line)
  # if(count<1):
   line_strip=line.strip()
   os.system("vlib work")
   os.system("vmap work work")
   os.system("vlog -ccflags \"-DQUESTA\" C:/uvm_1.2/uvm-1.2-master/src/dpi/uvm_dpi.cc")
   os.system("vlog +incdir+C:/uvm_1.2/uvm-1.2-master/src C:/uvm_1.2/uvm-1.2-master/src/uvm_pkg.sv ../top/top.sv +incdir+C:/uvm_1.2/uvm-1.2-master/src    +incdir+../../rtl    +incdir+../top    +incdir+../wb_proc    +incdir+../wb_mem    +incdir+../mii    +incdir+../phy    +incdir+../sbd +incdir+../reg_model")
   os.system("vopt top +cover=fcbest -o %0s"%(line_strip))
   os.system("vsim -c -voptargs=+acc -coverage %0s +UVM_TESTNAME=%0s -l %0s_py.txt -do \"coverage save -onexit %0s_py.ucdb\" -do \"run -all\" -do \"quit\""%(line_strip,line_strip,line_strip,line_strip))
   #os.system("vsim -c -do \"vcov merge final_py.ucdb %s.ucdb\" -do \"quit\" "%(line_strip))
   count=count+1
f.close()
os.system("vsim -c -do \"vcov merge final_py.ucdb ethmac_reg_read_test_py.ucdb ethmac_reg_write_read_test_py.ucdb ethmac_reg_read_test_reg_model_py.ucdb ethmac_reg_write_read_reg_model_test_py.ucdb ethmac_reg_BD_write_read_reg_model_test_py.ucdb ethmac_10mbps_fd_tx_test_py.ucdb ethmac_100mbps_fd_tx_test_py.ucdb ethmac_fd_rx_test_py.ucdb ethmac_fd_tx_rx_test_py.ucdb mac_coll_hd_test_py.ucdb mac_mii_write_ctrl_data_py.ucdb ctrl_frame_test_py.ucdb\" -do \"quit\"")
   os.system("vsim -do \"vcover report -details -html final_py.ucdb\"")
print(count)
