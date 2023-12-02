<CsoundSynthesizer>
<CsOptions>
--output=ang.aiff -r44100 -k441
</CsOptions>

<CsInstruments>

sr	    =	44100
ksmps	  = 1
nchnls	= 1
0dbfs	  = 3

instr 6
 ;ang generator
 i1 = ampdb(p5)
 k1 = i1/20

 a1  buzz k1, cpspch(p4)*2, 2, 1
 a2  buzz k1, cpspch(p4)*1.8885, 3, 1
 a3  buzz k1, cpspch(p4), 4, 1
 a4  buzz k1, cpspch(p4), 5, 1
 a4d delay a4, .1, 0
 a5  buzz k1, cpspch(p4), 7, 1
 a5d delay a5, .2, 0

 asig=a1+a2+a3+a4+a5+a4d+a5d
 
 af1 reson asig, cpspch(p4), 20, 1, 64
 af2 reson asig, cpspch(p4), 200, 1, 64
 af3 reson asig, cpspch(p4), 2, 1, 64
 af4 reson asig, cpspch(p4),.2, 1, 64


 aout=(af1+af2+af3+af4) * 0.5
 out aout
endin


</CsInstruments>
; ==============================================
<CsScore>
f1 0 8192 10 10 0 10 0 10 0 10 0 10 0
t  0 140

; inst p2   p3  p4    p5
;     strt  dur frq   amp

i6    .5    .6  4.07 10
i6    1.5   .   .     .
i6    2.5   .   .     .
i6    3.5   .   .     .
i6    4.5   .   .     .
i6    5.5   .   .     .
i6    6.5   .   .     .
i6    7.5   .   .     .
i6    0     .5  5.07  15
i6    2     .   5.07  .
i6    2.5   .   5.07  .
i6    3.5   .3  5.07  .
i6    4     .   5.07  .
i6    6     .   5.07  .
i6    6.5   .5  5.07  .
i6    1     .5  8.07  .
i6    1.75  .25 8.07  .
i6    3.75  .25 8.07  .
i6    5     .5  8.07  .
i6    7     .   8.07  .
i6    1     .5  8.07  .
i6    1.75  .25 8.07  .
i6    3.75  .25 8.07  .
i6    5     .5  8.07  .
e

</CsScore>
</CsoundSynthesizer>
