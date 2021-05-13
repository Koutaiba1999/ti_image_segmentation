function [ seuil ] = otsu( img_n )
%OTSU Summary of this function goes here
%   Detailed explanation goes here

[N,M]=size(img_n);
hs=imhist(img_n);
v_w=zeros(256,1);
p=hs/(N*M);
for t=1:256
    q1=0; q2=0; m1=0; m2=0; v1=0; v2=0;
    %First région
    for i=1:t 
        q1=q1+p(i);    
    end
    for i=1:t
        m1=m1+i*p(i);
    end
    m1=m1/q1;
    for i=1:t
        v1=v1+((i-m1)^2)*p(i);
    end
    v1=v1/q1;%variance de la première région
    
    %2nd région
    for i=t+1:255 
        q2=q2+p(i);    
    end
    for i=t+1:255  
        m2=m2+i*p(i);
    end
    m2=m2/q2;
    for i=t+1:255
        v2=v2+((i-m2)^2)*p(i);
    end
    v2=v2/q2;
   v_w(t)=q1*v1+q2*v2;
end
[s,seuil] = min(v_w);