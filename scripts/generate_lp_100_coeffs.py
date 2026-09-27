import numpy as np
from scipy.signal import firwin, freqz
from pathlib import Path
import matplotlib.pyplot as plt
from plot_filter import plot_filter

FILTER_LENGTH = 1366
FILTER_WIDTH = 16

FS = 8000.0     # fs as set in ssm2603 config
FC = 100.0      # desired cutoff frequency

# FIR design; lowpass @ 100Hz - firwin default is lowpass
coeffs = firwin (
    FILTER_LENGTH,
    cutoff = FC,
    window = "hamming",
    fs = FS
)

plot_filter(np.real(coeffs), FS)

# fixed-point scaling (signed 16 bit Q15)
scale = 2**(FILTER_WIDTH - 1) - 1
coeffs_q15 = np.round(coeffs * scale).astype(int)

# generate VHDL file segment
lines = []
lines.append("-- Note: this file was auto-generated using a python script.")
lines.append(f"-- lp @ {FC}Hz")
lines.append("")
lines.append("library ieee;")
lines.append("use ieee.std_logic_1164.all;")
lines.append("use ieee.numeric_std.all;")
lines.append("")
lines.append("package filter_pkg is")
lines.append(f"    constant FILTER_LENGTH : integer := {FILTER_LENGTH};")
lines.append(f"    constant FILTER_WIDTH  : integer := {FILTER_WIDTH};")
lines.append("")
lines.append("    type t_filter is array(0 to FILTER_LENGTH-1) of signed(FILTER_WIDTH-1 downto 0);")
lines.append("")
lines.append("    constant C_FILTER : t_filter := (")

for i, c in enumerate(coeffs_q15):
    comma = "," if i < FILTER_LENGTH - 1 else ""
    lines.append(f"     {i} => to_signed({c}, FILTER_WIDTH){comma}")

lines.append("  );")
lines.append("end package filter_pkg;")
Path(f"filter_pkg_lp_{FC}.vhd").write_text("\n".join(lines), encoding="utf-8")

print("Done.")