function u=mg(x,xMF,uMF)
% f=mg(x,xMF,uMF)
% function to compute the membership grades of x on a T1 FS
% Dongrui WU (dongruiw@usc.edu), 3/24/2009
%
% xMF: x-coordinates of the T1 FS
% uMF: u-coordinates of the T1 FS; default to be [0 1 1 0]
% u: membership of x on the T1 FS
if nargin==2
    uMF=[0 1 1 0];
elseif length(xMF)~=length(uMF)
    error('xMF and uMF must have the same length.');
end

[xMF,index]=sort(xMF);
uMF=uMF(index);

u=zeros(size(x));
for i=1:length(x)
    if x(i)<=xMF(1) | x(i)>=xMF(end)
        u(i)=0;
    else
        left=find(xMF<x(i),1,'last');
        right=left+1;
        u(i)=uMF(left)+(uMF(right)-uMF(left))*(x(i)-xMF(left))/(xMF(right)-xMF(left));
    end
end
