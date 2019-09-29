function [RecKspace] = TED_v1(FullKspace,PARAMS)
% This function reconstructs fully-sampled k-space data from sub-sampled
% k-space data using the Temporal Differences (TED) Compressed Sensing
% method.

% Inputs:
% FullKspace - fully-sampled k-space data at all time points. Matrix size: NxNxNTxNC
% PARAMS      - array of parameters

% Intermediate variables - defined for a single time point
% x      = reconstructed complex multi-coil data in K-SPACE, at a single time point           (matrix size: NxNxNc)
% X      = reconstructed complex multi-coil data in the IMAGE DOMAIN, at a single time point  (matrix size: NxNxNc)
% X_W    = reconstructed complex multi-coil data in the WAVELET DOMAIN, at a single time point (matrix size: NxNxNc)

% Output:
% RecKspace - Reconstructed k-space data at all time points. Matrix size: NxNxNTxNC

mask4all_coils = repmat(PARAMS.sampling_mask,[1 1 PARAMS.NC]);

W = Wavelet('Daubechies',4,3); % create Wavelet operator

% initialization
RecKspace = zeros(size(FullKspace));
RecKspace(:,:,1,:) = FullKspace(:,:,1,:);  % TED assumes that the baseline frame (#1) is always fully sampled

% =========== get (t-1) data =====================
X_baseline = ifft2c(squeeze(FullKspace(:,:,1,:))); % take data from time step 1 (baseline time) & go to image domain


% ========================== t>1 reconstructions ==================

for t_ind = PARAMS.t_rec_vec
    disp(['time frame #',num2str(t_ind)])
    
    % ========= sample K-space ==============
    x_sampled = squeeze(FullKspace(:,:,t_ind,:)).*mask4all_coils; %  = zero-filled sampled k-space
    
    % initialize
    x = x_sampled;  % initial guess (in k-space)
    
    for n = 1:PARAMS.TED_num_iters
        
        X = ifft2c(x);                   % go to image domain
        
        DX            = X - X_baseline;  % compute the complex differences between time t_ind and t=1
        DX_W          = W*(DX);          % go to wavelet domain
        DX_W_after_th = softThresh(DX_W,PARAMS.wavWeight); % apply threshold (joint sparsity)
        DX            = W'*(DX_W_after_th); % go back go image domain
        X             = X_baseline + DX;    % compute updated complex image at time t_ind
        
        xx = fft2c(X);                      % go back to k-space
        x = xx.*(x_sampled==0) + x_sampled; % apply data consistency
        
    end % for n=1:max_itrs
    
    % Output
    RecKspace(:,:,t_ind,:) = x(:,:,:);
    
end % for t_ind



% =====================================================================
%                 Joint Sparsity Soft Threshold
% =====================================================================

function x = softThresh(y,t)
% apply joint sparsity soft-thresholding
% (c) Lustig

absy = sqrt(sum(abs(y).^2,3));
unity = y./(repmat(absy,[1,1,size(y,3)])+eps);

res = absy-t;
res = (res + abs(res))/2;
x = unity.*repmat(res,[1,1,size(y,3)]);


