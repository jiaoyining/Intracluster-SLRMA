function [L]=ClusterTo3D(rX_Saver,GrouPatch,lenSel,par,rzSize,sizeLi,MEM)
% recconstruct the estimated HSI by aggregating all reconstructed patch groups.
patchsize=par.patsize^2;
Li=cell(lenSel);
for i=1:lenSel
     F=GrouPatch{i};
     Li{i}=CovertTo3D(F',patchsize,rzSize(3));
end
     Epatch          = zeros(sizeLi);
     W               = zeros(sizeLi(1),sizeLi(3));
     for i = 1:lenSel
         Epatch(:,:,MEM{i})  = Epatch(:,:,MEM{i}) + Li{i};
         W(:,MEM{i})         = W(:,MEM{i})+ones(size(Li{i},1),size(Li{i},3));
     end
     [L, ~]  =  Patch2Im3D(rX_Saver, Epatch, W, par, rzSize);              
  
     % end of Qian Zhao 
end



