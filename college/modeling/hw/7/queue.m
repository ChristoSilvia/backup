p = 0.2;
q = 0.2;

Mold = [ (1 - p) p 0; q (1 - (q + p)) p; 0 q (1 - q)]
Mnew = [ (1 - p) p 0; q*(1 - p) (1 - (q + p) + 2 * p * q) p*(1 - q); 0 q (1 - q)]
[Vold, lambdaold] = eig(Mold)
[Vnew, lambdanew] = eig(Mnew)
Vold * lambdaold * inv(Vold) - Mold
Vold * lambdaold.^40 * inv(Vold) * [0.3; 0.3; 0.4]
Vold(:,3)/sum(Vold(:,3))
Vnew * lambdanew.^40 * inv(Vnew) * [0.3; 0.3; 0.4]
Vnew(:,3)/sum(Vnew(:,3))

printf('\n')
lambdaold
Vold(:,1)/sum(Vold(:,1))
Vold(:,2)/sum(Vold(:,2))
Vold(:,3)/sum(Vold(:,3))

printf('\n')
lambdanew
Vnew(:,1)/sum(Vnew(:,1))
Vnew(:,2)/sum(Vnew(:,2))
Vnew(:,3)/sum(Vnew(:,3))
