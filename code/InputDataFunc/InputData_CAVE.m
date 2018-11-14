function [X0,m,n,nb] = InputData_CAVE(index_of_database)
num=index_of_database;
nb=31;% bands num
%np = row * col
%% 1. Load HSI data
%%
%dataName = 'Urban64';
%data = load(['./data/',dataName,'.mat']); 
data_name={'balloons';'beads';'cd';'chart_and_stuffed_toy';'clay';'cloth';
    'egyptian_statue';'face';'fake_and_real_beers';
'fake_and_real_food';'fake_and_real_lemon_slices';
'fake_and_real_lemons';'fake_and_real_peppers';'fake_and_real_strawberries';
'fake_and_real_sushi';'fake_and_real_tomatoes';'feathers';'flowers';'glass_tiles';
'hairs';'jelly_beans';'oil_painting';'paints';'photo_and_face';'pompoms';
'real_and_fake_apples';'real_and_fake_peppers';'sponges';'stuffed_toys';
'superballs';'thread_spools';'watercolors'};%
%for n=1:32
for i=1:31
if i<10
data_init=imread(['./data/complete_ms_data/',data_name{num},'_ms/',data_name{num},'_ms/',data_name{num},'_ms_0',num2str(i),'.png']);
else
data_init=imread(['./data/complete_ms_data/',data_name{num},'_ms/',data_name{num},'_ms/',data_name{num},'_ms_',num2str(i),'.png']);
end
[~,~,u]=size(data_init);
if u==3
data_init=rgb2gray(data_init);
end
[m,n]=size(data_init);
data_init=imresize(data_init,[m/2,n/2]);
[m,n]=size(data_init);
data_init=im2double(reshape(data_init,[1,m*n]));
data(i,:)=data_init;
end
X=data;
[mx,~] = size(X);
if mx <nb
    X(mx +1 : nb,:) = repmat(X(mx,:),nb - mx,1); % padding data
else
    X = X(1 : nb,:); 
end
X0 = X;
end


