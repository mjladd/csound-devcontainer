<CSoundSynthesizer>
<CsOptions>
--output=ghosts.aiff -r44100 -k441

</CsOptions>
<CsInstruments>

;***********************************************
;    Ghosts, I                                 *
;    whispers of the collective unconsciousnes *
;    part I                                    *
;***********************************************

sr = 44100
kr =  4410
ksmps = 10
nchnls = 2


;garvbsig    init    0 ; initialize global reverb

;*************************
;        instr 1 xenak   *
;*************************


    instr 1
; amplitude control with 4 envelopes
kenv1    linseg    0,             p3/4,    p4,     p3/2,    p4,     p3/4,    0
kenv2    linseg    .00001*p4,     p3/4,    p4,     p3/2,    p4,     p3/4,    .00001*p4
kenv3    linseg    .00001*p4,     p3/4,    p4,     p3/2,    p4,     p3/4,    .00001*p4
kenv4    linseg    .00001*p4,     p3/4,    p4,     p3/2,    p4,     p3/4,    .00001*p4

; spectral control over time
; expseg: series of exponential segments
;        opcode        ia,        dur1,     ib          dur2     ic         dur3      ic
actr1    expseg        p5,        p3*.1,    p5,         p3*.8,   p5*1.43,   p3*.1,    p5*1.42
actr2    expseg        p5*1.06,   p3*.2,    p5*1.06,    p3*.6,   p5*1.45,   p3*.2,    p5*1.45
actr3    expseg        p5*1.07,   p3*.3,    p5*1.07,    p3*.4,   p5*1.48,   p3*.3,    p5*1.48
actr4    expseg        p5*1.09,   p3*.4,    p5*1.09,    p3*.4,   p5*1.5,    p3*.2,    p5*1.5
actr5    expseg        p5*.96,    p3*.1,    p5*.96,     p3*.8,   p5*.71,    p3*.1,    p5*.71
actr6    expseg        p5*.94,    p3*.25,   p5*.94,     p3*.5,   p5*.7,     p3*.25,   p5*.7
actr7    expseg        p5*.92,    p3*.2,    p5*.92,     p3*.6,   p5*.68,    p3*.2,    p5*.68
actr8    expseg        p5*.9,     p3*.3,    p5*.9,      p3*.5,   p5*.66,    p3*.2,    p5*.66

; oscillators
;    opcode    amp      freq    ifn
a1    oscil    kenv1,   actr1,    1
a2    oscil    kenv1,   actr2,    1
a3    oscil    kenv1,   actr3,    1
a4    oscil    kenv1,   actr4,    1
a5    oscil    kenv1,   actr5,    1
a6    oscil    kenv1,   actr6,    1
a7    oscil    kenv1,   actr7,    1
a8    oscil    kenv1,   actr8,    1


;        opcode   asig,          khp
afilt1   tone     a1+a3+a5+a7,   800
afilt2   tone     a2+a4+a6+a8,   800

    outs     afilt1, afilt2

;    garvbsig1 = garvbsig + afilt1
;    garvbsig2 = garvbsig + afilt2
    endin


;***********************************
;        instr 2 phase vocoder     *
;***********************************

    instr 2
k1  line    0,     p3,     .25

;    opcode   timpnt   fmod    file
a1   pvoc     k1,      p4,     "whisp.pv",     1
a2   pvoc     k1,      p4,     "whisp.pv",     1

;    opcode    ia    dur1     ib    dur2    ic    dur3    id
k2   linseg    0,    p3*.25,  .7,   p3*.5,  .7,   p3*.25,  0
    outs a1*k2, a2*k2
    endin


;*****************************************************
;           instr  3 sample granulation              *
;*****************************************************

    instr 3
itrnss  = p4    ;event pitch (start: 1000=@ orig pitch)
itrnsf  = p5    ;event pitch (finish: 1000=@ orig pitch)
iamp    = p6    ;amplitude of overall event
imiigts = p7    ;minimum inter-grain time (start)
imiigtf = p8    ;minimum inter-grain time (finish)
imxigts = p9    ;maximum inter-grain time (start)
imxigtf = p10   ;maximum inter-grain time (finish)
imigls  = p11   ;minimum grain length (start)
imiglf  = p12   ;minimum grain length (finish)
imxgls  = p13   ;maximum grain length (start)
imxglf  = p14   ;maximum grain length (finish)
iseed   = p15   ;seed value for randh units
irvars  = p16   ;random var around read pointer (start)
irvarf  = p17   ;random var around read pointer (finish)
ifns    = p18   ;sound file source table
ismpsz  = p19   ;actual sample size
ifnrp   = p20   ;line function for read pointer
ifnm    = p21   ;function for melodic contour
ifnmt   = p22   ;number of repeats of melodic function/p3

; inter-grain time
;       opcode    ia         dur1     ib        dur2     ic
kmiigt  expseg    imiigts,   p3*.66,  imiigtf,  p3*.34,  imiigts
kmxigt  expseg    imxigts,   p3*.66,  imxigtf,  p3*.34,  imxigts

;     opcode    amp                   cps         seed
kr1   randh     (kmxigt-kmiigt)/2,    1/kmiigt,   iseed

kigt    = kmiigt+(kr1+((kmxigt-kmiigt)/2))

; grain length
kmxgl   expseg imxgls,    p3*.66,    imxglf,    p3*.34,    imxgls
kmigl   expseg imigls,    p3*.66,    imiglf,    p3*.34,    imigls

;       opcode    amp                 cps         seed
kr2     randh     (kmxgl-kmigl)/2,    1/kmiigt,   iseed

kgl     = kmigl+(kr2+((kmxgl-kmigl)/2))

; envelope for random stereo placement over event duration:
; uniform pseudorandom selection
;    opcode    amp    cps        seed
kstr    randh    .5,    1/kmiigt,    iseed

                ;read pointer
;    opcode    ia      dur1    ib    dur2    ic
newvar:        krvar   expseg     irvars,    p3*.34,    irvarf,    p3*.66,    irvars
               ktrns   expseg     itrnss,    p3*.34,    itrnsf,    p3*.66,    itrnss

        ;    opcode    amp    cps       ifn
                kr4     oscil     ktrns,    ifnmt/p3,  ifnm

        ;    opcode    amp        cps        seed
                kr3     randh     krvar*1000,    1/kmiigt,    iseed

        ;    opcode    amp    cps    ifn    phase
                krpt    oscil1     0,    1,    p3*2.5, ifnrp

                kbegg   = (krpt*1000)*48+(kr3*48)
                kendg   = kbegg+((kgl*kr4)*48)

                ;amplitude of overall event
        ;    opcode    amp    rise    dec    atk
                kenv    linenr     iamp,    p3*.25,    0,    0.001

        ;    instr    strt        label
reset:          timout  0,    i(kigt)+i(kgl),    contin
                reinit  reset

contin:         if      i(kendg)>ismpsz goto null
                if      i(kbegg)<0 goto null

        ;    opcode    ia    dur1    ib
                andx    line    0,    i(kgl),    4096

        ;    opcode    index    func
                agenv   tablei  andx,    81

        ;    opcode    ia         dur1    ib
                adyn    line     i(kbegg),    i(kgl),    i(kendg)

        ;    opcode    index    func    mode    off    wrap
                a1      tablei     adyn,    ifns,    0,    0,    0

                outs1   (a1*agenv*kenv)*(i(kstr)+.5)
                outs2   (a1*agenv*kenv)*(1-(i(kstr)+.5))
null:           a2      = 0


                outs    a2, a2
;        garvbsig1  =     garvbsig + (a2*.8)
;        garvbsig2  =     garvbsig + (a2*.8)
;        garvbsig1  =     garvbsig + (a1*.8)
;        garvbsig2  =     garvbsig + (a2*.8)

endin


;*************************************
;        instr 4-6 Phase Vocoder     *
;*************************************

    instr 4
k1       line    0,     p3,     .25

;    opcode    timpnt    fmod    file
a1    pvoc    k1,     p4,     "female.pv",     1

;    opcode    ia    dur1    ib    dur2    ic    dur3    id
k2    linseg    0,    p3*.25,    .7,    p3*.5,    .7,    p3*.25,    0
    outs a1*k2, a1*k2
    endin

    instr 5
k1       line    0,     p3,     .25

;    opcode    timpnt    fmod    file
a1    pvoc    k1,     p4,     "glass.pv",     1

;    opcode    ia    dur1    ib    dur2    ic    dur3    id
k2    linseg    0,    p3*.25,    .7,    p3*.5,    .7,    p3*.25,    0
    outs a1*k2, a1*k2
    endin

    instr 6
k1       line    0,     p3,     .25

;    opcode    timpnt    fmod    file
a1    pvoc    k1,     p4,     "whisp.pv",     1

;    opcode    ia    dur1    ib    dur2    ic    dur3    id
k2    linseg    0,    p3*.25,    .7,    p3*.5,    .7,    p3*.25,    0
    outs a1*k2, a1*k2
    endin


;************************
;        instr 7 FOF    *
;************************
    instr 7
ifq     =       p4    ; fundamental frequency

; envelope for singing harmonic levels
;    opcode    ia   dur1    ib       dur2    ic    dur3   ic    dur4    id   dur5    ie   dur6    if    dur7   ig
;kflvl   linseg  7.8, p3*.1,  7.8,  p3*.1,  14.4, p3*.1, 14.4, p3*.05, 5.8, p3*.1,  5.8, p3*.05, 12.4, p3*.4, 12.4
;kflvl2  linseg  21.9,p3*.05, 21.9, p3*.05, 16.9, p3*.2, 16.9, p3*.05, 21.9,p3*.05, 21.9,p3*.1,  16.9, p3*.4, 16.9

kflvl   linseg   7.8, p3*.1,  7.8,  p3*.1,  14.4, p3*.1, 14.4, p3*.05, 3.8, p3*.1,  3.8,  p3*.05,  9.8, p3*.4, 9.8
kflvl2  linseg  21.9,p3*.05, 21.9,  p3*.05, 16.9, p3*.2, 16.9, p3*.05, 21.9,p3*.05, 21.9, p3*.1,  26.9, p3*.4, 26.9


; constant
kconst  =       32000        ; used to normalize output

; normalization function
knorm   =      (1/(9+kflvl+kflvl2+16.9+25.1))*.15

; convert formant amp from dB to csoundlvls
kamp1   =       (kconst*19)*knorm       ;formant1 amplitude
kamp2   =       (kconst*kflvl)*knorm    ;moved by k80
kamp3   =       (kconst*kflvl2 )*knorm  ;moved by k90
kamp4   =       (kconst*36.9)*knorm     ;formant4  amplitude
kamp5   =       (kconst*55.1)*knorm     ;formant5  amplitude

;  jitter  used to create random flucuations for singing
;    opcode    kamp    kcps      iseed
k5      randi   .01,    1/.05,     .8355
k6      randi   .01,    1/.111,  .2111
k7      randi   .01,    1/1.219, .9711
kjitter =       (k5 + k6 + k7) * p4

; sum of fund and jitter
kfq     =       p4 + kjitter

; fund freq displacement envelopes
;    opcde    ia    dur1    ic    dur2    id
kd1     linseg  1,     p3*.3,     1,     p3*.7,     1.2
kd2     linseg  1,     p3*.4,     1,     p3*.6,     1.4
kd3     linseg  1,     p3*.5,     1,     p3*.5,     1.6
kd4     linseg  1,     p3*.6,     1,     p3*.4,     1.8
kd5     linseg  1,     p3*.7,     1,     p3*.3,     2.0

; sum kfreq with kd displacements
kfreq1  =       kfq*kd1
kfreq2  =       kfq*kd2
kfreq3  =       kfq*kd3
kfreq4  =       kfq*kd4
kfreq5  =       kfq*kd5

; xoormif mid singing harmonics
;    opcde    ia   dur1    ib    dur2    ic    dur3     ic    dur4    id    dur5    ie    dur6   if    dur7   ig
ksing1  linseg  477, p3*.25, 953,  p3*.25, 1252, p3*.125, 1252, p3*.25, 953,  p3*.25, 953,  p3*.1, 1252, p3*.4, 1252
ksing2  linseg  1276,p3*.05, 2552, p3*.05, 2495, p3*.2,   2495, p3*.05, 2552, p3*.05, 2552, p3*.1, 2495, p3*.4, 2495

; octiviation   ia  dur1       ib  dur2       ic  dur3      id
koct    expseg  .1, (p3-3)*.4, .1, (p3-3)*.3, 10, (p3-3)*.3, 10


; subtract from p3 to allow reverb decay
ip3     =       p3-5

;    opcode    kamp    xfund   xform   koct  kband kris  kdur  kdec  iolps ifna ifnb itotdur    iphs    ifmode
a1      fof     kamp1,    kfreq1,    317,    koct, 80,   .003, .02, .007,  50,   20,   21,   ip3,      0,     20
a2      fof     kamp2,    kfreq2,    ksing1,    koct, 90,   .003, .02, .007,  50,   20,   21,   ip3,      0,     20
a3      fof     kamp3,    kfreq3,    ksing2,    koct, 120,  .003, .02, .007,  50,   20,   21,   ip3,      0,     20
a4      fof     kamp4,    kfreq4,    3417,    koct, 130,  .003, .02, .007,  50,   20,   21,   ip3,      0,     20
a5      fof     kamp5,    kfreq5,    5861,    koct, 140,  .003, .02, .007,  50,   20,   21,   ip3,      0,     20

; mix all fof generators
a6      =       a1 + a2 + a3 + a4 + a5

; a6 into 2 different reverbs
;    opcode    asig    krvt    khdif
ar1     nreverb a6,     15,     0           ; reverb 1
ar10    nreverb a6,     10,     1           ; reverb 2

; add together
ar100   =       ar1+ar10


;env control over output
k99    linen    .8,    p3*.25,    p3,    p3*.01

; output a6 with reverb
        outs     (k99*(a6+(ar100*.03))), (k99*(a6+(ar100*.04)))
        endin


;*****************************************************
;        instr 99 reverb                      *
;*****************************************************

;    instr 99                 ; global reverb
;       irvbtime1 = p4
;    irvbtime2 = p4+1

;    opcode    amp    freq    ifn
;afin1    reverb    garvbsig1, irvbtime1 ; put global signal into reverb1
;afin2    reverb    garvbsig2, irvbtime2 ; put global signal into reverb2


;        outs afin1*.3, afin2*.3
;    garvbsig    =    0              ; then clear it

;    endin
;*****************************************************
;        reverb score                       *
;*****************************************************

;instr    strt    dur    rvbtime    hfdif
;i99    0    385    1.5    .2


</CsInstruments>

<CsScore>
;*****************************************************
;        xenak                          *
;*****************************************************

;    strt    table    GEN    prmtr
f1    0    512    10    1 .8 .7 .5 .4

;    strt    dur    amp    freq
;    p2    p3    p4    p5
i1    1    12    3000    65
i1    17    10    2000    65
i1    20    10    4000    73
i1    25    11    4000    90
i1    30    14    4000    66
i1    42    15    3300    160
i1    55    7    3700    330
i1    60    6    2500    165
i1    63    6    2500    427
i1    65    8    2500    340
i1    67    6    2500    390
i1    70    7    2200    85
i1    75    10    2100    93
i1    87    14    2000    65
i1    90    17    2100    240
i1    92    18    2000    160
i1    95    16    200    66
i1    105    12    3000    65
i1    121    10    2000    65
i1    127    10    4000    73
i1    134    11    4000    90
i1    140    14    4000    66
i1    154    12    3300    160
i1    162    5    3700    330
i1    162    10    2000    65
i1    164    4    2500    165
i1    164    8    2500    330
i1    165    12    2100    240
i1    166    10    2500    450
i1    167    18    2000    160
i1    168    14    2000    300
i1    172    6    2000    330
i1    244    15    1500    160
i1    261    15    1300    330
i1    274    18    1300    130
i1    390    20    2000    65
i1    405    18    2100    100
i1    420    19    3000    650


;*****************************************************
;        phase vocoder score                *
;*****************************************************

;    strt    dur    timescale
i2    137    7    2
i2    149    10    1
i2    370    10    .5
i2    376    22    .6

;*****************************************************
;        sample granulation instrument            *
;*****************************************************

;itrnss  = p4    event pitch (start: 1000=@ orig pitch)
;itrnsf  = p5    event pitch (finish: 1000=@ orig pitch)
;iamp    = p6    amplitude of overall event
;imiigt  = p7    minimum inter-grain time (start)
;imiigt  = p8    minimum inter-grain time (finish)
;imxigt  = p9    maximum inter-grain time (start)
;imxigt  = p10   maximum inter-grain time (finish)
;imigl   = p11   minimum grain length (start)
;imigl   = p12   minimum grain length (finish)
;imxgl   = p13   maximum grain length (start)
;imxgl   = p14   maximum grain length (finish)
;iseed   = p15   seed value for randh units
;irvar   = p16   random var around read pointer (start)
;irvar   = p17   random var around read pointer (finish)
;ismpsz  = p18   actual sample size
;ifns    = p19   sound file source table
;ifnrp   = p20   line function for read pointer


;grain envelope
;    strt    table    GEN    a    n1    b    n2    c    n3    d
f81     0       4096    8         0     1024     1     2048     1     1024     0

;input source (substitute a sample of your here
; check with the Csound manual for GEN1 options for various file formants)
;    strt    table    GEN    FileName    skip    format    chnl
;f71     0         32768   1    "Short.wav"      0    4         1     ;sample file
;f73     0         65536   1    "apoc.wav"      0    4         1     ;sample file
;f74     0         8192    1    "sh.wav"          0    4         1     ;sample file
;f75     0         8192    1    "glass.wav"      0    4         1     ;sample file

f71     0         32768   1    "whisp.aiff"      0    4         1     ;sample file
f73     0         65536   1    "apoc.aiff"      0    4         1     ;sample file
f74     0         8192    1    "female.aiff"      0    4         1     ;sample file
f75     0         8192    1    "glass.aiff"      0    4         1     ;sample file

;line generators for read pointer
;        strt    table    GEN        a    n1       b
f31     0       4096    7       0    4096   1

;melody function (substitute your melodic sequence function here)
;    strt    table    GEN  a      n1    b      n2    c     n3    d
f32     0       4096    8    1.0   1024   1.0   1024  .5    2048  .5
f33     0       4096    8    .5    1024   .5    1024   1    2048  1
f34     0       4096    8    .4    1024   .4    1024   .8   512   .8    1536   1

;score
;*************************************************
; single line melodic fragment with sample
;*************************************************
;ins  strt  dur  itrnss  itrnsf  iamp  imiigts  imiigtf  imxigts  imxigtf  imigls  imiglf  imxgls  imxglf  iseed  irvars  irvarf  ifns  ismpsz  ifnrp  ifnm  ifnmt
;p1   p2    p3   p4      p5     p6     p7       p8       p9       p10      p11     p12     p13      p14     p15    p16    p17    p18  p19     p20    p21  p22
i3    85    7    700      900     9000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     73    65536   31     32   1
i3    100   15  1000     1600    12000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     75    65536   31     33   1
i3    117   12  1100     1600     8000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     34   1
i3    133   17  1000     1350    10000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     75    8192    31     33   1


i3    189   9   1000      900    13000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     73    65536   31     32   1
i3    201   3   1000      900    14000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     71    32768   31     32   1
i3    203   7   1400     1700    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     75    32768   31     33   1
i3    209   10  1000      900    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .561   .001    .1     71    32768   31     32   1
i3    212   5   1200      900    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .461   .001    .1     71    32768   31     32   1
i3    214   10  1000     1300    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .361   .001    .1     73    65536   31     32   1
i3    220   15  1000     1200    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     33   1
i3    227   15  1000     1300    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .761   .001    .1     71    32768   31     32   1
i3    245   10  1300     1500    22000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     32   1
i3    254   9   1400     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     34   1
i3    261   8   1000     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     34   1
i3    264   15  1300     1500    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     32   1
i3    266   13  1200     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .651   .001    .1     73    65536   31     34   1
i3    273   10  1300     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .641   .001    .1     74    8192    31     33   1
i3    284   9   1000     1350    12000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     75    8192    31     33   1
i3    285   9   1000     750     12000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     71    8192    31     32   1
i3    286   9   1200     850     12000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     73    8192    31     32   1
i3    287   15  1000     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     74    8192    31     33   1
i3    288   7   700      900     15000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     74    8192    31     33   1
i3    289   12  1000     1600    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     71    8192    31     32   1
i3    291   10  1000      900    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .621   .001    .1     71    8192    31     32   1
i3    300   15  1000     1200    12000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     33   1
i3    311   15  1000     1200    12000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     33   1
i3    323   20  1000     1200    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     34   1
i3    332   15  1000     1200    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     32   1
i3    337   10  1000     1200    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     33   1
i3    339   12  1000     900     20000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     71    32768   31     32   1
i3    344   27  1000     900     12000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     71    32768   31     32   1
i3    344   15  1700     1900    12000  .04      .001    .002      .0007    .003    .05      .05     .01     .661   .001    .1     74    32768   31     33   1
i3    347   17  1000     1200    20000  .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     73    65536   31     32   1
i3    367   12  1400     1700     25000    .04      .001    .002      .0007    .003    .05      .05     .01     .261   .001    .1     74    8192    31     34   1


;*****************************************************
;        instr 4-6 Phase Vocoder                 *
;*****************************************************

;    strt    table    GEN    prmt    [FOF]
f20    0     65536      10    1

; shape rise and decay
;    strt    table    GEN    prtl#    strengtha  phasea    DC offset   [FOF]
f21    0     1024      19    .5      .25         270      .5


;p4 = time scale // 1=original pitch, 2=octave up, .5=octave down
;p5 = timescale

;    strt    dur  timescale
;p1   p2     p3   p4
i4    380    4    1
i4    386    5    .5
i4    390    14   2

i5    382    4    1
i5    367    5    .5
i5    396    5    2

i6    385    4    1
i6    400    5    .5
i6    416    5    2

;*****************************************************
;        instr 7 FOF                      *
;*****************************************************

;instr    strt    dur    fo
i7         425    26    650

e

</CsScore>
</CsoundSynthesizer>
