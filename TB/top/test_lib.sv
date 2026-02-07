class ethmac_base_test extends uvm_test;
  ethmac_env env;
  `uvm_component_utils(ethmac_base_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_reg::include_coverage("*",UVM_CVR_ALL,this);
    env=ethmac_env::type_id::create("env",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    //     uvm_factory factory = uvm_factory::get();
    uvm_top.print_topology();
    //     factory.print();
  endfunction
endclass

class ethmac_reg_read_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_reg_read_test)
  `NEW_COMP

  task run_phase(uvm_phase phase);
    wb_reg_read_seq  read_seq=wb_reg_read_seq::type_id::create("read_seq");
    phase.raise_objection(this);
    read_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,100);
    phase.drop_objection(this);
  endtask
endclass

class ethmac_reg_read_test_reg_model extends ethmac_base_test;
  `uvm_component_utils(ethmac_reg_read_test_reg_model)
  `NEW_COMP
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",0,this);
  endfunction
  task run_phase(uvm_phase phase);
    wb_reg_read_reg_model_seq  read_seq=wb_reg_read_reg_model_seq::type_id::create("reg_model_read_seq");
    phase.raise_objection(this);
    read_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,100);
    phase.drop_objection(this);
  endtask
endclass

class ethmac_reg_write_read_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_reg_write_read_test)
  `NEW_COMP
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",40,this);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",0,this);
    //$display("wb_reg_write_read_test, test_lib");
  endfunction
  task run_phase(uvm_phase phase);
    wb_reg_write_read_seq  write_read_seq=wb_reg_write_read_seq::type_id::create("write_read_seq");
    
    $display("wb_reg_write_read_test, test_lib");
    phase.raise_objection(this);
    write_read_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,1000);
    phase.drop_objection(this);
  endtask
endclass

class ethmac_reg_write_read_reg_model_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_reg_write_read_reg_model_test)
  `NEW_COMP

  task run_phase(uvm_phase phase);
    wb_reg_write_read_reg_model_seq  write_read_seq=wb_reg_write_read_reg_model_seq::type_id::create("write_read_seq");
    phase.raise_objection(this);
    write_read_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,100);
    phase.drop_objection(this);
  endtask
endclass


class ethmac_reg_BD_write_read_reg_model_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_reg_BD_write_read_reg_model_test)
  `NEW_COMP

  task run_phase(uvm_phase phase);
    wb_reg_BD_write_read_reg_model_seq  write_read_seq=wb_reg_BD_write_read_reg_model_seq::type_id::create("write_read_seq");
    phase.raise_objection(this);
    write_read_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,100);
    phase.drop_objection(this);
  endtask
endclass



class ethmac_10mbps_fd_tx_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_10mbps_fd_tx_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",400,this);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    ethmac_common::exp_int_src_reg_val='d1;
  endfunction
  task run_phase(uvm_phase phase);
    ethmac_10mbps_fd_tx_seq  write_tx_fd_10mbps=ethmac_10mbps_fd_tx_seq::type_id::create("write_tx_fd_10mbps");
    int_wait wait_int=int_wait::type_id::create("int_wait");

    phase.raise_objection(this);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
    write_tx_fd_10mbps.start(env.proc_agent_i.sqr);
    wait(ethmac_common::int_o_genrated==1'b1);
    phase.phase_done.set_drain_time(this,2000);
    phase.drop_objection(this);
  endtask
endclass


class ethmac_100mbps_fd_tx_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_100mbps_fd_tx_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",40,this);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    ethmac_common::exp_int_src_reg_val='d1;
  endfunction
  task run_phase(uvm_phase phase);
    ethmac_10mbps_fd_tx_seq  write_tx_fd_10mbps=ethmac_10mbps_fd_tx_seq::type_id::create("write_tx_fd_10mbps");
    int_wait wait_int=int_wait::type_id::create("int_wait");

    phase.raise_objection(this);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
    write_tx_fd_10mbps.start(env.proc_agent_i.sqr);
    wait(ethmac_common::int_o_genrated==1'b1);
    phase.phase_done.set_drain_time(this,2000);
    phase.drop_objection(this);
  endtask
endclass


class ethmac_fd_rx_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_fd_rx_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",40,this);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    ethmac_common::exp_int_src_reg_val='d4;
  endfunction
  task run_phase(uvm_phase phase);
    ethmac_fd_rx_seq fx_seq=ethmac_fd_rx_seq::type_id::create("ethmac_fd_rx_seq");
    phy_rx_gen_frame_seq phy_rx_frame=phy_rx_gen_frame_seq::type_id::create("phy_rx_frame");
    int_wait wait_int=int_wait::type_id::create("int_wait");
    force $root.top.dut.macstatus1.LatchedCrcError=1'b0;
    phase.raise_objection(this);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
    fx_seq.start(env.proc_agent_i.sqr);
    phy_rx_frame.start(env.phy_rx_agent_i.sqr);
    //wait(ethmac_common::int_o_genrated==1'b1);
    phase.phase_done.set_drain_time(this,2000);
    phase.drop_objection(this);
   // release $root.top.dut.macstatus1.LatchedCrcError;
  endtask
endclass

class ethmac_fd_tx_rx_test extends ethmac_base_test;
  `uvm_component_utils(ethmac_fd_tx_rx_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",40,this);
  endfunction
  task run_phase(uvm_phase phase);
    ethmac_fd_tx_rx_seq tx_rx_seq=ethmac_fd_tx_rx_seq::type_id::create("ethmac_fd_tx_rx_seq");
    phy_rx_gen_frame_seq phy_rx_frame=phy_rx_gen_frame_seq::type_id::create("phy_rx_frame");
    int_wait wait_int=int_wait::type_id::create("int_wait");
    //force $root.top.dut.macstatus1.LatchedCrcError=1'b0;
    phase.raise_objection(this);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
    tx_rx_seq.start(env.proc_agent_i.sqr);
    phy_rx_frame.start(env.phy_rx_agent_i.sqr);
        ethmac_common::exp_int_src_reg_val=7'd4;
    wait(ethmac_common::int_o_genrated==1'b1);
    //#10;
     $display("test_lib_fd_tx_rx: %0t",$time);
    wait(ethmac_common::int_o_genrated==1'b0);
     ethmac_common::exp_int_src_reg_val=7'd1;
     wait(ethmac_common::int_o_genrated==1'b1);
    //#40000;
     $display("test_lib_fd_tx_rx: %0t",$time);
    phase.phase_done.set_drain_time(this,20000);
    phase.drop_objection(this);
  endtask
endclass

class mac_mii_write_ctrl_data extends ethmac_base_test;
  `uvm_component_utils(mac_mii_write_ctrl_data)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //10MHZ, 1000/mhz for getting the nanoseconds
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",0,this);
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",40,this);
  endfunction
  task run_phase(uvm_phase phase);
    mac_mii_write_ctrl_data_seq tx_rx_seq=mac_mii_write_ctrl_data_seq::type_id::create("mii_write");
    phase.raise_objection(this);
    tx_rx_seq.start(env.proc_agent_i.sqr);
    phase.phase_done.set_drain_time(this,100);
    phase.drop_objection(this);
  endtask
endclass

class mac_coll_hd_test extends ethmac_base_test;
  `uvm_component_utils(mac_coll_hd_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",400,this);
    ethmac_common::exp_int_src_reg_val='d1;
	
  endfunction

  task run_phase (uvm_phase phase);
    ethmac_10mbps_hd_tx_seq hd_tx_seq=ethmac_10mbps_hd_tx_seq::type_id::create("mac_hd_tx_seq");
    phy_coll_det_seq coll_det_seq=phy_coll_det_seq::type_id::create("phy_coll_det_seq");
    int_wait wait_int=int_wait::type_id::create("int_wait");
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,10000);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
    hd_tx_seq.start(env.proc_agent_i.sqr);	
	#16000;
	force $root.top.dut.macstatus1.CarrierSenseLost = 1'h0;
   // coll_det_seq.start(env.phy_rx_agent_i.sqr);
   // coll_det_seq=new("coll_det_seq");
    coll_det_seq.randomize() with {delay == 45500;};
    coll_det_seq.start(env.phy_rx_agent_i.sqr);
    coll_det_seq.randomize() with {delay == 33500;};
    coll_det_seq.start(env.phy_rx_agent_i.sqr);
	repeat(6) begin
	    coll_det_seq.randomize() with {delay == 33500;};
        coll_det_seq.start(env.phy_rx_agent_i.sqr);
	end
    wait(ethmac_common::int_o_genrated == 1'b1);
    phase.drop_objection(this);


  endtask
endclass


class ctrl_frame_test extends ethmac_base_test;
  `uvm_component_utils(ctrl_frame_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",400,this);
  endfunction

  task run_phase (uvm_phase phase);
    ethmac_10mbps_fd_tx_seq fd_tx_seq = ethmac_10mbps_fd_tx_seq::type_id::create("fd_tx_seq");
    phy_pause_det_seq pause_frame = phy_pause_det_seq::type_id::create("phy_pause_det_seq");  
	ethmac_fd_pause_rx_seq pause_seq=ethmac_fd_pause_rx_seq::type_id::create("ethmac_fd_pause_rx_seq");
        int_wait wait_int=int_wait::type_id::create("int_wait");
    force $root.top.dut.macstatus1.LatchedCrcError=1'b0;
		
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,10000);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
	pause_seq.start(env.proc_agent_i.sqr);
    pause_frame.randomize() with {delay==10;};
	
    pause_frame.start(env.phy_rx_agent_i.sqr);
    ethmac_common::exp_int_src_reg_val='b0100_0000;
    wait(ethmac_common::int_o_genrated == 1'b1);
	#70;
    ethmac_common::exp_int_src_reg_val='d1;
    wait(ethmac_common::int_o_genrated == 1'b1);
	ethmac_common::pause_frame_flag=1'b1;
	//fd_tx_seq.start(env.proc_agent_i.sqr);
	//#1000000;
	#100;
    wait(ethmac_common::int_o_genrated == 1'b1);
	ethmac_common::pause_frame_flag=1'b1;
    phase.drop_objection(this);
  endtask
endclass

class tx_ctrl_frame_test extends ethmac_base_test;
  `uvm_component_utils(tx_ctrl_frame_test)
  `NEW_COMP

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ethmac_common::delay_timer_value_enable=1'b1;
    ethmac_common::delay_timer_value='h1234; //16bit
    uvm_resource_db#(bit)::set("GLOBAL","PHY_CLK_TP_EN",1,this);
    uvm_resource_db#(real)::set("GLOBAL","PHY_CLK_TP",400,this);
  endfunction

  task run_phase (uvm_phase phase);
    //ethmac_10mbps_fd_tx_seq fd_tx_seq = ethmac_10mbps_fd_tx_seq::type_id::create("fd_tx_seq");
	tx_ctrl_frame ctrl_frame=tx_ctrl_frame::type_id::create("tx_ctrl_frame");
    int_wait wait_int=int_wait::type_id::create("int_wait");
    force $root.top.dut.macstatus1.LatchedCrcError=1'b0;
		
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,10000);
    fork
      wait_int.start(env.proc_agent_i.sqr);
    join_none
	//fd_tx_seq.start(env.proc_agent_i.sqr);
	ctrl_frame.start(env.proc_agent_i.sqr);
  //  ethmac_common::exp_int_src_reg_val='b0000_001;
  //  wait(ethmac_common::int_o_genrated == 1'b1);
	//#100;
    ethmac_common::exp_int_src_reg_val='b0100_000;
    wait(ethmac_common::int_o_genrated == 1'b1);
    phase.drop_objection(this);
  endtask
endclass


