require 'view'

-- MapView: View class ---------------------------------------

tileSize = 66.6666

mapDictionary = {
    ["#"] = SquareView:new({
    name = "wall tile",
    color = {174, 122, 66},
    width = tileSize, height = tileSize
    }),
    ["_"] = SquareView:new({
    name = "floor tile",
    color = {200, 200, 200},
    width = tileSize, height = tileSize
    })
}

map = {"###_########",
       "###_########",
       "____##______",
       "###_##_#####",
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
