%IMAGE SEGMENTATION PROJECT USING OTSU, MORPHOLOGICAL RECONSTRUCTION
%AND CUSTOM SELECTION CODE
%DIGITAL IMAGE PROCESSING PROJECT
%BY NWAGWU JOHNPAUL KOSISOCHUKWU 301447651


clc;
clear;
close all;
%----------------------------------------------------------------------------------------------------------
% Read all Images from Data Folder
%---------------------------------------------------------------------------------------------------------
%if folder is not named Data. Please replace
imagedir = dir("Data\*.png");
no_of_files = length(imagedir);

for i=1:no_of_files
current_folder = imagedir.folder;
current_file = imagedir(i).name;
current_image = imread(append(current_folder,'\',current_file));
%images{i}=current_image;

%-------------------------------------------------------------------------------------------------------------
%FILTERING OPERATIONS: GAUSSIAN, MEDIAN AND AVERAGING
%---------------------------------------------------------------------------------------------------------------

%Filter by gaussian Filtering
filter = fspecial('gaussian', 3, 3);
A = imfilter(current_image, filter);

%More Filtering using averaging
h=1/3*ones(3,1);
B = imfilter(A,h);

%More Filtering using median filtering
C = medfilt2(B);

%----------------------------------------------------------------------------------------------------------------------
%OTSU HISTOGRAM EQUALIZATION AND THRESHOLDING
%----------------------------------------------------------------------------------------------------------------------

%Otsu threholding
his = histeq(C);
o = graythresh(his);
t = imbinarize(his,o);
%figure, imshow(t), title('Otsu Thresholded image');

%otsu inversed image
it=~t;

%------------------------------------------------------------------------------------------------------------------------
%MORPHOLOGICAL RECONSTRUCTION ON ORIGINAL FILTERED IMAGE,C USING CUSTOM
%CODE AND A LITTLE HOLE FILLING AND OPENING WITH DISK MASK OF SIZE 3
%------------------------------------------------------------------------------------------------------------------------

%image segmentation by morphological operations
morph_image=reconstruct(C, 0.4, 14, 22);

%More Image Morphological and Cleaning up
SE = strel('disk',3);
I_segmentedholes = imfill(morph_image,"holes");
%figure, imshow(I_segmentedholes); title('I_segmented holes')

%Opening
I_segmentedopened = imopen(I_segmentedholes,SE);
%figure, imshow(I_segmentedopened); title('I_segmented opened')

%---------------------------------------------------------------------------------------------------------------------
%LOGICAL AND OPERATION OF OTSU THRESHOLDED IMAGE AND MORPHOLOGICAL RECONSTRUCTED
%RESULT
%--------------------------------------------------------------------------------------------------------------------

%Multiplication of Otsu and imagereconstruct
%Otsu threholding multiply by morphology
m = it.*I_segmentedopened;
%figure, imshow(m), title('Multiplied image');

%-----------------------------------------------------------------------------------------------------------------------
%A LITTLE HOLE FILLING AND DILATION WITH DISK MASK OF SIZE 3
%-------------------------------------------------------------------------------------------------------------------------

%fill holes in final image if any
finale = imfill(m,"holes");
SE2 = strel('disk', 3);
finale = imdilate(finale, SE2);
%figure, imshow(finale), title('Finale');

%-------------------------------------------------------------------------------------------------------------------------
%SELECTION OF LARGEST MASK IN IMAGE ASSUMING ONLY ONE TUMOR EXISTS
%-------------------------------------------------------------------------------------------------------------------------

%Since image shows more than one blob. Let's select largest blob
%select largest blob out of all
[label, nBlobs] = bwlabel(finale);
blobs = regionprops(label, 'area', 'Centroid');
Areas = [blobs.Area];
[sortAreas, sortIndexes] = sort(Areas, 'descend');
biggestmask = ismember(label, sortIndexes(1:1));
finale2 = biggestmask > 0;


%---------------------------------------------------------------------------------------------------------------------------
%WRITING AND SAVING RESULT TO THE FOLDER WITH THE SAME INPUT IMAGE NAME
%---------------------------------------------------------------------------------------------------------------------------

%output_filename = sprintf('TestImage%dmask.png', i);
imwrite(finale2,current_file,"png");
%figure, imshow(finale2), title('Finale2');


%--------------------------------------------------------------------------------------------------------------------------
%CALCULATING JACCARD INDEX WITH TRUE MASK
%--------------------------------------------------------------------------------------------------------------------------
%calculating accuracy
%mask_image = finale2;
%mask = imread('mask_20.png');
%mask_image = imbinarize(mask_image./255);
%mask = imbinarize(mask./255);
%figure, imshow(uint8(mask.*255)), title('True mask')
%Jaccard = jaccard(mask,mask_image);

end


%--------------------------------------------------------------------------------------------------------------------------
%FUNCTION DEFINITIONS
%---------------------------------------------------------------------------------------------------------------------------

%imagereconstruct
function [A]=reconstruct(image, thresh, r1, r2)
%thresh is threshold, r1 is minimum r and r2 is maximum r
image=double(image);
A=zeros(size(image));  % matrix used for the final reconstructed image

for i=r1:2:r2 
    % circular mask
	se= strel('disk',i);
	    
	% Closing of image
	closed_image=imclose(image,se);

	%resonstruction using closed image
	reconstructed_image=imcomplement(imreconstruct(imcomplement(closed_image),imcomplement(image),4));
    
	% difference image
    difference_image=reconstructed_image-image;
    
    %thresholding by finding maximum and minimum values
    maxs=max(max(difference_image));
	mins=min(min(difference_image));  
	
    %difference between the minimum and maximum value
	thresh_value=thresh*(maxs-mins)+mins; 

    %Thresholded image
	thresh_image=difference_image>=thresh_value; 
	
    % LOGICAL OR TO ADD IN THRESHOLDS
	A= A | thresh_image; 
end

end
