<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>


<CsInstruments>
nchnls = 2
instr    1 ; Ring Modulator
ilevl    = p4                          ; Output level
ifreq1   = (p5 < 19 ? cpspch(p5) : p5) ; L start frequency in cpspch or Hz
ifreq2   = (p6 < 19 ? cpspch(p6) : p6) ; L end frequency in cpspch or Hz
ifreq3   = (p7 < 19 ? cpspch(p7) : p7) ; R start frequency in cpspch or Hz
ifreq4   = (p8 < 19 ? cpspch(p8) : p8) ; R end frequency in cpspch or Hz
idepth   = p9                          ; Depth
iwave    = p10                         ; Waveform
ain      soundin  "hellorcb.aif"
ksweep1  expon  ifreq1, p3, ifreq2
ksweep2  expon  ifreq3, p3, ifreq4
aosc1    oscili  1, ksweep1, iwave, -1
aosc2    oscili  1, ksweep2, iwave, -1
outs1    ain*(aosc1*idepth + 1*(1 - idepth))
outs2    ain*(aosc2*idepth + 1*(1 - idepth))
endin
</CsInstruments>

<CsScore>
f1 0 8193 10 1                      ; Sine
f2 0 8193 7 0 2048 1 4096 -1 2048 0 ; Triangle
f3 0 8193 10 1 1                    ; 1st and 2nd harmonics
f4 0 8193 10 1 0 0 0 1              ; 1st and 5th harmonics
;Freq: >19=Hz <19=Pitch
;                     -----L----- -----R-----
;   Strt  Leng  Levl  Freq1 Freq2 Freq1 Freq2 Depth Wave
i1  0.00  7     1.00  75    1000  4000   75    1.00  3
s
i1  0.00  7     1.00  777   10000 400    7005  1.00  2
s
i1  0.00  7     1.00  7     70    40     375   1.00  1
s
i1  0.00  7     1.00  1775  170   2400   5375   1.00  4
s
i1  0.00  7     1.00  77     2170  57    3375   1.00  1
e
</CsScore>

</CsoundSynthesizer>