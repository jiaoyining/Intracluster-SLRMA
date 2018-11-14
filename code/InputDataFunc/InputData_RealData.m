function [X,row,col,band] = InputData_RealData(index_of_database)
num=index_of_database;
%np = row * col
%% 1. Load HSI data
%%
%dataName = 'Urban64';
%data = load(['./data/',dataName,'.mat']); 
data_name={'Indiana';'Urban'};%
data_m=load(['./data/real data/',data_name{num},'.mat']);
data_init=(data_m.data);
[row,col,band]=size(data_init);% bands num
data=CovertTo2D(data_init);
X=data;
end

