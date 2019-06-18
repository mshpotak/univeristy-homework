%task4demod.m
close all; clear all; clc;
load('task3.mat');

dA = signalAmpDemod( fi1, fq1 );
gdA = signalAmpDemod( gfi1, gfq1 );

dw = signalFreqDemod( fi2, fq2, Fs );
gdw = signalFreqDemod( gfi2, gfq2, Fs );

dphi2 = signalBpskDemod( fi3, fq3 );
gdphi2 = signalBpskDemod( gfi3, gfq3 );

dphi4 = signalQpskDemod( fi4, fq4 );
gdphi4 = signalQpskDemod( gfi4, gfq4 );
save('task4.mat');

%figures
mkdir('task4');

h1 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.55 0.8] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, dA , '-k.' ); 
plotp( 't, сек', 'A(t), В' ); 
title( 'A(t)' );
subplot( N1, N2, 2 );
plot( t, gdA, '-r.' ); 
plotp( 't, сек', 'A(t), В' ); 
title( 'A(t) - Гауссова фильтрация' );
subplot( N1, N2, 3 );
plot( t(1:end-1), dw , '-k.' ); 
plotp( 't, сек', 'dw(t), рад/с' );
title( 'dw(t)' );
subplot( N1, N2, 4 );
plot( t(1:end-1), gdw , '-r.' ); 
plotp( 't, сек', 'dw(t), рад/с' );
title( 'dw(t) - Гауссова фильтрация' );
saveas( h1, fullfile( 'task4', ['4_afsk.png'] ) );

h2 = figure('Units', 'normalized', 'OuterPosition', [0.2 0.2 0.55 0.8] );
N1 = 2; N2 = 2;
subplot( N1, N2, 1 );
plot( t, dphi2 * 180/pi, '-k.' ); 
plotp( 't, сек', 'phi2(t), градусы' ); 
title( 'phi2(t)' );
subplot( N1, N2, 2 );
plot( t, gdphi2 * 180/pi, '-r.' ); 
plotp( 't, сек', 'phi2(t), градусы' );
title( 'phi2(t) - Фильтрация "Приподнятым косинусом"' );
subplot( N1, N2, 3 );
plot( th, dphi4 * 180/pi , '-k.' ); 
plotp( 't, сек', 'phi4(t), градусы' ); 
title( 'phi4(t)' );
subplot( N1, N2, 4 );
plot( th, gdphi4 * 180/pi , '-r.' ); 
plotp( 't, сек', 'phi4(t), градусы' ); 
title( 'phi4(t) - Фильтрация "Приподнятым косинусом"' );
saveas( h2, fullfile( 'task4', ['4_bqpsk.png'] ) );