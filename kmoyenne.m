%algorithme des K moyennes
function [imseg] =kmoyenne(im,nc)
%function [imseg,ccl] =kmoyenne(im,nc)

%im est l'image à segmenter
%nc est le nombre de classe (ici nc=2)

%--------------------- Initialisation-------------------------------


[r,c]=size(im);
d=zeros(r*c,nc);  %ce vecteur sert à calculer les distances de tous les points de l'image des centres des clusters
v=zeros(1,nc);    %v est un vecteur de taille 1xnc contient les valeurs des centres des clusters
x=zeros(1,r*c);   %l'image initiale qui est une matrice de taille rxc sera stockée dans le vecteur x de taille 1xrc
for t=1:c
    x(r*(t-1)+1:r*t)=im(:,t);
end;
%randn('seed',0);
u=0.1*randn(r*c,nc); %u est la partition 0
u=u-mean2(u); 
N=norm(u);


iter=0;
while N>0.0001
   %----------------------------- Calcul des centres de classes-------------------  
    for i=1:nc
        v(i)=x*(u(:,i).^2)./sum(u(:,i).^2);
    end;
%     disp(['les valeurs des centroides: c(1)=',num2str(v(1)),'    c(2)=',num2str(v(2))])
   %---------------------Mise à jour des partitions U-------------

   %--------------------Calcul des distances euclidiennes ---------
   for i=1:nc
       d(:,i)=abs(x'-v(i));
   end;
   
  %--------------------Calcul de la matrice de partition U------------------
  
    s=u;
    u=zeros(r*c,nc);
    for i=1:r*c
        if d(i,1)<d(i,2)
           u(i,1)=1;
        else 
           u(i,2)=1;
        end;
     end 
  %---------------Construction de la matrice de l'image segmentée------------  
   ims=zeros(r,c);
    for i=1:r
        for j=1:c
            for k=1:nc
                 if u((j-1)*r+i,k)==1
                    ims(i,j)=k;
                end;
            end;
        end;
    end;
    %binarisation de l'image
    ims=2-ims;
    imseg=ims;
    %cc1(1)=v(1);
    %cc1(2)=v(2);
  
  
  N=norm(s-u);
  iter=iter+1;
end;


 end