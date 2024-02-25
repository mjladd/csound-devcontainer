<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>

<CsInstruments>
 nchnls    =         1
 
           instr     2
 k2        linseg    p5, p3/2, p9, p3/2, p5
 k3        line      p10, p3, p11
 k4        line      p12, p3, p13
 k5        expon     p14, p3, p15
 k6        expon     p16, p3, p17
 a1        grain     p4, k2, k3, k4, k5, k6, 1, p6, 1
 a2        linen     a1, p7, p3, p8
           out       a2
           endin
 
</CsInstruments>
<CsScore>
;============================================================================================
 ;FUNCTION 1 (f1) USES THE GEN10 SUBROUTINE TO COMPUTE A SINE WAVE
 ;FUNCTION 3 USES THE GEN20 SUBROUTINE TO COMPUTE A HANNING WINDOW FOR USE AS A GRAIN ENVELOPE
 ;============================================================================================
   f1  0   4096   10   1    
   f3  0   4097   20   2  1
 ;============================================================================================
 ; p1  p2   p3  p4   p5   p6  p7  p8  p9   p10   p11   p12    p13    p14    p15    p16   p17  
 ;============================================================================================
 ; INS STRT DUR AMP  FRQ  FN  ATK REL BEND DENS1 DENS2 AMPOF1 AMPOF2 PCHOF1 PCHOF2 GDUR1 GDUR2
 ;============================================================================================
   i2  0    5   1000 440  3   1   .1  430  12000 4000  120    50     .01   .05    .1    .01 
   i2  6    10  4000 1760 3   5   .1  60   5     200   500    1000    10    20000  1    .01
 ;============================================================================================
 
</CsScore>

</CsoundSynthesizer>