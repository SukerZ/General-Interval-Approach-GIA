function [MF,fla,k]=IAgaosi2(L,R,u)
n=length(L);
tTable=[6.314 2.920 2.353 2.132 2.015 1.943 1.895 1.860 1.833 1.812 1.796 1.782 1.771 1.761 1.753 1.746 1.740 1.734 1.729 1.725 1.721 1.717 1.714 1.711 1.708 1.706 1.703 1.701 1.699 1.697 1.684];%alpha=0.05;
tAlpha=tTable(min(n,31));
meanL=mean(L);meanR=mean(R);
u2=(u+1)/2;
C=R-(3/2/norminv(u2)+0.5)/(3/2/norminv(u2)-0.5)*L;D=R-(3/2/norminv(u2)-0.5)/(3/2/norminv(u2)+0.5)*L-10/(3/2/norminv(u2)+0.5);
shift1=tAlpha*std(C)/sqrt(n);shift2=tAlpha*std(D)/sqrt(n);
amf=zeros(1,n);bmf=zeros(1,n);
tmp1=(3/2/norminv(u2)+0.5)/(3/2/norminv(u2)-0.5)*meanL-shift1;
tmp2=(3/2/norminv(u2)-0.5)/(3/2/norminv(u2)+0.5)*meanL+10/(3/2/norminv(u2)+0.5)-shift2;
fprintf('%f %f %f\n',meanR,tmp1,tmp2);
if meanR<(3/2/norminv(u2)+0.5)/(3/2/norminv(u2)-0.5)*meanL-shift1&meanR>(3/2/norminv(u2)-0.5)/(3/2/norminv(u2)+0.5)*meanL+10/(3/2/norminv(u2)+0.5)-shift2
    for i=n:-1:1
        amf(i)=(L(i)+R(i))/2+1/2*sqrt(2/(pi-2))*(R(i)-L(i))/norminv(u2);
        bmf(i)=(R(i)-L(i))/norminv(u2)/2/sqrt(1-2/pi);
        if amf(i)<0|amf(i)>10|amf(i)-3*bmf(i)<0
            amf(i)=[];bmf(i)=[];
        end
    end
    k=2
elseif  meanR>(3/2/norminv(u2)+0.5)/(3/2/norminv(u2)-0.5)*meanL-shift1&meanR<(3/2/norminv(u2)-0.5)/(3/2/norminv(u2)+0.5)*meanL+10/(3/2/norminv(u2)+0.5)-shift2
    for i=n:-1:1
        amf(i)=(L(i)+R(i))/2-1/2*sqrt(2/(pi-2))*(R(i)-L(i))/norminv(u2);
        bmf(i)=(R(i)-L(i))/norminv(u2)/2/sqrt(1-2/pi);
        if amf(i)<0|amf(i)>10|amf(i)+3*bmf(i)>10;
            amf(i)=[];bmf(i)=[];
        end
    end
    k=1;
else
    for i=n:-1:1
        amf(i)=0.5*(L(i)+R(i));
        bmf(i)=(R(i)-L(i))/norminv(u2);
        if amf(i)<0|amf(i)>10|amf(i)-3*bmf(i)<0|amf(i)+3*bmf(i)>10
            amf(i)=[];bmf(i)=[];
        end
    end
    k=3;
end
if length(amf)<1
    fla=0;MF=[0 0 0 0 0 0];
else
    fla=1;
    cmf=amf-3*bmf;dmf=amf+3*bmf;
    amfx=min(amf);amfd=max(amf);cmfx=min(cmf);cmfd=max(cmf);
    dmfx=min(dmf);dmfd=max(dmf);
    MF=[min(amf) max(amf) min(cmf) max(cmf) min(dmf) max(dmf)];
end