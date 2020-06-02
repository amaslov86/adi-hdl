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
// Pack two input beats into one and align it based on start of frame
//
// Frame size 2 beats: 
// Temporal ordering of input: 
//   idata : MS Beat, LS Beat, MS Beat, LS Beat, ...
//   sof   :       1,       0,       1,       0, ...   
// Format of output beats:  {MS Beat, LS Beat}
//
// Frame size 4 beats: 
// Temporal ordering of input: 
//   idata : MS Beat, LS Beat, MS Beat, LS Beat, MS Beat, LS Beat, ...
//   sof   :       1,       0,       0,       0,       1,       0, ...   

// Fast to slow converter of factor 2 with with two operation modes.
//
// Single clock mode:
//  - there is only clock domain (clk_2x)
//  - output data qualifier toggles
//
// Dual clock mode:
//  - clk and clk_2x must be in phase
//  - output qualifier stable 
//

module gearbox_fts #(
  parameter WIDTH = 8,
  parameter SINGLE_CLK_DUAL_CLK_N = 1
)(
  input                      clk_2x, // Input clock, also output clock in single clock mode
  input                      clk,    // Output clock used in dual clock mode
  input                      sof,    // Start of frame indicator marking the MS Beat
  input       [WIDTH-1:0]    idata,  // Input data beat    
  input                      ivalid, // Input data qualifier
  output reg  [WIDTH*2-1:0]  odata,  // Output data beat 
  output reg                 ovalid, // Output data qualifier
  output reg                 osof    // Output Start of frame indicator
);

  reg  [WIDTH-1:0] idata_d = {WIDTH{1'b0}};
  reg  [WIDTH-1:0] idata_2d = {WIDTH{1'b0}};
  always @(posedge clk_2x) begin
    if (ivalid) begin
      idata_d <= idata;
      idata_2d <= idata_d;
    end
  end

  generate if (SINGLE_CLK_DUAL_CLK_N == 0) begin
    // Dual clock mode:
    reg sof_in_phase = 1'b0;
    always @(posedge clk) begin
      sof_in_phase <= ~sof;
    end
    always @(posedge clk) begin
      odata <= sof_in_phase ? {idata_d,idata}
                            : {idata_2d,idata_d};
      ovalid <= 1'b1;
    end

  end else begin
    // Single clock mode:
    reg [6:0] sof_d = 7'b000;
    reg       ivalid_d = 'b0;
    // Use sof_d[2] for frame size of 4 beats
    // Use sof_d[4,6] for frame size of 8 beats
    always @(posedge clk_2x) begin
      ivalid_d <= ivalid;
      if (ivalid) begin
        sof_d <= {sof_d[5:0],sof};
      end
      if (ivalid &(sof_d[0] | sof_d[2] | sof_d[4] | sof_d[6])) begin
        odata <= {idata_d,idata};
      end
      ovalid <= ivalid & (sof_d[0] | sof_d[2] | sof_d[4] | sof_d[6]);
      osof <= ivalid & sof_d[0];
    end
  end
  endgenerate

endmodule
