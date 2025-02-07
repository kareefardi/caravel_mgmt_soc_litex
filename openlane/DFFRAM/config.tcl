# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) DFFRAM
set ::env(DESIGN_IS_CORE) 1

set ::env(ROUTING_CORES) 48
set ::env(RUN_KLAYOUT) 0

# Change if needed
set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/DFFRAM.v\
	$script_dir/../../verilog/rtl/DFFRAMBB.v"

set ::env(BASE_SDC_FILE) $script_dir/base.sdc

set ::env(CLOCK_PERIOD) "25"
set ::env(CLOCK_PORT) "CLK"

## Synthesis
set ::env(CLOCK_TREE_SYNTH) 1
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

## Floorplan
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 550 740"

set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg

set ::env(LEFT_MARGIN_MULT) 22
set ::env(RIGHT_MARGIN_MULT) 22

set ::env(CELL_PAD) 0

## PDN 
set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_PDN_HPITCH) "130"
set ::env(FP_PDN_HOFFSET) "16.65"

## Placement
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0

set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.85

set ::env(PL_TARGET_DENSITY) 0.84

## Routing
set ::env(GLB_RT_ADJUSTMENT) 0.18

set ::env(GLB_RT_MINLAYER) 2
set ::env(GLB_RT_MAXLAYER) 6

# set ::env(GLB_RT_OBS) "li1 $::env(DIE_AREA)"

set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.85

## Diode Insertion
set ::env(DIODE_INSERTION_STRATEGY) 4

# disable cts
set ::env(CLOCK_TREE_SYNTH) 0
