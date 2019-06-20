close all; clear all; clc;
initial_conditions;

%2 Геометрия с сеткой
Xlim = [ -0.01*(w+2*w+s) 1.01*(w+2*w+s) ];
Ylim = [ -0.1*(h1+h2+t) 1.1*(h1+h2+t) ];
fig1 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
pdegplot('geometry');
[ P, E, T ] = initmesh('geometry');
Q = pdetriq( P, T );
disp([ 'Минимальный показатель регулярности = [', num2str(min(Q)), ']'] );
pdemesh( P, E, T ); 

xlim( Xlim ); ylim( Ylim );
xlabel('мм'); ylabel('мм');
title('Геометрия с сеткой');

mkdir('task1');
saveas( fig1, fullfile( 'task1', 'initgeom.png' ) );

%3 Распеределение потенциалов
fig2 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
B = 0; F = 0;
A = ones( 1, length(T) );
zone30 = find( T(4,:) == 30 );
A(zone30) = eps1;
zone40 = find( T(4,:) == 40 ); 
A(zone40) = eps2;
zone20 = find( T(4,:) == 20 );

psi = assempde( 'bound', P, E, T, A, B, F );
pdesurf( P, T, psi )
%daspect([1 1 0.004])
%xlim( Xlim ); ylim( Ylim );
xlabel('мм'); ylabel('мм');
title('Распределение потенциалов');
zlabel('PSI'); 
grid on;
[ dpsi_dx, dpsi_dy ] = pdegrad( P, T, psi );

mkdir('task2');
saveas( fig2, fullfile( 'task2', 'psi.png' ) );

%4 Расчет составляющих электромагнитного поля ТЭМ-волн
Ex_tr = -dpsi_dx;
Ey_tr = -dpsi_dy;
Hx_tr = (sqrt(A)).*dpsi_dy./Z0;
Hy_tr = (-1).*((sqrt(A)).*dpsi_dx./Z0);

% Пересчет значений из центров триугольных элементов в узлы 
Ex_tr = pdeprtni( P, T, Ex_tr );
Ey_tr = pdeprtni( P, T, Ey_tr );
Hx_tr = pdeprtni( P, T, Hx_tr );
Hy_tr = pdeprtni( P, T, Hy_tr );
 
% Квадратная сетка
b1 = w+2*w+s;
b2 = h1+h2+t;
n = 100;
x = linspace(0,b1,n);
y = linspace(0,b2,n);
 
% Пересчет триугольной сетки в четыреугольную
Ex_qu = tri2grid( P, T, Ex_tr, x, y);
Ey_qu = tri2grid( P, T, Ey_tr, x, y);
Hx_qu = tri2grid( P, T, Hx_tr, x, y);
Hy_qu = tri2grid( P, T, Hy_tr, x, y);
 
% Построение силовых линий электрического поля
fig3 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
hplot1 = pdegplot('geometry');
set( hplot1, 'color', 'k', 'linestyle', '--');
streamslice( x, y, Ex_qu, Ey_qu, 3), axis equal, axis tight;
xlabel('мм'); ylabel('мм');
title('Силовые линии электрического поля E');

mkdir('task3');
saveas( fig3, fullfile( 'task3', 'elines.png' ) );

%5 Построение силовых линий магнитного поля
fig4 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
hplot2 = pdegplot('geometry');
set( hplot2, 'color', 'k', 'linestyle', '--' );
streamslice( x, y, Hx_qu, Hy_qu, 3), axis equal, axis tight;
xlabel('мм'); ylabel('мм');
title('Силовые линии магнитного поля H')
saveas( fig4, fullfile( 'task3', 'hlines.png' ) );
 
% Расчет эффективной диэлектрической проницаемости
[ AR, A1, A2, A3 ] = pdetrg( P, T );
psi1 = assempde( 'bound', P, E, T, 1, B, F );
[ dpsi_dx1, dpsi_dy1 ] = pdegrad( P, T, psi1 );
D = sum( ( dpsi_dx1.*dpsi_dx1 + dpsi_dy1.*dpsi_dy1 ).*AR );
psi = assempde( 'bound', P, E, T, A, B, F );
[ dpsi_dx, dpsi_dy ] = pdegrad( P, T, psi);
N = sum( A.*( dpsi_dx.*dpsi_dx + dpsi_dy.*dpsi_dy ).*AR );
 
% Діелектрична проникність
Eef = N/D;
disp(['Эфективная диэлектрическая проницаемость = [', num2str(Eef),']']);
% Расчет характер. уравнения
D_z = sum( (sqrt(A)).*( dpsi_dx.*dpsi_dx + dpsi_dy.*dpsi_dy ).*AR );
Z = Z0*(phi1-phi2)*(phi1-phi2)/D_z;
disp(['Характеристическое сопротивление = [', num2str(Z), ']']);


%6 Графики напряженности электрического и магнитного полей в ортогональных направлениях

mkdir('task4');
% Электрическое поле
fig5 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
surf( x, y, sqrt( Ex_qu.*Ex_qu + Ey_qu.*Ey_qu ) )
daspect([1 0.5 2]); colormap hsv; 
xlabel( 'x, мм' ); ylabel( 'y, мм' ); zlabel( 'E, В/м' ); 
title( 'Напряженность электрического поля вдоль X, Y' );
saveas( fig5, fullfile( 'task4', 'esurf.png' ) );
 
% Магнитное поле
fig6 = figure('Units', 'normalized', 'OuterPosition', [0.1 0.1 0.8 0.9] );
surf( x, y, sqrt( Hx_qu.*Hx_qu + Hy_qu.*Hy_qu ) );
daspect([1 0.5 0.005]); colormap hsv; 
xlabel( 'x, мм' ); ylabel( 'y, мм' ); zlabel( 'H, А/м' ); 
title(strcat('Напряженность магнитного поля вдоль X, Y'));
saveas( fig6, fullfile( 'task4', 'hsurf.png' ) );

%7 Параметрические зависимости

%%
%Залежність від S
s11(1)=s1(1)-s
s11(2)=s1(2)-s
j1=s11(1)*K;
j2=s11(2)*K;  
h=0;
for j=j1:1:j2
save -ascii j.txt j
figure(14)
pdegplot('geometry_s'), axis equal;
[p,e,t]=initmesh('geometry_s');
[p,e,t]=refinemesh('geometry_s',p,e,t);
pdemesh(p,e,t); 
axis equal
% Еф. діелектрична проникність(33)
[AR,A1,A2,A3]=pdetrg(p,t);
b=0;f=0;
psi1=assempde('bound',p,e,t,1,b,f);
[dpsi_dx1,dpsi_dy1]=pdegrad(p,t,psi1);
D=sum((dpsi_dx1.*dpsi_dx1+dpsi_dy1.*dpsi_dy1).*AR);
a=ones(1,length(t));
zone20=find(t(4,:)==20);
a(zone20)=E20;
zone40=find(t(4,:)==40); 
a(zone40)=E40;
psi=assempde('bound',p,e,t,a,b,f);
[dpsi_dx,dpsi_dy]=pdegrad(p,t,psi);
N = sum(a.*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Eef(h+1) = N/D;
% Характеристичний опір  (27)
D_z = sum( (sqrt(a)).*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Z(h+1) = 120*pi*(phi1-phi2)*(phi1-phi2)/D_z;
h=h+1;
end
 
s111=(s1(1)*K:s1(2)*K)/K;
figure(11)
plot(s111,Eef)
title('Залежність ефективної діелектричної проникності від  s');
xlabel('s ,мм');
ylabel('Ееф.');
xlim([0 s1(2)])
 
figure(12)
plot(s111,Z)
title('Залежність характеристичного опору від s');
xlabel('s, мм');
ylabel('Z, Ом');
xlim([0 s1(2)])
