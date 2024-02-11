<CsoundSynthesizer>

<CsOptions>
--output=cass_quad_scan.aiff -r44100 -k441
</CsOptions>

<CsInstruments>

; SCANNED SYNTHESIS
nchnls    =         2
          instr     1
iwiggle   =         0
kenv      linseg    1, p3*.2, 3.5, p3*.2, 2, p3*.1, 3, p3*.5, .01
kpicker   randi     kenv*.1, kenv
krnd      =         kenv+abs(kpicker)
kenv2     linseg    1, p3*.9, 1, p3*.1, 0
asound    loscil    10000*kenv2, 262, 13
          scanu     1, .01, 6, 2, 3, 4, 5, 2, .03, .1, -.1, .1, .5, 0, 0, asound, iwiggle, 0
a1        scans     1, 180*krnd, 7, 0
a2        scans     1, 150*krnd, 7, 0
a3        scans     1, 100*krnd, 7, 0
a4        scans     1, 55*krnd, 7, 0
a2b       delay     a2, 1
a3b       delay     a3, 2
a4b       delay     a4, 3
aleft     reverb    a1+(a3b*.7)+(a4b*.3), .3
aright    reverb    a2b+(a3b*.3)+(a4b*.7), .3
          outs      aleft*kenv2, aright*kenv2
          endin
</CsInstruments>
<CsScore>

; INITIAL CONDITION
f1 0 128 7 0 32 1 32 0

; MASSES
f2 0 128 -7 1 128 1

; CENTERING FORCE
f4  0 128 -7 2 64 0 64 2

; DAMPING
f5 0 128 -7 1 128 1

; INITIAL VELOCITY
f6 0 128 -7 -.0 128 .0

; TRAJECTORIES
f7 0 128 -23 "circularstring-128.matrix"

; SPRING MATRICES
f3 0 16384 -23 "cylinder-128_8.matrix"

;LOOPED 13EAT
f13 0 131072 1 "13eat3.aiff" 0 0 1

i1 0 30 0
e
</CsScore>

</CsoundSynthesizer>