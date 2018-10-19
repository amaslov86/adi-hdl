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
 * Up-converts the input link by a factor of 2
 * Requirements: 
   * out_link_clk = 2 x in_link_clk
   * the two clocks must be in phase
 */

module ad_ip_jesd204_link_upconv #(
  parameter NUM_LANES = 4,
  parameter OCTETS_PER_BEAT_IN = 8,
  parameter OCTETS_PER_BEAT_OUT = OCTETS_PER_BEAT_IN/2
) (
  input in_link_clk,

  input in_link_valid,
  output in_link_ready,
  input [NUM_LANES*8*OCTETS_PER_BEAT_IN-1:0] in_link_data,

  input out_link_clk,

  output out_link_valid,
  input out_link_ready,
  output [NUM_LANES*8*OCTETS_PER_BEAT_OUT-1:0] out_link_data

);

  assign in_link_ready = 1'b1;

  reg out_beat_sel = 1'b0;
  reg out_link_ready_d = 1'b0;
  reg [NUM_LANES*8*OCTETS_PER_BEAT_IN-1:0] in_link_data_d = 'h0;

  reg in_phase = 1'b0;
  reg in_out_link_ready_d = 1'b0;

  always @(posedge out_link_clk) begin
    if (~out_link_ready) begin
      out_beat_sel <= 1'b0;
    end else begin
      out_beat_sel <= ~out_beat_sel;
    end
  end

  always @(posedge out_link_clk) begin
    out_link_ready_d <= out_link_ready;
    in_link_data_d <= in_link_data;
  end

  always @(posedge in_link_clk) begin
    in_out_link_ready_d <= out_link_ready;
  end

  // Detect phase of of the ready signal relative to the input clock
  always @(posedge in_link_clk) begin
    if (~in_out_link_ready_d & out_link_ready) begin
      in_phase <= out_link_ready_d;
    end
  end

  // The output link must be synchronized to the assertion of the
  // out_link_ready.
  // We must drive the first part of the input beat on the first cycle of the
  // out_link_ready assertion, the second part of the input beat on the next
  // cycle and so on. 
  generate
    genvar i;
    for (i = 0; i < NUM_LANES; i = i + 1) begin: g_lanes
      assign out_link_data[i*8*OCTETS_PER_BEAT_OUT +: 8*OCTETS_PER_BEAT_OUT] =
        ~out_beat_sel ? in_link_data[i*2*8*OCTETS_PER_BEAT_OUT +: 8*OCTETS_PER_BEAT_OUT] :
         in_phase ? in_link_data[(i*2+1)*8*OCTETS_PER_BEAT_OUT +: 8*OCTETS_PER_BEAT_OUT] :
                  in_link_data_d[(i*2+1)*8*OCTETS_PER_BEAT_OUT +: 8*OCTETS_PER_BEAT_OUT];
    end

  endgenerate

endmodule


