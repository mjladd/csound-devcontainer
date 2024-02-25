<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>

<CsInstruments>
gisin    ftgen    1, 0, 16384, 10, 1

          instr    1
icps     = 110
iscale	 = 32768
kfiltfrq line   200,p3,2000
kfiltres init	1
kampenv  adsr    .01, .2, .6, .5
kfrqmod	 adsr    .1, .2, .7, .2
aosc     vco      30000, icps, 1
afilt    moogvcf  aosc, kfiltfrq*kfrqmod, kfiltres, iscale
         out      afilt*kampenv
         endin
          
</CsInstruments>

<CsScore>
i1 0 2
</CsScore>

</CsoundSynthesizer>