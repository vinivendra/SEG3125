
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
    loopEnabled = true,
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
    loopEnabled = true,
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
    attackEnabled = false,
    loopEnabled = true,
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
    getEndingAnimation = fadeUp,
    begginingAnimation = fadeInUp,
    shouldRestart = true,
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

mapState5 = MapState:new({
    map = {"#_#",
           "#_#",
           "#_#",
           "#_#"},
    imageName = "stages/stage2-2.png",
    mapSize = {2460, 900},
    startingPosition = {4, 2},
    goalPosition = {1, 2},
    playerPosition = nil,
    playerOffset = {5*180 + 540, 4*180},
    attackEnabled = true,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = fadeUp,
    begginingAnimation = fadeInUp,
    entities = {
        ImageView:new({
            name = "monster",
            x = 5*180 + 540 + 30,
            y = 2*180 + 90,
            imageName = "individuals/enemyFoxFacingLeft.png",
            width = 100,
            height = 100,
            monsterPosition = {2, 2},
            isAlive = true
            }),
        ImageView:new({
            name = "monster",
            x = 5*180 + 540 + 30,
            y = 1*180 + 90,
            imageName = "individuals/enemyFoxFacingLeft.png",
            width = 100,
            height = 100,
            monsterPosition = {1, 2},
            isAlive = true
            })
    }
    })


mapStates = {mapState1, mapState2, mapState3, mapState4, mapState5}
