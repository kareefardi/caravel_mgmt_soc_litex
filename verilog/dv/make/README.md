## sim.makefile

### Targets

- `RTL` : outputs `RTL.vcd RTL.vvp RTL.log`
- `GL`: outputs `GL.vcd GL.vvp GL.log`
- `GL_SDF` : outputs `GL.vcd GL.vvp GL.log`
- `ALL` : runs all of the above
- `clean` : cleans the following artifacts

    ```
	*.elf *.hex *.bin *.vvp *.log *.vcd *.lst *.hexe
    ```
***Note***:
> RTL GL GL_SDF are ***independent*** targets using make -j<number of parrallel jobs> will run them in parallel