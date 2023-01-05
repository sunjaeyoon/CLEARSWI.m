function [corrected] = sensitivity_correction(combined_mag, data, options)
%SENSITIVITY_CORRECTION Summary of this function goes here
%   Detailed explanation goes here
sensitivity = options.mag_sens;
if isnothing(sensitivity)
    sensitivity = getsensitivity(data.mag(:,:,:,1), getpixdim(data));
end
    corrected = combined_mag ./ sensitivity;
end

