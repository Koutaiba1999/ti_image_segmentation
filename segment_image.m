% SEGMENT_PANDA contains the implementation of the main routine for Assignment 2. 
% This routine reads a image, which contains three intensity classes.
% The routine employs the Expectation-maximization method to estimate the parameters
% of the three intensity classes with a mixture of three Gaussian distributions, and
% segment the image with minimum error thresholds.
%  
function segment_image() 

% Define convergence threshold.
threshold = 0.01;

% Read the sunset image and convert the color image into grayscale image.
Im = imread('C:\Users\Koutaiba\Desktop\Datasets\images\1objet\01.png');
%Im = rgb2gray(Im);
% Build a histgoram of the image, it is for the sake of
% parameter estimations and visualization.
Hist = imhist(Im,256)';

% The Expectation-maximization algorithm.

% Initialize the paramters.
Weight = zeros(3,1);
Mu = zeros(3,1);
Sigma = zeros(3,1);
Weight(1) = 0.45;
Weight(2) = 0.35;
Weight(3) = 0.20;
Mu(1) = 5;
Mu(2) = 90;
Mu(3) = 230;
Sigma(1) = 1;
Sigma(2) = 10;
Sigma(3) = 20;

itn = 1;
while(1)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO_1: Estimate the expected posterior probabilities.
    
    dIm = double(Im);
    mSum = (Weight(1) .* normpdf(dIm, Mu(1), Sigma(1))) + (Weight(2) .* normpdf(dIm, Mu(2), Sigma(2))) + (Weight(3) .* normpdf(dIm, Mu(3), Sigma(3))); 
    p1 = (Weight(1) .* normpdf(dIm, Mu(1), Sigma(1))) ./ mSum;
    p2 = (Weight(2) .* normpdf(dIm, Mu(2), Sigma(2))) ./ mSum;
    p3 = (Weight(3) .* normpdf(dIm, Mu(3), Sigma(3))) ./ mSum;
   
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Allocate spaces for the parameters estimated.
	NewWeight = zeros(3,1);
	NewMu = zeros(3,1);
	NewSigma = zeros(3,1);
    
    % TODO_2: Estimate the parameters.
    
    % Estimate the new mean
    NewMu(1) = sum(p1(:).*dIm(:)) ./ sum(p1(:));
    NewMu(2) = sum(p2(:).*dIm(:)) ./ sum(p2(:));
    NewMu(3) = sum(p3(:).*dIm(:)) ./ sum(p3(:));
    
    % Estimate the new Sigma
    n1 = p1 .* ((dIm - NewMu(1)).^2);
    n2 = p2 .* ((dIm - NewMu(2)).^2);
    n3 = p3 .* ((dIm - NewMu(3)).^2);
    NewSigma(1) = sqrt(sum(n1(:)) ./ sum(p1(:)));
    NewSigma(2) = sqrt(sum(n2(:)) ./ sum(p2(:)));
    NewSigma(3) = sqrt(sum(n3(:)) ./ sum(p3(:)));
    
    % Estimate the new Weights
    NewWeight(1) = sum(p1(:)) ./ numel(Im);
    NewWeight(2) = sum(p2(:)) ./ numel(Im);
    NewWeight(3) = sum(p3(:)) ./ numel(Im);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    % Check if convergence is reached.
	DiffWeight = abs(NewWeight-Weight)./Weight;
	DiffMu = abs(NewMu-Mu)./Mu;
	DiffSigma = abs(NewSigma-Sigma)./Sigma;
	
	if (max(DiffWeight) < threshold) & (max(DiffMu) < threshold) & (max(DiffSigma) < threshold)
        break;
	end
	
	% Update the parameters.
	Weight = NewWeight;
	Mu = NewMu;
	Sigma = NewSigma;
    
    disp(['Iteration #' num2str(itn)]);
    disp([' Weight: ' num2str(Weight(1)) ' ' num2str(Weight(2)) ' ' num2str(Weight(3))]);
    disp([' Mu: ' num2str(Mu(1)) ' ' num2str(Mu(2)) ' ' num2str(Mu(3))]);
    disp([' Sigma: ' num2str(Sigma(1)) ' ' num2str(Sigma(2)) ' ' num2str(Sigma(3))]);
    itn = itn + 1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO_3(a): Compute minimum error threshold between the first and the second
% Gaussian distributions.
% Using the minimum error equation for Gaussian distributions.

X = [1:size(Hist,2)];
funcG = zeros(3,size(Hist,2));

for i = [1:3]
    funcG(i,:) = 1/(sqrt(2*pi)*Sigma(i)).*exp(-((X-Mu(i)).^2)/(2*Sigma(i)^2));
end

norm_1 = funcG(1,:);
norm_2 = funcG(2,:);
norm_3 = funcG(3,:);

% Find the intensity value with the minimum error between 1 and 2
curMin = 9999;
for i = floor(Mu(1)):ceil(Mu(2))
    diff = abs((Weight(1) * norm_1(i)) - (Weight(2) * norm_2(i)));
    if (diff < curMin) 
       curMin = diff;
       FirstThreshold = i;
    end
end

% TODO_3(b): Compute minimum error threshold between the second and the third
% Gaussian distributions.

% Find the intensity value with the minimum error between 3 and 2
curMin = 9999;
for i = floor(Mu(2)):ceil(Mu(3))
    diff = abs((Weight(2) * norm_2(i)) - (Weight(3) * norm_3(i)));
    if (diff < curMin) 
       curMin = diff;
       SecondThreshold = i;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the segmentation results.
figure;
subplot(2,3,1);imshow(Im);title('Sunset');
subplot(2,3,3);imshow(Im<=FirstThreshold);title('First Intensity Class');
subplot(2,3,4);imshow(Im>FirstThreshold & Im<SecondThreshold);title('Second Intensity Class');
subplot(2,3,5);imshow(Im>=SecondThreshold);title('Third Intensity Class');
Params = zeros(9,1);
Params(1) = Weight(1);
Params(2) = Mu(1);
Params(3) = Sigma(1);
Params(4) = Weight(2);
Params(5) = Mu(2);
Params(6) = Sigma(2);
Params(7) = Weight(3);
Params(8) = Mu(3);
Params(9) = Sigma(3);
subplot(2,3,2);ggg(Params,Hist);