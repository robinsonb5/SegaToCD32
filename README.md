SegaToCD32
==========

A PSOC4-based project for interfacing 6-button Sega megadrive pads to
the Amiga CD32, mapping all buttons to equivalent functions on the latter
machine.

This is an experimental project designed around the CY8CKIT-049 42XX
development board, which features the 42XX-series PSOC4 chip.  The 41XX
series board will *not* work, since it lacks the programmable logic blocks
which are currently used to replicate the CD32 pad's serial shift register.
