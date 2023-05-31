clc; clear; close all;f=20;  %Fontsize 
OI = imread("circuit.bmp"); OI = im2double(OI);
NI = imread('circuit_gauss001.bmp');NI = im2double(NI);
ws_alnd = 7; % The size of the local window for ALND
ws_am = 5; % The size of the local window for AM
sigma = 1.3; %SD of Gaussian smoothing filter
noise_var = 0.01; %the noise variance
[r, c] = size(NI);
for i = 1:r
    for j = 1:c
        rmin=max(i-floor(ws_alnd/2),1);rmax=min(i+floor(ws_alnd/2),r);
        cmin=max(j-floor(ws_alnd/2),1);cmax=min(j+floor(ws_alnd/2),c);
        curr_window=NI(rmin:rmax, cmin:cmax);
        loc_mean=mean(curr_window(:)); loc_var = var(curr_window(:));      
        ALNDI(i,j)=NI(i,j)-(noise_var/loc_var).*(NI(i,j)-loc_mean);
    end
end
AMI = imboxfilt(NI,ws_am); %arithmetic mean filter
GSI = imgaussfilt(NI,sigma); %Gaussian smoothing filter

figure(1);imshow(OI);title('Original image','FontSize',f);
figure(2);imshow(NI);title('Noisy image','FontSize',f);
figure(3);imshow(ALNDI);title('Denoised image by ALND','FontSize',f);
figure(4);imshow(AMI);title('Denoised image by arithmetic mean filter','FontSize',f);
figure(5);imshow(GSI);title('Denoised image by Gaussian smoothing filter','FontSize',f);

%quantitative evaluation
wsq = 1:2:25; sigmaq = linspace(.1,2.5,length(wsq));
for k=1:length(wsq)
    for i=1:r
        for j=1:c
            rmin=max(i-floor(wsq(k)/2), 1);rmax=min(i+floor(wsq(k)/2),r);
            cmin=max(j-floor(wsq(k)/2),1);cmax=min(j+floor(wsq(k)/2),c);
            curr_window=NI(rmin:rmax,cmin:cmax); % Get the current window
            loc_mean=mean(curr_window(:));loc_var = var(curr_window(:));      
            ALNDIq(i,j) = NI(i,j) - (noise_var/loc_var).*(NI(i,j) - loc_mean);
        end
    end
    AMIq = imboxfilt(NI,wsq(k));
    GSIq = imgaussfilt(NI,sigmaq(k));
    PSNR_ALND(k) = psnr(OI,ALNDIq);SSIM_ALND(k) = ssim(OI,ALNDIq);
    PSNR_AM(k) = psnr(OI,AMIq);SSIM_AM(k) = ssim(OI,AMIq);
    PSNR_GS(k) = psnr(OI,GSIq);SSIM_GS(k) = ssim(OI,GSIq);
end
figure(6);subplot(321);plot(wsq,PSNR_ALND,'r',LineWidth=1.4);xlabel("Window size",FontSize=f-4);grid on;
ylabel('PSNR',FontSize=f-4); title("PSNR vs. window sizes for ALND filter",FontSize=f-4);
subplot(322);plot(wsq,SSIM_ALND,'b',LineWidth=1.4);xlabel("Window size",FontSize=f-4);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. window sizes for ALND filter",FontSize=f-4);
subplot(323);plot(wsq,PSNR_AM,'r',LineWidth=1.4);xlabel("Window size",FontSize=f-4);grid on;
ylabel('PSNR',FontSize=f-4); title("PSNR vs. window sizes for AM filter",FontSize=f-4);
subplot(324);plot(wsq,SSIM_AM,'b',LineWidth=1.4);xlabel("Window size",FontSize=f-4);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. window sizes for AM filter",FontSize=f-4);
subplot(325);plot(sigmaq,PSNR_GS,color=[0 0.5 0],LineWidth=1.4);xlabel("\sigma",FontSize=f-4);grid on;
ylabel('PSNR',FontSize=f-4); title("PSNR vs. \sigma for Gaussian smoothing filter",FontSize=f-4);
subplot(326);plot(sigmaq,SSIM_GS,'m',LineWidth=1.4);xlabel("\sigma",FontSize=f-4);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. \sigma for Gaussian smoothing filter",FontSize=f-4);
psnr_noisy_im = psnr(OI,NI)
ssim_noisy_im = ssim(OI,NI)
