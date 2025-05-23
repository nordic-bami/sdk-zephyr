#!/usr/bin/env bash
# Copyright 2020 Nordic Semiconductor ASA
# SPDX-License-Identifier: Apache-2.0

source ${ZEPHYR_BASE}/tests/bsim/sh_common.source

# Basic Connected ISO test: a Central connects to 9 Peripherals and Establishes
# 1 CIS each to 9 Peripherals (9 CIS in a CIG)
simulation_id="connected_iso_legacy_adv"
verbosity_level=2
EXECUTE_TIMEOUT=500

cd ${BSIM_OUT_PATH}/bin

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=0 -testid=central

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=1 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=2 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=3 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=4 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=5 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=6 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=7 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=8 -testid=peripheral

Execute ./bs_${BOARD_TS}_tests_bsim_bluetooth_ll_cis_prj_conf_overlay-legacy_adv_conf \
  -v=${verbosity_level} -s=${simulation_id} -d=9 -testid=peripheral

Execute ./bs_2G4_phy_v1 -v=${verbosity_level} -s=${simulation_id} \
  -D=10 -sim_length=60e6 $@

wait_for_background_jobs
