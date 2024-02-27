<CsoundSynthesizer>
<CsOptions>
--output=combs1.aiff -r44100 -k441
</CsOptions>
<CsLicence>
</CsLicence>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;comb filters
; coded by Josep M Comajuncosas / jan�98
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 1; noisy wave to test the filters
kamp linen 1, .001, p3, .01
gkfreq linseg 100, p3/2, 2000, p3/2, 100
anoise rand 1
gasig = kamp*anoise
endin


instr 2; inverse FIR comb filter
; notches at kfreq, 2*kfreq ...
iminfreq = 20
kfeed line 0, p3, 1

adel delayr 1/iminfreq
acomb0 deltapi 1/gkfreq

delayw gasig

aout = gasig - kfeed*acomb0
out aout*2500

endin

instr 3; FIR comb filter
; peaks at kfreq, 2*kfreq ...
iminfreq = 20
kfeed line 0, p3, 1

adel delayr 1/iminfreq
acomb0 deltapi 1/gkfreq

delayw gasig

aout = gasig + kfeed*acomb0
out aout*2500

endin

instr 4; IIR comb filter
; peaks at kfreq, 2*kfreq ...
iminfreq = 20
kfeed line 0, p3, .85; careful!

adel delayr 1/iminfreq
acomb0 deltapi 1/gkfreq

afeed = gasig + kfeed*acomb0
aout atone afeed, 10
delayw afeed

out aout*1500

endin

instr 5; inverse IIR comb filter
; peaks at kfreq, 3*kfreq ...
iminfreq = 20
kfeed line 0, p3, .85; careful!

adel delayr 1/iminfreq
acomb0 deltapi 1/(2*gkfreq)

afeed = gasig - kfeed*acomb0
delayw afeed

out afeed*1500

endin

instr 6; dry signal to compare
out gasig*5000
endin
</CsInstruments>
<CsScore>
f1 0 8193 10 1
i1 0 10
i6 0 10
s
i1 0 10
i2 0 10
s
i1 0 10
i3 0 10
s
i1 0 10
i4 0 10
s
i1 0 10
i5 0 10
e
</CsScore>
</CsoundSynthesizer>

