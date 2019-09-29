clear all
close all

% ===========================================================
%        SET YOUR DESIRED DEMO & REDUCTION FACTOR HERE
% ===========================================================
demo = 'Agar_phantom_demo' % scanner vendor: Philips.  Grissom's data
% demo = 'Gel_phantom_demo'  % scanner vendor: GE.     Insightec's data - series 25

% Set the reduction factor (k-space subsampling rate)
switch demo
    case 'Agar_phantom_demo' 
        R_vec =  2; %[2  4  6 ];  
    case 'Gel_phantom_demo'  
        R_vec =  2; % 2:2:10;      
end


% =========================== set parameters =========================

PARAMS = set_params(demo); 

% =========================== load fully sampled data =========================

disp('loading fully sampled data')

switch demo
    case 'Agar_phantom_demo'
        load('Agar_phantom_kspace_data.mat')   
    case 'Gel_phantom_demo'
        load('Gel_phantom_kspace_data.mat')     
end


% ======================= Calc. Gold Standard Temp. Change   ========================

[dT_Gold] = TempChangeCalc(FullKspace,PARAMS); 

[dT_Gold] = dT_corrections_per_vendor(dT_Gold,PARAMS);


% ---------- Examples - plots for fully-sampled data ---------------
 plot_fully_sampled_examples(FullKspace,dT_Gold,PARAMS)



%% ========================== Reconstruction Experiments ===============================

for R = R_vec
    
    disp(['=================== R = ',num2str(R),' ========================='])
    
    % ------ Create Sampling Mask ------
    [PARAMS] = gen_var_dens_sampling(PARAMS,R);
    
    % figure; imagesc(PARAMS.sampling_mask); axis image; title(['sampling mask, R=',num2str(R)]); colormap gray;
    
    %===================================================================================
    % ------  Temporal Differences (TED)   ----------
    %====================================================================================
    
    disp('************ TED method *****************')

    [RecKspace] = TED(FullKspace,PARAMS);
    
    [dT_TED] = TempChangeCalc(RecKspace,PARAMS); 

    [dT_TED] = dT_corrections_per_vendor(dT_TED,PARAMS);

    % ------------ display results -----------------------
    for t_jjj = 1:length(PARAMS.t_rec_vec)
        t_ind = PARAMS.t_rec_vec(t_jjj);
        
        % ------- zoom-in on the HIFU area -------
        % gold standard
        dT_gold_zoomed = dT_Gold(PARAMS.x1:PARAMS.x2,PARAMS.y1:PARAMS.y2,t_ind);
        
        % TED reconstruction
        dT_zoomed_TED = dT_TED(PARAMS.x1:PARAMS.x2,PARAMS.y1:PARAMS.y2,t_ind);
        dT_zoomed_TED_err = dT_zoomed_TED - dT_gold_zoomed;
       
        NRMSE_TED = calc_NRMSE(dT_gold_zoomed(:),dT_zoomed_TED(:));
     
        % ------------- plot results ---------------
        SPACE = -20*ones(length(PARAMS.x1:PARAMS.x2),1);

        figure('Name',[PARAMS.title,', dT, t=',num2str(t_ind),', R=' ,num2str(R)])
        imagesc([dT_gold_zoomed  SPACE dT_zoomed_TED] )
        colormap jet;
        axis equal; axis tight; axis off;
        caxis([PARAMS.cmin PARAMS.cmax]);%caxis([-30 30])
        hold on
        text(1,2,['Gold Standard'],'Color','k','FontSize',11)
        hold on
        text(2+size(dT_gold_zoomed,2),2,['TED'],'Color','k','FontSize',11)
        hold on
        text(2+size(dT_gold_zoomed,2),(PARAMS.x2-PARAMS.x1)-0.5,['NRMSE ',sprintf('%.3f',NRMSE_TED )],'Color','k','FontSize',11)
        c = colorbar;
        c.Label.String = '[^oC]';
        suptitle(['R=',num2str(R),', Time frame #',num2str(t_ind)])
        
    end
        
end 


