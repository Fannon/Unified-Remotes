local keyboard = libs.keyboard;
local server = libs.server;

--@help Navigate to start
actions.refresh = function()
    keyboard.stroke("f5");
end

--@help Navigate to start
actions.enter = function()
    keyboard.stroke("enter");
end

--@help Navigate to end
actions.escape = function()
    keyboard.stroke("escape");
end

--@help Show black screen
actions.black = function()
    keyboard.stroke("B");
end

--@help Show white screen
actions.white = function()
    keyboard.stroke("W");
end

--@help Navigate left
actions.left = function()
    keyboard.stroke("left");
end

--@help Navigate right
actions.right = function()
    keyboard.stroke("right");
end

--@help Navigate up
actions.up = function()
    keyboard.stroke("up");
end

--@help Navigate down
actions.down = function()
    keyboard.stroke("down");
end
