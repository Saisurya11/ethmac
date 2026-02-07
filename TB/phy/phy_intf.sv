interface phy_intf();
// Tx
  bit mtx_clk_pad_i; // Transmit clock (from BFM -> PHY)
bit [3:0]  mtxd_pad_o;    // Transmit nibble (to PHY)
bit mtxen_pad_o;   // Transmit enable (to PHY)
bit mtxerr_pad_o;  // Transmit error (to PHY)

// Rx
bit mrx_clk_pad_i; // Receive clock (from PHY -> BFM) as they are coming from BFM we have to take it not to give
bit [3:0]  mrxd_pad_i;    // Receive nibble (from PHY)
bit mrxdv_pad_i;   // Receive data valid (from PHY)
bit mrxerr_pad_i;  // Receive data error (from PHY)

// Common Tx and Rx
bit mcoll_pad_i;   // Collision (from PHY)
bit mcrs_pad_i;    // Carrier sense (from PHY)
endinterface