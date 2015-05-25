local lure = require(select('1', ...):match(".-lure%.")..'init')

-- 
-- Define Class
--
local MouseEvent = lure.lib.upperclass:define('MouseEvent', lure.dom.Event)

--
-- Left Mouse Button.
--
property : MOUSE_BUTTON_LEFT {
    0;
    get='public';
    set='nobody';
    type='number';
}

--
-- Middle Mouse Button.
--
property : MOUSE_BUTTON_MIDDLE {
    1;
    get='public';
    set='nobody';
    type='number';
}

--
-- Right Mouse Button.
--
property : MOUSE_BUTTON_RIGHT {
    2;
    get='public';
    set='nobody';
    type='number';
}

--
-- Mouse Button x1.
--
property : MOUSE_BUTTON_X1 {
    3;
    get='public';
    set='nobody';
    type='number';
}

--
-- Mouse Button x2.
--
property : MOUSE_BUTTON_X2 {
    4;
    get='public';
    set='nobody';
    type='number';
}

--
-- Returns true if the alt key was down when the mouse event was fired.
--
property : altKey {
    false;
    get='public';
    set='protected';
    type='boolean';
}

--
-- The button number that was pressed when the mouse event was fired. 
--
property : button {
    -1;
    get='public';
    set='protected';
    type='number';
}

--
-- The buttons being pressed when the mouse event was fired
--
property : buttons {
    {};
    get='public';
    set='protected';
    type='table';
}

--
-- The X coordinate of the mouse pointer in local (DOM content) coordinates.
--
property : clientX {
    0;
    get='public';
    set='protected';
    type='number';
}

--
-- The Y coordinate of the mouse pointer in local (DOM content) coordinates.
--
property : clientY {}

--
-- Returns true if the control key was down when the mouse event was fired.
--
property : ctrlKey {}

--
-- Returns true if the meta key was down when the mouse event was fired.
--
property : metaKey {}

--
-- The X coordinate of the mouse pointer relative to the position of the last mousemove event.
--
property : movementX {}

--
-- The Y coordinate of the mouse pointer relative to the position of the last mousemove event.
--
property : movementY {}

--
-- The X coordinate of the mouse pointer relative to the position of the padding edge of the target node..
--
property : offsetX {}

--
-- The Y coordinate of the mouse pointer relative to the position of the padding edge of the target node.
--
property : offsetY {}

--
-- Returns the id of the hit region affected by the event. If no hit region is affected, null is returned
--
property : region {}

--
-- The secondary target for the event, if there is one.
--
property : relatedTarget {}

--
-- The X coordinate of the mouse pointer in global (screen) coordinates.
--
property : screenX {}

--
-- The Y coordinate of the mouse pointer in global (screen) coordinates.
--
property : screenY {}

--
-- Returns true if the shift key was down when the mouse event was fired.
--
property : shiftKey {}

--
-- The button being pressed when the mouse event was fired.
--
property : which {}

--
-- Class Constructor
--
function private:__construct(EVENT_TYPE, PARAMS) 
    self:__constructparent(EVENT_TYPE, PARAMS)
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(MouseEvent)