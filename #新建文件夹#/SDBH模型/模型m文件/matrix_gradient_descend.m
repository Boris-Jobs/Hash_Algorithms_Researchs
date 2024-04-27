clear; close all; 

data = load('ex1data1.txt');    %读取信息
X = data(:,1);
Y = data(:,2);
m = length(Y);
plot(X,Y,'rx','MarkerSize',5);

X = [ones(m,1) X];
theta = zeros(2,1);
alpha = 0.0001;
J = [];
itera = [];

%典型迭代方程     
for i = 1:3000
    diff = (X*theta - Y);
    error = (diff'* diff) / 2*m;
    J = [J 20*log10(error)];
    itera = [itera i];
    theta(2,1) = theta(2,1) - (alpha * ((diff'*X(:,2))/m));
    theta(1,1) = theta(1,1) - (alpha * ((diff'*X(:,1))/m));
end

hold on;
plot(X(:,2),X*theta,'-');
hold off;
figure;
plot(itera',J','x');
ylabel('dB')
xlabel('num of interation')
fprintf('theta1 is %f ,theta2 is %f,and the cost function is %f \n',theta(1),theta(2),error);