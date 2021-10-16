clc;clear all;close all;
Data = xlsread('Data for Question 2');
for line_ii = 1:1:size(Data,1)
    for line_jj = 1:1:size(Data,2)
        if isnan(Data(line_ii,line_jj)) == 1
            Data(line_ii,line_jj) = Data(line_ii-1,line_jj);
        end
    end
end
k_value = 5;
for Classification_ii = 1:1:size(Data,2)
    tic
    Classification_Matrix(:,Classification_ii) = k_means(Data(:,Classification_ii), k_value);
    T = toc;
    fprintf('第%d种污染物浓度的分类分析耗时为：%d\n',Classification_ii,T);
end
figure('color', [1 1 1]);
Title_Name = {'SO2','NO2','PM10','PM2.5','O3','CO','Temperature','Humidity','Air Pressure','The wind speed','Wind Direction'};
for Classification_ii = 1:1:size(Data,2)
    subplot(3,4,Classification_ii);
    Two_Demision(:,:,Classification_ii) = ones(1,2).*sqrt(Data(:,Classification_ii).^2./2);
    for Type_ii = 1:1:k_value
        Location_Judge = find(Classification_Matrix(:,Classification_ii)==Type_ii);
        x = Two_Demision(Location_Judge,1,Classification_ii);
        y =  Two_Demision(Location_Judge,2,Classification_ii);
        plot(x,y,'*');
        hold on
    end
    title([Title_Name{Classification_ii}],'FontSize',18,'FontName','Times New Roman');
    set(gca,'linewidth',2);
    if Classification_ii == 1
        h1 = legend('class 1','class 2','class 3','class 4','class 5');
        set(h1,'box','off','FontSize',18,'FontName','Times New Roman');
    end
    
end
for Classification_ii = 1:1:size(Data,2)
    Two_Demision(:,:,Classification_ii) = ones(1,2).*sqrt(Data(:,Classification_ii).^2./2);
    fprintf('%s下各类别污染物浓度的范围大小分别为: \n',Title_Name{Classification_ii});
    for Type_ii = 1:1:k_value
        Location_Judge = find(Classification_Matrix(:,Classification_ii)==Type_ii);
        Series = Data(Location_Judge,Classification_ii);
        fprintf('第%d类别下%s的浓度范围大小为：%.1f 至 %.1f ',Type_ii,Title_Name{Classification_ii},min(Series),max(Series));
        fprintf('\n');
    end
end
function [ output ] = k_means(data, k_value)
data_num = size(data, 1);
temp = randperm(data_num, k_value)';
center = data(temp, :);

iteration = 0;
while 1
    distance = euclidean_distance(data, center);
    [~, index] = sort(distance, 2, 'ascend');
    
    center_new = zeros(k_value, size(data, 2));
    for i = 1:k_value
        data_for_one_class = data(index(:, 1) == i, :);
        center_new(i,:) = mean(data_for_one_class, 1);
    end
    iteration = iteration + 1;
    %     (norm(center_new-center,1)/norm(center,1))
    if  ((norm(center_new-center,1)/norm(center,1))<1e-20)||(iteration > 5000)
        break;
    end
    
    center = center_new;
end

output = index(:, 1);

end
function [ output ] = euclidean_distance(data, center)
data_num = size(data, 1);
center_num = size(center, 1);
output = zeros(data_num, center_num);
for i = 1:center_num
    difference = data - repmat(center(i,:), data_num, 1);
    sum_of_squares = sum(difference .* difference, 2);
    output(:, i) = sum_of_squares;
end

end