# Seiko uc-2000 reverse engineering

This is a project to restore of instruction set for Seiko UC-2000 and analogs. The goal of this project is to write first third-party application (even more - first program in more than 30 years) for these early smart watch.

**[Wiki/Instruction Set](https://github.com/azya52/seiko/wiki/Instruction-Set)**<br />
Instruction Set that I was able to recover.

**[./rom](https://github.com/azya52/seiko/tree/master/rom)**<br />
Contains 5 applications from the original ROM that came with the UC-2200. These files were taken from http://www.sigma957.org/datagraph.html

**[./docs](https://github.com/azya52/seiko/tree/master/docs)**<br />
Manuals and other documents.

**[./ads](https://github.com/azya52/seiko/tree/master/ads)**<br />
Scans of ads and magazine cuttings.

**[./axasm](https://github.com/azya52/seiko/tree/master/axasm)**<br />
Assembler for Seico Cal. UW01, I used axasm by Al Williams (https://github.com/wd5gnr/axasm)

**[./ucDisassembler](https://github.com/azya52/seiko/tree/master/ucDisassembler)**<br />
Very simple disassembler, but without which I would not have managed (Source code of applications from the ROM are in ./rom/disassembled)

**[./apps](https://github.com/azya52/seiko/tree/master/apps)**<br />
Programs written by me. Now there's Tetris and Watch face pack, see demo video

**[./Transmitters](https://github.com/azya52/seiko/tree/master/Transmitters)**<br />
Firmware sources for the PC -> Watch wireless interface, and the application for Windows based on http://www.sigma957.org/datagraph.html
I will publish the device schemes a little later.

**[./UC2000Keyboard](https://github.com/azya52/seiko/tree/master/UC2000Keyboard)**<br />
Source code of the application for Android emulating UC-2100 keyboard, in which to transfer data to the watch using phone speaker coil. Due to frequency limitations (the application transmits at 16384Hz, while the native frequency is 32768Hz) the transmission comes with a significant number of errors - at best 10-20%. This app on [Google Play](https://play.google.com/store/apps/details?id=com.azya.seiko.uc2000)
<br /><br />

**Summary**:
- Restored and documented most of the processor instructions;
- Written an assembler on the basis of AXASM;
- Written a simple disassembler;
- Written a two apps - Tetris and the set of custom faces;
- Made a device to connect the watch to the PC;
- Written an emulator of UC-2100 keyboard for Android phones.
<br />

**Tetris demo**<br />
[![Video](https://img.youtube.com/vi/BHnZNJsGcyE/0.jpg)](https://www.youtube.com/watch?v=BHnZNJsGcyE)

**Face pack demo**<br />
[![Video](https://img.youtube.com/vi/W52tVbbM9_A/0.jpg)](https://www.youtube.com/watch?v=W52tVbbM9_A)

**UC2000 Keyboard demo**<br />
[![Video](https://img.youtube.com/vi/F5JUM7w5gWQ/0.jpg)](https://www.youtube.com/watch?v=F5JUM7w5gWQ)
