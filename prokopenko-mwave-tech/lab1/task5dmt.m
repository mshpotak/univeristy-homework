close all; clear all; clc
%task5dmt.m
load('task4.mat');

[ m1, m2, m3, m4 ] = signalDemodulation( s_bit, dA, dw, dphi2, dphi4 );
[ gm1, gm2, gm3, gm4 ] = signalDemodulation( s_bit, gdA, gdw, gdphi2, gdphi4 );

%figures
mkdir('task5');

h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.6 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, m1 , '-k.' , t, m, '-r'); 
plotp( 't, сек', 'm(t)' ); 
title( 'ASK' );
subplot( N1, N2, 2 );
plot( t, m2, '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' ); 
title( 'FSK' );
subplot( N1, N2, 3 );
plot( t, m3 , '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' );
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( t, m4 , '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' );
title( 'QPSK' );
saveas( h1, fullfile( 'task5', ['5_afsk.png'] ) );

h2 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.6 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, gm1, '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' ); 
title( 'ASK - Гауссова фильтрация' );
subplot( N1, N2, 2 );
plot( t, gm2, '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' );
title( 'FSK - Гауссова фильтрация"' );
subplot( N1, N2, 3 );
plot( t, gm3 , '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' ); 
title( 'BPSK - Фильтрация "Приподнятым косинусом"' );
subplot( N1, N2, 4 );
plot( t, gm4 , '-k.', t, m, '-r' ); 
plotp( 't, сек', 'm(t)' ); 
title( 'QPSK - Фильтрация "Приподнятым косинусом"' );
saveas( h2, fullfile( 'task5', ['5_bqpsk.png'] ) );
%% 

iphi2 = [ -1, 1 ]; 
qphi2 = [ 0, 0 ];
iphi4 = [ 1/sqrt(2), -1/sqrt(2), -1/sqrt(2), 1/sqrt(2) ];
qphi4 = [ 1/sqrt(2), 1/sqrt(2), -1/sqrt(2), -1/sqrt(2) ];
h3 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.6 0.7] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( fi3, fq3 , '-r+', iphi2, qphi2, 'ko'); 
plotp( 'i(t)', 'q(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 2 );
plot( fi4, fq4 , '-r+', iphi4, qphi4, 'ko' ); 
plotp( 'i(t)', 'q(t)' ); 
title( 'QPSK' );
subplot( N1, N2, 3 );
plot( gfi3, gfq3 , '-r+', iphi2, qphi2, 'ko'  ); 
plotp( 'i(t)', 'q(t)' ); 
title( 'BPSK - Фильтрация "Приподнятым косинусом"' );
subplot( N1, N2, 4 );
plot( gfi4, gfq4 , '-r+', iphi4, qphi4, 'ko'); 
plotp( 'i(t)', 'q(t)' ); 
title( 'QPSK - Фильтрация "Приподнятым косинусом"' );
saveas( h3, fullfile( 'task5', ['5_bqpskmap.png'] ) );
