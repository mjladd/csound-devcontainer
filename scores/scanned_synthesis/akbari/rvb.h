#define xrvb0s(in'outL'outR'IR'dry)
#
;convolve-based reverb (from Varga István EffectProc. file)(not usable for MIDI events)
;dry!=0 output the default (suggested) wet/dry mix
;dry=0  output only the wet signal

if $dry. = 0 igoto xrvb0swet

iwet table 3*($IR.-1)+3,206
idry table 3*($IR.-1)+2,206
iwet = iwet*.01
idry = idry*.01
igoto xrvb0snext

xrvb0swet:
iwet = 1
idry = 0

xrvb0snext:
ilnth	=  p3					/* envelope to eliminate clicks */
kenv	linseg 1,ilnth+0.05,1,0.025,0,1,0 /* just some declicking stuff */
aenv	interp kenv
ismp_frames 	table 3*($IR.-1)+1,206	/* reverb length in samples*/
irvlen	= ismp_frames /sr			/* reverb length in seconds */
;ftable 206 stores the IR lengh,dry&wet mix of each convolve.m file at locations 3(m-1)+(0,1,2) respect.
print ismp_frames,idry,iwet

p3	=  p3+(2*irvlen)+0.1 /* expand the event duration accordingly */

irvlen	=  int(((irvlen*sr)+ksmps-0.5)/ksmps)/kr	/* convert reverb length */

axL	delay $in.*aenv,irvlen			/* sync. output with reverb delay */
axR	delay $in.*aenv,irvlen			/* assumes a MONO input by now */

aL,aR	convolve $in.*aenv,$IR	/* reverberate input */

$outL.=  iwet*aL+idry*axL	/* mix with dry signal */
$outR.=  iwet*aR+idry*axR
#

#define rvb1m(in'out)
#
; MN3011 BBD Reverb
;Cook
;default values
ilevl    = 1.00   ; Output level
idelay   = 2.00   ; Delay factor
ifdbk    = 0.25   ; Feedback
iecho    = 0.25   ; Reverb amount

afdbk    init 0

$in.      = $in. + afdbk*ifdbk

atemp    delayr  1
atap1    deltapi .0396*idelay
atap2    deltapi .0662*idelay
atap3    deltapi .1194*idelay
atap4    deltapi .1726*idelay
atap5    deltapi .2790*idelay
atap6    deltapi .3328*idelay
         delayw  $in.

afdbk    butterlp  atap6, 7000
abbd     sum  atap1, atap2, atap3, atap4, atap5, atap6

abbd     butterlp  abbd, 7000

$out.      = (abbd*iecho)*ilevl
;removed dry signal from the mix (d/w was 1:.25, already coded, so just put a d/w mix of 1:1))(JCN)
#

#define xrvb2s(in'outL'outR'gain'pitchmod'fco)
#
; 8 delay line FDN reverb, with feedback matrix based upon
; physical modeling scattering junction of 8 lossless waveguides
; of equal characteristic impedance. Based on Julius O. Smith III,
; "A New Approach to Digital Reverberation using Closed Waveguide
; Networks," Proceedings of the International Computer Music
; Conference 1985, p. 47-53 (also available as a seperate
; publication from CCRMA), as well as some more recent papers by
; Smith and others.
;
; Coded by Sean Costello, October 1999

afilt1 init 0
afilt2 init 0
afilt3 init 0
afilt4 init 0
afilt5 init 0
afilt6 init 0
afilt7 init 0
afilt8 init 0

; Delay times chosen to be prime numbers.
; Works with sr=44100 ONLY. If you wish to
; use a different delay time, find some new
; prime numbers that will give roughly the
; same delay times for the new sampling rate.
; Or adjust to taste.
idel1 = (2473.000/sr)
idel2 = (2767.000/sr)
idel3 = (3217.000/sr)
idel4 = (3557.000/sr)
idel5 = (3907.000/sr)
idel6 = (4127.000/sr)
idel7 = (2143.000/sr)
idel8 = (1933.000/sr)

igain = $gain.
		    ; gain of reverb. Adjust empirically
                ; for desired reverb time. .6 gives
                ; a good small "live" room sound, .8
                ; a small hall, .9 a large hall,
                ; .99 an enormous stone cavern.

ipitchmod = $pitchmod.
		    ; amount of random pitch modulation
                ; for the delay lines. 1 is the "normal"
                ; amount, but this may be too high for
                ; held pitches such as piano tones.
                ; Adjust to taste.

itone = $fco.
		    ; Cutoff frequency of lowpass filters
                ; in feedback loops of delay lines,
                ; in Hz. Lower cutoff frequencies results
                ; in a sound with more high-frequency
                ; damping.

; k1-k8 are used to add random pitch modulation to the
; delay lines. Helps eliminate metallic overtones
; in the reverb sound.
k1      randi   .001, 3.1, .06
k2      randi   .0011, 3.5, .9
k3      randi   .0017, 1.11, .7
k4      randi   .0006, 3.973, .3
k5      randi   .001, 2.341, .63
k6      randi   .0011, 1.897, .7
k7      randi   .0017, 0.891, .9
k8      randi   .0006, 3.221, .44

; apj is used to calculate "resultant junction pressure" for
; the scattering junction of 8 lossless waveguides
; of equal characteristic impedance. If you wish to
; add more delay lines, simply add them to the following
; equation, and replace the .25 by 2/N, where N is the
; number of delay lines.
apj = .25 * (afilt1 + afilt2 + afilt3 + afilt4 + afilt5 + afilt6 + afilt7 + afilt8)

adum1   delayr  1
adel1   deltapi idel1 + k1 * ipitchmod
        delayw  $in. + apj - afilt1

adum2   delayr  1
adel2   deltapi idel2 + k2 * ipitchmod
        delayw  $in. + apj - afilt2

adum3   delayr  1
adel3   deltapi idel3 + k3 * ipitchmod
        delayw  $in. + apj - afilt3

adum4  delayr  1
adel4   deltapi idel4 + k4 * ipitchmod
        delayw  $in. + apj - afilt4

adum5   delayr  1
adel5   deltapi idel5 + k5 * ipitchmod
        delayw  $in. + apj - afilt5

adum6   delayr  1
adel6   deltapi idel6 + k6 * ipitchmod
        delayw  $in. + apj - afilt6

adum7   delayr  1
adel7   deltapi idel7 + k7 * ipitchmod
        delayw  $in. + apj - afilt7

adum8   delayr  1
adel8   deltapi idel8 + k8 * ipitchmod
        delayw  $in. + apj - afilt8

; 1st order lowpass filters in feedback
; loops of delay lines.
afilt1  tone    adel1 * igain, itone
afilt2  tone    adel2 * igain, itone
afilt3  tone    adel3 * igain, itone
afilt4  tone    adel4 * igain, itone
afilt5  tone    adel5 * igain, itone
afilt6  tone    adel6 * igain, itone
afilt7  tone    adel7 * igain, itone
afilt8  tone    adel8 * igain, itone

; The outputs of the delay lines are summed
; and sent to the stereo outputs. This could
; easily be modified for a 4 or 8-channel
; sound system.
$outL. = (afilt1 + afilt3 + afilt5 + afilt7)
$outR. = (afilt2 + afilt4 + afilt6 + afilt8)
#

#define rvb3s(in'outL'outR)
#
;reverb for Costello´s phased string ensemble
; by Sean Costello, August 23-26, 1999
      	; Simple implementation of Feedback Delay Network (FDN)
		; reverb, as described by John Stautner and Miller 
		; Puckette, "Designing Multi-Channel Reverberators," 
		; Computer Music Journal, Vol. 6, No. 1, Spring 1982,
		; p.52-65. This version sticks to implementing the 
		; basic FDN structure, and leaves out most of the
		; FIR multitap delay lines and filtering used for
		; the early reflections. For sounds with non-percussive
		; attacks, this simple implementation works great.

afilt1 init 0
afilt2 init 0
afilt3 init 0
afilt4 init 0

igain = .93 * 0.70710678117 ; gain of reverb
ipitchmod = 1.2    	       ; amount of random pitch mod, between 0 and 1
idelaytime = 1	             ; controls overall length of delay lines
ifilt = 7000			 ; controls cutoff of lowpass filters at 
				       ; outputs of delay lines
ifreq = 1		       ; controls frequency of random noise

kgain 	linseg	.94, 66, .94, 2, 1, p3 - 68, 1
k1 randi .001, 3.1 * ifreq, .06
k2 randi .0011, 3.5 * ifreq, .9
k3 randi .0017, 1.11 * ifreq, .7
k4 randi .0006, 3.973 * ifreq, .3

atap	multitap $in. , 0.00043, 0.0215, 0.00268, 0.0298, 0.00485, 0.0572, 0.00595, 0.0708, 0.00741, 0.0797, 0.0142, 0.134, 0.0217, 0.181, 0.0272, 0.192, 0.0379, 0.346, 0.0841, 0.504

adum1 delayr 0.072 
adel1 deltapi 0.0663 * idelaytime + k1 * ipitchmod
 delayw $in. + afilt2 + afilt3

adum2 delayr 0.082 
adel2 deltapi 0.0753 * idelaytime + k2 * ipitchmod
 delayw $in. - afilt1 - afilt4

adum3 delayr 0.095
adel3 deltapi 0.0882 * idelaytime + k3 * ipitchmod
 delayw $in. + afilt1 - afilt4

adum4 delayr 0.11
adel4 deltapi 0.0971 * idelaytime + k4 * ipitchmod
 delayw $in. + afilt2 - afilt3

afilt1 tone adel1 * igain, ifilt
afilt2 tone adel2 * igain, ifilt
afilt3 tone adel3 * igain, ifilt
afilt4 tone adel4 * igain, ifilt

$outL. = afilt1 + afilt2 + atap
$outR. = afilt4 + afilt3 + atap
#

#define xrvb3s(in'outL'outR'gain'pitchmod'delaytime'filt'freq)
#
; by Sean Costello, August 23-26, 1999
      	; Simple implementation of Feedback Delay Network (FDN)
		; reverb, as described by John Stautner and Miller 
		; Puckette, "Designing Multi-Channel Reverberators," 
		; Computer Music Journal, Vol. 6, No. 1, Spring 1982,
		; p.52-65. This version sticks to implementing the 
		; basic FDN structure, and leaves out most of the
		; FIR multitap delay lines and filtering used for
		; the early reflections. For sounds with non-percussive
		; attacks, this simple implementation works great.

afilt1 init 0
afilt2 init 0
afilt3 init 0
afilt4 init 0


igain = $gain. * 0.70710678117   ; gain of reverb
ipitchmod = $pitchmod.    		; amount of random pitch mod, between 0 and 1
idelaytime = $delaytime.		; controls overall length of delay lines
ifilt = $filt.			; controls cutoff of lowpass filters at 
					; outputs of delay lines
ifreq = $freq.			; controls frequency of random noise

kgain 	linseg	.94, 66, .94, 2, 1, p3 - 68, 1
k1 randi .001, 3.1 * ifreq, .06
k2 randi .0011, 3.5 * ifreq, .9
k3 randi .0017, 1.11 * ifreq, .7
k4 randi .0006, 3.973 * ifreq, .3

atap	multitap $in. , 0.00043, 0.0215, 0.00268, 0.0298, 0.00485, 0.0572, 0.00595, 0.0708, 0.00741, 0.0797, 0.0142, 0.134, 0.0217, 0.181, 0.0272, 0.192, 0.0379, 0.346, 0.0841, 0.504

adum1 delayr 0.072 
adel1 deltapi 0.0663 * idelaytime + k1 * ipitchmod
 delayw $in. + afilt2 + afilt3

adum2 delayr 0.082 
adel2 deltapi 0.0753 * idelaytime + k2 * ipitchmod
 delayw $in. - afilt1 - afilt4

adum3 delayr 0.095
adel3 deltapi 0.0882 * idelaytime + k3 * ipitchmod
 delayw $in. + afilt1 - afilt4

adum4 delayr 0.11
adel4 deltapi 0.0971 * idelaytime + k4 * ipitchmod
 delayw $in. + afilt2 - afilt3

afilt1 tone adel1 * igain, ifilt
afilt2 tone adel2 * igain, ifilt
afilt3 tone adel3 * igain, ifilt
afilt4 tone adel4 * igain, ifilt

$outL. = afilt1 + afilt2 + atap
$outR. = afilt4 + afilt3 + atap
#


#define rvb4s(inL'inR'outL'outR'preset)
#
;----------------------------------------------------------------------
; MULTI-FEEDBACK REVERBS
; BY HANS MIKELSON
;----------------------------------------------------------------------

; CURRENT PRESETS :1-caveman 2-bathroom 3-live room 4-cathedral 5-medium room 6-dead room

;----------------------------------------------------------------------------------
; 4 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
if $preset. = 1 igoto caveman
if $preset. = 2 igoto bathroom
if $preset. = 3 igoto liveroom
if $preset. = 4 igoto cathedral
if $preset. = 5 igoto mediumroom
if $preset. = 6 igoto deadroom

caveman:
;LEFT
ifdbkL   	=        	1.5/4
ifco1L   	=        	3000
ifco2L   	=        	3000*5/(5+18*(1-.8))
ifco3L   	=        	3000*5/(5+24*(1-.8))
ifco4L   	=        	3000*5/(5+30*(1-.8))
itim1L   	=        	5/1000
itim2L   	=        	18/1000
itim3L   	=        	24/1000
itim4L   	=        	30/1000
ifchp   		=        	400
;RIGHT
ifdbkR    	=        	1.5/4
ifco1R   	=        	3000
ifco2R    	=        	3000*7/(7+11*(1-.8))
ifco3R    	=        	3000*7/(7+29*(1-.8))
ifco4R    	=        	3000*7/(7+34*(1-.8))
itim1R    	=        	7/1000
itim2R    	=        	11/1000
itim3R    	=        	29/1000
itim4R    	=        	34/1000
ifchpR    	=        	400
igoto next

bathroom:
;LEFT
ifdbkL   	=        	1.1/4
ifco1L   	=        	8000
ifco2L   	=        	8000*25/(25+45*(1-.8))
ifco3L   	=        	8000*25/(25+58*(1-.8))
ifco4L   	=        	8000*25/(25+73*(1-.8))
itim1L   	=        	25/1000
itim2L   	=        	45/1000
itim3L   	=        	58/1000
itim4L   	=        	73/1000
ifchp   		=        	200
;RIGHT
ifdbkR    	=        	1.1/4
ifco1R    	=        	8000
ifco2R    	=        	8000*22/(22+41*(1-.8))
ifco3R    	=        	8000*22/(22+53*(1-.8))
ifco4R    	=        	8000*22/(22+77*(1-.8))
itim1R    	=        	22/1000
itim2R    	=        	41/1000
itim3R    	=        	53/1000
itim4R    	=        	77/1000
ifchpR    	=        	200
igoto next

liveroom:
;LEFT
ifdbkL   	=        	1.1/4
ifco1L   	=        	8010
ifco2L   	=        	8010*45/(45+74*(1-.8))
ifco3L   	=        	8010*45/(45+103*(1-.8))
ifco4L   	=        	8010*45/(45+154*(1-.8))
itim1L   	=        	45/1000
itim2L   	=        	74/1000
itim3L   	=        	103/1000
itim4L   	=        	154/1000
ifchp   		=        	200
;RIGHT
ifdbkR    	=        	1.1/4
ifco1R    	=        	8200
ifco2R    	=        	8200*42/(42+74*(1-.8))
ifco3R    	=        	8200*42/(42+103*(1-.8))
ifco4R    	=        	8200*42/(42+154*(1-.8))
itim1R    	=        	42/1000
itim2R    	=        	74/1000
itim3R    	=        	103/1000
itim4R    	=        	154/1000
ifchpR    	=        	200
igoto next

cathedral:
;LEFT
ifdbkL   	=        	1.1/4
ifco1L   	=        	8010
ifco2L   	=        	8010*75/(75+163*(1-.8))
ifco3L   	=        	8010*75/(75+294*(1-.8))
ifco4L   	=        	8010*75/(75+493*(1-.8))
itim1L   	=        	75/1000
itim2L   	=        	163/1000
itim3L   	=        	294/1000
itim4L   	=        	493/1000
ifchp  	 	=        	200
;RIGHT
ifdbkR    	=        	1.1/4
ifco1R    	=        	8200
ifco2R    	=        	8200*72/(72+164*(1-.8))
ifco3R    	=        	8200*72/(72+293*(1-.8))
ifco4R    	=        	8200*72/(72+474*(1-.8))
itim1R    	=        	72/1000
itim2R    	=        	164/1000
itim3R    	=        	293/1000
itim4R    	=        	474/1000
ifchpR    	=        	200
igoto next

mediumroom:
;LEFT
ifdbkL   	=        	1.0/4
ifco1L   	=        	4010
ifco2L   	=        	4010*45/(45+73*(1-.8))
ifco3L   	=        	4010*45/(45+104*(1-.8))
ifco4L   	=        	4010*45/(45+163*(1-.8))
itim1L   	=        	45/1000
itim2L   	=        	73/1000
itim3L   	=        	104/1000
itim4L   	=        	163/1000
ifchp   		=        	200
;RIGHT
ifdbkR    	=        	1.0/4
ifco1R    	=        	4200
ifco2R    	=        	4200*42/(42+74*(1-.8))
ifco3R    	=        	4200*42/(42+103*(1-.8))
ifco4R    	=        	4200*42/(42+154*(1-.8))
itim1R    	=        	42/1000
itim2R    	=        	74/1000
itim3R    	=        	103/1000
itim4R    	=        	154/1000
ifchpR    	=        	200
igoto next

deadroom:
;LEFT
ifdbkL   	=        	.25/4
ifco1L   	=        	2010
ifco2L   	=        	2010*45/(45+73*(1-.8))
ifco3L   	=        	2010*45/(45+104*(1-.8))
ifco4L   	=        	2010*45/(45+163*(1-.8))
itim1L   	=        	45/1000
itim2L   	=        	73/1000
itim3L   	=        	104/1000
itim4L   	=        	163/1000
ifchp   		=        	100
;RIGHT
ifdbkR    	=        	.25/4
ifco1R    	=        	2200
ifco2R    	=        	2200*42/(42+74*(1-.8))
ifco3R    	=        	2200*42/(42+103*(1-.8))
ifco4R    	=        	2200*42/(42+164*(1-.8))
itim1R    	=        	42/1000
itim2R    	=        	74/1000
itim3R    	=        	103/1000
itim4R    	=        	164/1000
ifchpR    	=        	100
igoto next

next:

aflt1L	init     	0
aflt2L  	init     	0
aflt3L  	init     	0
aflt4L  	init     	0


adel1L  	delay  $inL.+( aflt1L+aflt2L-aflt3L-aflt4L)*ifdbkL,itim1L ; Loop 1
adel2L  	delay  $inL.+(-aflt1L+aflt2L-aflt3L+aflt4L)*ifdbkL,itim2L ; Loop 2
adel3L  	delay  $inL.+( aflt1L-aflt2L+aflt3L-aflt4L)*ifdbkL,itim3L ; Loop 3
adel4L  	delay  $inL.+(-aflt1L-aflt2L+aflt3L+aflt4L)*ifdbkL,itim4L ; Loop 4

; FC, VOL, Q
aflt1L   	pareq     adel1L,  ifco1L, .5, .4, 2
aflt2L   	pareq     adel2L,  ifco2L, .5, .4, 2
aflt3L   	pareq     adel3L,  ifco3L, .5, .4, 2
aflt4L   	pareq     adel4L,  ifco4L, .5, .4, 2

$outL.    	butterhp 	aflt1L+aflt2L+aflt3L+aflt4L, ifchp 			; COMBINE OUTPUTS

aflt1R    	init     	0
aflt2R    	init     	0
aflt3R    	init     	0
aflt4R    	init     	0


adel1R  	delay $inR.+( aflt1R+aflt2R-aflt3R-aflt4R)*ifdbkR, itim1R ; Loop 1
adel2R  	delay $inR.+(-aflt1R+aflt2R-aflt3R+aflt4R)*ifdbkR, itim2R ; Loop 2
adel3R  	delay $inR.+( aflt1R-aflt2R+aflt3R-aflt4R)*ifdbkR, itim3R ; Loop 3
adel4R  	delay $inR.+(-aflt1R-aflt2R+aflt3R+aflt4R)*ifdbkR, itim4R ; Loop 4

; FC, VOL, Q
aflt1R   	pareq     adel1R,  ifco1R, .5, .4, 2
aflt2R   	pareq     adel2R,  ifco2R, .5, .4, 2
aflt3R   	pareq     adel3R,  ifco3R, .5, .4, 2
aflt4R   	pareq     adel4R,  ifco4R, .5, .4, 2

$outR.    	butterhp 	aflt1R+aflt2R+aflt3R+aflt4R, ifchp 			; COMBINE OUTPUTS
#


#define xrvb4s(inL'inR'outL'outR'fdbk'fco'dlt1L'dlt2L'dlt3L'dlt4L'dlt1R'dlt2R'dlt3R'dlt4R'fchp)
#

;----------------------------------------------------------------------------------
; 4 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
;LEFT
ifdbkL   	=        	$fdbk./4
ifco1L   	=        	$fco.
ifco2L   	=        	$fco.*$dlt1L./($dlt1L.+$dlt2L.*(1-.8))
ifco3L   	=        	$fco.*$dlt1L./($dlt1L.+$dlt3L.*(1-.8))
ifco4L   	=        	$fco.*$dlt1L./($dlt1L.+$dlt4L.*(1-.8))
itim1L   	=        	$dlt1L./1000
itim2L   	=        	$dlt2L./1000
itim3L   	=        	$dlt3L./1000
itim4L   	=        	$dlt4L./1000
ifchp   		=        	$fchp.
;RIGHT
ifdbkR    	=        	$fdbk./4
ifco1R   	=        	$fco.
ifco2R   	=        	$fco.*$dlt1R./($dlt1R.+$dlt2R.*(1-.8))
ifco3R   	=        	$fco.*$dlt1R./($dlt1R.+$dlt3R.*(1-.8))
ifco4R   	=        	$fco.*$dlt1R./($dlt1R.+$dlt4R.*(1-.8))
itim1R   	=        	$dlt1R./1000
itim2R   	=        	$dlt2R./1000
itim3R   	=        	$dlt3R./1000
itim4R   	=        	$dlt4R./1000
ifchpR    	=        	$fchp.

aflt1L	init     	0
aflt2L  	init     	0
aflt3L  	init     	0
aflt4L  	init     	0


adel1L  	delay	$inL.+( aflt1L+aflt2L-aflt3L-aflt4L)*ifdbkL, itim1L ; Loop 1
adel2L  	delay	$inL.+(-aflt1L+aflt2L-aflt3L+aflt4L)*ifdbkL, itim2L ; Loop 2
adel3L  	delay	$inL.+( aflt1L-aflt2L+aflt3L-aflt4L)*ifdbkL, itim3L ; Loop 3
adel4L  	delay	$inL.+(-aflt1L-aflt2L+aflt3L+aflt4L)*ifdbkL, itim4L ; Loop 4

; FC, VOL, Q
aflt1L   	pareq     adel1L,  ifco1L, .5, .4, 2
aflt2L   	pareq     adel2L,  ifco2L, .5, .4, 2
aflt3L   	pareq     adel3L,  ifco3L, .5, .4, 2
aflt4L   	pareq     adel4L,  ifco4L, .5, .4, 2

$outL.    	butterhp 	aflt1L+aflt2L+aflt3L+aflt4L, ifchp 			; COMBINE OUTPUTS

aflt1R    	init     	0
aflt2R    	init     	0
aflt3R    	init     	0
aflt4R    	init     	0


adel1R  	delay $inR.+( aflt1R+aflt2R-aflt3R-aflt4R)*ifdbkR, itim1R ; Loop 1
adel2R  	delay $inR.+(-aflt1R+aflt2R-aflt3R+aflt4R)*ifdbkR, itim2R ; Loop 2
adel3R  	delay $inR.+( aflt1R-aflt2R+aflt3R-aflt4R)*ifdbkR, itim3R ; Loop 3
adel4R  	delay	$inR.+(-aflt1R-aflt2R+aflt3R+aflt4R)*ifdbkR, itim4R ; Loop 4

; FC, VOL, Q
aflt1R   	pareq     adel1R,  ifco1R, .5, .4, 2
aflt2R   	pareq     adel2R,  ifco2R, .5, .4, 2
aflt3R   	pareq     adel3R,  ifco3R, .5, .4, 2
aflt4R   	pareq     adel4R,  ifco4R, .5, .4, 2

$outR.    	butterhp 	aflt1R+aflt2R+aflt3R+aflt4R, ifchp 			; COMBINE OUTPUTS
#






#define rvb5s(inL'inR'outL'outR'preset)
#
;----------------------------------------------------------------------------------
; 3 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
; CURRENT PRESETS :1-live large room 2-dead large room 3-cathedral 4-caveman

if $preset. = 1 igoto livelargeroom
if $preset. = 2 igoto deadlargeroom
if $preset. = 3 igoto cathedral
if $preset. = 4 igoto caveman

livelargeroom:
;LEFT
ifdbkL   	=        	1.2/3
ifco1L      	=        	4070
ifco2L      	=        	4070*68/(68+151*(1-.9))
ifco3L      	=        	4070*68/(68+273*(1-.9))
itim1L      	=        	68/1000
itim2L      	=        	151/1000
itim3L      	=        	273/1000
;RIGHT
ifdbkR      	=        	1.2/3
ifco1R        	=        	4260
ifco2R        	=        	4260*62/(62+133*(1-.9))
ifco3R        	=        	4260*62/(62+231*(1-.9))
itim1R        	=        	62/1000
itim2R        	=        	133/1000
itim3R        	=        	231/1000
igoto next

deadlargeroom:
;LEFT
ifdbkL      	=        	1.2/3
ifco1L      	=        	1070
ifco2L      	=        	1070*68/(68+154*(1-.8))
ifco3L      	=        	1070*68/(68+273*(1-.8))
itim1L      	=        	68/1000
itim2L      	=        	154/1000
itim3L      	=        	273/1000
;RIGHT
ifdbkR        	=        	1.2/3
ifco1R        	=        	1260
ifco2R        	=        	1260*61/(61+152*(1-.8))
ifco3R        	=        	1260*61/(61+277*(1-.8))
itim1R        	=        	61/1000
itim2R        	=        	152/1000
itim3R        	=        	277/1000
igoto next

cathedral:
;LEFT
ifdbkL      	=        	1.2/3
ifco1L      	=        	6070
ifco2L      	=        	6070*68/(68+204*(1-.8))
ifco3L      	=        	6070*68/(68+373*(1-.8))
itim1L      	=        	68/1000
itim2L      	=        	204/1000
itim3L      	=        	373/1000
;RIGHT
ifdbkR        	=        	1.2/3
ifco1R        	=        	6260
ifco2R        	=        	6260*61/(61+202*(1-.8))
ifco3R        	=        	6260*61/(61+377*(1-.8))
itim1R        	=        	61/1000
itim2R        	=        	202/1000
itim3R        	=        	377/1000
igoto next

caveman:
;LEFT
ifdbkL      	=        	1.0/3
ifco1L      	=        	2000
ifco2L      	=        	2000*48/(48+57*(1-.7))
ifco3L      	=        	2000*48/(48+83*(1-.7))
itim1L      	=        	48/1000
itim2L      	=        	57/1000
itim3L      	=        	83/1000
;RIGHT
ifdbkR        	=        	1.0/3
ifco1R        	=        	2000
ifco2R        	=        	2000*52/(52+62*(1-.7))
ifco3R        	=        	2000*52/(52+87*(1-.7))
itim1R        	=        	52/1000
itim2R        	=        	62/1000
itim3R        	=        	87/1000
igoto next

next:
aflt1L  	init     	0
aflt2L  	init     	0
aflt3L  	init     	0

adel1L  	delay    	$inL.+( aflt1L-aflt2L-aflt3L)*ifdbkR, itim1L; Loop 1
adel2L  	delay    	$inL.+(-aflt1L+aflt2L-aflt3L)*ifdbkR, itim2L; Loop 2
adel3L  	delay    	$inL.+(-aflt1L-aflt2L+aflt3L)*ifdbkR, itim3L; Loop 3

aflt1L  	pareq     adel1L, ifco1L, .5, .4, 2
aflt2L  	pareq     adel2L, ifco2L, .5, .4, 2
aflt3L  	pareq     adel3L, ifco3L, .5, .4, 2

$outL.    	butterhp 	aflt1L+aflt2L+aflt3L, 140 				; COMBINE OUTPUTS



aflt1R  	init     	0
aflt2R  	init     	0
aflt3R  	init     	0

adel1R  	delay    	$inR.+( aflt1R-aflt2R-aflt3R)*ifdbkR, itim1R; Loop 1
adel2R  	delay    	$inR.+(-aflt1R+aflt2R-aflt3R)*ifdbkR, itim2R; Loop 2
adel3R  	delay    	$inR.+(-aflt1R-aflt2R+aflt3R)*ifdbkR, itim3R; Loop 3

aflt1R  	pareq     adel1R, ifco1R, .5, .4, 2
aflt2R  	pareq     adel2R, ifco2R, .5, .4, 2
aflt3R  	pareq     adel3R, ifco3R, .5, .4, 2

$outR.    	butterhp 	aflt1R+aflt2R+aflt3R, 140 				; COMBINE OUTPUTS
#


#define xrvb5m(in'out'fdbk'fco'dlt1'dlt2'dlt3)
#
;----------------------------------------------------------------------------------
; 3 DELAY MULTIPLE FEEDBACK REVERB
;----------------------------------------------------------------------------------
ifdbk      	=        	1.0/3
ifco1      	=        	2000
ifco2      	=        	2000*48/(48+57*(1-.7))
ifco3      	=        	2000*48/(48+83*(1-.7))
itim1      	=        	48/1000
itim2      	=        	57/1000
itim3      	=        	83/1000

next:
aflt1  	init     	0
aflt2  	init     	0
aflt3  	init     	0

adel1  	delay    	$in.+( aflt1-aflt2-aflt3)*ifdbk, itim1; Loop 1
adel2  	delay    	$in.+(-aflt1+aflt2-aflt3)*ifdbk, itim2; Loop 2
adel3  	delay    	$in.+(-aflt1-aflt2+aflt3)*ifdbk, itim3; Loop 3

aflt1  	pareq     adel1, ifco1, .5, .4, 2
aflt2  	pareq     adel2, ifco2, .5, .4, 2
aflt3  	pareq     adel3, ifco3, .5, .4, 2

$out.    	butterhp 	aflt1+aflt2+aflt3, 140 				; COMBINE OUTPUTS

#

#define xrvb6s(in'outL'outR'lx'ly'lz'sx'sy'sz'Rx'Ry'Rz'Lx'Ly'Lz'alfa'eps'early1'early2'ref'dir)
#

;BABO roc 20-11-96
	     as0nm0    init 0   ; inizializzazione linee di feedback
	     as1nm1    init 0
	     as2nm2    init 0
	     as3nm3    init 0
	     as4nm4    init 0
	     as5nm5    init 0
	     as6nm6    init 0
	     as7nm7    init 0
	     as8nm8    init 0
	     as9nm9    init 0
	     as10nm10  init 0
	     as11nm11  init 0
	     as12nm12  init 0
	     as13nm13  init 0
	     as14nm14  init 0

	     ax       init 0    ; inizializzazione entrata e uscita


	     isigma = 0.05      ;magic number
	     ipi =3.1415926   ;costante pi greco
	     ics =343         ;velocita' del suono m/s

	; dimensioni box in x,y,z
	     ilx = $lx.
	     ily = $ly.
	     ilz = $lz.
	; posiz. sorgente x,y,z
	     isrx  = $sx.
	     isry  = $sy.
	     isrz  = $sz.
	; ricevitore dx in x,y,z
	     irrx  = $Rx.
	     irry  = $Ry.
	     irrz  = $Rz.
	; ricevitore sx in x,y,z
	     irlx  = $Lx.
	     irly  = $Ly.
	     irlz  = $Lz.
	     ialfa   =$alfa.      ; coefficente att. lungo linee di ritardo
	     ieps    =$eps.       ; volume generale per coeff. b delle 2 linee
	     iearly1 =$early1.    ; controllo early/diffuse ch 1
	     iearly2 =$early2.    ; controllo early/diffuse ch 2
	     irifl   =$ref.       ; peso dei cammini di prima riflessione
	     idir    =$dir.       ; ampiezza segnale diretto da tapline

	     ; coefficenti di uscita con il criterio di inserire un numero  
	     ; pari 1 e -1 insieme a valori nulli


	     ic0a =1  ;     
	     ic0b =1
	     ic1a =-1  ;     
	     ic1b =-1
	     ic2a =1  ;     
	     ic2b =1
	     ic3a =-1  ;     
	     ic3b =-1
	     ic4a =1  ;     
	     ic4b =1
	     ic5a =-1  ;     
	     ic5b =-1
	     ic6a =1  ;     
	     ic6b =1
	     ic7a =-1  ;     
	     ic7b =-1
	     ic8a =0  ;     
	     ic8b =0
	     ic9a =0  ;     
	     ic9b =0
	     ic10a=0  ;     
	     ic10b=0
	     ic11a=0  ;     
	     ic11b=0
	     ic12a=0  ;     
	     ic12b=0
	     ic13a=0  ;     
	     ic13b=0
	     ic14a=0  ;     
	     ic14b=0




; Costruzione dei tempi di ritardo dipendenti dai parametri della stanza e 
; dalla velocita del suono
; la costruzione delle linee e'  effettuata implementando la teoria
; del biscione che si morde la coda con N=15

; Roc inserisce 1/ al posto di 2/                       
	     
iddly0=2/(ics*sqrt((1/ilx)*(1/ilx)))                                 ; dly tm a= 001
iddly1=2/(ics*sqrt((2/ilx)*(2/ilx)+(1/ily)*(1/ily)))                 ; dly tm b= 210
iddly2=2/(ics*sqrt((1/ilx)*(1/ilx)+(1/ily)*(1/ily)))                 ; dly tm c= 110
iddly3=2/(ics*sqrt((1/ilx)*(1/ilx)+(2/ily)*(2/ily)))                 ; dly tm d= 110
iddly4=2/(ics*sqrt((1/ily)*(1/ily)))                                 ; dly tm e= 010
iddly5=2/(ics*sqrt((2/ily)*(2/ily)+(1/ilz)*(1/ilz)))                 ; dly tm f= 021
iddly6=2/(ics*sqrt((1/ily)*(1/ily)+(1/ilz)*(1/ilz)))                 ; dly tm g= 011
iddly7=2/(ics*sqrt((1/ily)*(1/ily)+(2/ilz)*(2/ilz)))                 ; dly tm h= 012
iddly8=2/(ics*sqrt((1/ilz)*(1/ilz)))                                 ; dly tm i= 001
iddly9=2/(ics*sqrt((1/ilx)*(1/ilx)+(2/ilz)*(2/ilz)))                 ; dly tm j= 102
iddly10=2/(ics*sqrt((1/ilx)*(1/ilx)+(1/ilz)*(1/ilz)))                ; dly tm k= 101
iddly11=2/(ics*sqrt((1/ilx)*(1/ilx)+(1/ily)*(1/ily)+(1/ilz)*(1/ilz))); dly tm m= 111
iddly12=2/(ics*sqrt((1/ilx)*(1/ilx)+(2/ily)*(2/ily)+(1/ilz)*(1/ilz))); dly tm m= 121
iddly13=2/(ics*sqrt((2/ilx)*(2/ilx)+(1/ily)*(1/ily)+(1/ilz)*(1/ilz))); dly tm m= 211
iddly14=2/(ics*sqrt((2/ilx)*(2/ilx)+(1/ilz)*(1/ilz)))                ; dly tm k= 201
     
    

; Il sistema essendo la matrice sostanzialmente lossless tende ad essere
; instabile percio' e'  necessario inserire dei coefficenti di attenuazione
; nei filtri in serie alle linee di ritardo
; 
; La scelta dei coefficenti viene effettuata con il criterio che il max
; coeff. leggermente inferiore a 1 sia quello del segnale piu' veloce nella  
; linea di ritardo , cioe'  quello che ha una catena con un delay minore
; prorzionalmente ai delay viene quindi determinato in modo esponenziale
; il coefficente di Fc/2 dei passabasso

    idlmin =  iddly7
    idlmin =  (iddly9<idlmin  ? iddly9  : idlmin)
    idlmin =  (iddly12<idlmin ? iddly12 : idlmin)
    idlmin =  (iddly13<idlmin ? iddly13 : idlmin)


; questi sono i coefficenti di partenza dei filtri passabasso in serie
; alla linea di ritardo


ialfa0=exp((iddly0/idlmin)*log(ialfa))
ialfa1=exp((iddly1/idlmin)*log(ialfa))
ialfa2=exp((iddly2/idlmin)*log(ialfa))
ialfa3=exp((iddly3/idlmin)*log(ialfa))
ialfa4=exp((iddly4/idlmin)*log(ialfa))
ialfa5=exp((iddly5/idlmin)*log(ialfa))
ialfa6=exp((iddly6/idlmin)*log(ialfa))
ialfa7=exp((iddly7/idlmin)*log(ialfa))
ialfa8=exp((iddly8/idlmin)*log(ialfa))
ialfa9=exp((iddly9/idlmin)*log(ialfa))
ialfa10=exp((iddly10/idlmin)*log(ialfa))
ialfa11=exp((iddly11/idlmin)*log(ialfa))
ialfa12=exp((iddly12/idlmin)*log(ialfa))
ialfa13=exp((iddly13/idlmin)*log(ialfa))
ialfa14=exp((iddly14/idlmin)*log(ialfa))

ieps0=exp((iddly0/idlmin)*log(ieps))
ieps1=exp((iddly1/idlmin)*log(ieps))
ieps2=exp((iddly2/idlmin)*log(ieps))
ieps3=exp((iddly3/idlmin)*log(ieps))
ieps4=exp((iddly4/idlmin)*log(ieps))
ieps5=exp((iddly5/idlmin)*log(ieps))
ieps6=exp((iddly6/idlmin)*log(ieps))
ieps7=exp((iddly7/idlmin)*log(ieps))
ieps8=exp((iddly8/idlmin)*log(ieps))
ieps9=exp((iddly9/idlmin)*log(ieps))
ieps10=exp((iddly10/idlmin)*log(ieps))
ieps11=exp((iddly11/idlmin)*log(ieps))
ieps12=exp((iddly12/idlmin)*log(ieps))
ieps13=exp((iddly13/idlmin)*log(ieps))
ieps14=exp((iddly14/idlmin)*log(ieps))
		



; Ho calcolato i coefficenti dei diversi filtri Fir passabasso del secondo 
; ordine tipo ka0+ka1*z+ka2*z(-2)
; in frequenza la condizione  LP(0)=ialfa,antitrasformata tenendo conto 
; della fase linrare mi da' 2*ka0+ka1=ialfai
; mentre LP(Fc/2)=iepsi mi da 2*ka0-ka1=iepsi 


; la soluzione del sistema precedentemente impostato mi da queste soluzioni


ia00=(ialfa0+ieps0)/4
ia10=(ialfa0-ieps0)/2
ia20=ia00                
ia01=(ialfa1+ieps1)/4
ia11=(ialfa1-ieps1)/2
ia21=ia01                
ia02=(ialfa2+ieps2)/4
ia12=(ialfa2-ieps2)/2
ia22=ia02                
ia03=(ialfa3+ieps3)/4
ia13=(ialfa3-ieps3)/2
ia23=ia03                
ia04=(ialfa4+ieps4)/4
ia14=(ialfa4-ieps4)/2
ia24=ia04                
ia05=(ialfa5+ieps5)/4
ia15=(ialfa5-ieps5)/2
ia25=ia05                
ia06=(ialfa6+ieps6)/4
ia16=(ialfa6-ieps6)/2
ia26=ia06                
ia07=(ialfa7+ieps7)/4
ia17=(ialfa7-ieps7)/2
ia27=ia07                
ia08=(ialfa8+ieps8)/4
ia18=(ialfa8-ieps8)/2
ia28=ia08                
ia09=(ialfa9+ieps9)/4
ia19=(ialfa9-ieps9)/2
ia29=ia09                
ia010=(ialfa10+ieps10)/4
ia110=(ialfa10-ieps10)/2
ia210=ia010                
ia011=(ialfa11+ieps11)/4
ia111=(ialfa11-ieps11)/2
ia211=ia011                
ia012=(ialfa12+ieps12)/4
ia112=(ialfa12-ieps12)/2
ia212=ia012                
ia013=(ialfa13+ieps13)/4
ia113=(ialfa13-ieps13)/2
ia213=ia013                
ia014=(ialfa14+ieps14)/4
ia114=(ialfa14-ieps14)/2
ia214=ia014                




	gax = $in.; fissa il file di ingresso
	 
	 ; doppia entrata con delay tapline a 7 tappi con parametri costanti
	 ; determinati dai punti sorgente e ricevente che fissano i
	 ; tempi di prelievo e i coefficenti amplicazione


	




; Determinazione delle distanze percorse con il metodo dell'  immagine  per
; il pickup right
; Valutando l'  origine degli assi al centro della stanza
; i vari coefficenti  im  rappresentano  i diversi ritardi delle onde riflesse 

idist0a=sqrt((irrx-isrx)*(irrx-isrx)+(irry-isry)*(irry-isry)+(irrz-isrz)*(irrz-isrz))
idist1a=sqrt((ilx+irrx+isrx)*(ilx+irrx+isrx)+(irry-isry)*(irry-isry)+(irrz-isrz)*(irrz-isrz))
idist2a=sqrt((ilx-irrx-isrx)*(ilx-irrx-isrx)+(irry-isry)*(irry-isry)+(irrz-isrz)*(irrz-isrz))
idist3a=sqrt((irrx-isrx)*(irrx-isrx)+(ily-irry-isry)*(ily-irry-isry)+(irrz-isrz)*(irrz-isrz))
idist4a=sqrt((irrx-isrx)*(irrx-isrx)+(ily+irry+isry)*(ily+irry+isry)+(irrz-isrz)*(irrz-isrz))
idist5a=sqrt((irrx-isrx)*(irrx-isrx)+(irry-isry)*(irry-isry)+(ilz-irrz-isrz)*(ilz-irrz-isrz))
idist6a=sqrt((irrx-isrx)*(irrx-isrx)+(irry-isry)*(irry-isry)+(ilz+irrz+isrz)*(ilz+irrz+isrz))

im0a=idist0a/ics
im1a=idist1a/ics
im2a=idist2a/ics
im3a=idist3a/ics
im4a=idist4a/ics
im5a=idist5a/ics
im6a=idist6a/ics

ip0a=1/idist0a    ; attenuazione delle prime riflessioni
ip1a=irifl/idist1a    ; irifl e' parametro caratteristico delle pareti
ip2a=irifl/idist2a
ip3a=irifl/idist3a
ip4a=irifl/idist4a
ip5a=irifl/idist5a
ip6a=irifl/idist6a


; Determinazione delle distanze di prima riflessione per il pickup left

idist0b=sqrt((irlx-isrx)*(irlx-isrx)+(irly-isry)*(irly-isry)+(irlz-isrz)*(irlz-isrz))
idist1b=sqrt((ilx+irlx+isrx)*(ilx+irlx+isrx)+(irly-isry)*(irly-isry)+(irlz-isrz)*(irlz-isrz))
idist2b=sqrt((ilx-irlx-isrx)*(ilx-irlx-isrx)+(irly-isry)*(irly-isry)+(irlz-isrz)*(irlz-isrz))
idist3b=sqrt((irlx-isrx)*(irlx-isrx)+(ily-irly-isry)*(ily-irly-isry)+(irlz-isrz)*(irlz-isrz))
idist4b=sqrt((irlx-isrx)*(irlx-isrx)+(ily+irly+isry)*(ily+irly+isry)+(irlz-isrz)*(irlz-isrz))
idist5b=sqrt((irlx-isrx)*(irlx-isrx)+(irly-isry)*(irly-isry)+(ilz-irlz-isrz)*(ilz-irlz-isrz))
idist6b=sqrt((irlx-isrx)*(irlx-isrx)+(irly-isry)*(irly-isry)+(ilz+irlz+isrz)*(ilz+irlz+isrz))

im0b=idist0b/ics
im1b=idist1b/ics
im2b=idist2b/ics
im3b=idist3b/ics
im4b=idist4b/ics
im5b=idist5b/ics
im6b=idist6b/ics


ip0b=1/idist0b
ip1b=irifl/idist1b
ip2b=irifl/idist2b
ip3b=irifl/idist3b
ip4b=irifl/idist4b
ip5b=irifl/idist5b
ip6b=irifl/idist6b





; qui e'  stato necessario usare le primitive delayr e delayw per la 
; futura possibilita'  di inserire come parametri delle variabili k
; tempo varianti




; costruzione della tapdelayline 1  dx

amax   delayr 1   ; massimo tempo di delay
asgn0a deltap im0a;
asgn1a deltap im1a;
asgn2a deltap im2a;
asgn3a deltap im3a;
asgn4a deltap im4a;
asgn5a deltap im5a;
asgn6a deltap im6a;
delayw $in.

   atap1=asgn0a*ip0a+asgn1a*ip1a+asgn2a*ip2a+asgn3a*ip3a+asgn4a*ip4a+asgn5a*ip5a+asgn6a*ip6a


 

; Costruzione della tapdelayline 2 sx

amax   delayr 1   ; massimo tempo di delay 1 secondo
asgn0b deltap im0b;
asgn1b deltap im1b;
asgn2b deltap im2b;
asgn3b deltap im3b;
asgn4b deltap im4b;
asgn5b deltap im5b;
asgn6b deltap im6b;
delayw $in.
   atap2=asgn0b*ip0b+asgn1b*ip1b+asgn2b*ip2b+asgn3b*ip3b+asgn4b*ip4b+asgn5b*ip5b+asgn6b*ip6b



; linee di ritardo che funziano con variabili globali tipo g precedentemente
; gia'  inizializzate
	    
	    amax0  delayr  .5
	    asf0n  deltap  iddly0
	    delayw as0nm0
	    amax1  delayr  .5
	    asf1n  deltap  iddly1
	    delayw as1nm1
	    amax2  delayr  .5
	    asf2n  deltap  iddly2
	    delayw as2nm2
	    amax3  delayr  .5
	    asf3n  deltap  iddly3
	    delayw as3nm3
	    amax4  delayr  .5
	    asf4n  deltap  iddly4
	    delayw as4nm4
	    amax5  delayr  .5
	    asf5n  deltap  iddly5
	    delayw as5nm5
	    amax6  delayr  .5
	    asf6n  deltap  iddly6
	    delayw as6nm6
	    amax7  delayr  .5
	    asf7n  deltap  iddly7
	    delayw as7nm7
	    amax8  delayr  .5
	    asf8n  deltap  iddly8
	    delayw as8nm8
	    amax9  delayr  .5
	    asf9n  deltap  iddly9
	    delayw as9nm9
	    amax10  delayr  .5
	    asf10n  deltap  iddly10
	    delayw as10nm10
	    amax11  delayr  .5
	    asf11n  deltap  iddly11
	    delayw as11nm11
	    amax12  delayr  .5
	    asf12n  deltap  iddly12
	    delayw as12nm12
	    amax13  delayr  .5
	    asf13n  deltap  iddly13
	    delayw as13nm13
	    amax14  delayr  .5
	    asf14n  deltap  iddly14
	    delayw as14nm14



; elaborazione dei segnali per effettuarne il filtraggio a mezzo dei FIR 
; in parallelo alle linee di ritardo

; ritarda il segnale di un campione

arit0 delay1 asf0n
arit1 delay1 asf1n
arit2 delay1 asf2n
arit3 delay1 asf3n
arit4 delay1 asf4n
arit5 delay1 asf5n
arit6 delay1 asf6n
arit7 delay1 asf7n
arit8 delay1 asf8n
arit9 delay1 asf9n
arit10 delay1 asf10n
arit11 delay1 asf11n
arit12 delay1 asf12n
arit13 delay1 asf13n
arit14 delay1 asf14n

; ritarda il segnale di 2 campioni ritardando il precedente di 1

arrit0 delay1 arit0
arrit1 delay1 arit1
arrit2 delay1 arit2
arrit3 delay1 arit3
arrit4 delay1 arit4
arrit5 delay1 arit5
arrit6 delay1 arit6
arrit7 delay1 arit7
arrit8 delay1 arit8
arrit9 delay1 arit9
arrit10 delay1 arit10
arrit11 delay1 arit11
arrit12 delay1 arit12
arrit13 delay1 arit13
arrit14 delay1 arit14


; segnali all'  uscita dei filtri FIR

as0n=ia00*asf0n+arit0*ia10+arrit0*ia20
as1n=ia01*asf1n+arit1*ia11+arrit1*ia21
as2n=ia02*asf2n+arit2*ia12+arrit2*ia22
as3n=ia03*asf3n+arit3*ia13+arrit3*ia23
as4n=ia04*asf4n+arit4*ia14+arrit4*ia24
as5n=ia05*asf5n+arit5*ia15+arrit5*ia25
as6n=ia06*asf6n+arit6*ia16+arrit6*ia26
as7n=ia07*asf7n+arit7*ia17+arrit7*ia27
as8n=ia08*asf8n+arit8*ia18+arrit8*ia28
as9n=ia09*asf9n+arit9*ia19+arrit9*ia29
as10n=ia010*asf10n+arit10*ia110+arrit10*ia210
as11n=ia011*asf11n+arit11*ia111+arrit11*ia211
as12n=ia012*asf12n+arit12*ia112+arrit12*ia212
as13n=ia013*asf13n+arit13*ia113+arrit13*ia213
as14n=ia014*asf14n+arit14*ia114+arrit14*ia214


; segnali all'  uscita della feedback matrix e all'  ingresso dei sommatori
; precedenti la linea di ritardo

; Anche qui e' stato necessario spezzare le somme dei segnali per non 
; superare i 100 char max lunghezza della stringa consentita dal compilatore


aoff = isigma*(as0n+as1n+as2n+as3n+as4n+as5n+as6n+as7n+as8n+as9n+as10n+as11n+as12n+as13n+as14n)


as0nm01  =4*atap1*idir+4*atap2*idir+as0n-as1n-as2n-as3n+as4n-as5n-as6n 
as0nm02  =as7n +as8n -as9n +as10n-as11n+as12n+as13n+as14n
as0nm0   =(as0nm01+as0nm02)/4+aoff            

as1nm11  =4*atap1*idir+4*atap2*idir+as0n+as1n-as2n-as3n-as4n+as5n-as6n
as1nm12  =-as7n+as8n+as9n-as10n+as11n-as12n+as13n+as14n
as1nm1   =(as1nm11+as1nm12)/4+aoff            

as2nm21  =4*atap1*idir +4*atap2*idir+as0n+as1n+as2n-as3n-as4n-as5n+as6n
as2nm22  =-as7n-as8n+as9n+as10n-as11n+as12n-as13n+as14n
as2nm2   =(as2nm21+as2nm22)/4+aoff            

as3nm31 =4*atap1*idir+4*atap2*idir+as0n+as1n+as2n+as3n-as4n-as5n-as6n
as3nm32 =as7n-as8n-as9n +as10n+as11n-as12n+as13n-as14n
as3nm3  =(as3nm31+as3nm32)/4+aoff

as4nm41 =4*atap1*idir+4*atap2*idir-as0n+as1n+as2n+as3n+as4n-as5n-as6n 
as4nm42 =-as7n +as8n -as9n -as10n+as11n+as12n -as13n +as14n
as4nm4  =(as4nm41+as4nm42)/4+aoff

as5nm51=4*atap1*idir+4*atap2*idir+as0n-as1n+as2n+as3n+as4n+as5n-as6n 
as5nm52=-as7n-as8n+as9n-as10n-as11n+as12n+as13n-as14n
as5nm5 =(as5nm51+as5nm52)/4+aoff

as6nm61 =4*atap1*idir+4*atap2*idir-as0n+as1n-as2n+as3n+as4n+as5n+as6n
as6nm62 =-as7n-as8n-as9n+as10n-as11n-as12n+as13n+as14n
as6nm6  =(as6nm61+as6nm62)/4+aoff

as7nm71=4*atap1*idir+4*atap2*idir+as0n-as1n+as2n-as3n+as4n+as5n+as6n
as7nm72=as7n -as8n -as9n -as10n+as11n-as12n-as13n +as14n
as7nm7 =(as7nm71+as7nm72)/4+aoff

as8nm81 =4*atap1*idir+4*atap2*idir+as0n+as1n-as2n+as3n-as4n+as5n+as6n
as8nm82 =as7n+as8n -as9n -as10n-as11n +as12n -as13n -as14n
as8nm8 =(as8nm81+as8nm82)/4+aoff

as9nm91 =4*atap1*idir+4*atap2*idir-as0n+as1n+as2n-as3n+as4n-as5n+as6n
as9nm92 =as7n+as8n+as9n -as10n-as11n -as12n+as13n -as14n
as9nm9  =(as9nm91+as9nm92)/4+aoff

as10nm101=4*atap1*idir+4*atap2*idir-as0n-as1n+as2n+as3n-as4n+as5n-as6n
as10nm102=as7n+as8n+as9n+as10n-as11n-as12n-as13n +as14n
as10nm10= (as10nm101+as10nm102)/4+aoff

as11nm111=4*atap1*idir+4*atap2*idir+as0n-as1n-as2n+as3n+as4n-as5n+as6n
as11nm112=-as7n+as8n+as9n+as10n+as11n -as12n-as13n -as14n
as11nm11 =(as11nm111+as11nm112)/4+aoff

as12nm121=4*atap1*idir+4*atap2*idir-as0n+as1n-as2n-as3n+as4n+as5n-as6n
as12nm122=as7n-as8n+as9n+as10n+as11n+as12n-as13n -as14n
as12nm12 =(as12nm121+as12nm122)/4+aoff

as13nm131=4*atap1*idir+4*atap2*idir-as0n-as1n+as2n-as3n-as4n+as5n+as6n 
as13nm132=-as7n +as8n-as9n+as10n+as11n+as12n+as13n -as14n
as13nm13 =(as13nm131+as13nm132)/4+aoff

as14nm141=4*atap1*idir+4*atap2*idir-as0n-as1n-as2n+as3n-as4n-as5n+as6n 
as14nm142=as7n -as8n +as9n-as10n+as11n+as12n+as13n+as14n
as14nm14 =(as14nm141+as14nm142)/4+aoff            



aout11=as0n*ic0a+as1n*ic1a+as2n*ic2a+as3n*ic3a+as4n*ic4a+as5n*ic5a+as6n*ic6a
aout12=as7n*ic7a+as8n*ic8a+as9n*ic9a+as10n*ic10a+as11n*ic11a+as12n*ic12a+as13n*ic13a+as14n*ic14a+atap1*iearly1
$outL. =aout11+aout12

aout21=as0n*ic0b+as1n*ic1b+as2n*ic2b+as3n*ic3b+as4n*ic4b+as5n*ic5b+as6n*ic6b
aout22=as7n*ic7b+as8n*ic8b+as9n*ic9b+as10n*ic10b+as11n*ic11b+as12n*ic12b+as13n*ic13b+as14n*ic14b+atap2*iearly2
$outR. =aout21+aout22; wrong...R<->L???
#

#define rvb7s(in'outL'outR'gain'echotime);Lyon´s echo1 reverb;includes d/w mix!!
#
iroll     =         600
igain     =         $gain.
iecho     =         $echotime.
isp1      =         .237
isp2      =         .1892
idev      =         .005
ibase     =         idev*2.0
;idk       =         .015

;aclean    linseg    1,p3-idk,1,idk,0;removed to allow MIDI reverb (JCN)
ain1      =         $in.
ain1      =         ain1 * igain
alop      tone      ain1, iroll
adel      delay     ain1, iecho
amix      =         alop+adel
adel1     oscili    idev, isp1, 1
adel2     oscili    idev, isp2, 1
adel1     =         adel1 + ibase
adel2     =         adel2 + ibase
addl1     delayr    .5
atap1     deltapi   adel1
atap2     deltapi   adel2
          delayw    amix
amid      =         amix * .7
aleft     =         atap1 + amid
aright    =         atap2 + amid

$outL.    =         aleft;*aclean
$outR.    =         aright;*aclean
#

#define rvb8s(inL'inR'outL'outR'gain'echotime);Lyon´s echo2 reverb
 #

iroll          =         600
igain          =         $gain.
iecho          =         $echotime.
isp1           =         .237
isp2           =         .1892
idev           =         .005
ibase          =         idev*2.0
;idk            =         .015

;aclean         linseg    1,p3-idk,1,idk,0;removed to allow MIDI reverb (JCN)
ain1           =         $inL.
ain2           =         $inR.
ain1           =         ain1 * igain
ain2           =         ain2 * igain
alop1          tone      ain1, iroll
alop2          tone      ain2, iroll
adel1          delay     ain1, iecho
adel2          delay     ain2, iecho
amix1          =         alop1+adel1
amix2          =         alop2+adel2;hmm why those stages? all the parms. are equal...(JCN)
adel1          oscili    idev, isp1, 1
adel2          oscili    idev, isp2, 1
adel1          =         adel1 + ibase
adel2          =         adel2 + ibase
addl1          delayr    .5
atap1          deltapi   adel1
               delayw    amix1
addl2          delayr    .5
atap2          deltapi   adel2
               delayw    amix2

aleft          =         atap1 + amix1
aright         =         atap2 + amix2

$outL.    =         aleft;*aclean
$outR.    =         aright;*aclean
#

#define rvb9m(in'outL'outR);Lyon´s GATOR2 reverb MONO input
#
; MONO INPUT
;iorig          =         .05
irev           =         1.;-iorig REMOVED (MUST COMPENSATE IN THE ORCHESTRA (JCN))
igain          =         1.0
ilpgain        =         1.5
icgain         =         .1
ialpgain       =         0.1
ispeed1        =         1.068664  
ispeed2        =         0.957679  
ispeed3        =         1.193976  
ispeed4        =         1.210142  
idel1          =         0.030699 
idel2          =         0.071858 
idel3          =         0.103109 
idel4          =         0.173237
icf1           =         2049.613770 
icf2           =         567.451782 
icf3           =         172.628906 
icf4           =         42.963375
ifac           =         2
ibw1           =         icf1/ifac
ibw2           =         icf2/ifac
ibw3           =         icf3/ifac
ibw4           =         icf4/ifac
aenv1          oscil     igain, ispeed1, 201
aenv2          oscil     igain, ispeed2, 202
aenv3          oscil     igain, ispeed3, 203
aenv4          oscil     igain, ispeed4, 204
araw           =         $in.
ares1          reson     araw,icf1,ibw1,1
ares2          reson     araw,icf2,ibw2,1
ares3          reson     araw,icf3,ibw3,1
ares4          reson     araw,icf4,ibw4,1
adel1          delay     ares1,idel1
adel2          delay     ares2,idel2
adel3          delay     ares3,idel3
adel4          delay     ares4,idel4
asum           =         (ares1*aenv1)+(ares2*aenv2)+(ares3*aenv3)+(ares4*aenv4)
alp            tone      asum,1000
adright        delay     alp,.178
adleft         delay     alp,.215
asumr          =         asum+(adright*ilpgain)
asuml          =         asum+(adleft*ilpgain)
acr1           comb      asumr,2,.063
acr2           comb      acr1+asumr,.5,.026
acl1           comb      asuml,2,.059
acl2           comb      acl1+asuml,.5,.031
acsumr         =         asumr+(acr2*icgain)
acsuml         =         asuml+(acl2*icgain)
alpo           alpass    asum,3,.085
alpol          comb      alpo, 2.8, .526 
alpor          comb      alpo, 2.8, .746 
alol           tone      alpol,500
alor           tone      alpor,500
alold          delay     alol,.095
alord          delay     alor,.11
arevl          =         (alpol*ialpgain)+acsuml+alold
arevr          =         (alpor*ialpgain)+acsumr+alord
;aorig          =         araw*iorig

$outL. =	(arevl*irev);+aorig
$outR. =	(arevr*irev);+aorig
#

#define rvb9s(inL'inR'outL'outR);Lyon´s GATOR2 reverb STEREO input 
#
;iorig          =         .05
irev           =         1;.-iorig; REMOVED (MUST COMPENSATE IN THE ORCHESTRA (JCN))
igain          =         1.0
ilpgain        =         1.5
icgain         =         .1
ialpgain       =         0.1
ispeed1        =         1.068664  
ispeed2        =         0.957679  
ispeed3        =         1.193976  
ispeed4        =         1.210142  
idel1          =         0.030699 
idel2          =         0.071858 
idel3          =         0.103109 
idel4          =         0.173237
icf1           =         2049.613770 
icf2           =         567.451782 
icf3           =         172.628906 
icf4           =         42.963375
ifac           =         2
ibw1           =         icf1/ifac
ibw2           =         icf2/ifac
ibw3           =         icf3/ifac
ibw4           =         icf4/ifac
aenv1          oscil     igain, ispeed1, 201
aenv2          oscil     igain, ispeed2, 202
aenv3          oscil     igain, ispeed3, 203
aenv4          oscil     igain, ispeed4, 204
ain1           =         $inL.
ain2           =         $inR.
ares1          resonz    ain1,icf1,ibw1,1;changed reson to resonz (better sounding IMHO - JCN)
ares2          resonz    ain2,icf2,ibw2,1
ares3          resonz    ain1,icf3,ibw3,1
ares4          resonz    ain2,icf4,ibw4,1
adel1          delay     ares1,idel1
adel2          delay     ares2,idel2
adel3          delay     ares3,idel3
adel4          delay     ares4,idel4
asum1          =         (ares1*aenv1)+(ares3*aenv3)
asum2          =         (ares2*aenv2)+(ares4*aenv4)
alp1           tone      asum1,1000
alp2           tone      asum2,1000
adright        delay     alp1,.178
adleft         delay     alp2,.215
asumr          =         asum1+(adright*ilpgain)
asuml          =         asum2+(adleft*ilpgain)
acr1           comb      asumr,2,.063
acr2           comb      acr1+asumr,.5,.026
acl1           comb      asuml,2,.059
acl2           comb      acl1+asuml,.5,.031
acsumr         =         asumr+(acr2*icgain)
acsuml         =         asuml+(acl2*icgain)
alpo1          alpass    asum1,3,.085
alpo2          alpass    asum2,3,.085
alpol          comb      alpo1, 2.8, .526 
alpor          comb      alpo2, 2.8, .746 
alol           tone      alpol,500
alor           tone      alpor,500
alold          delay     alol,.095
alord          delay     alor,.11
arevl          =         (alpol*ialpgain)+acsuml+alold
arevr          =         (alpor*ialpgain)+acsumr+alord
;aorig1         =         ain1*iorig
;aorig2         =         ain2*iorig
$outL. =	(arevl*irev);+aorig1
$outR. =	(arevr*irev);+aorig2
#


#define rvb10m(in'outL'outR); E. Lyon´s Lmultitap reverb
#
ip2      =1.570796
iroll1   = 7000
iroll2   = 3000
iroll3   = 1000
;gigain    = .25
it1a      =         0.030243 
it1b      =         0.067391 
it1c      =         0.080443 
it1d      =         0.095692 
it1e      =         0.106696 
ig1a      =         0.700000 
ig1b      =         0.280000 
ig1c      =         0.112000 
ig1d      =         0.044800 
ig1e      =         0.017920 
iloc1a    =         0.101870 
iloc1b    =         0.101218 
iloc1c    =         0.123827 
iloc1d    =         0.178924 
iloc1e    =         0.173902 
it2a      =         0.135053 
it2b      =         0.177988 
it2c      =         0.278580 
it2d      =         0.420888 
it2e      =         0.487966 
ig2a      =         0.300000 
ig2b      =         0.210000 
ig2c      =         0.147000 
ig2d      =         0.102900 
ig2e      =         0.072030 
iloc2a    =         0.468848 
iloc2b    =         0.519407 
iloc2c    =         0.683724 
iloc2d    =         0.559628 
iloc2e    =         0.629442 
it3a      =         0.181703 
it3b      =         0.441584 
it3c      =         0.667100 
it3d      =         0.810717 
it3e      =         1.031620 
ig3a      =         0.150000 
ig3b      =         0.135000 
ig3c      =         0.121500 
ig3d      =         0.109350 
ig3e      =         0.098415 
iloc3a    =         0.481580 
iloc3b    =         0.271741 
iloc3c    =         0.637698 
iloc3d    =         0.741447 
iloc3e    =         0.385553
ilg1a     =         sin( iloc1a * ip2 )
irg1a     =         cos( iloc1a * ip2 )
ilg1b     =         sin( iloc1b * ip2 )
irg1b     =         cos( iloc1b * ip2 )
ilg1c     =         sin( iloc1c * ip2 )
irg1c     =         cos( iloc1c * ip2 )
ilg1d     =         sin( iloc1d * ip2 )
irg1d     =         cos( iloc1d * ip2 )
ilg1e     =         sin( iloc1e * ip2 )
irg1e     =         cos( iloc1e * ip2 )
ilg2a     =         sin( iloc2a * ip2 )
irg2a     =         cos( iloc2a * ip2 )
ilg2b     =         sin( iloc2b * ip2 )
irg2b     =         cos( iloc2b * ip2 )
ilg2c     =         sin( iloc2c * ip2 )
irg2c     =         cos( iloc2c * ip2 )
ilg2d     =         sin( iloc2d * ip2 )
irg2d     =         cos( iloc2d * ip2 )
ilg2e     =         sin( iloc2e * ip2 )
irg2e     =         cos( iloc2e * ip2 )
ilg3a     =         sin( iloc3a * ip2 )
irg3a     =         cos( iloc3a * ip2 )
ilg3b     =         sin( iloc3b * ip2 )
irg3b     =         cos( iloc3b * ip2 )
ilg3c     =         sin( iloc3c * ip2 )
irg3c     =         cos( iloc3c * ip2 )
ilg3d     =         sin( iloc3d * ip2 )
irg3d     =         cos( iloc3d * ip2 )
ilg3e     =         sin( iloc3e * ip2 )
irg3e     =         cos( iloc3e * ip2 )
ain       =         $in.
;ain       =         ain * gigain;removed:gain compensation is your responsibility (JCN) 
atap1a    delay     ain, it1a
atap1b    delay     ain, it1b
atap1c    delay     ain, it1c
atap1d    delay     ain, it1d
atap1e    delay     ain, it1e
at1a      =         atap1a * ig1a
at1b      =         atap1b * ig1b
at1c      =         atap1c * ig1c
at1d      =         atap1d * ig1d
at1e      =         atap1e * ig1e
asum1     =         atap1a+atap1b+atap1c+atap1d+atap1e
ain2      tone      asum1, iroll1
atap2a    delay     ain2, it2a
atap2b    delay     ain2, it2b
atap2c    delay     ain2, it2c
atap2d    delay     ain2, it2d
atap2e    delay     ain2, it2e
at2a      =         atap2a * ig2a
at2b      =         atap2b * ig2b
at2c      =         atap2c * ig2c
at2d      =         atap2d * ig2d
at2e      =         atap2e * ig2e
asum2     =         atap2a+atap2b+atap2c+atap2d+atap2e
ain3      tone      asum2, iroll2
atap3a    delay     ain3, it3a
atap3b    delay     ain3, it3b
atap3c    delay     ain3, it3c
atap3d    delay     ain3, it3d
atap3e    delay     ain3, it3e
at3a      =         atap3a * ig3a
at3b      =         atap3b * ig3b
at3c      =         atap3c * ig3c
at3d      =         atap3d * ig3d
at3e      =         atap3e * ig3e
aleft1    =         (at1a*ilg1a)+(at1b*ilg1b)+(at1c*ilg1c)+(at1d*ilg1d)+(at1e*ilg1e)
aleft2    =         (at2a*ilg2a)+(at2b*ilg2b)+(at2c*ilg2c)+(at2d*ilg2d)+(at2e*ilg2e)
aleft3    =         (at3a*ilg3a)+(at3b*ilg3b)+(at3c*ilg3c)+(at3d*ilg3d)+(at3e*ilg3e)
$outL.    =         aleft1+aleft2+aleft3
aright1   =         (at1a*irg1a)+(at1b*irg1b)+(at1c*irg1c)+(at1d*irg1d)+(at1e*irg1e)
aright2   =         (at2a*irg2a)+(at2b*irg2b)+(at2c*irg2c)+(at2d*irg2d)+(at2e*irg2e)
aright3   =         (at3a*irg3a)+(at3b*irg3b)+(at3c*irg3c)+(at3d*irg3d)+(at3e*irg3e)
$outR.    =         aright1+aright2+aright3

#

#define rvb11s(inL'inR'outL'outR); E. Lyon´s Lmultitap2 reverb
#
ip2           =         1.570796
iroll1        =         7000
iroll2        =         3000
iroll3        =         1000
;gigain         =         1.
it1a           =         0.026533 
it1b           =         0.049413 
it1c           =         0.066368 
it1d           =         0.082412 
it1e           =         0.117546 
ig1a           =         0.700000 
ig1b           =         0.280000 
ig1c           =         0.112000 
ig1d           =         0.044800 
ig1e           =         0.017920 
iloc1a         =         0.143560 
iloc1b         =         0.190170 
iloc1c         =         0.119558 
iloc1d         =         0.146660 
iloc1e         =         0.185922 
it2a           =         0.147850 
it2b           =         0.230754 
it2c           =         0.305349 
it2d           =         0.421241 
it2e           =         0.555897 
ig2a           =         0.300000 
ig2b           =         0.210000 
ig2c           =         0.147000 
ig2d           =         0.102900 
ig2e           =         0.072030 
iloc2a         =         0.580088 
iloc2b         =         0.587813 
iloc2c         =         0.534898 
iloc2d         =         0.457856 
iloc2e         =         0.551248 
it3a           =         0.201058 
it3b           =         0.485650 
it3c           =         0.746925 
it3d           =         0.959482 
it3e           =         1.196479 
ig3a           =         0.150000 
ig3b           =         0.135000 
ig3c           =         0.121500
ig3d           =         0.109350 
ig3e           =         0.098415 
iloc3a         =         0.468171 
iloc3b         =         0.919478 
iloc3c         =         0.858948 
iloc3d         =         0.649586 
iloc3e         =         0.916412 
ilg1a          =         sin( iloc1a * ip2 )
irg1a          =         cos( iloc1a * ip2 )
ilg1b          =         sin( iloc1b * ip2 )
irg1b          =         cos( iloc1b * ip2 )
ilg1c          =         sin( iloc1c * ip2 )
irg1c          =         cos( iloc1c * ip2 )
ilg1d          =         sin( iloc1d * ip2 )
irg1d          =         cos( iloc1d * ip2 )
ilg1e          =         sin( iloc1e * ip2 )
irg1e          =         cos( iloc1e * ip2 )
ilg2a          =         sin( iloc2a * ip2 )
irg2a          =         cos( iloc2a * ip2 )
ilg2b          =         sin( iloc2b * ip2 )
irg2b          =         cos( iloc2b * ip2 )
ilg2c          =         sin( iloc2c * ip2 )
irg2c          =         cos( iloc2c * ip2 )
ilg2d          =         sin( iloc2d * ip2 )
irg2d          =         cos( iloc2d * ip2 )
ilg2e          =         sin( iloc2e * ip2 )
irg2e          =         cos( iloc2e * ip2 )
ilg3a          =         sin( iloc3a * ip2 )
irg3a          =         cos( iloc3a * ip2 )
ilg3b          =         sin( iloc3b * ip2 )
irg3b          =         cos( iloc3b * ip2 )
ilg3c          =         sin( iloc3c * ip2 )
irg3c          =         cos( iloc3c * ip2 )
ilg3d          =         sin( iloc3d * ip2 )
irg3d          =         cos( iloc3d * ip2 )
ilg3e          =         sin( iloc3e * ip2 )
irg3e          =         cos( iloc3e * ip2 )
ain            =         $inL.
ain2           =         $inR.
;ain            =         ain * gigain 
atap1a         delay     ain, it1a
atap1b         delay     ain, it1b
atap1c         delay     ain, it1c
atap1d         delay     ain, it1d
atap1e         delay     ain, it1e
at1a           =         atap1a * ig1a
at1b           =         atap1b * ig1b
at1c           =         atap1c * ig1c
at1d           =         atap1d * ig1d
at1e           =         atap1e * ig1e
asum1          =         atap1a+atap1b+atap1c+atap1d+atap1e
atap2a         delay     ain2, it2a
atap2b         delay     ain2, it2b
atap2c         delay     ain2, it2c
atap2d         delay     ain2, it2d
atap2e         delay     ain2, it2e
at2a           =         atap2a * ig2a
at2b           =         atap2b * ig2b
at2c           =         atap2c * ig2c
at2d           =         atap2d * ig2d
at2e           =         atap2e * ig2e
asum2          =         atap2a+atap2b+atap2c+atap2d+atap2e
ain3           tone      asum2, iroll2
atap3a         delay     ain3, it3a
atap3b         delay     ain3, it3b
atap3c         delay     ain3, it3c
atap3d         delay     ain3, it3d
atap3e         delay     ain3, it3e
at3a           =         atap3a * ig3a
at3b           =         atap3b * ig3b
at3c           =         atap3c * ig3c
at3d           =         atap3d * ig3d
at3e           =         atap3e * ig3e
aleft1         =         (at1a*ilg1a)+(at1b*ilg1b)+(at1c*ilg1c)+(at1d*ilg1d)+(at1e*ilg1e)
aleft2         =         (at2a*ilg2a)+(at2b*ilg2b)+(at2c*ilg2c)+(at2d*ilg2d)+(at2e*ilg2e)
aleft3         =         (at3a*ilg3a)+(at3b*ilg3b)+(at3c*ilg3c)+(at3d*ilg3d)+(at3e*ilg3e)
$outL.         =         aleft1+aleft2+aleft3
aright1        =         (at1a*irg1a)+(at1b*irg1b)+(at1c*irg1c)+(at1d*irg1d)+(at1e*irg1e)
aright2        =         (at2a*irg2a)+(at2b*irg2b)+(at2c*irg2c)+(at2d*irg2d)+(at2e*irg2e)
aright3        =         (at3a*irg3a)+(at3b*irg3b)+(at3c*irg3c)+(at3d*irg3d)+(at3e*irg3e)
$outR.         =         aright1+aright2+aright3
#

#define rvb12s(inL'inR'outL'outR);Lyon´s Rev1 reverb (dry/wet mix of .65/.35 in the orgininal file)
;rev1 - stereo 2 stereo (very rich) 

#
gifeed         =         .5
gilp1          =         1/10
gilp2          =         1/23
gilp3          =         1/41
giroll         =         3000
  
inputdur       =         p3;I guess... (JCN) original was 15.650 
iatk           =         .01
idk            =         .01
idecay         =         .01
;data for output envelope
ioutsust       =         p3-idecay
idur           =         inputdur-(iatk+idk)
isust          =         p3-(iatk+idur+idk)
iorig          =         0.0;.65;removed dry signal (JCN) 
irev           =         1.0;-.65 

igain          =         1
;for stereo input
kclean         linseg    0,iatk,igain,idur,igain,idk,0,isust,0
kout           linseg    1,ioutsust,1,idecay,0
ain1           =         $inL.*kclean
ain2           =         $inR.*kclean
ajunk          alpass    ain1,1.7,.1
aleft          alpass    ajunk,1.01,.07
ajunk          alpass    ain2,1.5,.2
aright         alpass    ajunk,1.33,.05

kdel1          randi     .01,1,.666
kdel1          =         kdel1 + .1
addl1          delayr    .3
afeed1         deltapi   kdel1
afeed1         =         afeed1 + gifeed*aleft
delayw         aleft

kdel2          randi     .01,.95,.777
kdel2          =         kdel2 + .1
addl2          delayr    .3
afeed2         deltapi   kdel2
afeed2         =         afeed2 + gifeed*aright
               delayw    aright
;GLOBAL REVERB

aglobin        =         (afeed1+afeed2)*.05
atap1          comb      aglobin,3.3,gilp1
atap2          comb      aglobin,3.3,gilp2
atap3          comb      aglobin,3.3,gilp3
aglobrev       alpass    atap1+atap2+atap3,2.6,.085
aglobrev       tone      aglobrev,giroll

kdel3          randi     .003,1,.888
kdel3          =         kdel3 + .05
addl3          delayr    .2
agr1           deltapi   kdel3
               delayw    aglobrev

kdel4          randi     .003,1,.999
kdel4          =         kdel4 + .05
addl4          delayr    .2
agr2           deltapi   kdel4
               delayw    aglobrev

arevl          =         agr1+afeed1
arevr          =         agr2+afeed2
$outL.         =         kout*((ain1*iorig)+(arevl*irev))
$outR.         =         kout*((ain2*iorig)+(arevr*irev))
#

#define rvb13s(in'outL'outR);Lyon´s Rev2 reverb;PANNING TAP BASED STEREO REVERB : MONO INPUT ONLY
;outputs only the wet signal   dry/wet mix suggested in the original score : .5/.5
#
gigain         =         2.1
gipiotwo       =         1.571
gil1           =         sin(0)
gil2           =         sin((1/5) * gipiotwo)
gil3           =         sin((2/5) * gipiotwo)
gil4           =         sin((3/5) * gipiotwo)
gil5           =         sin((4/5) * gipiotwo)
gil6           =         sin((1) * gipiotwo)
gir1           =         cos(0)
gir2           =         cos((1/5) * gipiotwo)
gir3           =         cos((2/5) * gipiotwo)
gir4           =         cos((3/5) * gipiotwo)
gir5           =         cos((4/5) * gipiotwo)
gir6           =         cos((1) * gipiotwo)
iorig          =         0.0
irev           =         1-iorig
arawsig        =         $in.
arawsig        =         arawsig * 1 * gigain;default gain to 1 (JCN)
aline1         delayr    1.2
atap1          deltap    .1
atap2          deltap    .3
atap3          deltap    .5
atap4          deltap    .4
atap5          deltap    .2
               delayw    arawsig
kenv1          randi     .49,3,.666
kenv2          randi     .49,3.1,.555
kenv3          randi     .49,3.2,.444
kenv4          randi     .49,3.3,.333
kenv5          randi     .49,3.4,.222
kenv1          =         kenv1 + .5
kenv2          =         kenv2 + .5
kenv3          =         kenv3 + .5
kenv4          =         kenv4 + .5
kenv5          =         kenv5 + .5
atap1          =         atap1 * kenv1
atap2          =         atap2 * kenv1
atap3          =         atap3 * kenv1
atap4          =         atap4 * kenv1
atap5          =         atap5 * kenv1
aleft          =         (atap1*gil1)+(atap2*gil2)+(atap3*gil3)+(atap4*gil4)+(atap5*gil5)
aright         =         (atap1*gir1)+(atap2*gir2)+(atap3*gir3)+(atap4*gir4)+(atap5*gir5)
$outL.         =         (aleft*irev)+(arawsig*iorig)
$outR.         =         (aright*irev)+(arawsig*iorig)
#

#define rvb14m(in'out);E.Lyon´s Rev3 instrument, ;tighter reverb (Lyon uses a d/w mix of .5/.5)
#
;i1 0 dur file skip gain iorig

gifeed         =         .5
gilp1          =         1/30
gilp2          =         1/23
gilp3          =         1/41
giroll         =         2500
iorig          =         0;OUTPUTS ONLY WET SIGNAL (JCN)
irev           =         (1.0-iorig)

igain          =         1;(original default (JCN))
     ;FOR MONO INPUT 
     asigin    =         $in.
     asigin    =         asigin * igain
     ajunk     alpass    asigin,.7,.044
     aleft     alpass    ajunk,.3,.037

     kdel1     randi     .01,1,.666
     kdel1     =kdel1    + .02
     addl1     delayr    .3
     afeed1    deltapi   kdel1
     afeed1    = afeed1  + gifeed*aleft
               delayw    aleft

;GLOBAL REVERB

     aglobin   =         (afeed1)*.2
     atap1     comb      aglobin,3.3,gilp1
     atap2     comb      aglobin,3.3,gilp2
     atap3     comb      aglobin,3.3,gilp3
     aglobrev  alpass    atap1+atap2+atap3,2.6,.085
     aglobrev  tone      aglobrev,giroll

     kdel3     randi     .003,1,.888
     kdel3     =         kdel3 + .05
     addl3     delayr    .2
     agr1      deltapi   kdel3
               delayw    aglobrev


     arevl     =         agr1+afeed1
     $out.     =         (asigin*iorig)+(arevl*irev)
#


#define rvb15s(inL'inR'outL'outR);Lyon´s Rev4 reverb (Lyon suggests a d/w mix of .1/.9)
#
icombgain      =         .3
ialpassgain    =         .5
itapgain       =         .5
iglobgain      =         .9
irvt           =         1.7
iorig          =         0.0
irev           =         1.-iorig
ilp1a          =         1/11.1235
ilp1b          =         1/14.3716
ilp1c          =         1/17.691
ilp2a          =         1/13.5271
ilp2b          =         1/15.5351
ilp2c          =         1/19.1173
ipatk          =         .2
ipsust         =         p3-ipatk

     a1        =         $inL.
     a2        =         $inR.
     addl1     delayr    .2
     atap1a    deltap    .007
     atap1b    deltap    .011
     atap1c    deltap    .023
     atap1d    deltap    .047
     atap1e    deltap    .061
     atap1f    deltap    .079
     atap1g    deltap    .093
               delayw    a1
     addl2     delayr    .2
     atap2a    deltap    .005
     atap2b    deltap    .013
     atap2c    deltap    .027
     atap2d    deltap    .043
     atap2e    deltap    .071
     atap2f    deltap    .083
     atap2g    deltap    .107
               delayw    a2
     atap1a    =         atap1a*.9
     atap1b    =         atap1b*.8
     atap1c    =         atap1c*.7
     atap1d    =         atap1d*.6
     atap1e    =         atap1e*.5
     atap1f    =         atap1f*.4
     atap1g    =         atap1g*.3
     atap2a    =         atap2a*.9
     atap2b    =         atap2b*.8
     atap2c    =         atap2c*.7
     atap2d    =         atap2d*.6
     atap2e    =         atap2e*.5
     atap2f    =         atap2f*.4
     atap2g    =         atap2g*.3
     at1       =         atap1a+atap1b+atap1c+atap1d+atap1e+atap1f+atap1g
     at2       =         atap2a+atap2b+atap2c+atap2d+atap2e+atap2f+atap2g
     at1       =         at1*itapgain
     at2       =         at2*itapgain
     ap1a      alpass    at1,.5,.0467
     ap1       alpass    ap1a,3,.0731
     ap2a      alpass    at2,.5,.0531
     ap2       alpass    ap2a,3,.0697
     ap1       =         ap1*ialpassgain
     ap2       =         ap2*ialpassgain
     kpenv     linseg    0,ipatk,1,ipsust,1
     acp1      =         kpenv*ap1
     acp2      =         kpenv*ap2
     acomb1a   comb      acp1,irvt,ilp1a
     acomb1b   comb      acp1,irvt,ilp1b
     acomb1c   comb      acp1,irvt,ilp1c
     acomb2a   comb      acp2,irvt,ilp2a
     acomb2b   comb      acp2,irvt,ilp2b
     acomb2c   comb      acp2,irvt,ilp2c
     ac1       =         (acomb1a+acomb1b+acomb1c)*icombgain
     ac2       =         (acomb2a+acomb2b+acomb2c)*icombgain
     arev1     =         at1+ap1+ac1
     arev2     =         at2+ap2+ac2
     $outL.    =         iglobgain*((arev1*irev)+(a1*iorig))
     $outR.    =         iglobgain*((arev2*irev)+(a2*iorig))
#

#define rvb16m(in'out);Lyon´s Rev5 reverb
#
;1 in 1 out

iorig          =         0;original w/d mix is .4/.6
igain          =         1
istretch       =         1;this p-field is not in the sco - default 1 (JCN)
irvt1          =         .2*istretch
irvt2          =         .5*istretch
irvt3          =         2.1*istretch
irvt4          =         3.06*istretch

irev           =         1-iorig

     araw      =         $in.
     araw      =         araw*igain
     ar1       alpass    araw,irvt1,.04
     ar2       alpass    ar1,irvt2,.035
     ar3       alpass    ar2,irvt3,.065
     ar4       alpass    ar3,irvt4,.0491
     arl1      tone      ar1,10000
     arl2      tone      ar2,6000
     arl3      tone      ar3,3000
     arl4      tone      ar4,1000
     arev      =         arl1+arl2+arl3+arl4
     $out.     =         (irev*arev);+(iorig*araw);removed dry sig. from the mix (JCN)
#


#define rvb17m(in'outL'outR);Lyon´s Rev6 reverb
#
;1 in 2 out ambient
;echo_rvt echolpt1 echolpt2 iorig iecho

igain          =         1.000000
irvt1          =         2.421249              ; AUDIO COMB REVERB LENGTH
ilpt1          =         1/35.801517            ; AUDIO COMB RESONANCES
ilpt2          =         1/34.275620 
ilpt3          =         1/46.886345 
ilpt4          =         1/51.539425 
iechot         =         0.575749             ;ECHO LENGTH
ilpt5          =         0.098021             ; ECHO LOOPTIMES
ilpt6          =         0.069816 
iorig          =         0; original score :d/w mix of .6/.4
iecho          =         0.247023 
irev           =         1.-iorig
ialpt          =         0.07
ijuice         =         .6
iroll          =         2000
ipres          =         5000
ipbw           =         1000
iatk           =         0.01
idk            =         .05
isust          =         p3-(iatk+idk)
     aenv      linseg    0,iatk,igain,isust,igain,idk,0
     araw      =         $in.
     acmb1     comb      araw,irvt1,ilpt1
     acmb2     comb      araw,irvt1,ilpt2
     acmb3     comb      araw,irvt1,ilpt3
     acmb4     comb      araw,irvt1,ilpt4
     acmbmix1  =         acmb1+acmb2*.5+acmb3*.25+acmb4*.125
     acmbmix2  =         acmb4+acmb3*.5+acmb2*.25+acmb1*.125
     aecho1    comb      acmbmix1,ilpt5,iechot
     aecho2    comb      acmbmix2,ilpt5,iechot
     aecmix1   =         (acmbmix1*ijuice)+(aecho1*iecho)
     aecmix2   =         (acmbmix2*ijuice)+(aecho2*iecho)
     alp1      alpass    aecmix2,ialpt,.06
     alp2      alpass    aecmix1,ialpt,.063
     apres1    reson     alp1,ipres,ipbw,1
     apres2    reson     alp2,ipres,ipbw,1
     arevraw1  =         aecmix1+alp1
     arevraw2  =         aecmix2+alp2
     alpf1     tone      arevraw1,iroll
     alpf2     tone      arevraw2,iroll
     ao        =         araw*iorig
     $outL.    =         aenv*(ao+(alpf1+apres1)*irev)
     $outR.    =         aenv*(ao+(alpf2+apres2)*irev)
#

#define rvb18m(in'out);Lyon´s Rev7 reverb
#
;MONO -> MONO REVERB
; INDUSTRIAL SOUND
;i1 0 dur file skip srcdur gain revtime
 ;1 0  3  1     0       .8  1     3


indur          =         p3;what´s that???.8;com????
igain          =         1
irvt           =         3
itail          =         p3 - indur
idel1          =         .07
idel2          =         idel1 + .053
;irvt          =         1.33
iclpt1         =         1/33
iclpt2         =         1/47.12
iclpt3         =         1/53.59
iclpt4         =         1/67.13
iclpt5         =         1/83.16
iclpt6         =         1/106.0
iallrvt        =         .15
iall1          =         .02
iall2          =         .031
iorig          =         0; suggested d/w mix : .7/.3
irev           =         (1.-iorig) 
               timout    indur, itail, contin
araw           =         $in.
araw           =         araw * igain
contin: adel1  delay     araw,idel1
adel2          delay     araw,idel2
acmb1          comb      araw, irvt, iclpt1
acmb2          comb      araw, irvt, iclpt2
acmb3          comb      adel1, irvt, iclpt3
acmb4          comb      adel1, irvt, iclpt4
acmb5          comb      adel2, irvt, iclpt5
acmb6          comb      adel2, irvt, iclpt6
acmbsum1       =         acmb1+acmb3+acmb5
acmbsum2       =         acmb2+acmb4+acmb6
allp1          alpass    acmbsum1,iallrvt,iall1
allp2          alpass    acmbsum2,iallrvt,iall2
arev           =         allp1+allp2
arev           =         arev * irev
alrev          atone     arev, 50
araw           =         araw * iorig
$out.          =         alrev+araw
#


#define rvb19m(in'out);Lyon´s Rev8 reverb
#
;MONO -> MONO REVERB
;WITH RESONANCE MOVING
irvt           =         1.5
indur          =         p3-.8;not sure about this (JCN)
igain          =         1
iorig          =         0;original d/w mix is .4/.6
itail          =         p3 - indur
irev           =         1. - iorig
                                        ;NEXT LINE ONLY FOR STEREO OUTPUT
;iorig          =         iorig * .707
ibfac          =         .15
idev           =         .3
icf1           =         4000
icf2           =         2000
icf3           =         1000
icf1amp        =         icf1*idev
icf2amp        =         icf2*idev
icf3amp        =         icf3*idev
irspeed1       =         .61
irspeed2       =         .72
irspeed3       =         .819
icmbres1       =         37.5
icmbres2       =         39.1352
icmbres3       =         30.8677
icmbres4       =         32.7032
icmbres5       =         34.6478
icmbres6       =         36.7081
ilp1           =         1./icmbres1
ilp2           =         1./icmbres2
ilp3           =         1./icmbres3
ilp4           =         1./icmbres4
ilp5           =         1./icmbres5
ilp6           =         1./icmbres6
idev2          =         .5
ibfac2         =         .5
icf4           =         3000
icf5           =         5000
icf4amp        =         icf4*idev2
icf5amp        =         icf5*idev2
irspeed4       =         .21
irspeed5       =         .389
               timout    indur, itail, contin
     araw      =         $in.
     araw      =         araw * igain
     contin:
     kcfdev1   oscil     icf1amp,irspeed1,1
     kcf1      =         icf1 + kcfdev1
     kbw1      =         kcf1 * ibfac
     ares1     reson     araw, kcf1, kbw1, 1
     kcfdev2   oscil     icf2amp,irspeed2,1
     kcf2      =         icf2 + kcfdev2
     kbw2      =         kcf2 * ibfac
     ares2     reson     araw, kcf2, kbw2, 1
     kcfdev3   oscil     icf3amp,irspeed3,1
     kcf3      =         icf3 + kcfdev3
     kbw3      =         kcf3 * ibfac
     ares3     reson     araw, kcf3, kbw3, 1
     acomb1    comb      ares1, irvt, ilp1
     acomb2    comb      ares1, irvt, ilp2
     acomb3    comb      ares2, irvt, ilp3
     acomb4    comb      ares2, irvt, ilp4
     acomb5    comb      ares3, irvt, ilp5
     acomb6    comb      ares3, irvt, ilp6
     acsum1    =         acomb1+acomb3+acomb5
     acsum2    =         acomb2+acomb4+acomb6
     kcfdev4   oscil     icf4amp,irspeed4,1
     kcf4      =         icf4 + kcfdev4
     kbw4      =         kcf4 * ibfac
     ares4     reson     acsum1, kcf4, kbw4, 1
     kcfdev5   oscil     icf5amp,irspeed5,1
     kcf5      =         icf5 + kcfdev5
     kbw5      =         kcf5 * ibfac
     ares5     reson     acsum2, kcf5, kbw5, 1
     ; MONO OUTPUT
     arev     =         ares4 + ares5
     $out.    =         (iorig*araw)+(irev*arev)
#

#define rvb19s(inL'inR'outL'outR);Lyon´s Rev8 reverb STEREO->STEREO version
#
irvt           =         1.5
indur          =         p3-.8;not sure about this (JCN)
igain          =         1
iorig          =         0;original d/w mix is .4/.6
itail          =         p3 - indur
irev           =         1. - iorig
     ;NEXT LINE ONLY FOR STEREO OUTPUT
iorig          =         iorig * .707
ibfac          =         .15
idev           =         .3
icf1           =         4000
icf2           =         2000
icf3           =         1000
icf1amp        =         icf1*idev
icf2amp        =         icf2*idev
icf3amp        =         icf3*idev
irspeed1       =         .61
irspeed2       =         .72
irspeed3       =         .819
icmbres1       =         37.5
icmbres2       =         39.1352
icmbres3       =         30.8677
icmbres4       =         32.7032
icmbres5       =         34.6478
icmbres6       =         36.7081
ilp1           =         1./icmbres1
ilp2           =         1./icmbres2
ilp3           =         1./icmbres3
ilp4           =         1./icmbres4
ilp5           =         1./icmbres5
ilp6           =         1./icmbres6
idev2          =         .5
ibfac2         =         .5
icf4           =         3000
icf5           =         5000
icf4amp        =         icf4*idev2
icf5amp        =         icf5*idev2
irspeed4       =         .21
irspeed5       =         .389
               timout    indur, itail, contin
     a1        =         $inL.
     a2        =         $inR.
     a1        =         a1 * igain
     a2        =         a2 * igain
     contin:
     kcfdev1   oscil     icf1amp,irspeed1,1
     kcf1      =         icf1 + kcfdev1
     kbw1      =         kcf1 * ibfac
     ares1     reson     a1, kcf1, kbw1, 1
     kcfdev2   oscil     icf2amp,irspeed2,1
     kcf2      =         icf2 + kcfdev2
     kbw2      =         kcf2 * ibfac
     ares2     reson     a2, kcf2, kbw2, 1
     kcfdev3   oscil     icf3amp,irspeed3,1
     kcf3      =         icf3 + kcfdev3
     kbw3      =         kcf3 * ibfac
     ares3     reson     a1+a2, kcf3, kbw3, 1
     acomb1    comb      ares1, irvt, ilp1
     acomb2    comb      ares1, irvt, ilp2
     acomb3    comb      ares2, irvt, ilp3
     acomb4    comb      ares2, irvt, ilp4
     acomb5    comb      ares3, irvt, ilp5
     acomb6    comb      ares3, irvt, ilp6
     acsum1    =         acomb1+acomb3+acomb5
     acsum2    =         acomb2+acomb4+acomb6
     kcfdev4   oscil     icf4amp,irspeed4,1
     kcf4      =         icf4 + kcfdev4
     kbw4      =         kcf4 * ibfac
     ares4     reson     acsum1, kcf4, kbw4, 1
     kcfdev5   oscil     icf5amp,irspeed5,1
     kcf5      =         icf5 + kcfdev5
     kbw5      =         kcf5 * ibfac
     ares5     reson     acsum2, kcf5, kbw5, 1
     ; STEREO OUTPUT
     $outL.    =         ares4*irev + (a1*iorig)
     $outR.    =         ares5*irev + (a2*iorig)
#

#define rvb20m(in'out);Lyon´s Rev9 reverb
#
idev1          =         .02
imax1          =         idev1 * 2.1
iorig          =         0; original d/w mix : .6/.4
irev           =         1.-iorig
iegain         =         .2
icgain         =         .05
iagain         =         iorig/2

ihpf           =         50
icmblpf        =         2700
ieclp1         =         .1
ieclp2         =         .1327
ieclp3         =         .0639
ieclp4         =         .184
iecrvt         =         1.0
icombrvt       =         1.8
ilpt1          =         1/30
ilpt2          =         1/38
ilpt3          =         1/43
ilpt4          =         1/51
iallrvt        =         .1
     araw      =         $in.
     aec1      comb      araw, iecrvt, ieclp1
     aec2      comb      araw, iecrvt, ieclp2
     aec3      comb      araw, iecrvt, ieclp3
     aec4      comb      araw, iecrvt, ieclp4
     aec       =         aec1+aec2+aec3+aec4
     aecho1    atone     aec, ihpf
     ; FUNC205 IS RAISED AMP=1 COSINE WITH SMALL DC (.05 )
     adel1     oscil     idev1, 1.4, 205
     adel2     oscil     idev1, 1.63, 205
     adel3     oscil     idev1, 1.871, 205
     addl1     delayr    imax1
     atap1     deltapi   adel1
     atap2     deltapi   adel2
     atap3     deltapi   adel3
               delayw    aecho1
     aecho     =         (atap1+atap2+atap3) 
     ;acomb1   comb      aecho, icombrvt, ilpt1
     ;acomb2   comb      aecho, icombrvt, ilpt2
     ;acomb3   comb      aecho, icombrvt, ilpt3
     ;acomb4   comb      aecho, icombrvt, ilpt4
     ;asum     =         acomb1 + acomb2 + acomb3
     ;acomb    tone      asum, icmblpf
     ;acomb    =         acomb * icgain
     asum2     =         aecho * iegain

     ;asum2    =         acomb + aecho
     all1      alpass    asum2, iallrvt, .006
     all2      alpass    asum2, iallrvt, .007
     all3      alpass    araw, 2.0, .03
     all3lp    tone      all3, 2000
     arev      =         all1 + all2 
     $out.     =         (irev*arev)+(iorig*araw)+(all3lp*iagain)
#

#define rvb21s(inL'inR'outL'outR);Lyon´s Rev10 reverb 
;2IN 2OUT WET REVERB
#
igain          =         .5 * 3
it1d1          =         .023
it1d2          =         .027
it1d3          =         .031
it2d1          =         .029
it2d2          =         .039
it2d3          =         .037
itapgain       =         .2
iallrvt        =         2.0
ilpfraw        =         3000
icombrvt       =         2.5
ilpt1a         =         1/79.3
ilpt1b         =         1/69.3
ilpt1c         =         1/59.3
ilpt2a         =         1/73.3
ilpt2b         =         1/64.3
ilpt2c         =         1/55.3
icombgain      =         .33
icomblpf       =         600
a1in           =         $inL.
a2in           =         $inR.
a1in           =         a1in * igain
a2in           =         a2in * igain
atap1a         delay     a1in, it1d1
atap1b         delay     a1in, it1d2
atap1c         delay     a1in, it1d3
atap2a         delay     a2in, it2d1
atap2b         delay     a2in, it2d2
atap2c         delay     a2in, it2d3
atap1sum       =         (atap1a+atap1b+atap1c)*itapgain
atap2sum       =         (atap2a+atap2b+atap2c)*itapgain
aall1          alpass    atap1sum, iallrvt, .06
aall2          alpass    atap2sum, iallrvt, .06
ain1sum        =         a1in+aall1
ain2sum        =         a2in+aall2
araw1          atone     ain1sum, ilpfraw
araw2          atone     ain2sum, ilpfraw
; MIDLEVEL REVERB
acomb1a        comb      araw1, icombrvt, ilpt1a
acomb1b        comb      araw1, icombrvt, ilpt1b
acomb1c        comb      araw1, icombrvt, ilpt1c
acomb2a        comb      araw2, icombrvt, ilpt2a
acomb2b        comb      araw2, icombrvt, ilpt2b
acomb2c        comb      araw2, icombrvt, ilpt2c
acombsum1      =         (acomb1a+acomb1b+acomb1c)
acombsum2      =         (acomb2a+acomb2b+acomb2c)
alpfc1         tone      acombsum1, icomblpf
alpfc2         tone      acombsum2, icomblpf
acdel1         delay     alpfc1, .03
acdel1         =         acdel1 * .4
acdel2         delay     alpfc2, .015
acdel2         =         acdel2 * .4
alpfc1         =         alpfc1 + acdel1
alpfc2         =         alpfc2 + acdel2
               ; sum     raw + comb
arcsum1        =         alpfc1 + araw1
arcsum2        =         alpfc2 + araw2
iechorvt       =         4.5
ielpt1a        =         .237
ielpt1b        =         .391
ielpt1c        =         .473
ielpt2a        =         .221
ielpt2b        =         .385
ielpt2c        =         .507
irawgain       =         0; original d=.6 (JCN)
ilpfcgain      =         .1
iechogain      =         .1
aecho1a        comb      arcsum1, iechorvt, ielpt1a
aecho1b        comb      arcsum1, iechorvt, ielpt1b
aecho1c        comb      arcsum1, iechorvt, ielpt1c
aecho2a        comb      arcsum2, iechorvt, ielpt2a
aecho2b        comb      arcsum2, iechorvt, ielpt2b
aecho2c        comb      arcsum2, iechorvt, ielpt2c
aecho1sum      =         (aecho1a+aecho1b+aecho1c)
aecho2sum      =         (aecho2a+aecho2b+aecho2c)
$outL.         =         (araw1*irawgain)+(alpfc1*ilpfcgain)+(aecho1sum*iechogain)
$outR.         =         (araw2*irawgain)+(alpfc2*ilpfcgain)+(aecho2sum*iechogain)
#

#define rvb22s(in'outL'outR);Lyon´s Rev11 reverb
#
gipiotwo  =         1.571
; MONO IN, STEREO OUT - ALLPASS REVERB WITH SPATIALIZED RESONANCE
il1       =         .55
il2       =         .15
il3       =         .65
il4       =         .25
il5       =         .75
il6       =         .35
il7       =         .85
il8       =         .45

gil1      =         sin(il1 * gipiotwo)
gil2      =         sin(il2 * gipiotwo)
gil3      =         sin(il3 * gipiotwo)
gil4      =         sin(il4 * gipiotwo)
gil5      =         sin(il5 * gipiotwo)
gil6      =         sin(il6 * gipiotwo)
gil7      =         sin(il7 * gipiotwo)
gil8      =         sin(il8 * gipiotwo)
gir1      =         cos(il1 * gipiotwo)
gir2      =         cos(il2 * gipiotwo)
gir3      =         cos(il3 * gipiotwo)
gir4      =         cos(il4 * gipiotwo)
gir5      =         cos(il5 * gipiotwo)
gir6      =         cos(il6 * gipiotwo)
gir7      =         cos(il7 * gipiotwo)
gir8      =         cos(il8 * gipiotwo)

icf1      =         100
icf2      =         200
icf3      =         400
icf4      =         800
icf5      =         1600
icf6      =         3200
icf7      =         6400
icf8      =         12800
ibfac     =         .6
ibw1      =         icf1 * ibfac
ibw2      =         icf2 * ibfac
ibw3      =         icf3 * ibfac
ibw4      =         icf4 * ibfac
ibw5      =         icf5 * ibfac
ibw6      =         icf6 * ibfac
ibw7      =         icf7 * ibfac
ibw8      =         icf8 * ibfac
ilpt1     =         .037
ilpt2     =         .047
ilpt3     =         .0513
ilpt4     =         .0638
ilpt5     =         .0821
ilpt6     =         .0916
ilpt7     =         .114
ilpt8     =         .237
irvt1     =         3.
irvt2     =         2.13
irvt3     =         2.27
irvt4     =         1.56
irvt5     =         1.1
irvt6     =         .8
irvt7     =         .4
irvt8     =         .2
amono     =         $in.
arev1     alpass    amono, irvt1, ilpt1
arev2     alpass    amono, irvt2, ilpt2
arev3     alpass    amono, irvt3, ilpt3
arev4     alpass    amono, irvt4, ilpt4
arev5     alpass    amono, irvt5, ilpt5
arev6     alpass    amono, irvt6, ilpt6
arev7     alpass    amono, irvt7, ilpt7
arev8     alpass    amono, irvt8, ilpt8
ares1     reson     arev1, icf1, ibw1, 1
ares2     reson     arev2, icf2, ibw2, 1
ares3     reson     arev3, icf3, ibw3, 1
ares4     reson     arev4, icf4, ibw4, 1
ares5     reson     arev5, icf5, ibw5, 1
ares6     reson     arev6, icf6, ibw6, 1
ares7     reson     arev7, icf7, ibw7, 1
ares8     reson     arev8, icf8, ibw8, 1
alsub1    =         (ares1*gil1)+(ares2*gil2)+(ares3*gil3)+(ares4*gil4)
alsub2    =         (ares5*gil5)+(ares6*gil6)+(ares7*gil7)+(ares8*gil8)
$outL.    =         alsub1 + alsub2
arsub1    =         (ares1*gir1)+(ares2*gir2)+(ares3*gir3)+(ares4*gir4)
arsub2    =         (ares5*gir5)+(ares6*gir6)+(ares7*gir7)+(ares8*gir8)
$outR.    =         arsub1 + arsub2
#


#define rvb23s(inL'inR'outL'outR);Lyon´s Rev12 reverb
#
;CHORUS, COMB BASED REVERB - STEREO IN STEREO OUT,
;ins start dur  sndin   skip   gain  %_of_original_signal   soundin_duration   attack
;i1   0     7    5       0      1     .5                      2.5               .01

gifeed 	= 		.5
gilp1 	= 		1/10
gilp2 	= 		1/23
gilp3 	= 		1/41
giroll 	= 		3000
inputdur	= 		p3;p8 hmm not sure about this...(JCN)
iatk 	      = 		.01
idk 		= 		.2
idecay 	= 		.2

; DATA FOR OUTPUT ENVELOPE
ioutsust	= 		p3-idecay
idur 	= 		inputdur-(iatk+idk)
isust 	= 		p3-(iatk+idur+idk)
iorig 	= 		0;original d/w mix : .5/.5
irev 	= 		1.0-iorig
igain 	= 		1

 ;FOR STEREO INPUT
 kclean 	linseg 	0,iatk,igain,idur,igain,idk,0,isust,0
 ain1       =           $inL.
 ain2       =           $inR.
 ain1 	= 		ain1*kclean
 ain2 	= 		ain2*kclean
 ajunk 	alpass 	ain1,1.7,.1
 aleft 	alpass 	ajunk,1.01,.07
 ajunk 	alpass 	ain2,1.5,.2
 aright 	alpass 	ajunk,1.33,.05

kdel1 	randi 	.01,1,.666
kdel1 	=		kdel1 + .1
addl1 	delayr 	.3
afeed1 	deltapi 	kdel1
afeed1 	= 		afeed1 + gifeed*aleft
		delayw 	aleft

kdel2 	randi 	.01,.95,.777
kdel2 	= 		kdel2 + .1
addl2 	delayr 	.3
afeed2 	deltapi 	kdel2
afeed2 	= 		afeed2 + gifeed*aright
		delayw	 aright

; GLOBAL REVERB

aglobin 	= 		(afeed1+afeed2)*.05
atap1 	comb 	aglobin,3.3,gilp1
atap2 	comb 	aglobin,3.3,gilp2
atap3 	comb 	aglobin,3.3,gilp3
aglobrev 	alpass 	atap1+atap2+atap3,2.6,.085
aglobrev 	tone 	aglobrev,giroll

kdel3 	randi 	.003,1,.888
kdel3 	=		kdel3 + .05
addl3 	delayr 	.2
agr1 	deltapi 	kdel3
		delayw 	aglobrev

kdel4 	randi 	.003,1,.999
kdel4 	=		kdel4 + .05
addl4 	delayr 	.2
agr2 	deltapi 	kdel4
		delayw 	aglobrev

arevl 	= 		agr1+afeed1
arevr 	= 		agr2+afeed2
; FOR STEREO INPUT
 aoutl 	= 		(arevl*irev);removed dry signal from the mix (JCN)
 aoutr 	= 		(arevr*irev)

kout 	linseg 	1,ioutsust,1,idecay,0
$outL.      =            aoutl*kout
$outR.      =            aoutr*kout
#

#define rvb24s(in'outL'outR);Lyon´s Reverb2 reverb
#
; PANNING TAP BASED STEREO REVERB : MONO INPUT ONLY
gigain    =         1
gipiotwo  =         1.571

gil1      =         sin(0)
gil2      =         sin((1/5) * gipiotwo)
gil3      =         sin((2/5) * gipiotwo)
gil4      =         sin((3/5) * gipiotwo)
gil5      =         sin((4/5) * gipiotwo)
gil6      =         sin((1) * gipiotwo)
gir1      =         cos(0)
gir2      =         cos((1/5) * gipiotwo)
gir3      =         cos((2/5) * gipiotwo)
gir4      =         cos((3/5) * gipiotwo)
gir5      =         cos((4/5) * gipiotwo)
gir6      =         cos((1) * gipiotwo)

iorig     =         0;original dry/wet range from .1/.9 to .9/.1
irev      =         1-iorig
arawsig   =         $in.
arawsig   =         arawsig * gigain;arawsig * p6 * gigain
aline1    delayr    1.2
atap1     deltap    .1
atap2     deltap    .3
atap3     deltap    .5
atap4     deltap    .4
atap5     deltap    .2
          delayw    arawsig
kenv1     randi     .49,3,.666
kenv2     randi     .49,3.1,.555
kenv3     randi     .49,3.2,.444
kenv4     randi     .49,3.3,.333
kenv5     randi     .49,3.4,.222
kenv1     =         kenv1 + .5
kenv2     =         kenv2 + .5
kenv3     =         kenv3 + .5
kenv4     =         kenv4 + .5
kenv5     =         kenv5 + .5
atap1     =         atap1 * kenv1
atap2     =         atap2 * kenv1
atap3     =         atap3 * kenv1
atap4     =         atap4 * kenv1
atap5     =         atap5 * kenv1
aleft     =         (atap1*gil1)+(atap2*gil2)+(atap3*gil3)+(atap4*gil4)+(atap5*gil5)
aright    =         (atap1*gir1)+(atap2*gir2)+(atap3*gir3)+(atap4*gir4)+(atap5*gir5)
$outL.    =         (aleft*irev);+(arawsig*iorig);dry signal removed (JCN)
$outR.    =         (aright*irev);+(arawsig*iorig)
#

#define xrvb25s(in'out'rvbt);Brandt´s Moorer´s reverb implementation
#
; Moorer's circulating-delay reverb, w/ lowpasses.
; and fine-tuned early echoes.
; fancy Moorer-17

   idur = p3
   iamp = 1
   ;ipan = .5;removed:panning of a mono reverb is up to you (JCN)
   iwetmix = 1;original dry/wet mix : 1/.3 (!)
   irvbtime = $rvbt.

   adry         =      $in.
   adry = adry*iamp

   iloop1 = .050                ; comb lengths
   iloop2 = .056
   iloop3 = .061
   iloop4 = .068
   iloop5 = .072
   iloop6 = .078
   
                                ; gains forming the lowpasses in the combs
   ifiltscale = sr/25000                ; (a cheap hack)
   ifiltgain1 = .24*ifiltscale
   ifiltgain2 = .26*ifiltscale
   ifiltgain3 = .28*ifiltscale
   ifiltgain4 = .29*ifiltscale
   ifiltgain5 = .30*ifiltscale
   ifiltgain6 = .32*ifiltscale

                                ; calc remix gains for correct -60dB time
   igain1 = exp( log(.001)*(iloop1/irvbtime) ) * (1-ifiltgain1)
   igain2 = exp( log(.001)*(iloop2/irvbtime) ) * (1-ifiltgain2)
   igain3 = exp( log(.001)*(iloop3/irvbtime) ) * (1-ifiltgain3)
   igain4 = exp( log(.001)*(iloop4/irvbtime) ) * (1-ifiltgain4)
   igain5 = exp( log(.001)*(iloop5/irvbtime) ) * (1-ifiltgain5)
   igain6 = exp( log(.001)*(iloop6/irvbtime) ) * (1-ifiltgain6)

   acomb1       delayr  iloop1
   afeedback1 = adry + igain1*acomb1
   afilt1       delay1  afeedback1
                delayw  afeedback1 + afilt1*ifiltgain1
                
   acomb2       delayr  iloop2
   afeedback2 = adry + igain2*acomb2
   afilt2       delay1  afeedback2
                delayw  afeedback2 + afilt2*ifiltgain2
                
   acomb3       delayr  iloop3
   afeedback3 = adry + igain3*acomb3
   afilt3       delay1  afeedback3
                delayw  afeedback3 + afilt3*ifiltgain3
                
   acomb4       delayr  iloop4
   afeedback4 = adry + igain4*acomb4
   afilt4       delay1  afeedback4
                delayw  afeedback4 + afilt4*ifiltgain4
                
   acomb5       delayr  iloop5
   afeedback5 = adry + igain5*acomb5
   afilt5       delay1  afeedback5
                delayw  afeedback5 + afilt5*ifiltgain5
                
   acomb6       delayr  iloop6
   afeedback6 = adry + igain6*acomb6
   afilt6       delay1  afeedback6
                delayw  afeedback6 + afilt6*ifiltgain6

   alate = (acomb1+acomb2+acomb3+acomb4+acomb5+acomb6)
   alate        alpass  alate, .12, .006

   iecho1time  = .0043          ; early echo times
   iecho2time  = .0215
   iecho3time  = .0225
   iecho4time  = .0268
   iecho5time  = .0270
   iecho6time  = .0298
   iecho7time  = .0458
   iecho8time  = .0485
   iecho9time  = .0572
   iecho10time = .0587
   iecho11time = .0595
   iecho12time = .0612
   iecho13time = .0707
   iecho14time = .0708
   iecho15time = .0726
   iecho16time = .0741
   iecho17time = .0753
   iecho18time = .0797

   iecho1gain  = .841           ; early echo gains
   iecho2gain  = .504
   iecho3gain  = .491 
   iecho4gain  = .379
   iecho5gain  = .380
   iecho6gain  = .346
   iecho7gain  = .289
   iecho8gain  = .272
   iecho9gain  = .192
   iecho10gain = .193
   iecho11gain = .217
   iecho12gain = .181
   iecho13gain = .180
   iecho14gain = .181
   iecho15gain = .176
   iecho16gain = .142
   iecho17gain = .167
   iecho18gain = .134
    
   adump        delayr  .1
   aecho1       deltap  iecho1time
   aecho1 = aecho1*iecho1gain
   aecho2       deltap  iecho2time
   aecho2 = aecho2*iecho2gain
   aecho3       deltap  iecho3time
   aecho3 = aecho3*iecho3gain
   aecho4       deltap  iecho4time
   aecho4 = aecho4*iecho4gain
   aecho5       deltap  iecho5time
   aecho5 = aecho5*iecho5gain
   aecho6       deltap  iecho6time
   aecho6 = aecho6*iecho6gain
   aecho7       deltap  iecho7time
   aecho7 = aecho7*iecho7gain
   aecho8       deltap  iecho8time
   aecho8 = aecho8*iecho8gain
   aecho9       deltap  iecho9time
   aecho9 = aecho9*iecho9gain
   aecho10      deltap  iecho10time
   aecho10 = aecho10*iecho10gain
   aecho11      deltap  iecho10time
   aecho11 = aecho11*iecho11gain
   aecho12      deltap  iecho11time
   aecho12 = aecho12*iecho12gain
   aecho13      deltap  iecho12time
   aecho13 = aecho13*iecho13gain
   aecho14      deltap  iecho13time
   aecho14 = aecho14*iecho14gain
   aecho15      deltap  iecho14time
   aecho15 = aecho15*iecho15gain
   aecho16      deltap  iecho15time
   aecho16 = aecho16*iecho16gain
   aecho17      deltap  iecho16time
   aecho17 = aecho17*iecho17gain
   aecho18      deltap  iecho17time
   aecho18 = aecho18*iecho18gain

   aearly = aecho1+aecho2+aecho3+aecho4+aecho5+aecho6+aecho7+aecho8+aecho9
   aearly = aearly+aecho10+aecho11+aecho12+aecho13+aecho14+aecho15+aecho16+aecho17+aecho18

   alate2       delay   alate, .015
   awet = aearly + alate2

   ;aout = adry + awet*iwetmix
   aout = awet*iwetmix;removed dry signal from the mix (JCN)
 ;as STEREO output was a simple panning of a true MONO output I changed the output to MONO
   $out. = aout
#


