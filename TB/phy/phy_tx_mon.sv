class phy_tx_mon extends uvm_monitor;
  `uvm_component_utils(phy_tx_mon)
  `NEW_COMP
  eth_frame eth;
  int n_swap;
  virtual phy_intf vif;
  virtual wb_proc_intf proc_vif;
  uvm_analysis_port#(eth_frame) ap_port;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_resource_db#(virtual wb_proc_intf)::read_by_name("GLOBAL","PROC_VIF",proc_vif,this));
    uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL","PHY_VIF",vif,this);
    ap_port=new("ap_port",this);
  endfunction

  int coll_flag, coll_count;
  bit ignore_initial_0s=1;
  nibble_t nibbleq[$];
  bit frame_valid_f;
  task run_phase(uvm_phase phase);
    fork
      forever begin
        @(posedge vif.mtx_clk_pad_i);
        #1;
        if(vif.mtxen_pad_o && coll_flag==0) begin
          frame_valid_f=1;
          if(ignore_initial_0s && vif.mtxd_pad_o==4'h0) begin
            ignore_initial_0s=0;
          end
          else begin
            ignore_initial_0s=0;
            nibbleq.push_back(vif.mtxd_pad_o);
          end
        end
        else begin
          if(frame_valid_f==1) begin
            `uvm_info("TX_PKT",$psprintf("transmit packet %0t",$time),UVM_NONE)
            eth=eth_frame::type_id::create("frame");
            if(ethmac_common::delay_timer_value_enable==0) begin
              //         for(int i=7;i<(nibbleq.size()/2)-3-1;i++) begin //4 is for crc and 7 is for preamble
              //          n_swap=nibbleq[2*i];
              //           nibbleq[2*i]=nibbleq[2*i+1];
              //           nibbleq[2*i+1]=n_swap;
              //         end
              //           {eth.preamble,eth.sfd,eth.payload} = {<<nibble_t{nibbleq}};
              eth.preamble={nibbleq[0],
                            nibbleq[1],
                            nibbleq[2],
                            nibbleq[3],
                            nibbleq[4],
                            nibbleq[5],
                            nibbleq[6],
                            nibbleq[7],
                            nibbleq[8],
                            nibbleq[9],
                            nibbleq[10],
                            nibbleq[11],
                            nibbleq[12],
                            nibbleq[13]
                           };
              eth.sfd={nibbleq[15],
                       nibbleq[14]};
              frame_valid_f=0;
              for(int i=0;i<(nibbleq.size()/2)-4-7-1;i++) begin
                eth.payload.push_back({nibbleq[16+2*i+1],nibbleq[16+2*i]});
              end
              //           for(int i=0;i<16;i++) begin
              //           `uvm_info("INFO",$psprintf("printing packet=%0d",nibbleq[i]),UVM_NONE)
              //           end
              //           `uvm_info("INFO",$psprintf("printing packet=%0p",nibbleq),UVM_NONE)
              eth.crc={
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+0],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+1],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+2],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+3],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+4],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+5],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+6],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+7]
              };
            end
            else begin
              $display("#############rx_mon: control_frame##############");
              eth.preamble={nibbleq[0],
                            nibbleq[1],
                            nibbleq[2],
                            nibbleq[3],
                            nibbleq[4],
                            nibbleq[5],
                            nibbleq[6],
                            nibbleq[7],
                            nibbleq[8],
                            nibbleq[9],
                            nibbleq[10],
                            nibbleq[11],
                            nibbleq[12],
                            nibbleq[13]
                           };
              eth.sfd={nibbleq[15],
                       nibbleq[14]};
              //tx.preamble,tx.sfd,tx.da,tx.sa,tx.type_len,tx.opcode,tx.pause_timer,tx.RSVD,tx.crc
              eth.da={
                nibbleq[17],
                nibbleq[16],
                nibbleq[19],
                nibbleq[18],
                nibbleq[21],
                nibbleq[20],
                nibbleq[23],
                nibbleq[22],
                nibbleq[25],
                nibbleq[24],
                nibbleq[27],
                nibbleq[26]
              };
              eth.sa={
                nibbleq[29],
                nibbleq[28],
                nibbleq[31],
                nibbleq[30],
                nibbleq[33],
                nibbleq[32],
                nibbleq[35],
                nibbleq[34],
                nibbleq[37],
                nibbleq[36],
                nibbleq[39],
                nibbleq[38]
              };
              eth.type_len={nibbleq[41],nibbleq[40],nibbleq[43],nibbleq[42]};
              eth.opcode={nibbleq[45],nibbleq[44],nibbleq[47],nibbleq[46]};
              eth.pause_timer={nibbleq[49],nibbleq[48],nibbleq[51],nibbleq[50]};
              frame_valid_f=0;
              // for(int i=0;i<(nibbleq.size()/2)-4-7-1;i++) begin
              //   eth.payload.push_back({nibbleq[16+1+2*i],nibbleq[16+2*i]});
              // end
              //           for(int i=0;i<16;i++) begin
              //           `uvm_info("INFO",$psprintf("printing packet=%0d",nibbleq[i]),UVM_NONE)
              //           end
              //           `uvm_info("INFO",$psprintf("printing packet=%0p",nibbleq),UVM_NONE)
              eth.crc={
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+1],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+0],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+3],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+2],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+5],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+4],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+7],
                nibbleq[16+2*((nibbleq.size()/2)-4-7-1)+6]
              };
            end
            ap_port.write(eth);
            nibbleq.delete();
            eth=null;
            if(coll_flag==1) begin
              `uvm_info("TX_PKT",$psprintf("transmit packet %0t",$time),UVM_NONE)
              //eth.print();
              nibbleq.delete();
              eth=null;
              @(negedge vif.mtxen_pad_o);

            end
          end
          coll_flag=0;
          ethmac_common::pause_frame_flag=1'b0;
        end
      end
      forever begin
        @(posedge proc_vif.wb_clk_i);
        if(vif.mcoll_pad_i && coll_flag==0) begin
          ethmac_common::coll_flag=1;
          coll_flag=1;
          //$display("phy_tx_mon,collision happend");
        end
      end
    join
  endtask
endclass