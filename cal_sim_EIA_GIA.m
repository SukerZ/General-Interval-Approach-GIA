clc;clear all;close all;
[a,words]=xlsread('Book1.xls');
words=words(1,1:2:end);
[row,col]=size(a);  
for i=1:32
    l=a(1:row,2*i-1);r=a(1:row,2*i);
    [MFsEIA(i,:),numEIA(i,:),shapeEIA(i),FSL,FSR]=EIA(l,r);
    [l,r]=yuchuli(l,r);
    [MFsIA(i,:),fla(i),k(i)]=IA2(l,r,97/100);
    fprintf('%s %f\n',words{i},Jaccard(MFsEIA(i,:),MFsIA(i,:)));
end  