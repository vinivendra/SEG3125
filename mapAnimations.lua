


nextMapView = nil


function animateNextMap()
    print("animating next map")
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
    print("complete!")
    mapView:removeFromSuperview()
    mapView = nextMapView
    nextMapView = nil
    currentMapState = nextMapState
    -- nextMapState:begginingANimation()
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



