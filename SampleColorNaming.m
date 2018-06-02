% SampleColorNaming: Given a sRGB sample, returns the color name assigned to 
%                    the sample by the color naming model (in 'res') and the 
%                    11 memberships to the 11 basic colors (in 'CD')
%                    The membership values in the third dimension of CD are
%                    ordered: Red,Orange,Brown,Yellow,Green,Blue,Purple,Pink,Black,Grey,White
% s                - Sample in sRGB format [R G B]
% parFileName1     - File name for parameters of the model (chromatic colors)
% parFileName2     - File name for parameters of the model (achromatic colors)
% parFileName3     - File name for parameters of the model (lightness levels)

function [res,CD]=SampleColorNaming(s,parFileName1,parFileName2,parFileName3)

if ((size(s,1)~=1)||(size(s,2)~=3))
   error('Error: s must be a 1 x 3 vector [R G B]');
end

% Constants
colors={'Red' 'Orange' 'Brown' 'Yellow' 'Green' 'Blue' 'Purple' 'Pink' 'Black' 'Grey' 'White'};
numColors=11;                           % Number of colors
numAchromatics=3;                       % Number of achromatic colors
numChromatics=numColors-numAchromatics; % Number of chromatic colors

% Load Files with color-naming model parameters
load(parFileName1);                     % Contains structure 'parameters'
load(parFileName2);                     % Contains structure 'thrL'
load(parFileName3);                     % Contains structure 'params_achro'

%Initializations
numLevels=size(thrL,2)-1;               % Number of Lightness levels in the model
CD=zeros(1,numColors);                  % Color descriptor to store results

% Conversion: sRGB to CIELab
cform=makecform('srgb2lab','AdaptedWhitePoint', whitepoint('D65')); 
Lab=applycform(double(s)/255,cform);
L=Lab(1);
a=Lab(2);
b=Lab(3);

% Assignment of the sample to its corresponding level
m=(L==0);                               % Pixels with L=0 assigned to level 1
k=1;
while (k<=numLevels)
    m=m+((thrL(k)<L).*(L<=thrL(k+1))).*k;
    k=k+1;
end

% Computing membership values to chromatic categories
for k=1:numChromatics
    tx=parameters(k,1,m);
    ty=parameters(k,2,m);
    alfa_x=parameters(k,3,m);
    alfa_y=parameters(k,4,m);
    beta_x=parameters(k,5,m);
    beta_y=parameters(k,6,m);
    beta_e=parameters(k,7,m);
    ex=parameters(k,8,m);
    ey=parameters(k,9,m);
    angle_e=parameters(k,10,m);
    CD(:,k)=(beta_e~=0.0).*TripleSigmoid_E([a b],tx,ty,alfa_x,alfa_y,beta_x,beta_y,beta_e,ex,ey,angle_e);
end

% Computing membership values to achromatic categories
valueAchro=max(1-sum(CD,2),0);
CD(:,numChromatics+1)=valueAchro.*Sigmoid(L,paramsAchro(1,1),paramsAchro(1,2));
CD(:,numChromatics+2)=valueAchro.*Sigmoid(L,paramsAchro(2,1),paramsAchro(2,2)).*Sigmoid(L,paramsAchro(3,1),paramsAchro(3,2));
CD(:,numChromatics+3)=valueAchro.*Sigmoid(L,paramsAchro(4,1),paramsAchro(4,2));

% Returning the color name corresponding to the maximum membership value
[M,index]=max(CD,[],2);
res=colors(index);



