function Z= gen_observation(X)
if isempty(X)
    Z= [];
else
    Rng= Range_meas(X);
    Ang= Bear_meas(X);
    sigma= [1+0.00005*(Rng.*Rng);(pi/180)*ones(size(Ang))];
    Z= gen_observation_fn(X, sigma*randn);
end
end