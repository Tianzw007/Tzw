function pD = compute_pD(X)
pd_limit = 320;
pd_rate = 0.00025;
Rng= Range_meas(X);
pD = transpose(zeros(1,length(Rng)));
ind1 = Rng < pd_limit;
pD(ind1) = 0.9999;
ind2 = Rng >= pd_limit;
pD(ind2) = max(0,1.0-(Rng(ind2)-pd_limit)*pd_rate);
end