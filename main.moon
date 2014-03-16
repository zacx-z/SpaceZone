physicsWorld = nil

class Ship
    new: =>
        x = love.graphics.getWidth! / 2
        y = love.graphics.getHeight! / 2
        @radius = 50

        with love.physics
            @body = .newBody physicsWorld, x, y, "dynamic"
            @fix = .newFixture @body, .newCircleShape @radius
            @body\setMass 1
            -- @body\setLinearDamping 1

            @fix\setUserData @
    draw: =>
        x, y = @body\getPosition!
        with love.graphics
            .setColor {255, 180, 180}
            .circle "fill", x, y, @radius

    getPosition: => @body\getPosition!

class Setting1
    down: => love.keyboard.isDown 'down'
    left: => love.keyboard.isDown 'left'
    right: => love.keyboard.isDown 'right'
    color: {0, 255, 0}
    initialAngle: 0

class Setting2
    down: => love.keyboard.isDown 's'
    left: => love.keyboard.isDown 'a'
    right: => love.keyboard.isDown 'd'
    color: {0, 0, 255}
    initialAngle: math.pi

class Ejector
    new: (ship, setting) =>
        @ship = ship
        @angle = setting.initialAngle
        @setting = setting
    draw: =>
        shipX, shipY = @ship\getPosition!
        with love.graphics
            .setColor @setting.color
            .push!
            .translate shipX, shipY
            .rotate @angle
            .rectangle "fill", -@ship.radius - 10, -10, 30, 20
            .pop!
    update: =>
        with love.keyboard
            if @setting\down!
                @ship.body\applyForce 200 * (math.cos @angle), 200 * (math.sin @angle)
            if @setting\left!
                @angle += 0.05
            if @setting\right!
                @angle -= 0.05

export ship = nil
export ejectors = nil

love.load = ->
    physicsWorld = love.physics.newWorld!
    ship = Ship!
    ejectors = {(Ejector ship, Setting1!), (Ejector ship, Setting2!)}

love.update = (dt) ->
    physicsWorld\update dt
    for e in *ejectors
        e\update!

love.draw = ->
    ship\draw!
    e\draw! for e in *ejectors