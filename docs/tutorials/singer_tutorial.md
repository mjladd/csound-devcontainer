# An Introduction to Csound

by Eric L. Singer

source: <https://www.eumus.edu.uy/eme/ensenanza/electivas/csound/materiales/tutorials/singer/>

## What Is Csound?

Csound is a public domain computer program which processes text files to synthesize audio and music on a computer. This process is commonly referred to as software synthesis. "Csound" refers to both a software synthesis language and a program for translating this language into sound.

Csound is generally used for non-real-time synthesis. This means that sound does not come out immediately upon running the program. When used in this mode, Csound computes sound output and writes it to a file, which can then be played back. The time it takes to process is dependent on the speed of the computer, the complexity of the instruments and the length of the score.

On a fast computer system, Csound may be able to perform synthesis in real-time, dependent on the complexity of the input files. That is, Csound can play sound out of the computer as the program is running.

Csound runs on a variety of computer platforms. Currently, versions of the program are available for Macintosh, PowerMac, IBM-PC, Atari, Amiga, NeXT, Sun, SGI, HP and other computers. This paper describes the use of Csound on a Macintosh computer. However, most of the information contained in this report is applicable to other versions. Since Csound is currently used mostly for non-real-time synthesis, the descriptions in the report pertain to using Csound in this mode, unless otherwise noted.

When using Csound, the first step is to create two text files: an orchestra and a score file. The orchestra file contains the specifications for the software "instruments" to be played. The score file is a list of the notes and control parameters which play the instruments. Csound reads these files as input and produces digital audio samples, which are then written to disk as a sound file. In other words, the orchestra and score files specify synthesis computations to be performed, and Csound generates samples by performing these computations directly.

Csound can also accept MIDI input in two ways. A standard MIDI file from a sequencer can be converted to a Csound score file, or Csound can process a standard MIDI file while running using MIDI information to play the orchestra instruments directly. On fast computers, Csound can process live MIDI input and play sound in real-time.

The instruments in the orchestra file are created from a set of building blocks which include oscillators, envelope generators, function generators, sample file input, physical models, filters, effects and more. These are similar to the building blocks found in analog and digital synthesizers.

Csound has several advantages over hardware synthesizers, however. The blocks can be arranged in any order and in any quantity. If you require an instrument with a complex arrangement of 1000 oscillators, you can create it in Csound. In addition, Csound includes many functions which are not available in synthesizers, such as physical modeling, phase vocoding, linear predictive coding and spectral analysis and resynthesis.

The trade-off for Csound’s versatility is speed. Because Csound runs on general purpose computers rather than dedicated hardware found in commercial synthesis, it cannot run as fast. This is why it is usually used for non-real-time synthesis. As computer systems get faster, Csound will increasingly be used for real-time synthesis.

## Computer hardware and software requirements for using Csound

You will need a computer on which Csound can run. Versions of Csound are available via anonymous FTP on the Internet for most types of computers. See the Internet guide at the end of the report for more information on obtaining the program.

The computer must have sound output capability. On the Macintosh, you can use the built-in internal or external sound system or dedicated sound hardware such as a Digidesign AudioMedia, SoundTools or ProTools system or a MediaVision ProAudioSpectrum card.

You will need a separate program to play back the audio files generated. For playing sound files on the Mac, you can use SoundDesigner or SoundEdit software or a shareware program such as SoundHack. SoundHack is available via anonymous FTP and can play sound files through the Mac’s built-in sound system using Sound Manager 3.0.

You will also need a text editor or word processor in which to create your orchestra and score files. A recommended text editor for the Mac is BBEdit Lite, which is also available via anonymous FTP.

## Creating Music with Csound

There are three basic steps to creating music with Csound. The first is to create the orchestra and score files. The next is to run Csound, specifying the orchestra and score file names. The program produces a sound file in the format which you select, such as a Sound Designer II or AIFF file. Finally, the sound file can be played back using Sound Designer or another digital audio program.

The following guide will help you learn to understand and use Csound. It contains introductory information and tutorials and is meant to complement the manual and tutorials which are included with the program.

## Csound’s Concept of Time

Before writing Csound files, it is important to understand the program’s concept of processing time. As Csound processes the orchestra and score files, it performs computations at certain times or rates. The three divisions of time are i-time, k-time and a-time. Variables in the orchestra file begin with the letters "i," "k," and "a," corresponding to these time divisions. The value of a variable can change only at its corresponding time.

__A-time variables__ can change on each sample (i.e. at the sampling rate specified in the orchestra header). They are used for audio signals which are sent to the output and any signals that must change at the audio rate. For example, in FM synthesis, both the modulator and carrier oscillator frequencies are in the audio range so they would both be a-time variables in Csound.

__K-time variables__ change at the control rate (also specified in the orchestra header). K-time variables are used for control signals such as envelope generators. Because the control rate is usually lower than the sample rate, it is more efficient to use k-time instead of a-time variables for slower-changing signals. For example, an amplitude envelope would usually be a k-time variable.

__I-time (initialization time)__ occurs at the beginning of each note. Since each note is started by an i-statement in the score, i-statements correspond to i-time. Any variable in the orchestra file beginning with an "i" can only change its value at i-time (i.e. once per note at the beginning of the note). I-time variables are used to initialize note parameters which will not change during the note. For example, if each note played by an instrument is to have a constant pitch, the pitch variable will be an i-time variable.

In the score file, each i-statement also has parameter fields which are read by the instruments in the orchestra using p# variables (where # is the parameter number). Since p-fields can only change once per note, they correspond to i-time so are usually assigned to i-time variables.

## Orchestra File

The orchestra file begins with a header section in which the sample rate, control rate and number of output channels are specified. This is followed by individual instrument sections containing the specifications for each instrument.

### Orchestra Header Format

The header consists of the following four statements:

```csound
sr     = #  ;# is the sample rate
kr     = #  ;# is the control rate
ksmps  = #  ;# must equal the sample rate divided by the control rate
nchnls = #  ;# is number of output channels
```

### Orchestra Instrument Format

Each instrument block contains the specifications for one instrument. A block is delineated by "instr #" and "endin" (# is the instrument number). In between are the variables and commands which make up the instrument:

```csound
instr # ;starts section for instrument number #

<instrument statements here>

endin ;end of this instrument definition
```

## Score File

The score file consists mostly of i-statements. Each i-statement plays a note on a given instrument in the orchestra and specifies the instrument parameters of the note. The score file usually includes f-statements at the beginning which are used to create wave tables or function tables. It may also include other types of statements such as t-statements for changing tempo.

An i-statement line begins with "i#" (where # is the instrument number). It is followed by p-fields separated by spaces or tabs. Each p-field is a numeric value of an instrument parameter. Two p-fields are predefined by CSound. p2 is the note starting time in beats and p3 is the note duration in beats. The default beat rate is one beat per second, which can be changed using a tempo statement. The rest of the p-fields are defined by each individual instrument in the orchestra file.

## Example Orchestra and Score Files

Below are an example orchestra and score file which are documented to show the meanings of the commands. You can run the files through Csound and listen to the output while following the statements to hear the results.

```csound
Example Orchestra File

sr     = 44100 ;sample rate
kr     = 2205  ;control rate
ksmps  = 20    ;sr / kr
nchnls = 1     ;mono output

instr 1  ;instrument #1, an oscillator
asignal oscili 10000, 440, 1 ;table-lookup interpolating osc
;amp = 10000, freq = 440 Hz, tbl = 1
out asignal ;send it to output
endin


instr 2  ;#2, same as #1 but
;with p-fields for input
asignal oscili p4, p5, p6 ;amp = p4, freq = p5, tbl = p6
out asignal
endin


instr 3 ;same but more readable
iamp  = p4 ;init iamp to equal to p4
ifreq = p5 ;init ifreq to equal to p5
itbl  = p6 ;init itbl to equal to p6
asignal oscili iamp, ifreq, itbl ;same as #2
out asignal
endin


instr 4 ;add some control
idur  = p3 ;remember, p3 is always duration
iamp  = p4
ifreq = p5
itbl  = p6
kenv line 0, idur, iamp  ;goes from 0 to iamp in idur time
asignal oscili kenv, ifreq, itbl ;now amp has an envelope
out asignal
endin


instr 5  ;mix three detuned oscs
;creates chorus effect
idur  = p3
iamp  = p4
ifreq = p5
itbl  = p6
kenv line 0, idur, iamp
a1 oscili kenv, ifreq, itbl
a2 oscili kenv, ifreq * .995, itbl ;detune freq down a bit
a3 oscili kenv, ifreq * 1.005, itbl ;detune freq up a bit
out a1+a2+a3 ;add signals together
;same as mixing
endin


instr 6 ;build a square wave
;by additive synthesis
iamp  = p4
ifreq = p5
itbl  = p6
a1 oscili iamp, ifreq, itbl ;fundamental
a3 oscili iamp / 3, ifreq * 3, itbl ;3rd harmonic
a5 oscili iamp / 5, ifreq * 5, itbl ;5th harmonic
a7 oscili iamp / 7, ifreq * 7, itbl ;7th harmonic
a9 oscili iamp / 9, ifreq * 9, itbl ;9th harmonic
out a1+a3+a5+a7+a9 ;add them together
endin


instr 7 ;create an FM pair
idur     = p3
imodamp  = p4
imodfreq = p5
icaramp  = p6
icarfreq = p7
kenv line 0, idur, imodamp ;modulator envelope
amod oscili kenv, imodfreq, 1 ;modulator osc with
;increasing amp, const freq
acar oscili icaramp, icarfreq+amod, 1 ;carrier osc with
;const amp, modulated freq
out acar ;only carrier is heard
endin


instr 8 ;filtered noise
idur       = p3
iamp       = p4
istartfreq = p5
iendfreq   = p6
anoise rand iamp ;random (noise) gen
kenv expon istartfreq, idur, iendfreq ;exponential envelope
;for filter frequency
afiltnoise reson anoise, kenv, kenv / 12, 2 ;put noise through
;a resonant filter
out afiltnoise
endin


instr 9 ;gets input from sound file
ifilenum = 1
asound soundin ifilenum ;filename = "soundin.1"
out asound
endin


instr 10 ;sound file with reverb
ifilenum = 1
irvbtime = p4
asound soundin ifilenum ;get sound in
arvb reverb asound / 6, irvbtime ;send to reverb at
;reduced level
out asound+arvb ;mix original with reverb
endin

instr 11 ;Karplus-Strong plucked string algorithm
idur = p3
iamp = p4
ipitch = p5
ifreq = cpspch(ipitch)
astring pluck iamp, ifreq, ifreq, 0, 1 ;for full explanation
;of "pluck," see
;Csound manual
out astring
endin

Example Score File
;f1 = sine wave table
;create at time 0, length=1024
;gen 10 (sine wave partial generator), one harmonic (pure sine wave)
f1 0 1024 10 1
;f2 = sawtooth table
;use gen 10 to add partials with amp = 1/n
f2 0 1024 10 1 .5 .333333 .25 .2 .166667 .142857 .125
;i1 = table lookup osc
;i1 start dur
i1 0 1
;i2 = same as i1
;i2 start dur p4 p5 p6
i2 2 1 10000 440 1
;i3 = same as i1
;i3 start dur amp freq table
;the . means repeat from line above
;the + means add last start and dur for new start time
;(+ is valid in start field only)
i3 4 1 10000 440 1
i3 + . . . 2
;i4 = i1 with envelope
;i4 start dur amp freq table
i4 7 1 10000 440 2
;i5 = chorusing
;i5 start dur amp freq table
i5 9 1 10000 440 2
;i6 = additive square wave
;i6 start dur amp freq table
i6 11 1 10000 440 1
;i7 = FM pair
;i7 start dur modamp modfreq caramp carfreq
i7 13 3 10000 220 10000 440
;i8 = filtered noise
;i8 start dur amp startfreq endfreq
i8 17 3 10000 10000 20
;i9 = sampler
;i9 start dur
i9 21 3
;i10 = sampler with reverb
;i10 start dur rvbtime
i10 25 6 3
;i11 = plucked string
;i11 start dur amp pitch
i11 32 .5 10000 8.00
i11 + . . 8.04
i11 + . . 8.00
i11 + . . 8.07
i11 + . . 8.00
i11 + 3 . 9.00
```

## Creating a Csound Instrument from a Model

One useful aspect of Csound is that it is easy to create a synthesized instrument from a model or block diagram. In this section, a diagram and description of an FM instrument for playing brass-like tones will be used to demonstrate how to go from an instrument model to a Csound instrument. The model is from John Chowning’s paper on FM synthesis entitled "The Synthesis of Complex Audio Spectra by Means of Frequency Modulation."

Excerpts from the paper with the instrument diagram and description are included in the appendix to this report. The block diagram in Figure 1.10 will be used to create an instrument in the orchestra file.

The top of the orchestra file must begin with a header specifying the sampling rate, control rate and number of output channels:

```csound
sr = 44100 ;sampling rate
kr = 4410 ;control rate
ksmps = 10 ;sr / kr
nchnls = 1 ;one output channel
```

Next begins the instrument definition. This model has several input parameters, which are listed in the text and shown across the top of the diagram. These correspond to instrument parameters in Csound (p#, where # is the parameter number). The parameters for this instrument are duration (p3), amplitude (p4),

carrier frequency (p5), modulating frequency (p6), modulation index 1 (p7) and modulation index 2 (p8). These are defined as i-time variables because they are set at the beginning (initialization) of each note:

```csound
instr 1 ;instrument #1
idur = p3
iamp = p4
icarfreq = p5
imodfreq = p6
imodindex1 = p7
imodindex2 = p8
```

Two more parameters, dev1 and dev2, are calculated from the input parameters. The formulas given can be used explicitly to define these parameters:

```csound
idev1 = p7 * p6
idev2 = (p8 - p7) * p6
```

Next, the signal flow of the diagram is followed and recreated. The first step is to create the two envelope generators, labeled u.g.4 and u.g.5. Figure 1.11 in Chowning’s paper shows the envelope function for brass-like tones as a series of line segments. The levels are from 0 to 1 and the times are given as a fraction of the duration. In Csound, the "linseg" function can be used to create this envelope.

The parameters to linseg alternate \<level> \<time> \<level> \<time> \<level> etc., where \<time> is the time it takes to move between the two surrounding \<level> values. Because an envelope is a control function, it should be defined as a k-time variable:

```csound
kbrassenv linseg 0, idur/6, 1, idur/6, .75, idur/2, .65, idur/6, 0
```

This envelope function is used to create u.g.4 and u.g.5. The frequency input to the envelope generators is implicit in the envelope function (the "frequency" of the envelope is one over its duration, which is the duration of this envelope function). The amplitude inputs are simply scaling amounts, which correspond to multiplying the envelope function by the amplitude:

```csound
kug4 = iamp * kbrassenv
kug5 = idev2 * kbrassenv
```

The next function, u.g.6, is a simple adder. This must be a k-time variable since it adds a value from another k-time variable:

```kug6 = idev1 + kug5```

Csound’s "oscili" command is used to create u.g.1, which is a sine wave oscillator. The amplitude input of the oscillator is u.g.6 and the frequency input is the modulating frequency. Since the frequency will be in the audio range, an a-time variable must be used:

```aug1 oscili kug6, imodfreq, 1```

The score file will need to define wave table 1 to be a sine wave. Another adder, u.g.2, adds the carrier frequency plus u.g.1. This must also be an a-time variable, since it will add values from an another a-time variable:

```aug2 = icarfreq + aug1```

The last function is u.g.3, the carrier oscillator. It is a sine wave oscillator with amplitude input from u.g.4 and frequency input from u.g.2:

```aug3 oscili kug4, aug2, 1```

Finally, the carrier is output using the "out" function and the instrument block is ended:

```csound
out aug3
endin
```

The completed instrument looks like this:

```csound
instr 1

idur = p3
iamp = p4
icarfreq = p5
imodfreq = p6
imodindex1 = p7
imodindex2 = p8
idev1 = p7 * p6
idev2 = (p8 - p7) * p6

kbrassenv linseg 0, idur/6, 1, idur/6, .75, idur/2, .65, idur/6, 0
kug4 = iamp * kbrassenv
kug5 = idev2 * kbrassenv
kug6 = idev1 + kug5
aug1 oscili kug6, imodfreq, 1
aug2 = icarfreq + aug1
aug3 oscili kug4, aug2, 1
out aug3
endin
```

The score file begins with the sine wave table definition. A sine wave can be created using Csound’s "gen 10" function. Wave table "f1" is defined to be created at time 0 (so it is available for use right away), with a length of 1024 points (an adequate size in this case), using "gen" function number 10 to generate a single partial (a fundamental sine wave):

```f1 0 1024 10 1```

Chowning’s text specifies the parameters to be used for brass-like tones. These are used to play a note on the instrument:

```csound
;i1 start dur amp carfreq modfreq modindex1 modindex2

i1 0 0.6 10000 440 440 0 5
```

If the input parameters are modified and the envelope function is changed to an exponential decay, the same basic instrument design can be used to create other types of sounds. Here is the modified instrument definition for Chowning’s bell-like sound:

```csound
instr 2
idur = p3
iamp = p4
icarfreq = p5
imodfreq = p6
imodindex1 = p7
imodindex2 = p8
idev1 = p7 * p6
idev2 = (p8 - p7) * p6

kbellenv expon 1, idur, .000001 ;expon can go close but not

; all the way to zero

kug4 = iamp * kbellenv
kug5 = idev2 * kbellenv
kug6 = idev1 + kug5
aug1 oscili kug6, imodfreq, 1
aug2 = icarfreq + aug1
aug3 oscili kug4, aug2, 1
out aug3
endin

; These are the note parameters for the sound:

;i2 start dur amp carfreq modfreq modindex1 modindex2

i2 0 15 10000 200 280 0 10
```

## Using MIDI Input in Csound

Csound can accept MIDI from a live input or a standard MIDI file and use it to play instruments in the orchestra. There are two ways to use MIDI file input with Csound. One is to use the MIDI-to-Csound program to convert a standard MIDI file into a score file. The other is to use special commands in the instrument definitions which accept MIDI input. The first method allows for faster processing. The second method allows for more versatility in that continuous controllers can be used in the instrument definitions.

To use the MIDI-to-Csound program, first create and save a MIDI sequence as a standard MIDI file. When you run MIDI-to-Csound, you must first set up the parameter mapping information. The program provides a self-explanatory dialog box for assigning MIDI information to p-fields in a Csound score. Each of the sixteen channels can be assigned to a Csound instrument, or patch changes can be used to select the instruments. MIDI note and controller information can be assigned to p4 through p7. It is customary to set p4 equal to MIDI velocity and p5 equal to MIDI pitch. The program automatically assigns p2 as the note starting time and p3 as the duration.

After setting up the parameter map, you can open and convert a standard MIDI file. The program will output a standard Csound score text file. To this file, you can add other information as needed. Mainly, you will probably need to add f-statements for wave tables.

Since MIDI-to-Csound simply places MIDI values in the p-fields, your instruments must convert these values to more useful quantities. Here is an example of an instrument which plays an oscillator using MIDI notes. It assumes that p4 was assigned to MIDI velocity and p5 was assigned to MIDI Pitch. A velocity from 0-127 is converted to an amplitude range of 0 to 10000. A pitch from 0-127 is converted to "octave point decimal" (or "oct") format, where middle C (MIDI note 60) equals 8.00. Then, the oct value is converted to frequency in cycles per second ("cps" format) using the "cpsoct" command.

```csound
instr 1
idur = p3 ;duration is set automatically in p3
iamp = p4 * 10000 / 127 ;convert 0-127 to 0-10000
ifreq = cpsoct(p5 / 12 + 3) ;convert 0-127 to cycles per second
anote oscili iamp, ifreq, 1 ;play an oscil with the note
out anote
endin
```

To get MIDI file input directly into Csound, you must use MIDI input commands in the instrument definitions of the orchestra file. The score file will contain lines to activate each instrument, but the instruments will be played and controlled by MIDI information. The startup dialog box for Csound has an option for selecting the standard MIDI file to be used.

Here is an example instrument which uses direct MIDI input. This instrument gets notes from MIDI and converts note number to frequency. Amplitude comes from velocity and is converted to a range of 0-10000. It also gets continuous pitch bend data and scales it to a range of 0-1. This is used to bend the pitch in the positive direction up to an octave.

```csound
instr 1
iamp ampmidi 10000 ;get velocity, scale to 0-10000
ifreq cpsmidi ;get note number in cps
kbend pchbend 1 ;get pitch bend, scale to 0-1
knewfreq = ifreq + ifreq * kbend ;compute new freq with pitch bend
anote oscili iamp, knewfreq, 1
out anote
endin
```

The score file contains a wave table for the oscillator and a line to activate the instrument for 60 seconds. The instrument will then wait for notes to come from the MIDI file.

```csound
;a sine wave ftable
f1 0 4096 10 1

;activate for 60 seconds, wait for MIDI
i1 0 60
```

## Bibliography

- Borin, G., De Poli, G., and Sarti, A. "Algorithms and Structures for Synthesis Using Physical Models," Computer Music Journal , vol. 16, no. 4, 1992
- Chowning, John, and David Bristow, FM Theory & Applications: By Musicians for Musicians, Tokyo: Yamaha Music Foundation, 1986
- Chowning, John M., "The Synthesis of Complex Audio Spectra by Means of Frequency Modulation," Journal of the Audio Engineering Society, 21(7), 1973
- Dodge, Charles and Thomas A. Jerse, Computer Music: Synthesis, Composition, and Performance, New York: Schirmer Books, 1985
- Dolson, Mark, "The Phase Vocoder: A Tutorial," Computer Music Journal , vol. 10, no. 4, 1986
- Hiller, Lejaren A., Experimental Music, New York: McGraw-Hill, 1959
- Karplus, R., and A. Strong, "Digital Synthesis of Plucked String and Drum Timbres," Computer Music Journal, vol.7, no.2, 1983
- Mathews, Max V., et. al., The Technology of Computer Music, Cambridge, Mass: M.I.T. Press, 1969
- Mathews, Max V. and John R. Pierce, ed., Current Directions in Computer Music Research, Cambridge, MA: MIT Press, 1989
- Moore, F. Richard, Elements of Computer Music, Englewood Cliffs, NJ: Prentice Hall, 1990
- Pierce, John R., The Science of Musical Sound, New York: Freeman, 1992
- Roads, Curtis, "Physical Modeling: The History of Digital Simulations of Acoustic Instruments," Keyboard Magazine, Sept. 1994
- Roads, Curtis, ed., The Music Machine, Cambridge, Mass: MIT Press, 1989
- Risset, Jean-Claude, An Introductory Catalogue of Computer-Synthesized Sound, Murray Hil, NJ: Bell Telephone Laboratories, 1969
- Risset, Jean-Claude, and M. V. Mathews, "Analysis of musical instrument tones, " Physics Today 22(2), 1969
- Roads, Curtis and John Strawn (editors), Foundations of Computer Music, Cambridge, Mass: MIT Press, 1988
- Vercoe, Barry L. et al, Csound Manual, ©1986, 1992 Massachusetts Institute of Technology
