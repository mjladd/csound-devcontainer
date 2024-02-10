<CsoundSynthesizer>
<CsOptions>
--output=coda.aiff -r44100 -k441
</CsOptions>
<CsInstruments>
; coda.orc                                        ; FM INSTR WITH EXCESSIVE REVERB

sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2

garvbsig  init      0                             ; GLOBAL AUDIO REVERB SIGNAL

; INITIALIZATION

; p4      =         amplitude of output wave
; p5      =         carrier frequency specified in Hz
; p6      =         modulating frequency in Hz
; p7      =         modulation index 1
; p8      =         modulation index 2

          instr 1                                 ; FM INSTRUMENT

iamp1     =         p7 * p6                       ; amp for amod
iamp2     =         (p8-p7) * p6                  ; amp for ampmod
k1        randi     120, 10                       ; xamp, xcps
k2        randi     200, 20                       ; xamp, xcps
ampcar    oscil     p4, 1/p3, 1                   ; amp for carrier
ampmod    oscil     iamp2, 1/p3, 1                ; amp for modulator

amod      oscili    ampmod+iamp1, p6 + k1, 1      ; mod freq for global signal
gasig     oscili    ampcar, k2 + p5 + amod, 1     ; global signal
          outs1     gasig * .25                   ; left direct audio output
          outs2     gasig * .25                   ; right direct audio output
garvbsig  =         garvbsig + gasig * .25        ; add audio to audio receiver
; PRIOR TO PAN
          endin


          instr 99                                ; global reverb instrument

irvbtime  =         p4                            ; seconds for signal to decay
; 60 dB
asig2     reverb    garvbsig, irvbtime            ; put global sig into reverb
          outs1     asig2                         ; output reverb signal left
          outs2     asig2                         ; output reverb signal right
garvbsig  =         0                                       ; reinitialize
          endin

</CsInstruments>
<CsScore>
; CODA.SCO

; p4 = amplitude of output wave
; p5 = carrier frequency specified in Hz
; p6 = modulating frequency in Hz
; p7 = modulation index 1
; p8 = modulation index 2


f1  0   1024    9   1   1   0   3   4   0   4   12  0
;------------------------------------------------------
; sine wave with partial, strength, phase
;------------------------------------------------------

;p1 p2  p3  p4  p5  p6  p7  p8
;------------------------------------------------------
;instr  strt    dur amp cfrq    mfreq   modi1   modi2
;------------------------------------------------------
i1  0   16  2500    150 300 5   10
i1  7   14  <   <   <   <   <
i1  12  20  3600    300 650 10  20


;p1 p2  p3  p4
;------------------------------------------------------
;instr  strt    dur rvbtm
;------------------------------------------------------
i99 0   67  35
e

</CsScore>
</CsoundSynthesizer>

