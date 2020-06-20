function[X_update,N_update,w_update]=Resampling_fn(q_update,w_update,X_predict,N_update,X_pseudo,L_update,L_predict)
global Lmax Lmin;
X_update=cell(L_update,1);
for j=1:L_update
    N_update(j)= max(round(q_update(j)*Lmax),Lmin);
    idxs= resample(w_update{j},N_update(j));
    w_update{j}= ones(N_update(j),1)/N_update(j);
    if j <= L_predict
        X_update{j}= X_predict{j}(:,idxs);
    elseif j >= L_predict+1
        X_update{j}= X_pseudo(:,idxs);
    end
end
end

function resample_idx= resample(w,L)
resample_idx= [];
[~,sort_idx]= sort(-w); %sort in descending order
rv= rand(L,1);
i= 0; threshold= 0;
while ~isempty(rv)
    i= i+1; threshold= threshold+ w(sort_idx(i));
    rv_len= length(rv);
    idx= find(rv>threshold);
    resample_idx= [ resample_idx; sort_idx(i)*ones(rv_len-length(idx),1) ];
    rv= rv(idx);
end
end