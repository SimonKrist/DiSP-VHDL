import numpy as np
from scipy.signal import firwin, freqz
from pathlib import Path
import matplotlib.pyplot as plt

def plot_filter (coeffs, fs):
    NFFT=262144
    freq = np.fft.fftfreq(NFFT, 1/fs)
    H = np.fft.fft(coeffs, NFFT)
    half = NFFT//2

    H = H[:half]
    w = freq[:half]

    magnitude = 20*np.log10(np.maximum(np.abs(H), 1e-12))
    phase = np.degrees((np.angle(H)))

    threshold = 1e-10
    phase[np.abs(phase) < threshold] = 0

    print(len(w))
    print(len(magnitude))
    print(len(phase))

    # -------------------------
    # Plotting
    # ------------------------- 
    plt.figure(figsize=(12, 8))

    # Magnitude response
    plt.subplot(3, 1, 1)
    plt.plot(w, magnitude)
    plt.ylim(-24, 24)
    plt.xlim(10, 4000)
    plt.title("Magnitude Response")
    #plt.xlabel("Frequency [Hz]")
    plt.ylabel("Magnitude [dB]")
    plt.grid()

    # Phase response
    plt.subplot(3, 1, 2)
    plt.plot(w, phase)
    plt.xlim(10, 4000)
    plt.title("Phase Response")
    plt.xlabel("Frequency [Hz]")
    plt.ylabel("Phase [deg]")
    plt.grid()

    # Impulse response
    plt.subplot(3, 1, 3)
    plt.plot(coeffs)
    plt.title("Impulse Response")
    plt.xlabel("Samples")
    plt.ylabel("Amplitude")
    plt.grid()

    plt.tight_layout()
    plt.show()