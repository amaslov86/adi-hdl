// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  sys_rst,
  sys_clk_p,
  sys_clk_n,

  uart_sin,
  uart_sout,

  ddr3_addr,
  ddr3_ba,
  ddr3_cas_n,
  ddr3_ck_n,
  ddr3_ck_p,
  ddr3_cke,
  ddr3_cs_n,
  ddr3_dm,
  ddr3_dq,
  ddr3_dqs_n,
  ddr3_dqs_p,
  ddr3_odt,
  ddr3_ras_n,
  ddr3_reset_n,
  ddr3_we_n,

  sgmii_rxp,
  sgmii_rxn,
  sgmii_txp,
  sgmii_txn,

  phy_rstn,
  mgt_clk_p,
  mgt_clk_n,
  mdio_mdc,
  mdio_mdio,

  fan_pwm,

  linear_flash_addr,
  linear_flash_adv_ldn,
  linear_flash_ce_n,
  linear_flash_oen,
  linear_flash_wen,
  linear_flash_dq_io,

  gpio_lcd,
  gpio_led,
  gpio_sw,

  iic_rstn,
  iic_scl,
  iic_sda,

  hdmi_out_clk,
  hdmi_hsync,
  hdmi_vsync,
  hdmi_data_e,
  hdmi_data,

  spdif,

  rx_ref_clk_p,
  rx_ref_clk_n,
  rx_sysref_p,
  rx_sysref_n,
  rx_sync_p,
  rx_sync_n,
  rx_data_p,
  rx_data_n,

  tx_ref_clk_p,
  tx_ref_clk_n,
  tx_sysref_p,
  tx_sysref_n,
  tx_sync_p,
  tx_sync_n,
  tx_data_p,
  tx_data_n,

  trig_p,
  trig_n,

  adc_fdb,
  adc_fda,
  dac_irq,
  clkd_status,

  adc_pd,
  dac_txen,
  dac_reset,
  clkd_sync,

  spi_csn_clk,
  spi_csn_dac,
  spi_csn_adc,
  spi_clk,
  spi_sdio,
  spi_dir);

  input             sys_rst;
  input             sys_clk_p;
  input             sys_clk_n;

  input             uart_sin;
  output            uart_sout;

  output  [13:0]    ddr3_addr;
  output  [ 2:0]    ddr3_ba;
  output            ddr3_cas_n;
  output  [ 0:0]    ddr3_ck_n;
  output  [ 0:0]    ddr3_ck_p;
  output  [ 0:0]    ddr3_cke;
  output  [ 0:0]    ddr3_cs_n;
  output  [ 7:0]    ddr3_dm;
  inout   [63:0]    ddr3_dq;
  inout   [ 7:0]    ddr3_dqs_n;
  inout   [ 7:0]    ddr3_dqs_p;
  output  [ 0:0]    ddr3_odt;
  output            ddr3_ras_n;
  output            ddr3_reset_n;
  output            ddr3_we_n;

  input             sgmii_rxp;
  input             sgmii_rxn;
  output            sgmii_txp;
  output            sgmii_txn;

  output            phy_rstn;
  input             mgt_clk_p;
  input             mgt_clk_n;
  output            mdio_mdc;
  inout             mdio_mdio;

  output            fan_pwm;

  output  [26:1]    linear_flash_addr;
  output            linear_flash_adv_ldn;
  output            linear_flash_ce_n;
  output            linear_flash_oen;
  output            linear_flash_wen;
  inout   [15:0]    linear_flash_dq_io;

  output  [ 6:0]    gpio_lcd;
  output  [ 7:0]    gpio_led;
  input   [12:0]    gpio_sw;

  output            iic_rstn;
  inout             iic_scl;
  inout             iic_sda;

  output            hdmi_out_clk;
  output            hdmi_hsync;
  output            hdmi_vsync;
  output            hdmi_data_e;
  output  [35:0]    hdmi_data;

  output            spdif;

  input             rx_ref_clk_p;
  input             rx_ref_clk_n;
  input             rx_sysref_p;
  input             rx_sysref_n;
  output            rx_sync_p;
  output            rx_sync_n;
  input   [ 3:0]    rx_data_p;
  input   [ 3:0]    rx_data_n;

  input             tx_ref_clk_p;
  input             tx_ref_clk_n;
  input             tx_sysref_p;
  input             tx_sysref_n;
  input             tx_sync_p;
  input             tx_sync_n;
  output  [ 3:0]    tx_data_p;
  output  [ 3:0]    tx_data_n;

  input             trig_p;
  input             trig_n;

  inout             adc_fdb;
  inout             adc_fda;
  inout             dac_irq;
  inout   [ 1:0]    clkd_status;

  inout             adc_pd;
  inout             dac_txen;
  inout             dac_reset;
  inout             clkd_sync;

  output            spi_csn_clk;
  output            spi_csn_dac;
  output            spi_csn_adc;
  output            spi_clk;
  inout             spi_sdio;
  output            spi_dir;

  // internal registers

  reg               dac_drd = 'd0;
  reg     [63:0]    dac_ddata_0 = 'd0;
  reg     [63:0]    dac_ddata_1 = 'd0;
  reg     [63:0]    dac_ddata_2 = 'd0;
  reg     [63:0]    dac_ddata_3 = 'd0;
  reg               adc_dsync = 'd0;
  reg               adc_dwr = 'd0;
  reg    [127:0]    adc_ddata = 'd0;

  // internal signals

  wire              trig;
  wire              rx_ref_clk;
  wire              rx_sysref;
  wire              rx_sync;
  wire              tx_ref_clk;
  wire              tx_sysref;
  wire              tx_sync;
  wire    [ 2:0]    spi_csn;
  wire              spi_mosi;
  wire              spi_miso;
  wire              dac_clk;
  wire   [127:0]    dac_ddata;
  wire              dac_enable_0;
  wire              dac_enable_1;
  wire              dac_enable_2;
  wire              dac_enable_3;
  wire              dac_valid_0;
  wire              dac_valid_1;
  wire              dac_valid_2;
  wire              dac_valid_3;
  wire              adc_clk;
  wire    [63:0]    adc_data_0;
  wire    [63:0]    adc_data_1;
  wire              adc_enable_0;
  wire              adc_enable_1;
  wire              adc_valid_0;
  wire              adc_valid_1;
  wire    [ 5:0]    gpio_ctl_i;
  wire    [ 5:0]    gpio_ctl_o;
  wire    [ 5:0]    gpio_ctl_t;
  wire    [ 4:0]    gpio_status_i;
  wire    [ 4:0]    gpio_status_o;
  wire    [ 4:0]    gpio_status_t;
  wire    [31:0]    mb_intrs;

  // adc-dac data

  always @(posedge dac_clk) begin
    case ({dac_enable_1, dac_enable_0})
      2'b11: begin
        dac_drd <= dac_valid_0 & dac_valid_1;
        dac_ddata_0[63:48] <= dac_ddata[111: 96];
        dac_ddata_0[47:32] <= dac_ddata[ 79: 64];
        dac_ddata_0[31:16] <= dac_ddata[ 47: 32];
        dac_ddata_0[15: 0] <= dac_ddata[ 15:  0];
        dac_ddata_1[63:48] <= dac_ddata[127:112];
        dac_ddata_1[47:32] <= dac_ddata[ 95: 80];
        dac_ddata_1[31:16] <= dac_ddata[ 63: 48];
        dac_ddata_1[15: 0] <= dac_ddata[ 31: 16];
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
      end
      2'b10: begin
        dac_drd <= dac_valid_1 & ~dac_drd;
        dac_ddata_0 <= 64'd0;
        if (dac_drd == 1'b1) begin
          dac_ddata_1[63:48] <= dac_ddata[127:112];
          dac_ddata_1[47:32] <= dac_ddata[111: 96];
          dac_ddata_1[31:16] <= dac_ddata[ 95: 80];
          dac_ddata_1[15: 0] <= dac_ddata[ 79: 64];
        end else begin
          dac_ddata_1[63:48] <= dac_ddata[ 63: 48];
          dac_ddata_1[47:32] <= dac_ddata[ 47: 32];
          dac_ddata_1[31:16] <= dac_ddata[ 31: 16];
          dac_ddata_1[15: 0] <= dac_ddata[ 15:  0];
        end
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
      end
      2'b01: begin
        dac_drd <= dac_valid_0 & ~dac_drd;
        if (dac_drd == 1'b1) begin
          dac_ddata_0[63:48] <= dac_ddata[127:112];
          dac_ddata_0[47:32] <= dac_ddata[111: 96];
          dac_ddata_0[31:16] <= dac_ddata[ 95: 80];
          dac_ddata_0[15: 0] <= dac_ddata[ 79: 64];
        end else begin
          dac_ddata_0[63:48] <= dac_ddata[ 63: 48];
          dac_ddata_0[47:32] <= dac_ddata[ 47: 32];
          dac_ddata_0[31:16] <= dac_ddata[ 31: 16];
          dac_ddata_0[15: 0] <= dac_ddata[ 15:  0];
        end
        dac_ddata_1 <= 64'd0;
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
      end
      default: begin
        dac_drd <= 1'b0;
        dac_ddata_0 <= 64'd0;
        dac_ddata_1 <= 64'd0;
        dac_ddata_2 <= 64'd0;
        dac_ddata_3 <= 64'd0;
      end
    endcase
  end

  always @(posedge adc_clk) begin
    case ({adc_enable_1, adc_enable_0})
      2'b11: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_1 & adc_valid_0;
        adc_ddata[127:112] <= adc_data_1[63:48];
        adc_ddata[111: 96] <= adc_data_0[63:48];
        adc_ddata[ 95: 80] <= adc_data_1[47:32];
        adc_ddata[ 79: 64] <= adc_data_0[47:32];
        adc_ddata[ 63: 48] <= adc_data_1[31:16];
        adc_ddata[ 47: 32] <= adc_data_0[31:16];
        adc_ddata[ 31: 16] <= adc_data_1[15: 0];
        adc_ddata[ 15:  0] <= adc_data_0[15: 0];
      end
      2'b10: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_1 & ~adc_dwr;
        adc_ddata[127:112] <= adc_data_1[63:48];
        adc_ddata[111: 96] <= adc_data_1[47:32];
        adc_ddata[ 95: 80] <= adc_data_1[31:16];
        adc_ddata[ 79: 64] <= adc_data_1[15: 0];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      2'b01: begin
        adc_dsync <= 1'b1;
        adc_dwr <= adc_valid_0 & ~adc_dwr;
        adc_ddata[127:112] <= adc_data_0[63:48];
        adc_ddata[111: 96] <= adc_data_0[47:32];
        adc_ddata[ 95: 80] <= adc_data_0[31:16];
        adc_ddata[ 79: 64] <= adc_data_0[15: 0];
        adc_ddata[ 63: 48] <= adc_ddata[127:112];
        adc_ddata[ 47: 32] <= adc_ddata[111: 96];
        adc_ddata[ 31: 16] <= adc_ddata[ 95: 80];
        adc_ddata[ 15:  0] <= adc_ddata[ 79: 64];
      end
      default: begin
        adc_dsync <= 1'b0;
        adc_dwr <= 1'b0;
        adc_ddata <= 128'd0;
      end
    endcase
  end

  // spi

  assign spi_csn_adc = spi_csn[2];
  assign spi_csn_dac = spi_csn[1];
  assign spi_csn_clk = spi_csn[0];

  // default logic

  assign fan_pwm = 1'b1;

  // instantiations

  IBUFDS_GTE2 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (rx_ref_clk_p),
    .IB (rx_ref_clk_n),
    .O (rx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_rx_sysref (
    .I (rx_sysref_p),
    .IB (rx_sysref_n),
    .O (rx_sysref));

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  IBUFDS_GTE2 i_ibufds_tx_ref_clk (
    .CEB (1'd0),
    .I (tx_ref_clk_p),
    .IB (tx_ref_clk_n),
    .O (tx_ref_clk),
    .ODIV2 ());

  IBUFDS i_ibufds_tx_sysref (
    .I (tx_sysref_p),
    .IB (tx_sysref_n),
    .O (tx_sysref));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  daq2_spi i_spi (
    .spi_csn (spi_csn),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio),
    .spi_dir (spi_dir));

  IBUFDS i_ibufds_trig (
    .I (trig_p),
    .IB (trig_n),
    .O (trig));

  assign gpio_ctl_i[0] = trig;

  ad_iobuf #(.DATA_WIDTH(9)) i_iobuf (
    .dt ({gpio_ctl_t[5:3], gpio_ctl_t[1], gpio_status_t[4:0]}),
    .di ({gpio_ctl_o[5:3], gpio_ctl_o[1], gpio_status_o[4:0]}),
    .do ({gpio_ctl_i[5:3], gpio_ctl_i[1], gpio_status_i[4:0]}),
    .dio ({ adc_pd,          // 10
            dac_txen,        //  9
            dac_reset,       //  8
            clkd_sync,       //  6
            adc_fdb,         //  4
            adc_fda,         //  3
            dac_irq,         //  2
            clkd_status}));  //  0

  // instantiations

  system_wrapper i_system_wrapper (
    .adc_clk (adc_clk),
    .adc_data_0 (adc_data_0),
    .adc_data_1 (adc_data_1),
    .adc_ddata (adc_ddata),
    .adc_dsync (adc_dsync),
    .adc_dwr (adc_dwr),
    .adc_enable_0 (adc_enable_0),
    .adc_enable_1 (adc_enable_1),
    .adc_valid_0 (adc_valid_0),
    .adc_valid_1 (adc_valid_1),
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_odt (ddr3_odt),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_we_n (ddr3_we_n),
    .dac_clk (dac_clk),
    .dac_ddata (dac_ddata),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_ddata_2 (dac_ddata_2),
    .dac_ddata_3 (dac_ddata_3),
    .dac_drd (dac_drd),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_enable_2 (dac_enable_2),
    .dac_enable_3 (dac_enable_3),
    .dac_valid_0 (dac_valid_0),
    .dac_valid_1 (dac_valid_1),
    .dac_valid_2 (dac_valid_2),
    .dac_valid_3 (dac_valid_3),
    .gpio_ctl_i (gpio_ctl_i),
    .gpio_ctl_o (gpio_ctl_o),
    .gpio_ctl_t (gpio_ctl_t),
    .linear_flash_addr (linear_flash_addr),
    .linear_flash_adv_ldn (linear_flash_adv_ldn),
    .linear_flash_ce_n (linear_flash_ce_n),
    .linear_flash_oen (linear_flash_oen),
    .linear_flash_wen (linear_flash_wen),
    .linear_flash_dq_io(linear_flash_dq_io),
    .gpio_lcd_tri_o (gpio_lcd),
    .gpio_led_tri_o (gpio_led),
    .gpio_status_i (gpio_status_i),
    .gpio_status_o (gpio_status_o),
    .gpio_status_t (gpio_status_t),
    .gpio_sw_tri_i (gpio_sw),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),
    .iic_rstn (iic_rstn),
    .mb_intr_10 (mb_intrs[10]),
    .mb_intr_11 (mb_intrs[11]),
    .mb_intr_12 (mb_intrs[12]),
    .mb_intr_13 (mb_intrs[13]),
    .mb_intr_14 (mb_intrs[14]),
    .mb_intr_15 (mb_intrs[15]),
    .mb_intr_16 (mb_intrs[16]),
    .mb_intr_17 (mb_intrs[17]),
    .mb_intr_18 (mb_intrs[18]),
    .mb_intr_19 (mb_intrs[19]),
    .mb_intr_20 (mb_intrs[20]),
    .mb_intr_21 (mb_intrs[21]),
    .mb_intr_22 (mb_intrs[22]),
    .mb_intr_23 (mb_intrs[23]),
    .mb_intr_24 (mb_intrs[24]),
    .mb_intr_25 (mb_intrs[25]),
    .mb_intr_26 (mb_intrs[26]),
    .mb_intr_27 (mb_intrs[27]),
    .mb_intr_28 (mb_intrs[28]),
    .mb_intr_29 (mb_intrs[29]),
    .mb_intr_30 (mb_intrs[30]),
    .mb_intr_31 (mb_intrs[31]),
    .axi_ad9144_dma_intr (mb_intrs[13]),
    .axi_ad9680_dma_intr (mb_intrs[12]),
    .axi_daq2_gpio_intr (mb_intrs[11]),
    .axi_daq2_spi_intr (mb_intrs[10]),
    .rx_data_n (rx_data_n),
    .rx_data_p (rx_data_p),
    .rx_ref_clk (rx_ref_clk),
    .rx_sync (rx_sync),
    .rx_sysref (rx_sysref),
    .tx_data_n (tx_data_n),
    .tx_data_p (tx_data_p),
    .tx_ref_clk (tx_ref_clk),
    .tx_sync (tx_sync),
    .tx_sysref (tx_sysref),
    .spi_clk_i (spi_clk),
    .spi_clk_o (spi_clk),
    .spi_csn_i (spi_csn),
    .spi_csn_o (spi_csn),
    .spi_sdi_i (spi_miso),
    .spi_sdo_i (spi_mosi),
    .spi_sdo_o (spi_mosi),
    .mdio_mdc (mdio_mdc),
    .mdio_mdio_io (mdio_mdio),
    .mgt_clk_clk_n (mgt_clk_n),
    .mgt_clk_clk_p (mgt_clk_p),
    .phy_rstn (phy_rstn),
    .sgmii_rxn (sgmii_rxn),
    .sgmii_rxp (sgmii_rxp),
    .sgmii_txn (sgmii_txn),
    .sgmii_txp (sgmii_txp),
    .spdif (spdif),
    .sys_clk_n (sys_clk_n),
    .sys_clk_p (sys_clk_p),
    .sys_rst (sys_rst),
    .uart_sin (uart_sin),
    .uart_sout (uart_sout));

endmodule

// ***************************************************************************
// ***************************************************************************
