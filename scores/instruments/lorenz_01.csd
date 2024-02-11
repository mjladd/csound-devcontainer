<CsoundSynthesizer>

<CsOptions>
--output=lorenz_01.aiff  -r44100 -k441
</CsOptions>

<CsInstruments>
 nchnls    =         2

           instr     1
 ax        init      p5         ; LORENZ ATTRACTOR
 ay        init      p6
 az        init      p7
 as        init      p8
 ar        init      p9
 ab        init      p10
 ah        init      p11

 kampenv   linseg    0, .01, p4, p3-.02, p4, .01, 0
 axnew     =         ax+ah*as*(ay-ax)
 aynew     =         ay+ah*(-ax*az+ar*ax-ay)
 aznew     =         az+ah*(ax*ay-ab*az)
 ax        =         axnew
 ay        =         aynew
 az        =         aznew
           outs      ax*kampenv,ay*kampenv
           endin


</CsInstruments>
<CsScore>
f1 0 16384 10 1

 t 0 200

 i 1  0    1   500   .6  .6  .6  30   21  2.52  .002
 i 1  +    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   1200  .6  .6  .6  30   21  2.30  .012
 ;
 i 1  14   1   800   .6  .6  .6  30   21  2.00  .012
 i 1  +    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .   <     .6  .6  .6  30   21  <     <
 i 1  .    .  2000   .6  .6  .6  30   21  2.30  .002

</CsScore>

</CsoundSynthesizer>