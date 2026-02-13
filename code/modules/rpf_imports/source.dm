#define FONT_COLOR "#ffffff"
#define FONT_STYLE "Arial Black"

/atom
	var/allowtooltip = TRUE

/turf/unsimulated/wall/hammereditor/dev1
	icon = 'icons/hammer/source.dmi'
	icon_state = "devwall1"
	name = "Dev Wall"
	desc = "A wall with pixel measurements.."

/turf/unsimulated/wall/hammereditor/dev2
	icon = 'icons/hammer/source.dmi'
	icon_state = "devwall2"
	name = "Dev Wall"
	desc = "A wall with pixel measurements.."

/turf/unsimulated/wall/hammereditor/dev3
	icon = 'icons/hammer/source.dmi'
	icon_state = "devwall3"
	name = "Dev Wall"
	desc = "A wall with pixel measurements.."

/turf/unsimulated/wall/hammereditor/dev1
	icon = 'icons/hammer/source.dmi'
	icon_state = "devwall1"
	name = "Dev Wall"
	desc = "A wall with pixel measurements.."


/turf/unsimulated/floor/hammereditor/dev1
	icon = 'icons/hammer/source.dmi'
	icon_state = "devturf1"
	name = "Dev Turf"
	desc = "A floor with pixel measurements.."

/turf/unsimulated/floor/hammereditor/dev12
	icon = 'icons/hammer/source.dmi'
	icon_state = "devturf2"
	name = "Dev Turf"
	desc = "A floor with pixel measurements.."

/turf/unsimulated/floor/hammereditor/dev2
	icon = 'icons/hammer/source.dmi'
	icon_state = "devturf3"
	name = "Dev Turf"
	desc = "A floor with pixel measurements.."

/turf/unsimulated/floor/hammereditor/dev22
	icon = 'icons/hammer/source.dmi'
	icon_state = "devturf4"
	name = "Dev Turf"
	desc = "A floor with pixel measurements.."

/obj/effect/map_entity/dev_text
	icon = 'icons/hammer/source.dmi'
	icon_state = "dev_text"
	desc = "Think of it as like.. code comments, but in maps!"
	layer = 9999
	anchored = TRUE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE

	var/fixtext = ""
	var/list/text_lines = list()
	var/show_always = FALSE

/obj/effect/map_entity/dev_text/Initialize()
	. = ..()

	if(fixtext)
		text_lines = splittext(fixtext, ";")

	if(!show_always)
		invisibility = 0
		return

/obj/effect/map_entity/dev_text/Click()
	if(!usr.client.holder)
		return
	var/dat = "<html><head></head><body>"
	if(text_lines.len)
		for(var/line in text_lines)
			dat += "[line]<br>"
	else
		dat += "<i>No text content.</i>"
	dat += "</body></html>"
	usr << browse(dat, "window=dev_text_[ref(src)];size=400x400")

/obj/effect/map_entity/dev_text/receive_input(input_name, atom/activator, atom/caller, list/params)
	. = ..()
	if(.)
		return TRUE
	switch(lowertext(input_name))
		if("settext")
			if(params?["value"])
				text_lines = list(params["value"])
			return TRUE
		if("addline")
			if(params?["value"])
				text_lines += params["value"]
			return TRUE
		if("clear")
			text_lines = list()
			return TRUE
	return FALSE

/obj/effect/map_entity/nodraw
	icon = 'icons/hammer/source.dmi'
	icon_state = "nodraw"
	alpha = 0
	density = TRUE
	opacity = FALSE
	anchored = TRUE

/obj/effect/map_entity/nodraw/deco
	icon = 'icons/obj/worldbuilding.dmi'
	alpha = 255
	plane = ABOVE_OBJ_PLANE
	density = FALSE
	invisibility = 0

/obj/effect/map_entity/nodraw/deco/bars
	icon_state = "bars"

/obj/effect/map_entity/nodraw/deco/shadowpaint
	icon_state = "shadow"

/obj/effect/map_entity/nodraw/deco/shutter_half
	icon_state = "mostly_open_shuitter"

/obj/effect/map_entity/nodraw/deco/shutter_quarter
	icon_state = "slightly_open_shutter"

/obj/hammereditor
	allowtooltip = FALSE
	layer = 9999
	mouse_opacity = 0

/obj/hammereditor/blocks_airlock()
	return 0

/obj/hammereditor/New()
	layer = -9999
	icon_state = ""
	name = ""
	desc = ""

/obj/effect/map_entity/clip/player
	icon = 'icons/hammer/source.dmi'
	icon_state = "playerclip"
	alpha = 255
	density = 1
	opacity = 0
	anchored = 1
	throwpass = TRUE

/obj/effect/map_entity/clip/player/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return 1
	if(!ishuman(mover))
		return 1
	var/mob/living/carbon/human/H = mover
	if(H.client)
		return 0