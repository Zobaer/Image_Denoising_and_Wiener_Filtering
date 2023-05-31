clc; clear; close all;
f=16;  %Fontsize 
orig_image = imread("circuit.bmp"); orig_image = im2double(orig_image);
noisy_image = imread('circuit_sp05.bmp');
noisy_image = im2double(noisy_image);
wsq = 1:2:25;
for i=1:length(wsq)
    denoised_medfilt2 = medfilt2(noisy_image, [wsq(i) wsq(i)],'symmetric');
    PSNR_medfilt2(i) = psnr(orig_image,denoised_medfilt2);
    SSIM_medfilt2(i) = ssim(orig_image,denoised_medfilt2);
end

figure(1);subplot(121);plot(wsq,PSNR_medfilt2,'r',LineWidth=1.4);xlabel("Window size",FontSize=f);grid on;
ylabel('PSNR',FontSize=f-4); title("PSNR vs. window sizes for fixed-size median filter",FontSize=f);
subplot(122);plot(wsq,SSIM_medfilt2,'b',LineWidth=1.4);xlabel("Window size",FontSize=f);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. window sizes for fixed-size median filter",FontSize=f);

psnr_noisy_im = psnr(orig_image,noisy_image)
ssim_noisy_im = ssim(orig_image,noisy_image)

ws = 7;
denoised_medfilt2 = medfilt2(noisy_image, [ws ws],'symmetric');
figure(2);imshow(noisy_image);title('Noisy Image',FontSize=f);
figure(3);imshow(denoised_medfilt2);title('Denoised Image using medfilt2',FontSize=f);
