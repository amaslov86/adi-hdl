// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  input   [12:0]  gpio_bd_i,
  output  [ 7:0]  gpio_bd_o,

  // RGMII interface
  output          mdc_fmc,
  inout           mdio_fmc,
  input   [3:0]   rgmii_rxd,
  input           rgmii_rx_ctl,
  input           rgmii_rxc,
  output  [3:0]   rgmii_txd,
  output          rgmii_tx_ctl,
  output          rgmii_txc,

  input           gp_clk,
  input           ext_clk_fmc,

  input           link_st,
  input           int_n,
  input           sw_1,
  input           sw_2,
  input           sw_3,
  input           sw_4,
  input           sw_5,
  input           sw_6,
  input           led_0,
  output          led_a,
  output          led_b,
  inout           io_sda,
  inout           io_scl,

  input           ref_clk_25, // REF_CLK from the ADIN1300
  input           reset_n


);

  // internal signals

  wire    [94:0]  gpio_i;
  wire    [94:0]  gpio_o;
  wire    [94:0]  gpio_t;


  assign gpio_i[94:42] = gpio_o[94:42];
  assign gpio_i[40] = led_0;
  assign gpio_i[39] = link_st;
  assign gpio_i[38] = sw_6;
  assign gpio_i[37] = sw_5;
  assign gpio_i[36] = sw_4;
  assign gpio_i[35] = sw_3;
  assign gpio_i[34] = sw_2;
  assign gpio_i[33] = sw_1;
  assign gpio_i[32] = int_n;

  assign gpio_i[31:21] = gpio_o[31:21];
  assign gpio_i[ 7:0] = gpio_o[7:0];

  assign gpio_bd_o = gpio_o[ 7:0];
  assign gpio_i[20:8] = gpio_bd_i;

  // instantiations

  system_wrapper i_system_wrapper (
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .spi0_csn (),
    .spi0_miso (1'b0),
    .spi0_mosi (),
    .spi0_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .spi1_sclk (),

    .clock_speed_0({led_a,led_b}),
    .MDIO_PHY_0_mdc (mdc_fmc),
    .MDIO_PHY_0_mdio_io (mdio_fmc),
    .RGMII_0_rd (rgmii_rxd),
    .RGMII_0_rx_ctl (rgmii_rx_ctl),
    .RGMII_0_rxc (rgmii_rxc),
    .RGMII_0_td (rgmii_txd),
    .RGMII_0_tx_ctl (rgmii_tx_ctl),
    .RGMII_0_txc (rgmii_txc),
    .ref_clk_25 (ref_clk_25),
    .reset_n ()
  );

endmodule

// ***************************************************************************
// ***************************************************************************
