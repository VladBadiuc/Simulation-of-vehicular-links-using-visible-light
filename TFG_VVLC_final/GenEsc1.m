function [DaTX,DaRX]=GenEsc1(d,R,par)

% OPCIÓN A) CURVA
alpha=asin(d/(2*R)); % ángulo que define la curva para una distancia [rad]
alpha_grados=alpha*180/pi;

% OPCIÓN B) RECTA
% alpha = 0;

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
r2=[d*cos(alpha) -d*sin(alpha) H];    % COCHE_2 SEGUIDOR

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
% En primer lugar rotamos las coordenadas del coche lider 2 alpha
% En segundo lugar desplazamos a las coordenadas del coche seguidor
% RX: faros delanteros "HeadLignt HL"
% Right
HLr1rotado=CambioCoordenadas(HLr1,2*alpha); % rotación
HLr2=r2+HLr1rotado;                         % desplazamiento
% Left
HLl1rotado=CambioCoordenadas(HLl1,2*alpha); % rotación
HLl2=r2+HLl1rotado;                         % desplazamiento
nHL2=[-cos(2*alpha) sin(2*alpha) 0];        % vector unitario
% tiene dirección eje -x prima (girado 2 alpha)
% Pilotos traseros "TailLight TL" (no tienen uso)
% Right
TLr1rotado=CambioCoordenadas(TLr1,2*alpha);
TLr2=r2+TLr1rotado;
% Left
TLl1rotado=CambioCoordenadas(TLl1,2*alpha);
TLl2=r2+TLl1rotado;  % coordenadas del piloto izquierdo [m]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de matrices de datos de TX y RX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DaTX=[TLr1 nTL1 par(1) par(2); TLl1 nTL1 par(1) par(2)];
DaRX=[HLr2 nHL2 par(3) par(4); HLl2 nHL2 par(3) par(4)];