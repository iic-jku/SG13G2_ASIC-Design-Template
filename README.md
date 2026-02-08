# An Open-Source ASIC Design Template for the SG13G2 IHP Open-PDK.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18378633.svg)](https://doi.org/10.5281/zenodo.18378633)

## Introduction

This template repository is suited for analog mixed-signal design with the 130nm BiCMOS open-source SG13G2 PDK by IHP and the IIC-OSIC-Tools by the Institute for Integrated Circuits and Quantum Computing (IICQC), Johannes Kepler University, Linz (JKU).

IHP SG13G2 PDK: https://github.com/IHP-GmbH/IHP-Open-PDK

IIC-OSIC-Tools (version 2025.12): https://github.com/iic-jku/IIC-OSIC-TOOLS

The installation of IIC-OSIC-Tools is explained under `SG13G2_ASIC-Design-Template/doc/Docker-Tutorial.pdf` or in this YouTube video: https://www.youtube.com/watch?v=UrUOg9s7gsM

**Update:** Since version 2025.03, third-party software such as Xserver is no longer required.

The recommended folder structure makes it easy to automate with shell scripts. VHDL files are read and converted into Verilog files (`vhdl2verilog.sh`). If Verilog files are available directly, this step can be skipped. With OpenROAD flow-scripts (ORFS) the newly generated Verilog file is synthesized and a layout is created. The synthesized Verilog file is then converted into a `.xspice` file with `qflow` scripts (`vlog2Verilog`, `vlog2Spice`, `spi2xspice.py`) which can be included into `Xschem` for analog-digital mixed simulation. All these scripts are automated with `run_all.sh` and can be cleaned again with `clean_all.sh`. The template contains a 4-Bit counter with an enable input to get a better understanding of the structure and the file paths within the scripts.

<img src="doc\scripts_overview.svg" width="400"/>

**Figure 1**: Overview of the script structure in the template GitHub repository.

I have also made a short video on how to use this repo: https://www.youtube.com/watch?v=UrUOg9s7gsM (Note that the scripts have been updated since then. However, the basic functionalities are the same.)

If you want to use other OpenROAD-compatible PDKs, just add the corresponding files to the `orfs/flow/platforms` folder. These files can be found at https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.

This template repository should update itself automatically using GitHub actions and `update_orfs.sh` when a new IIC-OSIC-TOOLS version is released.

## How to use this template for your design

#### Step-by-step introduction:

1. Clone or download this repo and copy it into the `foss/designs` folder of your IIC-OSIC-Tools environment.
2. Copy the `.designinit` file from `foss/designs/SG13G2_ASIC-Design-Template` to `foss/designs` and check the path for Xschem. This will change the used PDK to SG13G2 by IHP.

   **Update:** The path to Xschem is now set with the `xschemrc` file. Just start Xschem within the `xschem` folder and everything will be set up.
3. Run `run_all.sh` with the `-s/--sim` flag (`./run_all.sh -s counter`) for creating only a synthesized Verilog file and a `.xspice` file for simulation in `Xschem`.
4. Run `run_all.sh` with the `-l/--layout` flag (`./run_all.sh -l counter`) for creating a synthesized Verilog file and the digital layout. No `.xspice` file is created or overwritten.
5. If the steps 3. and 4. work, proceed to add your own project files.
6. Execute `clean_all.sh` to remove any build files.
7. Rename the repo as you wish.
8. Add your VHDL code to the `vhdl` folder. It is advised that the same folder structure with `rtl` and `sim` is used.
9. Add your `Xschem` files and testbenches to the `xschem` folder
10. Adapt VHDL paths in `vhdl2verilog.sh` in the `verilog` folder. If the design is already done in Verilog, this step can be skipped. By default the script works with VHDL files. For Verilog files, please use the `--verilog` flag and the VHDL to Verilog conversion part is skipped.
11. Add config files to `orfs/flow/designs/ihp-sg13g2`. It is a good idea to copy an existing folder (e.g. `counter_board`) and adapt these files. Do not forget to set the path to the Verilog file in `config.mk` and set up the `constraint.sdc` and `autotuner.json`.
12. Double-check the paths in the .sh files.
13. In the `Xschem` testbench, include the generated `.xspice` file with an absolute path, otherwise, ngspice will not find the file. For example, `.include /foss/designs/SG13G2_ASIC-Design-Template/xspice/counter_board/counter_board.xspice`
14. Create a symbol with all needed pins (also VDD and VSS) and assign the pin order with `SHIFT+S`. The pin order can be found in the `.xspice` file (left signal = 0 to right signal = N-1). In the properties (open with `q`), the type should be set to `type=primitive`. It is recommended to check the `.sym` file in a text editor if everything was set correctly.
15. Run `run_all.sh` again and try out the analog mixed-signal gate-level simulation in `Xschem`.

For more detailed information, please refer to Option B in `SG13G2_ASIC-Design-Template/doc/AMS_simulation.pdf` or the YouTube video.

#### Hierarchical synthesis:

If you want to see the area per module / entity of your digital core, you can set `export SYNTH_HIERARCHICAL=1` (default) in `run_orfs.sh` and open the hierarchy browser in the OpenROAD GUI. If it is disabled, check the box under `Windows/Hierarchy Browser`.

**Note that the mixed-signal simulation in Xschem will not work if `SYNTH_HIERARCHICAL=1` is set. Hence, this option is only available for the -l/--layout flag.**

#### Simulation details:

The VHDL code is simulated with `GHDL` & `GTKWave` (counter_tb.gtkw ) or `Modelsim` (sim.do). The VHDL simulation can be executed with `simulate_vhdl.sh`. The Verilog code is simulated with `verilator` & `iverilog` & `GTKWave` or `Modelsim` (sim_verilog_tb.do or sim_vhdl_tb.do). The Verilog simulation can be executed with `simulate_verilog.sh`. Alternatively, one can use `Surfer` instead of `GTKWave`. Further information can be found in the YouTube video.

#### Exporting Ngspice data and plotting them with Python:

The data can not only be shown within Xschem but, of course, exported as a .txt file, read with Python and the function `loadngspicecol` in `ngspice2python.py`, and finally plotted with Matplotlib. If you navigate into `foss/designs/SG13G2_ASIC-Design-Template/python/plot_simulations` and execute `python3 plot_counter_board_tb_tran.py`, the plot will pop up.

Alternatively, one can post-process the data (e.g. down-sample or cut out data) and export a .csv file. This file can then be used with `pgfplots` for professional vector graphics for a paper or thesis.

<img src="python\plot_simulations\figures\counter_board_simulation.svg" width="1200"/>

**Figure 2**: Ngspice data plotted with Python.

## **ToDo**

It is planned to add scripts or template / reference project files for the following features (help wanted).
- [ ] `CACE` Support
- [ ] easy-to-use workflow for DRC / LVS / PEX with `kLayout` / `Magic`
- [ ] `LibreLane` Support
- [ ] Post-Layout Simulation with `Spice`
- [ ] `ngspice` & `verilog` RTL Co-Simulation using `Xschem`: https://www.youtube.com/watch?v=PPd7jkcHOgA
- [ ] Gate-Level Simulation with `cocotb`
- [ ] GDS Renderings with `Blender`
- [ ] Verilog-A Support with `VACASK`

## **Cite this work**

```
@software{Dorrer_2026_ASIC_Template,
	author = {Dorrer, Simon},
	month = jan,
	title = {{GitHub Repository for an Open-Source ASIC Design Template for the SG13G2 IHP Open-PDK}},
	url = {https://github.com/iic-jku/SG13G2_ASIC-Design-Template/tree/2025.12},
	doi = {10.5281/zenodo.18378633},
	year = {2026}
}
```