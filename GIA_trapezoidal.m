clc;clear all;close all;
[a,words]=xlsread('Book1.xls');
words=words(1,1:2:end);
[row,col]=size(a);  
for i=1:32
    l=a(1:row,2*i-1);r=a(1:row,2*i);
    [MFsEIA(i,:),numEIA(i,:),shapeEIA(i),FSL,FSR]=EIA(l,r);
    %Cs(i)=centroidIT2(MFsEIA(i,:));
end
%MFsEIA=MFsEIA(index,:);words2=words;words2=words2(index);
for j=90:90
    for i=1:1
        l=a(1:row,2*i-1);r=a(1:row,2*i);
        [l,r]=yuchuli(l,r);
        [MFsIA(i,:),fla(i),k(i)]=IA2(l,r,j/100);
    end
    %MFsIA=MFsIA(index,:);
end
for i=1:32
     subplot(8,6,2*floor((i-1)/4)+i);
     %figure;
     %if fla(i)>0
     plotIT2(MFsEIA(i,:));
     %end
     hold on
     %plot(MFsEIA(i,[1:4 8:-1:5]),[0 1 1 0 0 MFsEIA(i,[9 9]) 0],'--k','linewidth',1);
     title(words(i),'fontsize',9);
     set(gca,'YTick',[]);
     set(gca,'XTick',[]);
     axis([0 10 0 1]);
 end