function[X_pseudo,N_update,q_update,w_update,L_update]=Update(k,N_predict,L_predict,w_predict,X_predict,q_predict,Z)
global x_dim clutterpdf T_threshold lambda_c;
m= size(Z{k},2);
q_update = zeros(L_predict+m,1) ;
N_update = zeros(L_predict+m,1) ;
w_update = cell(L_predict+m,1);
%---preparation for update
N_pseudo= sum(N_predict); %number of particles in pseudo-PHD
X_pseudo= zeros(x_dim,N_pseudo);
w_pseudo= zeros(N_pseudo,1);
w_pseudo1= zeros(N_pseudo,1);
w_pseudo2= zeros(N_pseudo,1);
start_pt= 1;
%construct pseudo-PHD
for j=1:L_predict
    end_pt= start_pt+N_predict(j)-1;
    w_temp= w_predict{j}.*compute_pD(X_predict{j});
    X_pseudo(:,start_pt:end_pt)= X_predict{j};
    w_pseudo(start_pt:end_pt) = q_predict(j)/(1-q_predict(j))*w_predict{j};
    w_pseudo1(start_pt:end_pt)= q_predict(j)/(1-q_predict(j)*sum(w_temp))*w_predict{j};
    w_pseudo2(start_pt:end_pt)= q_predict(j)*(1-q_predict(j))/((1-q_predict(j)*sum(w_temp))^2)*w_predict{j};
    start_pt= end_pt+1;
end
%--update
clear q_update N_update w_update X_update;

%legacy
for j=1:L_predict
    w_temp= w_predict{j}.*compute_pD(X_predict{j});
    N_update(j)= N_predict(j);
    q_update(j)= q_predict(j)*((1-sum(w_temp))/(1-q_predict(j)*sum(w_temp)));
    w_update{j}= w_predict{j}.*(1-compute_pD(X_predict{j}))/(1-sum(w_temp));
end
count=L_predict;
%measurement updated
for ell=1:m
    pD_temp= compute_pD(X_pseudo);
    gz_temp= transpose(compute_likelihood(Z{k}(:,ell),X_pseudo));
    qtrack= sum(pD_temp.*gz_temp.*w_pseudo2)/(lambda_c*clutterpdf+sum(pD_temp.*gz_temp.*w_pseudo1));
    %only compute tracks that are strong enough
    if qtrack > T_threshold
        count=count+1;
        w_temp= pD_temp.*gz_temp.*w_pseudo;
        q_update(count)= qtrack;
        N_update(count)= N_pseudo;
        w_update{count}= w_temp/sum(w_temp);
    end
end
L_update= length(q_update);
end