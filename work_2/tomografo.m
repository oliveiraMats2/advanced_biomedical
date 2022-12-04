% script de teste de reconstrucao tomografica

%------------------------------------------
% IMAGEM "PHANTOM" 512x512
%------------------------------------------
clear all;
% geracao de imagem utilizada como phantom
f512=phantom('Modified Shepp-Logan',512);
fr512=ct(f512); % reconstrucao
img = fr512;
[m n]=size(fr512);
frf512=abs(ifft2(ifftshift(butterpb(m,n,2,3)).*fft2(fr512))); % filtro Butterworth
f512=normaliza(f512);
fr512=normaliza(fr512);
frf512=normaliza(frf512);
img1 = normaliza(img);
imwrite(uint8(img1),'semFiltro.jpg');
imwrite(uint8(f512),'forig512.jpg');
imwrite(uint8(fr512),'fr512.jpg');
imwrite(uint8(frf512),'frfiltr512.jpg');
imwrite(uint8(normaliza(f512-frf512)),'fdif512.jpg');



