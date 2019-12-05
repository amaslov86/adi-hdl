
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9081_fmca_ebz_vcu118 0 [list \
  RX_JESD_M    8  \
  RX_JESD_L    4  \
  RX_JESD_S    1  \
  RX_JESD_NP   16 \
  RX_NUM_LINKS 1  \
  TX_JESD_M    8  \
  TX_JESD_L    4  \
  TX_JESD_S    1  \
  TX_JESD_NP   16 \
  TX_NUM_LINKS 1  \
]

adi_project_files ad9081_fmca_ebz_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]


adi_project_run ad9081_fmca_ebz_vcu118

