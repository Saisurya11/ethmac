class phy_rx_mon extends uvm_monitor;
  `uvm_component_utils(phy_rx_mon)
  `NEW_COMP
  eth_frame eth;
  int n_swap;
  uvm_analysis_port#(eth_frame) ap_port;
  virtual phy_intf vif;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL","PHY_VIF",vif,this);
    ap_port=new("ap_port",this);
  endfunction

  bit ignore_initial_0s=1;
  nibble_t nibbleq[$];
  bit frame_valid_f;

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.mrx_clk_pad_i);
      #1;
      if(vif.mrxdv_pad_i) begin
        frame_valid_f=1;
        if(ignore_initial_0s && vif.mrxd_pad_i==4'h0) begin
          //           ignore_initial_0s=0;
        end
        else begin
          ignore_initial_0s=0;
          nibbleq.push_back(vif.mrxd_pad_i);
          $display("phy_rx_mon: %0t: vif.mrxd_pad_i=%0h",$time,vif.mrxd_pad_i);
        end
      end
      else begin
        if(frame_valid_f==1) begin
          eth=eth_frame::type_id::create("frame");
		  $display("rx_mon: delay+_timer_enable=%0d",ethmac_common::delay_timer_value_enable);
		 
         /* for(int i=7;i<(nibbleq.size()/2);i++) begin //4 is for crc and 7 is for preamble
            n_swap=nibbleq[2*i];
            nibbleq[2*i]=nibbleq[2*i+1];
            nibbleq[2*i+1]=n_swap;
          end
		  */
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
            eth.payload.push_back({nibbleq[16+1+2*i],nibbleq[16+2*i]});
          end
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
          ap_port.write(eth);
//           eth.print();
        end
	  end
    end
  endtask
endclass
