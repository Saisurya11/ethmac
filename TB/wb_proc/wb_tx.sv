class wb_tx extends uvm_sequence_item;
  rand bit [9:0]addr;
  static bit [31:0] addr_q[$];
  rand bit [31:0]data;
  rand bit wr_rd;
  rand bit [3:0]sel;
  `uvm_object_utils_begin(wb_tx)
  `uvm_field_int(addr,UVM_ALL_ON)
  `uvm_field_int(data,UVM_ALL_ON)
  `uvm_field_int(wr_rd,UVM_ALL_ON)
  `uvm_field_int(sel,UVM_ALL_ON)
  `uvm_object_utils_end
  `NEW_OBJ
  constraint soft_c{
    soft sel==4'b1111;
    soft addr[1:0]==2'b00; //addr is always multiple of 4
//     !(addr[11:2] inside {addr_q});
  }

  function void post_randomize();
    addr_q.push_back(addr);
    if(addr_q.size()==21)
      addr_q.delete();
  endfunction
endclass
