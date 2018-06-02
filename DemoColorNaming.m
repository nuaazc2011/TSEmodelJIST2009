clear all
close all

% Files with the parameters of the model
parFileName1='.\Parameters\TSE_JIST_Params1.mat';
parFileName2='.\Parameters\TSE_JIST_Params2.mat';
parFileName3='.\Parameters\TSE_JIST_Params3.mat';

% Path for output images
pathRes='.\Results\';

% Format of Output images
resImageFormat='tif'; 

% Image dataset (path and filename)
pathImages='.\Images\';
fileName='.\Images\ImageList.txt';



% Example of SampleColorNaming function for naming single sRGB values
[res,CD]=SampleColorNaming([155 155 155],parFileName1,parFileName2,parFileName3)
[res,CD]=SampleColorNaming([80 120 200],parFileName1,parFileName2,parFileName3)
[res,CD]=SampleColorNaming([87 87 22],parFileName1,parFileName2,parFileName3)
[res,CD]=SampleColorNaming([207 206 148],parFileName1,parFileName2,parFileName3)
[res,CD]=SampleColorNaming([205 65 23],parFileName1,parFileName2,parFileName3)



% Example of ImColorNamingTSELab function for naming a set of images
fid=fopen(fileName);
imageNames=textscan(fid,'%s');
imageNames=[imageNames{1}];
for i=1:size(imageNames,1)
    imageName=strcat(pathImages,char(imageNames(i)));
    ima=imread(imageName);
    figure;imshow(ima);
    [imaRes,imaIndex,CD]=ImColorNamingTSELab(ima,parFileName1,parFileName2,parFileName3);
    figure;imshow(imaRes);
    [pathstr,name,ext]=fileparts(imageName);
    resImageName=strcat(pathRes,name,'.',resImageFormat);
    imwrite(imaRes,resImageName,resImageFormat);
end
fclose(fid);

