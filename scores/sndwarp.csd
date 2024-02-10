<CsoundSynthesizer>

<CsOptions>
; XO
;-+rtmidi=alsa  --midi-device=hw:1,0 -+rtaudio=alsa -odac -r16000 -k160 ;-O stdout
; Mac
--output=sndwarp.aiff -r44100 -k441
</CsOptions>

<CsInstruments>
; Instrument #1 - play an audio file.
instr 1
  ; Use the audio file defined in Table #1.
 a1      diskin2     "glass.aiff", 1, 0, 1

  out a1
endin

; Instrument #2 - time-stretch an audio file.
instr 2
  kamp init 6500
  ; Start at 1 second and end at 3.5 seconds.
  ktimewarp line 1, p3, 3.5
  ; Playback at the normal speed.
  kresample init 1
  ; Use the audio file defined in Table #1.
  ifn1 = 1
  ibeg = 0
  iwsize = 4410
  irandw = 882
  ioverlap = 15
  ; Use Table #2 for the windowing function.
  ifn2 = 2
  ; Use the ktimewarp parameter as a "time" pointer.
  itimemode = 1

  a1 sndwarp kamp, ktimewarp, kresample, ifn1, ibeg, iwsize, irandw, ioverlap, ifn2, itimemode
  out a1
endin
</CsInstruments>
<CsScore>
f 1 0 [16384*4] 1 "glass.aiff" 0 4 0
f 2 0 16384 9 0.5 1 0

; Play Instrument #1 for 3.5 seconds.
i 1 0 3.5
; Play Instrument #2 for 7 seconds (time-stretched).
i 2 3.5 10.5
e
</CsScore>

</CsoundSynthesizer>