interface wb_mem_intf(input wb_clk_i,wb_rst_i);
//wishbone Master
  bit [31:0]  m_wb_adr_o;
  bit  [3:0]  m_wb_sel_o;
  bit         m_wb_we_o;
  bit [31:0]  m_wb_dat_i;
  bit [31:0]  m_wb_dat_o;
  bit         m_wb_cyc_o;
  bit         m_wb_stb_o;
  bit         m_wb_ack_i;
  bit         m_wb_err_i;

  bit [2:0]  m_wb_cti_o;   // Cycle Type Identifier
  bit [1:0]  m_wb_bte_o;   // Burst Type Extension

endinterface
