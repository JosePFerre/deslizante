local levels = require("levels")

function love.load()
	game = {}
	game.screen_width = 360
	game.screen_height = 640

	lg = love.graphics

	restartHeld = 0;
	curLevel = 1

	level = levels[curLevel]
	map = level.map

	player = {
		x = level.start[1] * 32,
		y = level.start[2] * 32,
		realX = level.start[1] * 32,
		realY = level.start[2] * 32,
		width = 32,
		moving = false,
		direction = "xd",
		speed = 10
	}

	function player:move(dt)
		if self.direction == "up" then
			if testCollision(0, -1) then
				self.y = self.y - 32
				self.moving = true
			end
		elseif self.direction == "down" then
			if testCollision(0, 1) then
      			self.y = self.y + 32
      			self.moving = true
      		end
		elseif self.direction == "right" then
			if testCollision(1, 0) then
				self.x = self.x + 32
				self.moving = true
			end
		elseif self.direction == "left" then
			if testCollision(-1, 0) then
				self.x = self.x - 32
				self.moving = true
			end
		end

		self.realY = self.realY - ((self.realY - self.y) * self.speed * dt)
		self.realX = self.realX - ((self.realX - self.x) * self.speed * dt)
	end
end

function love.update(dt)
	player:move(dt)
	testLevelDone()

	if love.keyboard.isDown("r") then
		keyboardHeld = keyboardHeld + dt;
		if keyboardHeld >= 1 then
			restartLevel()
		end
	else
		keyboardHeld = 0
	end
end

function love.keypressed( key ) 

   if key == "w" and not player.moving then
      player.direction = "up"
   elseif key == "s" and not player.moving then
      player.direction = "down"
   elseif key == "a" and not player.moving then
      player.direction = "left"
   elseif key == "d" and not player.moving then
      player.direction = "right"
   end
end

function love.draw()
	lg.push()

	--lg.scale(lg.getWidth() / game.screen_width)
	--lg.scale(lg.getHeight() / game.screen_height)

	lg.setBackgroundColor(0.3, 0.1, 0.3, 1)
	lg.setColor(0.2, 0.6, 0.6, 1)

    for i=1, #map do
    	for j=1, #map[i] do
    		if map[i][j] == 1 then
    			lg.setColor(0.2, 0.6, 0.6, 1)
    			lg.rectangle("line", j*32, i*32, 32, 32)
    		end
    		if map[i][j] == 2 then
    			lg.setColor(0.8, 0.6, 0.6, 1)
    			lg.rectangle("fill", j*32, i*32, 32, 32)
    		end
    		if map[i][j] == 3 then
    			lg.setColor(0.8, 0.2, 0.1, 1)
    			lg.rectangle("fill", j*32, i*32, 32, 32)
    		end
    		if map[i][j] == 4 then
    			lg.setColor(0, 0, 0, 0)
    			lg.rectangle("line", j*32, i*32, 32, 32)
    		end
    	end
    end

    lg.setColor(0.1, 0.8, 0.1, 1)
    lg.rectangle("fill", player.realX, player.realY, player.width, player.width)

    lg.print(player.realX/32 .. "   " .. player.realY/32 , 100, 10)
    lg.print(math.ceil(player.realX/32 - 0.9) .. "   " .. math.ceil(player.realY/32 - 0.9) , 0, 10)
    lg.print(map[(math.ceil(player.realY / 32 - 0.5))][(math.ceil(player.realX /32 - 0.5))], 200, 10)
    lg.print(level.name, 100, 0)
    lg.print(player.x/32 .. "   " .. player.y/32, 0, 20)
    lg.print(player.direction .. "   " .. tostring(player.moving))

    lg.pop()
end

function testCollision(x, y)
	if map[(player.y / 32) + y][(player.x /32) + x] == 1 or map[(player.y / 32) + y][(player.x /32) + x] == 4 then
		if map[(math.ceil(player.realY / 32 - 0.8)) + y][(math.ceil(player.realX /32 - 0.8)) + x] == 1 or
			map[(math.ceil(player.realY / 32 - 0.8)) + y][(math.ceil(player.realX /32 - 0.8)) + x] == 4 
			and (player.direction == "down" or player.direction == "right") then
			player.moving = false
		elseif map[(math.ceil(player.realY / 32 - 0.2)) + y][(math.ceil(player.realX /32 - 0.2)) + x] == 1 or
			map[(math.ceil(player.realY / 32 - 0.2)) + y][(math.ceil(player.realX /32 - 0.2)) + x] == 4 
			and (player.direction == "up" or player.direction == "left") then
			player.moving = false
		end
		return false
	end
	return true
end

function testLevelDone()
	if map[(math.ceil(player.realY / 32 - 0.5))][(math.ceil(player.realX /32 - 0.5))] == 3 then
		loadNextLevel()
	end
end

function loadNextLevel()
	curLevel = curLevel +1
	if levels[curLevel] then
		level = levels[curLevel]
		map = level.map

		player.x = level.start[1] * 32
		player.y = level.start[2] * 32
		player.realX = level.start[1] * 32
		player.realY = level.start[2] * 32
		player.moving = false
		player.direction = "xd"
	else
		level.name = "No more levels"
	end

end

function restartLevel()
	player.x = level.start[1] * 32
	player.y = level.start[2] * 32
	player.realX = level.start[1] * 32
	player.realY = level.start[2] * 32
	player.moving = false
	player.direction = "xd"
end