<CsoundSynthesizer>
<CsOptions>
--output=saw01.aiff -r44100 -k441
</CsOptions>
<CsLicence>
</CsLicence>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 1; band limited sawtooth wave
; coded by Josep M Comajuncosas / jan�98
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iamp = 10000; intended max. amplitude
kenv linen 1, .2,p3,.2; volume envelope
kfreq = cpspch(p4)
ibound = sr/4; set it to sr/2 for true BL square wave
apulse buzz 1, kfreq, ibound/kfreq, 1
asawdc integ apulse
asaw = asawdc - .5
out asaw*iamp*kenv
endin
</CsInstruments>
<CsScore>
f1 0 65537 10 1
i1 0 2 6.00
i1 2 2 7.00
i1 4 2 8.00
i1 6 2 9.00
i1 8 2 10.00
e
</CsScore>
</CsoundSynthesizer>

