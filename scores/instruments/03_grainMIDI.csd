<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441 -M0 ;-Fplkbass.mid
</CsOptions>

<CsInstruments>
ctrlinit  1,  10,0,  11,10,  12,64,   13,40,   14,40

instr     1
icps	   cpsmidi
iamp	   ampmidi   10000
kcps      midic7    10, 0, 10000
kdens     midic7    11, .01, 1000
kampoff   midic7    12, .01, 1000
kptchoff  midic7    13, .01, 10000
kgdur     midic7    14, .0001, .1
a1        grain     iamp, icps+kcps, kdens, kampoff, kptchoff, kgdur, 1, 3, .1
a2        linenr    a1, .01, .4, .5
out       a2
endin
</CsInstruments>

<CsScore>
f1  0   4096   10   1
f3  0   4097   20   2  1
f0  60
</CsScore>

</CsoundSynthesizer>
