<CsoundSynthesizer>
<CsOptions>
--output=bamboo.aiff -r44100 -k441
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2

instr 1
; bamboo is a semi-physical model of a bamboo sound
;            kamp  idettack  inum  idamp imaxshake ifreq  ifreq1
asig  bamboo p4,  0.01,     0,     0,    .25,        p5,    p6
      outs asig, asig

endin

</CsInstruments>
<CsScore>

;p1    p2    p3   p4     p5
;inst start  dur  amp    freq  freq2
i1    0      1    20000  2000  2300
i1    2      1    20000  1200  1500
i1    4      1    20000  800   3000
e

</CsScore>
</CsoundSynthesizer>