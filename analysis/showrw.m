clear
clc
prefix = {'/home/user/dlvo/test_rw1_'};
num = [0:100];
R = 5;
for i=1:numel(num)
    name = strcat(prefix,num2str(num(i),'%04d'),'.h5');
    nx = double(h5read(char(name),'/Nx'));
    ny = double(h5read(char(name),'/Ny'));
    rp = h5read(char(name),'/RWPposition');
    rpad = h5read(char(name),'/RWPIsAD');
    p = h5read(char(name),'/Pposition');
    pad = h5read(char(name),'/PAD');
    np = numel(p)/6;
    
    ppad = pad(1:np);
    gpad = pad(np+1:end);
    Pad = ppad+gpad;
    PT(i,1) = Pad(1);
    px = p(1:3:3*np-2);
    gpx = p(3*np+1:3:end-2);
    gpy = p(3*np+2:3:end-1);
    py = p(2:3:3*np-1);
    rpx = rp(1:3:end-2);
    rpy = rp(2:3:end-1);
    RR = zeros(np,1)+R;
    viscircles([px,py],RR,'Color','b');
    hold on
    viscircles([gpx,gpy],RR,'Color','b');
    kkk1 = find(rpad<0);
    kkk2 = find(rpad>0);
    ADN(i,1) = numel(kkk2);
    plot(rpx(kkk1),rpy(kkk1),'k.');
    plot(rpx(kkk2),rpy(kkk2),'r.');
    axis equal
    plot([0 0], [0 ny-1],'g')
    plot([-1 -1], [0 ny-1],'g--')
    plot([nx-1,nx-1],[0 ny-1],'g')
    plot([nx,nx],[0 ny-1],'g--')
    xlim([-R nx+R])
    drawnow
%     fn = strcat(num2str(i),'.jpg');
%     saveas(gcf,char(fn))
    clf
end
figure
plot(ADN)
figure
plot(PT)