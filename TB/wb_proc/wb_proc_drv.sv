class wb_proc_drv extends uvm_driver#(wb_tx);
  virtual wb_proc_intf vif;
  wb_tx tx;
  `uvm_component_utils(wb_proc_drv)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_resource_db#(virtual wb_proc_intf)::read_by_name("GLOBAL","PROC_VIF",vif,this));
  endfunction

  task run_phase(uvm_phase phase);
    fork
      begin
        forever begin
          seq_item_port.get_next_item(req);
          //       req.print();
          drive_tx(req);
          seq_item_port.item_done();
        end
      end
      begin
        forever begin
          @(posedge vif.int_o); //whenever interrupt is genrated
          //indicate seq that in got genrated
          $display("wb_drv: interrupt genrated");
          ethmac_common::int_o_genrated=1;
          ethmac_common::int_o_genrated_sbd=1;
	  
        end
      end
    join
  endtask
  task drive_tx(wb_tx tx);
    @(posedge vif.wb_clk_i);
    #1;
    vif.wb_adr_i=tx.addr;
    vif.wb_we_i=tx.wr_rd;
    if(tx.wr_rd==1) vif.wb_dat_i=tx.data;
    vif.wb_sel_i=4'hF; //all 4bytes are valid
    vif.wb_cyc_i=1'b1;
    vif.wb_stb_i=1'b1;
    wait(vif.wb_ack_o==1'b1);
    if(tx.wr_rd==0) tx.data=vif.wb_dat_o;
//     @(posedge vif.wb_clk_i);
    #1;
    reset_signals();
  endtask

  task reset_signals();
    vif.wb_adr_i=0;
    vif.wb_we_i=0;
    vif.wb_dat_i=0;
    vif.wb_sel_i=0; //all 4bytes are valid
    vif.wb_cyc_i=1'b0;
    vif.wb_stb_i=1'b0;
  endtask
endclass
