---
title: Voynich-CX
---

What is it?
===========

The Voynich-CX is a hobby computer created from the ground up as an experiment
in learning about 8-bit computers, FPGAs, and electronics. The goal is to create
a computer that is easy to emulate, with an easy to use toolchain that can be
built physically with readily available parts.

What are its specifications?
============================

CPU: MOS 6502 running at 3.72mhz

RAM: 16kB of RAM with 3k reserved for video and 1k for audio

ROM: 32kB

I/O:

-   SD Card Slot

-   Cartridge Slot

-   PS/2 Keyboard connector

-   D-sub 9 joystick port

-   VGA out

-   NTSC/PAL Composite out

-   MIDI in/out

Video Chip – Grue
=================

Text Mode
---------

40x25 characters

8 colors available, with bright or dark palette

Each character can be flipped horizontally or vertically

Graphics Mode
-------------

320x200 High Resolution Mode

120x100 High Color Mode

Sound Chip – Snark
==================

Features

4 Wavetable Channels

Each wavetable consists of a 4x4 bit wave

Registers:

Wavetable – 4 bits

Tooling
=======

ROM build and flashing tool - Codex
