%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = compactbit(b)%ת������
%
% b = bits array
% cb = compacted string of bits (using words of 'word' bits)

[nSamples,nbits] = size(b);%��n*l��
nwords = ceil(nbits/8);
cb = zeros([nSamples,nwords], 'uint8');

for j = 1:nbits
    w = ceil(j/8);
    cb(:,w) = bitset(cb(:,w), mod(j-1,8)+1, b(:,j));
end