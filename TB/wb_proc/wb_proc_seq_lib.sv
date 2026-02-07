class wb_proc_base_seq extends uvm_sequence#(wb_tx);
  `uvm_object_utils(wb_proc_base_seq);
  `NEW_OBJ
  uvm_phase phase;
  task pre_body();
    phase=get_starting_phase();
    if(phase!=null) begin
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this,100);
    end
  endtask
  task post_body();
    if(phase!=null)
      phase.drop_objection(this);

  endtask
endclass

class wb_reg_read_seq extends wb_proc_base_seq; //1st test, read using genral model
  `uvm_object_utils(wb_reg_read_seq)
  `NEW_OBJ
  task body();
    for(int i=0;i<21;i++) begin //check this
      wb_tx tx=wb_tx::type_id::create("wb_tx");
      `uvm_do_with(req, {req.wr_rd==0;req.addr==i;})  //here are sending the addresses as 1,2,3, in the +1 incremental form but the actuall addressing will be mulitple of 4 but in the rtl we have neglected the last 2 bits becuase the last bits will be alwyas zero for 4 multiple so as we are not caring about the last 2 lsb bits it is going in the +1 series, then value can be checked in the ethmac_Defines
    end
  endtask
endclass

class wb_reg_read_reg_model_seq extends wb_proc_base_seq; //read using the reg model
  int errors;
  uvm_reg_data_t ref_data;
  uvm_reg_data_t data;
  string reg_name;
  uvm_reg mac_regs[$];
  uvm_status_e status;
  `uvm_object_utils(wb_reg_read_reg_model_seq)
  `NEW_OBJ
  task body;
    mac_reg_block mac_reg_block_i;
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
    mac_reg_block_i.get_registers(mac_regs); //getting all the registers handles in mac_regs, queue of 21 registers
    repeat(10) begin
      //       mac_regs.shuffle();
      foreach(mac_regs[i]) begin
        ref_data=mac_regs[i].get_reset();
        mac_regs[i].read(status,data,.parent(this));
        //         `uvm_info("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected: %0h Actual: %0h",mac_regs[i].get_name(),ref_data,data),UVM_NONE)
        if(ref_data!=data) begin
          `uvm_error("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected: %0h Actual: %0h",mac_regs[i].get_name(),ref_data,data))
          errors++;
        end
      end
    end
  endtask
endclass



class wb_reg_write_read_seq extends wb_proc_base_seq; //write read without using reg model
  `uvm_object_utils(wb_reg_write_read_seq)
  `NEW_OBJ
  bit[31:0]data_t;
  task body();
    //writing all regisgters
    for(int i=0;i<21;i++) begin //check this
     // $display("wb_proc_seq_lin, wb_Reg_write_read_seq: checking");
      data_t=$random & ethmac_common::regmaskA[i];
      //             `uvm_do_with(req, {req.wr_rd==1;req.addr==i;req.data==data_t;})
      `uvm_do_with(req, {req.wr_rd==1;req.data==data_t;req.addr==i;}) 
    end
    //reading all reegisters
    for(int i=0;i<21;i++) begin //check this
      `uvm_do_with(req, {req.wr_rd==0;req.addr==i;})
    end
  endtask
endclass




class wb_reg_write_read_reg_model_seq extends wb_proc_base_seq; //write read using reg model
  int errors;
  uvm_reg_data_t ref_data;
  rand uvm_reg_data_t data;
  uvm_reg_data_t miicommand_wr_data;
  uvm_reg_addr_t addr;
  string reg_name;
  uvm_reg mac_regs[$];
  uvm_status_e status;
  `uvm_object_utils(wb_reg_write_read_reg_model_seq)
  `NEW_OBJ
  task body;
    mac_reg_block mac_reg_block_i;
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
    mac_reg_block_i.get_registers(mac_regs); //getting all the registers handles in mac_regs, queue of 21 registers
    repeat(100) begin
      errors=0;
      mac_regs.shuffle();
      foreach(mac_regs[i]) begin
        if(!this.randomize()) begin
          `uvm_error("body","randomization error");
        end
        reg_name=mac_regs[i].get_name();

      //  if(reg_name=="txbdnum") begin //they written for miicommand 
      //    if(data>'h80)
      //      data='h7F;
      //  end

      //  if(reg_name=="miicommand") begin
      //    miicommand_wr_data=data;
      //  end

		  //  if(reg_name=="moder")
	    //  	data[1:0]=2'b00;

        mac_regs[i].write(status,data,.parent(this)); //performing a wrire
      end
      //if(miicommand_wr_data[0]==1) begin
        //assert(mac_reg_block_i.miistatus.predict(3'b110));
      //end
        //mac_reg_block_i.miistatus.mirror(status);
        //mac_reg_block_i.miicommand.mirror(status);
	  
      mac_regs.shuffle();
      foreach(mac_regs[i]) begin
        mac_regs[i].read(status,data,.parent(this));
        
        reg_name=mac_regs[i].get_name();

        //if(reg_name=="miistatus")
         // mac_regs[i].mirror(status);

        ref_data=mac_regs[i].get();
        //         `uvm_info("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected: %0h Actual: %0h",mac_regs[i].get_name(),ref_data,data),UVM_NONE)
        if(ref_data!=data) begin
          `uvm_error("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected (ref_data from the ral model): %0h Actual (readed from the dut): %0h",mac_regs[i].get_name(),ref_data,data))
          errors++;
        end
      end
    end
  endtask
endclass

class wb_reg_BD_write_read_reg_model_seq extends wb_proc_base_seq; //write read using reg model but in Backdoor
  int errors;
  uvm_reg_data_t ref_data;
  rand uvm_reg_data_t data;
  uvm_reg_data_t miicommand_wr_data;
  uvm_reg_addr_t addr;
  string reg_name;
  uvm_reg mac_regs[$];
  uvm_status_e status;
  `uvm_object_utils(wb_reg_BD_write_read_reg_model_seq)
  `NEW_OBJ
  task body;
    mac_reg_block mac_reg_block_i;
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
    mac_reg_block_i.get_registers(mac_regs); //getting all the registers handles in mac_regs, queue of 21 registers
    repeat(10) begin
      errors=0;
      mac_regs.shuffle();
      foreach(mac_regs[i]) begin
        if(!this.randomize()) begin
          `uvm_error("body","randomization error");
        end
        reg_name=mac_regs[i].get_name();
        if(reg_name=="txbdnum") begin //they written for miicommand 
          //           $display("txbdnum");
          if(data>'h80)
            data='h7F;
        end
        //         if(reg_name=="miicommand") begin
        //           miicommand_wr_data=data;
        //         end
        //         if(reg_name=="miitxdata" || reg_name=="miiaddress")
        //           $display("data=%0h",data);
        mac_regs[i].poke(status,data,.parent(this)); //performing a wrire
      end
      //       if(miicommand_wr_data[0]==1) begin
      //         assert(mac_reg_block_i.miistatus.predict(3'b110));
      //       end
      mac_regs.shuffle();
      foreach(mac_regs[i]) begin
        ref_data=mac_regs[i].get();
        mac_regs[i].peek(status,data,.parent(this));
        //`uvm_info("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected: %0h Actual: %0h",mac_regs[i].get_name(),ref_data,data),UVM_NONE)
        if(ref_data!=data) begin
          `uvm_error("REG_TEST_SEG:",$sformatf("get/read:Read Error for %s:Expected: %0h Actual: %0h",mac_regs[i].get_name(),ref_data,data))
          errors++;
        end
      end
    end
  endtask
endclass


class ethmac_10mbps_fd_tx_seq extends wb_proc_base_seq;
  rand uvm_reg_data_t data,d1;
  uvm_status_e status;
  `uvm_object_utils(ethmac_10mbps_fd_tx_seq)
  `NEW_OBJ
  bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  task body;
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));

    //uvm_do_with(req,req.addr==13'h0;reg.data==data_t;req_write==1);
    data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=1; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=0; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=0; //TXEN
    data[0]=0; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);

    //un mask the interrupt
    d1='d0;
    d1[0]=1'b1;
         mac_reg_block_i.intrmsk.write(status,d1);
  // // `uvm_do_with(req,{req.addr=='h2;req.data==d1;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101

    //Load TX_BD

    //we cant load this using reg model becuase it doesnt have address and according tot he spec the tx_bd address sts from 0x400 - 0x7FF(total 128 x 64 bit)
    data_offset_0={16'h100,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h100;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h101;req.data==data_offset_1;req.wr_rd==1;})

    //rest all fields are same only write TXEN=1
    data[1]=1'b1; //TXEN
    mac_reg_block_i.moder.write(status,data);
  endtask
endclass


class int_wait extends wb_proc_base_seq;
  `uvm_object_utils(int_wait)
  `NEW_OBJ
  mac_reg_block mac_reg_block_i;

  task body;
    uvm_status_e status;
    uvm_reg_data_t data;//int_src_reg_data
    //         mac_reg_block mac_reg_block_i;
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));


    forever begin
      wait(ethmac_common::int_o_genrated==1);
       #0.1;
      
      mac_reg_block_i.intrsrc.read(status, data);
//       if(ethmac_common::exp_int_src_reg_val_tx==data) begin
//         `uvm_error("data",$psprintf("%0t: tx expected =%0b, data=%0b",$time,ethmac_common::exp_int_src_reg_val_tx,data))
//         `uvm_error("data",$psprintf("data=%b",data))
//       end
//       else if(ethmac_common::exp_int_src_reg_val_rx==data) begin
//         `uvm_error("data",$psprintf("%0t: rx expected =%1b, data=%0b",$time,ethmac_common::exp_int_src_reg_val_rx,data))
//         `uvm_error("data",$psprintf("data=%b",data))
//       end
          if(ethmac_common::exp_int_src_reg_val!=data) begin
              `uvm_error("INT_ERROR","interrupt_Data tx/rx error");
             `uvm_error("data",$psprintf("expected =%0b",ethmac_common::exp_int_src_reg_val))
             `uvm_error("data",$psprintf("data=%0b",data))
            end
      mac_reg_block_i.intrsrc.write(status, data);
	  ethmac_common::int_o_genrated=0;
    end
  endtask
endclass


class ethmac_fd_rx_seq extends wb_proc_base_seq;
  rand uvm_reg_data_t data,d1;
  uvm_status_e status;
  `uvm_object_utils(ethmac_fd_rx_seq)
  `NEW_OBJ
  bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  task body;
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));

    //     uvm_do_with(req,req.addr==13'h0;req.data==data_t;req_write==1);
    data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=1; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=0; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=0; //TXEN
    data[0]=0; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);

    //un mask the interrupt
    d1[2]=1'b1;
    mac_reg_block_i.intrmsk.write(status,d1);
    //     `uvm_do_with(req,{req.addr=='h2;req.data==d1;req.wr_rd==1;})

  
    //Load RX_BD
    data_offset_0={16'h40,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h2000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h180;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 180, not 600 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 201
    `uvm_do_with(req,{req.addr==13'h181;req.data==data_offset_1;req.wr_rd==1;})


    data[0]=1'b1;
    mac_reg_block_i.moder.write(status,data);
  endtask
endclass



class ethmac_fd_tx_rx_seq extends wb_proc_base_seq;
  rand uvm_reg_data_t data,d1;
  uvm_status_e status;
  `uvm_object_utils(ethmac_fd_tx_rx_seq)
  `NEW_OBJ
  bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  task body;
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));

    //uvm_do_with(req,req.addr==13'h0;reg.data==data_t;req_write==1);
    data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=1; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=0; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=0; //TXEN
    data[0]=0; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);

    //un mask the interrupt
    d1[0]=1'b1;
    d1[2]=1'b1;
    mac_reg_block_i.intrmsk.write(status,d1);
    //     `uvm_do_with(req,{req.addr=='h2;req.data==d1;req.wr_rd==1;})


    //Load RX_BD
    data_offset_0={16'h60,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h2000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h180;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 180, not 600 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 201
    `uvm_do_with(req,{req.addr==13'h181;req.data==data_offset_1;req.wr_rd==1;})

   
    //Load TX_BD
    data_offset_0={16'h60,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h100;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h101;req.data==data_offset_1;req.wr_rd==1;})



    //rest all fields are same only write TXEN=1
    data[0]=1'b1;
    data[1]=1'b1; //intrsrc
    mac_reg_block_i.moder.write(status,data);
  endtask
endclass


class mac_mii_write_ctrl_data_seq extends wb_proc_base_seq;
          rand uvm_reg_data_t miimoder_data=0;
          rand uvm_reg_data_t miicommand_data=0;
          rand uvm_reg_data_t miistatus_data=0;
          rand uvm_reg_data_t miiaddress_data=0;
          rand uvm_reg_data_t miitx_data=0;
          rand uvm_reg_data_t miirx_data=0;
          rand uvm_reg_data_t read_data=0;
          int count;
          uvm_status_e status;
          `uvm_object_utils(mac_mii_write_ctrl_data_seq)
          `NEW_OBJ
          bit [31:0]data_offset_1;
          bit [31:0]data_offset_0;
          task body;
            uvm_reg_addr_t addr;
            string reg_name;
            int errors;
            mac_reg_block mac_reg_block_i;
            //we need register handle model
            assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
        
            //     uvm_do_with(req,req.addr==13'h0;req.data==data_t;req_write==1);
            miimoder_data[31:9]='h0;
            miimoder_data[8]=1; //1=no preamble , 0 for preamble it is for MII
            miimoder_data[7:0]=1; //clk factor
            mac_reg_block_i.miimoder.write(status,miimoder_data,.parent(this));

            miicommand_data[2]=1'b1; //write
            miicommand_data[1]=1'b0; //read
            miicommand_data[0]=1'b0; //scan
//            `uvm_do_with(req,{req.addr=='hB;req.data=='h4;req.wr_rd==1;})
            mac_reg_block_i.miicommand.write(status,miicommand_data);
            
            
            miiaddress_data=32'b0;
            miiaddress_data[4:0]=5'h10; //phy addres
            miiaddress_data[12:8]=5'h07; //reg address
            mac_reg_block_i.miiaddress.write(status,miiaddress_data,.parent(this));


            miitx_data=32'b0;
            miitx_data[15:0]=16'hAA33; //1010_1010_0011_0011
            mac_reg_block_i.miitxdata.write(status,miitx_data,.parent(this));
            
            ///miirx_data=32'b0;
            ///miirx_data[15:0]=16'hAA33; //1010_1010_0011_0011
            ///mac_reg_block_i.miirx.write(status,miirx);
            
            mac_reg_block_i.miistatus.read(status,miistatus_data);
          while(miistatus_data[1]==1) begin
            mac_reg_block_i.miistatus.read(status,miistatus_data,.parent(this));
            count++;
          end

          if(miistatus_data[0]==1'b1) begin
            `uvm_error("MII","Link failed");
          end
          else
          begin
            `uvm_info("MII:wb_proc_seq_lib","MII_WORKING",UVM_NONE)
          end
          if(miistatus_data[2]==1'b1) begin
            `uvm_error("MII","Link failed");
          end
             $display("WB_PROC_SEQ_LIB:count=%0d",count);
             mac_reg_block_i.miicommand.read(status,read_data);
            `uvm_info("wb_proc_seq_lib",$psprintf("read_Data=%b",read_data),UVM_NONE)
            
            mac_reg_block_i.miiaddress.read(status,read_data);
            `uvm_info("wb_proc_seq_lib",$psprintf("mii_address: read_Data=%b",read_data),UVM_NONE)
          endtask
endclass


//in puase frame genration we have to configure the ctrlmoder, for that data[1]=1,rest are zero and this sequence has to be used in the test library, make the transmit and recive also enable in mdoer for transmission


//half duplex
class ethmac_10mbps_hd_tx_seq extends wb_proc_base_seq;
  rand uvm_reg_data_t data,d1;
  uvm_status_e status;
  `uvm_object_utils(ethmac_10mbps_hd_tx_seq)
  `NEW_OBJ
  bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  task body;
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));

    //uvm_do_with(req,req.addr==13'h0;reg.data==data_t;req_write==1);
    data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=0; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=0; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=0; //TXEN
    data[0]=0; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);

    //un mask the interrupt
    d1='d0;
    d1[0]=1'b1;
         mac_reg_block_i.intrmsk.write(status,d1);
   // `uvm_do_with(req,{req.addr=='h2;req.data==d1;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101

    //Load TX_BD

    //we cant load this using reg model becuase it doesnt have address and according tot he spec the tx_bd address sts from 0x400 - 0x7FF(total 128 x 64 bit)
    data_offset_0={16'h60,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h100;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h101;req.data==data_offset_1;req.wr_rd==1;})

    //rest all fields are same only write TXEN=1
    data[1]=1'b1; //TXEN
    mac_reg_block_i.moder.write(status,data);
//    data=32'h0000_0013;
//    mac_reg_block_i.ipgt.write(status,data);
    mac_reg_block_i.moder.read(status,data);
  endtask
endclass

// Code your testbench here
// or browse Examples
class ethmac_fd_pause_rx_seq extends wb_proc_base_seq; //pause frame reception at ethmac
  rand uvm_reg_data_t data,data_interrupt;
  uvm_status_e status;
    bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  `uvm_object_utils(ethmac_fd_pause_rx_seq)
  `NEW_OBJ
  task body();
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
	 //uvm_do_with(req,req.addr==13'h0;reg.data==data_t;req_write==1);

	
    data='d0;
    data[1:0]=2'b11;
    mac_reg_block_i.ctrlmoder.write(status, data);
	
	
    data_interrupt='d0;
    data_interrupt[6]=1'b1;
    data_interrupt[0]=1'b1;
    mac_reg_block_i.intrmsk.write(status,data_interrupt);
	
	//Load TX_BD

    //we cant load this using reg model becuase it doesnt have address and according tot he spec the tx_bd address sts from 0x400 - 0x7FF(total 128 x 64 bit)
    data_offset_0={16'h100,1'b1,1'b1,1'b0,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h100;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h101;req.data==data_offset_1;req.wr_rd==1;})
	
	//we cant load this using reg model becuase it doesnt have address and according tot he spec the tx_bd address sts from 0x400 - 0x7FF(total 128 x 64 bit)
    data_offset_0={16'h50,1'b1,1'b1,1'b1,4'b0,1'b1, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h102;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h103;req.data==data_offset_1;req.wr_rd==1;})
	
	//Load RX_BD
    data_offset_0={16'h40,1'b1,1'b1,1'b1,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h2000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h180;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 180, not 600 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 201
    `uvm_do_with(req,{req.addr==13'h181;req.data==data_offset_1;req.wr_rd==1;})


	
    data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=1; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=1; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=1; //TXEN
    data[0]=1; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);
  endtask
endclass


class tx_ctrl_frame extends wb_proc_base_seq;
 rand uvm_reg_data_t data,data_interrupt;
  uvm_status_e status;
    bit [31:0]data_offset_1;
  bit [31:0]data_offset_0;
  `uvm_object_utils(tx_ctrl_frame)
  `NEW_OBJ
  task body();
    uvm_reg_addr_t addr;
    string reg_name;
    int errors;
    mac_reg_block mac_reg_block_i;
    //we need register handle model
    assert(uvm_resource_db#(mac_reg_block)::read_by_name("GLOBAL","MAC_RM",mac_reg_block_i,this));
	 //uvm_do_with(req,req.addr==13'h0;reg.data==data_t;req_write==1);
	 
	 
	data='d0;
    data[2]=1'b1;
    mac_reg_block_i.ctrlmoder.write(status, data);

  data='d0;
  data[16]=ethmac_common::delay_timer_value_enable;
  data[15:0]=ethmac_common::delay_timer_value;
	data=17'h11234;
	mac_reg_block_i.txctrl.write(status,data);
	
	 data_interrupt='d0;
    data_interrupt[5]=1'b1;
   // data_interrupt[0]=1'b1;
    mac_reg_block_i.intrmsk.write(status,data_interrupt);
	
	/*
	data_offset_0={16'h40,1'b1,1'b1,1'b0,1'b0,1'b0,2'b0,1'b0, 4'b0,1'b0,1'b0,1'b0,1'b0}; //512 bytes
    data_offset_1=32'h1000_0000; //512 bytes

    `uvm_do_with(req,{req.addr==13'h102;req.data==data_offset_0;req.wr_rd==1;}) //here it shuold be 100, not 400 as spec because in RTL it is mentinoed as lsb 2 bit aligned means we have to discard the lsb 2 bits and give the remaining value so it will be and next is 101
    `uvm_do_with(req,{req.addr==13'h103;req.data==data_offset_1;req.wr_rd==1;})
	 data[16]=0; //RECSMALL
    data[15]=0; //PADEN
    data[14]=0; //HUGEN
    data[13]=1; //CRCEN
    data[12]=0; //CLYCRCEN
    data[11]=0;  //RSVD
    data[10]=1; //FULLDUPLEX
    data[9]=0;  //EXdfren
    data[8]=0; //NOBCKOFF
    data[7]=0; //LOOPBCK
    data[6]=1; //IFG
    data[5]=1; //PROMISCUOS
    data[4]=0; //INDIVIDUAL ADDRESS MODE
    data[3]=0; //BROADCAST ADDRESS
    data[2]=0; //NOPRE
    data[1]=1; //TXEN
    data[0]=0; //RXEN
    //we are performing to the moder register byusing register model
    mac_reg_block_i.moder.write(status,data);
	*/
   endtask
endclass
