close all;
clear all;
clc;
% Вхідні дані, варіант 2
E20=10;
E40=4;
E50=1;
phi1=2;
phi2=0;
K=100;% масштаб 
w=3;% мм
h1=1;% мм
h2=1;% мм
s=0.5;% мм
E20_1=[1 100];% межі зміни параметра E20
w1=[0.05 3.95]% межі зміни w
s1=[0.01 2.39];% межі зміни параметра s
 
% 2. 
%Побудова геометрії і сітки
Xlim = [-10 900];
Ylim = [-10 310];
pdegplot('geometry');
axis equal;
[p,e,t]=initmesh('geometry');
q=pdetriq(p,t);
disp(strcat('Мінімальний показник регулярності = ',num2str(min(q))))
pdemesh(p,e,t); 
axis equal 
set(gca,'Xlim',Xlim); 
set(gca,'Ylim',Ylim);
xlabel('мм/100');
ylabel('мм/100');
title('Геометрія з сіткою');
 
%%3
%Знаходження розподілу потенціалів (34) 
figure(2)
b=0;f=0;
a=ones(1,length(t));
zone20=find(t(4,:)==20);
a(zone20)=E20;
zone40=find(t(4,:)==40); 
a(zone40)=E40;
zone50=find(t(4,:)==50);
psi=assempde('bound',p,e,t,a,b,f);
pdesurf(p,t,psi)
set(gca,'Xlim',Xlim);
set(gca,'Ylim',Ylim);
grid on;
daspect([1 1 0.004])
xlabel('мм/100');
ylabel('мм/100');
title('Розподіл потенціла');
zlabel('Psi'); 
[dpsi_dx,dpsi_dy]=pdegrad(p,t,psi);
 
 
%%4
%Розрахунок складових електромагнітного поля ТЕМ-хвиль
Ex_tr=-dpsi_dx;
Ey_tr=-dpsi_dy;
Hx_tr=(sqrt(a)).*dpsi_dy./(120*pi);
Hy_tr=(-1).*((sqrt(a)).*dpsi_dx./(120*pi));
 
% Перерахунок значень із центрів в узли трикутних елементів 
Ex_tr=pdeprtni(p,t,Ex_tr);
Ey_tr=pdeprtni(p,t,Ey_tr);
Hx_tr=pdeprtni(p,t,Hx_tr);
Hy_tr=pdeprtni(p,t,Hy_tr);
 
% Квадратна сітка
b1=850;
b2=310%
n=118;
x = linspace(0,b1,n);
y = linspace(0,b2,n);
 
% Перерахунок 3-х кутної сітки в 4-х
Ex_qu=tri2grid(p,t,Ex_tr,x,y);
Ey_qu=tri2grid(p,t,Ey_tr,x,y);
Hx_qu=tri2grid(p,t,Hx_tr,x,y);
Hy_qu=tri2grid(p,t,Hy_tr,x,y);
 
% Побудова силових ліній електрочного поля
figure(3);
h=pdegplot('geometry');
set(h,'color','k','linestyle','--');
streamslice(x,y,Ex_qu,Ey_qu,3), axis equal,axis tight;
xlabel('мм/100');
ylabel('мм/100');
title('Силові лінії електричного поля E ')
 
%%5
% Побудова  силових ліній магнітного поля
figure(4);
h=pdegplot('geometry');
set(h,'color','k','linestyle','--')
streamslice(x,y,Hx_qu,Hy_qu,3), axis equal,axis tight;
xlabel('мм/100');
ylabel('мм/100');
title('Силові лінії магнітного поля H ')
 
% Рохрахунок еф. діелектричної проникності (33)
[AR,A1,A2,A3]=pdetrg(p,t);
psi1=assempde('bound',p,e,t,1,b,f);
[dpsi_dx1,dpsi_dy1]=pdegrad(p,t,psi1);
D=sum((dpsi_dx1.*dpsi_dx1+dpsi_dy1.*dpsi_dy1).*AR);
psi=assempde('bound',p,e,t,a,b,f);
[dpsi_dx,dpsi_dy]=pdegrad(p,t,psi);
N = sum(a.*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
 
% Діелектрична проникність
Eef = N/D;
disp(strcat('Ефективна діелектрична проникність = ',num2str(Eef)))
% Рохрахунок характеристичного рівняння (27)
D_z = sum( (sqrt(a)).*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Z = 120*pi*(phi1-phi2)*(phi1-phi2)/D_z;
disp(strcat('Характеристичний опір = ',num2str(Z)))
 
% 6
% Графіки напруженості електричного та магнітного полів в двух
% ортогональних напрямах
%Електричне поле
figure(5) 
surf(x/K,y/K,sqrt(Ex_qu.*Ex_qu + Ey_qu.*Ey_qu) )
set(gca,'Ylim',Ylim/K);
set(gca,'Xlim',Xlim/K);
daspect([1 1 0.01])
colormap hsv; 
xlabel('x,мм');
ylabel('y,мм');
zlabel('E'); 
title(strcat('Напруженості електричного поля вздовж  X Y '))
 
%Магнітне поле
figure(6)
surf(x/K,y/K,sqrt(Hx_qu.*Hx_qu + Hy_qu.*Hy_qu) );
axis tight 
set(gca,'Ylim',Ylim/K);set(gca,'Xlim',Xlim/K);
daspect([1 1 0.00006])
colormap hsv; 
xlabel('x,мм');
ylabel('y,мм');
zlabel('H, А/м'); 
title(strcat('Напруженості магнітного поля  вздовж X Y '))
 
 
%7
% Залежність від E
b=0;f=0;
psi1=assempde('bound',p,e,t,1,b,f);
[dpsi_dx1,dpsi_dy1]=pdegrad(p,t,psi1);
D=sum((dpsi_dx1.*dpsi_dx1+dpsi_dy1.*dpsi_dy1).*AR);
g=0;
 
for i=E20_1(1):E20_1(2)
zone20=find(t(4,:)==20);
a(zone20)=i;
zone40=find(t(4,:)==40);
a(zone40)=E40;
psi=assempde('bound',p,e,t,a,b,f);
[dpsi_dx,dpsi_dy]=pdegrad(p,t,psi);
N = sum(a.*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);    
Eef(g+1) = N/D;
% Характеристичний опір(27)
D_z = sum( (sqrt(a)).*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Z(g+1) = 120*pi*(phi1-phi2)*(phi1-phi2)/D_z;
g=g+1;
end
E1=E20_1(1):E20_1(2);
% Графік залежності еф. проникності від електрофізичних параметрів області лінії передачі 
figure(7)
plot(E1,Eef)
title('Залежність ефективної діелектричної проникності від E ');
xlabel('E');
ylabel('Eеф.');
figure(8)
plot(E1,Z)
title('Залежність характеристичного опору від E');
xlabel('E');
ylabel('Z, Ом');
 
%Залежність від W
w11(1)=w1(1)-w
w11(2)=w1(2)-w
i1=w11(1)*K;
i2=w11(2)*K;  
l=0;
for i=i1:1:i2
save -ascii i.txt i
figure(13)
pdegplot('geomenry_w'), axis equal;
[p,e,t]=initmesh('geomenry_w');
[p,e,t]=refinemesh('geomenry_w',p,e,t);
pdemesh(p,e,t); 
axis equal
% Еф. діелектрична проникність(33)
[AR,A1,A2,A3]=pdetrg(p,t);
b=0;f=0;
psi1=assempde('bound',p,e,t,1,b,f);
[dpsi_dx1,dpsi_dy1]=pdegrad(p,t,psi1);
D=sum((dpsi_dx1.*dpsi_dx1+dpsi_dy1.*dpsi_dy1).*AR);
a=ones(1,length(t));b=0;f=0;
zone20=find(t(4,:)==20);
a(zone20)=E20;
zone40=find(t(4,:)==40); 
a(zone40)=E40;
psi=assempde('bound',p,e,t,a,b,f);
[dpsi_dx,dpsi_dy]=pdegrad(p,t,psi);
N = sum(a.*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Eef(l+1) = N/D;
% Характеристичний опір  (27)
D_z = sum( (sqrt(a)).*(dpsi_dx.*dpsi_dx+dpsi_dy.*dpsi_dy).*AR);
Z(l+1) = 120*pi*(phi1-phi2)*(phi1-phi2)/D_z;
l=l+1;
end
 
 w111=(w1(1)*K:w1(2)*K)/K;
figure(9)
plot(w111,Eef)
title('Залежність ефективної діелектричної проникності від ширини w');
xlabel('w, мм');
ylabel('Ееф.');
xlim([0 w1(2)]);
 
figure(10)
plot(w111,Z)
title('Залежність характеристичного опору від ширини w');
xlabel('w, мм');
ylabel('Z, Ом ');
xlim([0 w1(2)]);
 
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
