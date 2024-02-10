<CsoundSynthesizer>

<CsOptions>
--output=scan_rb00.aiff -r44100 -k441
</CsOptions>

<CsInstruments>
	instr 1
icondfn   = p7
ispgmtrxf = p8
a0 = 0

;       icondfn,  scnrat,  ivelf, imasf, ispgmtrxf, icntrf, idampf, kmas, kspgstf, kcntr, kdamp, ilplkpos, irplkpos, kpos, kstrngth, ain, disp, id
scanu	icondfn,  .05,     6,     2,     3,         4,      5,      2,    .2,      .2,    -.05,  .1,       .5,       .5,   0,        a0,   p6,  1

;  	scans  kamp,      kfreq,      itrj, iid
a1 	scans  ampdb(p4), cpspch(p5), 7,    1
a1 	dcblock a1
out	 a1
endin
</CsInstruments>

<CsScore>
; Initial Condition/State
;num   str size GEN
;p1    p2  p3   p4  p5
f1     0   128  7   0 60  0  2  1  2  0  60  0
f11    0   128  7   0 30  0  2  1  2  0  30  0 30 0 2 -1 2 0 30 0
f111   0   128  10  1 0   0  0  1  0  0  0   1
f1111  0   128  10  1

; Initial Masses
; negative table number = don't scale to max value in the table
f2     0   128  -7  1  128 1

; Spring matrix
; GEN23: read numeric values from text file
f3     0    0   -23 "string-128"

; Centering force
f4     0    128 -7  0 64 2 64 0

; Damping
f5     0    128 -7  1 128 1

; Initial velocity
f6     0    128 -7  0 128 0

; Trajectory
f7     0    128 -7  0 128 128

; Pluck
f8     0    128  7  0 60 0 2 1 2 0 60 0

; Sine wave
f9     0    1024 10 1

; initial conditions
;   start dur amp
;p1 p2  p3    p4  p5    p6 p7   p8
i1  0   2     90  7.00  1  1    2
i1  +   .     90  7.07  1  1    2
i1  +   5     90  8.00  1  1    2
i1  +   2     90  7.00  1  11   2
i1  +   .     90  7.07  1  11   2
i1  +   5     90  8.00  1  11   2
i1  +   2     90  7.00  1  111  2
i1  +   .     90  7.07  1  111  2
i1  +   5     90  8.00  1  111  2
i1  +   2     90  7.00  1  1111 2
i1  +   .     90  7.07  1  1111 2
i1  +  12     90  8.00  1  1111 2
e
</CsScore>
</CsoundSynthesizer>
