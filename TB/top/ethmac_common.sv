`define NEW_COMP \
function new(string name="",uvm_component parent); \
  super.new(name,parent); \
endfunction

`define NEW_OBJ \
function new(string name=""); \
  super.new(name); \
endfunction

typedef bit[3:0] nibble_t;
class ethmac_common;
  static bit int_o_genrated;
  static bit int_o_genrated_sbd=0;
  static bit coll_flag;
  static bit pause_frame_flag=1;
  static bit memory_delay_sbd_flag=1;
  static bit[6:0]exp_int_src_reg_val_rx=7'd1;
  static bit[6:0]exp_int_src_reg_val_tx=7'd1;
  static bit[6:0]exp_int_src_reg_val=7'd1;
  static bit [31:0]regmaskA[20:0];
  static bit [15:0]delay_timer_value='h1234;
  static bit delay_timer_value_enable=1'b0;
  static bit [47:0]frame_da='h180c2000001;
  static bit [47:0]frame_sa='h0;
  static bit [15:0]frame_len='h8808;
  static bit [15:0]frame_opcode='h0001;
  function new();
    regmaskA[0]={15'h0,17'h1FFFF};
    regmaskA[1]={25'h0,7'h0}; //as in the p=spec they mentioning it clears the data when the input is one so we dont want to clear it
    regmaskA[2]={25'h0,7'h7F};
    regmaskA[3]={25'h0,7'h7F};
    regmaskA[4]={25'h0,7'h7F};
    regmaskA[5]={15'h0,17'h1FFFF};
    regmaskA[6]={17'h1FFFF,15'h7FFF};
    regmaskA[7]={12'h0,4'hF,10'h0,6'h3F};
    regmaskA[8]={24'h0,8'hFF};
    regmaskA[9]={28'h0,3'h7};
    regmaskA[10]={23'h0,9'h1FF};
    regmaskA[11]={28'h0,3'h4}; //lower 2 bits are zero they are stauts bits
    regmaskA[12]={19'h0,5'h1F,3'h0,5'h1F};
    regmaskA[13]={16'h0,16'hFFFF};
    regmaskA[14]={16'h0,16'hFFFF};
    regmaskA[15]={28'h0,3'h7};
    regmaskA[16]={15'h7FFF,17'h1FFFF};
    regmaskA[17]={16'h0,16'hFFFF};
    regmaskA[18]={15'h7FFF,17'h1FFFF};
    regmaskA[19]={15'h7FFF,17'h1FFFF};
    regmaskA[20]={15'h0,17'h1FFFF};
  endfunction
endclass