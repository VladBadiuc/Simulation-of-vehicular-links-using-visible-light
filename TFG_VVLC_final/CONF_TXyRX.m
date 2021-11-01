%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURACIÓN EMISORES Y DETECTORES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se modifican las matrices de datos DTX y DRX, incluyendo las 
% característas de faros y detectores

% TX: FAROS DELANTEROS
% TX: PILOTOS TRASEROS
P=1;                       % potencia [W]
HPSA= 20*pi/180;           % Semiángulo de potencia mitad [rad].
m=-log(2)/log(cos(HPSA));  % orden Lambertiano

% RX: DETECTORES
Ad=5*10^-5;                % Area de detección [m^2] (sin concentrador)
FOV=55*pi/180;             % Campo visión [rad] (semiángulo).

% concetrador NIMG
no=1.5;                    % índice de refracción concentrador
g = no^2/sin(FOV)^2;         % ganancia del concetrador
g=1;
A=Ad*g;                    % área equivalente [m^2]

% modifico matrices globales
% DTX(1,7)=m;
% DTX(2,7)=m;
% DTX(1,8)=P;
% DTX(2,8)=P;
% DRX(1,7)=FOV;
% DRX(2,7)=FOV;
% DRX(1,8)=A;
% DRX(2,8)=A;