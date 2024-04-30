function exp_data = construct_data(db_name)
% construct data
fprintf('starting construct %s database\n\n', db_name);

% split data to trainging and test
if strcmp(db_name, 'Cifar10-Gist512.mat')
    load ./datasets/Cifar10-Gist512.mat;
    X_class = X_class+1;
    db_data = X;
    db_label = zeros(size(db_data,1),10);
    for i=1:length(db_data)
        db_label(i,X_class(i)) = 1;
    end
    clear X;
    clear X_class;
end

train_data = db_data;

% Divide the test set
[n,d] = size(db_data);
rand('seed',0);
rowrank = randperm(n);
num_test = min(floor(n*0.1),1000);
num_training = n-num_test;
test_data = db_data(rowrank(1:num_test),:);
test_label = db_label(rowrank(1:num_test),:);
rowrank(1:num_test) = [];
train_data = db_data(rowrank,:);
train_label = db_label(rowrank,:);


XX = [train_data; test_data];
XX = double(XX);
exp_data.train_data = XX(1:num_training, :);
exp_data.test_data = XX(num_training+1:end, :);
exp_data.db_data = XX;
exp_data.train_label = train_label;
exp_data.test_label = test_label;
exp_data.train_data = train_data;

fprintf('constructing %s database has finished\n\n', db_name);
