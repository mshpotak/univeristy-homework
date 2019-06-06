initial_conditions;

f = 10e6;
w = 2 * pi * f;
t_bit = 6e-6;
s_bit = 16; %samples per bit
Fs = s_bit/t_bit;
T = t_bit * n_bit;
t = 0 : 1/Fs : T - 1/Fs;

m = zeros( size(t) );
pulse_rate = t_bit * Fs;

for i = 1 : n_bit
    if byte_le(i) == 0
        m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = -1;
    else
        m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = 1;
    end
end

s1 = signalAmpModulation(1, Ma, m, 0, w, t);
%plot( t, s1, '-ro' )

figure()
L = length(s1);
F = Fs*(0:L-1)/L;
g = fft(s1);
G = abs(g/L);
plot(F,G);
xlabel('Frequency, Hz');
ylabel('Amplitude');