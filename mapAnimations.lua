


nextMapView = nil


function animateNextMap()
    if nextMapState == nil then
        return
    end

    if nextMapState == mapState5 then
        nextMapView = nextMapState:createView()
        view:addSubview(nextMapView)
        nextMapView.x = 0
        nextMapView.y = -900

        local animation1 = OriginAnimation:new({
            destinationX = -540,
            destinationY = 900,
            subject = mapView
            })
        local animation2 = OriginAnimation:new({
            destinationX = -540,
            destinationY = 0,
            subject = nextMapView,
            completion = completeMapAnimation
            })
        startAnimation(animation1)
        startAnimation(animation2)
    else
        nextMapView = nextMapState:createView()
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
end

function completeMapAnimation()
    if mapStateIndex >= getSize(mapStates) then
        return
    end

    mapView:removeFromSuperview()

    mapStateIndex = mapStateIndex + 1

    currentMapState = nextMapState
    nextMapState = mapStates[mapStateIndex + 1]

    mapView = nextMapView
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

    currentMapState:begginingAnimation()
end


function fadeUp(self)
    local displacementX = moveUp[1] * tileSize
    local displacementY = moveUp[2] * tileSize

    local animation0 = StopAnimation:new({
        subject = player,
        imageName = "individuals/linkSuccess.png"
        })

    local animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveUpSpriteFunction
        })
    animation0:chain(animation1)

    local animation2 = AlphaAnimation:new({
        subject = player,
        duration = 0.5,
        completion = animateNextMap
        })
    animation1.with = animation2
    return animation0
end

function fadeRight(self)
    local displacementX = moveRight[1] * tileSize
    local displacementY = moveRight[2] * tileSize

    local animation0 = StopAnimation:new({
        subject = player,
        imageName = "individuals/linkSuccess.png"
        })

    local animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveRightSpriteFunction
        })
    animation0:chain(animation1)

    local animation2 = AlphaAnimation:new({
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

    local animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveRightSpriteFunction,
        completion = beginRunningActions
        })

    local animation21 = DelayAnimation:new({
        duration = 0.5
        })

    local animation22 = AlphaAnimation:new({
        subject = player,
        duration = 0.5
        })
    animation21:chain(animation22)

    startAnimation(animation21)
    startAnimation(animation1)
end

function fadeInUp(self)
    player.x = player.x - moveUp[1] * tileSize
    player.y = player.y - moveUp[2] * tileSize

    local displacementX = moveUp[1] * tileSize
    local displacementY = moveUp[2] * tileSize

    local animation1 = MoveAnimation:new({
        subject = player,
        displacementX = displacementX,
        displacementY = displacementY,
        willStart = moveUpSpriteFunction,
        completion = beginRunningActions
        })

    local animation21 = DelayAnimation:new({
        duration = 0.5
        })

    local animation22 = AlphaAnimation:new({
        subject = player,
        duration = 0.5
        })
    animation21:chain(animation22)

    startAnimation(animation21)
    startAnimation(animation1)
end

function masterSword(self)
    local sword = currentMapState.entities[1]

    local animationS1 = MoveAnimation:new({
        subject = sword,
        displacementX = 0,
        displacementY = -100,
        duration = 0.5
        }) 
    local animationS2 = AlphaAnimation:new({
        subject = sword,
        duration = 0.5
        })

    --
    local animation0 = MoveAnimation:new({
        subject = player,
        displacementX = 130,
        displacementY = -10,
        duration = 1
        }) 

    local animation01 = DelayAnimation:new({
        subject = player,
        duration = 1,
        willStart = successSpriteFunction
        })

    local animation1 = DelayAnimation:new({
        subject = player,
        duration = 0.5,
        willStart = moveRightSpriteFunction
        })

    local animation2 = DelayAnimation:new({
        subject = player,
        duration = 2,
        willStart = swordSpriteFunction
        })

    local endAnimation = fadeRight()

    animation0:chain(animation01) 
    animation01:chain(animation1) 
    animation1.with = animationS1
    animationS1.with = animationS2
    animation1:chain(animation2)
    animation2:chain(endAnimation)

    return animation0
end




