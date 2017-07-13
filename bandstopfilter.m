function [b, a] = bandstopfilter(Fs,N,Fc1,Fc2)

h  = fdesign.bandstop('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

[b, a] = tf(Hd);

