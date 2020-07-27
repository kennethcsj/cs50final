--[[
    GD50
    
    MapIntro Class
]]

MapIntro = Class{}

function MapIntro:init(playState, player)
    gSounds['dream-music']:setLooping(true)
    gSounds['dream-music']:play()

    self.player = player
    self.playState = playState

    self.camX = 0
    self.camY = 0

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }

    self.player.stateMachine:change('idle')
end

function MapIntro:update(dt)
    -- Introduction to the game
    gStateStack:push(DialogueState("" .. 
        "Chosen One.. " .. "Your world has been plagued with a flu virus and is on the verge of falling apart. " ..
        "We have brought you to the past to prevent the spread of the virus. " .. 
        "Keep fighting and do not give up!! ", self.camX, self.camY, 'left', function()
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                gSounds['dream-music']:stop()

                self.playState.level = MapHome(self.playState, self.player)
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function() end))
            end))
        end
    ))
end

function MapIntro:render()
    -- translate the entire view of the scene to emulate a camera
    love.graphics.clear(0, 0, 0, 255)

    self.player:render()
end
