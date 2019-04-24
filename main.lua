display.setDefault ( "background", 53/255, 235/255, 242/255)

local physics = require( "physics" )

local playerBullets = {}

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local rightWall = display.newRect( 320, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
rightWall.alpha = 0.0
physics.addBody( rightWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround = display.newImage( "Assets/land.png" )
theGround.x = display.contentCenterX
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local shoot = display.newImageRect( "Assets/shoot.png", 50, 50 )
shoot.x = 275
shoot.y = 475
shoot.id = "shoot button"

local dPad = display.newImageRect( "Assets/dpad.png", 200, 200 )
dPad.x = 160
dPad.y = display.contentHeight - 75
dPad.id = "d-pad"

local upArrow = display.newImageRect( "Assets/upArrow.png", 50, 30)
upArrow.x = 160
upArrow.y = display.contentHeight - 148
upArrow.id = "up arrow"

local downArrow = display.newImageRect( "Assets/downArrow.png", 50, 30)
downArrow.x = 160
downArrow.y = display.contentHeight - 2
downArrow.id = "down arrow"

local rightArrow = display.newImageRect( "Assets/rightArrow.png", 30, 50)
rightArrow.x = 233
rightArrow.y = display.contentHeight - 75
rightArrow.id = "right arrow"

local leftArrow = display.newImageRect( "Assets/leftArrow.png", 30, 50)
leftArrow.x = 87
leftArrow.y = display.contentHeight - 75
leftArrow.id = "right arrow"

local jumpButton = display.newImageRect( "Assets/jumpButton.png", 65, 65 )
jumpButton.x = 160
jumpButton.y = 400
jumpButton.id = "jump button"

local theCharacter = display.newImageRect( "Assets/bastion.png", 150, 150 )
theCharacter.x = display.contentCenterX
theCharacter.y = display.contentCenterY
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
 
function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = 160
        theCharacter.y = 240
    end
end

function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 in the x direction 
            y = -50, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character down
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 in the x direction 
            y = 50, -- move down 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character right
        transition.moveBy( theCharacter, { 
            x = 50, -- move right 50 pixels 
            y = 0, -- move 0 pixels in the y direction
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character left
        transition.moveBy( theCharacter, { 
            x = -50, -- move left 50 pixels 
            y = 0, -- move 0 in the y direction
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        theCharacter:setLinearVelocity( 0, -750 )
    end

    return true
end

function shoot:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImageRect( "Assets/bullet.png", 25, 50 )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 0, 300 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

local function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 , -1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

upArrow:addEventListener( "touch", upArrow )

downArrow:addEventListener( "touch", downArrow )

rightArrow:addEventListener( "touch", rightArrow)

leftArrow:addEventListener( "touch", leftArrow)

jumpButton:addEventListener( "touch", jumpButton )

shoot:addEventListener( "touch", shootTouch )

Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )