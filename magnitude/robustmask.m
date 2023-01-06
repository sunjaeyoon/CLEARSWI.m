function robustmask(weight::AbstractArray; factor=1, threshold=nothing)
    if threshold isa Nothing
        w = sample(weight);
        q05, q15, q8, q99 = quantile.(Ref(w), (0.05, 0.15, 0.8, 0.99));
        high_intensity = mean(filter(isfinite, w[q8 .<= w .<= q99]));
        noise = mean(filter(isfinite, w[w .<= q15]))
        if noise > high_intensity/10
            noise = mean(filter(isfinite, w[w .<= q05]))
            if noise > high_intensity/10
                noise = 0; % no noise detected
            end
        end
        threshold = max(5*noise, high_intensity/5);
    end
    mask = weight > (threshold * factor);
    % remove small holes and minimally grow
    boxsizes=[[5] for i in 1:ndims(weight)]
    mask = gaussiansmooth3d(mask; nbox=1, boxsizes) .> 0.4
    mask = fill_holes(mask)
    boxsizes=[[3,3] for i in 1:ndims(weight)]
    mask = gaussiansmooth3d(mask; nbox=2, boxsizes) .> 0.6
    return mask
end