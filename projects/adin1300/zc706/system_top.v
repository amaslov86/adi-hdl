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

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [14:0]  gpio_bd,

 //MII interface

  output          mii_mdc_fmc,
  inout           mii_mdio_fmc,

  input           mii_rx_clk,
  input   [3:0]   mii_rxd,
  input           mii_rx_dv,
  input           mii_rx_er,
  input           mii_col,
  input           mii_crs,

  input           mii_tx_clk,
  output  [3:0]   mii_txd,
  output          mii_tx_en,
  output          mii_tx_er,

  input           mii_ext_clk_fmc,
  input           mii_sw_1,
  input           mii_sw_2,
  input           mii_sw_3,
  input           mii_sw_4,
  input           mii_sw_5,
  input           mii_sw_6,
  output          mii_led_a,
  output          mii_led_b,
  inout           mii_io_sda,
  inout           mii_io_scl,

  input           mii_ref_clk_25, // REF_CLK from the ADIN1300
  input           mii_reset_n,

  output          hdmi_out_clk,
  output          hdmi_vsync,
  output          hdmi_hsync,
  output          hdmi_data_e,
  output  [23:0]  hdmi_data,

  output          spdif,

  inout           iic_scl,
  inout           iic_sda);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  wire    [ 3:0]  mii_txd_extra;
  wire            mii_rx_clk_ibuf_s;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_gpio_bd (
    .dio_t(gpio_t[14:0]),
    .dio_i(gpio_o[14:0]),
    .dio_o(gpio_i[14:0]),
    .dio_p(gpio_bd));

    IBUFG i_mii_rx_clk_ibuf (
      .I (mii_rx_clk),
      .O (mii_rx_clk_ibuf_s));

  assign gpio_i[63:15] = gpio_o[63:15];

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .GMII_ETHERNET_1_0_col(mii_col),
    .GMII_ETHERNET_1_0_crs(mii_crs),
    .GMII_ETHERNET_1_0_rx_clk(mii_rx_clk_ibuf_s),
    .GMII_ETHERNET_1_0_rx_dv(mii_rx_dv),
    .GMII_ETHERNET_1_0_rx_er(mii_rx_er),
    .GMII_ETHERNET_1_0_rxd({4'h0,mii_rxd}),
    .GMII_ETHERNET_1_0_tx_clk(mii_tx_clk),
    .GMII_ETHERNET_1_0_tx_en(mii_tx_en),
    .GMII_ETHERNET_1_0_tx_er(mii_tx_er),
    .GMII_ETHERNET_1_0_txd({mii_txd_extra,mii_txd}),
    .MDIO_ETHERNET_1_0_mdc(mii_mdc_fmc),
    .MDIO_ETHERNET_1_0_mdio_io(mii_mdio_fmc),
    .spdif (spdif),
    .spi0_clk_i (1'b0),
    .spi0_clk_o (),
    .spi0_csn_0_o (),
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (1'b0),
    .spi0_sdo_i (1'b0),
    .spi0_sdo_o (),
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o());

endmodule

// ***************************************************************************
// ***************************************************************************
