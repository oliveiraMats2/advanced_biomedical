%----------------------------------------------------- 
%               Amanda Costa Martinez
%  Código para reconstrução de imagem de US
%                  Transdutor Convexo
%                     IA751 2s2022
%----------------------------------------------------

close all;
clear all;
clc;

% Leitura dos sinais de RF gerados pela ultrassonix com o MATLAB

%função load_ux_signal fornecida pela ultrassonix
[x header params actual_frames] = load_ux_signal('data/18-06-05.rf',1,1);

%armazenando os dados de interesse em uma variável
data = x;

%função read_sonixRF análoga a da ultrassonix modificada pelo Ramon
%[header, rf_data] = read_sonixRF('14-30-46.rf');
%data = rf_data;

size(data)                                           %verifica as dimensões da matriz de dados

%Envelope para uma Scanline
ScanLine = data(:,3,1);                      %para pegar todas as amostras de um único elemento
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

%Valores max e min são mto divergentes em magnitude
max(Hm(:))                                        %valor máximo das amostras
min(Hm(:))                                         %valor minimo das amostras

%Compressão Logaritmica
Hm = log10(Hm);                               %compressao dos dados em escala logaritmica

%Normalização dos dados
Hm = Hm - min(min(Hm));                %Sinal pós CompLog é subtraido ponto a ponto 
                                                          %do fundo de escala da matriz
Hm = Hm./max(max(Hm));                %Após subtração, divide-se ponto a ponto pelo valor máximo de Hm 

%plota Figure_2
figure, imshow(Hm);
saveas(gcf, 'LogComp.jpg')

%Redimensionamento da Imagem
H2=imresize(Hm, [2080/10 191]);
H3 = imadjust(H2);                            %redimensionamento da imagem 
                                                          %necessário devido a diferença entre o numero 
                                                          %de amostras e de elementos

%plota Figure_3
figure, imshow(H3);
saveas(gcf, 'Redimensionada.jpg')

%--------------------------------------------
% Rotina
%--------------------------------------------
tic;            % inicia temporizador
ne =128;
i = 1:ne;
kerf = 155e-6;
d = 0.41e-3;
R = 40e-3;
N = 4096;
n = 1:N;
c = 1540;
fs = 40e6;
t = (n/fs);

%--------------------------------------------
% Angulo de abertura do transdutor convexo
%--------------------------------------------
c_transdutor = 2*pi*R;
c_abertura = (ne-1)*(kerf + d);
theta_convexo = 36*c_abertura/c_transdutor;

%--------------------------------------------
% Angulo de abertura do transdutor convexo
% de cada elemento
%--------------------------------------------
theta_convexo_i = (i-(ne+1)/2)*theta_convexo/(ne-1);
%--------------------------------------------
%Escala de profundidade
%--------------------------------------------
z = c*t/2+R;
%--------------------------------------------
% Buffer de dados para simulação
%--------------------------------------------
valor_final_Env_Log = (rand(N, ne)-2)*25;

%--------------------------------------------
%Dados das inclusões para teste
%--------------------------------------------
a = 200; b = 10;

%--------------------------------------------
%  Equação das inclusões
%--------------------------------------------
valor_final_Env_Log((N/4)-a:(N/4)+a,ne/2-b:ne/2+b)= 0;
valor_final_Env_Log((N/4)-a:(N/4)+a,ne*3/4-b:ne*3/4+b)= 0;
 
valor_final_Env_Log((N/2)-a:(N/2)+a,ne/4-b:ne/4+b)= -25;
valor_final_Env_Log((N/2)-a:(N/2)+a,ne/2-b:ne/2+b)= -25;
valor_final_Env_Log((N/2)-a:(N/2)+a,ne*3/4-b:ne*3/4+b)= -25;
 
valor_final_Env_Log((N*3/4)-a:(N*3/4)+a,ne/4-b:ne/4+b)= -50;
valor_final_Env_Log((N*3/4)-a:(N*3/4)+a,ne/2-b:ne/2+b)= -50;
valor_final_Env_Log((N*3/4)-a:(N*3/4)+a,ne*3/4-b:ne*3/4+b)= -50;

[THETA,RHO] = meshgrid(degtorad(theta_convexo_i),z); 
[xc,yc] = pol2cart(THETA,RHO); 
%---------------------------------- 
% Imagem simulada antes da conversão de varre?dura 
%---------------------------------- 
figure; colormap(gray); 
imagesc(theta_convexo_i,(z-R)*1e3,valor_final_Env_Log); 
xlabel('\theta_c_o_n_v_e_x_o [\circ]'); 
ylabel('Profundidade z[mm]'); 
axis tight; colorbar; 
%---------------------------------- 
% Imagem simulada após a conversão de varredura 
%---------------------------------- 
figure; colormap(gray); 
h=surf((xc-R)*1e3,(yc)*1e3,valor_final_Env_Log, 'edgecolor', 'none'); 
view(90,90); 
xlabel('Profundidade z[mm]'); 
ylabel('Eixo x[mm]'); 
axis image; colorbar; 
toc % finaliza temporizador 
%----------------------------------------------
