initial_conditions;

%discrete time
T = t_bit * n_bit;
sig_len = Fs * T; 
t = 0 : 1/Fs : T - 1/Fs;

%normalized modulation
m = zeros( size(t) );
pulse_rate = t_bit * Fs;
for i = 1 : n_bit
    if byte_le(i) == 0
        m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = -1;
    else
        m( (1 + ((i-1)*pulse_rate)) : (i*pulse_rate) ) = 1;
    end
end

%amplitude modulation
s1 = signalAmpModulation(1, Ma, m, 0, w, t);

%frequency modulation
wm = 2 * pi / t_bit;
s2 = signalFreqModulation(1, Mf, m, 0, w, wm, t);

%phase modulation

[s3, phi3] = signalPhaseModulation(1, m, 2, w, t);

[s4, phi4] = signalPhaseModulation(1, m, 4, w, t);
[s5, phi5 , m5] = signalPhaseModulation(1, m, 42, w, t);