clc; clear; close all; f = 16;
OI = im2double(imread('original.bmp'));BI = im2double(imread('blur3.bmp'));
psnr_BI = psnr(OI,BI); ssim_BI = ssim(OI,BI);

figure(1); subplot(221);imshow(OI); title('Original Image',FontSize=f);
subplot(222);imshow(BI),title(sprintf('Blurred & noisy Image \n (PSNR=%.2fdB, SSIM=%.2f)',psnr_BI,ssim_BI),FontSize=f);

mwidth = 9;
BIM = medfilt2(BI,[mwidth mwidth],'symmetric');
psnr_BIM = psnr(OI,BIM); ssim_BIM = ssim(OI,BIM);
%BI = imboxfilt(BI,5);

subplot(223); imshow(BIM);
title(sprintf('After median filtering (width = %d) \n(PSNR=%.2fdB, SSIM=%.2f)',mwidth,psnr_BIM,ssim_BIM),FontSize=f);

[M, N] = size(BIM);

%OIF=fftshift(fft2(OI));
BIF=fftshift(fft2(BIM));
a = 0.1; b = 0.1; T = 1; WF=ones(M,N);
K = .14; %for blur3

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
subplot(224); imshow(RDI);
title(sprintf('After Wiener Filtering, K = %.2f \n (PSNR=%.3fdB, SSIM=%.3f)',K, psnr_WF,ssim_WF),FontSize=f);