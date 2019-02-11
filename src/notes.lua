local program = { args = {} }

function program:onEnter()
    if Settings.showNotes == "true" then Settings.showNotes = "false"
    else Settings.showNotes = "true" end
    Terminal:endProg()
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:update(dt) end
function program:draw() end
function program:keypressed(key) end
function program:textinput(key) end

return program
