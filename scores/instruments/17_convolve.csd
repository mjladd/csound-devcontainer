<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441
</CsOptions>

<CsInstruments>
		strset 	10, "hellorcb.aif"
 		strset 	11, "120_BT_Fast_Satellite.wav"
 		strset 	12, "door3.con"
 		strset 	13, "cymbal.con"
 		strset 	14, "gaussReverb.con"
 		strset 	15, "120_BT_Fast_Satellite.con"
 
 		instr  	1  
 iscale 	= 		p4
 itrans 	= 		p5
 isource	=		p6
 ifilter	= 		p7
 aa 		diskin2  	isource, itrans
 ab 		convolve 	aa, ifilter
 		out		ab*iscale
    		endin
    		
</CsInstruments>
<CsScore>
; ==========================================
 ; P1  P2    P3   P4    P5     P6      P7
 ; INS STRT  DUR  AMP   TRANS  SOURCE  FILTER
 ; ==========================================
   i1  0     6    .01   1      10      12
  s
   i1  0     7    .01   1.1    10      13
  s
   i1  0     12   .01   0.6    10      14
  s
   i1  0     5    .01   1.5   10      15
  s
   i1  0     6    .01    1     11      12
  s
   i1  0     7    .01    1.1   11      13
  s
   i1  0     12   .01    0.6   11      14
  s
   i1  0     5    .01   1.5   11      15
      
</CsScore>

</CsoundSynthesizer>