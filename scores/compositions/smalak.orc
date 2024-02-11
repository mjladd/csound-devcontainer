sr		=		44100
kr		=		4410
ksmps	=		10
nchnls	=		1


		instr 109							; P-FIELD FM
a1 		foscil 	p4, p5, p12, p13, p14, p15  
		out 		a1
		endin

		instr 2
a1 		oscil 	p4, p5, 20 				; p4 = AMP
		out 		a1 						; p5 = FREQ
		endin

		instr 105
a1 		grain 	1000, 120, 55,  10000,  10,  .05,  1,  3, 1
		out 		a1
		endin

		instr  1
idur    	init   	p3
iamp    	init   	p4
ifqc    	init   	p5
ifqc2   	init   	p6
ax      	init   	p7
ay      	init   	p8
az      	init   	p9
is      	init   	p10
ir      	init   	p11
ib      	init   	p16
ih      	init   	p17
ilfo    	init   	p18
ipantab 	init   	p19
kclkold 	init   	-1
kpan    	oscil  	1, 1/idur, ipantab
kclknew 	oscil  	1, ilfo/p3/2, 3
	if 	(kclkold==kclknew) 	goto next
ax      	=   		p7
ay      	=   		p8
az      	=   		p9
next:
kclkold   =   		kclknew
;kamp    	linseg 	0, .2, iamp, idur-.21, iamp, .01, 0
kamp    	oscil  	1, ilfo/p3, 4
kamp    	=      	kamp*iamp
krez    	oscil  	1, ilfo/p3, 2
krez    	=      	1000; (krez+1)*4000+1000
kfqc    	oscil  	1, ilfo/p3, 2
kfqc    	=      	(kfqc+1)*(ifqc-ifqc2)+ifqc
axnew   	=      	ax+ih*is*(ay-ax)
aynew   	=      	ay+ih*(-ax*az+ir*ax-ay)
aznew   	=      	az+ih*(ax*ay-ib*az)

ax      	=      	axnew
ay      	=      	aynew
az      	=      	aznew

aoutx    	oscil  	1, kfqc*(1+ax), 1
aouty    	oscil  	1, kfqc*(1+ay), 1

;arezx   	reson   	asigx, krez, krez/8
;aoutx   	balance 	arezx, asigx
;arezy   	reson   	asigy, krez, krez/8
;aouty   	balance 	arezy, asigy
		out    	aoutx*kamp*sqrt(kpan)
		endin

		instr 107
a1 		buzz 	10000, 20, 10, 6
		out 		a1 
		endin
