function interpolate(a, b, t)
    return a + ((b - a) * t)
end

function smooth(a, b, t)
    start = a
    interval = b - a
    interp = t * t * t * (t * (t * 6 - 15) + 10)
    return start + interp * interval
end

function easeIn(a, b, t)
    start = a
    interval = b - a
    interp = t * t
    return start + interp * interval
end

function easeOut(a, b, t)
    start = a
    interval = b - a
    interp = 1 - (1 - t) * (1 - t)
    return start + interp * interval
end