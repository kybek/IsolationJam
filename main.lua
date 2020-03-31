local table = {}

function save_table()
  if table == {} then
    return
  end

  local x0 = 1000
  local x1 = 0
  local y0 = 1000
  local y1 = 0

  for x, v in pairs(table) do
    for y, v2 in pairs(v) do
      x0 = math.min(x0, x)
      x1 = math.max(x1, x)
      y0 = math.min(y0, y)
      y1 = math.max(y1, y)
    end
  end

  local output_t = {}

  for x, v in pairs(table) do
    for y, v2 in pairs(v) do
      local x2 = (x - x0) / 20
      local y2 = (y - y0) / 20
      if output_t[x2] == nil then
        output_t[x2] = {}
      end
      output_t[x2][y2] = v2
    end
  end

  local output = "["

  for x = 0, (x1 - x0) / 20, 1 do
    local row = '"'
    for y = 0, (y1 - y0) / 20, 1 do
      local c = "."
      if output_t[x] ~= nil and output_t[x][y] ~= nil then
        c = output_t[x][y]
      else
        c = "."
      end
      row = row .. c
    end
    row = row .. '"'
    if output ~= "[" then
      output = output .. ", "
    end
    output = output .. row
  end

  output = output .. "]"
  print((x1 - x0) / 20 + 1, (y1 - y0) / 20 + 1, output)
end

function love.load()
	for i = 1, 20, 1 do
		table[i * 20] = {}
		for j = 1, 20, 1 do
			table[i * 20][j * 20] = "t"
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    save_table()
    return
  end
  local x, y = love.mouse.getPosition()
  x = x - x % 20
  y = y - y % 20
  print(x, y)
  if table[x] == nil then
    table[x] = {}
  end
  if scancode == "backspace" then
    table[x][y] = nil
  else
    table[x][y] = scancode
  end
end

function love.draw()
  for x, v in pairs(table) do
    for y, v2 in pairs(v) do
      love.graphics.print(v2, x, y)
    end
  end
end