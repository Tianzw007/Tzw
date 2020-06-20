function Rng_Finder= Range_meas(X)
global C_posn Sen;
P= C_posn*X;
Rng_Finder= sqrt((P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))).^2+ (P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))).^2);
end