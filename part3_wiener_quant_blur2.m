clc; clear; close all; f = 16;OI = im2double(imread('original.bmp'));BI = im2double(imread('blur2.bmp'));
bwidth = 7; gsd = 0.8; mwidth= 9;BIPB = imboxfilt(BI,bwidth);BIPG = imgaussfilt(BI,gsd);BIPM = medfilt2(BI, [mwidth mwidth],'symmetric');
psnr_BI = psnr(OI,BI); ssim_BI = ssim(OI,BI);psnr_BIPB = psnr(OI,BIPB); ssim_BIPB = ssim(OI,BIPB);psnr_BIPG = psnr(OI,BIPG); ssim_BIPG = ssim(OI,BIPG);
psnr_BIPM = psnr(OI,BIPM); ssim_BIPM = ssim(OI,BIPM);
figure(1), subplot(231);imshow(OI), title('Original image',FontSize=f-2);
subplot(232); imshow(BI),title(sprintf('Blurred & noisy image \n (PSNR=%.3fdB, SSIM=%.3f)',psnr_BI,ssim_BI),FontSize=f-2);
subplot(233); imshow(BIPB),title(sprintf('Prefiltered - box filter (width = %d) \n (PSNR=%.3fdB, SSIM=%.3f)',bwidth, psnr_BIPB,ssim_BIPB),FontSize=f-2);
subplot(234); imshow(BIPG),title(sprintf('Prefiltered - Gaussian filter (SD = %0.1f) \n (PSNR=%.3fdB, SSIM=%.3f)',gsd, psnr_BIPG,ssim_BIPG),FontSize=f-2);
subplot(235); imshow(BIPM),title(sprintf('Prefiltered - median filter (width = %d) \n (PSNR=%.3fdB, SSIM=%.3f)',mwidth,psnr_BIPM,ssim_BIPM),FontSize=f-2);
[M, N] = size(BI);BIF=fftshift(fft2(BI));BIFPB=fftshift(fft2(BIPB));BIFPG=fftshift(fft2(BIPG));BIFPM=fftshift(fft2(BIPM));
a = 0.1; b = 0.1; T = 1; WF=ones(M,N); K = .02:.08:1.5;
for p=1:length(K)
    for u=1:M
         for v=1:N
             uu=u-M/2-1;vv=v-N/2-1;
             t = uu*a+vv*b;
             H(u,v) = T*sinc(t)*exp(-1j*pi*t);
             WF(u,v) = (1/H(u,v))*(abs(H(u,v))^2)/(abs(H(u,v))^2+K(p)^2);
         end
    end
    RDF=BIF.*WF; RDI=abs(ifft2(ifftshift(RDF)));RDI=RDI/max(max(RDI));RDFB=BIFPB.*WF; RDIB=abs(ifft2(ifftshift(RDFB)));RDIB=RDIB/max(max(RDIB));
    RDFG=BIFPG.*WF; RDIG=abs(ifft2(ifftshift(RDFG)));RDIG=RDIG/max(max(RDIG));
    RDFM=BIFPM.*WF; RDIM=abs(ifft2(ifftshift(RDFM)));RDIM=RDIM/max(max(RDIM));
    psnr_FI(p) = psnr(OI,RDI); ssim_FI(p) = ssim(OI,RDI);psnr_FIB(p) = psnr(OI,RDIB); ssim_FIB(p) = ssim(OI,RDIB);
    psnr_FIG(p) = psnr(OI,RDIG); ssim_FIG(p) = ssim(OI,RDIG);psnr_FIM(p) = psnr(OI,RDIM); ssim_FIM(p) = ssim(OI,RDIM);
end
figure(2);subplot(121);plot(K,psnr_FI,LineWidth=1.4); hold on; grid on;title("PSNR vs. K for Weiner filter",FontSize=f);
xlabel("K",FontSize=f);ylabel('PSNR (dB)',FontSize=f-4); plot(K,psnr_FIB,LineWidth=1.4);plot(K,psnr_FIG,LineWidth=1.4);plot(K,psnr_FIM,LineWidth=1.4);
legend("Without prefiltering","With box filtering","With Gauss filtering", "With median filtering",FontSize=f);
subplot(122);plot(K,ssim_FI,LineWidth=1.4); hold on;grid on;title("SSIM vs. K for Weiner filter",FontSize=f);
xlabel("K",FontSize=f);ylabel('SSIM',FontSize=f-4); plot(K,ssim_FIB,LineWidth=1.4);plot(K,ssim_FIG,LineWidth=1.4);plot(K,ssim_FIM,LineWidth=1.4);
legend("Without prefiltering","With box filtering","With Gauss filtering", "With median filtering",FontSize=f);