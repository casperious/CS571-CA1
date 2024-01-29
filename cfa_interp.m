function out = cfa_interp(in)
%CFA_INTERP Summary of this function goes here
%   Detailed explanation goes here
in = uint16(in);
out = demosaic(in,"gbrg");
imshow(out);
end

