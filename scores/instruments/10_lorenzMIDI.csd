<CsoundSynthesizer>

<CsOptions>
-odac -r44100 -k441 -M1 -Fplkbass.mid
</CsOptions>

<CsInstruments>
   maxalloc 1,4

  gisin  ftgen   8, 0, 8192, 10, 1
         ctrlinit  1, 10,10,   11, 67,   12, 90,  13, 51
         
 		instr 	1
   icps	cpsmidi
   iamp	ampmidi		20000
   
   kmod	midic7	10,0,4	
   					
   ksv          midic7  11,.1,5    ; THE PRANDTL NUMBER OR SIGMA
   krv          midic7  12, 2, 12  ; THE RAYLEIGH NUMBER
   kbv          midic7  13, .1,1.6 ; RATIO OF THE LENGTH AND WIDTH OF THE BOX
   ax, ay, az   lorenz   ksv, krv, kbv, .01, .6, .6, .6, 1
   kx    downsamp      ax
   ky    downsamp  ay
   kz  downsamp       az              
   kenv	madsr	.1, .2, .5, .6
   afm	foscil	kenv*iamp, icps, 0, kx, kmod*ky*(iamp/2000), 8				
 		out		afm
 		endin
</CsInstruments>

<CsScore>
 f0  60  
</CsScore>

</CsoundSynthesizer>