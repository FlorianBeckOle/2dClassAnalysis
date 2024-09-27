function genProjLib()


v=tom_mrcread('algStacks/EMDB31420P096.mrc'); v=v.Value;
v=tom_rescale(v,[256 256 256]);
sp=tom_spheremask(ones(256,256,256),118,6);
% cyl=tom_cylindermask(ones(256,256,256),95,6);
% cylI=tom_cylindermask(ones(256,256,256),49);
% m=cyl.*sp;
% mI=tom_spheremask(ones(256,256,256),45);
% v=tom_norm(v,'mean0+1std',mI);
% v=v.*m;
% v=tom_norm(v,'mean0+1std',(cylI==0).*(cyl));
% cylI=tom_cylindermask(ones(256,256,256),49);
% v=v.*tom_filter((cylI==0),3).*cyl;
m=tom_filter(v,5)>0.055; 
v=tom_norm(v,'mean0+1std',m);
%m=tom_filter(m,2)>0.1;
m=tom_filter(m,7);
v=v.*m.*sp;

angles=tom_av2_equal_angular_spacing([58 90],[0 180],8,'spider');
for i=1:size(angles,1)
    vr=tom_rotate(v,[angles(i,1) 0 angles(i,2)]);
    pst(:,:,i)=tom_norm(tom_rotate(sum(vr,3),90),'mean0+1std');
    disp([num2str(i) ' of ' num2str(size(angles,1))]);
end
tom_mrcwrite(pst,'name','algStacks/EMDB31420P096Lib.mrc')


v=tom_mrcread('algStacks/avg.mrc'); v=v.Value;
v=tom_rescale(v,[256 256 256]);


angles=tom_av2_equal_angular_spacing([58 90],[0 180],8,'spider');
for i=1:size(angles,1)
    vr=tom_rotate(v,[angles(i,1) 0 angles(i,2)]);
    pst(:,:,i)=tom_norm(tom_rotate(sum(vr,3),90),'mean0+1std');
    disp([num2str(i) ' of ' num2str(size(angles,1))]);
end
tom_mrcwrite(pst,'name','algStacks/avgLib.mrc')



disp(' ');