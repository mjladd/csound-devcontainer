;*********************************************
;*    	Ghosts??? (Ouspensky)                *
;*      Orchestra                            *
;*********************************************
;*    	Michael Ladd (Spring 2001)           *
;*********************************************

<CSoundSynthesizer>
<CsOptions>
;	-+S1 -+C1 -b80
</CsOptions>

<CsScore>

;======================================================================================
; 	use functions (1-9)to load soundfiles
;	strt	table	GEN	file		skip format	channel
;======================================================================================
f1	0	131072	1	"basmrmba.wav"  0	  4	    1	; 151 Hz
f2	0	131072	1	"blood.wav"	    0	  4	    1	; 194 Hz
f3	0	131072	1	"perc_1.wav"	0	  4	    1	; 259 Hz
f4	0	131072	1	"perc_4.wav"	0	  4	    1	; 884 Hz
f5	0	131072	1	"analog.wav"	0	  4	    1	; 108 Hz
f6	0	131072	1	"a3.wav"	    0	  4	    1	; 711 Hz
f7	0	131072	1	"tambura.wav"	0	  4	    1	; 1250 Hz
f8	0	131072	1	"talk.wav"	    0	  4	    1	; 237 Hz
f9 	0 	131072	1	"talk.wav"      0.001 4	    1	; offset by .001  
f10	0	131072	1	"barren.wav"	0	  4	    1	; 44 Hz
f11	0	131072	1	"marmbabck.wav"	0	  4	    1	; 151 Hz
f12	0	131072	1	"marBck.wav"	0	  4	    1	; 1552 Hz
f13	0	131072	1	"perc_4Bck.wav"	0	  4	    1	; 884 Hz
f14	0	131072	1	"glassBk.wav"	0	  4	    1	; 6359 Hz
f15	0	131072	1	"noise.wav"	    0	  4     1	;
;=======================================================================================


;==========================================================================================================
;   	Xenak_2 functions
;	strt	table	GEN	prmtrs
;==========================================================================================================
f30	0	4096	10	1   .6   .2

;=====================================================================================================================
; 	moving resonator freq function
;=====================================================================================================================
f40	0	1024	-5	.02	200	.025	300	.026	224	.0375	210	.0325	90	.0425
f41	0	1024	-5	.00162	210	.00162	290	.036	244	.036	180	.0104	100	.0104
;=====================================================================================================================

;==========================================================================================
;     Instr 4 fof Functions
;==========================================================================================
f50 	0 	1024 	19 	.5 	.5 	270 	.5
f51 	0 	512 	7 	0 	50 	.25 	50 .75 	350 	.75 	62 	0
;==========================================================================================

;============================================================
;     Copter Functions
;============================================================
f60	0	1024	10	1
f61 	0 	1024  	-8 	3	128	3	846	1
f62	0	1024	-8	1	128	2	846	.3
f63	0  	16384	9  	1	1	90
;=============================================================


;==============================================================
;     SndWarp Function
;==============================================================
f70 	0   	512	20	1         		;Hamming Window


;==============================================================
;     Rachet Functions
;==============================================================
f95	0	512	10	1					; sine
f94	0	512	7	0	64	1	16	0	; gatefn
f93	0	513	5	05	512	1			; env exp rise
f92	0	129	7	-1	129	1			; rt panfn
f91	0	129	7	1	129	-1			; pan lftfn

;	strt	table	GEN	prtl	wght	prtl	wght
f100	0	1024    19	.5 	.5 	270 	.5


;***********************************************************************************************************************

;------------------------------------
;    	Xenak_2  score
;------------------------------------
;	strt	dur	amp	freq
;------------------------------------
;	p2	p3	p4	p5
i1	1	17	2000	50
i1	10	55	2200	65
i1	25	22	1700	75
i1	53	25	2400	90
i1	70	45	2700	120
i1	117	25	2800	100
i1	125	20	2500	45
i1	133	25	2800	150
i1	160	35	2555	90
i1	165	20	2833	165
i1	177	39	2000	65

;-------------------------------------------------------
;    	high req fof 
;-------------------------------------------------------
;	strt	dur	amp	fund1	fund2	formant
;-------------------------------------------------------
;	p2	p3	p4	p5	p6	p7
;i2 	65 	12	8000	259	194	300


;-------------------------------------------------------------
;    	load samples into fog with control over pitch
;-------------------------------------------------------------
;	strt	dur	ptch	speed	ifn (choose soundfile)
;-------------------------------------------------------------
;	p2	p3	p4	p5	p6	p7
i3	45	5	.2	-.2	10	0
i3	78	6	.5	.5	10	0
i3	79	10	1	.5	8	0
i3	79.25	9.25	1	.5	9	0
i3	79.75	15	.5	.25	2	0	
i3	125	12	.6	.33	11	3
i3	150	12.25	.4	.5	10	0
i3	150.25	12.5	.3	.4	10	0
i3	163	7	.6	.4	14	0

;-----------------------------------------------
;	ins4 fof
;-----------------------------------------------
;	strt	dur	fund1	fund2	formant
;-----------------------------------------------
;	p2	p3	p4	p5	p6
i4	10	14	270	224	325
i4	15	19	110	60	200
i4	103	14	220	225	200
i4	162	12	220	227	202



;-------------------------------------------
;    	load sample and slide formant
;-------------------------------------------
;	strt	dur	freq	ifna	ifnb
;-------------------------------------------
;	p2	p3	p4	p5	p6
i7	.8	20	150	9	8
i7	41	7	212	13	13
i7	55     	10     	123.47	14	11
i7	59	12	172	14	13
i7	62	10	55	9	8
i7	115	15	233.2	13	13
i7	119	8	200	14	14
i7 	135	10	150	11	12
i7	162	15	253.2	12	12
i7	163	15	200	13	13


;----------------------------------------------------------
;    	long vocals - stretched
;----------------------------------------------------------
;	strt	dur	freq	ifna	ifnb
;----------------------------------------------------------
;	p2	p3	p4	p5	p6
;i8  	162	10    	300	7	7


;----------------------------------------------------------------------------------
; 	noise sweep
;----------------------------------------------------------------------------------
;	str	dur	amp	freq	atk	rel	cf1	cf2	bw1	bw2
;-----------------------------------------------------------------------------------
i10	0	2	.75	15000	.35	1	70	4000	10	100 
i10	170	10	.75	15000	.35	1	70	4000	100	10

;------------------------------------------------------------------------------------------
;  	copter score
;------------------------------------------------------------------------------------------
; 	Strt 	Dur 	Amp 	FqcTab 	FcoDepth  FcoPhase  SepPhase 	Q   LP/HP  BaseFco
;------------------------------------------------------------------------------------------
;	p2	p3	p4	p5	p6	  p7	    p8	 	p9  p10	   p11
i11	120	10	200	62	65	  .12       .4          80   0     200
i11	125	7	150	61	66	  .22	    .5		65   1	   300
i11	130	10	110	60	60	  .09 	    .6		50   1     450
i11	133	10	200	62	65	  .12	    .4	        85   0     400
i11	180	20	220	62	57	  .13       .5          90   0     440


;--------------------------------------------------------------------------------------
;    	sndwarp score
;--------------------------------------------------------------------------------------
;	strt	dur	amp	strfn	endfn	scpsfn	ecpsfn	window	rndwin	density	ifnsamp
;--------------------------------------------------------------------------------------
;	p2	p3	p4	p5	p6	p7	p8	p9	p10	p11	p12
i12	168	10	1.4	1	1	1	1	2000	150	25	12
i12 	185	20	1  	1  	1  	1  	1	2000	200	10	11
i12	199	5	1.2	1	1	1	1	2000	170	20	10

;--------------------------------------------------------------------------------------
; 	rachet score
;--------------------------------------------------------------------------------------
;	strt	dur    	amp     pch	lfohz	gtfn	envfn	panfn	ctoff	Q        
;--------------------------------------------------------------------------------------
;	p2	p3	p4      p5	p6	p7	p8	p9	p10	p11  
i13	30	6	16000	10.09	16	94	93	91	0	12
i13	34	4	17000	11.05	16	94	93	92	0	12
i13	186	4	18000	7.09	16	94	93	92	0	12
i13	190	3	18000	10.09	20	94	93	91	0	16
i13	191	3	18000	11.09	10	94	93	95	0	20
i13	192	7	19000	12	15	94	93	95	0	20
i13	196	8	17000	12.08	15	94	93	92	0	20


</CsScore>


<CsInstruments>
sr = 44100
kr =  4410
ksmps = 10
nchnls = 2


;-----------------------------------
;    Xenak_2 orc
;-----------------------------------

	instr 1
; 	amplitude control 
kenv1	linseg	0, 	p3*.2,	p4, 	p3*.6,	p4,  p3*.2, 	0	

;	opcode		delay	amp	dur	ifn
kosc	oscil1i		0,	1000,	p3,	40	;oscil resonator 1
kosc2	oscil1i		0,	1000,	p3,	41	;oscil resonator 2

; 	spectral control over time
;	opcode		ia, 		dur1, 	ib		dur2	 ic		dur3	ic
actr5	expseg		p5, 		p3*.8,	p5,		p3*.1, 	 p5*1.43, 	p3*.1,	p5*1.42	
actr7	expseg		p5*1.26, 	p3*.6,	p5*1.26,	p3*.2,	 p5*1.65,	p3*.2,	p5*1.65
actr4	expseg		p5*1.07,	p3*.3,	p5*1.07,	p3*.4,	 p5*1.48,	p3*.3,	p5*1.48
actr8	expseg		p5*1.19,	p3*.4,	p5*1.19,	p3*.2,   p5*1.5,	p3*.4,	p5*1.5
actr1	expseg		p5*.96,		p3*.1,	p5*.96,		p3*.8,	 p5*.71,	p3*.1,	p5*.71
actr6	expseg		p5*.74,		p3*.25,	p5*.74,		p3*.5,	 p5*.54,	p3*.25,	p5*.54
actr3	expseg		p5*.92, 	p3*.6,	p5*.92,		p3*.2,	 p5*.68,	p3*.2,	p5*.68
actr2	expseg		p5*.6, 		p3*.2,	p5*.96,		p3*.5,   p5*.66,	p3*.3,	p5*.66

; 	oscillators
;	opcode	amp	freq	ifn
a1	oscil	kenv1, 	actr1, 	30
a2	oscil	kenv1, 	actr2, 	30
a3	oscil	kenv1, 	actr3, 	30
a4	oscil	kenv1, 	actr4, 	30
a5	oscil	kenv1, 	actr5, 	30
a6	oscil	kenv1, 	actr6, 	30
a7	oscil	kenv1, 	actr7, 	30
a8	oscil	kenv1, 	actr8, 	30

asum_1 	= a1+a3+a5+a7
asum_2	= a2+a4+a6+a8

;	opcode	 asig	 kcutoff  kreson   iord    ksep		
afilt_1 vlowres  asum_1, 2000,	  kosc,	   1,      550  ;resonator 1
afilt_2 vlowres  asum_2, 2000,	  kosc2,   1,      410	;resonator 2

alpf1	tone	afilt_1, 1000
alpf2	tone	afilt_2, 1000
	outs	alpf1, alpf2 
	endin


;----------------
; high freq fof 
;----------------

	instr 2
;	opcode	ia	dur1	ib	dur2	ic
aamp	linseg	0,	p3*.3,	p4,	p3*.7,	0 
afun1	expseg	p5,	p3*.8,	p5,	p3*.2,	p6
afun2	expseg	p6,	p3*.8,	p5,	p3*.2,	p6
aform	linseg	20,	p3*.5,	820,	p3*.5,	20

;	opcode	amp,	fund	form	oct  band  rise	  dur   dec   olaps  ifna  ifnb	otdur
a1	fof	aamp,	afun1,	aform, 	0,   40,   .003,  .02,  .007, 25,    11,   100,   p3,   0,   1
a2	fof 	aamp,	afun2,	aform, 	0,   40,   .003,  .02,  .007, 25,    11,   100,   p3,   0,   1

	outs	a1*.2, a2*.2
	endin

;------------------------------------------------
; load samples into fog with control over pitch 
;------------------------------------------------

        instr 3
i1 	= sr/ftlen(1) 				;speed factor (relative to sr and table length)
a2      phasor  i1*p5   			;cps for phasor speed

;		ia	dur1	ib	dur2	ic	dur3	id
a3	linseg  0,	p3*.01,	.9,	p3*.9,	.9,	p3*.09,	0

;		ia	dur	ib	dur	ic
aoct	linseg	0,	p3*.6,	0,	p3*.4,	p7

;		amp	dens	trans phs   oct   band   rise   dur   dec   olaps fna  fnb  tdur  phase mode
a1      fog     10000,  100,    p4,   a2,   aoct, 0,    .01,   .02,   .01,  2,    10,   100,  p3,   0,    1
        outs    a1*a3*1.1, a1*a3*1.1
        endin


;------------------------------------------------
; 	ins4 fof 
;------------------------------------------------

	instr 4
;	opcode	ia	dur1	ib	dur2	ic
amp1	linseg	0,	p3*.3,	9000,	p3*.7,	0 
amp2	linseg	0,	p3*.2,	9000,	p3*.8,	0 
afun1	expseg	300,	p3*.8,	p4,	p3*.2,	325
afun2	expseg	280,	p3*.8,	p5,	p3*.2,	250
aform	linseg	20,	p3*.5,	p6,	p3*.5,	20

;	opcode	amp,	fund	form	oct  band  rise	  dur   dec   olaps  ifna  ifnb	otdur
a1	fof	amp1,	afun1,	aform, 	0,   90,   .003,  .02,  .007, 25,    51,    50,   p3,   0,   1
a2	fof 	amp2,	afun2,	aform, 	0,   103,  .003,  .02,  .007, 25,    51,    50,   p3,   0,   1

	outs      a1*.8, a2*.8
	endin



;-------------------------------
; load sample and slide formant       
;-------------------------------

        instr 7
k50     randi   .1,6,  .8135
k60     randi   .1,5,  .3111
k70     randi   .1,9,  .6711
kjitter = (k50 + k60 + k70) * p4

; 		ia	dur	ib	dur	ic	dur	id
ksing   linseg  1, 	p3*.02, 1, 	p3*.02, p4, 	p3*.96, p4

;kdur
kdur    linseg  1, 	p3*.02, 1, 	p3*.02, .5, 	p3*.96, .5
kdec    linseg  1, 	p3*.02, 1, 	p3*.02, .5, 	p3*.96, .5 	; kdec change
kenv    linseg  10000, 	p3*.02, 10000,  p3*.02, 2000, 	p3*.966, 10 	; level compensator
kf0     = ksing+kjitter

;		ia	dur	ib
ktwist  linseg  1, 	p3, 	1.2          ; slide formant left
ktwist2 linseg  1, 	p3, 	1.1          ; slide formant right

;		amp	fund	 formant  oct  band  rise  dur    dec   olaps ifna ifnb tdur  phase mode
a1      fof     kenv,   kf0,     ktwist,  0,   0,    .003, kdur,  kdec, 250,  p5,   100,  p3,   0,    1
a2      fof     kenv,   kf0,     ktwist2, 0,   0,    .003, kdur,  kdec, 250,  p6,   100,  p3,   0,    1  
        outs    a1, a2
        endin



;------------------------
; long vocals stretched 
;------------------------

	instr 8
idur = 	p3
ifq  = 	p4 
	 
; 	JITTER
k50 	randi 	.01,  1/.05,   .8135
k60 	randi 	.01,  1/.111,  .3111
k70 	randi 	.01,  1/1.219, .6711
kjitter	= (k50 + k60 + k70) * p4

kfund 	linseg 	1,	p3*.04,	1,	p3*.3,	p4,	p3*.66,	p4  ; GLIDES FROM 1Hz TO ifq
kdur 	linseg 	1,	p3*.02,	1,	p3*.02,	.5,	p3*.96,	.5   ; CHANGES SIZE OF kdur
kdec 	linseg 	1,	p3*.02,	1,	p3*.02,	.5,	p3*.96,	.5   ; CHANGES SIZES OF kdec

; 	OVERALL LEVEL ENVELOPE
kenv 	linseg 	10,	p3*.02,	10000,	p3*.02,	8000,	p3*.96,	0

kf0	= kfund+kjitter
kforms	linseg 	1,	p3,	2
 
;		amp	fund	formant  oct  band  rise  dur    dec   olaps ifna ifnb  tdur  phase mode
a1 	fof 	kenv,  	kf0, 	kforms,  0,   0,    .003, kdur,  kdec, 600,  p5,   100, idur, 0,    1
a2 	fof 	kenv, 	kf0, 	kforms,  0,   0,    .003, kdur,  kdec, 600,  p6,   100, idur, 0,    1

afilt1	tone	a1, 	2000
afilt2	tone	a2,	2010
	outs 	afilt1, afilt2
	endin


;---------------------------------
;   noise sweep
;---------------------------------

          instr 10
kenv      expseg    .001, p6, p4, p3/6, p4*.4, p3-(p6+p7+p3/6), p4*.6, p7,.01
anoise    rand	p5
kcf       expon	p8, p3, p9
kbw       line	p10, p3, p11
afilt     reson	anoise, kcf, kbw, 2
          outs	afilt*kenv, afilt*kenv
          endin

;---------------------------------
;   copter
;---------------------------------

        instr 11
iphs	= p8  ; Separation phase

anz	buzz	p4, 	300, 	28, 	63
kamp	linseg	0,	p3*.25,	p4,	p3*.5,	p4,	p3*.25,	0 	; Amp envelope
krt	oscili	1,	1/p3,	p5   					; Controls modulation frequency
asin1l  oscili  1, 	krt, 	60, 	.5+p7   			; Sine 1 is for filter Fco
asin2l  oscili  1, 	krt/2, 	60    					; Sine 2 is for amplitude modulation
arezl   rezzy   anz, 	(asin1l+1)*p6*krt+p11, 	p9, 	p10		; Make sine positive and add base fqc
aoutl   =       arezl*asin2l*2    					; Modulate amplitude
asin1r  oscili  1, 	krt, 	60, 	.25+p7  			; Controls modulation frequency
asin2r  oscili  1, 	krt/2, 	60, 	.25   				; Sine 1 is for filter Fco
arezr   rezzy   anz, 	(asin1r+1)*p6*krt+p11, 	p9, 	p10 		; Make sine postive and add base fqc
aoutr   =       arezl*asin2r*2  
        outs    aoutl*kamp, aoutr*kamp   
        endin

;---------------------------------
;   sndwarp
;---------------------------------

        instr 12
atwarp	line	p5,	p3,	p6    ; TIME SCALING
asamp	line 	p7,	p3,	p8    ; PITCH SCALING

;		amp	twarp	ptch	sndfn	strt	winsize	rndwin	olap	winfn	timemode
a1      sndwarp p4,	atwarp,	asamp,	p12,	0,	p9,	p10,	p11,	70,	0 
        outs     a1, a1
        endin


;---------------------------------
;   rachet
;---------------------------------   
     
	instr 13
icf	=	cpspch(p5)
ifc	=	(p10 == 0 ? sr/4:p10)              ; HPF cutoff default: SR/4
iq	=	(p11 == 0 ? 1:p11)                 ; filter q cannot be zero
ibw	=	icf/iq

;		amp	cps	ifn	phase
kgate	oscili	1,	p6,	p7,	0

;		del	amp	dur	ifn
kenv	oscil1i	0,	1,	p3,	p8
kpan	oscil1i	0,	.5,	p3,	p9
kpan	= 	.5+kpan

anoise	rand	p4
asig 	reson	anoise,	cpspch(p5),	ibw,	2	; band pass
asig	atone	asig,	ifc                           	; high pass
asig	atone	asig,	ifc                           	; sharp filter
asig	balance	asig,	anoise

asig	=	asig*kgate*kenv                  	; env post-balance
aleft	=	sqrt(kpan)
aright	=	sqrt(1-kpan)
	outs	asig*aleft, asig*aright
	endin


</CsInstruments>
</CsoundSynthesizer>
