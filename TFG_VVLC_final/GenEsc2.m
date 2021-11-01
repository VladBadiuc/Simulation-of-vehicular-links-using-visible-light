function [DaTX,DaRX]=GenEsc2(d,R1,R2,par)

% OPCIÓN A) CURVA
cosbeta=(R1^2+R2^2-d^2)/(2*R1*R2);
beta=acos(cosbeta);
betaGrad=beta*180/pi;
alpha=acos((R2*sin(beta))/d); % ángulo alpha [rad]
alpha_grados=alpha*180/pi;
alphaGrad=alpha*180/pi;

% correción y postivo
%beta0=asin(d/R2);
beta0=acos(R1/R2);
d0=R1*cos(beta0);

% OPCIÓN B) RECTA
% alpha = 0;
% beta=0;

% DIMENSIONES VEHÍCULOS Y SEPARACIÓN DE LUCES
Lv= 4.6; % Longitud de los vehiculos [m]
DF=1.3; % Separación faros delanteros [m]
DB=1.1; % Separación pilotos traseros [m]
HF=0.5; % Altura de los faros delanteros [m]
HB=0.5; % Altura de los pilotos traseros [m]
H=0.5; % Altura del chasis del vehículo [m]

% GENERACIÓN DE COORDENADAS DE TX Y RX
% El origen de oordenadas en (x,y) se fija en el centro del primer coche 
r1=[0,0,H];                           % COCHE_1 LIDER
% La posción del segundo coche a una distancia d.
if beta<beta0 
   signo=1;
else
   signo=-1;
end
r2=[d*cos(alpha) signo*d*sin(alpha) H];    % COCHE_2 SEGUIDOR


%%%%%%%%%%%%%%
% Coche1 Lider
%%%%%%%%%%%%%%
% TX: pilotos traseros "TailLignt TL"
% Right
TLr0=[Lv/2 DB/2 0];  % posición relativa desde el origen
TLr1=r1+TLr0;        % posición desplazada
% Left
TLl0=[Lv/2 -DB/2 0]; % posición relativa desde el origen 
TLl1=r1+TLl0;        % coordenadas del piloto izquierdo [m]
nTL1=[1 0 0];        % vector unitario apuntamiento, coincide con eje x
% faros delanteros "HeadLiht HL" (no tienen uso)
% Right
HLr0=[-Lv/2 DB/2 0]; % posición relativa
HLr1=r1+HLr0;        % posición desplazada
% Left
HLl0=[-Lv/2 -DB/2 0];% posición relativa
HLl1=r1+HLl0;        % posición desplazada
nHL1=[-1 0 0];       % vector unitario apuntamiento coincide con eje -x
                     % es el mismo para los dos faros

%%%%%%%%%%%%%%%%%
% Coche2 Seguidor
%%%%%%%%%%%%%%%%%
% En primer lugar rotamos las coordenadas del coche lider beta
% En segundo lugar desplazamos a las coordenadas del coche seguidor
% RX: faros delanteros "HeadLignt HL"
% Right
HLr1rotado=CambioCoordenadas(HLr1,beta); % rotación
HLr2=r2+HLr1rotado;                      % desplazamiento
% Left
HLl1rotado=CambioCoordenadas(HLl1,beta); % rotación
HLl2=r2+HLl1rotado;                      % desplazamiento
nHL2=[-cos(beta) sin(beta) 0];           % vector unitario
% tiene dirección eje -x prima (girado 2 alpha)
% Pilotos traseros "TailLight TL" (no tienen uso)
% Right
TLr1rotado=CambioCoordenadas(TLr1,beta);
TLr2=r2+TLr1rotado;
% Left
TLl1rotado=CambioCoordenadas(TLl1,beta);
TLl2=r2+TLl1rotado;  % coordenadas del piloto izquierdo [m]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de matrices de datos de TX y RX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx de coche lider a coche seguidor
DaTX=[TLr1 nTL1 par(1) par(2); TLl1 nTL1 par(1) par(2)];
DaRX=[HLr2 nHL2 par(3) par(4); HLl2 nHL2 par(3) par(4)];