class eth_frame extends uvm_sequence_item;
typedef enum bit[1:0]{
  ETH_FRAME,
  COLL_DET,
  CTRL_FRAME,
  rsvd
}frame;

  rand bit [55:0]preamble;
  rand frame frame_type;
  rand bit [7:0]sfd;
  //currently MAC, Frames will not have DA,SA in this MAC only
  rand bit[7:0]payload[$];
  rand int len;
  rand bit [31:0]crc;
  rand int coll_det_delay;
  //pause frame fields
  rand bit [47:0] da;
  rand bit [47:0] sa;
  rand bit[15:0]opcode;
  rand bit[15:0] pause_timer;
  rand bit[7:0]RSVD[41:0];
  rand int pause_frame_delay;
  rand bit [15:0]type_len;

  `NEW_OBJ
  `uvm_object_utils_begin(eth_frame)
  `uvm_field_int(preamble,UVM_ALL_ON)
  `uvm_field_int(sfd,UVM_ALL_ON)
  `uvm_field_queue_int(payload,UVM_ALL_ON)
  `uvm_field_int(crc,UVM_ALL_ON)
  `uvm_field_int(len,UVM_ALL_ON|UVM_NOPACK)
  `uvm_field_int(opcode,UVM_ALL_ON)
  `uvm_field_int(pause_timer,UVM_ALL_ON)
//  `uvm_field_array_int(RSVD,UVM_ALL_ON)
  `uvm_field_int(type_len,UVM_ALL_ON)
  `uvm_field_int(sa,UVM_ALL_ON)
  `uvm_field_int(da,UVM_ALL_ON)
  `uvm_field_int(pause_frame_delay,UVM_ALL_ON)
  `uvm_object_utils_end

  constraint opcode_c{
    (frame_type == CTRL_FRAME) -> (opcode == 16'h0001);
    (frame_type == CTRL_FRAME) -> (type_len== 16'h8808); //changed from 0008
  }
  constraint a_c{
    soft preamble == 56'h55_5555_5555_5555;
    soft sfd == 8'hd5;
    soft len inside {[46:1500]};
    soft frame_type == ETH_FRAME;
    soft da== 48'h01_80_c2_00_00_01;
    soft sa== 48'h11_22_33_44_55_66;
  }

  constraint payload_c{
    payload.size() == len;
  }

  function void post_randomize();
    bit [32:0]poly=33'b1_0000_0100_1100_0001_1101_1011_0111;
    bit [32:0]remainder;
    bit [32:0]dividend;
    int number_bits_to_shift;
    bit payload_bitvector[$];
    int queue_size,shift_count;

    payload_bitvector={<<bit{payload}};
    queue_size=payload_bitvector.size();
    while(payload_bitvector.size()!=0) begin
      for(int i=32;i>=0;i--) begin
        //       dividend={payload[0],payload[1],payload[2],payload[3],payload[4]};
        dividend[i]=(payload_bitvector.pop_front());
      end
      remainder=dividend[32:1]^poly;
      for(int i=32;i>=0;i--) begin
        if(remainder[i]==0) number_bits_to_shift++;
        else break;
      end
      queue_size=payload_bitvector.size();
      shift_count=number_bits_to_shift>queue_size?number_bits_to_shift:queue_size;
      //shift the bits in to dividend
      dividend=dividend<<shift_count;
      for(int i=shift_count-1;i>=0;i--) begin
        dividend[i]=(payload_bitvector.pop_front());
      end
    end
    crc=remainder;
//     $display("CRC=%0b",crc);
  endfunction
endclass
