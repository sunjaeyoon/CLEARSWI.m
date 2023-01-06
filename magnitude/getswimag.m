function swimag = getswimag(data,options)
%GETSWIMAG Summary of this function goes here
%   Detailed explanation goes here

combined_mag = combine_echoes_swi(data.mag, data.TEs, options.mag_combine);
swimag = sensitivity_correction(combined_mag, data, options);

if options.mag_softplus ~= false
    swimag = softplus_scaling(swimag, options.mag_softplus);
end

end

function out = softplus_scaling(mag, para)
    q = estimatequantile(mag, 0.8);
    if para == true
        out = softplus(mag, q/2);
    elseif isa(para, 'isnumeric')
        out = softplus(mag, para * q);
    elseif isa(para, 'struct') % idk about this one
        out = softplus(mag, para(1) * q, para(2));
    else
        error("wrong input for softplus: got $para")
    end
end

function out = estimatequantile(array, p)
    try 
        out = quantile(sample(array, 1e5), p);
    catch
        disp("quantile could not be estimated! (maybe only NaNs)")
        out = 0;
    end
end

function out = softplus(val, offset, factor) % factor = 2
    f = factor / offset;
    % stable implementation
    function out1 = sp(x)
        arg = f * (x - offset);
        soft = log(1 + exp(-abs(arg))) + max(0, arg);
        out1 =  soft / f;
    end
    out = sp(val) - sp(0);
end

function ret = sample(I, n)
    n = min(n, length(I));
    len = ceil(sqrt(n)); % take len blocks of len elements
    startindices = round(range(firstindex(I) - 1, lastindex(I) - len, length=len));
    indices = [(i + (1:len) for i in startindices ]
    ret = filter(isfinite, I[indices])
    if isempty(ret)
        ret = filter(isfinite, I)
    end
end
