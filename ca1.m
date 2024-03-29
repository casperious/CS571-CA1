%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ICSI471/571 Introduction to Computer Vision Spring 2024
% Copyright: Xin Li@2024
% Computer Assignment 1: Image Acquisition and Perception
% Due Date: Feb. 8, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General instructions: 
% 1. Wherever you see a pair of <...>, you need to replace <>
% by the MATLAB code you come up with
% 2. Wherever you see a pair of [...], you need to write a new MATLAB
% function with the specified syntax
% 3. Wherever you see a pair of {...}, you need to write your answers as
% MATLAB annotations, i.e., starting with %

% The objective of this assignment is to learn the basic concepts of
% image acquisition and perception such as optical illusions 
% MATLAB functions: rgb2gray, imresize, interp2, subplot, round, squeeze  

% Part I: Image acquisition basics (5 points)

% read in the test image cameraman (provided by matlab)
x=double(imread('cameraman.tif'));
% check the spatial resolution (width and height) of the image
whos x
% 1. reduce the image spatial resolution by a factor of two (also-called down-sampling)
% Hint: you need to know how to use ":" operator (1 point)
%x1=<only keep odd-indexed rows and columns of x so you will obtain 
%an image whose size is half of that of x>;
x1=x(1:2:end,1:2:end); %extract odd rows and columns
imshow(x,[]);
imshow(x1,[]);
% increase the spatial image resolution by a factor of two (also-called up-sampling)
% Hint: use >help imresize or >help interp2 to learn how to use these two
% functions assoicated with linear interpolation 
x2=imresize(x1,2); %resize
subplot(1,2,1);imshow(x,[]);title('original image');
subplot(1,2,2);imshow(x2,[]);title('interpolated image');
%{report what kind of visual quality degradation you observe when comparing
%    x2 with the original x.}
% The original image is a lot clearer. The second image is more pixelated

% 2. reduce the bit-depth image resolution of x from 256 to 16 
% Hint: you can google ``uniform quantization'' to learn more 
% background information (1 point)
Q=16;
x3=round(x/Q);
subplot(1,2,1);imshow(x,[]);title('8-bit image');
subplot(1,2,2);imshow(x3,[]);title('4-bit image');
%{report what kind of visual quality degradation you observe when comparing
%    x3 with the original x.}
% The foreground looks the same, but the background is a lot hazier


% 3. extract the MSB and LSB of a given image (1 point)
% Hint: you can google ``matlab bitget'' or type ">help bitget" to learn%
% how to use this tool properly
x=double(imread('cameraman.tif'));
MSB=bitget(x,8);
LSB=bitget(x,1);
subplot(1,2,1);imshow(MSB,[]);title('Most Significant Bitplane (MSB)');
subplot(1,2,2);imshow(LSB,[]);title('Least Significant Bitplane (MSB)');
%{report what kind of visual difference between MSB and LSB you can observe.}
% MSB is a white and black representation of the image, while LSB is a mosaic of white and black.

% 4. play with a color image of flowers (1 point)
% read in the test image 
x=double(imread('fl_orig.ppm'));
img = imread('fl_orig.ppm');
y=rgb2gray(x/255);
% generate Bayer pattern z
% green channels: quincinx lattice
z=zeros(size(y));
z(1:2:end,1:2:end)=squeeze(x(1:2:end,1:2:end,2));
z(2:2:end,2:2:end)=squeeze(x(2:2:end,2:2:end,2));
% red/blue channels: quarter-size
z(1:2:end,2:2:end)=squeeze(x(1:2:end,2:2:end,1));
z(2:2:end,1:2:end)=squeeze(x(2:2:end,1:2:end,3));
% Bayer pattern is NOT the grayscale version but visually appears similar
% Note that y is normalized within [0,1] and z is within [0,255]
imshow([y*255 z],[]);
%[write a new matlab function called cfa_interp.m to reconstruct full-resolution
%color image from the bayer pattern z. ]

%Hint: For MATLAB beginners, learn to search which function is provided by MATLAB 
% to do CFA interpolation (just Google it!); for MATLAB veterans, you can try out your own ideas of 
% interpolating each channel independently via linear methods (e.g., imresize or interp2)]
% or you can use '>help demosaic' to learn how to solve this problem by calling a build-in function
% Note that you need to be careful with the image format because 'demosaic'
% only supports the class of image format with unsigned integers.
xx=cfa_interp(z);
%<display original and reconstructed color images side-by-side>
subplot(1,2,1);imshow(img,[]);title('original image');
subplot(1,2,2);imshow(xx,[]);title('reconstructed image');
% This problem is often called image demosaicing. You can learn more about 
% more advanced demosaicing methods at wiki: https://en.wikipedia.org/wiki/Demosaicing 

% 5. MRI image acquisition in k-space (1 point) probable error
clear all
close all
%load spiralexampledata
% d - spiral data;
% k - kspace locations (kx,ky); use plot(real(k),imag(k),'.') to see
% w - density compensation function (used to weight the k-space data); 
S = load("rt_spiral.mat"); 
d = S.d;
w = S.w;
k = S.k;
% a simple implementation of gridding algorithm for MRI reconstruction
% choose an image size
n=256/2;
% read the supplied grid2w.m function and learn how to call it
X=grid2w(d,k,w,n);
x=abs(fftshift(ifft2(X)));
% display the reconstructed result
% Hint: if the displayed result does not appear correct, >help fftshift
% and understand why you need to use fftshift here (we will discuss this
% issue later during the lecture on FT of images)
figure(1);imshow(abs(x),[]);
% Is the scan of a stop watch?

% Part II: Image perception experiments (5 points)
% The objective of this assignment is to play with digital images
% and learn about the fascinating science of visual perception

% 1. black or white? (1 point)
x1=imread('illusion.png');
imshow(x1,[]);
%{Find out the intensity values at blocks A and 
%    Verfiy they are indeed the same number despite visually apparent difference}
% A and B both have R:120 G:120 and B:120 values


% 2. which one is longer? (1 point)
x2=imread('arrows.png');
imshow(x2,[]);
%{Find out the approximate lengths of two arrows 
%    and verify theu are indeed the same despite that visually the bottom one appears longer}
% Both are approx 192 units long

% 3. which one is larger? (1 points)
x3=imread('SC_shape.png');
imshow(x3,[]);
%{Find out the diameters of two disks at the center
%    and verify they are indeed the same despite that visually the left one appears larger}
% Both center circles are approx 71 units long

% 4. red or orange? (1 point)
% two pixels with identical R,G,B values might look like two totally different colors
x4=imread('scstrpe1.ppm');      
imtool(x4);
%{Use the interactive tool supplied by imtool to find out the (R,G,B) 
%    values associated with two center blocks respectively}
%  Left value is 255,0,0 and right value is 255,0,0

% 5. parallel or not? (1 point)
x5=imread('parallel.png');
imshow(x5);
%{Find out whether the long lines along the NW direction are parallel to each other
%    by measuring their orientations - just pick any two lines and show your calculation.}
%  Taking the third and 5th lines from the left, drawing two lines through
%  the horizontal lines along the lines in question, reveal that they are in fact parallel.
% I exported the proof image, but do not know where it is stored.

% Summary: seeing is not believing. The neuroscience behind visual
% perception has remained largely a big mystery.
