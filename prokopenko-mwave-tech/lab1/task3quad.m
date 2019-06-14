%task3quad.m
close all; clear all; clc;
load('task2.mat');

%Signals without Gauss
[ i1, i2, i3, i4, q1, q2, q3, q4] = signalComplex( t, s1, s2, s3, th, s4 );
[ ~, G1, G2, G3, ~, G4] = signalSpectres( Fs, i1 + 1i*q1, i2 + 1i*q2, i3 + 1i*q3, i4 + 1i*q4);

n = 20;
Wn = 0.07;
[ fi1, fi2, fi3, fi4, fq1, fq2, fq3 ,fq4] = signalFilter( n, Wn, i1, i2, i3, i4, q1, q2, q3 ,q4 );
[ ~, fG1, fG2, fG3, ~, fG4] = signalSpectres( Fs, fi1 + 1i*fq1, fi2 + 1i*fq2, fi3 + 1i*fq3, fi4 + 1i*fq4);

%Signals with Gauss
[ gi1, gi2, gi3, gi4, gq1, gq2, gq3, gq4] = signalComplex( t, gs1, gs2, gs3, th, gs4 );
[ ~, gG1, gG2, gG3, ~, gG4] = signalSpectres( Fs, gi1 + 1i*gq1, gi2 + 1i*gq2, gi3 + 1i*gq3, gi4 + 1i*gq4);

n = 20;
Wn = 0.07;
[ gfi1, gfi2, gfi3, gfi4, gfq1, gfq2, gfq3 ,gfq4] = signalFilter( n, Wn, gi1, gi2, gi3, gi4, gq1, gq2, gq3 ,gq4 );
[ ~, gfG1, gfG2, gfG3, ~, gfG4] = signalSpectres( Fs, gfi1 + 1i*gfq1, gfi2 + 1i*gfq2, gfi3 + 1i*gfq3, gfi4 + 1i*gfq4);
L = length(i1);
F123 = Fs*( -L/2 : 1 : (L/2 - 1) )/L;
L = length(i4);
F4 = Fs*( -L/2 : 1 : (L/2 - 1) )/L;

mkdir('task3');

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
plot( t, s3 , '-k.' ); 
plotp( 't, сек', 's3(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( th, s4, '-b.' ); 
plotp( 't, сек', 's4(t)' );
title( 'QPSK' );
saveas( h1, fullfile( 'task3', ['2_sigs','.png'] ) );

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
plot( t, gs3 , '-k.' ); 
plotp( 't, сек', 's3(t)' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( th, gs4, '-b.' ); 
plotp( 't, сек', 's4(t)' );
title( 'QPSK' );
saveas( h2, fullfile( 'task3', ['2_gsigs','.png'] ) );

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
plot( F123, G3 , '-k.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( F4, G4, '-b.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'QPSK' );
saveas( h3, fullfile( 'task3', ['2_specs','.png'] ) );

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
plot( F123, gG3 , '-k.' ); 
plotp( 'f, Гц', 'Амплитуда' ); 
title( 'BPSK' );
subplot( N1, N2, 4 );
plot( F4, gG4, '-b.' ); 
plotp( 'f, Гц', 'Амплитуда' );
title( 'QPSK' );
saveas( h4, fullfile( 'task3', ['2_gspecs','.png'] ) );