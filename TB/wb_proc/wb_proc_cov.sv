class wb_proc_cov extends uvm_subscriber#(wb_tx);
  `uvm_component_utils(wb_proc_cov)
  wb_tx temp[$],tx;
  
  covergroup wb_proc_cg;
    ADDR_CP:coverpoint tx.addr{
      bins MODER={10'h0};
      bins INT_SRC={10'h1};
      bins INT_MSK={10'h2};
      bins IPGT={10'h3};
      bins IPGR1={10'h4};
      bins IPGR2={10'h5};
      bins PACKETLEN={10'h6};
      bins COLL_CONF={10'h7};
      bins TX_BD_NUM={10'h8};
      bins CTRLMODER={10'h9};
      bins MIIMODER={10'hA};
      bins MIICOMMAND={10'hB};
      bins MIIADDRESS={10'hC};
      bins MII_TX_dATA={10'hD};
      bins MII_RX_dATA={10'hE};
      bins MIISTATUS={10'hF};
      bins MAC_ADDR0={10'h10};
      bins MAC_ADDR1={10'h11};
      bins ETH_HASH0_ADR={10'h12};
      bins ETH_HASH1_ADR={10'h13};
      bins ETH_TXCTRLR={10'h14};
    }
    WR_RD_CP: coverpoint tx.wr_rd{
      bins WRITE={1'b1};
      bins READ={1'b0};
    }
    
    ADDR_X_WR_RD:cross ADDR_CP,WR_RD_CP;
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
      wb_proc_cg.sample();
    end
  endtask
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COVERAGE",$psprintf("Coverage=%0.3f",wb_proc_cg.get_inst_coverage()),UVM_NONE)
  endfunction
endclass