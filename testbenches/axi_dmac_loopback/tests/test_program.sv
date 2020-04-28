`include "utils.svh"
`include "environment.sv"

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import logger_pkg::*;

import `PKGIFY(`TH, `M_DMAC)::*;
import `PKGIFY(`TH, `S_DMAC)::*;

program test_program;
  //declaring environment instance
  environment env;

  initial begin
    //creating environment
    env = new(`TH.`MNG_AXI.inst.IF,
              `TH.`DDR_AXI.inst.IF
    );

    #2ps;

    setLoggerVerbosity(6);
    start_clocks();
    sys_reset();

    env.start();

    simpleRegTest;


    `INFO(("start env"));
    env.run();

    // Test with full DDR rate
    singleTest;

    // Slow down DDR interface to create backpressure on the AXIS interface between the DMACs
    `TH.clk_rst_gen.`DDR_CLK.inst.IF.set_clk_frq(.user_frequency(7500000));

    singleTest;

    stop_clocks();

    $display("Testbench done !!!");
    $finish();

  end

  task singleTest();
    dma_segment m_seg, s_seg;
    int m_tid, s_tid;
    // gen 10 frames
    int frame_num = 10;
    int rand_succ = 0;
    byte src_data;

    for (int i=0; i<frame_num; i++) begin
      m_seg = new;
      m_seg.set_params({`DMAC_PARAMS(`TH, `M_DMAC)});
      rand_succ = m_seg.randomize() with { src_addr == i*4096;
                                           length >= 4;
                                           length <= 2048;};
      if (rand_succ == 0) `ERROR(("randomization failed"));


      s_seg = new;
      m_seg.copy(s_seg);
      s_seg.dst_addr = m_seg.dst_addr + 'h1000_0000;
      s_seg.set_params({`DMAC_PARAMS(`TH, `S_DMAC)});

      env.m_dmac_api.enable_dma();
      env.s_dmac_api.enable_dma();

      env.m_dmac_api.submit_transfer(m_seg, m_tid);
      env.s_dmac_api.submit_transfer(s_seg, s_tid);


      env.m_dmac_api.wait_transfer_done(m_tid);
      env.s_dmac_api.wait_transfer_done(s_tid);

      // Compare data blocks
      for (int j=0; j<m_seg.length; j=j+1) begin
        env.ddr_axi_seq.get_byte_from_mem(m_seg.src_addr+j, src_data);
        env.ddr_axi_seq.verify_byte(s_seg.dst_addr+j, src_data);
      end

    end

  endtask

  // This is a simple reg test to check the register access API
  task simpleRegTest;
    xil_axi_ulong mtestWADDR; // Write ADDR

    bit [63:0]    mtestWData; // Write Data
    bit [31:0]    rdData;

    env.mng.RegReadVerify32(`M_DMAC_BA + GetAddrs(dmac_IDENTIFICATION), 'h44_4D_41_43);

    mtestWData = 0;
    repeat (10) begin
      env.mng.RegWrite32(`M_DMAC_BA + GetAddrs(dmac_SCRATCH), mtestWData);
      env.mng.RegReadVerify32(`M_DMAC_BA + GetAddrs(dmac_SCRATCH), mtestWData);
      mtestWData += 4;
    end

    env.mng.RegReadVerify32(`S_DMAC_BA + GetAddrs(dmac_IDENTIFICATION), 'h44_4D_41_43);

  endtask

  task start_clocks;

    `TH.clk_rst_gen.`USR_CLK.inst.IF.set_clk_frq(.user_frequency(10000000));

    `TH.clk_rst_gen.`USR_CLK.inst.IF.start_clock;
    `TH.clk_rst_gen.`MNG_CLK.inst.IF.start_clock;
    `TH.clk_rst_gen.`DDR_CLK.inst.IF.start_clock;
    #100;

  endtask

  task stop_clocks;

    `TH.clk_rst_gen.`USR_CLK.inst.IF.stop_clock;
    `TH.clk_rst_gen.`MNG_CLK.inst.IF.stop_clock;
    `TH.clk_rst_gen.`DDR_CLK.inst.IF.stop_clock;

  endtask

  task sys_reset;

      //asserts all the resets for 100 ns
      `TH.clk_rst_gen.`RST.inst.IF.assert_reset;

      #1000
      `TH.clk_rst_gen.`RST.inst.IF.deassert_reset;

  endtask


endprogram
