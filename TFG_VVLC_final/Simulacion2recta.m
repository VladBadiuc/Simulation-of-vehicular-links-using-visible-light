%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Simulación 2 recta
%
% Sobre el escenario 2, en recta, modifico la distancia de separación
% Obtengo

clear;
CONF_TXyRX;
ParamTxRx=[m,P,FOV,A];
% Conf_coche;
AnchoCarril= 3.5; % anchura de carril [m]
dmin=6;   % distancia mínima
dmax=50;  % distancia máxima
dd=0.1;   % separación entre posiciones
          
pesosEGC=[0.5 0.5]; % pesos EGC

Hright=[];Hleft=[];Hegc=[];Hmrc=[];Hsb=[];
IN2=[];IN2egc=[];IN2mrc=[];IN2sb=[];
for d=dmin:dd:dmax
    [DTX,DRX]=GeneraEscenario2recta(d,AnchoCarril,ParamTxRx);
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
    Hright=[Hright int(1)];
    Hleft=[Hleft int(2)];
    pesosMRC=[int(1)/in int(2)/in]; % pesos wj combinación MRC
    [peso,posi]=max(pesosMRC);
    pesosSB=[0 0];       
    pesosSB(posi)=1;             % pesos wj combinación SB
    pesosMRC=pesosMRC/sum(pesosMRC);    
    Hegc=[Hegc sum(Hdc*pesosEGC.')];
    Hmrc=[Hmrc sum(Hdc*pesosMRC.')];    
    Hsb=[Hsb sum(Hdc*pesosSB.')];
     IN2egc=[IN2egc in*sum(pesosEGC.^2)];
    IN2mrc=[IN2mrc in*sum(pesosMRC.^2)];
    IN2sb=[IN2sb in*sum(pesosSB.^2)];  
end
xd=[dmin:dd:dmax];
%xd=xd-;

% SNR
respons=0.5;

SNRegc=((respons*Hegc*DTX(1,8)).^2)./IN2egc;
SNR_EGCdB=10*log10(SNRegc);
SNRmrc=((respons*Hmrc*DTX(1,8)).^2)./IN2mrc;
SNR_MRCdB=10*log10(SNRmrc);
SNRsb=((respons*Hsb*DTX(1,8)).^2)./IN2sb;
SNR_SBdB=10*log10(SNRsb);

figure;
%plot(xd,SNR_EGCdB,'b'); hold on;
%%plot(xd,SNR_MRCdB,'k');
%plot(xd,SNR_SBdB,'r');
plot(xd,SNR_MRCdB,'k');
HSPA=acos(exp(-log(2)/DTX(1,7)))*180/pi;
title(['RECTA DOBLE CARRIL D=', num2str(AnchoCarril), 'm: (FOV=', num2str(DRX(1,7)*180/pi), '^o, HPSA=' num2str(HSPA),'^o, P_{piloto}=' num2str(DTX(1,8)), 'W, A=', num2str(DRX(1,8)),'m^2)'])
xlabel('Distancia entre vehículos [m]');
ylabel('Relación señal-ruido eléctrica [dB]');
legend({'EGC','SB','MRC'});
axis([0 50 0 50]);
grid;

figure;
plot(xd,10*log10(Hegc),'b');
hold on;grid;
plot(xd,10*log10(Hsb),'r');
plot(xd,10*log10(Hmrc),'k');
title(['RECTA DOBLE CARRIL D=', num2str(AnchoCarril), 'm: (FOV=', num2str(DRX(1,7)*180/pi), '^o, HPSA=' num2str(HSPA),'^o, A=', num2str(DRX(1,8)),'m^2)'])
xlabel('Distancia entre vehículos [m]');
ylabel('Ganancia en continua del canal [dB]');
legend({'EGC','SB','MRC'});
axis([0 50 -80 -50]);

