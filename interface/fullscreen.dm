mob
	var/_fullscreen

client
	var/_fullscreen

mob/Login()
	..()
	if(client._fullscreen) //Keep the window in  fullscreen, just in case someone closes the game or.. Something.
		FullScreen(client._fullscreen)

mob/verb/FullScreen(var/FC as num)
	if(FC)
		_fullscreen = FC
	else
		_fullscreen = !_fullscreen
		if(client)
			client._fullscreen = _fullscreen

	winset(src,"menu","Titlebar=[_fullscreen ? "true" : "false"]")
	winset(src,"menu","can-resize=[_fullscreen ? "true" : "false"]")
	winset(src,"menu","is-maximized=[_fullscreen ? "true" : "false"]")



