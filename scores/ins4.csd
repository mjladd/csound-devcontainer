<CsoundSynthesizer>
<CsOptions>
--output=ins4.aiff -r44100 -k441
</CsOptions>

<CsInstruments>
sr = 44100
kr =  4410
ksmps = 10
nchnls = 2

ifreq = p4

        instr 4
;	opcode	ia	dur1	ib	dur2	ic	dur3	id
aamp	linseg  0, 	p3*.3, 	8000, 	p3*.2, 	8500, 	p3*.5, 	10000
afund	expseg  200, 	p3*.8, 	342, 	p3*.2, 	223
afreq	linseg  20, 	p3*.2, 	p6, 	p3*.8, 	20

;	opcode	amp,	 fund	form	oct  band  rise	 dur   dec   olaps  ifna  ifnb	otdur
a1      fof	aamp*p7, afund,	afreq, 	0,   0,	   .1,   .12, .009,  100,   24,    23,    p3,    0,    1

        outs	a1*.05, a1*.05
        endin

</CsInstruments>
<CsScore>
;****************************
;     Instr 4 
;****************************
;	strt	table	GEN	prmtr
f23	0	1024 	19	.5     .5	270	.5
f24	0	512	7	0	50 	.25	50  .75  350  .75  62  0

;****************************
;     Instr 4 Score
;****************************
;       str	dur	freq
;       p2	p3	p4	p5	p6	p7
i4	0	10	0       0	490	1
i4	10	10	0	0	290	1
i4	20	10	0	0	690	1
</CsScore>
</CsoundSynthesizer>
