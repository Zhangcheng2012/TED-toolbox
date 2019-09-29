
function NRMSE = calc_NRMSE(correct_im,rec)
% Compute the Normalized Root Mean Squared Error (NRMSE)
% (c) Efrat Shimron

s_0 = abs(correct_im);
s_rec = abs(rec);

% throw away pixels for which the true image == 0
nnz_inds = find(s_0~=0);
s_0 = s_0(nnz_inds);
s_rec = s_rec(nnz_inds);

len = length(s_0);
RMSE = sqrt(sum((s_rec(:)-s_0(:)).^2 ) / (size(s_0,1)*size(s_0,2)));
dd = ( max(s_0(:)) - min(s_0(:))  );
NRMSE = RMSE/dd;

end