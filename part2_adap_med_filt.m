clc; clear; close all; f=16;
OI=imread("circuit.bmp"); OI=im2double(OI);
NI=imread('circuit_sp05.bmp'); NI=im2double(NI);
Smax=43; [r,c]=size(NI); FI=zeros(r,c);
for i=1:r
    for j=1:c
        S=3;
        while (S<=Smax)
            rmin=max(i-floor(S/2),1); rmax=min(i+floor(S/2),r);
            cmin=max(j-floor(S/2),1); cmax=min(j+floor(S/2),c);
            curr_window=NI(rmin:rmax,cmin:cmax);
            Zmin=min(curr_window(:)); Zmax=max(curr_window(:));
            Zmed=median(curr_window(:));
            A1=Zmed-Zmin; A2=Zmed-Zmax;
            if (A1>0 && A2<0)
                B1=NI(i,j)-Zmin; B2=NI(i,j)-Zmax;
                if (B1>0 && B2<0)
                    FI(i,j)=NI(i,j);
                else
                    FI(i,j)=Zmed;
                end
                break;
            end
            S=S+2;
            if (S>Smax) 
                FI(i,j)=NI(i,j);
            end
        end
    end
end
figure(1); imshow(NI); title('Noisy Image',FontSize=f);
figure(2); imshow(FI);
title('Denoised Image using adaptive median filter',FontSize=f);
psnr_FI=psnr(OI,FI)
ssim_FI=ssim(OI,FI)
