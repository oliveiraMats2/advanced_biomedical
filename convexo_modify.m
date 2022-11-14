%----------------------------------------------------- 
%               Amanda Costa Martinez
%  Código para reconstrução de imagem de US
%                  Transdutor Convexo
%                     IA751 2s2020
%----------------------------------------------------

close all
clear all

% Leitura dos sinais de RF gerados pela ultrassonix com o MATLAB

%função load_ux_signal fornecida pela ultrassonix
%[x header params actual_frames] = load_ux_signal('data/18-02-46.rf',1,1);
%[x header params actual_frames] = load_ux_signal('data/18-06-05.rf',1,1);
[x header params actual_frames] = load_ux_signal('data/18-08-36.rf',1,1);

%armazenando os dados de interesse em uma variável
data = x;

%função read_sonixRF análoga a da ultrassonix modificada pelo Ramon
%[header, rf_data] = read_sonixRF('14-30-46.rf');
%data = rf_data;

size(data)                                           %verifica as dimensões da matriz de dados

%Envelope para uma Scanline
ScanLine = data(:,50,1);                      %para pegar todas as amostras de um único elemento
envelope = abs(hilbert(ScanLine));     %pega-se apenas a amplitude do sinal analitico obtido 
                                                          %pela transformada de Hilbert

%Plota Figure_1
figure; plot(ScanLine)
hold on
plot(envelope,'r');
hold off
saveas(gcf, 'Envelope.jpg');

%Processamento de toda a matriz de RF
I = data (:,:,1);                                     %Para pegar todas as amostras de todos os 
                                                          %elementos de um único frame

H = hilbert(I);                                     %para obter o sinal analítico
Hm = abs(H);                                     %utiliza-se apenas a magnitude do sinal
sc = Hm;
%Valores max e min são mto divergentes em magnitude
max(Hm(:))                                        %valor máximo das amostras
min(Hm(:))                                         %valor minimo das amostras

%Compressão Logaritmica
A = max(Hm(:));
a = min(Hm(:));
dr = 20*log10(A/a);
k = A/(1-10^-dr/20);
v = log10(10)/log10(exp(1))
ln = Hm/a;
ln = log10(ln)/log10(exp(1));
p = 20*(2^8/dr*v*ln)+ (-50);  
ic = 20*log10(Hm/(k+10^-dr/20));

Hm = log10(Hm);                               %compressao dos dados em escala logaritmica

%Normalização dos dados
sc = sc - min(min(ic));
p = p - min(min(ic));
ic = ic - min(min(ic));
Hm = Hm - min(min(Hm));                %Sinal pós CompLog é subtraido ponto a ponto 
                                                          %do fundo de escala da matriz
Hm = Hm./max(max(Hm));                %Após subtração, divide-se ponto a ponto pelo valor máximo de Hm 
ic = ic./max(max(ic));
p = p./max(max(p));
sc = sc./max(max(sc));

%plota Figure_2
figure, imshow(Hm);
saveas(gcf, 'LogComp.jpg')

%Redimensionamento da Imagem
sc1 = imresize(sc, [2080/10 191]);
sc2 = imadjust(sc1);
p1 = imresize(p, [2080/10 191]);
p2 = imadjust(p1); 
ic1 = imresize(ic, [2080/10 191]);
ic2 = imadjust(ic1); 
H2=imresize(Hm, [2080/10 191]);
H3 = imadjust(H2);                            %redimensionamento da imagem 
                                                          %necessário devido a diferença entre o numero 
                                                          %de amostras e de elementos

%plota Figure_3
figure, imshow(ic2);
saveas(gcf, 'Redimensionada.jpg')

%%
%----------------------------------------------
% Rotina de conversão de varredura CONVEXO
%----------------------------------------------

tic; %inicia temporizador

% Definição de parâmetros de entrada
ne = 128; % numero de elementos
i=1:ne; % indice dos elementos
kerf = 115e-6; % kerf
d = 0.41e-3; % largura do elemento
R = 58e-3; % raio do transdutor
N = 4680; % numero de amostras
n = 1:N; % indice das amostras
c = 1540; % velocidade do som no tecido mole
fs = 20e6; % frequência de amostragem
t = (n/fs)'; % escala de tempo

%----------------------------------
% Ângulo de abertura do transdutor convexo
%----------------------------------
c_transdutor = 2*pi*R;
c_abertura = (ne-1)*(kerf + d);
theta_convexo = 360*c_abertura/c_transdutor;

%----------------------------------
% Ângulo de abertura do transdutor convexo
% de cada elemento
%----------------------------------

theta_convexo_i = (i-(ne+1)/2)*theta_convexo/(ne-1);

%----------------------------------
% Escala de profundidade
%----------------------------------
z = c*t/2+R;

%----------------------------------
% Dados das inclusões para teste
%----------------------------------
a = 200; b = 10;

[THETA,RHO] = meshgrid(degtorad(theta_convexo_i),z);

[xc,yc] = pol2cart(THETA,RHO);

%----------------------------------
% Imagem simulada antes da conversão de varredura
%----------------------------------

figure;
colormap(gray);
imagesc(theta_convexo_i,(z-R),Hm);

xlabel('\theta_c_o_n_v_e_x_o [\circ]');
ylabel('Profundidade z[mm]');
axis tight; colorbar;

%----------------------------------
% Imagem simulada após a conversão de varredura
%----------------------------------

figure; 
colormap(gray);
h=surf((xc-R)*1e3,(yc)*1e3,Hm,'edgecolor' ,'none');

view(90,90);
xlabel('Profundidade z[mm]');
ylabel('Eixo x[mm]');
axis image;
saveas(gcf, 'IA751_Convexo.jpg')
toc                             % finaliza temporizador