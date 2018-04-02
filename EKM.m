function y = EKM(xPoint,wLower,wUpper,maxFlag)

%
% y = EKM(xPoint,wLower,wUpper,maxFlag)
%
% function to implement the EKM algorithms
%
% D. Wu and J. M. Mendel, "Enhance Karnik-Mendel Algorithms," IEEE Trans.
% on Fuzzy Systems, 2009.
%
% J. M. Mendel and Dongrui Wu, Perceptual Computing: Aiding People in Making Subjective Judgments, 
% Wiley-IEEE Press, 2010.
%
% Dongrui WU (dongruiw@usc.edu), 4/19/2009
%
% xPoint: x_i
% [wLower, wUpper]: range of w_i
% maxFlag: 1, if to output the maximum; -1, if to output the minimum
% xPoint, wLower and wUpper must have the same length.

if max(wUpper)==0 | max(xPoint)==0
    y=0; return
end

if max(wLower)==0
    if maxFlag>0
        y=max(xPoint);
    else
        y=min(xPoint);
    end
    return;
end

if length(xPoint)==1
    y=xPoint;
    return;
end

% combine zero firing intervals
I=find(wUpper==0);
xPoint(I)=[];
wLower(I)=[];
wUpper(I)=[];

% combine zero xs
[xSort,xIndex] = sort(xPoint);
lowerSort = wLower(xIndex);
upperSort = wUpper(xIndex);
k=find(xSort==0,1,'last');
if k>1
    xSort(1)=0;
    xSort(2:k)=[];
    lowerSort(1)=sum(lowerSort(1:k));
    lowerSort(2:k)=[];
    upperSort(1)=sum(upperSort(1:k));
    upperSort(2:k)=[];
end

% Change column vector into row vector
if size(xSort,1)>1
    xSort=xSort';
end
if size(lowerSort,1)>1
    lowerSort=lowerSort';
end
if size(upperSort,1)>1
    upperSort=upperSort';
end

ly=length(xSort);
if maxFlag<0
    k=round(ly/2.4);
    temp=[upperSort(1:k) lowerSort(k+1:ly)];
else
    k=round(ly/1.7);
    temp=[lowerSort(1:k) upperSort(k+1:ly)];
end
a=sum(temp.*xSort);
b=sum(temp);
y = a/b;
kNew = find(xSort > y,1)-1;

while k~=kNew
    mink=min(k,kNew);
    maxk=max(k,kNew);
    temp=upperSort(mink+1:maxk)-lowerSort(mink+1:maxk);
    b=b-sign(kNew-k)*sign(maxFlag)*sum(temp);
    a=a-sign(kNew-k)*sign(maxFlag)*sum(temp.*xSort(mink+1:maxk));
    y = a/b;
    k=kNew;
    kNew = find(xSort>y,1)-1;
end
