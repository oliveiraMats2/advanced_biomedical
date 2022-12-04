function g=prj1d(f);
% PRJ1D -> projecao de uma matriz (2D) em um vetor (1D)
% g = prj1d(f)

[m n]=size(f);

% projecao na vertical (ao longo das colunas)
g=zeros(1,n); % vetor onde sera feita a projecao
g=sum(f);
