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

//
// Un-pack one input beat into two output beats
// Frame size 2 beats:
// Format of input beats:  {MS Beat, LS Beat}
// Temporal ordering of output:
//   odata :  MS Beat0, LS Beat0, MS Beat1, LS Beat1, ...
//   sof   :         1,        0,        1,        0, ...

// Frame size 4 beats:
// Format of input beats:  {MS Beat, LS Beat}
// Temporal ordering of output:
//   odata :  MS Beat0, LS Beat0, MS Beat1, LS Beat1, MS Beat2, LS Beat2,...
//   sof   :         1,        0,        0,        0,        1,        0, ...

// Slow to fast converter of factor 2 with with two operation modes.
//
// Single clock mode:
//  - there is only clock domain (clk_2x)
//  - input data qualifier toggles
//
// Dual clock mode:
//  - clk and clk_2x must be in phase
//  - input qualifier stable
//

//
// clk and clk_2x must be in phase
//
module gearbox_stf #(
  parameter WIDTH = 8,
  parameter SINGLE_CLK_DUAL_CLK_N = 1
)(
  input                  clk,    // Input clock used in dual clock mode
  input                  clk_2x, // Output clock, also input clock in single clock mode
  input                  rst,    // Synchronous reset active high
  input   [WIDTH*2-1:0]  idata,  // Input data beat
  input                  ivalid, // Input data qualifier
  output                 iready,
  input                  isof,   // Input start of frame indicator
  output  [WIDTH-1:0]    odata,  // Output data beat
  output                 ovalid, // Output data qualifier
  input                  oready,
  output                 osof    // Start of frame indicator marking the MS Beat
);

  generate if (SINGLE_CLK_DUAL_CLK_N == 0) begin
    // Dual clock mode:
    reg i_toggle = 1'b0;
    reg o_toggle;
    reg o_toggle_d;
    reg o_data_sel = 1'b1;

    always @(posedge clk) begin
      i_toggle <= ~i_toggle;
    end

    always @(posedge clk_2x) begin
      o_toggle <= i_toggle;
      o_toggle_d <= o_toggle;
    end

    always @(posedge clk_2x) begin
      if (o_toggle & ~o_toggle_d) begin
        o_data_sel <= 1'b1;
      end else begin
        o_data_sel <= ~o_data_sel;
      end
    end

    assign odata = o_data_sel ? idata[WIDTH*2-1:WIDTH] : idata[WIDTH-1:0];
    assign osof = o_data_sel;
  end else begin

    reg [WIDTH*2-1:0] idata_d = {WIDTH*2{1'b0}};
    reg isof_d = 1'b0;
    reg o_data_sel = 1'b0;
    reg has_data = 1'b0;

    assign iready = oready & (o_data_sel == 1'b0) & ~rst;

    // Single clock mode:
    always @(posedge clk_2x) begin
      if (rst) begin
        isof_d <= 1'b0;
        idata_d <= {WIDTH*2{1'b0}};
      end else if (ivalid & iready) begin
        idata_d <= idata;
        isof_d <= isof;
      end
    end

    always @(posedge clk_2x) begin
      if (rst) begin
        o_data_sel <= 1'b0;
      end else if (ivalid & iready) begin
        o_data_sel <= 1'b1;
      end else if (ovalid & oready) begin
        o_data_sel <= 1'b0;
      end
    end

    always @(posedge clk_2x) begin
      if (rst) begin
        has_data<= 1'b0;
      end else if (ivalid & iready) begin
        has_data <= 1'b1;
      end else if (ovalid & oready & ~o_data_sel) begin
        has_data <= 1'b0;
      end
    end

    assign odata = o_data_sel ? idata_d[WIDTH*2-1:WIDTH] : idata_d[WIDTH-1:0];
    assign ovalid = oready & has_data;
    assign osof = isof_d & o_data_sel;

  end
  endgenerate

endmodule

