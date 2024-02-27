<CsoundSynthesizer>
<CsOptions>
--output=lfowaves01.aiff -r44100 -k441
</CsOptions>
<CsLicence>
Copyright 2024: All Rights Reserved
</CsLicence>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

instr 1
iamp = 10000
ilfoamp = 2000
kamp linen iamp-ilfoamp, p3/3, p3, p3/3

klfofreq linen 7, .5, p3, .5
klfoamp linen ilfoamp, p3/2, p3, p3/2
klfo oscili klfoamp, klfofreq, p4

asine oscili kamp+klfo, 110, 1
out asine

endin
</CsInstruments>
<CsScore>
f1 0 65537 10 1; asine wave
f2 0 513   7  0 0 1 256 1 0 -1 256 -1 0 0 ; square wave
f3 0 513   7  0 256 1 0 -1 256 0 ; sawtooth wave (up-down)
f4 0 513   7  0 256 -1 0 1 256 0 ; sawtooth wave (down-up)
f5 0 513   7  0 128 1 256 -1 128 0 ; triangle wave

t 0 30
;     lfo (modulates the amplitude)
i1 0 2 1
i1 2 2 2
i1 4 2 3
i1 6 2 4
i1 8 2 5
e
</CsScore>
</CsoundSynthesizer>

