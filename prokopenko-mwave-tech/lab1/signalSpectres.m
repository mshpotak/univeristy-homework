function [F123, G1, G2, G3, F4, G4] = signalSpectres( Fs, s1, s2, s3, s4 )
   L = length(s1);
   G1 = abs( fft(s1) / L );
   G2 = abs( fft(s2) / L );
   G3 = abs( fft(s3) / L );
   F123 = Fs*( 0:L - 1 ) / L;
   
   L = length(s4);
   G4 = abs( fft(s4) / L );
   F4 = Fs * ( 0:L - 1 ) / L;
end