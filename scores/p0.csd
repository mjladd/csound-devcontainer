<CsoundSynthesizer>
<CsOptions>
--output=p0.aiff -r44100 -k441
</CsOptions>

<CsInstruments>
sr = 44100
kr =  4410
ksmps = 10
nchnls = 1

    instr     10
idur =   p3
ipch1 =  cpspch(p5)
ipch2 =  cpspch(p6)
itmb1 =  p7
itmb2 =  p8
iamp1 =  p9
iamp2 =  p10
inoise = p11

kamp	linseg	0,	.075,	iamp1,	idur/3-.075,	iamp1,	idur/3,	iamp2,	idur/3-.075,	iamp2,	.075,0
kcps	linseg	ipch1,	idur/3,	ipch1,	idur/3,		ipch2,	idur/3,	ipch2

;	    opcode	amp	     cps	ifn
kvib	oscil	kcps/50, 4.6,	1

;	    opcode	ia	    dur1	ib	    dur2	ic	    dur3	id
ktmb	linseg	itmb1,	idur/3,	itmb1,	idur/3,	itmb2,	idur/3,	itmb2

;		index	funct	mode
kcf1	table   ktmb,	25,	1
kbw1	table   ktmb,	26,	1
kcf2	table   ktmb,	27,	1
kbw2	table   ktmb,	28,	1
kcf3	table   ktmb,	29,	1
kbw3	table   ktmb,	30,	1
kcf4	table   ktmb,	31,	1
kbw4	table   ktmb,	32,	1

;	opcode	amp	cps		numHarm				ifn
a0	rand    kamp
a1	buzz    kamp,	kcps+kvib,	int(sr/(2*(kcps+kvib))),	1

;	opcode	asig	cf			bw
a2	reson   a1*(1-inoise)+a0*inoise,  kcf1,	kbw1
a2	reson   a2,	kcf2,	kbw2
a2	reson   a2,	kcf3,	kbw3
a2	reson   a2,	kcf4,	kbw4

asig	balance a2,	a1
        out      asig
        endin

</CsInstruments>
<CsScore>
f1 	0 	8192 	10 	1

;    Instr 10 functions
;CF AND BW FOR 4-POLE RESON COMBO
;	    strt   table	GEN	prmt
f25	    0 	   513 	-8   	200 257 800 256 200
f26 	0 	   513 	-8   	50  257 150 256 50

f27 	0 	513 	-8   	700 257 1300 256 2200
f28 	0 	513 	-8   	70  257 150  256 100

f29 	0 	513 	-8   	2200 257 2500 256 3000
f30 	0 	513 	-8   	150  257 200  256 150

f31 	0 	513 	-8   	3500 257 3500 256 3700
f32 	0 	513 	-8   	150  257 300  256 150


;    Instr 10 score
;     st   dur  pch1 pch2   tmb1    tmb2  amp1 amp2
;------------------------------------------------------------------------------
i10   0    .5   0    8.00   8.04     0    .1   5000 8000 .1
i10   +    .3   .    7.10   7.08    .1    .2   7000 3000 .2
i10   +    .4   .    7.11   7.105   .2    .4   3000 5000 .3
i10   +    .65  .    7.065  7.08    .3    .2   4000 5000 .4
i10   +    .25  .    7.085  8.083   .4    .7   3000 4500 .5
i10   +    .8   .    8.02   8.0133  .5    .6   8000 4000 .6
i10   +    .3   .    8.0117 8.0066  .6     1   5000 3000 .7
i10   +    .6   .    8.00   8.04     0    .1   5000 8000 .1
i10   +    .8   .    6.10   7.08    .1    .2   7000 3000 .2
i10   +    .4   .    5.11   7.105   .2    .4   3000 5000 .3
i10   +    .65  .    7.165  7.08    .3    .2   4000 5000 .4
i10   +    .25  .    7.285  8.083   .4    .7   3000 4500 .5
i10   +    .3   .    8.42   8.0133  .5    .6   8000 4000 .6
i10   +    .7   .    8.0117 8.0066  .6     1   5000 3000 .7

e

</CsScore>
</CsoundSynthesizer>
