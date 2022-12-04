function H = butterpb(W,H,Tc,n)

%    BUTTERPB - Gera Mascara do Filtro ButterWorth no Domineo da Frequencia
%    ButterPB(W,H,Tc,n)
%    Onde W = # de Colunas e H = $ de Linhas da Mascara, Tc = Periodo de Corte
%    e n = ordem do filtro

if n<1,
   display(fprintf('Ordem n deve ser maior que zero'));
   return;
end;

if ((Tc<2) | (Tc>max(W,H))), 
   display(fprintf('Tc deve estar compreendido no intervalo [2,max(W,H)]'));
   return;
end;

K = sqrt(2) - 1;  % Constante de Normalizaçao p/ resposta Sqrt(2)/2 em Fc.
Fc = 1/Tc; 			% Calcula Fc.
Wmedio = fix(W/2);
Hmedio = fix(H/2);

%---------------------------------------------------------------------------------
%		Calculo da Mascara do Filtro ButterWorth
%---------------------------------------------------------------------------------
% Gera distancias de colunas(X) e linhas(Y) ao centro.
[X,Y]= meshgrid(-Hmedio:Hmedio-1+mod(H,2),-Wmedio:Wmedio-1+mod(W,2)); 
% Normaliza distancias de X e Y ao centro em funcao de H e W.
X = X/(2*Hmedio); Y=Y/(2*Wmedio); 
% Calcula Distancia Euclidiana Normalizada de cada ponto ao centro.
D = sqrt(X.^2 + Y.^2);
% Aplica a funcao do filtro ButterWorth.
H = 1./(1+K*((D/Fc).^(2*n)));

return;
