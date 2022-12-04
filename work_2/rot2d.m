function g = rot2d(f,angulo,lin,col)
% ROT2D -> rotaciona uma imagem 2D
% g = rot2d(f,theta,lin,col)
%     f: imagem original
%     teta: angulo de rotacao (em graus)
%     lin,col: posicao do centro da rotacao

[m n]=size(f);
theta=2*pi*angulo/360; % conversao de graus para radianos
a=[cos(theta) -sin(theta);sin(theta) cos(theta)]; % matriz de rotacao
g=zeros(m,n);

for i=1:m,
  for j=1:n,
    novoi=round((i-lin)*a(1,1)+(j-col)*a(1,2)+lin);
    novoj=round((i-lin)*a(2,1)+(j-col)*a(2,2)+col);
    if novoi>=1 & novoi<=m & novoj>=1 & novoj<=n,
      g(i,j)=f(novoi,novoj);
      
    end;
  end;
end;
