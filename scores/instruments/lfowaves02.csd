<CsoundSynthesizer>
<CsOptions>
--output=lfowaves02.aiff -r44100 -k441
</CsOptions>
<CsLicence>
</CsLicence>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1

instr 1; PWM and Saw to Ramp mod. for control signals
; coded by Josep M Comajuncosas / Aug�96

iamp = 10000
ilfoamp = 2000
iamp = iamp - ilfoamp

;pitch and wave shape control
klfofreq linseg 3, .7*p3, 10, .3*p3, 5
kratio line  .01, p3,  .99

cycle:

idur   = i(1/klfofreq)
iratio = i(kratio)
irise =  idur * iratio

	timout 0, idur, shape
	reinit cycle

shape:

if p4 = 1 goto s2t; Ramp/Saw mod.
if p4 = 2 goto vwp; Pulse Width mod.

s2t:
kshape linseg -1, irise, 1, idur-irise, -1;saw or triangle
goto contin

vwp:
kshape linseg  1, irise, 1, 1/sr, -1, idur-irise, -1;variable width pulse
goto contin


contin:
	rireturn
kamp linen iamp, .1, p3, .2;		      amplitude envelope
asig oscili kamp+kshape*ilfoamp, 110, 1

	out asig

endin

</CsInstruments>
<CsScore>
f1 0 65537 10 1; asine wave

t 0 30

; p4 = 1 for Ramp/Saw
; p4 = 2 for PWM
i1 0  10 1
i1 10 10 2
e
</CsScore>
</CsoundSynthesizer>

