<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>

<CsInstruments>
          instr    1
 ; OUT    OPCODE   AMP,   FREQ, STIFF, ATK,  REL, NOISE, VIBF, VIBAMP, FUN
   asig   wgclar    p4,     p5,  -0.3, 0.1,  0.2,   0.3,  5.6,   0.18,  1
          out      asig
          endin
</CsInstruments>

<CsScore>
f1 0 16384 10 1 
i1 0 3 20000 440
i1 4 2 10000 880
i1 7 4 30000 220
</CsScore>

</CsoundSynthesizer>