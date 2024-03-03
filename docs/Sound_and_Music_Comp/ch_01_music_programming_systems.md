# Ch 1 Music Programming Systems

## Intro

Music programming system is a complete software package for making music with computers.

## Early Music Programming Languages

- Unit Generator (UG) : basic building block for an instrument that can be connected to other UGs to create a signal path
  - UGs are black boxes that have defined behavior given the parameters and/or inputs, but the internals are not exposed to the user
  - UGs are often thought of as implementing an algorithm
- instruments : provide a structure to place UGs

### Music IV

- first general model of a music programming system, written for IBM 7094
- the software comprised a number of separate programs that run in three phases that eventually produce a digital audio stream on disk
  - pass one : takes control data in the form of a numeric score and function-table generation instructions
    - the data here is used as parameters to be fed to instruments
- the numeric score is a list of parameters for each instance of instruments to allow them to generate different types of sounds
  - ex. start times / durations / parameters
  - pass two : sorts the score in time order and applying any tempo transformations
  - pass three : the synthesis program is loaded and generating the audio output

#### Function Tables

Function tables are an efficient way to handle many types of mathematical op- erations that are involved in the computing of sound. They are pre-calculated lists of numbers that can be looked up directly, eliminating the need to compute them repeatedly. For instance, if you need to create a sliding pitch, you can generate the numbers that make up all the intermediary pitches in the glissando, place them in a function table, and then just read them. This saves the program from having to calculate them every time it needs to play this sound.

#### MUSIC IV Data Types

- U : unit generator outputs
- C : conversion function outputs
- P : note parameters
- F : function tables
- K : system constants

###  Music V

Final iteration of the MUSIC series, written in FORTRAN.

### Music 360

Written at Princeton by Barry Verco for IBM 360.

## Music 11

- a version of MUSIC 360 for the smaller DEC PDP-11, by Barry Vercoe

## Csound

