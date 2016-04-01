

function fadeRight(self)
    local displacementX = moveRight[1] * tileSize
    local displacementY = moveRight[2] * tileSize

    animation0 = StopAnimation:new({
        subject = player,
        imageName = "individuals/linkSuccess.png"
        })

    animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveRightSpriteFunction
        })
    animation0:chain(animation1)

    animation2 = AlphaAnimation:new({
        subject = player,
        duration = 0.5
        })
    animation1.with = animation2
    return animation0
end

