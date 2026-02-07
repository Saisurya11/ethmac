class mac_sbd extends uvm_scoreboard;

  `uvm_analysis_imp_decl(_proc)
  `uvm_analysis_imp_decl(_mem)
  `uvm_analysis_imp_decl(_tx)
  `uvm_analysis_imp_decl(_rx)
  `uvm_component_utils(mac_sbd)
  `NEW_COMP
  int match,mismatch=0;
  uvm_analysis_imp_proc#(wb_tx,mac_sbd) imp_proc;
  uvm_analysis_imp_mem#(wb_tx,mac_sbd) imp_mem;
  uvm_analysis_imp_tx#(eth_frame,mac_sbd) imp_tx;
  uvm_analysis_imp_rx#(eth_frame,mac_sbd) imp_rx;
  bit[7:0]wr_memoryq[$],rd_memoryq[$];
  eth_frame tx_frame,rx_frame;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp_proc=new("imp_proc",this);
    imp_mem=new("imp_mem",this);
    imp_tx=new("imp_tx",this);
    imp_rx=new("imp_rx",this);
  endfunction

  function void write_proc(wb_tx tx);
    //     tx.print();
  endfunction
  function void write_mem(wb_tx tx);
    //if(ethmac_common::coll_flag) begin
    //    $display("memory_Rd=%0p",rd_memoryq);
    //wr_memoryq.delete();
    //rd_memoryq.delete();
    //end
    if(tx.wr_rd==1) begin //this is the data received from the PHYBFM
      $display("SBD:%0t wr_queue rx data=%0h",$time,tx.data);
      //      wr_memoryq.push_back({tx.data[27:24],tx.data[31:28]});
      //      wr_memoryq.push_back({tx.data[19:16],tx.data[23:20]});
      //      wr_memoryq.push_back({tx.data[12:8],tx.data[15:12]});
      //      wr_memoryq.push_back({tx.data[3:0],tx.data[7:4]});
      wr_memoryq.push_back(tx.data[31:24]);
      wr_memoryq.push_back(tx.data[23:16]);
      wr_memoryq.push_back(tx.data[15:8]);
      wr_memoryq.push_back(tx.data[7:0]);
    end 
    else begin //this is the data transmistted to the phy BFM
      //       rd_memoryq.push_back(tx.data[31:24]);
      //       rd_memoryq.push_back(tx.data[23:16]);
      //       rd_memoryq.push_back(tx.data[15:8]);
      //       rd_memoryq.push_back(tx.data[7:0]);
      $display("SBD:%0t rd_memoryq tx data=%0h",$time,tx.data);
      repeat(4) begin
        rd_memoryq.push_back({tx.data[31:28],tx.data[27:24]});
        tx.data=tx.data<<8;
      end
      //  rd_memoryq.push_back({tx.data[27:24],tx.data[31:28]});
      //  rd_memoryq.push_back({tx.data[19:16],tx.data[23:20]});
      //  rd_memoryq.push_back({tx.data[12:8],tx.data[15:12]});
      //  rd_memoryq.push_back({tx.data[3:0],tx.data[7:4]});
    end
  endfunction
  function void write_tx(eth_frame tx);
    $display("############# MAC_SBD: DUT Transmitted frame ###########");
    tx.print();
    $cast(tx_frame,tx);
  endfunction
  function void write_rx(eth_frame tx);
    $display("############# MAC_SBD: DUT Received frame ###########");
    tx.print();
    $cast(rx_frame,tx);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin  
      if(rx_frame==null)
        $display("sbd: %0t, rx_frame is null",$time);


      //       $display("interrupt=%0b",ethmac_common::int_o_genrated);

      wait(
        ((ethmac_common::int_o_genrated_sbd==1'b1) || (ethmac_common::coll_flag==1))
        &&
        (
          (tx_frame!=null && rd_memoryq.size()>0)|| (rx_frame!=null && wr_memoryq.size()>0) || (tx_frame!=null && ethmac_common::delay_timer_value_enable)
        )
      );
      ethmac_common::int_o_genrated_sbd=0;
      ethmac_common::coll_flag=0;
      //       if(tx_frame!=null) 
      //         tx_frame.print();
      //       else $display("SBD:  ");
      // $display("memory_Rd=%0p",rd_memoryq);

      //      $display("rx_frame");
      //       foreach(rx_frame.payload[i])
      //         $write("%0h ",rx_frame.payload[i]);

      //       $display("memory_wr=%0p",wr_memoryq);
      //      $display("working");
      ethmac_common::int_o_genrated_sbd=1'b0;
      if(tx_frame!=null && ethmac_common::delay_timer_value_enable==0) begin
        $write("rd_memory =");
        foreach(rd_memoryq[i])
          $write("%0h ",rd_memoryq[i]);
        $display();
        foreach(tx_frame.payload[i]) begin
          if(tx_frame.payload[i]==rd_memoryq[i]) begin
            `uvm_info("SBD_CHECK",$psprintf("DATA TX MATCH:mem_rd_data=%0h, frame data=%0h",rd_memoryq[i],tx_frame.payload[i]),UVM_NONE)
            match++;
          end
          else begin
            mismatch++;
            `uvm_error("SBD_CHECK",$psprintf("DATA TX Frame MIS MATCH:mem_rd_data=%0h, frame data=%0h",rd_memoryq[i],tx_frame.payload[i]))
          end
        end
        #5;
        tx_frame=null;
        rd_memoryq.delete();
      end
      if(rx_frame!=null && ethmac_common::delay_timer_value_enable==0) begin
        $display("sbd: %0t, rx_frame is not null",$time);
        $write("wr_memory =");
        foreach(wr_memoryq[i])
          $write("%0h ",wr_memoryq[i]);
        $display();
        //        rx_frame.print();
        foreach(rx_frame.payload[i]) begin
          if(rx_frame.payload[i]==wr_memoryq[i]) begin
            `uvm_info("SBD_CHECK",$psprintf("DATA RX MATCH:mem_wr_data=%0h, frame data=%0h",wr_memoryq[i],rx_frame.payload[i]),UVM_NONE)
            match++;
          end
          else begin
            `uvm_error("SBD_CHECK",$psprintf("DATA RX Frame MIS MATCH:mem_wr_data=%0h, frame data=%0h",wr_memoryq[i],rx_frame.payload[i]))
            mismatch++;
          end
        end
        #5;
        // ethmac_common::int_o_genrated_sbd=0;

        rx_frame=null;
        wr_memoryq.delete();
      end
	  
      if(ethmac_common::delay_timer_value_enable && tx_frame.pause_timer == ethmac_common::delay_timer_value && tx_frame.type_len==ethmac_common::frame_len && tx_frame.opcode == ethmac_common::frame_opcode) begin
        match++;
      end
      else if(ethmac_common::delay_timer_value_enable && tx_frame.pause_timer != ethmac_common::delay_timer_value && tx_frame.type_len!=ethmac_common::frame_len && tx_frame.opcode != ethmac_common::frame_opcode)
        mismatch++;
		
      ethmac_common::coll_flag=0;
      ethmac_common::memory_delay_sbd_flag=1;
    end
  endtask

  function void report_phase(uvm_phase phase);
    if(mismatch>0)
      begin
        $display("###############################################################");
        $display("##################UVM_SCOREBOARD::FAILED#######################");
        $display("###############################################################");
      end
    else if(match>0 && mismatch==0)begin
      $display("###############################################################");
      $display("##################UVM_SCOREBOARD::PASSED#######################");
      $display("###############################################################");
    end
  endfunction
endclass
