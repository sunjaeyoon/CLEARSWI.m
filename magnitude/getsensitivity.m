function getsensitivity(mag::NIVolume, datatype=eltype(mag); kw...)
    return getsensitivity(datatype.(mag), getpixdim(mag); kw...)
end

function getsensitivity(mag, pixdim; sigma_mm=7, nbox=15)
    return getsensitivity(mag; sigma=mm_to_vox(sigma_mm, pixdim), nbox)
end

function getsensitivity(mag, sigma, nbox=15)
    % segmentation
    firstecho = view(mag,:,:,:,1)
    mask = robustmask(firstecho)
    segmentation = boxsegment(firstecho, mask, nbox)
    % smoothing
    sigma1, sigma2 = getsigma(sigma)
    lowpass = gaussiansmooth3d(firstecho, sigma1; mask=segmentation, nbox=8)
    fillandsmooth_(lowpass, mean(firstecho[mask]), sigma2)

    return lowpass
end
