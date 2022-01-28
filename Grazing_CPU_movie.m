%%%
%Herbivore and plant pattern
%Copyright: Zhenpeng Ge, Quan-xing Liu, East China Normal University.
%Licence: MIT Licence
%
%Usage: run this m file to obtain the movie of pattern formation 
%%%

% Spatial setting
N = 256 ;
dx = 1 ;
dy = 1 ;
Lengthx = N*dx ;
Lengthy = N*dy ;

% Time setting
T = 1e6 ;
dt = 0.02 ;

% Operator
kernel = [0,1/(dx*dx),0;1/(dy*dy),-2/(dx*dx)-2/(dy*dy),1/(dy*dy);0,1/(dx*dx),0] ;
kernelx = [-1/(2*dx);0;1/(2*dx)] ;
kernely = [-1/(2*dy),0,1/(2*dy)] ;

% Parameter setting
kappa = 0.05 ;
D0 = 1 ; 
DP = 1 ; 
alpha = 6 ; 
beta = -3 ; 
lambda = 1 ; 
Hmass = 0.5 ;

% Initial condition
P = 1 - Hmass/lambda + 0.1*(rand(N)*2 - 1) ;
H = Hmass + 0.1*(rand(N)*2 - 1) ;

F1 = figure('position',[200 20 600 600]) ;
Videoname = ['Grazing_L' num2str(N) '_T' num2str(T)] ;
V1 = VideoWriter(Videoname) ; % 'MPEG-4' is only available on windows
V1.FrameRate = 30 ;
V1.Quality = 100 ;
open(V1) ;
for i = 1:T
    if rem(i - 1,1000) == 0
        figure(F1) ;
        subplot(1,2,1) ;
        imagesc(P) ;
        axis equal
        xlim([0 N]) ;
        ylim([0 N]) ;
        colorbar ; 
%         caxis([0,1]) ;
        title('Plant') ;
        subplot(1,2,2) ;
        imagesc(H) ;
        axis equal 
        xlim([0 N]) ;
        ylim([0 N]) ;
        colorbar ; 
%         caxis([0,1]) ;
        title('Herbivore') ;
        Frame = getframe(gcf) ;
        writeVideo(V1,Frame) ;
    end
    V = alpha*P.^2 + beta*P + 1 ;
    F = V.^2 ;
    G = V.*H.*(2*alpha*P + beta) ;
    J1X = F.*imfilter(H,kernelx,'circular') + G.*imfilter(P,kernelx,'circular') ;
    J1Y = F.*imfilter(H,kernely,'circular') + G.*imfilter(P,kernely,'circular') ;
    J2 = imfilter(H,kernel,'circular') ;
    Pi = lambda*(1 - P).*P - P.*H + DP*imfilter(P,kernel,'circular') ;
    PH(i) = sum(sum(P.*H)) ;
    J3X = D0*imfilter(J1X,kernelx,'circular') ;
    J3Y = D0*imfilter(J1Y,kernely,'circular') ;
    J4 = D0*kappa*imfilter(J2,kernel,'circular') ;
    Hi = J3X + J3Y - J4 ;
    P = P + dt*Pi ;
    H = H + dt*Hi ;
end
close(V1);