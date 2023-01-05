function swi = calculateSWI(data, options)
    swi = getswimag(data, options) .* getswiphase(data, options);
end
