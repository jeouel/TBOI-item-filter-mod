local roomUtils = {}
local game = Game()

function roomUtils:isInCharacterSelect()
    return game:GetRoom():GetType() == RoomType.ROOM_DEFAULT and game:GetFrameCount() <= 0
end


return roomUtils