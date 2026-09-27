# DiSP-VHDL
This repository provides the VHDL files required for simulation and implementation of the Diffuse Signal Processing (DiSP) algorithm. Furthermore, Python scripts for generation of the required Temporary Diffuse Impulse (TDI) response as well as other impulse responses useful for testing are provided in the 'scripts' directory.

## Requirements

Using the VHDL files, it should be possible to simulate and implement the design on a variety of platforms.
During development, simulation was done using ModelSim, Intel FPGA 10.5b, Quartus Prime 16.1. The logic was implemented on a Zybo Zynq-7000 development board using Xilinx Vivado 2016.1. Python version 3.14.3 together with Scipy (1.13.0), numpy (1.26.4) and matplotlib (3.10.8) was used for impulse generation.

The design requires the following external signals:

 1. 'reset_i': external reset input, active high
 2. 'bit_clk_i': bit clock used for I2S transmission, sourced from an external audio codec - 3.072 MHz during development
 3. 'conv_clk_i': external clock for the convolution logic. The minimum speed depends on the filter length and sample rate - 15 MHz was used during development.
 4. 'filter_enable_l_i': external input used for enabling the filter on the left channel, active high
 5. 'filter_enable_r_i': external input used for enabling the filter on the left channel, active high
 6. 'lr_clk_rec_i': left/right clock for the record path's I2S interface, sourced from an external audio codec
 7. 'lr_clk_pb_i': left/right clock for the playback path's I2S interface, sourced from an external audio codec
 8. 'data_rec_i': I2S record path data stream coming from an external audio codec

And provides the following signal:

 1. 'data_pb_o': I2S playback path data stream going to an external audio codec

The audio codec used during development was an SSM2603, found on the Zybo Zynq-7000 development board. It was configured to a sample rate of 8 kHz using I2C.
If another codec is intended to be used, its interface has to provide the same layout - otherwise, the logic needs to be adapted. Note that 16-bit digital audio is used.

## Operating Principle

The top-level design consists of an I2S driver entity and two instances of a convolution entity. The I2S driver converts the serial data stream into parallel 16-bit outputs for each channel, which are read by the convolution logic, where the pre-defined filter impulse response is applied. The processed signal is output back to the I2S driver in a parallel fashion and converted back to a serial I2S data stream. The separate, higher convolution clock allows for just one sample of processing delay.