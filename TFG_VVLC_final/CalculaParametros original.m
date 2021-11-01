%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULO DE GANANCIA DC Y RETARDOS DE PROPAGACIÓN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esta función calcula para una posción fija de TXs y RXs con unos
% parámetros determinddos, la matriz H0 (en principio 2x2) de la 
% ganancia DC de los enlaces y la matriz TAU (2x2) con los retardos
% de propagación que se usarán para obtener la h(t).

function [H0, TAU]=CalculaParametros(DatosTX,DatosRX)
% DatosTX es una Matriz Mx8. En cada fila contiene: coordenadas tx, vector
% de posición, orden lambertiano y potencia.
% DatosRX es una Matriz Nx8. En cada fila contiene: coordenadas rx, vector
% de posición, FOV y area fotosensible (ya incluye el concentrador NIMG)
% M - número de tx (inicialmente 2)
% N - número de rx (inicialmente 2)
c=3*10^8; % velocidad de la luz en el vacío [m/s]
tamano_tx=size(DatosTX);
M=tamano_tx(1);
tamano_rx=size(DatosRX);
N=tamano_rx(1);
% inicializo matrices
H0=zeros(N,M); TAU=zeros(N,M); 
for k=1:N                    % para los N=2 receptores
     for p=1:M               % para los M=2 transmisores
         rtx=DatosTX(p,1:3); % posición piloto
         ntx=DatosTX(p,4:6); % vector unitario piloto
         rrx=DatosRX(k,1:3); % posición detector
         nrx=DatosRX(k,4:6); % vector posición detector
         vrxtx=rrx-rtx;     % vector detector-piloto 
         dist=norm(vrxtx);  % ditancia detector-piloto
         nvrxtx=vrxtx/dist; % vector unitario dirección piloto-detector
         costheta1=ntx*nvrxtx.'; 
         theta1=acos(costheta1); % ángulo emisión
      
         vtxrx=rtx-rrx;     % vector piloto-receptor
         nvtxrx=vtxrx/dist; % vector unitario dirección piloto-detector
         cosphi1=nrx*nvtxrx.';
         phi1=acos(cosphi1); % ángulo de recepción
         phi1Grad=phi1*180/pi;
         if (phi1<=DatosRX(k,7)) % si angulo recepción <= FOV
            Rad=((DatosTX(p,7)+1)/(2*pi))*costheta1^DatosTX(p,7); 
            % patrón Lambertiano  
            H0p=DatosRX(k,8)*Rad*cosphi1/dist^2; % ganancia DC enlace
         else H0p=0;
         end
         tau=dist/c;   % retardo propagación enlace
         H0(k,p)=H0p;  % matriz salida ganancia DC.
         TAU(k,p)=tau; % matriz salida retardos.
     end
end

end