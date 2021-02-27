x2821 Overview
==============

Verilog implementation of the logic in the IBM 2821.

Synopsis
--------
Emulate an IBM 2821 model 1 printer/card reader punch control unit with
optional column binary mode in verilog.

What is it?
-----------
The IBM 2821 is an 360 control unit that can attach to a 360 or 370 and
control (depending on the model) up to 1 2540 card reader punch and up
to 3 1403/1404 printers.  The model 1 can control one of each.

The ancestor to the 2821 is the IBM 1414, which could also control among
other devices a 1403 printer and a 1402 card reader punch.  The 1402 card
punch is the direct ancestor of the 2540, and early on, IBM advertised
that the 2821 would use the 1402.  The 1403 printer was a popular choice
on IBM mainframes, and therefore, the 2821 was also fairly popular,
even after IBM came out with newer smarter printers with integrated
control units.

What does it control?
---------------------
The 2540 card read punch was mostly a higher speed version of the
1402 parallel card punch.  The most significant advantage it had was
that it was faster.  It also had slightly more smarts in its belly,
so the actual electronic interface appears to have been significantly
different.  Whereas the 1402 wired up each column directly out to
the control unit, 160 wires of it, the 2540 has a local row buffer,
and holes are read out one at a time serially from this buffer, using
only about 20 lines.  Like the 1402, the 2540 reads a card row by row.
The control unit is responsible for collecting all the rows, after which
it can present the data from the card, column by column, to the computer.
The punch, which is logically a different device, also punches row by row.
Both the reader and the punch have error checking hardware - the card
reader reads cards twice and compares the results; the card punch reads
the card once after punching and compares the results.  Interestingly,
it doesn't check against the actual data, but only against a computed
hash called the "hole count".

The 1403 printer is well described elsewhere.  The main thing to remember
is that interfacing to it primarily means having a bunch of counters
carefully counting out pulses, to determine when to fire hammers just
before the right character runs by the hammer.  Other features of note are
the carriage control tape and a two speed hydraulic paper advance motor.

The 2540 interface is not so well described, and requires a fair amount
of guesswork.  It includes a variety of switches and lights, in addition
to other control signals to run the buffer logic in the device.  There is
much more complete information out there for the 1402 card punch; the
mechanical description is very relevant, but the electrical description
is not close to what the 2821 sees.

A fair bit of the 2821 logic is optional to support the 1404 printer.
This was similar to a 1403 printer, but it could also read selected data
off of cards before printing on them.  The standard 1403 printer only
printed in upper case, but with the UCS option and the right chain,
it could print lower case as well.  The card reader and punch could
optionally punch all 12 rows with arbitrary data, not just ebcdic, as
part of a "column binary" feature.  I've not included most of the logic
necessary to support any of those features here.

Inside the 2821
---------------

Internally, the 2821 sports several core memories, each of which is
addressed decimally.  The decimal logic is different in detail from the
1414, which was also decimal.  Several places in the ALDs for the 2821
show a "star" pattern indicating the order of counting for addressing
these devices.  One special property of these counters is they could
be easily made to count by 3 instead of by 1; this was important for
controlling the 1403.  The core memories are all 8 x 10; for the printer,
they were made to be 160 x (6 + x), of which only 132 positions (starting
with 1) were used.  Ebcdic characters were converted into 6-bit print
character counter values before being stored.  Extra bits were used to
keep track of which hammers had been fired.  For the card reader and
punch, the core memory was organized as 80 x (12 + X), with extra bits
for character checking.  The buffer always stored 12-bit characters;
without column binary mode they were converted to/from ebcdic between
the buffer and the computer.

In addition to combinational latches, the 2821 also included a number
of clocked trigger designs.   Understanding these properly is crucial
to understanding how the 2821 works, in particular, the decade counters.
The ac inputs are actually capacitively connected, which means it takes
a sharp positive transition on the ac-set or ac_reset to set or clear
the latch.  The dc inputs are negative sense; a low input sets or clears
the latch.  The gate outputs both a positive and a negative sense output.

Implementation notes
--------------------

For the card reader punch and printer, various bits of logic were not
quite right in the fpga, so I added "hacks" to enable the right behavior.
These probably reflect differing races or other logic aberrations from
the original 2821 asynchronous design.  I've provided several local
parameters, sense_hack, prt_hack, and pch_hack, that enable these
various fixes.

For the interface between the 1403 and 2821, in particular, timing is
crucial.  For testing purposes I picked arbitrary values for the various
clocks and one-shots that control the timing in the 2821.  If this were
to be used in the real world, they would need to be set right for the
clock speed of the FPGA vs. the speed of the 1403.  one more parameter,
"CB", controls whether column binary mode is supported.

The printer and card reader punch have separate timing logic
to control memory timing.  For the card reader punch, they are
reg trigger_a_clock_0_4 trigger_b_clock_1_5 trigger_c_clock_2_6
trigger_d_clock_3_7 and trigger_e_clock_4_0.  These are all clocked by
osc_pulse which is counted down by pctr from the fpga clock.  The timing
here can be fairly flexible, but if you had an actual 2540 to work with,
the timing would need to be adjusted to circuit realities, especially for
the core memory buffer.  For the printer, these are trigger_a trigger_b
trigger_c trigger_d trigger_e, which are clocked by osc, which is counted
down by xctr from the fpga clock i_clk.  For testing purposes, I made
xctr & pctr ranges very small.  The timing here must be accurate, because
it will ultimately control when the printer hammers fire.  The channel
interface also has some timing constraints that are controlled in part
by one-shots.  These are not high precision but would obviously need to
be in the ball park to work with real hardware.

The printer hammer impulses generated by this logic will be very short.
If you were trying to drive a real 1403 printer, you'd want to provide
132 one-shot driver cards.  You would also want to engineer those cards
with "coil protect" technology.  The coils in the 1403 are designed to
take 60 V high amperage current, with a very small duty cycle.  If you
exceed the duty cycle, the coil will overheat and burn out.  The
logic I provide ships out 132 separate lines, but on the real
2821, units_drive_bar, bar_tens, and bar_100, were decoded by each
driver card directly.

More generally, you'd also need to worry about switch contact bouncing,
possible high voltages from various other parts of vintage hardware.
and of course, clock domain crossing problems for all inputs.

If you're providing your own device designs, then of course you only
need to match *those* timing constraints, whatever they are.  The values
I chose for timing work with the simulated devices that I use for testing.

References
----------
... Sorry not yet
