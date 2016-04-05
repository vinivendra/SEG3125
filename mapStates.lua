
require 'mapState'
require 'mapAnimations'

mapState1 = MapState:new({
    map = {"########",
           "#______#",
           "########"},
    imageName = "stages/stage1-1.png",
    startingPosition = {2, 2},
    goalPosition = {2, 7},
    playerPosition = nil,
    playerOffset = {540, 360},
    attackEnabled = false,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = fadeRight,
    begginingAnimation = fadeInRight,
    entities = {}
    })

mapState2 = MapState:new({
    map = {"##______",
           "##______",
           "_____###",
           "##______"},
    imageName = "stages/stage1-2.png",
    startingPosition = {3, 1},
    goalPosition = {2, 7},
    playerPosition = nil,
    playerOffset = {540, 360}, --{545, 340},
    attackEnabled = false,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = fadeRight,
    begginingAnimation = fadeInRight,
    entities = {}
    })

mapState3 = MapState:new({
    map = {"__#_____",
           "________",
           "________"},
    imageName = "stages/stage1-3.png",
    startingPosition = {2, 1},
    goalPosition = {3, 8},
    playerPosition = nil,
    playerOffset = {180, 180},
    attackEnabled = true,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = masterSword,
    begginingAnimation = fadeInRight,
    entities = {
        ImageView:new({
            name = "master sword",
            x = 1720,
            y = 355,
            imageName = "individuals/masterSword.png",
            width = 100,
            height = 100
            }),
        ImageView:new({
            name = "monster",
            x = 3*180,
            y = 180 + 30,
            imageName = "individuals/enemyFoxFacingLeft.png",
            width = 100,
            height = 100,
            monsterPosition = {2, 3},
            isAlive = true
            })
    }
    })

mapState4 = MapState:new({
    map = {"_###___",
           "_______",
           "_###___"},
    imageName = "stages/stage2-1.png",
    mapSize = {2460, 900},
    startingPosition = {3, 1},
    goalPosition = {1, 6},
    playerPosition = nil,
    playerOffset = {3*180, 4*180},
    attackEnabled = true,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = fadeRight,
    begginingAnimation = fadeInRight,
    entities = {
        ImageView:new({
            name = "monster",
            x = 8*180,
            y = 3*180 + 30,
            imageName = "individuals/enemyFoxFacingLeft.png",
            width = 100,
            height = 100,
            monsterPosition = {2, 6},
            isAlive = true
            })
    }
    })


mapStates = {mapState1, mapState2, mapState3, mapState4}
