function analyse2dDiameter()


pixS=1.86;
genScaleBar([80 25],[256 256 100],'150Ang','output');
calcProfileAndDiamter('algStacks/expStackAlg.mrc',pixS,-1,'output/2dClass','2dClass');
calcProfileAndDiamter('algStacks/EMDB31420P096Lib.mrc',pixS,8,'output/31420','31420');
calcProfileAndDiamter('algStacks/avgLib.mrc',pixS,12,'output/17838','17838');



function calcProfileAndDiamter(stackName,pixS,filt2d,outFold,tag)

warning off; mkdir(outFold); warning on;

stackAlg=tom_mrcread(stackName);
if (filt2d>-1)
    stackAlg=tom_filter2resolution(stackAlg.Value,pixS,filt2d);
else
    stackAlg=stackAlg.Value;
end

mid=floor(size(stackAlg,1)/2)+1;

for i=1:size(stackAlg,3)
    img=stackAlg(:,:,i);
    prof(:,i)=sum(img,1);
    m=ones(size(img,1),1);
    mL=m; mL(mid:end)=0;
    mR=m; mR(1:(mid-1))=0;
    outerDiameter(i)=calcOuterDiameter(prof(:,i),mL,mR,pixS);
    innerDiameter(i)=calcInnerDiameter(prof(:,i),mL,mR,pixS);
end
pos=[530         -62        2201        1941 ];

figure; tom_dspcub(stackAlg); set(gcf,'Position',pos); saveas(gcf,[outFold filesep tag '-algStack.png']); close(gcf);
figure; surfc(prof); shading interp; view(90,90); set(gcf,'Position',pos);saveas(gcf,[outFold filesep tag '-surfProfiles.png']);close(gcf);
figure; plot(prof);set(gcf,'Position',pos);saveas(gcf,[outFold filesep tag '-Profiles.png']);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',50);
close(gcf);
%figure; histogram(outerDiameter,4);set(gcf,'Position',pos);saveas(gcf,[outFold filesep tag '-histogramOuterDiameter.png']);close(gcf);
%figure; histogram(innerDiameter); set(gcf,'Position',pos);saveas(gcf,[outFold filesep tag '-histogramInnerDiameter.png']);close(gcf);
figure; histogram(cat(1,innerDiameter,outerDiameter),100:2:330); set(gcf,'Position',pos);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',50);
saveas(gcf,[outFold filesep tag '-histogramInnerOuterDiameter.png']);
close(gcf);

figure; tom_imagesc(stackAlg(:,:,end-1)); set(gcf,'Position',pos); saveas(gcf,[outFold filesep tag '-algStackRep1.png']); close(gcf);

for i=1:size(stackAlg,3)
    img=stackAlg(:,:,i).*tom_spheremask(ones(256,256),120,8);
   
    tmp=tom_cut_out(tom_ps(img),'center',[64 64]);
    tmp(33,33)=0;
    imps(:,:,i)=tmp;
    impsl(:,:,i)=tom_norm(log(imps(:,:,i)+1),'mean0+1std');
end
g=tom_gallery(impsl,[10 10],[0 0],[0 0]);
figure;tom_imagesc(g,'range',[1 3]);set(gcf,'Position',pos); colormap hot;
saveas(gcf,[outFold filesep tag '-psStack.png']);close(gcf);
figure;tom_imagesc(impsl(:,:,end-1),'range',[1 3]);set(gcf,'Position',pos); colormap hot;
saveas(gcf,[outFold filesep tag '-psRep1.png']);close(gcf);


function genScaleBar(szBar,szimg,label,outFold)


img=zeros(szimg(1),szimg(2));
img(256-szBar(1):end,end-szBar(2):end)=1;
figure;tom_imagesc(img); 
stack=zeros(szimg);
stack(:,:,end)=img;
pos=[530         -62        2201        1941 ];
set(gcf,'Position',pos); saveas(gcf,[outFold filesep label '-image.png']); close(gcf);
figure; tom_dspcub(stack); set(gcf,'Position',pos); saveas(gcf,[outFold filesep label '-stack.png']); close(gcf);




function outerDiameter=calcOuterDiameter(prof,mL,mR,pixS)

[absMinLeft,posMinLeft]=min(prof.*mL);
[absMinRight,posMinRigth]=min(prof.*mR);
outerDiameter=(posMinRigth-posMinLeft)*pixS;


function innerDiameter=calcInnerDiameter(prof,mL,mR,pixS)

prof=tom_filter(prof,3);

[~,posMaxLeft]=max(prof.*mL);
crossLeft=tom_crossing(diff(prof.*mL));
idx=find(crossLeft>posMaxLeft);
posFminLeft=crossLeft(idx(1));

[~,posMaxRigth]=max(prof.*mR);
crossRight=tom_crossing(diff(prof.*mR));
%idx=find((crossRight-posMaxRigth)==-1)
idx=find(crossRight<posMaxRigth);
posFminRigh=crossRight(idx(end-1));

innerDiameter=(posFminRigh-posFminLeft)*pixS;


% figure; 
% plot(prof); hold on;
% plot(posFminRigh,prof(posFminRigh),'ro');
% plot(posFminLeft,prof(posFminLeft),'g+');
% hold off;
% disp(' ');

