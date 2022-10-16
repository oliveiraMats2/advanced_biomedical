%----------------------------------------------------- 
%               Amanda Costa Martinez
%     Código para reconstrução de imagem de US
%                  Transdutor Linear
%                     IA751 2s2022
%----------------------------------------------------

close all
clear all

% Leitura dos sinais de RF gerados pela ultrassonix com o MATLAB

%função load_ux_signal fornecida pela ultrassonix
[x header params actual_frames] = load_ux_signal('data/18-02-46.rf',1,1);

%armazenando os dados de interesse em uma variável
data = x;

%função read_sonixRF análoga a da ultrassonix modificada pelo Ramon
%[header, rf_data] = read_sonixRF('14-30-46.rf');
%data = rf_data;
%%
size(data)                                           %verifica as dimensões da matriz de dados
%%
%Envelope para uma Scanline
ScanLine = data(:,95,1);                      %para pegar todas as amostras de um único elemento
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

%Valores max e min são mto divergentes em magnitude
max(Hm(:))                                        %valor máximo das amostras
min(Hm(:))                                         %valor minimo das amostras
%%
%Compressão Logaritmica
Hm = log10(Hm);                               %compressao dos dados em escala logaritmica

%Normalização dos dados
Hm = Hm - min(min(Hm));                %Sinal pós CompLog é subtraido ponto a ponto 
                                                          %do fundo de escala da matriz
Hm = Hm./max(max(Hm));                %Após subtração, divide-se ponto a ponto pelo valor máximo de Hm 
%%
%plota Figure_2
figure, imshow(Hm);
saveas(gcf, 'LogComp.jpg')
%%
%Redimensionamento da Imagem
H2=imresize(Hm, [2080/10 191]);
H3 = imadjust(H2);                            %redimensionamento da imagem 
                                                          %necessário devido a diferença entre o numero 
                                                          %de amostras e de elementos

%plota Figure_3
figure, imshow(H3);
saveas(gcf, 'IA751_Linear.jpg')