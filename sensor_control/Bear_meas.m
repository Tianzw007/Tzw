function Bearing = Bear_meas(X)
global C_posn Sen;
P= C_posn*X;
Bearing = atan2 ((P(2,:)-(Sen(2,:).*(ones(size(P(2,:)))))),(P(1,:)-(Sen(1,:).*(ones(size(P(1,:)))))));
end