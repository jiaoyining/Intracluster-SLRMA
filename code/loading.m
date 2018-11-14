
record_NLM3D = load(['./ResultData/',noise,'_',database,'_NLM3D_','.mat']);
record_BM4D = load(['./ResultData/',noise,'_',database,'_BM4D_','.mat']);
record_LRTA = load(['./ResultData/',noise,'_',database,'_LRTA_','.mat']);
record_PARAFAC= load(['./ResultData/',noise,'_',database,'_PARAFAC_','.mat']);
record_TENSORDL= load(['./ResultData/',noise,'_',database,'_TENSORDL_','.mat']);
record_YING= load(['./ResultData/',noise,'_',database,'_YING_','.mat']);
record_CMESSC =load(['./ResultData/',noise,'_',database,'_CMESSC_','.mat']);
record_OURS = load(['./ResultData/',noise,'_',database,'_OURS_','.mat']);
record_MEAN= load(['./ResultData/',noise,'_',database,'_MEAN_','.mat']);
record_NLM3D = record_NLM3D.record_NLM3D ;
record_BM4D =record_BM4D.record_BM4D;
record_LRTA =record_LRTA.record_LRTA ;
record_PARAFAC=record_PARAFAC.record_PARAFAC;
record_TENSORDL=record_TENSORDL.record_TENSORDL;
record_YING= record_YING.record_YING;
record_CMESSC =record_CMESSC.record_CMESSC;
record_OURS =record_OURS.record_OURS;
record_MEAN=record_MEAN.record_MEAN;

