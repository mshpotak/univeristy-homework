initial_conditions;
close all

s_bit = 32; %samples per bit

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

[s1, A] = signalAmpModulation(1, Ma, m, 0, w, t);
i1 = s1 .* cos( w * t );
q1 = s1 .* sin( w * t );

n = 20;
Wn = 0.07;
b1 = fir1( n, Wn );
fi1 = 2 * filter( b1, 1, i1);
fq1 = -2 * filter( b1, 1, q1);
% [G1, F1, Fn1] = customFourier(fi1 + 1i*fq1, Fs);
% plot(Fn1,fftshift(G1))
% hold on;
b2 = fir1( n, 0.5 );
fi2 = 2 * filtfilt( b1, 1, i1 );
fq2 = -2 * filtfilt( b1, 1, q1 );

% [G2, F2, Fn2] = customFourier(fi2 + 1i*fq2, Fs);
% plot(Fn2,fftshift(G2))

figure()
% plot( t, s1 )
% hold on
plot( t, i1, t, q1 )

figure();
% plot( t, fi1, t, fq1 )
% hold on;
plot( t, fi2, t, fq2 )
figure()
s2 = sqrt( fi1.^2 + fq1.^2 );
s3 = sqrt( fi2.^2 + fq2.^2 );
plot( t, s1, t, s2 )

save('task4.mat')