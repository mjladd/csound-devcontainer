<CsoundSynthesizer>
<CsOptions>
--output=yi_scan_surfaces.aiff -r44100 -k441
</CsOptions>
<CsInstruments>
nchnls=2

ga1 init 0
ga2	init 0
ga3	init 0
gkenv	init 0
gkpch	init 440

gaexcite	init 0
galeft 	init 0
garight	init 0

	instr 1	;working instrument
kpch	= cpspch(p4)
iforce	= p6 * .0004

ain	linseg 0, 1, iforce, p3 - .1, 0

kenv	linseg 0, 1, 1, p3 -.7, 0

ifnmatrix	= p5
iscantable	 = p7

; PARAMETERS FOR SCANU
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
;kstrength	line 0, p3, .001

idisp	= 0
id	= 2

	scanu	iInit,irate,ifnvel,ifnmass,ifnmatrix,ifncenter,ifndamp,kmass,kstiff,kcenter,kdamp,ileft,iright,kpos,kstrength,ain,idisp,id

aout	scans	15000, kpch, iscantable, 2
aout 	dcblock aout
aout	= aout * kenv


aout	butterlp	aout, kpch * 8 * kenv
aout	butterlp	aout, kpch * 8 * kenv

aout	harmon	aout, kpch, .3, kpch, kpch * 1.25, 1, 110, .04

aout	butterlp 	aout, kpch * 4
aout	nreverb	aout, 1.1, .2


ga1	= ga1 + aout
ga2	= ga1 + aout

	endin

	instr 2	;feedback scanned
ain 	init 0

kpch	= cpspch(p4)
iforce	= p6 * .0004

aforce	linseg 0, 1, iforce, p3 - .1, 0

ain	= ain + aforce



kenv	line 1, p3, 0
kpch	= cpspch(p4)

ifnmatrix	= p5
iscantable	 = p7

; PARAMETERS FOR SCANU
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
;kstrength	line 0, p3, .001

idisp	= 0
id	= 2

	scanu	iInit,irate,ifnvel,ifnmass,ifnmatrix,ifncenter,ifndamp,kmass,kstiff,kcenter,kdamp,ileft,iright,kpos,kstrength,ain,idisp,id

aout	scans	30000, kpch, iscantable, 2

ain	= (aout / 30000) * .0002

aout	= aout * kenv

aout 	dcblock aout

aout	butterlp	aout, kpch * 8 * kenv
aout	butterlp	aout, kpch * 8 * kenv

aout	harmon	aout, kpch, .3, kpch, kpch * 1.25, 1, 110, .04

aout	butterlp 	aout, kpch * 4
aout	nreverb	aout, 2, .2

ga1	= ga1 + aout
ga2	= ga1 + aout
	endin

	instr 3	;double scanned
ain 	init 0

kpch	= cpspch(p4)
iforce	= p6 * .0004

aforce	linseg 0, 1, iforce, p3 - .1, 0

ain	= aforce - ain

kenv	line 1, p3, 0
kpch	= cpspch(p4)

ifnmatrix	= p5
iscantable	 = p7

; PARAMETERS FOR SCANU
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
;kstrength	line 0, p3, .001

idisp	= 0
id	= 2

	scanu	iInit,irate,ifnvel,ifnmass,ifnmatrix,ifncenter,ifndamp,kmass,kstiff,kcenter,kdamp,ileft,iright,kpos,kstrength,ain,idisp,id
	scanu iInit,irate,ifnvel,ifnmass,ifnmatrix,ifncenter,ifndamp,1,.04,kcenter,kdamp,ileft,iright,kpos,kstrength,aforce,idisp,3

aout	scans	30000, kpch, iscantable, 2
aout2	scans	30000, kpch, iscantable, 3

ain	= (aout2 / 30000) * .02
aout 	dcblock aout
aout	= aout * kenv

aout	butterlp	aout, kpch * 8 * kenv
aout	butterlp	aout, kpch * 8 * kenv

aout	harmon	aout, kpch, .3, kpch, kpch * 1.25, 1, 110, .04

aout	butterlp 	aout, kpch * 4
aout	nreverb	aout, 2, .2

ga1	= ga1 + aout
ga2	= ga1 + aout

	endin

	instr 4	;background noise
aout	pinkish	    1000
aout	butterlp 	aout, 1000
ga1 = ga1 + aout
ga2 = ga2 + aout
	endin

	instr 20	;reverb
aout	nreverb	ga1 * .7, 4, .8
outs aout + ga1, aout + ga1
ga1 = 0
ga2 = 0
	endin

</CsInstruments>
<CsScore>

;f1 0 128 7 0 64 1 64 0	; initpos
f1 0 128 7 0 128 0
f2 0 128 -7 1 128 1		; masses

f4  0 128 -7 0 128 2		; centering force
;f4  0 128 -7 1 128 2

f5 0 128 -7 1 128 1		; damping
;f5 0 128 -7 0 128 1
f6 0 128 -7 -.0 128 0		; init velocity
f7 0 128 -7 0 128 128	; trajectory

f20 0 65537 10 1
f21 0 65537 7 -1 65537 1
f22 0 65537 7 1 32768 1 1 -1 32768 -1

f100 0 16384 -23 "string-128.matrix"
f101 0 16384 -23 "torus-128_8.matrix"
f102 0 16384 -23 "steven2.matrix"
f103 0 16384 -23 "steven3-random.matrix"
f104 0 16384 -23 "steven4-random.matrix"
f105 0 16384 -23 "circularstring-128.matrix"
f106 0 16384 -23 "cylinder-128_8.matrix"



f200  0 128 -23 "spiral-8_16_128_2_1_over_2"

/*
f1  0 128 7 0 64 1 64 0
f2  0 128 -7 1 128 1
f4  0 128 -7 0 128 2
f5  0 128 -7 1 128 1
f6  0 128 -7 -.0 128 .0
f7   0 128 -7 0 128 128
*/

i4 0 [84.26137 + 4]
i20 0 [84.26137 + 4]


i1	5.836735	5.2727275	9.04	101	50	7
i1	41.863636	5.2727275	9.04	101	50	7
i1	27.222221	9.551911	8.04	102	53.0	7
i1	27.222221	11.272727	7.06	102	73.0	7
i1	28.394587	9.92	7.03	102	83.0	7
i1	0.0	5.2723813	9.03	102	50	7
i1	0.0	6.2222223	8.05	102	70	7
i1	0.64711165	5.475556	8.02	102	80	7
i1	38.0	9.551911	8.04	102	50	7
i1	38.0	11.272727	7.06	102	70	7
i1	39.172363	9.92	7.03	102	80	7
i1	11.45	5.2723813	9.03	102	50	7
i1	11.45	6.2222223	8.05	102	70	7
i1	12.097112	5.475556	8.02	102	80	7
i1	19.136364	10.181818	8.08	100	57	7
i1	0.0	6.255102	8.07	100	60	7
i1	16.227272	6.2272725	8.07	100	60	7
i1	10.3	7.9	8.00	101	60	7
i1	23.181818	7.8636365	8.00	101	60	7
i1	1.244898	7.908163	9.00	101	60	7
i1	1.7959183	8.061225	8.01	102	70	7
i1	31.681818	8.045455	8.01	102	70	7
i1	7.0	8.05	8.01	102	70	7
i1	37.272728	8.045455	8.01	102	70	7
i3	17.954546	11.636364	8.01	100	50	7
i3	0.0	11.636364	8.01	100	50	7
i1	16.775	9.469388	6.03	100	65	7
i1	2.6363637	9.409091	6.03	100	65	7
i1	29.90909	9.454545	6.03	100	65	7
i1	14.925	10.744898	6.08	100	70	7
i1	0.8877551	10.744898	6.08	100	70	7
i1	27.636364	10.727273	6.08	100	70	7
i1	49.0	10.722222	6.07	100	70	7
i1	13.2	11.65	6.01	100	70	7
i1	42.166668	11.636364	6.01	100	70	7
i1	0.0	11.67347	6.01	100	70	7
i1	25.227272	11.636364	6.01	100	70	7
i1	38.61111	11.636364	6.00	100	70	7
i1	47.72222	11.611111	6.00	100	70	7
i2	4.388889	10.444445	5.10	100	50	7
e

</CsScore>

</CsoundSynthesizer>