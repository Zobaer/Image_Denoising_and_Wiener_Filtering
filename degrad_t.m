clc; clear; close all;

O=imread('Aerial.TIF');
I=im2double(O);
J=fft2(I);
F1=fftshift(J);

k=0.0025;

[M N]=size(I);

for u=1:M
     for v=1:N
         uu=u-M/2-1;
         vv=v-N/2-1;
         t=-k*(uu^2+vv^2)^(5/6);
         H(u,v)=exp(t);
     end
end
J=H.*F1;
H5=ifftshift(J);
H3=ifft2(H5);
H2=real(H3);
H4=H2+randn(M,N)*0.025;

H4=H4/max(max(H4));
H5=imgaussfilt(H4,1);
%H5=wiener2(H4,[3 3]);

psnr1=psnr(H2,I), ssim1=ssim(H2,I);  
psnr2=psnr(H4,I), ssim2=ssim(H4,I);
psnr3=psnr(H5,I), ssim3=ssim(H5,I);

subplot(2,4,1),imshow(I,[]),title('Original image');
subplot(2,4,2),imshow(H2,[]),title(sprintf('Degraded image \n PSNR=%.2f dB, SSIM=%.2f',psnr1,ssim1));
subplot(2,4,3),imshow(H4,[]),title(sprintf('Noisy image \n PSNR=%.2f dB, SSIM=%.2f',psnr2,ssim2));
subplot(2,4,4),imshow(H5,[]),title(sprintf('Smoothed image\n PSNR=%.2f dB, SSIM=%.2f',psnr3,ssim3));


IF=fft2(H2);  % FFT of the degraded image
NF=fft2(H4);  % FFT of the degraded/noisy image
SF=fft2(H5);  % FFT of the smoothed/degraded/noisy image

IFC=fftshift(IF);
NFC=fftshift(NF);
SFC=fftshift(SF);

IW=ones(M,N);

for u=1:M
     for v=1:N
         uu=u-M/2-1;
         vv=v-N/2-1;
         r=sqrt(uu^2+vv^2);
         %but(u,v)=1/(1+(70/r)^4);
         if r<60   
            IW(u,v)=1/H(u,v);
         end
         %IW(u,v)=w+(1-w)*but(u,v);
     end
end

RDF=IFC.*IW;
RNF=NFC.*IW;
RSF=SFC.*IW;

RDI=abs(ifft2(ifftshift(RDF)));
RNI=abs(ifft2(ifftshift(RNF)));
RSI=abs(ifft2(ifftshift(RSF)));

RDI=RDI/max(max(RDI));
RNI=RNI/max(max(RNI));
RSI=RSI/max(max(RSI));

psnr4=psnr(RDI,I),ssim4=ssim(RDI,I);
psnr5=psnr(RNI,I),ssim5=ssim(RNI,I);
psnr6=psnr(RSI,I),ssim6=ssim(RSI,I);

subplot(2,4,5),imshow(H,[]),title('Degradation function');
subplot(2,4,6),imshow(RDI,[]),title(sprintf('Inverse filering (w/o noise) \n PSNR=%.2f dB, SSIM=%.2f',psnr4,ssim4));
subplot(2,4,7),imshow(RNI,[]),title(sprintf('Inverse filtering (w noise) \n PSNR=%.2f dB, SSIM=%.2f',psnr5,ssim5));
subplot(2,4,8),imshow(RSI,[]),title(sprintf('Inverse filtering (denoised) \n PSNR=%.2f dB, SSIM=%.2f',psnr6,ssim6));


