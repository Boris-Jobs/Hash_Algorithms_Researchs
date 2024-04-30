clear
clc

f=imread('riven.jpg');
g=rgb2gray(f);
g1=imnoise(g,'gaussian',0,0.1);
g2=imnoise(g,'salt & pepper',0.2);
subplot(331);imshow(g),title('��ԭͼ���Ҷ�');
[m,n]=size(g);
normg=norm(double(g),'fro');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X2=zeros(m+2,n+2);
for i=1:m
    for j=1:n
        X2(i+1,j+1)=g1(i,j);
    end
end
subplot(332);imshow(uint8(X2)),title('����˹�롿padding');
X3=zeros(m+4,n+4);
for i=1:m
    for j=1:n
        X3(i+2,j+2)=g1(i,j);
    end
end%�������ִ�С�ĸ�˹����padding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X4=zeros(m+4,n+4);
for i=1:m
    for j=1:n
        X4(i+2,j+2)=g2(i,j);
    end
end
X=zeros(m+2,n+2);
for i=1:m
    for j=1:n
        X(i+1,j+1)=g2(i,j);
    end
end%�������ִ�С�Ľ�������padding
subplot(333);imshow(uint8(X)),title('�������롿padding');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
averaging=[1/9,1/9,1/9;1/9,1/9,1/9;1/9,1/9,1/9];%averaging filter��1/9��Ԫ��
Y=zeros(m,n);
for i=1:m
    for j=1:n
        sum=0;
        for k=1:3
            for l=1:3
                sum=sum+averaging(k,l)*X2(i+k-1,j+l-1);%X2�ǣ�m+2��n+2����С
            end
        end
        Y(i,j)=sum;
    end
end
error=100*norm(Y-double(g),'fro')/normg;
subplot(334);imshow(uint8(Y)),title({'��averaging kernel��', ['norm_F error= ', num2str(error)] })
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gaussian=zeros(5,5);%��ȡ2����˹��
sumGaussian=0;%ϵ���ĺ�
for i=1:5
    for j=1:5
        Gaussian(i,j)=(1/sqrt(2*pi*100)*exp(-(((i-3)^2+(j-3)^2)/200)));
    end
end
for i=1:5
    for j=1:5
        sumGaussian=sumGaussian+Gaussian(i,j);
    end
end
Gaussian=Gaussian/sumGaussian;%����˹�˵�ϵ����һ����һ������

Z=zeros(m,n);
for i=1:m
    for j=1:n
        sum=0;
        for k=1:5
            for l=1:5
                sum=sum+Gaussian(k,l)*X3(i+k-1,j+l-1);
            end
        end
        Z(i,j)=sum;
    end
end
error=100*norm(Z-double(g),'fro')/normg;
subplot(335);imshow(uint8(Z)),title({'��Gaussian kernel ��s=10��', ['norm_F error= ', num2str(error)] })
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B1=zeros(5,5);%����˫���˲�ϵ���ĵ�һ��
s1=zeros(5,5);%��ʼ��һ������Ȩֵ�ķ���
for i=1:5
    for j=1:5
        s1(i,j)=sqrt((i-2)^2+(j-2)^2);
    end
end
s=(std2(s1))^2;
for i=1:5
    for j=1:5
        B1(i,j)=exp(-((i-3)^2+(j-3)^2)/(2*s^2));
    end
end
Z=zeros(m,n);
for i=1:m
    for j=1:n
        sum=0;%һ�ξ���ļ�Ȩƽ��
        sumB=0;%��ϵ������һ������
        var1=zeros(5,5);
        var1(1:5,1:5)=X3(i-1+1:i-1+5,j-1+1:j-1+5)-X3(i-1+3,j-1+3);
        r=(std2(var1))^2;
        for k=1:5
            for l=1:5
                sumB=sumB+B1(k,l)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        
        for k=1:5
            for l=1:5
                sum=sum+(B1(k,l)/sumB)*X3(i+k-1,j+l-1)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        Z(i,j)=sum;
    end
end
error=100*norm(Z-double(g),'fro')/normg;
subplot(339);imshow(uint8(Z)),title({'��Bilateral filter ��s,r����Ӧ��', ['norm_F error= ', num2str(error)] })
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B1=zeros(5,5);%����˫���˲�ϵ���ĵ�һ��
s=10;r=200;
for i=1:5
    for j=1:5
        B1(i,j)=exp(-((i-3)^2+(j-3)^2)/(2*s^2));
    end
end%û�������ֵ
Z=zeros(m,n);
for i=1:m
    for j=1:n
        sum=0;%�������ĺ�
        sumB=0;%Ȩֵ��ͣ���һ������
        for k=1:5
            for l=1:5
                sumB=sumB+B1(k,l)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        
        for k=1:5
            for l=1:5
                sum=sum+(B1(k,l)/sumB)*X3(i+k-1,j+l-1)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        Z(i,j)=sum;
    end
end
error=100*norm(Z-double(g),'fro')/normg;
subplot(337);imshow(uint8(Z)),title({'��Bilateral filter����s=10����r=200��', ['norm_F error= ', num2str(error)] })
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B1=zeros(5,5);%����˫���˲�ϵ���ĵ�һ��
s=10;r=0.1;
for i=1:5
    for j=1:5
        B1(i,j)=exp(-((i-3)^2+(j-3)^2)/(2*s^2));
    end
end%û�������ֵ
Z=zeros(m,n);
for i=1:m
    for j=1:n
        sum=0;%�������ĺ�
        sumB=0;%Ȩֵ��ͣ���һ������
        for k=1:5
            for l=1:5
                sumB=sumB+B1(k,l)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        
        for k=1:5
            for l=1:5
                sum=sum+(B1(k,l)/sumB)*X3(i+k-1,j+l-1)*exp(-(((X3(i-1+k,j-1+l)-X3(i-1+3,j-1+3))^2)/(2*(r^2))));
            end
        end
        Z(i,j)=sum;
    end
end
error=100*norm(Z-double(g),'fro')/normg;
subplot(338);imshow(uint8(Z)),title({'��Bilateral filter����s=10����r=0.1��', ['norm_F error= ', num2str(error)] })
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z=zeros(m,n);
for i=1:m
    for j=1:n
        kernel=zeros(3,3);
        for k=1:3
            for l=1:3
                kernel(k,l)=X(i-1+k,j-1+l);
            end
        end
        kernelmedian=median(kernel,'all');
        Z(i,j)=kernelmedian;
    end
end
error=100*norm(Z-double(g),'fro')/normg;
subplot(336);imshow(uint8(Z)),title({'��Median filter��', ['norm_F error= ', num2str(error)] })
