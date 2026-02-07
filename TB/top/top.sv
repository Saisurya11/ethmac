`include "uvm_macros.svh"
import uvm_pkg::*;
`include "ethmac_common.sv"
`include "wb_tx.sv"
`include "mac_reg_model.sv"
`include "wb_adapter.sv"
`include "eth_mac_rtl.svh"
`include "eth_frame.sv"

`include "mii_intf.sv"
`include "phy_intf.sv"
`include "wb_proc_intf.sv"
`include "wb_mem_intf.sv"
`include "memory.sv"

`include "wb_proc_drv.sv"
`include "wb_proc_sqr.sv"
`include "wb_proc_seq_lib.sv"

`include "phy_rx_sqr.sv"
`include "phy_rx_seq_lib.sv"


`include "phy_rx_drv.sv"
`include "phy_tx_drv.sv"



`include "wb_proc_mon.sv"
`include "wb_mem_mon.sv"
`include "phy_rx_mon.sv"
`include "phy_tx_mon.sv"

`include "wb_proc_cov.sv"

`include "wb_proc_agent.sv"
`include "wb_mem_agent.sv"
`include "phy_tx_agent.sv"
`include "phy_rx_agent.sv"
`include "mii_agent.sv"

`include "mac_sbd.sv"

`include "ethmac_env.sv"
`include "test_lib.sv"


module top;

  reg wb_clk,wb_rst;

  wb_proc_intf proc_pif(wb_clk,wb_rst);
  wb_mem_intf mem_pif(wb_clk,wb_rst);
  phy_intf phy_pif();
  mii_intf mii_pif();
  ethmac_common common=new(); // it is only for the initiating the internal registers configuration from the testbench to the RTL
  ethmac dut(
    // WISHBONE common
    .wb_clk_i(proc_pif.wb_clk_i), 
    .wb_rst_i(proc_pif.wb_rst_i), 
    .wb_dat_i(proc_pif.wb_dat_i), 
    .wb_dat_o(proc_pif.wb_dat_o), 

    // WISHBONE slave
    .wb_adr_i(proc_pif.wb_adr_i), 
    .wb_sel_i(proc_pif.wb_sel_i), 
    .wb_we_i(proc_pif.wb_we_i), 
    .wb_cyc_i(proc_pif.wb_cyc_i), 
    .wb_stb_i(proc_pif.wb_stb_i), 
    .wb_ack_o(proc_pif.wb_ack_o), 
    .wb_err_o(proc_pif.wb_err_o), 
    .int_o(proc_pif.int_o),

    // WISHBONE master
    .m_wb_adr_o(mem_pif.m_wb_adr_o), 
    .m_wb_sel_o(mem_pif.m_wb_sel_o), 
    .m_wb_we_o(mem_pif.m_wb_we_o), 
    .m_wb_dat_o(mem_pif.m_wb_dat_o), 
    .m_wb_dat_i(mem_pif.m_wb_dat_i), 
    .m_wb_cyc_o(mem_pif.m_wb_cyc_o), 
    .m_wb_stb_o(mem_pif.m_wb_stb_o), 
    .m_wb_ack_i(mem_pif.m_wb_ack_i), 
    .m_wb_err_i(mem_pif.m_wb_err_i), 
    .m_wb_cti_o(mem_pif.m_wb_cti_o), 
    .m_wb_bte_o(mem_pif.m_wb_bte_o), 

    //TX
    .mtx_clk_pad_i(phy_pif.mtx_clk_pad_i), 
    .mtxd_pad_o(phy_pif.mtxd_pad_o), 
    .mtxen_pad_o(phy_pif.mtxen_pad_o), 
    .mtxerr_pad_o(phy_pif.mtxerr_pad_o),

    //RX
    .mrx_clk_pad_i(phy_pif.mrx_clk_pad_i), 
    .mrxd_pad_i(phy_pif.mrxd_pad_i), 
    .mrxdv_pad_i(phy_pif.mrxdv_pad_i), 
    .mrxerr_pad_i(phy_pif.mrxerr_pad_i), 
    .mcoll_pad_i(phy_pif.mcoll_pad_i), 
    .mcrs_pad_i(phy_pif.mcrs_pad_i),

    // MIIM
    .mdc_pad_o(mii_pif.mdc_pad_o), 
    .md_pad_i(mii_pif.md_pad_i), 
    .md_pad_o(mii_pif.md_pad_o), 
    .md_padoe_o(mii_pif.md_padoe_o)
  );


  initial begin
    wb_clk=0;
    forever #5 wb_clk=~wb_clk;
  end

  initial begin
    wb_rst=1;
    repeat(2) @(posedge wb_clk);
    wb_rst=0;
  end

  initial begin
    uvm_resource_db#(virtual wb_proc_intf)::set("GLOBAL","PROC_VIF",proc_pif,null);
    uvm_resource_db#(virtual wb_mem_intf)::set("GLOBAL","MEM_VIF",mem_pif,null);
    uvm_resource_db#(virtual phy_intf)::set("GLOBAL","PHY_VIF",phy_pif,null);
    uvm_resource_db#(virtual mii_intf)::set("GLOBAL","MII_VIF",mii_pif,null);
  end
  initial begin
//     run_test("");
     run_test("ethmac_reg_read_test");
//     run_test("ethmac_reg_write_read_test");
//     run_test("ethmac_reg_read_test_reg_model");
//     run_test("ethmac_reg_write_read_reg_model_test");
//     run_test("ethmac_reg_BD_write_read_reg_model_test");
//     run_test("ethmac_10mbps_fd_tx_test"); //working correctly
//     run_test("ethmac_100mbps_fd_tx_test"); //working correctly

//     run_test("ethmac_fd_rx_test"); //all data coming right only when the 8ns is being used for the time period else it is coming wrong
//     run_test("ethmac_fd_tx_rx_test");
//     run_test("mac_coll_hd_test");
//     run_test("mac_mii_write_ctrl_data"); //working correctly
//    run_test("ctrl_frame_test");
    run_test("tx_ctrl_frame_test");
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,proc_pif,mem_pif,phy_pif,dut);
  end
endmodule


