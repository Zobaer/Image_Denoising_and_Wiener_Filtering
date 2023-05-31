clc; clear; close all; f = 16;
OI = im2double(imread('original.bmp'));BI = im2double(imread('blur1.bmp'));
psnr_BI = psnr(OI,BI); ssim_BI = ssim(OI,BI);
figure(1),imshow(OI), title('Original Image',FontSize=f);

%BI = medfilt2(BI,[9 9]);
%BI = imboxfilt(BI,5);
figure(2), imshow(BI),
title(sprintf('Blurred Image after median filtering (PSNR=%.2fdB, SSIM=%.2f)',psnr_BI,ssim_BI),FontSize=f);
[M, N] = size(BI);

%OIF=fftshift(fft2(OI));
BIF=fftshift(fft2(BI));
a = 0.1; b = 0.1; T = 1; WF=ones(M,N);
%K = .055; %for max PSNR in blur1
K = .047 %for max ssim in blur1


for u=1:M
     for v=1:N
         uu=u-M/2-1;vv=v-N/2-1;
         t = uu*a+vv*b;
         H(u,v) = T*sinc(t)*exp(-1j*pi*t);
         WF(u,v) = (1/H(u,v))*(abs(H(u,v))^2)/(abs(H(u,v))^2+K^2);
     end
end
RDF=BIF.*WF; RDI=abs(ifft2(ifftshift(RDF)));RDI=RDI/max(max(RDI));
psnr_WF=psnr(RDI,OI); ssim_WF=ssim(RDI,OI);
%figure(3); imshow(IF,[]),title('Degradation function');
figure(3), imshow(RDI),
title(sprintf('After Wiener Filtering, K = %.3f (PSNR=%.3fdB, SSIM=%.3f)',K, psnr_WF,ssim_WF),FontSize=f);