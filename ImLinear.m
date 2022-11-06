%----------------------------------------------------- 
%               Amanda Costa Martinez
%     C�digo para reconstru��o de imagem de US
%                  Transdutor Linear
%                     IA751 2s2022
%----------------------------------------------------

close all
clear all

% Leitura dos sinais de RF gerados pela ultrassonix com o MATLAB

%fun��o load_ux_signal fornecida pela ultrassonix
[x header params actual_frames] = load_ux_signal('data/18-06-05.rf',1,1);

%armazenando os dados de interesse em uma vari�vel
data = x;

%% paper pre processing classical
%data = pre_processing_classical(data, 1, 1);

%%
size(data)                                           %verifica as dimens�es da matriz de dados

%%
%Envelope para uma Scanline
ScanLine = data(:,95,1);                      %para pegar todas as amostras de um �nico elemento
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
                                                          %elementos de um �nico frame

H = hilbert(I);                                     %para obter o sinal anal�tico
Hm = abs(H);                                     %utiliza-se apenas a magnitude do sinal

%Valores max e min s�o mto divergentes em magnitude
max(Hm(:))                                        %valor m�ximo das amostras
min(Hm(:))                                         %valor minimo das amostras
%%
%Compress�o Logaritmica
Hm = log10(Hm);                               %compressao dos dados em escala logaritmica

%Normaliza��o dos dados
Hm = Hm - min(min(Hm));                %Sinal p�s CompLog � subtraido ponto a ponto 
                                                          %do fundo de escala da matriz
Hm = Hm./max(max(Hm));                %Ap�s subtra��o, divide-se ponto a ponto pelo valor m�ximo de Hm 
%%
%plota Figure_2
figure, imshow(Hm);
saveas(gcf, 'LogComp.jpg')
%%
%Redimensionamento da Imagem
H2=imresize(Hm, [2080/10 191]);
H3 = imadjust(H2);                            %redimensionamento da imagem 
                                                          %necess�rio devido a diferen�a entre o numero 
                                                          %de amostras e de elementos

%plota Figure_3
figure, imshow(H3);
saveas(gcf, 'IA751_Linear.jpg')
%% Try new enhancement
Hm = imresize(Hm, [2080/10 191]);

pout_imadjust = imadjust(Hm);
pout_imadjust = imresize(pout_imadjust, [2080/10 191]);

pout_histeq = histeq(Hm);
pout_histeq = imresize(pout_histeq, [2080/10 191]);

pout_adapthisteq = adapthisteq(Hm);
pout_adapthisteq = imresize(pout_adapthisteq, [2080/10 191]);

figure
montage({Hm, pout_imadjust, pout_histeq, pout_adapthisteq},"Size",[1 4])
title("Original Image and Enhanced Images using imadjust, histeq, and adapthisteq")

%% sharpen filter
b = imsharpen(pout_imadjust,'Radius',4,'Amount',1);
figure, imshow(b)
title('Sharpened Image');
%% open and close morphological operation
se = strel('disk',5);

afterOpening = imclose(pout_imadjust,se);
figure
imshow(afterOpening,[]);