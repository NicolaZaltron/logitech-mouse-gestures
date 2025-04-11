--[[
Author:		Nic
Version:	0.1 
Date:		2024-12-05

Special credits to:
- https://github.com/wookiefriseur/LogitechMouseGestures
- https://github.com/mark-vandenberg/g-hub-mouse-gestures

This script let's you use simple mouse gestures for Windows 7 and above.
The gestures use before and after comparisons of mouse pointer positions.

To execute a gesture move the mouse pointer while holding the special button:
* up to maximise active window 		(Alt+Space -> x)
* down to minimise active window	(Alt+Space -> n)
* left to move window to the left	(Winkey+Left)
* right to move window to the right	(Winkey+Right)
* if enabled: don't move to reset the window	(Alt+Space -> w)

Mouse buttons:
1=M1,2=M2,3=MMB and so on. For G-buttons use their respective numbers 1:1. 
--]]

button_number = 4; -- Change to your mouse button number
threshold_x = 5000; -- Change thresholds for x and y to set
threshold_y = 5000; -- the min distance needed for a gesture
show_console_output = true;

-- Default delay between keypresses in milliseconds
delay = 20

-- enable / disable gestures
click_on = false;
up_on = true;
down_on = true;
left_on = true;
right_on = true;

-- inits
pos_x_start, pos_y_start = 0, 0;
pos_x_end, pos_y_end = 0, 0;
pos_string = "";
diff_string = "";

showing_all_open_apps = false;

-- Event listener
function OnEvent(event, arg, family)
	if event == "MOUSE_BUTTON_PRESSED" and arg == button_number then
		Sleep(30);
		pos_x_start, pos_y_start = GetMousePosition();
		Sleep(20);
		-- Console output text
		pos_string = "x: " .. pos_x_start .. " y: " .. pos_y_start;
	end

	if event == "MOUSE_BUTTON_RELEASED" and arg == button_number then
		-- Sleep(30);
		pos_x_end, pos_y_end = GetMousePosition();
		-- Sleep(20);
		diff_x = pos_x_end - pos_x_start;
		diff_y = pos_y_start - pos_y_end;
		-- Console output text
		pos_string = "x: " .. pos_x_end .. " y: " .. pos_y_end;
		diff_string = "x: " .. diff_x .. " y: " .. diff_y;

		-- OutputLogMessage("[DEBUG]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);

		-- Actions
		if math.abs(diff_y) < threshold_y and math.abs(diff_x) < threshold_x then mouseJustClicked() end
		if diff_y > threshold_y and math.abs(diff_x) < threshold_x then mouseMovedUp() end
		if diff_y < -threshold_y and math.abs(diff_x) < threshold_x then mouseMovedDown() end
		if diff_x < -threshold_x and math.abs(diff_y) < threshold_y then mouseMovedLeft() end
		if diff_x > threshold_x and math.abs(diff_y) < threshold_y then mouseMovedRight() end		
	end
-- OutputLogMessage("event = %s, arg = %s, family=%s\nPosition = %s, Movement= %s \n", event, arg, family,pos_string,diff_string); --debug
end

--Movement actions to call proper gesture
function mouseMovedLeft()
	if left_on then
		-- gestureMoveLeft()
		gesturePreviousDesktop()
	end
end

function mouseMovedRight()
	if right_on then
		-- gestureMoveRight()
		gestureNextDesktop()
	end
end

function mouseMovedUp()
	if up_on then
		-- gestureMaximize()
		gestureShowAllOpenApps()
	end
end

function mouseMovedDown()
	if down_on then
		-- gestureMinimize()
		gestureShowAllDesktops()
	end
end

function mouseJustClicked()
	if click_on then
		gestureReset()
	end
	if showing_all_open_apps then
		gestureEscape()
		showing_all_open_apps = false;
	end
end

-- Gesture actions
function gestureMaximise()
	pressTwoKeys("lalt","spacebar",delay);
	PressAndReleaseKey("x");
	if show_console_output then
	 	OutputLogMessage("[MAXIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureReset()
	pressTwoKeys("lalt","spacebar",delay);
	Sleep(20);
	PressAndReleaseKey("w");
	if show_console_output then
		OutputLogMessage("[RESET]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMinimize()
	pressTwoKeys("lalt","spacebar",delay);
	Sleep(20);
	PressAndReleaseKey("n");
	Sleep(20);
	PressAndReleaseKey("enter"); -- workaround for Chrome
	if show_console_output then
	 	OutputLogMessage("[MINIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMoveLeft()
	pressTwoKeys("lgui","left",delay);
	if show_console_output then
	 	OutputLogMessage("[MOVE LEFT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMoveRight()
	pressTwoKeys("lgui","right",delay);
	if show_console_output then
	 	OutputLogMessage("[MOVE RIGHT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureNextDesktop()
	pressThreeKeys("lctrl","lgui","right",delay);
	if show_console_output then
	 	OutputLogMessage("[NEXT DESKTOP]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gesturePreviousDesktop()
	pressThreeKeys("lctrl","lgui","left",delay);
	if show_console_output then
	 	OutputLogMessage("[PREVIOUS DESKTOP]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureShowAllOpenApps()
	if not showing_all_open_apps then
		pressThreeKeys("lctrl","lalt","tab",delay);
		showing_all_open_apps = true;
	else
		gestureEscape();
		showing_all_open_apps = false;
	end
	if show_console_output then
	 	OutputLogMessage("[SHOW ALL OPEN APPS]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureShowAllDesktops()
	if not showing_all_open_apps then
		pressTwoKeys("lgui","tab",delay);
		showing_all_open_apps = true;
	else
		gestureEscape();
		showing_all_open_apps = false;
	end
	if show_console_output then
	 	OutputLogMessage("[SHOW ALL DESKTOPS]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureNewTab()
	pressTwoKeys("lctrl","t",delay);
	if show_console_output then
	 	OutputLogMessage("[NEW TAB]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureEscape()
	pressKeys("escape","","","","",delay);
	OutputLogMessage("[ESCAPE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
end

-- Helper functions

function pressOneKey(key,ms)
	PressKey(key);
	Sleep(ms);
	ReleaseKey(key);
end

function pressTwoKeys(key1,key2,ms)
	PressKey(key1);
	Sleep(ms);
	PressKey(key2);
	Sleep(ms);
	ReleaseKey(key2);
	ReleaseKey(key1);
end

function pressThreeKeys(key1,key2,key3,ms)
	PressKey(key1);
	Sleep(ms);
	PressKey(key2);
	Sleep(ms);
	PressKey(key3);
	Sleep(ms);
	ReleaseKey(key2);
	ReleaseKey(key1);
	ReleaseKey(key3);
end

function pressKeys(key1,key2,key3,key4,key5,ms)
	if string.len(key1) > 0 then
		PressKey(key1);
		Sleep(ms);
	end
	if string.len(key2) > 0 then
		PressKey(key2);
		Sleep(ms);
	end
	if string.len(key3) > 0 then
		PressKey(key3);
		Sleep(ms);
	end
	if string.len(key4) > 0 then
		PressKey(key4);
		Sleep(ms);
	end
	if string.len(key5) > 0 then
		PressKey(key5);
		Sleep(ms);
	end
	if string.len(key1) > 0 then ReleaseKey(key1); end
	if string.len(key2) > 0 then ReleaseKey(key2); end
	if string.len(key3) > 0 then ReleaseKey(key3); end
	if string.len(key4) > 0 then ReleaseKey(key4); end
	if string.len(key5) > 0 then ReleaseKey(key5); end
end