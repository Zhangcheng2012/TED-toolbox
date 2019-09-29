function plot_fully_sampled_examples(FullKspace,dT_Gold,PARAMS)

% ---------------- display magnitude & temperature (phase) examples ---------------------
% show full-FOV magnitude example for time frame #1
SOS = zeros(PARAMS.N,PARAMS.N);
for nc = 1:PARAMS.NC
    im = ifft2c(squeeze(FullKspace(:,:,1,nc)));
    SOS = SOS + im.^2;
end
SOS = sqrt(SOS);

switch PARAMS.scanner_vendor
    case 'Philips'
        % here we make a simple correction to the data due to the built-in
        % setup of Philips scanners, which produces data that is inherently
        % fftshift-ed along one dimension (not two!).
        SOS = fftshift(SOS,2);
end
figure; imagesc(abs(SOS)); colormap gray; axis image; %title('magnitude, t=18, coil #1')
axis off;
caxis([0 PARAMS.mag_max]);
title('Magnitude image; Time frame #1')

% -------------------------   show full-FOV temperature   -----------------------------------

dT_Gold_t_example = squeeze(dT_Gold(:,:,PARAMS.t_example));
dT_Gold_t_example(dT_Gold_t_example<0)=0; % null pixels with negative temp change for a fair comparison with the k-space method
figure; imagesc(dT_Gold_t_example); axis image; colormap jet;
caxis([PARAMS.cmin PARAMS.cmax]);
c = colorbar;
c.Label.String = '[^oC]';
axis off;
title(['Gold Standard \DeltaT',num2str(PARAMS.t_example),' = T(t=',num2str(PARAMS.t_example),') - T(t=1) [^oC]']); colorbar


% -------------- plot gold standard dT for several sonications (t<=24) -------------
% figure  % plot sonications for t=1:12
% for t_i = 1:min(PARAMS.NT,12)
%     subplot(3,4,t_i)
%     imagesc(squeeze(dT_Gold(:,:,t_i)))
%     colormap jet;
%     axis equal; axis tight; %axis off;
%     caxis([PARAMS.cmin PARAMS.cmax]);%caxis([-30 30])
%     xlim([PARAMS.y1 PARAMS.y2])
%     ylim([PARAMS.x1 PARAMS.x2])
%     title(['t=',num2str(t_i)])
%     title(['\DeltaT(t=',sprintf('%d',t_i),')'])
%     axis off
% end
% suptitle(['Gold Standard (zoomed) \DeltaT [^oC]'])
% 
% if PARAMS.NT>12
%     figure  % plot sonications for t=13:24
%     for t_i = 13:min(PARAMS.NT,24)
%         subplot(3,4,t_i-12)
%         imagesc(squeeze(dT_Gold(:,:,t_i)))
%         colormap jet;
%         axis equal; axis tight; %axis off;
%         caxis([PARAMS.cmin PARAMS.cmax]);%caxis([-30 30])
%         xlim([PARAMS.y1 PARAMS.y2])
%         ylim([PARAMS.x1 PARAMS.x2])
%         title(['t=',num2str(t_i)])
%         title(['\DeltaT(t=',sprintf('%d',t_i),')'])
%         axis off
%     end
%     suptitle(['Gold Standard (zoomed) \DeltaT [^oC]'])
% end



for cnt = 1:ceil(PARAMS.NT/12)
    a = cnt - 1;
    figure  % plot sonications for t=13:24
    for t_i = (1+a*12):min(PARAMS.NT,cnt*12)
        subplot(3,4,t_i-a*12)
        imagesc(squeeze(dT_Gold(:,:,t_i)))
        colormap jet;
        axis equal; axis tight; %axis off;
        caxis([PARAMS.cmin PARAMS.cmax]);%caxis([-30 30])
        xlim([PARAMS.y1 PARAMS.y2])
        ylim([PARAMS.x1 PARAMS.x2])
        title(['t=',num2str(t_i)])
        title(['\DeltaT(t=',sprintf('%d',t_i),')'])
        axis off
    end
    suptitle(['Gold Standard (zoomed) \DeltaT [^oC]'])
end 
