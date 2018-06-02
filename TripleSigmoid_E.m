% TripleSigmoid: Computes the value of the TSE function (Triple Sigmoid with 
%                  Elliptical centre) at each value in vector s
% s              - Input samples
% tx, ty         - Column vectors of translations from the origin
% alfa_x, alfa_y - Column vectors of rotation angles with respect to x and y axis of the two oriented 2D-Sigmoids
% bx, by         - Column vectors of beta values of the two oriented 2D-Sigmoids 
% be             - Column vector of beta values of the Elliptic Sigmoid
% ex, ey         - Column vectors of semi-minor and semi-major axis of the Elliptic Sigmoid
% angle_e        - Column vector of rotation angles of the Elliptic Sigmoid
function y=TripleSigmoid_E(s,tx,ty,alfa_x,alfa_y,bx,by,be,ex,ey,angle_e)
    s  = s - [tx ty];
    sR = [s(:,1).*cos(alfa_y)+s(:,2).*sin(alfa_y)  -s(:,1).*sin(alfa_x)+s(:,2).*cos(alfa_x)];
    sC = [s(:,1).*cos(angle_e)+s(:,2).*sin(angle_e)  -s(:,1).*sin(angle_e)+s(:,2).*cos(angle_e)];
    ex(ex==0.0) = 1;
    ey(ey==0.0) = 1;
    
    y = 1./[1+exp(-sR.*[by bx]) 1+exp(-be.*(sum((sC./[ex ey]).^2,2)-1))]; 
    y = prod(y,2);

