function mode = mode(x)

X = sort(x);
indices   =  find(diff([X realmax]) > 0); % indices where repeated values change
[modeL,i] =  max (diff([0 indices]));     % longest persistence length of repeated values
mode      =  X(indices(i));