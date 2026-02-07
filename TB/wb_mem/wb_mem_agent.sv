class wb_mem_agent extends uvm_agent;
  `uvm_component_utils(wb_mem_agent)
  `NEW_COMP
  memory memory_i;
  wb_mem_mon mon;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    memory_i =memory::type_id::create("memory",this);
    mon=wb_mem_mon::type_id::create("mon",this);
  endfunction
endclass
