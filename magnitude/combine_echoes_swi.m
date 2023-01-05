function out = combine_echoes_swi(mag, TEs, type)
%COMBINE_ECHOES_SWI Summary of this function goes here
%   Detailed explanation goes here

if ndims(mag) == 3 % only one echo
    out = mag;
elseif type == "SNR"
    out = RSS(mag);
elseif type == "average"
    out = squeeze(sum(mag,4));
elseif type == "last"
    out = mag(:,:,:,end);
    
% elseif typeof(type) <: Pair
%     type, para = type
%     if type == :CNR
%         if length(para) == 2
%             (w1, w2) = para
%             field = :B7T
%         else
%             (w1, w2, field) = para
%         end
%         weighting = calculate_cnr_weighting(TEs, w1, w2; field=field)
%         return combine_weighted(mag, weighting)
%     elseif type == :SE
%         TE_SE = para
%         return simulate_single_echo_mag(mag, TEs, TE_SE)
%     elseif type == :closest
%         TE_SE = para
%         eco = findmin(abs.(TEs .- TE_SE))[2]
%         return mag[:,:,:,eco]
%     elseif type == :echo
%         return mag[:,:,:,para]
%     elseif type == :average
%         return sum(mag[:,:,:,para]; dims=4)
%     end

end


end

