clc; clear all;
clc; clear all;
fname='SDF';
dat1=load('Data/DDA_LSdata1.mat');
datDDA=dat1.A;
Time=dat1.Time;

StartT=50;
datSk1=[];
datSk2=[];
ij=1;
for kk=StartT:10:size(datDDA,3);
    
    PT1=datDDA(:,:,kk);
    PT2=mat2gray(PT1);

    k =(1:1:floor(min(size(PT2))/3))';
    [SK] = Circularly_averaged_Sk_raster(PT2,k);
    qmax=sum(SK(:,1).*SK(:,2))./sum(SK(:,2));
    datSk1(ij,1)=Time(kk);
    datSk1(ij,2)=qmax;
    datSk2(:,ij+1)=SK(:,2);
    
    ij=ij+1;
    
%     loglog(SK(:,1),SK(:,2),'-o');
%     hold on
end
datSk2(:,1)=SK(:,1);
dlmwrite(strcat('DDA','_Sk1.csv'),datSk1,'delimiter','\t');
dlmwrite(strcat('DDA','_Sk2.csv'),datSk2,'delimiter','\t');
%% ===
figure('Position', [10 10 600 500]);
hold on
FS=18;
x=logspace(1,5,50);
y=400.*x.^(-0.25);
% loglog(SK(:,1),SK(:,2),'-o')
plot(datSk1(:,1),datSk1(:,2),'-o');
plot(x,y,'--'); 
text(1000,100,'$q_{max}\propto t^{-0.25}$','fontsize',FS,'Interpreter','latex','rotation',-35);
text(20,20,'$q_{max}=\frac{\int qS(q)dq}{\int S(q)dq}$','fontsize',22,'Interpreter','latex','rotation',0);
box on;
box on;
yticks([10 20 50 100, 200])
ylim([10,200])
xlabel('time, $t$', 'fontsize',22,'Interpreter','latex')
ylabel('$q_{\rm max}$','fontsize',22,'Interpreter','latex')
set(gca,'xscale','log','yscale','log','linewidth',1,'fontsize',FS,'TickLength',[0.02 0.025]);
save2pdf('SK_law')

%% ===
figure('Position', [10 10 600 500]);
hold on; box on
for nplot=2:size(datSk2,2)
    loglog(datSk2(:,1),datSk2(:,nplot),'-o')
end
xlabel('wavenumber, $k$', 'fontsize',22,'Interpreter','latex')
ylabel('structure factor, $S(k)$','fontsize',22,'Interpreter','latex')
set(gca,'xscale','log','yscale','log','linewidth',1,'fontsize',FS,'TickLength',[0.02 0.025]);

