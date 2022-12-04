function g=normaliza(f)
% NORMALIZA -> Normaliza os valores da figura
%   g=normaliza(f)
%   Esta funcao normaliza os valores dos pixels de uma
%   figura (matriz), ajustando-os para a faixa [0,255]

f=double(f);
f=f-min(min(f));     % ajuste de zero
f=f*255/max(max(f)); % ajuste de fundo de escala
g=round(f);
return;
