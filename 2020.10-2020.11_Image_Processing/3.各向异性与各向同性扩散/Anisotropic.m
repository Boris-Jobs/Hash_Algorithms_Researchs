clear
clc

lambda=15; 
k=0.15;% diffusivity coefficient
N=100;% iterations
img1=imread('quan.jpg');
subplot(121),imshow(uint8(img1)),title('original')
[m,n,o]=size(img1);
img2=zeros(m+2,n+2,o);
img2(2:m+1,2:n+1,1:o)=img1;
imgn=zeros(m+2,n+2,o);
for i=1:N
    for o=1:3
    for p=1:m
        for q=1:n
            NI=img2(p,q+1,o)-img2(p+1,q+1,o);
            SI=img2(p+2,q+1,o)-img2(p+1,q+1,o);
            EI=img2(p+1,q,o)-img2(p+1,q+1,o);
            WI=img2(p+1,q+2,o)-img2(p+1,q+1,o);
            
            cN=exp(double(-NI^2/(lambda*lambda)));
            cS=exp(double(-SI^2/(lambda*lambda)));
            cE=exp(double(-EI^2/(lambda*lambda)));
            cW=exp(double(-WI^2/(lambda*lambda)));
            
            imgn(p+1,q+1,o)=img2(p+1,q+1,o)+k*(cN*NI+cS*SI+cE*EI+cW*WI);     
        end
    end
    end
    img2=imgn;
end
subplot(122),imshow(uint8(img2)),title('edge preserving');











