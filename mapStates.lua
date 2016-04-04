
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
    attackEnabled = false,
    loopEnabled = false,
    conditionEnabled = false,
    getEndingAnimation = masterSword,
    begginingAnimation = fadeInRight,
    entities = {
        ImageView:new({
            x = 1720,
            y = 355,
            imageName = "individuals/masterSword.png",
            width = 100,
            height = 100
            })
    }
    })

mapStates = {mapState1, mapState2, mapState3}
