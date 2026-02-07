interface wb_proc_intf(input wb_clk_i,wb_rst_i);
  //WISHBONE COMMON
  bit [31:0]  wb_dat_i;
  bit [31:0]  wb_dat_o;  
  bit         wb_err_o;  
  // WISHBONE slave
  bit [11:2]  wb_adr_i;  
  bit [3:0]   wb_sel_i;  
  bit         wb_we_i;   
  bit         wb_cyc_i;  
  bit         wb_stb_i;  
  bit         wb_ack_o;  
  bit int_o;         // Interrupt output

endinterface
