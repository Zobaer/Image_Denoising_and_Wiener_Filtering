clc; clear; close all; f = 20;
OI = im2double(imread('original.bmp'));BI = im2double(imread('blur1.bmp'));
psnr_BI = psnr(OI,BI); ssim_BI = ssim(OI,BI);
figure(1), imshow(OI), title('Original Image');
figure(2), imshow(BI),
title(sprintf('Blurred Image (PSNR=%.2fdB, SSIM=%.2f)',psnr_BI,ssim_BI),FontSize=f);
[M, N] = size(BI);
OIF=fftshift(fft2(OI));
BIF=fftshift(fft2(BI));
a = 0.1; b = 0.1; T = 1; WF=ones(M,N); K = .001:.002:.1;
for p=1:length(K)
    for u=1:M
         for v=1:N
             uu=u-M/2-1;vv=v-N/2-1;
             t = uu*a+vv*b;
             H(u,v) = T*sinc(t)*exp(-1j*pi*t);
             WF(u,v) = (1/H(u,v))*(abs(H(u,v))^2)/(abs(H(u,v))^2+K(p)^2);
         end
    end
    RDF=BIF.*WF; RDI=abs(ifft2(ifftshift(RDF)));RDI=RDI/max(max(RDI));
    psnr_FI(p) = psnr(OI,RDI); ssim_FI(p) = ssim(OI,RDI);
end

figure(1);subplot(121);plot(K,psnr_FI,'r',LineWidth=1.4);xlabel("K",FontSize=f);grid on;
ylabel('PSNR (dB)',FontSize=f-4); title("PSNR vs. K for Weiner filter",FontSize=f);
subplot(122);plot(K,ssim_FI,'b',LineWidth=1.4);xlabel("K",FontSize=f);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. K for Weiner filter",FontSize=f);

[m_psnr, argmax_psnr] = max(psnr_FI);[m_ssim, argmax_ssim] = max(ssim_FI);
K_max_psnr = K(argmax_psnr)
m_psnr
K_max_ssim = K(argmax_ssim)
m_ssim
% RDF=BIF.*WF; RDI=abs(ifft2(ifftshift(RDF)));RDI=RDI/max(max(RDI));
% psnr_IF=psnr(RDI,OI); ssim_IF=ssim(RDI,OI);
% %figure(3); imshow(IF,[]),title('Degradation function');
% figure(3), imshow(RDI),
% title(sprintf('After Wiener FIltering with K = %.2f (PSNR=%.2fdB, SSIM=%.2f)',K, psnr_IF,ssim_IF),FontSize=f);