# Ch 39 Csound SuperSampler / Sequencer

Dr. James Mobberley

Like many composers, I came to Csound directly from work with digital synthesizers, samplers, and sequencers. I also, like many composers, saw immediately that there were many advantages to csound over these separate units. First, everything was in one box. Second, and more important, every single note event in csound could be sculpted individually with great precision. Unlike standard sequencers, each csound "note" could have its own individual envelope, pitch contour, timbre, spatial placement, reverberance, and duration. Most of these parameters are definable in standard sequencers but some are seriously restricted. For example, though each sound can have its own duration, all notes of a given voice will have the same, envelope, basic timbre, and lfo-defined pitch shape. For many purposes, sequencers which allow for 16 polyphonic voices are quite sufficient. But composers who might, for example, want to take fifty piano attacks of .2 seconds each, and string them together in a one-second collage, giving each a variety of glissando shapes and giving each a gradually sharpening attack would find themselves out of luck.

Much of my writing in the 1980s combined a solo live instrument with pre-recorded tape, and I had specialized in the use of the sounds of the solo instrument in making the tape part — creating a built-in timbral unity between soloist and tape. In 1992 I was commissioned by pianist Barry Hannigan to write a short work for piano and tape. By then I had had some experience with Csound, and I wanted to create this work using Csound to manipulate piano samples which I stored on our studio’s NeXT machine. I had used samples before with Csound, but only through the soundin unit generator, which does not allow pitch shifting of the samples. I was particularly interested in creating a "glissando-ing piano", since such things do not occur in nature.

In fact, what resulted was a Csound "Super Sampler/Sequencer". The orchestra allows the user to select pre-recorded individual mono soundfiles, choose a beginning and ending pitch level for each sound (automatically adjusting the resulting duration), set a volume level, select from a collection of user-defined envelopes, reverse the sound if desired, and set a simple panning shape for the sound in the stereo field of the output file.

The basic orchestra, which I called "sampenv", spent most of its time applying pitch shapes and envelopes to soundfiles, using genroutine 01 to read the samples from an existing soundfile into a table. The envelope creation and application takes a lot of space in the orchestra, but is exceptionally straightforward. I’ll begin the discussion with the pitch shaping, which is quite compact but requires some more extensive explanation.

Once they have been stored in a table, the samples from the soundfile can be read forward or backward, and at constant or varying speed. If the speed of the "tableread" is the same as the original file, then there is no pitch change. If it is faster, the pitch will be higher (and the duration shorter); if slower, the pitch will be lower (and the duration longer). If the speed changes over the course of the resulting note, then the sound will glissando from the start speed to the end speed. It works exactly like a tape deck, though the amount of control is exceptionally precise.

The challenge was to set up the math in the orchestra such that the values in score p-fields could be as musically intuitive as possible, yet produce predictable results. My solution was to set up three p-fields. The first controls the initial pitch of the resulting soundfile, the second defines the number of divisions of the octave, and the last controls the final pitch of the file. Examples:

p4 p5 p6 translation

- 0 any # 0 start with no change of pitch, end with no change (original pitch)
- -12 12 12 start one octave below original pitch, end one octave above
- 1 12 -1 start one well-tempered semitone above original pitch, end one semitone below
- 5 31 9 using 31-tone equal temperament, start 5 "steps" above original, end 9 "steps" above
- -8 1 8 using one-note-per-octave equal temperament, start 8 octaves below original, end 8 above

This apparatus does not allow for pitch shapes more sophisticated than simple unidirectional glissandi, but notes can be grouped in succession in the scorefile to create all sorts of shapes. NOTE: the mathematical conversions that determine the duration of the resulting pitch-shifted soundfile were provided by James Beauchamp of the University of Illinois. An understanding of the math is not necessary for the use of this orchestra.

The next section of the orchestra applies volume and envelope shapes to the pitch-shifted soundfile. Since recorded soundfiles are often of widely varying dynamic level, the process of reading the samples into the table automatically normalizes the amplitude levels from zero (softest) to one (loudest). With our NeXT workstation, the maximum amplitude capacity of the resulting soundfile output is 32767, so I selected a basic working amplitude multiplier of 3000, meaning that if I do not alter the amplitude of a note, it will have a maximum amplitude of 3000. I then set up p7 as a volume multiplier, with "1" being unity and other numbers increasing or decreasing the maximum amplitude of the note. For example:

p7 translation

- 1 maxamps for this note will be 3000
- .5 maxamps for this note will be 1500
- 4 maxamps for this note will be 12,000

It might seem logical to assume that if each note of an eleven-note "chord" is given a multiplier of one, the resulting soundfile will have a maxamp value of 33,000, which exceeds the amplitude capacity of the system, but in fact the maxamp points of each of the component notes rarely coincide. It would be more reasonable to expect that an eleven-note chord might top out at 12,000 - 20,000 maxamps. I have found 3000 to be a very reasonable working figure that rarely produces amplitudes in excess of 32767. Composers should experiment with various multipliers depending on their particular needs and systems.

Once a basic volume level is set, the orchestra allows any number of envelope shapes to be constructed. I have created seven, each of which begins and ends at zero to avoid clicks. P8 controls which envelope is selected:

p8 translation

- 1 choose envelope #1
- 6 choose envelope #6

The seven envelopes in my orchestra include:

1. "noclick" linseg 0,.01,p7,p3-.02,p7,.01,0
1. (start at 0, take .01" to rise to p7, stay at p7 for p3-.02", take .01" to fall to 0)
1. "taper" linseg 0,.01,p7,(p3*.75)-.01,p7,p3*.25,0
1. (start at 0, take .01" to rise to p7, stay at p7 for (p3*.75)-.01, take p3*.25 to fall to 0)
1. "hairpin" linseg 0,p3*.5,p7,p3*.5,0
1. (start at 0, take p3*.5 to rise to p7, take p3*.5 to fall to 0)
1. "cresc" linseg 0,p3-.01,p7,.01,0  .. etc ...
1. "dim" linseg 0,.01,p7,p3-.01,0
1. "cresctaper" linseg 0,p3*.95,p7,p3*.05,0
1. "rampdim" linseg 0,p3*.05,p7,p3*.95,0

Other, more complicated envelopes can be created in an orchestra, or these seven simple envelopes can be applied to consecutive notes in a score to simulate more complicated single-note envelopes. I have had significant success creating complicated textures by amassing a large number of notes, each of which has a hairpin envelope. Also, by overlapping hairpins consecutively, one can simulate a much longer note than a single stored sample would permit. For example, a single 4" sample can be used with a hairpin envelope. At time = 2", when the maximum point of the hairpin is reached, a second identical note can begin, also with a hairpin. By adding additional notes, each starting two seconds later than the last, the note can be sustained indefinitely at the same basic volume level. The result will have a "phased" sound, and will have a noticeable repetitive quality with a two-second "period", but will be less choppy than most sample loops. Multiple versions of these "extended notes" can be used, which will further obscure any sense of predictable repetition.

Next, the user chooses whether to keep the original sample order or to reverse the order, which will cause the soundfile to be heard backwards. I have used p11 for this, and set up a conditional that selects reverse order only if the p11 value is "-1". Any other value produces a forward read.

Finally, as the mono sound is sent to the outputs, the orchestra pans the sound to a particular location in the stereo field of the 2-channel output. The simplest way to do this is to reduce the amplitude of the sound by one percentage in the first (left) output, and by its complement in the second (right) output. For example, sending the sound out at 25% amplitude in the left channel and 75% in the right creates a stereo placement of halfway between center and right. Similarly, 50% and 50% creates a center pan, while 0% and 100% creates a total right-speaker pan. For this orchestra, I am using a slightly more sophisticated, but still simple panning procedure that allows not only single-point placement but also a linear movement of each sound from one point to another during the duration of the sound. By creating a 3-variable linseg whose first (p9) and last (p10) values are numbers between 0 and 1, and whose middle value is p3, a simple multiplication of this linseg to the left channel (kpan) and its inverse to the right channel (1-kpan) will produce a linear pan-shift that can be unique for each sound. For example:

p9 p10 translation

- .5 .5 this sound is panned center from beginning to end
- 0 0 this sound is panned full-left from beginning to end
- .75 .75 this sound is panned half-right from beginning to end
- 0 1 this sound begins panned full-left and shifts linearly to full-right during the sound
- 1 .5 this sound begins panned full-right and shifts linearly to center during the sound
- .25 .75 this sound begins half-left and shifts linearly to half-right during the sound

* * * * * * * * * * * *

Below is the complete orchestra. Semicolons separate actual orchestra code from comments. Actual code is also in italics for ease of reading. NOTE: newer unit generators, like loscil, can make much of this orchestra easier to manage.

```csound
;"sampenv.orc"
;PART I. Header
;this header sets up a stereo output at a standard 44.1K rate

sr=44100
kr=441
ksmps=100
nchnls=2

;PART II. Instr and I-statements

instr 1 ;this orchestra takes mono sample files and arranges them in a stereo
;output file, with control available over the pitch, volume,
;envelope shape, direction of table read (b/f), and pan
i1 = p3 ;i3 is used as a place to keep the duration of original soundfile,
;since p3 will change due to the pitch shift (if any)
i2 = 1/p3 ;period of original soundfile
i3 = exp(log(2)*p4/p6) ;converts starting pitch info (p4) to a multiplier (i4)
i4 = exp(log(2)*p5/p6) ;converts ending pitch info (p5) to a multiplier (i5)

;PART III. Choose either simple pitch shifting or a glissando, and converting pitch alteration information
; to a multiplier that will affect the speed of the table read (and hence the perceived pitch
; of the resulting sound)

if p4 = p5 goto nondiv ; in cases where there is a simple pitch shift without a glissando, the
;calculations for a glissando will produce "division by zero",
;which will kill the perf…this conditional checks for this and
;calculates the pitch shift in a different way, avoiding division
;by zero
goto rest ;if there is a gliss (if p4 and p5 are not identical, skip the nondiv section)
nondiv: i5 = (p4+p5)/2 ;determine a pitch change value (i5) for non-glissing notes
i6 = 1/(exp(log(2)*i5/p6)) ;create a value, based on the amount of pitch change, to determine
;the resulting duration of the pitch-shifted note
goto dur ;skip the calculation step for glissing notes
rest: i6 = log(i4/i3)/(i4 - i3) ; create a value, based on the start- and end-points of the glissando, to
;determine the resulting duration of the glissed note

;PART IV. Change the duration and volume of the resulting sound, and set up the possible envelopes for
;later use

dur: p3 = i1*i6 ;apply the i6 value to the original p3 to create the new p3 (resulting
;duration)
p7 = p7*3000 ;raises normalized (zero to one) amplitude range to zero to 3000

kenv1 linseg 0,.01,p7,p3-.02,p7,.01,0 ;noclick envelope
kenv2 linseg 0,.01,p7,(p3*.75)-.01,p7,p3*.25,0 ;taper envelope
kenv3 linseg 0,p3*.5,p7,p3*.5,0 ;hairpin envelope
kenv4 linseg 0,p3-.01,p7,.01,0 ;cresc envelope
kenv5 linseg 0,.01,p7,p3-.01,0 ;dim envelope
kenv6 linseg 0,p3*.95,p7,p3*.05,0 ;cresctaper envelope
kenv7 linseg 0,p3*.05,p7,p3*.95,0 ;rampdim envelope

;PART V. The phasor unit generator is designed to produce a value that moves linearly from zero to
;one. The input to the phasor is an expseg that represents an exponential "bending"
;of that linear motion. When this "bent" phasor is used to determine the speed of the
;table read, it is an effective translation of the pitch change information in p4, p5, and
;p6 into pitch shifting and/or a glissando. By inverting the phasor output, the "bent" read
;happens backwards, or from last sample to first.

a1 expseg i2*i3,p3,i2*i4 ;apply pitch change information to an exponential line segment
a1 phasor a1 ;use the pitch change information to create a distorted line that
;moves from zero to one
if p12 = -1 goto revrse ;skip normal table read, go to reverse table read
goto table ;skip reverse table read, go to normal table read
revrse: a1 = 1 - a1 ;reverse the distorted line so that it moves from one to zero
table: a2 tablei a1*(sr*i1),p11 ;place the samples from the selected soundfile (p11) into a table.

;Since a1 goes from zero to one (if read forwards) or one
;to zero (if read backwards), multiplying a1 times the sample
;rate times the original duration of the soundfile produces a
;table that runs from the zeroth sample in the file to the last (if
;read forward) or from the last sample to the zeroth (if read
;backwards). Again, the "bending" the line receives from the
;pitch change information that has been applied to the expseg
;creates continuous changes in the rate of speed that the table
;is read, and hence creates analogous changes in the resulting
;pitch of the sample playback.

;PART VI. Apply the selected envelope to the sound via a set of conditionals and simple multipliers.

if p8 = 1 gotonoclick
if p8 = 2 gototaper
if p8 = 3 gotohairpin
if p8 = 4 gotocresc
if p8 = 5 gotodim
if p8 = 6 gotocresctaper
if p8 = 7 gotorampdim

a2 = a2*p7: goto pan
noclick: a2 = a2*kenv1: goto pan
taper: a2 = a2*kenv2: goto pan
hairpin: a2 = a2*kenv3: goto pan
cresc: a2 = a2*kenv4: goto pan
dim: a2 = a2*kenv5: goto pan
cresctaper: a2 = a2*kenv6: goto pan
rampdim: a2 = a2*kenv7

;PART VII. Separate the mono sample into two independent outputs, applying panning information
;(via simple inversion) to each, then end the instrument.

pan: kpan linseg p9,p3,p10
outs1 a2*(1-kpan)
outs2 a2*kpan
endin

; Here is a sample scorefile, with explanations.
;piano1.sco

;tablesizes — this is a reminder list showing the minimum table size required with various soundfile durations
;8193 up to .185 65537 .74304 - 1.486
;16385 .19 - .3715 131073 1.4861 - 2.971
;32769 .372 - .743 262145 2.972 - 5.9442
;f-table start tblsz gen# tag# skiptime format filename (orig dur)
f1 0 32769 1 3 0 4 ;short C1 (.64")

;this is a staccato C below the bass staff, and the tablesize (32769) matches the duration range
;listed above (.64" lies between .372 and .743). The tag number is the NeXT equivalent of a
;soundin number for the soundfile.
f2 0 131073 1 5 0 4 ;plucked C6 (2.49")

;this is a plucked piano string 3 octaves above middle C which lasts 2.49 seconds
f3 0 16385 1 2 0 4 ;tap (.21")
;this is a tap on the keyboard cover, lasting only .21 seconds

;instr 1 (sampenv) p4 p5 p6 p7 p8 p9 p10 p11 p12
; start dur glsbeg glsend incr vol kenv panbeg panend ftable rev(-1)
i1 0 .21 -24 -24 12 1 3 .5 .5 3 0

;start with a tap sound, two octaves lower than original, panned center
i1 0 2.49 0 .2 12 .9 6 .5 1 2 -1
i1 .5 2.49 0 -.2 12 1.2 6 .5 .01 2 -1
i1 .9 2.49 0 .3 12 1.6 6 .5 1 2 -1
i1 1.2 2.49 0 -.3 12 2.2 6 .5 .01 2 -1
i1 1.4 2.49 0 .5 12 3 6 .5 1 2 -1
i1 1.5 2.49 0 -.5 12 4 6 .5 .01 2 -1

;create a series of reversed high string plucks that crescendo…each entrance gets closer to the
;previous entrance, each is louder than the previous, each strays further and further from the
;original pitch during its duration (alternating up and down) than the previous, and each
;begins at center and deviates to alternating pan extremes

i1 4 .64 59.5 59.5 12 6 2 .01 .01 1 0

;use a low staccato piano note shifted up nearly five octaves to place a loud, extremely short note
;on the end of the last reversed pluck…though the starting duration of the staccato note is
;.64", the five-octave pitch shift causes the resulting duration to be about .02"

```