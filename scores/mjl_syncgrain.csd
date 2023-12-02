<CsoundSynthesizer>
<CsOptions>
--output=mjl_syncgrain_female.aiff -r44100 -k441
</CsOptions>
<CsInstruments>

sr = 44100  ;Sample Rate

ksmps = 32
nchnls = 2  ;Number of Channels
0dbfs  = 1  ;Max amplitude

instr 1

iolaps = 2
igrsize = 0.4
ifreq = iolaps/igrsize
ips = 1/iolaps

istr = .3
ipitch = p4

;asig    syncgrain  1, ifreq, ipitch, igrsize, ips*istr, 1, 2, iolaps
asig = syncgrain:a(1, ifreq, ipitch, igrsize, ips*istr, 1, 2, iolaps)
        outs asig, asig
endin

</CsInstruments>
<CsScore>

;f1  0  0  1  "../samples/sa_beat1.aif"  0  0  0
#f1  0  0  1  "../samples/prayer_bell.aif"  0  0  0
f1  0  0  1  "../samples/female.aiff"  0  0  0
f2  0  8192  20  2  1

; instr srt dur amp  
i1      0   5   1   
i1      0   5   .05   
i1      +   5   4	
i1      +   10   .8	
i1      20   5   1.8	
e
</CsScore>
</CsoundSynthesizer>