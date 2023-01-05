function swimag = getswimag(data,options)
%GETSWIMAG Summary of this function goes here
%   Detailed explanation goes here

combined_mag = combine_echoes_swi(data.mag, data.TEs, options.mag_combine);
swimag = sensitivity_correction(combined_mag, data, options);

if options.mag_softplus ~= false
    swimag = softplus_scaling(swimag, options.mag_softplus);
end

end

