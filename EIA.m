
function [MF, nums, shape, FSL, FSR] = EIA(L,R)
%
% [MF, nums, shape, FSL, FSR] = EIA(L,R)
% Implements the Enhanced Interval Approach proposed in
% Simon Coupland, J. M. Mendel and Dongrui Wu, “Enhanced Interval Approach for Encoding Words into 
% Interval Type-2 Fuzzy Sets and Convergence of the Word FOUs,?IEEE World Congress on Computational 
% Intelligence, Barcelona, Spain, July 2010.
% Dongrui Wu, 5/2/2010
%
% L: left end-points of the intervals from survey
% R: right end-points of the intervals from survey
% MFs: MFs of the word model defined by 9 parameters
% nums: number of remaining intervals after each precessing steps
% shape: left-shoulder (1), interior (2), or right-shoulder (3). 
% FSL: left endpoints of the remaining embedded T1 FSs.
% FSR: right endpoints of the remaining embedded T1 FSs.

index=find(isnan(L)+isnan(R)); % remove incomplete data
L(index)=[];
R(index)=[];

%% Bad data processing, see Equation (1) in paper
for i=length(L):-1:1
    if L(i)<0 | L(i)>10 | R(i)<0 | R(i)>10 |  R(i)<=L(i) | R(i)-L(i)>=10
        L(i) = [];
        R(i) = [];
    end
end
nums=length(L); % n'

%% Outlier processing
intLeng = R-L;
left = sort(L);
right = sort(R);
leng = sort(intLeng);

NN1 = floor(nums * 0.25);
NN2 = floor(nums * 0.75);

% Compute Q(0.25), Q(0.75) and IQR for left-ends
QL25 = left(NN1)*(1-rem(0.25*nums,1)) + left(NN1+1)*rem(0.25*nums,1);
QL75 = left(NN2)*(1-rem(0.75*nums,1)) + left(NN2+1)*rem(0.75*nums,1);
LIQR = QL75 - QL25;

% Compute Q(0.25), Q(0.75) and IQR for right-ends.
QR25 = right(NN1)*(1-rem(0.25*nums,1)) + right(NN1+1)*rem(0.25*nums,1);
QR75 = right(NN2)*(1-rem(0.75*nums,1)) + right(NN2+1)*rem(0.75*nums,1);
RIQR = QR75 - QR25;

% outlier processing for L and R
for i=nums:-1:1
    if L(i)<QL25-1.5*LIQR | L(i)>QL75+1.5*LIQR | R(i)<QR25-1.5*RIQR | R(i)>QR75+1.5*RIQR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; % n''

% Compute Q(0.25), Q(0.75) and IQR for interval length.
NN1 = floor(n1 * 0.25);
NN2 = floor(n1 * 0.75);
QLeng25 = leng(NN1)*(1-rem(0.25*n1,1)) + leng(NN1+1)*rem(0.25*n1,1);
QLeng75 = leng(NN2)*(1-rem(0.75*n1,1)) + leng(NN2+1)*rem(0.75*n1,1);
lengIQR = QLeng75 - QLeng25;

% outlier processing for interval length
for i=n1:-1:1
    if intLeng(i)<QLeng25-1.5*lengIQR | intLeng(i)>QLeng75+1.5*lengIQR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; % m'

%% Tolerance limit processing, see Equation (3) in paper
meanL = mean(L);
stdL = std(L);
meanR = mean(R) ;
stdR = std(R);

K=[32.019 32.019 8.380 5.369 4.275 3.712 3.369 3.136 2.967 2.839...
    2.737 2.655 2.587 2.529 2.48 2.437 2.4 2.366 2.337 2.31...
    2.31 2.31 2.31 2.31 2.208];
k=K(min(n1,25));

%% Tolerance limit processing for L and R
for i=n1:-1:1
    if L(i)<meanL-k*stdL | L(i)>meanL + k*stdL | R(i)<meanR-k*stdR | R(i)>meanR + k*stdR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; % m+

%% Tolerance limit processing for interval length
meanLeng = mean(intLeng);
stdLeng = std(intLeng);
k=min([K(min(n1,25)),meanLeng/stdLeng,(10-meanLeng)/stdLeng]);
for i=n1:-1:1
    if  intLeng(i)<meanLeng-k*stdLeng | intLeng(i)>meanLeng + k*stdLeng
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; %m''

%% Reasonable interval processing, see Equation (4)-(6) in paper
meanL = mean(L);
stdL = std(L);
meanR = mean(R) ;
stdR = std(R);

% Determine sigma*
if stdL==stdR
    barrier = (meanL + meanR)/2;
elseif stdL==0
    barrier = meanL+0.01;
elseif stdR==0
    barrier = meanR-0.01;
else
    barrier1 =(meanR*stdL^2-meanL*stdR^2 + stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    barrier2 =(meanR*stdL^2-meanL*stdR^2 - stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    if  barrier1>=meanL & barrier1<=meanR
        barrier = barrier1;
    else
        barrier = barrier2;
    end
end

% Reasonable interval processing
for i=n1:-1:1
    if L(i)>=barrier | R(i)<= barrier | L(i)<2*meanL-barrier | R(i)>2*meanR-barrier
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n=length(L);
nums=[nums  n]; %m

%%  Admissible region determination
tTable=[6.314 2.920 2.353 2.132 2.015 1.943 1.895 1.860 1.833 1.812 1.796 1.782...
    1.771 1.761 1.753 1.746 1.740 1.734 1.729 1.725 1.721 1.717 1.714 1.711...
    1.708 1.706 1.703 1.701 1.699 1.697 1.684]; % alpha = 0.05;
tAlpha=tTable(min(n,31));
meanL = mean(L);
meanR = mean(R) ;
C = R - 5.831*L;
D = R - 0.171*L - 8.29;
shift1 = tAlpha * std(C)/sqrt(n);
shift2 = tAlpha * std(D)/sqrt(n);
FSL=zeros(1,n);
FSR=zeros(1,n);

% Establish nature of FOU, see Equation (19) in paper
if meanR>5.831*meanL-shift1 & meanR<.171*meanL+8.29-shift2
    for i=n:-1:1
        % left shoulder embedded T1 FS
        FSL(i) = 0.5*(L(i)+R(i)) - (R(i)-L(i))/sqrt(6);
        FSR(i) = 0.5*(L(i)+R(i)) + sqrt(6)*(R(i)-L(i))/3;

        % Delete inadmissible T1 FSs
        if FSL(i)<0 | FSR(i)>10
            FSL(i)=[];
            FSR(i)=[];
        end
    end
    % Compute the mathematical model for FOU(A~)
    UMF =[0,  0, max(FSL), max(FSR)];
    LMF = [0, 0, min(FSL), min(FSR), 1];
    shape=1;
elseif  meanR<5.831*meanL-shift1 & meanR>.171*meanL+8.29-shift2
    for i=n:-1:1
        % right shoulder embedded T1 FS
        FSL(i) = 0.5*(L(i)+R(i)) - sqrt(6)*(R(i)-L(i))/3;
        FSR(i) = 0.5*(L(i)+R(i)) + (R(i)-L(i))/sqrt(6);
        % Delete inadmissible T1 FSs
        if FSL(i)<0 | FSR(i)>10
            FSL(i)=[];
            FSR(i)=[];
        end
    end
    % Compute the mathematical model for FOU(A~)
    UMF =[min(FSL), min(FSR), 10, 10];
    LMF = [max(FSL), max(FSR), 10, 10, 1];
    shape=3;
else
    for i=n:-1:1
        %% internal embedded T1 FS
        FSL(i) = 0.5*(L(i)+R(i)) - sqrt(2)*(R(i)-L(i))/2;
        FSR(i) = 0.5*(L(i)+R(i)) + sqrt(2)*(R(i)-L(i))/2;

        % Delete inadmissible T1 FSs
        if FSL(i)< 0 | FSR(i)>10
            FSL(i)= [];
            FSR(i)= [];
        end
    end
    FSC=(FSL+FSR)/2;
    % Compute the mathematical model for FOU(A~)
    L1 = min(FSL);
    [L2,indexL] = max(FSL);
    [R1,indexR] = min(FSR);
    R2 = max(FSR);
    C1 = min(FSC);
    C2 = max(FSC);

    n=length(FSL);
    hs=zeros(1,n*(n-1));
    for i=1:n
        hs((i-1)*n+[1:n])=(FSR(i)-FSL)./(FSR(i)-FSL+FSC-FSC(i));
    end
    [h,index]=min(hs);
    i=ceil(index/n);
    j=index-(i-1)*n;
    p=FSL(j)+h*(FSC(j)-FSL(j));
    UMF =[L1, C1, C2, R2];
    LMF = [L2, p, p, R1, h];
    shape=2;
end

MF=[UMF LMF];
nums=[nums length(FSL)]; %m*
