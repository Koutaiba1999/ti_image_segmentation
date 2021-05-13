% this code works in all the data sets
close all;
clear all;
myDir = uigetdir;	% gets directory
myFiles = dir(fullfile(myDir));
myDir2 = uigetdir;
myFiles2 = dir(fullfile(myDir2));
addpath(myDir);
addpath(myDir2);
accuracy_rate = zeros(length(myFiles),2);  
accuracy_rate2 = zeros(length(myFiles),2);  
accuracy_rate3 = zeros(length(myFiles),2);
for i = 1:length(myFiles)
    if (strfind(myFiles(i).name, '.png')) & (strcmp(myFiles(i).name,'Thumbs.png')==0)
        a = myFiles(i).name;
 %sprintf(myFiles(i).name);
        image = imread(a);
        threshs(i,1) = otsu(image);
 %%%%%%%%appel des methodes de segmentation%%%%%%%%
        segv = imread(myFiles2(i).name);
        seg1=im2bw(image,threshs(i,1)/255);
        [seg2] = kmoyenne(image,4);
        [m,n] = size(image);
        segv= imresize(segv,[m,n]);
        seg1= imresize(seg1,[m,n]);
        if size(segv,3)==3
        [accuracy_rate(i, 1),snr(i,1)] = psnr(im2double(seg1),im2double(rgb2gray(segv)));
        [accuracy_rate(i, 2),snr(i,2)] = psnr(im2double(seg2),im2double(rgb2gray(segv)));
        accuracy_rate2(i, 1)=ssim(im2double(seg1),im2double(rgb2gray(segv))) ;   
        accuracy_rate2(i, 2)=ssim(im2double(seg2),im2double(rgb2gray(segv))) ;   
        shape =  [size(seg1, 1) * size(seg1, 2), 1];
        shape2 =  [size(seg2, 1) * size(seg2, 2), 1];
        cm1=confusionmatStats(reshape(seg1,shape),reshape(im2bw(segv),shape));
        accuracy_rate3(i,1)=cm1.accuracy(1);
        cm2=confusionmatStats(reshape(im2bw(seg2),shape),reshape(im2bw(segv),shape));
        accuracy_rate3(i,2)=cm2.accuracy(1);
        else
        [accuracy_rate(i, 1),snr(i,1)] = psnr(im2double(seg1),im2double(segv));
        [accuracy_rate(i, 2),snr(i,2)] = psnr(im2double(seg2),im2double(segv));
        accuracy_rate2(i, 1)=ssim(im2double(seg1),im2double(segv)) ;   
        accuracy_rate2(i, 2)=ssim(im2double(seg2),im2double(segv)) ;   
        shape =  [size(seg1, 1) * size(seg1, 2), 1];
        shape2 =  [size(seg2, 1) * size(seg2, 2), 1];
        cm1=confusionmatStats(reshape(seg1,shape),reshape(im2bw(segv),shape));
        accuracy_rate3(i,1)=cm1.accuracy(1);
        cm2=confusionmatStats(reshape(im2bw(seg2),shape),reshape(im2bw(segv),shape));
        accuracy_rate3(i,2)=cm2.accuracy(1);
        end
%accuracy_rate(i, 2) = metrique(seg2,segv);


%%%%%%%%%%%%%%%%%%%%affichage des images segmentees%%%%%%%%%%%%%%
        figure, 

        subplot(3,1,1),imshow(seg1),title(sprintf('\t\t Image segmentee avec Otsu'));
        subplot(3,1,2),imshow(seg2),title(sprintf('\t\t Image segmentee avec Kmeans K=4'));
        subplot(3,1,3),imshow(segv),title(sprintf('\t\t Verite Terrain'));

    end
end
figure,
plot(accuracy_rate(:, 1),'r');hold on; plot(accuracy_rate(:, 2),'b');
title('Etude comparative du taux d"exactitude PSNR');
xlabel('Images') % x-axis label
ylabel('Taux d"exactitude') % y-axis label
legend('Methode 1','Methode2')

figure,
plot(accuracy_rate2(:, 1),'r');hold on; plot(accuracy_rate2(:, 2),'b');
title('Etude comparative du taux d"exactitude SSIM');
xlabel('Images') % x-axis label
ylabel('Taux d"exactitude') % y-axis label
legend('Methode 1','Methode2')


figure,
plot(accuracy_rate3(:, 1),'r');hold on; plot(accuracy_rate3(:, 2),'b');
title('Etude comparative accuracy');
xlabel('Images') % x-axis label
ylabel('Taux d"exactitude') % y-axis label
legend('Methode 1','Methode2')
