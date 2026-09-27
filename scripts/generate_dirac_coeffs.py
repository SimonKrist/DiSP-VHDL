import numpy as np
from scipy.signal import firwin
from pathlib import Path
from plot_filter import plot_filter

FILTER_LENGTH = 1366
FILTER_WIDTH = 16

FS = 8000.0     # fs as set in ssm2603 config
FC = 100.0      # desired cutoff frequency

samples = [0] * FILTER_LENGTH

samples[683] = 1

plot_filter(samples, FS)

# generate VHDL file segment
lines = []
lines.append("-- Note: this file was auto-generated using a python script.")
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

lines.append(f"     0 => to_signed(32767, FILTER_WIDTH),")

for i in range(FILTER_LENGTH-1):
    j = i + 1
    comma = "," if j < FILTER_LENGTH - 1 else ""
    lines.append(f"     {j} => to_signed(0, FILTER_WIDTH){comma}")

lines.append("  );")
lines.append("end package filter_pkg;")
Path("filter_pkg.vhd").write_text("\n".join(lines), encoding="utf-8")

print("Done.")