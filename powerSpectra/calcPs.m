function calcPs()

st=tom_mrcread('stack.mrcs');
szcut=[64 64];
mask=tom_spheremask(ones(64,64),31);
idx=find(mask==0);

parfor i=1:size(st.Value,3)
    tmp=tom_cut_out(tom_ps(st.Value(:,:,i)),'center',[128 128]);
    mea=mean(tmp(idx));
    stda=std(tmp(idx));
    tmp=(tmp-mea)./stda;
    ps(:,:,i)=tmp;
   
end
tom_mrcwrite(ps,'name','ps.mrcs');


%ps=tom_mrcread('stackPs.mrc'); ps=ps.Value;
% [p.avg,p.stackAlg,p.algParam]=tom_os3_alignStack3(ps,1.86,2,0,8);
