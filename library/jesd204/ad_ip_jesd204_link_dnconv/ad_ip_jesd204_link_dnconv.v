// ***************************************************************************
// ***************************************************************************
// Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms.
// The user should keep this in in mind while exploring these cores.
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

/*
 * Down-converts the input link rate by a factor of 2 by doubling the
 * datawidth.
 * (older bytes are in LSB, newest bytes in MSB)
 */

module ad_ip_jesd204_link_dnconv #(
  parameter NUM_LANES = 4,
  parameter OCTETS_PER_BEAT_IN = 4,
  parameter OCTETS_PER_BEAT_OUT = OCTETS_PER_BEAT_IN*2
) (
  input in_link_clk,

  input [OCTETS_PER_BEAT_IN-1:0] in_link_sof,
  input in_link_valid,
  output in_link_ready,
  input [NUM_LANES*8*OCTETS_PER_BEAT_IN-1:0] in_link_data,

  input out_link_clk,

  output reg [OCTETS_PER_BEAT_OUT-1:0] out_link_sof = 'h0,
  output reg out_link_valid = 'h0,
  input out_link_ready,
  output reg [NUM_LANES*8*OCTETS_PER_BEAT_OUT-1:0] out_link_data

);

  localparam IBW = 8*OCTETS_PER_BEAT_IN;  // input beat width
  localparam IDW = NUM_LANES*IBW;

  localparam OBW = 8*OCTETS_PER_BEAT_OUT;  // output beat width
/*
  reg [2*IDW-1:0] in_link_data_d = 'h0;
  reg [3:0] in_link_sof_d = 'h0;

  reg not_in_phase = 1'b0;

  // Detect phase of of the sof signal relative to the slower output clock
  always @(posedge out_link_clk) begin
    if (~in_link_valid) begin
      not_in_phase <= 1'b0;
    end else if (|in_link_sof) begin
      not_in_phase <= 1'b1;
    end
  end

  always @(posedge in_link_clk) begin
    in_link_sof_d <= in_link_sof;
  end

  // Align beat with sof always to the LSBs
  always @(posedge out_link_clk) begin
    if (not_in_phase) begin
      out_link_sof[OCTETS_PER_BEAT_IN-1:0] <= in_link_sof;
    end else begin
      out_link_sof[OCTETS_PER_BEAT_IN-1:0] <= in_link_sof_d;
    end
  end

  generate
  genvar i;
  for (i = 0; i < NUM_LANES; i = i + 1) begin: g_lanes

    // create 2 cycle delay for each Lane
    always @(posedge out_link_clk) begin
      in_link_data_d[2*IBW*i +: 2*IBW] <= {in_link_data[IBW*i +: IBW], in_link_data_d[IBW*(i+1) +: IBW]};
    end

    // Align beat with sof always to the LSBs
    always @(posedge out_link_clk) begin
      if (not_in_phase) begin
        out_link_data[OBW*i +: OBW] <= {in_link_data[IBW*i +: IBW], in_link_data_d[IBW*(i+1) +: IBW]};
      end else begin
        out_link_data[OBW*i +: OBW] <= in_link_data_d[2*IBW*i -: 2*IBW];
      end
    end
  end
  endgenerate
*/

  reg [IDW-1:0] in_link_data_d = 'h0;
  reg [OCTETS_PER_BEAT_IN-1:0] in_link_sof_d = 'h0;

  always @(posedge in_link_clk) begin
    in_link_sof_d <= in_link_sof;
    in_link_data_d <= in_link_data;
  end

  generate
  genvar i;
  for (i = 0; i < NUM_LANES; i = i + 1) begin: g_lanes

    always @(posedge out_link_clk) begin
      out_link_data[OBW*i +: OBW] <= {in_link_data[IBW*i +: IBW], in_link_data_d[IBW*i +: IBW]};
    end

  end
  endgenerate

  always @(posedge out_link_clk) begin
    out_link_sof <= {in_link_sof,in_link_sof_d};
    out_link_valid <= in_link_valid;
  end

endmodule


