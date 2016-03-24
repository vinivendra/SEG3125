highdpi = true

function love.conf(t)
    t.window.highdpi = highdpi

    scale = 1

    if highdpi == true then
        scale = 2
    end

    t.window.width = 1920 / scale
    t.window.height = 1080 / scale
end