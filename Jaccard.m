function S=Jaccard(A,B)
N=200; % number of discretizations
minX=min(A(1),B(1)); % the range
maxX=max(A(4),B(4));
X=linspace(minX,maxX,N);

lowerA=mg(X,A(5:8),[0 A([9 9]) 0]);
upperA=mg(X,A(1:4));
lowerB=mg(X,B(5:8),[0 B([9 9]) 0]);
upperB=mg(X,B(1:4));

S=sum([min([upperA;upperB]), min([lowerA;lowerB])])/sum([max([upperA;upperB]), max([lowerA;lowerB])]);



