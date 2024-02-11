# Csound For Artists

BUILDING UNIQUE VIRTUAL INSTRUMENTS FOR YOUR COMPOSITIONS
by Roger King

Antonio Stradivari perfected the art of making bowed string instruments by the 1690’s. He perfected the placement of f-holes, bass bars, and sound posts, for example. And, by doing so, Stradivari harmonically enriched the sound waves a string instrument produces when played.

With the standardization of orchestral instruments came a plethora of composers who could write music for each member of the timbre family. The group of instruments necessary for the playing of symphonies increased over time. Mozart’s seventeen instrument orchestra would have been acoustically drowned by the magnitude of Mahler’s.

Yet, any famous composer of the past would have been stunned by the capabilities of Csound. Imagine even a modern composer such as Olivier Messiaen sampling birdsong in the wild, importing their waves into Csound using loscil and morphing them with gamelan sounds. He would have rejoiced at the sheer enormity of timbral possibilities available to composers who master the Csound programming language.

Consequently, composers of the 1990’s, three hundred years after Stradivari, can build virtual instruments on the same device they use to compose and notate. The sounds of virtual musical instruments is now of equal symbolic import to the musical idea expressed in the composition.

Most Csound programmers begin with analog synthesis: they are told to use oscil, buzz, or even fof, for example. Composers should begin learning Csound by experimenting with loscil.

Loscil reads a sound file and allows you to use the sound as a musical instrument. So, a composer can record an interesting sound, import it into a musical work, and even transform the sound in various stages of play. This is much more than mere digital sampling. Csound’s loscil is a key to building immensely complex musical performances. Entire groups of unique instruments can be grouped to play superhuman performances.

Loscil is also one of the easiest Csound functions to program. Getting just the right response, however, can be hard work.

```ar1 [,ar2] loscil```

If the sound file you call into your instrument file is monophonic, then you only need one signal name placed before loscil. Otherwise, two signal designations can be used, allowing you to split their output:

```asignal1, asignal2 loscil xamp,```

xamp is the variable name of amplitude. If you want a percussive volume envelope you would perhaps write the following statement above the loscil signal statement:

```amp line 10000,p3,0 ; p3 is the duration passed from the .sco file```

```asignal1,asignal2 loscil amp, kcps,```

kcps tells the instrument what pitch to play at that amplitude:

```csound
kcps=cpspch(p4) ; p4 is the pitch value passed from the .sco file

amp line 10000,p3,0 ; p3 is the duration passed from the .sco file

asignal1,asignal2 loscil amp, kcps, ifn,
```

ifn is the variable value of the desired function table in the .sco file. For example, your score file (.sco) begins with a function table that describes the soundwave your instrument plays. Since you’re importing a sound you digitally recorded (sampled), the function table in your score file could look like this...

```csound
f1 0 0 1 "c:\csound\kazoo.wav" 0 4 1
f2 0 0 1 "c:\csound\rattle.aiff" 0 4 1
```

The .sco and .orc files pass variable information back and forth to each other at compile time. The ifn variable in the .orc file points

out which f-statement in the .sco file the instrument requires. In the above f-statements, ifn could point to either a sound wave made from a kazoo (f1) or a baby’s rattle (f2).

```csound
ifn  = p5           ; the parameter of variable stored sounds
kcps = cpspch(p4)   ; p4 is the pitch value passed from the .sco file
amp line 10000,p3,0 ; p3 is the duration passed from the .sco file
asignal1,asignal2 loscil amp, kcps, ifn,
```

You can designate the f-statement variable value from inside your composition. If you write a note-on in your score file similar to...

```csound
;p1 p2 p3   p4   p5 p6
i1  0  1    8.04 90 1
i1  0  .25 11.04 79 2
i1 .25 .25 11.04 79 2
i1 .25 .25 11.04 79 2
i1 .25 .25 11.04 79 2
```

Two separate samples, one melodic and one percussive, can be used inside the same instrument. The p6 parameter in the score file tells the instrument to request one of the two available samples. The instrument does as the maestro requests, passing the number back to the score file and its f-statement.

If you wanted instead to morph the two samples into one musical instrument you would merely add another loscil statement to the instrument:

```csound
instr 1
kcps=cpspch(p4) ; p4 is the pitch value passed from the .sco file
amp line 10000,p3,0 ; p3 is the duration passed from the .sco file
asignal1,asignal2 loscil amp, kcps, 1,
asignal3,asignal4 loscil amp, kcps, 2,
outs asignal1+asignal3,asignal2 + asignal4
endin
```

The instr , outs, and endin statements are crucial to whether or not your code compiles.

By adding the two sound files together you commence the attempt at morphing their characteristics. What you need to do next depends on how the sound files were sampled, and how you want Csound to morph their qualities.

```ifn[, ibas][, imod1,ibeg1,iend1][, imod2,ibeg2,iend2]```

The above segment of the loscil signal statement influences the outcome of the compiled sound. Let’s start with f1...

1, 392, 1, 1, 5000

- says to use for sound wave reference the file found in f1;
- with a base frequency of 392 cps (the G below middle C);

using a regular loop mode, beginning at the first sample in the file and ending at the 5000th before going back to the start for the next loop.

So, if you add that to instr 1 it looks like...

```csound
sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2

instr 1
kcps = cpspch(p4)     ; p4 is the pitch value passed from the .sco file
amp line 10000, p3, 0 ; p3 is the duration passed from the .sco file
asignal1, asignal2 loscil amp, kcps, 1, 392, 1, 1, 5000
asignal3, asignal4 loscil amp, kcps, 2, 1760, 1, 1, 5000
outs asignal1 + asignal3, asignal2 + asignal4
endin
```

Please note the file header at the top. I like to produce a sound file at the same rate as the samples I import. That saves a lot of headache.

You might not have a kazoo to sample. You my actually own a Strad violin and wish to morph it’s sound with that of a pet German roller canary. In that case, you would sample your fiddle and coax a brief song from the canary. Then, play the sound in your editing software. Cut the wave of each sample down to fairly describe the wave to the Csound compiler without taxing all of your computer’s RAM. Then begin experimenting with Csound code until you have something which more perfectly professes the meaning of your musical idea.

Use your sound editing software to trim the sample. Use only the portion of the sample with best wave form. Csound will then be able to loop the wave, allowing you to play longer notes.

## Power Up Your Workbench for Analog Synthesis

Csound allows you to produce entire musical orchestras and scores. You have complete control over the four forces of musical nature: rhythm, melody, harmony, and timbre. You also have the added power of choosing from the various aspects of sound: frequency, amplitude, and wave forms, for instance. You need a system set-up conducive to simplifying the complexities of the production process.

You compile two text files at the same time to create one digital sound file. One text file, referred to as .sco, contains information about the musical aspects of your project. The other text file, .orc, conveys information to your system about the virtual instruments. The resulting sound file is called Test.

By compiling the following two code examples you can begin to see how to mate a composition with audio.

```csound
;this is the code for a .sco file

f1 0 1024 10 10 3 5 3 5 3 4 2 4 2 3 1 ; a sine wave function
t 0 120 ; a tempo statement
;p1 p2 p3 ; parameters
i1 0 1 ; this is an i-statement…the note-on, note-off procedure
e means "end"
```

The above example shows a score file that says,

"Play a sine wave for half a second."

Next, you need an orchestra to play this brief sine wave.

```csound
; This is the code of an .orc file
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2

; the above is a "header" telling the system that the sample rate
; of the audio is 44100, the control rate is 4410, the number of
; samples per sample time is 10, and there are two channels out.

instr 1

; the instrument statement is necessary for compiling.
; you can build orchestra files with as many as 200 instruments
; Gustav Mahler would have been very jealous of such a feature.

asig oscil ampdbl(90), cpspch(9.00),1
; the signal statement says to oscillate the sine wave, found in table 1
; of the score file, at middle C, at an amplitude of 90 decibels.

outs asig,asig

; says to output the same signal to each channel for
; review in stereo
endin

; the last statement of each instrument in an .orc file must be
; endin, or else you’ll get an error at compile time.
```

Once you compile, you essentially record. In this era of digital hard disk recording, you are creating sound, storing its characteristics in digital format, and performing music with its instrument. If you compile Csound you may place the title "record producer" under your name on your calling card.

## Yes…You Are A Record Producer

The minute your code compiles you have recorded sound and are thus a record producer. Record producers equip an area with objects used for sound recording. With Csound there’s no need for spending big money on sound equipment. Instead, you need only develop a cozy software development environment on your computer. Whatever suites your tastes and makes your coding a pleasant process will do just fine: Even the substitution of cute screen savers for actual lobby groupies.

## Multitasking & The Csound Developing Environment

Csound programming begins with the set-up of a development environment. It helps to have a text editor that can cut and paste to files or areas other than the one currently open. The ability to multitask greatly accelerates the creative process of producing with Csound. Also, there are sound editing and Fourier Transform software packages that add great efficiency to debugging.

## Where To Begin

You could spray paint a line going across a brick wall and have made a musical score. Csound’s canvas is the space-time continuum of the amount of storage space available. The storage media can be viewed as the modern version of magnetic tape or artist canvas. You can literally paint your canvas with sound, music, special effects, and enhancements.
Beethoven Had Rough Beginnings

Have you ever seen a picture of an original notated score by the great Ludwig Van Beethoven? Page after page contain scratch outs of ideas he wanted to change. The important thing to remember: Beethoven corrected and perfected. Thus, don’t be ashamed if you have to take extra time to debug your code. Every time you debug you learn how unlimited your compositional possibilities can be if you code by the rules.

outs asignal1, asignal2
endin

Now we know that we need two signals, both of which will be given stereo presentation.

```csound
asignal1 oscil kamp1,cpspch(p4),1
asignal2 oscil kamp2, cpspch(p4)*1.4987,2
outs asignal1, asignal2
endin
```

Here you get brutally introduced to the concept of control variables.

Kamp1 and kamp2 will be our amplitude envelope plug-in variables. They’ll shape the output of the sound wave. Transformation by a major fifth will be the duty of asignal2, as it boldly multiplies the pitch by 1.4987. Also, asignal2 will use the score file’s second function table, and hence a different shaped wave.


```csound
instr 1
kamp1 line ampdb(p5), p3, 0
kamp2 line 0, p3, ampdb(p5)
asignal1 oscil kamp1, cpspch(p4), 1
asignal2 oscil kamp2, cpspch(p4) * 1.4987, 2
outs asignal1, asignal2
endin
```

The kamp1 and kamp2 control variables are complete opposites.

Number one starts off strong and fades over the duration of the note.

Number two commences in silence and grows to its maximum designated potential over the scored note duration. Also, the instr 1 statement has been added. Keep in mind that you can have as many as 200 instruments in an orchestra. Without including the instr statement, however, you will not compile your code.

On top of your instrument you must put a header, since the output is in the format of stereo. Consequently, the entire example .orc file consists of the following file.

```csound
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2

instr 1
kamp1 line ampdb(p5),p3,0
kamp2 line 0,p3,ampdb(p5)
asignal1 oscil kamp1,cpspch(p4),1
asignal2 oscil kamp2, cpspch(p4)*1.4987,2
outs asignal1, asignal2
endin
```

Now, you may endeavor to build a formidable .sco file. Some people use a shareware package called Midi2Csound to convert their .mid compositions to score files. The registered, $50 version, is the only one this author recommends. The version available for download lacks in features.

## Csound As Metronome

Sometimes you may just want to invent instruments and then see how well they play your established repertoire. Recently, I was experimenting with "buzz" and "reson" and came up with something weird, so I went with it. I called it the Ang Generator:

sr=44100
kr=4410
ksmps=10
nchnls=1

instr 6
;ang generator
i1 = ampdb(p5)
k1 = i1/20
a1 buzz k1, cpspch(p4)*2, 2, 1
a2 buzz k1, cpspch(p4)*1.8885, 3, 1
a3 buzz k1, cpspch(p4), 4, 1
a4 buzz k1, cpspch(p4), 5, 1
a4d delay a4, .1, 0
a5 buzz k1, cpspch(p4), 7, 1
a5d delay a5, .2, 0
asig = a1 + a2 + a3 + a4 + a5 + a4d + a5d
af1 reson asig, cpspch(p4), 20, 1, 64
af2 reson asig, cpspch(p4), 200, 1, 64
af3 reson asig, cpspch(p4), 2, 1, 64
af4 reson asig, cpspch(p4), .2, 1, 64
aout = af1 + af2 + af3 + af4
out aout
endin

Here is a score to compile the Ang Generator:

f1 0 8192 10 10 0 10 0 10 0 10 0 10 0
t 0 140
i6 .5 .5 10.07 85
i6 1.5 . . .
i6 2.5 . . .
i6 3.5 . . .
i6 4.5 . . .
i6 5.5 . . .
i6 6.5 . . .
i6 7.5 . . .
i6 0 .5 5.07 85
i6 2 . 5.07 85
i6 2.5 . 5.07 85
i6 3.5 .25 5.07 85
i6 4 . 5.07 85
i6 6 . 5.07 85
i6 6.5 .5 5.07 85
i6 1 .5 8.07 98
i6 1.75 .25 8.07 98
i6 3.75 .25 8.07 98
i6 5   .5 8.07 98
i6 7 . 8.07 98
i6 1 .5 8.07 98
i6 1.75 .25 8.07 98
i6 3.75 .25 8.07 98
i6 5 .5 8.07 98
i6 7 . 8.07 98
i6 0 1 8.07 75
i6 1 . 8.11 79
i6 2 . 9.02 70
i6 3 . 9.05 70
i6 4 . 10.00 75
i6 5 . 10.02 70
i6 6 . 10.07 70
i6 7 . 11.00 70
i6 0 1 6.07 75
i6 1 . 6.11 79
i6 2 . 7.02 70
i6 3 . 7.05 70
i6 4 . 8.00 75
i6 5 . 8.02 70
i6 6 . 8.07 70
i6 7 . 9.00 70
i6 0 .5 7.07 75
i6 .5 . 7.11 75
i6 1 . 8.02 75
i6 1.5 . 8.05 75
i6 2 .5 9.00 75
i6 2.5 . 9.02 75
i6 3 . 9.07 75
i6 3.5 . 9.04 75
i6 4 .5 7.07 75
i6 4.5 . 7.11 75
i6 5 . 8.02 75
i6 5.5 . 8.05 75
i6 6 .5 9.00 75
i6 6.5 . 9.02 75
i6 7 . 9.07 75
i6 7.5 . 9.09 75
i6 0 .25 9.07 78
i6 .25 . 9.11 80
i6 .5 . 10.02 80
i6 .75 . 10.05 80
i6 1 .25 11.00 80
i6 1.25 . 11.02 80
i6 1.5 . 11.07 80
i6 1.75 . 11.11 80
i6 2 . 9.07 80
i6 2.25 . 9.11 80
i6 2.5 . 10.02 80
i6 2.75 . 10.07 80
i6 3 .25 11.11 80
i6 3.25 . 11.02 80
i6 3.5 . 11.07 80
i6 3.75 . 11.11 .
i6 4 .25 9.07 .
i6 4.25 . 9.11 .
i6 4.5 . 10.02 .
i6 4.75 . 10.00 .
i6 5    .25  11.00 .
i6 5.25 .    11.02 .
i6 5.5  .    11.05 .
i6 5.75 .    11.07 .
e

Notice the instr number is six. You can have up to 200 instruments in an orchestra file. Build, test, cut, paste, and build another! Keep adding to your timbre pile.

One thing you may wonder about are samples out of range, and illegal this or that. A good rule of thumb is to listen to the compiled output. View the wave form on a graphic display, if you have a sound editor.

Two great things about the csound programming language, for

those who are new to it, are the random signal generator and

the ability to produce non-tempered scale tones.

The p4 values in the score file below were picked from the

classified ad department numbers of a newspaper.

You should notice the tempo statment is set at 30.

For fun, you can change that value to 60 and then adjust

the k1 variable controls in each instrument of the orc file.

From that one small set of oddball tones, all sorts of

music can be sculpted.

;orc file of 3 rand instruments
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2

instr 1
i4 = p4/100
i1 = octpch(i4)
k1 randh 1.5,20
kemp = p5*500
asig oscil kemp, cpsoct(i1+k1),1
outs1 asig
endin

instr 2
i4 = p4/100
i1 = octpch(i4)
k1 randh 1.5,10
kemp = p5*750
asig oscil kemp, cpsoct(i1+k1),1
outs2 asig
endin
instr 3
i4 = p4/100
i1 = octpch(i4)
k1 randh 1.5, 5
kemp = p5*1000
asig oscil kemp, cpsoct(i1+k1),1
outs asig, asig

endin


;sco file using a nontempered scale
f1 0 4096 10 3 5 3 5 2 4 2 3 1
t 0 30
i1 0 1 777 5
i1 1 1 489 7
i1 0 1 331 9
i1 1 1 612 5
i2 0 1 777 5
i2 1 1 489 7
i2 0 1 331 9
i2 1 1 612 5
i3 0 2 777 2
i3 1 1 489 4
i3 0 1 331 4
i3 1 1 612 2
e



Do I want to produce a sound effect or a musical piece?

You may be of the intention of producing sounds to bank in the memory of your sound card or synthesizer. Csound has immense power in this category. You can do midi music using stored sounds you built yourself.

The following code generates a sound, not a song.

;orc file code
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2

instr 1
i1=cpspch(p5)
if i1<=8.00 igoto counter2
if i1>8.00 igoto counter1
counter1:
k2 linseg cpspch(p5),0.25, cpspch(p6), 0.25,cpspch(p5)
asig1 oscil p4*95, k2,2
counter2:
k3 expseg cpspch(p6),0.25,cpspch(p5),0.25,cpspch(p6)
asig2 oscil p4*6.25, k3, 1
outs asig1,asig2
endin
;.sco file code
f1 0 2049 -12 20
f2 0 2049 +12 10
t 0 30
i1 0 1 70 8.00 9.00
i1 0 1 70 7.00 6.00
e

If you compile and listen you may be inclined to believe that Martians have landed and are taking control of your speakers.

Here, for the first time, you’re shown conditional operators. If i1 is greater than the C below middle C then igoto the label ‘counter1’. If you are of the programming legion you know that conditionals and logical operators can mean the difference between twenty instrument orchestras with a few sounds and one orchestra with nearly twenty sounds. The added power of conditionals exponentially expands the work a program can perform.

The data storage capabilities of personal computers evolved nearly exponentially in the past decade. It is now possible to record music directly to a hard disk or a recordable CD-ROM drive. What this means to the computer musician is the expansion of the audio canvas. To the Csound programmer, a tremendous door has opened. Audio files used to be too large for complete compositions to be created and stored. With the advent of the CD-ROM recorder, Csound code can achieve full potential.

What Do I Do With A Song I’ve Selected For Material?

Once you have an idea you should analyze its potential. Csound instruments can be very complex, often sounding like entire orchestras. So, just because a theme was originally intended for piano does not mean that you must do hours of Fourier Transforms or physical modeling of piano sounds. You’ll do much better with an invention of your own. In this way you are composer of both the notes and the sounds.

Break the score down into the musical forces of melody, rhythm, and harmony. Next, put on your producer’s hat and consider timbre: what kinds of sounds or noises would best communicate the song’s information? If you come from a musical tradition, your mind has been programmed to think in terms of wind, brass, string, and percussion timbres. You have permission to throw all of that away. Whatever you conceive within the physical laws of sound can be coded and compiled as a working musical instrument.

You can also throw most of traditional harmony overboard as well.

This century saw the rise of pioneers on the harmonic frontier. From W.C. Handy to Arnold Schoenberg, composers expressing wrong notes. They became popular for the way those notes were used.

Melody, if your music needs one, can be varied using logical controls in your programming code. Csound can logically vary the entirety of a piece of music. Why just whistle Dixie when you can have a machine simultaneously whistle Dixie and many of its variations, and store the result in digital format?

Examine figure 1.01 and you’ll notice the i4 parameter values for frequency have been converted to Csound pitch values. In your .orc files you’ll be able to pass along information to manipulate the sound associated with each of those notes.

Notes occasionally shift in volume dynamics. A p5 parameter can designate the loudness or softness with which the note is expressed.

Exploring parameters and logical switches is necessary to become a better builder of virtual instruments.
PARAMETERS, SWITCHES, AND THOUGHT

outs a1,a2
endin

Above, beginning at the end of your next, and most complex, orchestra file, ask yourself a musical question.

After looking at a large cup of coffee at rest, you ask, " styrofoam?" White, light, absorbing, and not in your lifetime disintegrating: such a musical question asked of the musical forces returns values of harmonies modulating from C: The external forces, surrounding the issues of the objects political incorrectness, however, scream for a G minor.

The coffee in the cup you ponder. Signals generated in the instruments may be stimulating if allowed to enrich each note from the score file with buzzing sevenths, ninths, and suspended fourths.

As a boy aligns his toy soldiers for a battle or a roadie sets up your

equipment for a gig, you set up a template to build the imagined sounds.

Turn then to your principal musical instrument. Recall the keys selected to answer the question. Close your eyes and allow your fingers to describe in brief the situation.

When ready, write down in Csound what your fingers found true:

;the Mixolydian guilt, protest, and futility of styrofoam in the consciousness

i1 0 1 10.07 90 0
i1 1 1 10.05 84 0
i1 2 < 10.00 84 0
i1 3 .5 10.04 84 0
i1 3.5 . 10.05 84 0
i1 4 1 10.02 84 0
i1 5 > 9.11 84 0
i1 6 2 9.07 82 0

;the tonic rumbles in a wheel of sus4

i1 0 1 7.00 80 1
i1 .3 .5 7.07 90 1
i1 .7 . 7.05 80 1
i1 1 1 7.00 81 1
i1 1.3 .5 7.07 91 1
i1 1.7 . 7.05 80 1
i1 2 1 7.00 82 1
i1 2.3 .5 7.07 90 1
i1 2.7 . 7.05 83 1
i1 3 1 7.00 80 1
i1 3.3 .5 7.07 90 1
i1 3.7 . 7.05 81 1
i1 4 2 7.00 83 1
i1 5 1 7.07 90 1
i1 6 .33 7.05 80 1
i1 6.42 . 7.05 80 1
i1 6.75 . 7.05 80 1
i1 6.98 . 7.07 85 1
i1 7.48 .48 7.07 80 1

Now, return. Build the repression of the steam into the instrument. Styrofoam is forever. A combination of Chanting Monks and incessant percussion becomes part of the answer.

apoundl pluck kamp, kcps, icps, ifn, imeth [, iparm1, iparm2]
apoundr pluck kamp, kcps, icps, ifn, imeth [, iparm1, iparm2]
amonk1l fof xamp, xfund, xform, koct, kband, kris, kdur, kdec,iolaps, ifna, ifnb, itotdur
amonk2l fof xamp, xfund, xform, koct, kband, kris, kdur, kdec,iolaps, ifna, ifnb, itotdur
amonk1r fof xamp, xfund, xform, koct, kband, kris, kdur, kdec,iolaps, ifna, ifnb, itotdur
amonk2r fof xamp, xfund, xform, koct, kband, kris, kdur, kdec,iolaps, ifna, ifnb, itotdur
a9l oscil xamp, xcps, ifn
a7l oscil xamp, xcps, ifn
atl oscil xamp, xcps, ifn
a9r oscil xamp, xcps, ifn
a7r oscil xamp, xcps, ifn
atr oscil xamp, xcps, ifn
;all oscils will use a GEN 11 ifn for a buzzing effect
a1 = a9l+a7l+atl+apoundl+amonk1l+amonk2l
a2 = a9r+a7r+atr+apoundr+amonk1r+amonk2r
outs a1,a2
endin

What chant those Monks of styrofoam? What is repression expressed in the pound of percussion?

New questions demand a return to your compositional score.

;the Monks sing what they are conducted, yet they err.
; one path is a G minor chord and the other, C major.
; chant them soft and slow... and go deeper

i1 0 4.1 6.00 82 2
i1 0.03 3.9 6.04 81 2
i1 0.02 . 5.07 80 2
i1 0.04 . 4.11 79 2
i1 4 3.8 5.11 82 2
i1 4.01 3.97 6.07 81 2
i1 4.1 3.89 5.02 85 2
i1 4.05 3.92 6.11 80 2

;Drums offer a symbol of cardiac arhythmia. Though faint...

i1 0 1 5.00 90 3
i1 .5 . 4.07 90 4
i1 1 . 5.00 79 3
i1 1 . 4.07 79 4
i1 2 . > 78 3
i1 2 . 5.00 79 4
i1 3 . 4.07 78 3
i1 3 . 5.00 79 4
i1 4 . < 90 3
i1 4 . 4.07 90 4
i1 5 . 5.00 78 3
i1 5 . 4.07 79 4
i1 6 . > 78 3
i1 6 . 5.00 79 4
i1 7 . . 78 3
i1 7 . 4.07 79 4

Now this chorus pauses to review the score file’s parameters:

p1 is the instrument number
p2 is the time the instrument is turned on
p3 is the length of the note duration
p4 is the pitch
p5 is the amplitude in decibels
p6 will require the following paragraph to explain..

The sixth parameter is like a channel setting on your remote control. It’s numbers will logically send information only to places in the orchestra file you wish they go. For instance, a remote control value of 3 goes to the left side drum. A value of 4 sends the note request to the right side drum.

Building switches for remote controls may be your greatest asset as a virtual conductor. Remember how Gustav Mahler tested his compositions on his orchestra? Upon rewriting, he would with great frenzy wave his baton to get his orchestra to recognize changes in his score. With a Csound control switch, your instrument essentially acquires an algorithm to somewhat eliminate the need for frenzy.

One way to switch:

When designating the amplitude of the sound signal the instrument asks a question of the score. If the score responds with the value specific to the signal then volume is played in according to its designated envelope. Otherwise, the volume is kept completely at zero for the duration of the note.

Another way to switch:

According to the p6 integer, the score’s input passes to a label in the instrument. The label contains the appropriate signal generator.

```csound
sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2

instr 1
kamp = ampdb(p5)
k1 line 10000, p3, 0
k2 linen 10000, .002, p3, .003
kp1 = cpspch(p4)

thrust:
apoundl pluck (p6==3? k1 : 0), cpspch(p4), cpspch(p4), 1, 3, 1

foot:
apoundr pluck (p6==4? k1 : 0), cpspch(p4), cpspch(p4), 1, 4,1,3

tucan:
amonk1l fof (p6==2? kamp : 0), kp1, kp1,0, .047, .003,.02,.007,40,3,2,p3
amonk2l fof (p6==2? kamp : 0), kp1, kp1, 0, .048, .003,.02,.007,40,3,2, p3
amonk1r fof (p6==2? kamp : 0), kp1,kp1, 0, .049, .003, .02,.007,40,3,2, p3
amonk2r fof (p6==2? kamp : 0), kp1, kp1, 0, .05, .003,.02, .007,40,3,2, p3

zebra:
a9l oscil (p6==0?k2*.67:0), kp1*2.1225,4
a7l oscil (p6==0?k2*.33:0), kp1*1.8885,4
atl oscil (p6==0 ? k2 : 0), kp1,4
a9r oscil (p6==1?k2*.33:0), kp1*2.1225,4
a7r oscil (p6==1?k2*.67:0), kp1*1.8885,4
atr oscil (p6==1 ? k2 : 0), kp1,4
a1a=a9l+a7l+atl+apoundl+amonk1l+amonk2l
a2a=a9r+a7r+atr+apoundr+amonk1r+amonk2r
amodel oscil 12000,440,1
a1 balance a1a,amodel
a2 balance a2a,amodel
outs a1,a2
endin

;and the score file for styrofoam

f1 0 512 10 .5 .5 .5 .5 .5 .5 .5 .5 .5 .5
f2 0 512 19 .5 30 60 90 1
f3 0 4096 10 10 8 2 1 2
f4 0 8192 11 5 3 1
t  0 60
i1 0 1 10.07 90 0
i1 1 1 10.05 84 0
i1 1 2 10.00 84 0
i1 3 .5 10.04 84 0
i1 3.5 . 10.05 84 0
i1 4 1 10.02 84 0
i1 5 1.5 9.11 84 0
i1 6 2 9.07 82 0
i1 0 1 7.00 80 1
i1 .3 .5 7.07 90 1
i1 .7 . 7.05 80 1
i1 1 1 7.00 81 1
i1 1.3 .5 7.07 91 1
i1 1.7 . 7.05 80 1
i1 2 1 7.00 82 1
i1 2.3 .5 7.07 90 1
i1 2.7 . 7.05 83 1
i1 3 1 7.00 80 1
i1 3.3 .5 7.07 90 1
i1 3.7 . 7.05 81 1
i1 4 2 7.00 83 1
i1 5 1 7.07 90 1
i1 6 .33 7.05 80 1
i1 6.42 . 7.05 80 1
i1 6.75 . 7.05 80 1
i1 6.98 . 7.07 85 1
i1 7.48 .48 7.07 80 1
i1 0 4.1 6.00 82 2
i1 0.03 3.9 6.04 81 2
i1 0.02 . 5.07 80 2
i1 0.04 . 4.11 79 2
i1 4 3.8 5.11 82 2
i1 4.01 3.97 6.07 81 2
i1 4.1  3.89 5.02 85 2
i1 4.05 3.92 6.11 80 2
i1 0    1    5.00 90 3
i1 .5   .    4.07 90 4
i1 1    .    5.00 79 3
i1 1    .    4.07 79 4
i1 2    .    5.00 78 3
i1 2    .    5.00 79 4
i1 3    .    4.07 78 3
i1 3    .    5.00 79 4
i1 4    .    5.00 90 3
i1 4    .    4.07 90 4
i1 5    .    5.00 78 3
i1 5    .    4.07 79 4
i1 6    .    5.00 78 3
i1 6    .    5.00 79 4
i1 7    .    .    78 3
i1 7    .    4.07 79 4
e
```

In summary, as a composer, you no longer need a real orchestra. So long as you have enough storage media, you can program entire symphonies for instruments that have never occurred in history. The entire process of sound creation is at your fingertips. As an artist, this is your dream come true.

Begin to explore the possibilities of so powerful a compositional tool, and, before too long, you will be recording fantastic sound to your recordable CD-ROM or other data-intensive media.
