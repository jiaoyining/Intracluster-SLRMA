function [X,row,col,band] = InputData_2D(index_of_database)
num=index_of_database;
%np = row * col
%% 1. Load HSI data
%%
%dataName = 'Urban64';
%data = load(['./data/',dataName,'.mat']); 
data_name={'jyn'};%
data_m=imread('./data/2D/jyn.jpg');
data_init=data_m;
[row,col,band]=size(data_init);% bands num
data=CovertTo2D(data_init);
X=data;
end