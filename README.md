# FPGA-Synthesizer
## Overview
The FPGA-Synthesizer is a sound synthesizer for FPGA boards capable of generating 4 different types of waveforms
(square, sawtooth, triangle, sine) as well as random noise. Each waveform generator can be independently turned on
and off with switches on the FPGA board, allowing the user to play any combination of waveforms at a time to
produce different unqiue sounds.  

The musical note produced is controlled using the Digilent PmodKYPD 16 button keypad,
allowing the user to play and create music in real-time. By default, the buttons are mapped to 2 octaves of the C
major scale for ease-of use. The name of the note currently being played is output to the onboard 7-segment display.

Use of the FPGA-synthesizer requires the Digilent PmodI2S stereo audio device, which accepts a standard 3.5mm audio jack.

## Design Description
### Schematic
![schematic](https://cloud.githubusercontent.com/assets/10604384/13713739/6f4e9f86-e77f-11e5-9187-544b286e3d0e.png)

Above is an overall design diagram showing how all of the modules are related to eachother. The core modules are the
I2S Pmod-out module and the different waveform modules. 
The waveform modules output audio signals corresponding to the waveform of interest and input frequency
determined by the last button pressed on the Pmod keypad.
The Signal Adder module then accumulates these signals as specified by the onboard switches into an total audio signal value.
The Pmod-out module takes this total signal as input and outputs the audio signal bit-by-bit following the I2S protocol
to the Pmod Stereo Audio Output to generate sound.

### Keypad PMOD Module (pmod_kypd_input.v)
The way the Keypad PMOD works is that you need to set one column to logic level low while the other columns are set to logic
level high in order to observe if a button was pressed. If a button was pressed, the pin corresponding to that row will be at
logic level low. Only one column can be checked at a time so we rotate through each column, checking each column every millisecond.

The button pressed will output a certain frequency value that goes to the other modules (the seven segment display and the
signal wave modules.

### Display Module (display.v)
The display module is a simple switch statement, which displays the letter name of the note on the 7 segment display based
on the frequency value passed in as input.

### Square Wave Module (osc_square.v)
This is our most basic signal generating modules. It takes the current frequency and converts it into a period, outputting
a high signal for half of the period and a low signal for the other half of the period. As a result, it essentially acts as
a variable clock, having a low to high transition once every period, according to the current frequency value it receives as input.

Our high signal has the value 0000111111111111 in binary, and low signal has the value 1111000000000000 in binary.
The most positive and negative numbers are not the highest values they can be in order to prevent overflow when this signal
is added with other signals.

### Sawtooth/Triangle Wave Module (osc_tri_saw.v)
This module generates two different signals.  The first to be generated is the saw wave.  As with the square wave,
the amplitude is fixed at 0000111111111111, and the period is calculated from the input frequency.  A counter is incremented
with every clock cycle and resets to 0 at each period.  From here, the output value is calculated according to the following formula:

signal = ((amplitude – count) / period) – X

where X = 0 for the first half of the period and X = amplitude for the second half.

After this, the triangle wave signal is generated, using the saw wave signal as input.  First, the absolute value of the saw
wave is taken by inverting the signal if the highest bit is 1.  This creates a vertically shifted triangle wave with half the
desired amplitude.  To restore the full amplitude, the value is shifted down by one-fourth of the amplitude and then multiplied
by some desired factor.

### Sine Wave Module (osc_sine.v)
This module generates a sine wave using a phase-locked loop given by the following equations.

sin(t) = sin(t-1) + C*cos(t-1)

cos(t) = cos(t-1) - C*sin(t-1)

Where C is a variable dependent on the input frequency.

The phase-locked loop is initialized by setting the sine signal value to 0 and the cosine value to the intended 
amplitude (0011111111111111). C is calculated by taking the frequency and dividing it by the number 159154. This 
number was determined via simulation. During each computational cycle, the current values for the sine and cosine 
signals are calculated from the previous ones as shown in the aforementioned equations. Then, the previous signal 
values are updated to the current values before the next computational cycle. If a complete sine wave cycle has 
passed (if the current sine value >= 0 and the previous sine value < 0), the sine and cosine signal values are 
reset to their initial values to avoid accumulating rounding errors as time progresses.

The computation in this module requires more precision than is allowed by our default 16-bit output signal value. 
All computation is performed using 32-bit Verilog integers where the sine and cosine signal values are left-shifted 
by 16 bits for increased precision. Once a 32-bit value for the sine signal is determined, it is right-shifted back 
16 bits before being stored in the output signal value.

### Signal Adder Module (sig_adder.v)
As its name suggests, the module accumulates the output signals from all of the activated oscillators.  
Aside from the clock, the signal adder module has 9 inputs: 4 of the 5 waveform signals (square, saw, triangle, sine), 
and 5 switches, where each switch can turn one of the oscillators on or off.  At each clock cycle, the output value is 
initialized as 0.  For each switch that is flipped to 1, the signal from the corresponding waveform is added to the 
total output.

The noise generator does not have its own module - instead, the code is located in the signal adder module. 
It uses a 16 bit linear feedback shift register (LFSR) to generate a pseudo-random signal, looping through all 
65536 possible 16-bit values in a very complicated pattern generated by left shifting and taking the xor of several bits. 
As with the other modules, its signal is added to the total output only if the noise switch is turned on.

### PmodI2S Output Module (pmod_out.v)
This module takes the final summed audio output signal from the signal adder module and converts it to I2S protocol, 
allowing it to be correctly interpreted by the PmodI2S audio output device.  4 signals are output from this module to 
the PmodI2S device.  3 are clocks: the master clock, which synchronizes the other signals; the left/right clock, which 
switches between left and right stereo audio channels, and the serial clock, which signals the transmission of a data bit.
The fourth output is the serial data, which transmits the actual audio signal one bit at a time.  With 16 bit audio, it 
takes 16 serial clock cycles to transmit a single audio signal.

The master clock is set at 2000 kHz, the left/right clock is set at 1000 kHz, and the serial clock is set at 31.25 kHz.  
The serial clock is 32 times as fast as the left/right clock, meaning that when a full 16 bit audio signal is transmitted, 
the left/right clock reaches its half period and switches from high to low or vice versa, and the next audio signal is sent 
to the opposite ear.  The individual audio bits are taken from the input signal by left shifting the signal 1 at a time and 
taking the highest order bit.

With a bit rate of 15.625 kHz (31.25 / 2 channels), our audio quality is slightly less than the uncompressed CD and wav 
standard of 44.1 kHz (not that it makes a difference, with the simplicity of our sounds).

### Master Control Module (mastermind.v)
This is not a “proper” module, as it performs no functionality, and does not appear on the diagram.  
Instead, it contains and connects the inputs and outputs all of the other modules.
