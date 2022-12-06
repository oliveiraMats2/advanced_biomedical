function fr = backproj(projecao,angulos)
% fr = backproj(projecao,angulos)
% BACKPROJ -> realiza a reconstrucao da imagem obtida por tomografo
%             computadorizado (CT) atraves do metodo de retroprojecao
%             filtrada
% projecao:   matriz mXn com projecoes de "m" pontos para cada angulo "n"
% angulos:    vetor contendo os angulos em que as projecoes foram feitas
%             "n" usualmente varia de 1 a 180 graus com passos de 1 grau

theta=pi*(angulos)/180;
%N = 2*floor( size(projecao,1)/(2*sqrt(2)) ); % calculo do tamanho original da imagem
N = fix(size(projecao,1)/sqrt(2)); % calculo do tamanho original da imagem
len=size(projecao,1);   

% ------------------------------------------------------------------------
% No processo de retroprojecao filtrada, como tanto os detetores quanto
% o feixe de raios X tem dimensoes finitas, ha a necessidade de se filtrar
% as projecoes obtidas de forma a respeitar o teorema de Nyquist
% Pelo teorema da convolucao, a filtragem eh feita no dominio da frequencia
% ------------------------------------------------------------------------

% de forma a otimizar a implementacao da FFT, os dados sao expandidos
% com zeros ate a proxima potencia de 2
n=nextpow2(len);                      % proxima potencia de 2
H=[1:1:2^(n-1) 2^(n-1):-1:1];         % filtro a ser utilizado
H=H'/max(H);							     % filtro normalizado
projecao(length(H),1)=0;              % expansao (com zeros) da projecao
PROJECAO = fft(projecao);             % FFT-1D (linha por linha) das projecoes
for i = 1:size(projecao,2)
   PROJECAO(:,i) = PROJECAO(:,i).*H;  % filtragem no dominio da frequencia
end
projecao = real(ifft(PROJECAO));      % FFT-1D inversa, "p" corresponde as projecoes filtradas

% ------------------------------------------------------------------------
% Inicio da retroprojecao
% ------------------------------------------------------------------------
fr = zeros(N);                    % imagem de saida
% define as coordenadas x e y para a reconstrucao
% utiliza o REPMAT para evitar o FOR
x = repmat((1:N)-ceil(N/2),N,1);    
y = rot90(x);

% mudanca de coordenadas: retangular/cilindrica
costheta = cos(theta);
sintheta = sin(theta);
centro = ceil(len/2);     % centro das projecoes

for i=1:length(theta)   
   proj = projecao(:,i);
   t = round(x*costheta(i) + y*sintheta(i)); % rotacao da projecao atual
   
   fr = fr + proj(t+centro); % acumulador das projecoes
   
   % [2 100*i/180]
end
fr = fr*pi/(2*length(theta));
return;
