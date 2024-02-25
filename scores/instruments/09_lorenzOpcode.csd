<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>

<CsInstruments>
 nchnls    =         2

                instr    1
   iampfac		=	     400
   isv          =        10    ; THE PRANDTL NUMBER OR SIGMA
   irv          =        28    ; THE RAYLEIGH NUMBER
   ibv          =        2.667 ; RATIO OF THE LENGTH AND WIDTH OF THE BOX
   ksv          line     6, p3, isv
   krv			line     16, p3, irv
   kbv			line     1.9, p3, ibv
   ax, ay, az   lorenz   ksv, krv, kbv, .01, .6, .6, .6, 1
   				outs     (ax+az)*iampfac, (ay+az)*iampfac
                endin                                         
</CsInstruments>

<CsScore>
  i1 0     60   400
</CsScore>

</CsoundSynthesizer>
