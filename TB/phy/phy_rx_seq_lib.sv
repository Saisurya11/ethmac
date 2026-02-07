class phy_rx_base_seq extends uvm_sequence#(eth_frame);
  `uvm_object_utils(phy_rx_base_seq);
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

class phy_rx_gen_frame_seq extends phy_rx_base_seq;
  `uvm_object_utils(phy_rx_gen_frame_seq)
  `NEW_OBJ
  
  task body();
    `uvm_do_with(req,{req.len==96;})
  endtask
endclass

class phy_coll_det_seq extends phy_rx_base_seq;
  `uvm_object_utils(phy_coll_det_seq)
  `NEW_OBJ
  rand int delay;
  task body();
    `uvm_do_with(req,{req.frame_type == COLL_DET; req.coll_det_delay == delay;})
  endtask
endclass

class phy_pause_det_seq extends phy_rx_base_seq;
  `uvm_object_utils(phy_pause_det_seq)
  `NEW_OBJ
  rand int delay;
  task body();
    `uvm_do_with(req,{req.frame_type == CTRL_FRAME; req.pause_timer < delay;})
  endtask
endclass
