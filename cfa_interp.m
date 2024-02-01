function out = cfa_interp(in)
%CFA_INTERP Summary of this function goes here
%   Detailed explanation goes here
in = uint8(in);
out = demosaic(in,"grbg");
out = uint8(out);
imshow(out,[]);
end

