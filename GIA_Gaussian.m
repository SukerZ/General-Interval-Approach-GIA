clc;clear all;close all;
[a,words]=xlsread('Book1.xls');
words=words(1,1:2:end);
[row,col]=size(a);  
%for i=1:32
    %l=a(1:row,2*i-1);r=a(1:row,2*i);
    %[MFsEIA(i,:),numEIA(i,:),shapeEIA(i),FSL,FSR]=EIA(l,r);
%end
for j=90:90
    for i=1:32
        l=a(1:row,2*i-1);r=a(1:row,2*i);
        [l,r]=yuchuli(l,r);
        [MFsIA(i,:),fla(i),k(i)]=IAgaosi2(l,r,j/100);
    end
    %MFsIA=MFsIA(index,:);
    %fla=fla(index,:);
end

for i=1:32
     subplot(8,6,2*floor((i-1)/4)+i);
     %plotIT2(MFsEIA(i,:));
 
ax=MFsIA(i,1);ad=MFsIA(i,2);cx=MFsIA(i,3);cd=MFsIA(i,4);
     dx=MFsIA(i,5);dd=MFsIA(i,6);
     %figure;
     if k(i)==3
         x1=linspace(0,ax,500);
         y1=exp(-(x1-ax).^2/(2*((ax-cx)/3)^2));
         plot(x1,y1,'color','k');hold on;
         x2=linspace(ad,10,500);
         y2=exp(-(x2-ad).^2/(2*((dd-ad)/3)^2));
         plot(x2,y2,'color','k');hold on;
         p=(ad*dx-ax*cd)/(-ax+ad-cd+dx);
         x3=linspace(0,p,500);
         y3=exp(-(x3-ad).^2/(2*((ad-cd)/3)^2));
         plot(x3,y3,'color','k');hold on;
         x4=linspace(p,10,500);
         y4=exp(-(x4-ax).^2/(2*((dx-ax)/3)^2));
         plot(x4,y4,'color','k');hold on;
         for j=0:0.05:ax
               for kk=0:0.02:1
                     if kk>exp(-(j-ad).^2/(2*((ad-cd)/3)^2))&kk<exp(-(j-ax).^2/(2*((ax-cx)/3)^2))
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
         for j=ax:0.05:p
               for kk=0:0.02:1
                     if kk>exp(-(j-ad).^2/(2*((ad-cd)/3)^2))&kk<1
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
         for j=p:0.05:ad
               for kk=0:0.02:1
                     if kk>exp(-(j-ax).^2/(2*((dx-ax)/3)^2))&kk<1
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
         for j=ad:0.05:10
               for kk=0:0.02:1
                     if kk>exp(-(j-ax).^2/(2*((dx-ax)/3)^2))&kk<exp(-(j-ad).^2/(2*((dd-ad)/3)^2))
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
     elseif k(i)==2
         x1=linspace(0,ax,1000);
         y1=exp(-(x1-ax).^2/(2*((ax-cx)/3)^2));
         plot(x1,y1,'color','k');hold on;
         x2=linspace(0,ad,1000);
         y2=exp(-(x2-ad).^2/(2*((ad-cd)/3)^2));
         plot(x2,y2,'color','k');hold on;
         line([ad 10],[1 1],'color','k');hold on;
         for j=0:0.05:ax
               for kk=0:0.02:1
                     if kk>exp(-(j-ad).^2/(2*((ad-cd)/3)^2))&kk<exp(-(j-ax).^2/(2*((ax-cx)/3)^2))
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
         for j=ax:0.05:ad
               for kk=0:0.02:1
                     if kk>exp(-(j-ad).^2/(2*((ad-cd)/3)^2))&kk<1
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
     else
         x1=linspace(ax,10,1000);
         y1=exp(-(x1-ax).^2/(2*((dx-ax)/3)^2));
         plot(x1,y1,'color','k');hold on;
         x2=linspace(ad,10,1000);
         y2=exp(-(x2-ad).^2/(2*((dd-ad)/3)^2));
         plot(x2,y2,'color','k');hold on;
         line([0 ax],[1 1],'color','k');hold on;
         for j=0:0.05:ad
               for kk=0:0.02:1
                     if kk>exp(-(j-ax).^2/(2*((dx-ax)/3)^2))&kk<1
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
         for j=ad:0.05:10
               for kk=0:0.02:1
                     if kk>exp(-(j-ax).^2/(2*((dx-ax)/3)^2))&kk<exp(-(j-ad).^2/(2*((dd-ad)/3)^2))
                         plot(j,kk,'color',[0.85 0.85 0.85]);hold on;
                     end
               end
         end
     end
     line([ax ad],[1 1],'color','k');hold on;
     %fill([x1,fliplr(x1)],[y1,fliplr(y2)],[150 150 150]/255);
     %plot(MFsEIA(i,[1:4 8:-1:5]),[0 1 1 0 0 MFsEIA(i,[9 9]) 0],'--k','linewidth',1);
     title(words(i),'fontsize',9);
     set(gca,'YTick',[]);
     set(gca,'XTick',[]);
     axis([0 10 0 1]);
end