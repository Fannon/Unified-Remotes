local obj = nil;
local tid_update = -1;
local tid_timer = -1;

local timer = libs.timer;
local server = libs.server;
local fs = libs.fs;

local ready = false;


------------------------
-- BOOTSTRAP          --
------------------------

events.create = function ()
    file_curr = fs.temp();
end

events.destroy = function ()
    fs.delete(file_curr);
end

events.focus = function ()
    obj = luacom.CreateObject("PowerPoint.Application");
    update();
    tid_update = timer.interval(update, 1000);
    ready = false;
end

events.blur = function ()
    timer.cancel(tid_update);
    obj = nil;
    collectgarbage();
end


------------------------
-- FUNCTIONS          --
------------------------

function valid()
    return (obj ~= nil and
        obj.Presentations.Count > 0 and
        obj.SlideShowWindows.Count > 0);
end

function update ()
    local preview_curr = "";

    if (obj == nil) then
        ready = false;
    elseif (obj.Presentations.Count == 0 or obj.SlideShowWindows.Count == 0) then
        ready = false;
    else
        ready = true;
        local index = obj.ActivePresentation.SlideShowWindow.View.CurrentShowPosition;
        local slide = obj.ActivePresentation.Slides(index);

        -- Get previews
        slide:Export(file_curr, "jpg", 640, 360);
        preview_curr = file_curr;
    end

    server.update(
        { id = "preview_curr", image = preview_curr }
    );
end


------------------------
-- COMMANDS           --
------------------------

--@help Go to next slide
actions.next = function ()
    if (valid()) then
        obj.ActivePresentation.SlideShowWindow.View:Next();
        update();
    end
end

--@help Go to previous slide
actions.previous = function ()
    if (valid()) then
        obj.ActivePresentation.SlideShowWindow.View:Previous();
        update();
    end
end

--@help Set black screen
actions.black = function ()
    if (valid()) then
        obj.ActivePresentation.SlideShowWindow.View.State = 3; -- 3=black
    end
end

--@help Set white screen
actions.white = function ()
    if (valid()) then
        obj.ActivePresentation.SlideShowWindow.View.State = 4; -- 4=white
    end
end


------------------------
-- OLD STYLE COMMANDS --
------------------------

--@help Navigate left
actions.left = function()
    keyboard.stroke("left");
    update();
end

--@help Navigate right
actions.right = function()
    keyboard.stroke("right");
    update();
end

--@help Show black screen
actions.b = function()
    keyboard.stroke("B");
end

--@help Show white screen
actions.w = function()
    keyboard.stroke("W");
end
