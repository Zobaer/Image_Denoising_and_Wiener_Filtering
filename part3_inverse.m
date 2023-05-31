clc; clear; close all; f = 22;
OI = im2double(imread('original.bmp'));BI = im2double(imread('blur1.bmp'));
psnr_BI = psnr(OI,BI); ssim_BI = ssim(OI,BI);
figure(1), imshow(OI), title('Original Image',FontSize=f);
figure(2), imshow(BI),
title(sprintf('Blurred Image (PSNR=%.2fdB, SSIM=%.2f)',psnr_BI,ssim_BI),FontSize=f);
[M, N] = size(BI);
BIF=fftshift(fft2(BI));
a = 0.1; b = 0.1; T = 1; IF=ones(M,N);
for u=1:M
     for v=1:N
         uu=u-M/2-1;vv=v-N/2-1;
         t = uu*a+vv*b;
         H(u,v) = T*sinc(t)*exp(-1j*pi*t);
         if abs(H(u,v))>.2
            IF(u,v)=1/abs(H(u,v));
         end
     end
end
RDF=BIF.*IF; RDI=abs(ifft2(ifftshift(RDF)));RDI=RDI/max(max(RDI));
psnr_IF=psnr(RDI,OI); ssim_IF=ssim(RDI,OI);
figure(3); imshow(abs(H),[]),title('Degradation function',FontSize=f);
figure(4); imshow(IF,[]),title('Inverse degradation function',FontSize=f);
figure(5), imshow(RDI),
title(sprintf('After Inverse FIltering (PSNR=%.2fdB, SSIM=%.2f)',psnr_IF,ssim_IF),FontSize=f);