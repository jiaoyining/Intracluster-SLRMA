function par = ParSet(CLUSTER,STEP)
% patch and cluster parameter
%% parameter
par.patsize = STEP;%patch size(s*s)
par.Pstep = 1;%patch center step
%par.patnum  =10;               
par.NumOfCluster=CLUSTER;%cluster number
%par.step          =   floor((par.patsize-1));  
