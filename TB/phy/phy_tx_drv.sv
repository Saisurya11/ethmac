class phy_tx_drv extends uvm_driver#(eth_frame);
  virtual phy_intf vif;
  `uvm_component_utils(phy_tx_drv)
  `NEW_COMP
  real clk_tp;
  bit clk_en;
  int nibble_count=0;
  eth_frame tx;
  bit [7:0]byte_collected,byteq[$];
  bit tx_collected_in_progerss_f;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tx_collected_in_progerss_f=0;
    uvm_resource_db#(virtual phy_intf)::read_by_name("GLOBAL","PHY_VIF",vif,this);
    uvm_resource_db#(real)::read_by_name("GLOBAL","PHY_CLK_TP",clk_tp,this);
    uvm_resource_db#(bit)::read_by_name("GLOBAL","PHY_CLK_TP_EN",clk_en,this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      if(clk_en) begin
         forever begin
          #(clk_tp/2.0) vif.mtx_clk_pad_i=~vif.mtx_clk_pad_i;
         end
      end
      forever begin
        @(posedge vif.mtx_clk_pad_i);
        if(vif.mtxen_pad_o) begin
          tx_collected_in_progerss_f=1;
          nibble_count++;
          if(nibble_count%2==1)   byte_collected[3:0]= vif.mtxd_pad_o;
          if(nibble_count%2==0) begin
            byte_collected[7:4]= vif.mtxd_pad_o;
            byteq.push_back(byte_collected);
          end
        end
        if(tx_collected_in_progerss_f==1 && vif.mtxen_pad_o==0) begin
          tx_collected_in_progerss_f=0;
          tx=eth_frame::type_id::create("eth_frame");
          {>>byte{tx.preamble,tx.sfd,tx.payload,tx.crc}}=byteq;
          //           $display("phy_tx:drv  byteq=%0p",byteq);
//           tx.print();
          byteq.delete();
        end
      end
    join
  endtask
endclass
