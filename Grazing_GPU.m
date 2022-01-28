function [DataP,DataH,Sampletime] = Grazing_GPU(Hmass,alpha)
% % % 
% Copyright: Zhenpeng Ge, Quan-xing Liu, East China Normal University.
% Licence: MIT Licence
% 
% Input:
% Hmass: a number, the spatial average density of herbivores.
% alpha: a number, the behavior coefficient.
% Output:
% DataP: a 3D matrix, storing data of herbivore density. The first two dimensions are space, and the last one is time. 
% DataH: a 3D matrix, storing data of plant density. The first two dimensions are space, and the last one is time. 
% Sampletime: a vector, storing sampling time point, and corresponding to the third dimension of DataP and DataH.
% % % 

%GPU seting
GPU = gpuDevice(1) ;
reset(GPU) 

% Grid setting
N = 1024 ;
dx = 1 ;
dy = 1 ;
Lengthx = N*dx ;
Lengthy = N*dy ;

% Time setting
T = 1e6 ;
dt = 0.02 ;

% Operator
kernel = gpuArray([0,1/(dx*dx),0;1/(dy*dy),-2/(dx*dx)-2/(dy*dy),1/(dy*dy);0,1/(dx*dx),0]) ;
kernelx = gpuArray([-1/(2*dx);0;1/(2*dx)]) ;
kernely = gpuArray([-1/(2*dy),0,1/(2*dy)]) ;

% Parameter setting
kappa = 0.05 ;
D0 = 1 ; 
DP = 1 ; 
% alpha = 4 ; 
beta = 0.1 ; 
lambda = 1 ; 
% Hmass = 0.65 ;

% Initial condition
P = 1 - Hmass/lambda + 0.01*(rand(N,'gpuArray')*2 - 1) ;
H = Hmass + 0.01*(rand(N,'gpuArray')*2 - 1) ;

% Record data
Record = 1:1e4:T ;
Sampletime = Record*dt ;
DataP = zeros(N,N,length(Record)) ;
DataH = zeros(N,N,length(Record)) ;

for i = 1:T
    V = alpha.*P.^2 + beta*P + 1 ;
    F = V.^2 ;
    G = V.*H.*(2*alpha.*P + beta) ;
    J1X = F.*imfilter(H,kernelx,'circular') + G.*imfilter(P,kernelx,'circular') ;
    J1Y = F.*imfilter(H,kernely,'circular') + G.*imfilter(P,kernely,'circular') ;
    J2 = imfilter(H,kernel,'circular') ;
    Pi = lambda*(1 - P).*P - P.*H + DP*imfilter(P,kernel,'circular') ;
    J3X = D0*imfilter(J1X,kernelx,'circular') ;
    J3Y = D0*imfilter(J1Y,kernely,'circular') ;
    J4 = D0*kappa*imfilter(J2,kernel,'circular') ;
    Hi = J3X + J3Y - J4 ;
    P = P + dt*Pi ;
    H = H + dt*Hi ;
    if ismember(i,Record) == 1
        disp(['Time steps' num2str(i)]) ;
        Index = find(Record == i) ;
        DataP(:,:,Index) = gather(P) ;
        DataH(:,:,Index) = gather(H) ;
    end
end
% Path = '/home/user/ModelResult/GrazingL512/' ;
% Filename = ['DataPH_L512_T1e7_H_0.68_alpha_'.mat'] ;
% save([Path Filename],'DataP','DataH','-v7.3') ;