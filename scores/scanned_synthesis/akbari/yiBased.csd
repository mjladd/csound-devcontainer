<CsoundSynthesizer>
<CsOptions>
--output=yi_based.aiff -r44100 -k441
</CsOptions>
<CsInstruments>
/*
David Akbari
Exploration of Scanned Synthesis.
This is based on a collection of instruments by Steven Yi.
*/
sr		=	16000
kr		=	160
ksmps		=	100
nchnls	=	2

#include	"rvb.h"

ga1	init	0

		instr 1	;working instrument

;	init

kpch	= cpspch(p4)
iforce	= p6 * .0004

ain	linseg 0, 1, iforce, p3 - .1, 0

kenv	linseg 0, 1, 1, p3 -.7, 0

ifnmatrix	= p5
iscantable	 = p7

iInit	= 1
irate	= .02

ifnvel	= 6
ifnmass	= 2
ifncenter	= 4
ifndamp	= 5

kmass	= 2
kstiff	= .05
kcenter	= .1
kdamp 	= -.4

ileft	= .1
iright	= .3
kpos	= .2
kstrength	= 0
idisp	= 0
id	= 2
;	synth
	scanu	iInit,irate,ifnvel,ifnmass,ifnmatrix,ifncenter,ifndamp,kmass,kstiff,kcenter,kdamp,ileft,iright,kpos,kstrength,ain,idisp,id
aout	scans	15000, kpch, iscantable, 2
aout	= aout * kenv
aout 	dcblock aout
aout	butterlp	aout, kpch * 8 * kenv
aout	butterlp	aout, kpch * 8 * kenv
aout	nreverb	aout, 3.1, .2
ga1	= ga1 + aout
		endin

		instr 20	;reverb
$xrvb2s(ga1'aoutL'aoutR'.2'6'2000)
	outs aoutL, aoutR
ga1 = 0
		endin

</CsInstruments>
<CsScore>
f1 0 128 7 0 128 0
f2 0 128 -7 1 128 1		; masses
f4  0 128 -7 0 128 2		; centering force
f5 0 128 -7 1 128 1		; damping
f6 0 128 -7 -.0 128 0		; init velocity
f7 0 128 -7 0 128 128	; trajectory
f20 0 65537 10 1
f21 0 65537 7 -1 65537 1
f22 0 65537 7 1 32768 1 1 -1 32768 -1
f105 0 16384 -23 "circularstring-128"

i20 0 [64.0 + 4]

;i	st	dur	note	fnM	forc	fnSc
i1	0.0	6.0	9.01	105	80	7
i.	+	.	8.10	.	.	.
i.	6	.	9.03	.	.	.
i1	12	6	9.01	105	80	7
e
</CsScore>

</CsoundSynthesizer>