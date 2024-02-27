<CsoundSynthesizer>
<CsOptions>
--output=pwmd01.aiff -r44100 -k441
</CsOptions>
<CsLicence>
Copyright 2024: All Rights Reserved
</CsLicence>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 1; band limited PWM
; coded by Josep M Comajuncosas / jan�98
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iamp = 10000; intended max. amplitude
kenv linen 1, .2,p3,.2; volume envelope
kfreq = cpspch(p4)
ibound = sr/4; set it to sr/2 for true BL square wave
kratio line .01, p3, .99; fractional width of the pulse part of a cycle
apulse1 buzz 1, kfreq, ibound/kfreq, 1
; comb filter to give pulse width modulation
atemp delayr 1/20
apulse2 deltapi kratio/kfreq
delayw apulse1
avpw = apulse1 - apulse2
apwmdc integ avpw
apwm = apwmdc + kratio - .5
out apwm*iamp*kenv
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

