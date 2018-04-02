function [MF,fla,k]=IA2(L,R,u)
k=0;
n=length(L);
if n<1
    fla=0
    MF=[0 0 0 0 0 0 0 0 0]
    return
end
tTable=[6.314 2.920 2.353 2.132 2.015 1.943 1.895 1.860 1.833 1.812 1.796 1.782 1.771 1.761 1.753 1.746 1.740 1.734 1.729 1.725 1.721 1.717 1.714 1.711 1.708 1.706 1.703 1.701 1.699 1.697 1.684];%alpha=0.05;
tAlpha=tTable(min(n,31));
meanL=mean(L);meanR=mean(R);
u2=(u+1)/2;
C=R-(sqrt(6)/2/norminv(u2)+0.5)/(sqrt(6)/2/norminv(u2)-0.5)*L;D=R-((sqrt(6)/2/norminv(u2)-0.5)/(sqrt(6)/2/norminv(u2)+0.5)*L+10/(sqrt(6)/2/norminv(u2)+0.5));
shift1=tAlpha*std(C)/sqrt(n);shift2=tAlpha*std(D)/sqrt(n);
FSL=zeros(1,n);FSR=zeros(1,n);
if meanR>(sqrt(6)/2/norminv(u2)+0.5)/(sqrt(6)/2/norminv(u2)-0.5)*meanL-shift1&meanR<((sqrt(6)/2/norminv(u2)-0.5)/(sqrt(6)/2/norminv(u2)+0.5)*L+10/(sqrt(6)/2/norminv(u2)+0.5))
    for i=n:-1:1
        FSL(i)=0.5*(L(i)+R(i))-sqrt(2)*(R(i)-L(i))/2/norminv(u2);
        FSR(i)=0.5*(L(i)+R(i))+2*sqrt(2)*(R(i)-L(i))/2/norminv(u2);
        if FSL(i)<0|FSR(i)>10
            FSL(i)=[];FSR(i)=[];
        end
    end
    UMF =[0,  0, max(FSL), max(FSR)];
    LMF = [0, 0, min(FSL), min(FSR), 1];
    %fprintf('%f %f\n',min(FSL),max(FSR))
elseif  meanR<(sqrt(6)/2/norminv(u2)+0.5)/(sqrt(6)/2/norminv(u2)-0.5)*meanL-shift1&meanR>((sqrt(6)/2/norminv(u2)-0.5)/(sqrt(6)/2/norminv(u2)+0.5)*L+10/(sqrt(6)/2/norminv(u2)+0.5))-shift2
    for i=n:-1:1
        FSL(i)=0.5*(L(i)+R(i))-2*sqrt(2)*(R(i)-L(i))/2/norminv(u2);
        FSR(i)=0.5*(L(i)+R(i))+sqrt(2)*(R(i)-L(i))/2/norminv(u2);
        if FSL(i)<0|FSR(i)>10
            FSL(i)=[];FSR(i)=[];
        end
    end
    UMF =[min(FSL), min(FSR), 10, 10];
    LMF = [max(FSL), max(FSR), 10, 10, 1];
    %fprintf('%f %f\n',min(FSL),max(FSR))
else
    for i=n:-1:1
        FSL(i)=0.5*(L(i)+R(i))-sqrt(6)*(R(i)-L(i))/2/norminv(u2);
        FSR(i)=0.5*(L(i)+R(i))+sqrt(6)*(R(i)-L(i))/2/norminv(u2);
        if FSL(i)<0|FSR(i)>10
            FSL(i)=[];FSR(i)=[];
        end
    end
    FSC=(FSL+FSR)/2;
    % Compute the mathematical model for FOU(A~)
    L1 = min(FSL);
    [L2,indexL]=max(FSL);[R1,indexR]=min(FSR);
    R2 = max(FSR);C1 = min(FSC);C2 = max(FSC);
    n=length(FSL);
    hs=zeros(1,n*(n-1));
    for i=1:n
        hs((i-1)*n+[1:n])=(FSR(i)-FSL)./(FSR(i)-FSL+FSC-FSC(i));
    end
    [h,index]=min(hs);
    i=ceil(index/n);
    j=index-(i-1)*n;
    if length(h)<1
    p=0;fla=0;    
    else
    p=FSL(j)+h*(FSC(j)-FSL(j));
    end
    if L2>R1
        tmp=L2;L2=R1;R1=tmp;
    end
    UMF =[L1, C1, C2, R2];
    LMF = [L2, p, p, R1, h];
    %fprintf('%f %f\n',min(FSL),max(FSR))
end
MF=[UMF LMF];
if length(FSL)<1
    fla=0;MF=[0 0 0 0 0 0 0 0 0];
else
    fla=1;
end