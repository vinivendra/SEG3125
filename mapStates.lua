
require 'mapState'

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
    conditionEnabled = false
    })

mapState2 = MapState:new({
    map = {"________",
           "_____###",
           "________"},
    imageName = "stages/stage1-2.png",
    startingPosition = {2, 2},
    goalPosition = {2, 7},
    playerPosition = nil,
    playerOffset = {540, 360}, --{545, 340},
    attackEnabled = false,
    loopEnabled = false,
    conditionEnabled = false
    })

mapState3 = MapState:new({
    map = {"##########",
           "__________",
           "__________"},
    imageName = "stages/stage1-3.png",
    startingPosition = {2, 2},
    goalPosition = {2, 15},
    playerPosition = nil,
    playerOffset = {180, 180},
    attackEnabled = false,
    loopEnabled = false,
    conditionEnabled = false
    })
