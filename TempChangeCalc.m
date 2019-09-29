function [dT] = TempChangeCalc(KspaceData,PARAMS)% newRealImages, newImgImages)
% This function first computes delta_Phi (the overall phase change) from the
% multi-coil K-space data, according to eq.[2] in the TED paper:
%                delta_Phi_t = atan( sum_i( (x_i_0)*conj(x_i_t)) ) where i=1:Nc is the coil index             
% This calibrationless multi-coil merging method was introduced in:
% Bernstein et al., "Reconstructions of phase contrast, phased array multicoil data", MRM 1994;32(3)

% Secondly, this function computes the overall temperature change by dT = delta_Phi/CONST

N = size(KspaceData,1);   % Each 2D slice is an NxN matrix
NT = size(KspaceData,3);  % number of time frames
NC = size(KspaceData,4);  % number of coils
CONST = PARAMS.CONST;

dT = zeros(N,N,NT);

for t_ind = 2:NT
    %-------------- phase change ----------------
    Imag_sum = zeros(N);
    Real_sum = zeros(N);
    
    for i=1:NC
        x_i_0 = ifft2c(squeeze(KspaceData(:,:,1,i)));        % coil i, baseline scan (time frame #1)
        x_i_t = ifft2c(squeeze(KspaceData(:,:,t_ind,i)));    % coil i, post-heating scan (in time frame t_ind)

        % Next, we compute (x_i_0)*conj(x_i_t) using simple algebra of complex numbers:
        % If     x_i_0 = a+ib
        %        x_i_t = c+id
        % then: (x_i_0)*conj(x_i_t) = (a+ib)(c-id) = (ac+bd)+i(bc-ad)

        Re = real(x_i_0).*real(x_i_t) + imag(x_i_0).*imag(x_i_t);
        Im = imag(x_i_0).*real(x_i_t) - real(x_i_0).*imag(x_i_t);
        
        Imag_sum = Imag_sum + Im;
        Real_sum = Real_sum + Re;
    end
    delta_Phi_t = atan2(Imag_sum , Real_sum);       % this is an NxN matrix, obtained from the NC coils together  
    
    %-------------- temperature change -------------
   dT(:,:,t_ind) = delta_Phi_t/CONST;  % delta_Phi_t is an NxN matrix
    
end 

