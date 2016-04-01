


nextMapView = nil


function animateNextMap()
    nextMapView = ImageView:new({
        name = "map view",
        width = 1920,
        height = 900,
        x = 1920,
        imageName = nextMapState.imageName,
        shouldAnimateTap = false
        })
    view:addSubview(nextMapView)

    local animation1 = OriginAnimation:new({
        destinationX = -1920,
        subject = mapView
        })
    local animation2 = OriginAnimation:new({
        destinationX = 0,
        subject = nextMapView,
        completion = completeMapAnimation
        })
    startAnimation(animation1)
    startAnimation(animation2)
end

function completeMapAnimation()
    mapView:removeFromSuperview()
    mapView = nextMapView
    nextMapView = nil
    currentMapState = nextMapState
    --
    player.x = currentMapState.playerOffset[1]
    player.y = currentMapState.playerOffset[2]
    player:removeFromSuperview()
    mapView:addSubview(player)

    if currentMapState.attackEnabled then
        attackMenuAction.color = {255, 255, 255, 255}
        attackMenuAction.onTap = commandAttackAction
    else
        attackMenuAction.color = {0, 0, 0, 0}
        attackMenuAction.onTap = nil
    end

    if currentMapState.loopEnabled then
        loopMenuAction.color = {255, 255, 255, 255}
        loopMenuAction.onTap = commandLoopAction
    else
        loopMenuAction.color = {0, 0, 0, 0}
        loopMenuAction.onTap = nil
    end

    startAnimation(nextMapState:begginingAnimation())
end


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
        duration = 0.5,
        completion = animateNextMap
        })
    animation1.with = animation2
    return animation0
end

function fadeInRight(self)
    player.x = player.x - moveRight[1] * tileSize
    player.y = player.y - moveRight[2] * tileSize

    local displacementX = moveRight[1] * tileSize
    local displacementY = moveRight[2] * tileSize

    animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveRightSpriteFunction
        })

    animation2 = AlphaAnimation:new({
        subject = player,
        duration = 0.5
        })
    animation1.with = animation2
    return animation1
end





