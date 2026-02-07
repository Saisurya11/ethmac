class phy_rx_drv extends uvm_driver#(eth_frame);
  virtual phy_intf vif;
  `uvm_component_utils(phy_rx_drv)
  `NEW_COMP
  real clk_tp;
  bit clk_en;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(bit)::read_by_name("GLOBAL","PHY_CLK_TP_EN",clk_en,this);
    uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL","PHY_VIF",vif,this);
    uvm_resource_db#(real)::read_by_name("GLOBAL","PHY_CLK_TP",clk_tp,this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      begin
        if(clk_en) begin
        forever begin
          #(clk_tp/2.0) vif.mrx_clk_pad_i=~vif.mrx_clk_pad_i;
        end
      end
      end
      begin
        forever begin
          seq_item_port.get_next_item(req);
          if(req.frame_type==0)
            drive_tx(req);
          else if(req.frame_type==1)
            drive_coll(req);
          else if(req.frame_type==2)
            drive_pause(req);
         // case(req.frame_type)
         //   ETH_FRAME:drive(req);
         //   COLL_DET:drive_coll(req);
         //   CTRL_FRAME:drive_pause(req,req.pause_frame_delay);
         // endcase
//          drive_tx(req);
          // req.print();
          seq_item_port.item_done();
        end
      end
    join
  endtask

  task drive_coll(eth_frame tx);
    //vif.mcrs_pad_i<=1;
    //#20000;
    vif.mcrs_pad_i<=0;
    wait(vif.mtxen_pad_o);
    #(tx.coll_det_delay);
    vif.mcoll_pad_i<=1;
    #1000;
    vif.mcoll_pad_i<=0;

  endtask

  task drive_pause(eth_frame tx);
    nibble_t nibble[$],n_swap;
	//tx.pause_timer='h000a;
    nibble={>>nibble_t{tx.preamble,tx.sfd,tx.da,tx.sa,tx.type_len,tx.opcode,tx.pause_timer,tx.RSVD,tx.crc}};
    for(int i=0;i<nibble.size()/2;i=i+1) begin 
      n_swap=nibble[2*i];
      nibble[2*i]=nibble[2*i+1];
      nibble[2*i+1]=n_swap;
    end
//     for(int i=0;i<nibble.size();i=i+2) begin 
//       n_swap=nibble[i];
//       nibble[i]=nibble[i+1];
//       nibble[i+1]=n_swap;
//     end
 //   #tx.pause_frame_delay;
 //   repeat(37) begin
 //     @(posedge vif.mrx_clk_pad_i);
 //     vif.mrxd_pad_i=4'h0;
 //     vif.mrxdv_pad_i=1'b1;
 //   end
    foreach(nibble[i]) begin
      $write("rx_drv: %0h ",nibble[i]);
      @(posedge vif.mrx_clk_pad_i);
      vif.mrxd_pad_i=nibble[i];
      vif.mrxdv_pad_i=1'b1;
      //       vif.mrxerr_pad_i=1'b0;
    end
    $display();
    @(posedge vif.mrx_clk_pad_i);
    vif.mrxdv_pad_i=0;
  endtask
  task drive_tx(eth_frame tx);
    //pack frame in nibble queue =, then drive each nibble, pack should be done in way that lower nibble should be packed first, followed by upper
    nibble_t nibble[$],n_swap;
    nibble={>>nibble_t{tx.preamble,tx.sfd,tx.payload,tx.crc}};
    //we have to make the toggle of odd nd even nibbles means we have to switch them becuase now lsb come if we do like above directly so to make them coorctly in the msb first manner for that we have to do the toggling
    for(int i=0;i<nibble.size()/2;i=i+1) begin 
      n_swap=nibble[2*i];
      nibble[2*i]=nibble[2*i+1];
      nibble[2*i+1]=n_swap;
    end
//     for(int i=0;i<nibble.size();i=i+2) begin 
//       n_swap=nibble[i];
//       nibble[i]=nibble[i+1];
//       nibble[i+1]=n_swap;
//     end
    repeat(9) begin //to make the completre the inside 18 cycles we are making the value high for 9 cycles rest are covered by preamble
      @(posedge vif.mrx_clk_pad_i);
      vif.mrxd_pad_i=4'h0;
      //vif.mrxdv_pad_i=1'b1; //earlier was been used
      vif.mrxdv_pad_i=1'b1;
    end

    foreach(nibble[i]) begin
      $write("rx_drv: %0h ",nibble[i]);
      @(posedge vif.mrx_clk_pad_i);
      vif.mrxd_pad_i=nibble[i];
      vif.mrxdv_pad_i=1'b1;
      //       vif.mrxerr_pad_i=1'b0;
    end
    $display();
    force $root.top.dut.macstatus1.LatchedCrcError=1'b0;
    @(posedge vif.mrx_clk_pad_i);
    vif.mrxd_pad_i=0;
    vif.mrxdv_pad_i=1'b0;
  endtask
endclass
