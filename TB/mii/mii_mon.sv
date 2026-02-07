class mii_mon extends uvm_monitor;
  `uvm_component_utils(mii_mon)
  `NEW_COMP
  virtual mii_intf vif;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual mii_intf)::read_by_name("GLOBAL","MII_VIF",vif,this);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
    end
  endtask
endclass