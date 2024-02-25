<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441 -B4096 -b2048
</CsOptions>

<CsInstruments>
		instr 	2
iamp 	= 		ampdb(p4)
iamp 	= 		iamp*.5
a0		soundin	"120_BT_Fast_Satellite.wav"
a1 		=		a0/30000
		scanu	1,.01,6,2,33,44,5,2,.01,.05,-.05,.1,.5,0,0,a1,0,0
a2		scans	iamp, cpspch(p5), 7, 0
a3		scans	iamp, cpspch(p5)*1.01, 77, 0
		out		a3+a2+(a0*.1)
		endin
</CsInstruments>

<CsScore>
; Initial condition
f1 0 128 7 0 64 1 64 0
; Masses
f2 0 128 -7 1 128 1
; Spring matrices
f33 0 16384 -23 "string-128.mat"
; Centering force
f44 0 128 -7 4 64 0 64 4
; Damping
f5 0 128 -7 1 128 1
; Initial velocity
f6 0 128 -7 -.0 128 .0
; Trajectories
f7 0 128 -5 .001 64 64 64 .001
f77 0 128 -5 127 64 .001 64 127
; Note list
i2 0  5  63 6.00
i2 6  5  60 7.00
i2 10 5  60 8.00
i2 14 7  60 5.00
</CsScore>

</CsoundSynthesizer>