function [ output ] = CostGenerationCoprime( coprime, n,ell )
output = repmat(1:coprime,1,ceil(n*ell/coprime));
output = output(1:n*ell);
output = reshape(output, [ell,n])';
end

