%task2signals.m
close all; clear all; clc;
load('task1.mat');

[s1, s2, s3, s4] = signalModulations( t, m, phi2, th, phi4 );
[gs1, gs2, gs3, gs4] = signalModulations( t, gauss_m, cos_phi2, th, cos_phi4 );

save('task2.mat');

[F123, G1, G2, G3, F4, G4] = signalSpectres( Fs, s1, s2, s3, s4 );
[F123, gG1, gG2, gG3, F4, gG4] = signalSpectres( Fs, gs1, gs2, gs3, gs4 );


%figures
mkdir('task2');

h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, s1 , '-k.' ); 
plotp( 't, сек', 's1(t)' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( t, s2, '-r.' ); 
plotp( 't, сек', 's2(t)' );
title( 'FSK' );
subplot( N1, N2, 3 );
plot( t, s3 , '-m.' ); 
plotp( 't, сек', 's3(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( th, s4, '-b.' ); 
plotp( 't, сек', 's4(t)' );
title( 'QPSK' );
saveas( h1, fullfile( 'task2', ['2_sigs','.png'] ) );

h2 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, gs1 , '-k.' ); 
plotp( 't, сек', 's1(t)' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( t, gs2, '-r.' ); 
plotp( 't, сек', 's2(t)' );
title( 'FSK' );
subplot( N1, N2, 3 );
plot( t, gs3 , '-m.' ); 
plotp( 't, сек', 's3(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( th, gs4, '-b.' ); 
plotp( 't, сек', 's4(t)' );
title( 'QPSK' );
saveas( h2, fullfile( 'task2', ['2_gsigs','.png'] ) );

h3 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( F123, G1 , '-k.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( F123, G2, '-r.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'FSK' );
subplot( N1, N2, 3 );
plot( F123, G3 , '-m.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( F4, G4, '-b.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'QPSK' );
saveas( h3, fullfile( 'task2', ['2_specs','.png'] ) );

h4 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.5 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( F123, gG1 , '-k.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( F123, gG2, '-r.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'FSK' );
subplot( N1, N2, 3 );
plot( F123, gG3 , '-m.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( F4, gG4, '-b.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'QPSK' );
saveas( h4, fullfile( 'task2', ['2_gspecs','.png'] ) );