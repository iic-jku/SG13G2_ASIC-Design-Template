# -*- coding: utf-8 -*-
# Author: Simon Dorrer
# Description: This file reads the data from a .txt (ngspice) and plots it.
# Created: 13.12.2024
# Last Modified: 13.12.2024
# ============================================

# Imports
import numpy as np
import matplotlib.pyplot as plt
import ngspice2python as ng
from pathlib import Path
# ============================================

# Plotting Configuration
# ============================================
# Enable interactive mode so plots do not block execution
plt.ion()
plt.close("all")

# Matplotlib Settings
# %matplotlib qt
# %matplotlib inline

# Use LaTeX if available, otherwise fallback gracefully
try:
    plt.rc('text', usetex=True)
    plt.rc('font', family='serif', size=14)
except Exception:
    print("Warning: LaTeX not available. Using standard fonts.")
    plt.rc('font', size=12)
# =========================================================================

def main():
    # Resolve data and output paths relative to this script
    script_dir = Path(__file__).resolve().parent
    data_file = script_dir / "data" / "counter_board_tb_tran.txt"
    figures_dir = script_dir / "figures"
    figures_dir.mkdir(parents=True, exist_ok=True)

    # Load counter_board data from .txt
    data_time = ng.loadngspicecol(str(data_file), "time") * 1e6
    data_clock = ng.loadngspicecol(str(data_file), "clock")
    data_enable = ng.loadngspicecol(str(data_file), "enable")
    data_reset_n = ng.loadngspicecol(str(data_file), "reset_n")
    data_b0 = ng.loadngspicecol(str(data_file), "b0")
    data_b1 = ng.loadngspicecol(str(data_file), "b1")
    data_b2 = ng.loadngspicecol(str(data_file), "b2")
    data_b3 = ng.loadngspicecol(str(data_file), "b3")
    
    # Subsampling data (every 4th value)
    data_time = data_time[1::4]
    data_clock = data_clock[1::4]
    data_enable = data_enable[1::4]
    data_reset_n = data_reset_n[1::4]
    data_b0 = data_b0[1::4]
    data_b1 = data_b1[1::4]
    data_b2 = data_b2[1::4]
    data_b3 = data_b3[1::4]
    
    # Plot Data
    fig1, axs = plt.subplots(7)
    fig1.set_figwidth(16)
    fig1.set_figheight(9)
    axs[0].plot(data_time, data_clock)
    axs[0].set_xlabel(r'$t$ ($\mu$s)')
    axs[0].set_ylabel('Clock (V)')
    axs[0].grid(True)
    axs[1].plot(data_time, data_reset_n)
    axs[1].set_xlabel(r'$t$ ($\mu$s)')
    axs[1].set_ylabel('Reset_n (V)')
    axs[1].grid(True)
    axs[2].plot(data_time, data_enable)
    axs[2].set_xlabel(r'$t$ ($\mu$s)')
    axs[2].set_ylabel('Enable (V)')
    axs[2].grid(True)
    axs[3].plot(data_time, data_b0)
    axs[3].set_xlabel(r'$t$ ($\mu$s)')
    axs[3].set_ylabel('b0 (V)')
    axs[3].grid(True)
    axs[4].plot(data_time, data_b1)
    axs[4].set_xlabel(r'$t$ ($\mu$s)')
    axs[4].set_ylabel('b1 (V)')
    axs[4].grid(True)
    axs[5].plot(data_time, data_b2)
    axs[5].set_xlabel(r'$t$ ($\mu$s)')
    axs[5].set_ylabel('b2 (V)')
    axs[5].grid(True)
    axs[6].plot(data_time, data_b3)
    axs[6].set_xlabel(r'$t$ ($\mu$s)')
    axs[6].set_ylabel('b3 (V)')
    axs[6].grid(True)
    plt.tight_layout(pad=0.5, w_pad=0.1, h_pad=0.1)
    plt.show()
    
    fig1.savefig(str(figures_dir / "counter_board_simulation.svg"), bbox_inches='tight')
    fig1.savefig(str(figures_dir / "counter_board_simulation.eps"), bbox_inches='tight')
    np.savetxt(str(figures_dir / "counter_board_simulation.csv"),
                np.column_stack((data_time, data_clock, data_reset_n, data_enable, data_b0, data_b1, data_b2, data_b3)), comments = "", 
                header = "time,clock,reset_n,enable,b0,b1,b2,b3", delimiter = ",")
    # ============================================

# Main Execution
if __name__ == '__main__':
    main()

    # Keep plots open
    input("\nPress Enter to close plots and exit...")
# =========================================================================