function [DaTX,DaRX]=GeneraEscenario1(d,R,par,MatPot,parVehiculo1,parVehiculo2)

% OPCIÓN A) CURVA
alpha=asin(d/(2*R)); % ángulo que define la curva para una distancia [rad]
alpha_grados=alpha*180/pi;

% OPCIÓN B) RECTA
% alpha = 0;

% DIMENSIONES VEHÍCULOS Y SEPARACIÓN DE LUCES
Lvl = parVehiculo1(1); % Longitud de los vehiculos [m]
DFl = parVehiculo1(2); % Separación faros delanteros [m]
DBl = parVehiculo1(3); % Separación pilotos traseros [m]
HFl = parVehiculo1(4); % Altura de los faros delanteros [m]
HBl = parVehiculo1(5); % Altura de los pilotos traseros [m]
Hl = parVehiculo1(6); % Altura del chasis del vehículo [m]

Lvf = parVehiculo2(1); % Longitud de los vehiculos [m]
DFf = parVehiculo2(2); % Separación faros delanteros [m]
DBf = parVehiculo2(3); % Separación pilotos traseros [m]
HFf = parVehiculo2(4); % Altura de los faros delanteros [m]
HBf = parVehiculo2(5); % Altura de los pilotos traseros [m]
Hf = parVehiculo2(6); % Altura del chasis del vehículo [m]

% GENERACIÓN DE COORDENADAS DE TX Y RX
% El origen de oordenadas en (x,y) se fija en el centro del primer coche 
r1=[0,0,Hl];                           % COCHE_1 LIDER
% La posción del segundo coche a una distancia d.
r2=[d*cos(alpha) -d*sin(alpha) Hf];    % COCHE_2 SEGUIDOR
sV = par(7);
sH = par(8);
%%%%%%%%%%%%%%
% Coche1 Lider
%%%%%%%%%%%%%%
NumTx = par(5)*par(6);
% TX: pilotos traseros "TailLignt TL"
% Right
TLr1 = ones(NumTx,3);
TLl1 = ones(NumTx,3);
nTL1r = ones(NumTx,3);
nTL1l = ones(NumTx,3);
x = 1;
for i = 0 : par(5) - 1
    for y = 0 : par(6) - 1
TLr0=[Lvl/2 DBl/2+i*sH HBl+sV*y];  % posición relativa desde el origen
TLr1(x,:)=TLr0;        % posición desplazada
nTL1r(x,1:3)=[1 0 0];
% Left
TLl0=[Lvl/2 -(DBl/2+i*sH) HBl+sV*y]; % posición relativa desde el origen 
TLl1(x,:)=TLl0;        % coordenadas del piloto izquierdo [m]
nTL1l(x,1:3)=[1 0 0];        % vector unitario apuntamiento, coincide con eje x
x = x+1;
    end
end
% faros delanteros "HeadLiht HL" (no tienen uso)
% Right
HLr0=[-Lvl/2 DBl/2 0]; % posición relativa
HLr1=r1+HLr0;        % posición desplazada
% Left
HLl0=[-Lvl/2 -DBl/2 0];% posición relativa
HLl1=r1+HLl0;        % posición desplazada
nHL1=[-1 0 0];       % vector unitario apuntamiento coincide con eje -x
                     % es el mismo para los dos faros
   
%%%%%%%%%%%%%%%%%
% Coche2 Seguidor
%%%%%%%%%%%%%%%%%
% En primer lugar rotamos las coordenadas del coche lider 2 alpha
% En segundo lugar desplazamos a las coordenadas del coche seguidor
% RX: faros delanteros "HeadLight HL"

xHLr0=[-Lvf/2 DBf/2 0]; % posición relativa
xHLr1=r1+xHLr0;        % posición desplazada
xHLl0=[-Lvf/2 -DBf/2 0];% posición relativa
xHLl1=r1+xHLl0;
% Right
HLr1rotado=CambioCoordenadas(xHLr1,2*alpha); % rotación
HLr2=r2+HLr1rotado;                         % desplazamiento
% Left
HLl1rotado=CambioCoordenadas(xHLl1,2*alpha); % rotación
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
% PARAMETROS 1 y 2 de TX 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
par1 = zeros(NumTx,1);           %%Los pongo en forma de matriz para poder
par2 = zeros(NumTx,1);           %% hacer patrones regulables en potencia.
for i = 1 : NumTx
    par1(i,1) = par(1);     %% Parametro 1 --> m
    par2(i,1) = MatPot(i,1);     %% Parametro 2 --> P
    %fprintf("par2  %6.2f \r\n",MatPot(i,1));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de matrices de datos de TX y RX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DaTX=[TLr1 nTL1r par1 par2; TLl1 nTL1l par1 par2];
DaRX=[HLr2 nHL2 par(3) par(4); HLl2 nHL2 par(3) par(4)];
%disp(DaTX);
%disp(DaRX);

