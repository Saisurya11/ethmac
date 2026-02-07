class memory extends uvm_component;
  bit[31:0] mem[int]; //each location is having 4 bytes for 512 we have to use 128
  virtual wb_mem_intf vif;
  `uvm_component_utils(memory);
  `NEW_COMP
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual wb_mem_intf)::read_by_name("GLOBAL","MEM_VIF",vif,this);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    //pre-load the memory
    for(int i=0;i<512;i++) begin
      mem[32'h1000_0000+i]=$random;
    end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.wb_clk_i);
      #1;
      if(vif.m_wb_cyc_o && vif.m_wb_stb_o) begin
        vif.m_wb_ack_i=1'b1;
        if(vif.m_wb_we_o == 1'b1) begin
          
          mem[vif.m_wb_adr_o]=vif.m_wb_dat_o;
        end
        else begin
          vif.m_wb_dat_i=mem[vif.m_wb_adr_o];
        end
      end
      else begin
        vif.m_wb_ack_i=1'b0;
         vif.m_wb_dat_i=1'b0;
      end
    end
  endtask
endclass
