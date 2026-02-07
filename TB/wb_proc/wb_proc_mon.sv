class wb_proc_mon extends uvm_monitor;  //will have register coding into the ethmac
  wb_tx tx;
  `uvm_component_utils(wb_proc_mon)
  `NEW_COMP
  virtual wb_proc_intf vif;
  uvm_analysis_port#(wb_tx) ap_port;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual wb_proc_intf)::read_by_name("GLOBAL","PROC_VIF",vif,this);
    ap_port=new("ap_port",this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.wb_clk_i);
      #1; //need to add the clocking block
      if(vif.wb_stb_i && vif.wb_cyc_i && vif.wb_ack_o) begin
        tx=wb_tx::type_id::create("wb_tx");
        tx.addr=vif.wb_adr_i;
        tx.data=(vif.wb_we_i==1'b1)? vif.wb_dat_i:vif.wb_dat_o;
        tx.wr_rd=vif.wb_we_i;
        tx.sel=vif.wb_sel_i;
        ap_port.write(tx);
      end
    end
  endtask
endclass