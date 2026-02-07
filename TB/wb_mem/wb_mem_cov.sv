class wb_proc_cov extends uvm_subscriber#(wb_tx);
  `uvm_component_utils(wb_proc_cov)
  wb_tx temp[$],tx;
  
  covergroup wb_proc_cg;
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    wb_proc_cg=new();
  endfunction
  
  function void write(wb_tx t);
    temp.push_back(t);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      wait(temp.size()>0);
      tx=temp.pop_front();
    end
  endtask
endclass