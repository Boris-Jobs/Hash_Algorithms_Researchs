clear; close
%�����е��������ݾ�������á�d*n�������ݴ�С��dΪ���ȣ�nΪ���ݸ���
%mΪ�������ݸ���
%XΪѵ�����ݣ�YΪѵ����ǩ��XtΪ�������ݣ�YtΪ���Ա�ǩ
%AΪ��ϣ������WΪͶӰ����BΪѵ����ϣ�룬BtΪ���Թ�ϣ�룬BcΪת�����ƺ�Ĺ�ϣ��
dataset='cifar_10_gist.mat';
load(['C:\Users\13225\Desktop\major\SRTPģ��\ģ��m�ļ�\testbed\',dataset]);
traindata = double(traindata);%ԭʼ���ݼ���n*p����n=59000��p=512
testdata = double(testdata);%�������ݼ���n*d����m=1000��d=512



traingnd = traingnd - 1;%���б�ǩ��n*c����n=59000��c=1
testgnd = testgnd - 1;%���Ա�ǩ��m*c����m=1000��c=1


X_all = traindata';%��ԭʼѵ������ת��
X_selected=X_all(:,15001:30000);%����ʵ���X��С��p*n����p=512��n=ѡ������
Y_all = double(traingnd)';%��ԭʼ��ǩת��
Y_selected=Y_all(:,15001:30000);%����ʵ���Y��С��c*n����c=1��n=ѡ������
%ѡ���Y��С��c*n����c=1��n=ѡ������
Xt_all=testdata';%��ԭʼ��������ת��
Yt_all=double(testgnd)';%��ԭʼ���Ա�ǩת��

Xt_selected=Xt_all(:,1:500);%�������ݴ�С��p*m����p=512��m=ѡ������
Yt_selected=Yt_all(:,1:500);%���Ա�ǩ��c*m����c=1��m=ѡ������

%��ȡģ�����ɵĹ�ϣ��Ȳ�������a1Ϊÿ�ε�����ģ����ֵ��С���ɵ����飩
[W, B_model, L, S , Y, Y1, a1] = RobustPCA(X_selected, Y_selected);
%��ȡ��ͨ��ϣ�������ɵĹ�ϣ���ͶӰ����
[B_normal, W1]=leastsquare(X_selected);



%����ģ�����ɹ�ϣ���mAP��
A=(X_selected*X_selected')^-1*X_selected*B_model';
%ģ�͹�ϣ��������A��p*l����A^T��l*p��
B_model=(B_model+1)/2;
Bt_model=(sign(A'*Xt_selected)+1)/2;%��ģ�͹�ϣ�Ĳ������ݹ�ϣ����0��1
%A^TX�Ĵ�С��Bһ����l*n��
Bc_model=compactbit(B_model')';
Btc_model=compactbit(Bt_model')';
Dh1=hammingDist(Bc_model',Btc_model');
[~,HammingRank1]=sort((Dh1'),1);
ap1=cal_map(Y_selected',Yt_selected', Dh1);



%������С�������ɹ�ϣ���mAP��
A=(X_selected*X_selected')^-1*X_selected*B_normal';
%ģ�͹�ϣ��������A��p*l����A^T��l*p��
B_normal=(B_normal+1)/2;
Bt_normal=(sign(A'*Xt_selected)+1)/2;%��ģ�͹�ϣ�Ĳ������ݹ�ϣ����0��1
%A^TX�Ĵ�С��Bһ����l*n��
Bc_normal=compactbit(B_normal')';
Btc_normal=compactbit(Bt_normal')';
Dh2=hammingDist(Bc_normal',Btc_normal') ;%����������ȫ��������255��������
[~,HammingRank2]=sort((Dh2'),1);
ap2=cal_map(Y_selected',Yt_selected', Dh2);


%1.��ģ�͡��������ġ���һ��ģ�ͣ���С���ˡ�����RPCAԪ�ء�RPCA��ζ��ʲô��M��H�ıȽϣ�
%1.��ģ�͡�Z��S��L���ݶ��½���⣨���ܡ�С��è��

%2.��ʵ�顿����ͬ��ϣ�볤�ȣ�32bit��64bit��96bit��mapֵ��ģ����ֵͼ�񣨴�Ҫ��
%2.��ʵ�顿����С���ˡ�LSH��SH��SCDH�������Ī��
%2.��ʵ�顿���Բ�ͬ���ݼ��ڹ�ϣ�ı��֣�Ī��








