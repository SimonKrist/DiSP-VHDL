import numpy as np
from pprint import pprint
import matplotlib.pyplot as plt
from scipy.signal import hilbert
from pathlib import Path
from plot_filter import plot_filter
from scipy.ndimage import gaussian_filter1d

# parameters
fs = 8000
impulse_length = 1366
n_components = 64

f_min = 20
f_max = 3800

tc_low = 0.1
tc_high = 0.005

phase_weight = 0.94

time_constants = []
time_constants_dc = []

phase_values = []

samples = np.zeros(impulse_length)

# Table 5.5 Moore, log middlepoints
freq_points = np.array([
    31.5,                         
    np.sqrt(63 * 94),
    np.sqrt(94 * 125),
    np.sqrt(125 * 187.5),
    np.sqrt(187.5 * 250),
    np.sqrt(250 * 500),
    np.sqrt(500 * 1000),
    np.sqrt(1000 * 2000),
    np.sqrt(2000 * 4000),
    5656.85
])

decay_s = np.array([
    0.1798,
    0.1048,
    0.0788,
    0.0368,
    0.0276,
    0.0197,
    0.0157,
    0.0127,
    0.0082,
    0.0037
])

# time axis
t = np.arange(impulse_length) / fs

# distribute the frequencies logarithmically
freqs = np.logspace(np.log10(f_min), np.log10(f_max), impulse_length)

# interpolation in log10(f)
time_constants_interp = np.interp(
    np.log10(freqs),
    np.log10(freq_points),
    decay_s
)

# distribute the time constants as described by moore
k = (1/(tc_high - tc_low))*np.log(impulse_length/2)
a = np.exp(-k * tc_low)

# generate the tc vector
for n in range(1, impulse_length//2+1):

    tc = np.log((n)/a) / k
    time_constants.append(tc)

time_constants = np.array(time_constants)

plt.semilogx(freqs, np.repeat(time_constants, 2), label='logarithmic distribution')
plt.semilogx(freqs, time_constants_interp, label='Moores\' variable decay method')
plt.xlabel('frequency [Hz]')
plt.ylabel('time constant [s]')
plt.legend()
plt.grid(True)
plt.show()

time_constants_dc = impulse_length / (time_constants_interp * fs)

# generate random phase values
r = np.random.random(impulse_length//2)

pprint(r)

for n in range (0, impulse_length//2):

    p = 2 * np.pi * phase_weight * (r[n] - 0.5)
    phase_values.append(p)

phase_values = np.array(phase_values)

# build the impulse
t = np.arange(impulse_length)

for n in range (1, impulse_length//2+1):

    component = np.cos(phase_values[n-1] + 2 * np.pi * t * (n-1) / impulse_length) * np.exp((-time_constants_dc[n-1] * t) / impulse_length)
    
    samples += component

    #plot_filter(component, fs)

samples /= np.std(samples)

plot_filter(samples, fs)

plt.bar(range(impulse_length), samples, width=2)

plt.xlabel('sample')
plt.ylabel('value')
plt.legend()
plt.grid(True)
plt.show()

NFFT = 262144
NTAPS = 1366

eps = 1e-12

samples = samples.astype(float).copy()

for _ in range(500):
    H = np.fft.rfft(samples, n=NFFT)
    phase = np.angle(H)

    X_new = np.exp(1j * phase)
    long_ir = np.fft.irfft(X_new, n=NFFT)

    samples = long_ir[:NTAPS].copy()

# final normalization
H = np.fft.rfft(samples, n=NFFT)
mag = np.maximum(np.abs(H), eps)
scale = np.exp(np.mean(np.log(mag)))
samples /= scale

plot_filter(samples, fs)

FILTER_LENGTH = 1366
FILTER_WIDTH = 16

# fixed-point scaling (signed 16 bit Q15)
scale = 2**(FILTER_WIDTH - 1) - 1
coeffs_q15 = np.round(samples * scale).astype(int)

# generate VHDL file segment
lines = []
lines.append("-- Note: this file was auto-generated using a python script.")
lines.append(f"-- TDI")
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
Path(f"filter_pkg_tdi_v6.vhd").write_text("\n".join(lines), encoding="utf-8")

print("Done.")