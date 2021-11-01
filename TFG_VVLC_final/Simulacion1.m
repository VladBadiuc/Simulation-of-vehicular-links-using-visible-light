%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Simulación 1
%
% Sobre el escenario 1, con curva, modifico la distancia de separación
% Obtengo

clear;
CONF_TXyRX;
n_Filas_Tx = 1;         %%% Añadir opción modificación más cómoda luego !!!
n_Col_Tx = 1;
ParamTxRx=[m,P,FOV,A,n_Filas_Tx,n_Col_Tx];
% Conf_coche;
R=50; % radio de curva [m]
dmin=6;   % distancia mínima
dmax=50;  % distancia máxima
dd=0.1;   % separación entre posiciones
          
pesosEGC=[0.5 0.5]; % pesos EGC

Hright=[];Hleft=[];Hegc=[];Hmrc=[];Hsb=[];
IN2=[];IN2egc=[];IN2mrc=[];IN2sb=[];
for d=dmin:dd:dmax
    [DTX,DRX]=GeneraEscenario1(d,R,ParamTxRx);      %%%% N_FILAS Y N_COLUMNAS
    [Hdc,tp]=CalculaParametros(DTX,DRX);
    % meto provisionalmente aquí el ruido
    % ruido ambiental
     B=5*10^6;       % ancho de banda
     qe=1.6*10^-19;  % carga del electron
     Ibg1=740*10^-6;   % Sol indirecto esto debería ser variable
     Ibg2=5100*10^-6;   % Sol directo esto debería ser variable
     Ibg= Ibg1*(0.5/0.8);%la corrijo por diferentes areas 0.5/0.8    
     I2=0.562;
     nshot=2*qe*Ibg*I2*B; % ruido shot
     nint=0;              % ruido interno
     in=nshot+nint;       % ruido total
     IN2=[IN2 in];
    %%%%%
    int=sum(Hdc);
    %%fprintf("   %6.2f %6.2f   \r\n",Hdc);
    %%fprintf("   %6.2f %6.2f   \r\n",int);
%%%%%%%%%%%%%%
    %Hright=[Hright int(1)];
    %Hleft=[Hleft int(2)];
    pesosMRC=[int(1)/in int(2)/in]; % pesos wj combinación MRC
    [peso,posi]=max(pesosMRC);
    pesosSB=[0 0];       
    pesosSB(posi)=1;             % pesos wj combinación SB
    pesosMRC=pesosMRC/sum(pesosMRC);
    Hegc=[Hegc sum(Hdc.*pesosEGC.')];
    Hmrc=[Hmrc sum(Hdc.*pesosMRC.')];    
    Hsb=[Hsb sum(Hdc.*pesosSB.')];
    IN2egc=[IN2egc in*sum(pesosEGC.^2)];
    IN2mrc=[IN2mrc in*sum(pesosMRC.^2)];
    IN2sb=[IN2sb in*sum(pesosSB.^2)];  
%%%%%%%%%%%%%%%%
end

    disp(Hdc);
%xd=xd-4.6;

% SNR
respons=0.5;

SNRegc=((DTX(1,8)*respons*Hegc).^2)./IN2egc(1,1);
SNR_EGCdB=10*log10(SNRegc);
SNRmrc=((respons*Hmrc*DTX(1,8)).^2)./IN2mrc(1,1);
SNR_MRCdB=10*log10(SNRmrc);
SNRsb=((respons*Hsb*DTX(1,8)).^2)./IN2sb(1,1);
SNR_SBdB=10*log10(SNRsb);

%longMatrix = size(SNRegc);
xd=[dmin:(dmax-dmin)/size(SNRegc,2):dmax-1/size(SNRegc,2)];

figure;
%plot(xd,SNR_EGCdB,'b'); hold on;
%plot(xd,SNR_MRCdB,'k');
plot(xd,SNR_SBdB,'r');
plot(xd,SNR_MRCdB,'k');
xlabel('Distancia entre vehículos [m]');
ylabel('Relación señal-ruido eléctrica [dB]');
legend({'EGC','SB','MRC'});
grid;

figure;
plot(xd,10*log10(Hegc),'b');
hold on;grid;
plot(xd,10*log10(Hsb),'r');
plot(xd,10*log10(Hmrc),'k');
xlabel('Distancia entre vehículos [m]');
ylabel('Ganancia en continua del canal [dB]');
legend({'EGC','SB','MRC'});
