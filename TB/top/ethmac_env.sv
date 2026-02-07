class ethmac_env extends uvm_env;
  wb_proc_agent       proc_agent_i;
  wb_mem_agent        mem_agent_i;
  phy_tx_agent     phy_tx_agent_i;
  phy_rx_agent     phy_rx_agent_i;
  mii_agent           mii_agent_i;
  mac_sbd					  sbd;
  mac_reg_block reg_block;
  wb_adapter adapter;
  `uvm_component_utils(ethmac_env)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    proc_agent_i=wb_proc_agent::type_id::create("proc_agent_i",this);
    mem_agent_i=wb_mem_agent::type_id::create("mem_agent_i",this);
    phy_tx_agent_i=phy_tx_agent::type_id::create("phy_tx_agent_i",this);
    phy_rx_agent_i=phy_rx_agent::type_id::create("phy_rx_agent_i",this);
    sbd=mac_sbd::type_id::create("sbd",this);
    mii_agent_i=mii_agent::type_id::create("mii_agent_i",this);

    reg_block=mac_reg_block::type_id::create("reg_block",this);

    uvm_resource_db#(mac_reg_block)::set("GLOBAL","MAC_RM",reg_block,this);

    reg_block.build();
    adapter=wb_adapter::type_id::create("wb_adapter",this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    reg_block.wb_map.set_sequencer(proc_agent_i.sqr,adapter);
    proc_agent_i.mon.ap_port.connect(sbd.imp_proc);
    mem_agent_i.mon.ap_port.connect(sbd.imp_mem);
    phy_tx_agent_i.mon.ap_port.connect(sbd.imp_tx);
    phy_rx_agent_i.mon.ap_port.connect(sbd.imp_rx);
  endfunction
endclass