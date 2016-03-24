require 'squareView'

-- MapView: View class ---------------------------------------

mapDictionary = {
    ["#"] = SquareView:new({
    name = "wall tile",
    color = {85, 159, 168},
    width = tileSize, height = tileSize
    }),
    ["_"] = SquareView:new({
    name = "floor tile",
    color = {13, 64, 79},
    width = tileSize, height = tileSize
    })
}

map = {"###_########",
       "###_########",
       "____##______",
       "###____#####",
       "############"}

MapView = View:new({})

function MapView:new(o)
    o = o or {}   -- create object if user does not provide one    
    setmetatable(o, self)
    self.__index = self

    o:init()

    for i=1,getSize(map) do
        line = map[i]
        for j = 1,#line do
            char = line:sub(j,j)
            tile = mapDictionary[char]:copy()
            tile.x = (j - 1) * tileSize
            tile.y = (i - 1) * tileSize
            o:addSubview(tile)
        end
    end

    return o
end
