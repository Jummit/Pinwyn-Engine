os.loadAPI("engine")

elements = {
  player = {
    fruits = 0,
    path = "player.nfp",
    x = 10, y = 10,
    moves = {
      up =  {0, -1},
      down= {0,  1},
      left= {-1, 0},
      right={1,  0}
    },
    draw = function(self)
      term.setBackgroundColor(colors.lightBlue)
      term.setTextColor(colors.blue)
      term.setCursorPos(1, 1)
      term.write("Fruits collected: "..self.fruits)
      paintutils.drawPixel(self.x, self.y, colors.blue)
    end,
    update = function(self)
      for key, move in pairs(self.moves) do
        if engine.keyboard[key] then
          self:moveTo(elements.tilemap, move[1], move[2])
        end
      end
      elements.tilemap.lightSource.x = self.x
      elements.tilemap.lightSource.y = self.y
      if elements.tilemap[self.x][self.y].tile == "fruit" then
        elements.tilemap:setTile(self.x, self.y, "floor")
        self.fruits = self.fruits + 1
      end
    end
  },
  tilemap = engine.elements.tilemap({
    dynamicLight = false,
    lightUpdateTime=1,
    lightSource = {x=3, y=3},
    tileset = {
      floor = {bc=colors.green,tc=colors.gray,char=" "},
      grass = {bc=colors.green,tc=colors.lime,char="\""},
      wall = {bc=colors.gray,tc=colors.lightGray,char=" ",solid=true},
      fruit = {bc=colors.red,tc=colors.orange,char="o",solid=false}
    },
    generate = function(self)
      elements.tilemap:setRectangle(1, 1, engine.width, engine.height, "floor")
      for x = 1, 20 do
        self:setTile(math.random(1, engine.width), math.random(1, engine.height), "fruit")
      end
      for x = 1, #self do
        for y = 1, #self[x] do
          if math.random(1, 10) == 1 then
            self:setTile(x, y, "grass")
          end
        end
      end
      for i = 1, 10 do
        elements.tilemap:setRectangle(math.random(1, engine.width-4), math.random(1, engine.height-3), 3, 2, "wall")
      end
    end
  })
}

while not exit do
  engine.update(elements, 0.06, function()
    if engine.keyboard.q then exit = true end
  end)
  engine.draw(elements)
end
engine.quit()
