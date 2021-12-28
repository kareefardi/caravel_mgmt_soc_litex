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
#
# SPDX-License-Identifier: Apache-2.0


export IVERILOG_DUMPER = fst

# RTL/GL/GL_SDF
SIM?=RTL
SIMS = RTL GL GL_SDF

VCDS = RTL.vcd GL.vcd
VVPS = $(foreach i,$(SIMS),$(i).vvp)
#all: GL.vcd
#ALL: $(VCDS) GL_SDF.vcd
ALL: GL_SDF RTL GL


	
##############################################################################
# Runing the simulations
##############################################################################
.PHONY: RTL
.PHONY: RTL.vcd 
RTL.vcd : $(BLOCKS)_tb.v $(BLOCKS).hex
	# this is RTL
	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
		-f $(VERILOG_PATH)/includes/includes.rtl.$(CONFIG) -o $@ $< 

.PHONY: GL
.PHONY: GL.vcd 
GL.vcd : $(BLOCKS)_tb.v $(BLOCKS).hex
	# this is GL
	iverilog -Ttyp -DFUNCTIONAL -DGL -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
		-f $(VERILOG_PATH)/includes/includes.gl.$(CONFIG) -o $@ $<

.PHONY: GL_SDF
.PHONY: GL_SDF.vpp
GL_SDF.vvp : $(BLOCKS)_tb.v $(BLOCKS).hex
	# this is GL_SDF
	cvc  +interp \
		+define+SIM +define+FUNCTIONAL +define+GL +define+USE_POWER_PINS +define+UNIT_DELAY +define+ENABLE_SDF \
		+change_port_type +dump2fst +fst+parallel2=on   +nointeractive +notimingchecks +mipdopt \
		-f $(VERILOG_PATH)/includes/includes.gl+sdf.$(CONFIG) $< | tee $@.log

GL_SDF : % : %.vvp
	# GL_SDF done simulation $(BLOCKS)
	

RTL GL : % : %.vpp
	# RTL GL done simulating $(BLOCKS)


RTL.vpp GL.vpp : %.vpp : %.vcd
	vvp $< | tee $<.log


##############################################################################
# Comiple firmeware
##############################################################################

%.elf: %.c $(LINKER_SCRIPT) $(SOURCE_FILES)
	${GCC_PATH}/${GCC_PREFIX}-gcc -g \
	-I$(FIRMWARE_PATH) \
	-I$(VERILOG_PATH)/dv/generated \
	-I$(VERILOG_PATH)/dv/ \
	-I$(VERILOG_PATH)/common \
	  $(CPUFLAGS) \
	-Wl,-Bstatic,-T,$(LINKER_SCRIPT),--strip-debug \
	-ffreestanding -nostdlib -o $@ $(SOURCE_FILES) $<

%.lst: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objdump -d -S $< > $@

%.hex: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	# to fix flash base address
	sed -ie 's/@10/@00/g' $@

%.bin: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@
	


# ---- Clean ----

clean:
	rm  -f *.elf *.hex *.bin *.vvp *.log *.vcd *.lst *.hexe

.PHONY: clean hex all



