<CsoundSynthesizer>

<CsOptions>
--output=01_osc.aiff -r44100 -k441
</CsOptions>

<CsInstruments>

 nchnls    =         1					      ; OUTPUT CHANNELS
 
           instr     1					      ; DEFINE INSTRUMENT 1
 k1        linen     p4, p7, p3, p8		; AMLITUDE ENVELOPE
 a1        oscil     k1, p5, p6			  ; TABLE-LOOKUP OSCILLATOR
           out       a1					      ; OUTPUT
           endin							        ; END INSTRUMENT 1
           
</CsInstruments>

<CsScore>
; FUNCTION 1 USES THE GEN10 SUBROUTINE TO COMPUTE A (4096 POINT) SINE WAVE
 ; FUNCTION 2 USES THE GEN10 SUBROUTINE TO COMPUTE FIRST SIXTEEN PARTIALS OF A SAWTOOTH
 
   f1  0 4096 10 1    
   f2  0 4096 10 1 .5 .333 .25 .2 .166 .142 .125 .111 .1 .09 .083 .076 .071 .066 .062
 
 ;================================================================
 ; P1   P2     P3        P4      P5      P6       P7      P8
 ; INS  START  DURATION  AMP     FREQ    F-TABLE  ATTACK  RELEASE
 ;================================================================
   i1   0      2         20000   440     1        1       1
   i1   2.5    2         16000   220     2        0.1     1.99
   i1   5      4         11000   110     2        3.9     0.1
   i1   10     10        10000   138.6   2        9       1
   i1   10     10        9000    329.6   1        5       5
   i1   10     10        8000    440     1        1       9
  
</CsScore>

</CsoundSynthesizer>