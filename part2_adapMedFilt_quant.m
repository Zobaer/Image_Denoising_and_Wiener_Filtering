clc; clear; close all; f=16; OI=imread("circuit.bmp"); OI=im2double(OI);
NI=imread('circuit_sp05.bmp'); NI=im2double(NI); Smax=3:2:61; [r,c]=size(NI);
for k=1:length(Smax)
    FI=zeros(r,c);
    for i=1:r
        for j=1:c
            S=3;
            while (S<=Smax(k))
                rmin=max(i-floor(S/2),1); rmax=min(i+floor(S/2),r);
                cmin=max(j-floor(S/2),1); cmax=min(j+floor(S/2),c);
                curr_window=NI(rmin:rmax,cmin:cmax);
                Zmin=min(curr_window(:)); Zmax=max(curr_window(:)); Zmed=median(curr_window(:));
                A1=Zmed-Zmin; A2=Zmed-Zmax;
                if (A1>0&&A2<0)
                    B1=NI(i,j)-Zmin; B2=NI(i,j)-Zmax;
                    if(B1>0&&B2<0)
                        FI(i,j)=NI(i,j);
                    else
                        FI(i,j)=Zmed;
                    end
                    break; % Exit the inner loop (while loop)
                end
                S=S+2;
                if (S>Smax(k))
                    FI(i,j)=NI(i,j);
                end
            end
        end
    end
    psnr_FI(k)=psnr(OI,FI); ssim_FI(k)=ssim(OI,FI);
end
figure(1);subplot(121);plot(Smax,psnr_FI,'r',LineWidth=1.4);xlabel("Max window size",FontSize=f);grid on;
ylabel('PSNR',FontSize=f-4); title("PSNR vs. max window sizes for adaptive median filter",FontSize=f);
subplot(122);plot(Smax,ssim_FI,'b',LineWidth=1.4);xlabel("Max window size",FontSize=f);grid on;
ylabel('SSIM',FontSize=f-4); title("SSIM vs. max window sizes for adaptive median filter",FontSize=f);
