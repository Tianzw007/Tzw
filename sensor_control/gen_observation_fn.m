function Z= gen_observation_fn(X,V)
global C_posn Sen;
if isempty(X)
    Z= [];
else
    P= C_posn*X; %coordinate extraction
    Z(1,:) = sqrt((P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))).^2+ (P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))).^2);
    Z(2,:) = atan2((P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))),(P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))));
    Z= Z+ V;
end
end