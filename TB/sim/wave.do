onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_clk_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_rst_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_dat_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_dat_o
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_err_o
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_adr_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_sel_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_we_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_cyc_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_stb_i
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/wb_ack_o
add wave -noupdate -expand -group PROC -radix hexadecimal /top/proc_pif/int_o
add wave -noupdate -group MEM /top/mem_pif/wb_clk_i
add wave -noupdate -group MEM /top/mem_pif/wb_rst_i
add wave -noupdate -group MEM /top/mem_pif/m_wb_adr_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_sel_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_we_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_dat_i
add wave -noupdate -group MEM /top/mem_pif/m_wb_dat_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_cyc_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_stb_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_ack_i
add wave -noupdate -group MEM /top/mem_pif/m_wb_err_i
add wave -noupdate -group MEM /top/mem_pif/m_wb_cti_o
add wave -noupdate -group MEM /top/mem_pif/m_wb_bte_o
add wave -noupdate -expand -group phy /top/phy_pif/mtx_clk_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mtxd_pad_o
add wave -noupdate -expand -group phy /top/phy_pif/mtxen_pad_o
add wave -noupdate -expand -group phy /top/phy_pif/mtxerr_pad_o
add wave -noupdate -expand -group phy /top/phy_pif/mrx_clk_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mrxd_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mrxdv_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mrxerr_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mcoll_pad_i
add wave -noupdate -expand -group phy /top/phy_pif/mcrs_pad_i
add wave -noupdate -group MII /top/mii_pif/md_pad_i
add wave -noupdate -group MII /top/mii_pif/mdc_pad_o
add wave -noupdate -group MII /top/mii_pif/md_pad_o
add wave -noupdate -group MII /top/mii_pif/md_padoe_o
add wave -noupdate -group error_1 /top/dut/miim1/outctrl/BitCounter
add wave -noupdate -group error_1 /top/dut/miim1/outctrl/InProgress
add wave -noupdate -group error_1 /top/dut/miim1/outctrl/SerialEn
add wave -noupdate -group error_1 /top/dut/miim1/InProgress
add wave -noupdate -group error_1 /top/dut/miim1/NoPre
add wave -noupdate -group error_1 /top/dut/miim1/WriteOp
add wave -noupdate -group error_1 /top/dut/miim1/BitCounter
add wave -noupdate -group error_1 /top/dut/miim1/StartOp
add wave -noupdate -group error_1 /top/dut/miim1/MdcEn
add wave -noupdate -group error_1 /top/dut/ethreg1/Address
add wave -noupdate -group error_1 /top/dut/ethreg1/MIICOMMAND_Sel
add wave -noupdate -group error_1 /top/dut/ethreg1/MIICOMMANDOut
add wave -noupdate -group error_1 /top/dut/ethreg1/MIICOMMAND0/Write
add wave -noupdate -group error_1 /top/dut/ethreg1/Cs
add wave -noupdate -group error_1 /top/dut/ethreg1/Rw
add wave -noupdate -group error_1 /top/dut/miim1/clkgen/Mdc
add wave -noupdate -group error_1 /top/dut/miim1/shftrg/ByteSelect
add wave -noupdate -group error_1 /top/dut/ethreg1/r_FIAD
add wave -noupdate -group error_1 /top/dut/ethreg1/MIICOMMAND_Sel
add wave -noupdate -group error_1 /top/dut/ethreg1/Write
add wave -noupdate -group mii_frame_error /top/dut/wishbone/TxStartFrm_sync2
add wave -noupdate -group mii_frame_error /top/dut/wishbone/TxStartFrm
add wave -noupdate -group mii_frame_error /top/dut/miim1/outctrl/BitCounter
add wave -noupdate -group mii_frame_error /top/dut/miim1/InProgress
add wave -noupdate -group mii_frame_error /top/dut/miim1/MdcEn
add wave -noupdate -group mii_frame_error /top/dut/miim1/StartOp
add wave -noupdate -group mii_frame_error /top/dut/miim1/WriteDataOp
add wave -noupdate -group mii_frame_error /top/dut/miim1/ReadStatusOp
add wave -noupdate -group mii_frame_error /top/dut/miim1/ScanStatusOp
add wave -noupdate -group mii_frame_error /top/dut/miim1/WCtrlDataStart_q1
add wave -noupdate -group mii_frame_error /top/dut/miim1/RStatStart_q1
add wave -noupdate -group mii_frame_error /top/dut/miim1/SyncStatMdcEn
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/LatchedByte
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/ByteCntEq1
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/StateData
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/RxEndFrm
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/Multicast
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/Broadcast
add wave -noupdate -group rx_inflow /top/dut/rxethmac1/RxData_d
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxDataLatched1
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxValidBytes
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxData
add wave -noupdate -group rx_inflow /top/dut/wishbone/SetWriteRxDataToFifo
add wave -noupdate -group rx_inflow /top/dut/wishbone/ShiftWillEnd
add wave -noupdate -group rx_inflow /top/dut/wishbone/Reset
add wave -noupdate -group rx_inflow /top/dut/wishbone/MRxClk
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxDataLatched2
add wave -noupdate -group rx_inflow /top/dut/wishbone/rx_fifo/fifo
add wave -noupdate -group rx_inflow /top/dut/wishbone/rx_fifo/write
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxBufferFull
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifo_wb
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifo_wb
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifoSync3
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifoSync2
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifo
add wave -noupdate -group rx_inflow /top/dut/wishbone/WriteRxDataToFifoSync1
add wave -noupdate -group rx_inflow /top/dut/wishbone/SetWriteRxDataToFifo
add wave -noupdate -group rx_inflow /top/dut/wishbone/RxAbort
add wave -noupdate -group {small rx frame issue} /top/dut/ethreg1/RxB_IRQ
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ReceivedPacketGood
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxStatusWrite
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxIRQEn
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxEn_q
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxEn
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ShiftEnded
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ShiftEndedSync3
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/MasterWbRX
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/m_wb_ack_i
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxBufferAlmostEmpty
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ShiftEndedSync1
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ShiftEndedSync2
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/ShiftEnded_rck
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/SetWriteRxDataToFifo
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/StartShiftWillEnd
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxAbort
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxValid
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxEndFrm
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxByteCnt
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/RxEnableWindow
add wave -noupdate -group {small rx frame issue} /top/dut/wishbone/LastByteIn
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/DribbleRxEndFrm
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/GenerateRxEndFrm
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/ByteCntGreat2
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/StateData
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/MRxDV
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/ByteCntMaxFrame
add wave -noupdate -group {small rx frame issue} -expand /top/dut/rxethmac1/StateData
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/rxcounters1/MaxFL
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/rxcounters1/HugEn
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/rxcounters1/ByteCnt
add wave -noupdate -group {small rx frame issue} /top/dut/rxethmac1/rxcounters1/MaxFL
add wave -noupdate -group {small rx frame issue} /top/dut/ethreg1/DataIn
add wave -noupdate -group int_rx_error /top/dut/wishbone/RxError
add wave -noupdate -group int_rx_error /top/dut/wishbone/ReceivedPauseFrm
add wave -noupdate -group int_rx_error /top/dut/wishbone/AddressMiss
add wave -noupdate -group int_rx_error /top/dut/wishbone/RxOverrun
add wave -noupdate -group int_rx_error /top/dut/wishbone/InvalidSymbol
add wave -noupdate -group int_rx_error /top/dut/wishbone/DribbleNibble
add wave -noupdate -group int_rx_error /top/dut/wishbone/ReceivedPacketTooBig
add wave -noupdate -group int_rx_error /top/dut/wishbone/ShortFrame
add wave -noupdate -group int_rx_error /top/dut/wishbone/LatchedCrcError
add wave -noupdate -group int_rx_error /top/dut/wishbone/RxLateCollision
add wave -noupdate -group int_rx_error /top/dut/wishbone/RxStatusIn
add wave -noupdate -group int_rx_error /top/dut/rxethmac1/crcrx/Crc
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/RxData
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/MRxDV
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/StateSFD
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/MRxDEqD
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/IFGCounterEq24
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/StateData1
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxstatem1/ByteCntMaxFrame
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/IFGCounter
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/IncrementIFGCounter
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/ResetIFGCounter
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/IFGCounterEq24
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/StateDrop
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/StateIdle
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/StatePreamble
add wave -noupdate -group rx_inflow_2 /top/dut/rxethmac1/rxcounters1/StateSFD
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_txb
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_txe
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_rxb
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_rxe
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_busy
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_txc
add wave -noupdate -group coll_error /top/dut/ethreg1/irq_rxc
add wave -noupdate -group coll_error /top/dut/ethreg1/INT_MASKOut
add wave -noupdate -group coll_error /top/dut/ethreg1/int_o
add wave -noupdate -group coll_error /top/dut/txethmac1/NibCntEq15
add wave -noupdate -group coll_error /top/dut/txethmac1/StatePreamble
add wave -noupdate -group coll_error /top/dut/wishbone/CarrierSenseLost
add wave -noupdate -group coll_error /top/dut/wishbone/LateCollLatched
add wave -noupdate -group coll_error /top/dut/wishbone/RetryLimit
add wave -noupdate -group coll_error /top/dut/wishbone/TxUnderRun
add wave -noupdate -group coll_error /top/dut/macstatus1/TxStartFrm
add wave -noupdate -group coll_error /top/dut/macstatus1/CarrierSense
add wave -noupdate -group coll_error /top/dut/macstatus1/Loopback
add wave -noupdate -group coll_error /top/dut/macstatus1/Collision
add wave -noupdate -group coll_error /top/dut/macstatus1/r_FullD
add wave -noupdate -group coll_error /top/dut/macstatus1/StatePreamble
add wave -noupdate -group coll_error /top/dut/macstatus1/StateData
add wave -noupdate -group coll_error /top/dut/macstatus1/CarrierSenseLost
add wave -noupdate -group coll_error /top/dut/maccontrol1/CtrlMux
add wave -noupdate -group coll_error /top/dut/maccontrol1/TxCtrlStartFrm
add wave -noupdate -group coll_error /top/dut/maccontrol1/TxStartFrmIn
add wave -noupdate -group coll_error /top/dut/maccontrol1/Pause
add wave -noupdate -group coll_error /top/dut/wishbone/TxStartFrm_wb
add wave -noupdate /top/dut/ethreg1/SetPauseTimer
add wave -noupdate /top/dut/ethreg1/r_RxFlow
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/LatchedTimerValue
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ReceiveEnd
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ReceivedPauseFrmWAddr
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ReceivedPacketGood
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ReceivedLengthOK
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ByteCntEq18
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/DetectionWindow
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/AssembledTimerValue
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/RxData
add wave -noupdate /top/dut/rxethmac1/RxData_d
add wave -noupdate /top/dut/rxethmac1/LatchedByte
add wave -noupdate /top/dut/rxethmac1/GenerateRxValid
add wave -noupdate /top/dut/rxethmac1/StateData
add wave -noupdate /top/dut/rxethmac1/rxstatem1/MRxDEqD
add wave -noupdate /top/dut/rxethmac1/rxstatem1/IFGCounterEq24
add wave -noupdate /top/dut/rxethmac1/rxstatem1/StateSFD
add wave -noupdate /top/dut/rxethmac1/rxstatem1/MRxDV
add wave -noupdate /top/dut/RxEnSync
add wave -noupdate /top/dut/rxethmac1/ByteCntEq0
add wave -noupdate /top/dut/rxethmac1/DlyCrcCnt
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/TypeLengthOK
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/OpCodeOK
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ByteCntEq12
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ByteCntEq13
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ByteCntEq16
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/ByteCntEq17
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/RxData
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/AddressOK
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/LatchedTimerValue
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/PauseTimerEq0
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/PauseTimer
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/DecrementPauseTimer
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/SlotFinished
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/IncrementSlotTimer
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/SlotTimer
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/Pause
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/Divider2
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/PauseTimerEq0_sync2
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/IncrementSlotTimer
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/TxStartFrmOut
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/TxDoneIn
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/TxAbortIn
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/TxUsedDataOutDetected
add wave -noupdate /top/dut/maccontrol1/receivecontrol1/RxFlow
add wave -noupdate /top/dut/txethmac1/UnderRun
add wave -noupdate /top/dut/txethmac1/LateCollision
add wave -noupdate /top/dut/txethmac1/Collision
add wave -noupdate /top/dut/txethmac1/StateFCS
add wave -noupdate /top/dut/txethmac1/NibCntEq7
add wave -noupdate /top/dut/txethmac1/CrcEn
add wave -noupdate /top/dut/txethmac1/StateData
add wave -noupdate /top/dut/txethmac1/TxEndFrm
add wave -noupdate /top/dut/txethmac1/Pad
add wave -noupdate /top/dut/txethmac1/NibbleMinFl
add wave -noupdate /top/dut/txethmac1/StartTxDone
add wave -noupdate /top/dut/ethreg1/r_TxBDNum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {1417400 ns} 0} {{Cursor 3} {59438 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 335
configure wave -valuecolwidth 72
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {105 ns}
