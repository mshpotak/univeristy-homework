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
[s3, m3, t3, phi3] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "2", w);

[s4, m4, t4, phi4] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "4", w);

[s5, m5, t5, phi5] = signalPhaseModulation( 1, byte_le, Fs, t_bit, "pi/4", w);


% k = 0.25*pi;
% for i = 1 : length(m4)
%     if m4(1,i) == 1
%         if m4(2,i) == 1
%             M4(i) = 0.25 * pi - k;
%         else
%             M4(i) = 0.75 * pi - k;
%         end
%     else
%         if m4(2,i) == 1
%             M4(i) = 1.75 * pi - k;
%         else
%             M4(i) = 1.25 * pi - k;
%         end
%     end
% end
% 
% ss4 = cos(w*t4 + M4);

save('task1.mat')