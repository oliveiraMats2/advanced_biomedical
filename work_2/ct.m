function fr = ct(f)
% CT -> Simulacao de reconstrucao de imagens tomograficas
%       por retroprojecao filtrada
% function fr = ct(f)
%
%       Utiliza as funcoes auxiliares:
%       ROT2D.M -> rotaciona a imagem
%       PRJ1D.M -> realiza a projecao 1D da imagem 2D
%       BACKPROJ.M -> realiza a retroprojecao filtrada

% ampliacao da imagem original de forma que as novas dimensoes
% sejam iguais a diagonal original de forma a evitar perda de
% informacao dos cantos
[m n]=size(f);
novadim=ceil(sqrt(2)*max([m n]));
%g=zeros(novadim,novadim);
%g( fix((novadim-m)/2):fix((novadim-m)/2)+m-1 , fix((novadim-n)/2):fix((novadim-n)/2)+n-1  )=f;
figure, imshow(f);


% laco para calculo de todas as 180 projecoes (1 a 180 graus com passo = 1 grau)
for theta=1:180,
   gr=rot2d(f,theta,fix(novadim/2),fix(novadim/2));
   %if theta==45| theta==90| theta==120, plotar imagem girando 
    %figure, imshow(gr);
   %end;
   projecao(:,theta)=(prj1d(gr))'; % projecao vetor 
   

   %[1 100*theta/180] % indicador de porcentagem realizada
end;

% retroprojecao filtrada
for con=1:180,
    fr=backproj(projecao,1:con);
    if con == 10| con == 20| con ==30| con ==40| con ==50| con==60| con==70| con==80| con==90| con==100| con==110| con==120| con==130| con==140| con==150| con==160| con==170| con==180 ,
        %fr1=uint8(normaliza(fr));
        figure, imshow(fr); %| | | 
    end;
   
end;