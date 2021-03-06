clear
clc
prefix = {'/home/user/dlvo/test_swi_rw1_'};
num = [0:999];
for i=1:numel(num)
    name = strcat(prefix,num2str(num(i),'%04d'),'.h5');
    nx = double(h5read(char(name),'/Nx'));
    ny = double(h5read(char(name),'/Ny'));
    Con = h5read(char(name),'/Con');
    con = reshape(Con,[nx,ny]);
    rp = h5read(char(name),'/RWPposition');
    rpad = h5read(char(name),'/RWPIsAD');
    p = h5read(char(name),'/Pposition');
    pad = h5read(char(name),'/PAD');
    Pr = h5read(char(name),'/PR');
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
    pr = Pr(1:np)-2;
    subplot(211)
    viscircles([px,py],pr,'Color','b');
    hold on
    gpr = Pr(np+1:end)-2;
    viscircles([gpx,gpy],gpr,'Color','b');
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
    xlim([-pr(1) nx+pr(1)])
    ylim([0 ny-1])
    subplot(212)
    pcolor(con')
    caxis([0 5])
    grid off
    shading interp
%     fig = gcf;
%     fig.PaperPosition = [0 0 1400 500];
    drawnow
    fn = strcat(num2str(i),'.jpg');
    saveas(gcf,char(fn))
%     pause(0.5)
    clf
end
% figure
% plot(ADN)