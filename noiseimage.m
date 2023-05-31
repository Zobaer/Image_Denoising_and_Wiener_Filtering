clc; clear; close all;

I=im2double(imread('circuit.bmp'));

J=imnoise(I,'gaussian',0,0.01);
K=imnoise(I,'salt & pepper', 0.25);

subplot(1,3,1),imshow(I);
subplot(1,3,2),imshow(J); 
subplot(1,3,3),imshow(K);

% imwrite(J,'circuit_gauss001.bmp');
imwrite(K,'circuit_sp25.bmp');

SNR1=psnr(I,J)
SNR2=psnr(I,K)