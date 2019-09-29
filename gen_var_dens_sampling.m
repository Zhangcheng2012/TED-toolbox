function [PARAMS] = gen_var_dens_sampling(PARAMS,R)
% Load or generate 1D variable density random sampling pattern
% This function is based on Michael Lustig's SparseMRI toolbox

mask_filename = ['VarDensSampling/Sampling_mask_1D_var_dens_R',num2str(R),'_N',num2str(PARAMS.N),'.mat'];

if exist(mask_filename)==2
    disp('loading sampling mask')
    load(mask_filename);
    
else
    disp('creating new sampling mask')

    radius = 0.0000005;
    p=10;   % polynom degree
    
    sucss_flag=0;
    size_vec = [1 N];
    while ~sucss_flag
        try
            [pdf,val] = genPDF(size_vec,p,pctg,2,radius,0);
        catch
            continue;
        end
        sucss_flag=1;
    end
    s = RandStream('mt19937ar','Seed',1); % I changed the seed from 1 to 2 in version 3
    sampling_mask=pdf>rand(s,size_vec);
    sampling_mask = repmat(sampling_mask,N,1);
    
end

PARAMS.sampling_mask = sampling_mask;


