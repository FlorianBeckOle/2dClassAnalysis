function  preProcess()


%% exp 
path2Class='../../Select/selectGood3/class_averages.mrcs';
v=tom_mrcread(path2Class); v=v.Value;
ref=tom_mrcread('ref.mrc'); ref=ref.Value;
[p.avg,p.stackAlg,p.algParam]=tom_os3_alignStack3(v,0.96,ref,0,'2-halfsets');
mkdir algStacks
save('algStacks/expAlgParam.mat','p');
tom_mrcwrite(p.stackAlg,'name','algStacks/expStackAlg.mrc');


%%
