%----------------------------------------------------- 
%               Amanda Costa Martinez
%  Código para reconstrução de imagem de US
%                  Transdutor Linear
%                     IA751 2s2020
%----------------------------------------------------

close all
clear all

% Leitura dos sinais de RF gerados pela ultrassonix com o MATLAB

%função load_ux_signal fornecida pela ultrassonix
%[x header params actual_frames] = load_ux_signal('data/18-02-46.rf',1,1);
[x header params actual_frames] = load_ux_signal('data/18-06-05.rf',1,1);
%[x header params actual_frames] = load_ux_signal('data/18-08-36.rf',1,1);

%armazenando os dados de interesse em uma variável
data = x;

%função read_sonixRF análoga a da ultrassonix modificada pelo Ramon
%[header, rf_data] = read_sonixRF('14-30-46.rf');
%data = rf_data;
%%
size(data)                                           %verifica as dimensões da matriz de dados
%%
%Envelope para uma Scanline
ScanLine = data(:,40,1);                      %para pegar todas as amostras de um único elemento
envelope = abs(hilbert(ScanLine));     %pega-se apenas a amplitude do sinal analitico obtido 
                                                          %pela transformada de Hilbert

%Plota Figure_1
figure; plot(ScanLine)
hold on
plot(envelope,'r');
hold off
saveas(gcf, 'Envelope.jpg');
%%
%Processamento de toda a matriz de RF
I = data (:,:,1);                                     %Para pegar todas as amostras de todos os 
                                                          %elementos de um único frame

H = hilbert(I);                                     %para obter o sinal analítico
Hm = abs(H);                                     %utiliza-se apenas a magnitude do sinal
sc = Hm; 
%Valores max e min são mto divergentes em magnitude
max(Hm(:))                                        %valor máximo das amostras
min(Hm(:))                                         %valor minimo das amostras
%%
%Compressão Logaritmica
A = max(Hm(:));
a = min(Hm(:));
dr = 20*log10(A/a);
k = A/(1-10^-dr/20);
v = log10(10)/log10(exp(1));
ln = Hm/a;
ln = log10(ln)/log10(exp(1));
p = 20*(2^8/dr*v*ln)+ (-50);                 %compressão clássica       

ic = 20*log10(Hm/(k+10^-dr/20));              % modelo UNICAMP 
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
%%
%plota Figure_2
figure, imshow(sc);
saveas(gcf, 'LogComp.jpg')
%%
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
figure, imshow(sc2);
saveas(gcf, 'IA751_Linear.jpg')