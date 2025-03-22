local customWindow = {}
local roomUtils = require("scripts.RoomUtils")

local game = Game()
local showCustomWindow = false

local windowSprite = Sprite()
windowSprite:Load("gfx/ui/white.anm2", true)
windowSprite:Play("Idle")

function customWindow:onRender()
    if(roomUtils:isInCharacterSelect()) then
        if Input.IsButtonTriggered(Keyboard.KEY_X,0) then
            showCustomWindow = not showCustomWindow
        end

        if showCustomWindow then
            local center = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
            local size = Vector(400, 300)
            local position = center - (size / 2)
            local color = KColor(0, 0, 0, 0.75)

            windowSprite.Scale = Vector(size.X / 32, size.Y / 32)
            windowSprite.KColor = color ---@diagnostic disable-line: inject-field

            windowSprite:Render(position)

            Isaac.RenderScaledText("My Custom Window", position.X + 20, position.Y + 15, 1.2, 1.2, 1, 1, 1, 1)
        end
    end
end