clear

A=normrnd(0,1/200,200,500);%A����200*500
X=normrnd(0,10,500,1); X=abs(X);%X�ĳ�ʼ������ԭʼ�źţ�500*1

s=5;%����Ԫ�ؼ�������
a=randperm(500);%��1~500��������
ss=a(1:500-s);%����Ԫ��λ��(������ɷ���Ԫ�ص�λ���±�)

for i=1:500 %X��ϡ�軯
    for j=1:500-s
        if i==ss(j)
            X(i,1)=0;
        end
    end
end
observed=A*X; %�۲�ֵ

mu=50;
lamda=0.0001;
x_0=zeros(500,1);
m=floor(length(observed)*((500-s)/500));

for l=1:m
    x_2=x_0+mu*A'*(observed-A*x_0);
    for i=1:500
        if (x_2(i,1)<lamda)
            x_2(i,1)=0;
        end
    end     
    x_0=x_2;
end



