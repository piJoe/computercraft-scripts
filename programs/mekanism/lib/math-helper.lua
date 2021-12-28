function fixedDecimals(num, numDecimalPlaces)
  return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
end

function si(value, numDecimalPlaces)
    if value < 1000 then
        return fixedDecimals(value, numDecimalPlaces), ""
    end
    if value < 1000000 then
        return fixedDecimals(value/1000, numDecimalPlaces), "K"
    end

    return fixedDecimals(value/1000000, numDecimalPlaces), "M"
end

return {
    fixedDecimals = fixedDecimals,
    si = si
}