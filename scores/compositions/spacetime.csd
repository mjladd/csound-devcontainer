<CsoundSynthesizer>
<CsOptions>
--output=spacetime.aiff  -r44100 -k441
</CsOptions>
<CsLicence>
</CsLicence>
<CsInstruments>
;-----------------------------;
;						;
;	S		P		A	;
;		.		.		;
;						;
;	C		E		T	;
;						;
;		.		.		;
;	I		M		E	;
;						;
;		  ORCHESTRA		;
;	    BRIANANAKINCASS		;
;		kday/imnth/99		;
;-----------------------------;
;PERSISTENCE 	IN 	VARIATIONS;
;-----------------------------;




sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		2


gatic	init		0
gatoc	init		0
gaplly	init		0
gapndra	init		0

gkntrl	init		0

;KONTROL

		instr	8

ia		=		p4
idur1	=		p5
ibe		=		p6
idur2	=		p7
isee		=		p8

asig		oscil	1,1,1
ksig		linseg	ia, idur1, ibe, idur2, isee
		outs		asig, asig
gkntrl	=		ksig
		endin

;TIC
		instr	1
idur		=		p3
iamp		=		ampdb(p4)
ipris	=		p5
ipdur	=		p6
ipdcy	=		p7
irvt		=		p8
ilpt		=		p9
irvt2	=		p10
ilpt2	=		p11
idly		=		p12
ibw		=		p13
icofl	=		p14+300
icofr	=		p15+300
iprp		=		p16
itcp		=		p17
kpop		linseg	0, ipris, 1, ipdur, 1, ipdcy, 0
abrst	rand 	iamp*kpop
adly		delay	abrst, idly
apre		comb		abrst, irvt*gkntrl, ilpt
atic		comb		adly*8, irvt2*gkntrl, ilpt2
al		butterbp	(apre*iprp)+(atic*itcp), icofl-(300*gkntrl), ibw-(174*gkntrl)
ar		butterbp	(apre*(1-iprp))+(atic*(1-itcp)), icofr-(300*gkntrl), ibw-(74*gkntrl)
		outs 	al, ar

gatic	=		al+ar

		endin


;TOC
		instr	2
idur		=		p3
iamp		=		ampdb(p4)
ipris	=		p5
ipdur	=		p6
ipdcy	=		p7
irvt		=		p8
ilpt		=		p9
irvt2	=		p10
ilpt2	=		p11
idly		=		p12
ibw		=		p13
icofl	=		p14
icofr	=		p15
iprp		=		p16
itcp		=		p17
kpop		linseg	0, ipris, 1, ipdur, 1, ipdcy, 0
abrst	rand 	(iamp*kpop)/gkntrl
adly		delay	abrst*2, idly
adly2	delay	abrst, idly
apre		comb		abrst, irvt*gkntrl, ilpt
atc1		comb		adly*5, irvt2*gkntrl, ilpt2
atc2		comb		adly2*5, irvt2, ilpt2
atoc		=		atc1+atc2
al		butterbp	(apre*iprp)+(atoc*itcp), icofl-(300*gkntrl), ibw-(100*gkntrl)
ar		butterbp	(apre*(1-iprp))+(atoc*(1-itcp)), icofr-(300*gkntrl), ibw-(100*gkntrl)
outs 	al, ar

gatoc	=		al+ar

		endin


;POLLY
		instr	3
idur		=		p3
iamp		=		ampdb(p4)
ipris	=		p5
ipdur	=		p6
ipdcy	=		p7
irvt		=		idur*3
idiv		=		p8
idly		=		1/idiv
ifeed	=		p9

kpop		linseg	0, ipris, 1, ipdur, 1, ipdcy, 0
abrst	rand 	iamp*kpop
atic		comb		abrst, irvt, idly
abrst2	reson	atic*((gkntrl*.005)-.005), 1000-(100*gkntrl), 1

krand	randh	1, idly
krand1	randh	1, idiv
kenv		linseg	0, idur*.01, 1, idur*.999, 1, idur*.05, 0
abzz1	buzz		(kenv*10000)*ifeed, 65+(20*krand1)-(gkntrl*2), (krand1*3)+(6*gkntrl), 1
abzz2	buzz		(kenv*10000)*ifeed, 65+(20*(1-krand1))-(gkntrl*2), (krand1*3)+(6*gkntrl), 1
al		=		atic+abrst+abzz1+abrst2
ar		=		atic+abrst+abzz2+abrst2


		outs  	al, ar

gaplly	=		al+ar

		endin


;PANDORA
		instr	9
idur		=		p3
iamp		=		ampdb(p4)
iarisl	=		p5
iadurl	=		p6
iadcyl	=		p7
iarisr	=		p8
iadurr	=		p9
iadcyr	=		p10

ipch		=		p11
ipris	=		p12
ipch2	=		p13
ipdur	=		p14
ipdcy	=		p15
ipch3	=		p16

ivibl  	=		p17
ivrisl	=		p18
ivib2l	=		p19
ivdurl	=		p20
ivdcyl	=		p21
ivib3l	=		p22
ivibr  	=		p23
ivrisr	=		p24
ivib2r	=		p25
ivdurr	=		p26
ivdcyr	=		p27
ivib3r	=		p28

ivf  	=		p29
ivfr		=		p30
ivf2		=		p31
ivfdr	=		p32
ivfdc	=		p33
ivf3		=		p34
ivfnl 	=		p35
ivfnr	=		p36

iatrml	=		p37
iatrisl	=		p38
iatrm2l	=		p39
iatdurl	=		p40
iatdcyl	=		p41
iatrm3l	=		p42
iatfnl	=		p43
iatrmr	=		p44
iatrisr	=		p45
iatrm2r	=		p46
iatdurr	=		p47
iatdcyr	=		p48
iatrm3r	=		p49
iatfnr	=		p50

itf  	=		p51
itfr		=		p52
itf2		=		p53
itfdr	=		p54
itfdc	=		p55
itf3		=		p56
itfnl 	=		p57
itfnr	=		p58

ic   	=		p59
icris	=		p60
ic2  	=		p61
icdur	=		p62
icdcy	=		p63
ic3  	=		p64

iml   	=		p65
imrisl	=		p66
im2l  	=		p67
imdurl	=		p68
imdcyl	=		p69
im3l  	=		p70
imr   	=		p71
imrisr	=		p72
im2r  	=		p73
imdurr	=		p74
imdcyr	=		p75
im3r  	=		p76

index	=		p77
ifn		=		p78

kaenvl	linseg	0, iarisl, 1, iadurl, 1, iadcyl, 0
kaenvr	linseg	0, iarisr, 1, iadurr, 1, iadcyr, 0
kpenv	linseg	ipch, ipris, ipch2, ipdur, ipch2, ipdcy, ipch3
kvenvl	linseg	ivibl, ivrisl, ivib2l, ivdurl, ivib2l, ivdcyl, ivib3l
kvenvr	linseg	ivibr, ivrisr, ivib2r, ivdurr, ivib2r, ivdcyr, ivib3r
kvfenv	linseg	ivf, ivfr, ivf2, ivfdr, ivf2, ivfdc, ivf3
kvibl	oscil	kvenvl, kvfenv, ivfnl
kvibr	oscil	kvenvr, kvfenv, ivfnr
katenvl	linseg	iatrml, iatrisl, iatrm2l, iatdurl, iatrm2l, iatdcyl, iatrm3l
katenvr	linseg	iatrmr, iatrisr, iatrm2r, iatdurr, iatrm2r, iatdcyr, iatrm3r
katfenv	linseg	itf, itfr, itf2, itfdr, itf2, itfdc, itf3
ktrml	oscil	katenvl, katfenv, iatfnl
ktrmr	oscil	katenvr, katfenv, iatfnr
kcenv	linseg	ic, icris, ic2, icdur, ic2, icdcy, ic3
kmenvl	linseg	iml, imrisl, im2l, imdurl, im2l, imdcyl, im3l
kmenvr	linseg	imr, imrisr, im2r, imdurr, im2r, imdcyr, im3r
afml		foscil	iamp*kaenvl+ktrml, kpenv+kvibl, kcenv, kmenvl, index*gkntrl, ifn
afmr		foscil	iamp*kaenvr+ktrmr, kpenv+kvibr, kcenv, kmenvr, index*gkntrl, ifn

		outs		afml, afmr
gapndra	=		afml+afmr
		endin



 instr 99

irevfactor =        p4
ilowpass   =        9000
ioutputscale =      p5

idel1     =         1237.000/sr
idel2     =         1381.000/sr
idel3     =         1607.000/sr
idel4     =         1777.000/sr
idel5     =         1949.000/sr
idel6     =         2063.000/sr
idel7     =         307.000/sr
idel8     =         97.000/sr
idel9     =         71.000/sr
idel10    =         53.000/sr
idel11    =         47.000/sr
idel12    =         37.000/sr
idel13    =         31.000/sr

icsc1     =         .822 * irevfactor
icsc2     =         .802 * irevfactor
icsc3     =         .773 * irevfactor
icsc4     =         .753 * irevfactor
icsc5     =         .753 * irevfactor
icsc6     =         .753 * irevfactor

icsc7     =         .7 * irevfactor
asig      =         gatic+gatoc+gaplly+gapndra
acomb1    comb      asig, icsc1*(gkntrl*.5), idel1
acomb2    comb      asig, icsc2*(gkntrl*.5), idel2
acomb3    comb      asig, icsc3*(gkntrl*.5), idel3
acomb4    comb      asig, icsc4*(gkntrl*.5), idel4
acomb5    comb      asig, icsc5*(gkntrl*.5), idel5
acomb6    comb      asig, icsc6*(gkntrl*.5), idel6

acomball  =         acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1     alpass    acomball, icsc7, idel7
allp2     alpass    allp1, icsc7, idel8
allp3     alpass    allp2, icsc7, idel9
alow      tone      allp3, ilowpass
allp4     alpass    alow, icsc7, idel10
allp5     alpass    allp4, icsc7, idel12
arevout  =         allp5 * ioutputscale



          outs      arevout, arevout



gaplly	=		0
gatic	=		0
gatoc	=		0
gapndra	=		0

		endin

</CsInstruments>
<CsScore>
;*****************************************************************************
;*****************************************************************************
f1   0    4096 10 1
f2  0   4096   8  1.000000 2048 -1.000000 2048 1.000000
f3  0     512   5 256 512 1                                ;exp DOWN
f4   0    512    5  1    512  256                                          ;EXP UP
f5 0      512   7 1      512 0 0                                ;line down
f6 0      512   7 0      512 1 0                                ;line up
;KNTRL
;i   s    d    a    d1   b    d2   c
i8   0    180  1    60   1    120  10



; INS     STRT     DUR      RVBTIME    RVBRETURN
  i99      0       140       .777        .03
;7   T         I         C         K
;1   2    3    4    5         6         7         8         9         10        11        12        13        14        15        16        17
;I   S    D    A    /         -         \         RVT       LPT       RVT2      LPT2      DLY       BW        BPL       BPR       PRP       TKP
i1   0    1    75   .001      .001      .005      .01       .018      .05       .02       .036      1000      2000      2000      .5        .5
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i1   +    .    .    .         .         .         .         .         .         .         .         .         .         .         1         1
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i1   +    .    .    .01       .01       .05       .         .         .         .         .         .         .         .         1         1





;    T         O         C         K
;1   2    3    4    5         6         7         8         9         10        11        12        13        14        15        16        17
;I   S    D    A    /         -         \         RVT       LPT       RVT2 LPT2 DLY       BW        BPL       BPR       PRP       TKP
i2   .5   1    75   .001 .001 .005 .04       .018      .1        .02       .036      750       2000 2000 .5        .5
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         >         >
i2   +    .    .    .         .         .         .         .         .         .         .         .         .         .         0         0

i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    >         >         >         .         .         .         .         .         .         .         .         .         .
i2   +    .    .    .01       .1        .05       .         .         .         .         .         .         .         .         0         0














;    P         O         L         L         Y
;1   2    3    4    5         6         7         8         9
;I   S    D    A    /         -         \         DIV       FEED
i3   10   3    70   .001      .001      .005      3         0
i.   +    .    .    .         >         .         .         .
i.   +    .    .    .         >         .         .         .
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         >         >
i.   +    .    .    .         >         .         5         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    .    .    .         >         .         .         >
i.   +    30   .    .         .01       .         .         .75

;1   2    3    4     5        6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23        24        25        26        27        28        29        30        31        32        33        34        35        36        37        38        39        40        41        42        43        44        45        46        47        48        49        50        51        52        53        54        55        56        57        58        59        60        61        62        63        64        65        66        67        68        69        70        71        72        73        74        75        76        77        78
;i   s    d    a     arisl    adurl     adcyl     arisr     adurr     adcyr     pch       pris pch2 pchdr     pchdc     pch3 vibl vrsl vib2l     vdrl vdcl vib3l     vibr vrsr vib2r     vdrr vdcr vib3r     vf        vfr       vf2       vfdr vfdc vf3       vfnl vfnr trl       trisl     tr2l trdrl     trdcl     tr3l tfnl trr       trisr     tr2r trdrr     trdcr     tr3r tfnr tf        tfr       tf2       tfdr tfdc tf3       tfnl tfnr c         cr        c2        cdr       cdc       c3        ml        mrl       m2l       mdrl mdcl m3l       mr        mrr       m2r       mdrr mdcr m3r       ndx       fn
i9  10    141  60   60        60        20        60        75        5         50        10        50        10        10        50        .01       20        .01       40        80        9         .01       20        .01       40        80        9         0         20        0         40        80        3         5         6         0         70        0         10        50        500       1         0         70        0         10        50        500       2         0         20        .25       20        100       1         5         6         1         60        1         60        20        1         1         60        9         40        30        18        1         60        9         40        30        18        1         1

e

</CsScore>
</CsoundSynthesizer>

