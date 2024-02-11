
;================================================================
; HUNGER ARTIST (simple piece for manipulated cello)
; please note: render using "floats rescaled to 16-bit ints"
;================================================================

sr = 44100
kr =  4410
ksmps = 10
nchnls = 2

garvb4    init      0


	instr 15
kenv	oscil	1, 1/p3, 2
a1	soundin	"glassBk.wav", 1
a1	= a1 * kenv
amod	= a1

a2	oscil	1, p4, p5
a3	= a2*amod
a4	= a2 + a3 
	outs a4, a4    

garvb4	= garvb4  + (a4 * p6)
	endin 

;===============
; VERB
;===============

	instr 16
;		 ia	 dur1	ib	dur2	ic	dur3		id	dur4	ie
kcf	linseg	 p10, 	 p11, 	p12, 	p13, 	p14, 	p3-(p11+p13),	p15
kenv	linseg	 0, 	 50, 	10, 	200, 	10, 	p3-(50+200+50), 1.5, 	50, 	0

;		 asig	 verbt	hfrqdif
a1	nreverb	 garvb4, p4, 	p5
a1	butterbp a1, 	 kcf, 	p6
a1	= a1 * kenv
	outs a1, a1    

garvb4	= 0
	endin

