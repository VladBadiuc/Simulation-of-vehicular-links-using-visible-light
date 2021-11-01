function rsalida=CambioCoordenadas(rentrada,theta)

a=cos(theta);
b=sin(theta);
re=[rentrada(1);rentrada(2)];
matriz=[a b; -b a];
rs=matriz*re;
rsalida=[rs(1) rs(2) rentrada(3)];
end