close all;
clc;

img=imread('riven.jpg');
img=rgb2gray(img);
normimg=norm(double(img),'fro');
[m,n]=size(img);
subplot(131);imshow(img);title('ԭͼ');
img1=imnoise(img,'Gaussian',0,0.0246);
subplot(132);imshow(img1);title('���ϸ�˹����');
r=10;%ģ��뾶
imgn=zeros(m+2*r+1,n+2*r+1);
imgn(r+1:m+r,r+1:n+r)=img1;
imgn(1:r,r+1:n+r)=img1(1:r,1:n);%��չ�ϱ߽�
imgn(1:m+r,n+r+1:n+2*r+1)=imgn(1:m+r,n:n+r);%��չ�ұ߽�
imgn(m+r+1:m+2*r+1,r+1:n+2*r+1)=imgn(m:m+r,r+1:n+2*r+1);%��չ�±߽�
imgn(1:m+2*r+1,1:r)=imgn(1:m+2*r+1,r+1:2*r);%��չ��߽�

sigma_d=2;
sigma_r=0.1;
[x,y] = meshgrid(-r:r,-r:r);
w1=exp(-(x.^2+y.^2)/(2*sigma_d^2));%�Ծ�����Ϊ�Ա�����˹�˲���

%h=waitbar(0,'wait...');%��ʼ��waitbar
for i=r+1:m+r
    for j=r+1:n+r        
        w2=exp(-(imgn(i-r:i+r,j-r:j+r)-imgn(i,j)).^2/(2*sigma_r^2)); 
        %����Χ�͵�ǰ���ػҶȲ�ֵ��Ϊ�Ա����ĸ�˹�˲���
        w=w1.*w2;        
        s=imgn(i-r:i+r,j-r:j+r).*w;
        sumw=0;
        for k=1:2*r+1
            for l=1:2*r+1
                sumw=sumw+w(k,l);
            end
        end
        sums=0;
        for k=1:2*r+1
            for l=1:2*r+1
                sums=sums+s(k,l);
            end
        end
        imgn(i,j)=sums/sumw;   
    end
    %waitbar(i/m);
end
%close(h)
img2=imgn(r+1:m+r,r+1:n+r);
%figure;
error=100*norm(img2-double(img),'fro')/normimg;
subplot(133);imshow(uint8(img2));title({'Bilateral filter ��s=2����r=0.1',['error =',num2str(error)]});