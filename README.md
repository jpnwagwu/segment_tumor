# tumor_finder

Hi welcome to my tumor mask finder

I have writtten the algorithm to be fairly simple and straightforward.

---------------------------------------------------------------------
MOTIVATION
------------------------------------------------------------------------------
Breast cancer is a global health concern for women. Therefore, detecting signs of
this disease at its earlier stages is of prime importance. Using breast ultrasound
images is one of the preferred methods for diagnosing this disease due to the low
energy involved in the imaging process.

In that context, image segmentation in breast ultrasound images refers to
extracting the regions corresponding to the lesion and separating it from normal
tissue regions. The size and the mass of the lesion regions are associated with the
severity of the disease and its progress stage.
In this project, I designed an algorithm to segment tumor regions in breast ultrasound images that
include benign and malignant tumors.

----------------------------------------------------------------------------
INPUT
----------------------------------------------------------------------------
The code reads all images with extension, .png in a folder(I called this Data) found in the 
matlab path For eg Documents/MATLAB Folder.

To run the code, simply create a folder called Data containing all images. The folder should
be in a matlab path. OR 

replace the folder name, Data with the folder name in which all test
images are stored.

----------------------------------------------------------------------------------------
OUTPUT
---------------------------------------------------------------------------------------
The code will automatically run and return the mask results for each of the images in
the directory in which the Folder exists. The individual masks are named as the input images.
