`include "utils.svh"
`include "dmac_api.sv"
`include "m_axi_sequencer.sv"
`include "s_axi_sequencer.sv"
`include "m_axis_sequencer.sv"
`include "s_axis_sequencer.sv"

`ifndef __ENVIRONMENT_SV__
`define __ENVIRONMENT_SV__

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import `PKGIFY(`TH, `M_DMAC)::*;
import `PKGIFY(`TH, `S_DMAC)::*;
import `PKGIFY(`TH, `MNG_AXI)::*;
import `PKGIFY(`TH, `DDR_AXI)::*;

class environment;

  // Agents
  `AGENT(`TH, `MNG_AXI, mst_t) mng_agent;
  `AGENT(`TH, `DDR_AXI, slv_mem_t) ddr_axi_agent;

  // Sequencers
  m_axi_sequencer #(`AGENT(`TH, `MNG_AXI, mst_t)) mng;
  s_axi_sequencer #(`AGENT(`TH, `DDR_AXI, slv_mem_t)) ddr_axi_seq;

  // Register accessors
  dmac_api m_dmac_api;
  dmac_api s_dmac_api;

  dma_transfer_group trans_q[$];
  bit done = 0;


  //============================================================================
  // Constructor
  //============================================================================
  function new(
    virtual interface axi_vip_if #(`AXI_VIP_IF_PARAMS(`TH, `MNG_AXI)) mng_vip_if,
    virtual interface axi_vip_if #(`AXI_VIP_IF_PARAMS(`TH, `DDR_AXI)) ddr_vip_if
  );

    // Creating the agents
    mng_agent = new("AXI Manager agent", mng_vip_if);
    ddr_axi_agent = new("AXI DDR stub agent", ddr_vip_if);

    // Creating the sequencers
    mng = new(mng_agent);
    ddr_axi_seq = new(ddr_axi_agent);

    // Creating the register accessors 
    m_dmac_api = new(mng,
             `M_DMAC_BA,
             {`DMAC_PARAMS(`TH, `M_DMAC)}
            );
    s_dmac_api = new(mng,
             `S_DMAC_BA,
             {`DMAC_PARAMS(`TH, `S_DMAC)}
            );

  endfunction

  //============================================================================
  // Start environment
  //   - Connect all the agents to the scoreboard
  //   - Start the agents
  //============================================================================
  task start();
    mng_agent.start_master();
    ddr_axi_agent.start_slave();
  endtask

  //============================================================================
  // Start the test
  //   - start the scoreboard
  //   - start the sequencers
  //============================================================================
  task test();
    fork
      test_c_run();
    join_none
  endtask

  //============================================================================
  // Post test subroutine
  //============================================================================
  task post_test();
    // wait until done
    wait_done();
//    scrb.shutdown();
  endtask

  //============================================================================
  // Run subroutine
  //============================================================================
  task run;
    test();
    post_test();
  endtask

  //============================================================================
  // Stop subroutine
  //============================================================================
  task stop;
    mng_agent.stop_master();
    ddr_axi_agent.stop_slave();
  endtask

  //============================================================================
  // Wait until all component are done
  //============================================================================
  task wait_done;
    do
      wait (done == 1);
    while (trans_q.size()!=0);
    `INFO(("Shutting down"));
  endtask

  //============================================================================
  // Test controller routine
  //============================================================================
  task test_c_run();
     done = 1;
  endtask

  //============================================================================
  // Interface to the test env
  //============================================================================
  function void queue_trans_g(dma_transfer_group tg);
    trans_q.push_back(tg);
  endfunction

endclass

`endif
