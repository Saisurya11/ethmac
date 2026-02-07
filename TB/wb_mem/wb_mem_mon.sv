class wb_mem_mon extends uvm_monitor;
  wb_tx tx, txqueue[$];
  `uvm_component_utils(wb_mem_mon)
  `NEW_COMP
  bit flag=1;
  virtual wb_mem_intf vif;
  uvm_analysis_port#(wb_tx) ap_port;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual wb_mem_intf)::read_by_name("GLOBAL","MEM_VIF",vif,this);
    ap_port=new("ap_port",this);
  endfunction

  task run_phase(uvm_phase phase);
  fork
    forever begin
      @(posedge vif.wb_clk_i);
      if(vif.m_wb_stb_o && vif.m_wb_cyc_o && vif.m_wb_ack_i) begin
        tx=wb_tx::type_id::create("wb_tx");
        tx.addr=vif.m_wb_adr_o;
        tx.data=vif.m_wb_we_o? vif.m_wb_dat_o:vif.m_wb_dat_i;
        tx.wr_rd=vif.m_wb_we_o;
        tx.sel=vif.m_wb_sel_o;
		txqueue.push_back(tx);
        //ap_port.write(tx);
      end
    end	
	forever begin
	wait(txqueue.size()>0);
	wait(ethmac_common::int_o_genrated_sbd==0)
	#10;
	ap_port.write(txqueue.pop_front());
	
	end
	join
  endtask
endclass