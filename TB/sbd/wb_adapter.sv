// need to be dumped in sbd folder
class wb_adapter extends uvm_reg_adapter;
  `uvm_object_utils(wb_adapter)
  function new(string name="wb_adapter");
    super.new(name);
  endfunction

  virtual  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    wb_tx wb;
    wb=wb_tx::type_id::create("wb_tx");
    wb.wr_rd=(rw.kind==UVM_READ)?0:1;
    wb.addr=rw.addr;
    wb.data=rw.data;
    return wb;
  endfunction

  virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    wb_tx wb;
    if(!$cast(wb,bus_item)) begin
      `uvm_fatal("NOT_WB_TYPE","Provided bus item is notthe correct type")
      return;
    end
    rw.kind=wb.wr_rd?UVM_WRITE:UVM_READ;
    rw.addr=wb.addr;
    rw.data=wb.data;
    rw.status=UVM_IS_OK;
  endfunction

endclass