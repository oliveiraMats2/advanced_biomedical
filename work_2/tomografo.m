% script de teste de reconstrucao tomografica

%------------------------------------------
% IMAGEM "PHANTOM" 512x512
%------------------------------------------
clear all;, close all;
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


%------------------------------------------
% IMAGEM REAL 240x240
%------------------------------------------
% clear all;
% ftomo=double(imread('fatia-pb.jpg'));
% frtomo=ct(ftomo); % reconstrucao
% [m n]=size(frtomo);
% frftomo=abs(ifft2(ifftshift(butterpb(m,n,2,3)).*fft2(frtomo))); % filtro Butterworth
% ftomo=normaliza(ftomo);
% frtomo=normaliza(frtomo);
% frftomo=normaliza(frftomo);
% imwrite(uint8(frtomo),'fatia-r.jpg');
% imwrite(uint8(frftomo),'fatia-r-filtr.jpg');
% imwrite(uint8(normaliza(ftomo-frftomo)),'fatia-dif.jpg');
% imwrite(uint8(normaliza(errorms(ftomo,frftomo))),'fatia-rms.jpg');
% %------------------------------------------
% % IMAGEM SMPTE 512x512
% %------------------------------------------
% clear all;
% fsmpte=double(imread('smpte.jpg'));
% frsmpte=ct(fsmpte); % reconstrucao
% [m n]=size(frsmpte);
% frfsmpte=abs(ifft2(ifftshift(butterpb(m,n,2,3)).*fft2(frsmpte))); % filtro Butterworth
% fsmpte=normaliza(fsmpte);
% frsmpte=normaliza(frsmpte);
% frfsmpte=normaliza(frfsmpte);
% imwrite(uint8(frsmpte),'frsmpte.jpg');
% imwrite(uint8(frfsmpte),'frfiltrsmpte.jpg');
% imwrite(uint8(normaliza(fsmpte-frfsmpte)),'fdifsmpte.jpg');
% imwrite(uint8(normaliza(errorms(fsmpte,frfsmpte))),'fdifsmpte.jpg');
