





/obj/effect/map_entity/color_correction
	name = "color_correction"
	icon_state = "colorcorrect" 
	is_brush = FALSE 
	
	
	var/mode = "global"
	var/color_val = "#FFFFFF" 
	var/list/entities_inside = null

	var/transition_time = 0 

	
	

/obj/effect/map_entity/color_correction/Initialize()
	. = ..()
	
	
	if(isnum(mode))
		switch(mode)
			if(0) mode = "global"
			if(1) mode = "input"
			if(2) mode = "brush"
	
	if(mode == "brush" || mode == "manual_brush")
		is_brush = TRUE
		if(mode == "brush")
			spawn(1)
				connect_brush_neighbors() 

	
	if(istext(color_val))
		if(findtext(color_val, "#"))
			return
		var/clean_val = color_val
		
		clean_val = replacetext(clean_val, "list(", "")
		clean_val = replacetext(clean_val, ")", "")
		clean_val = replacetext(clean_val, "\\", "")
		clean_val = replacetext(clean_val, "'", "")
		clean_val = replacetext(clean_val, "\n", "")
		clean_val = replacetext(clean_val, " ", "") 
		
		
		clean_val = replacetext(clean_val, ",", ";")
		
		if(findtext(clean_val, ";"))
			var/list/split_colors = splittext(clean_val, ";")
			var/list/matrix_list = list()
			for(var/val in split_colors)
				var/num_val = text2num(val)
				if(!isnull(num_val))
					matrix_list += num_val
			
			if(matrix_list.len == 20 || matrix_list.len == 16)
				color_val = matrix_list

	if(mode == "global" && enabled) 
		apply_global()

/obj/effect/map_entity/color_correction/Destroy()
	if(mode == "global" && enabled) 
		remove_global()
	if(entities_inside)
		for(var/mob/M in entities_inside)
			remove_from(M)
	return ..()

/obj/effect/map_entity/color_correction/receive_input(input_name, atom/activator, atom/caller, list/params)
	. = ..()
	if(.)
		return TRUE

	switch(lowertext(input_name))
		if("enable")
			enabled = TRUE
			if(mode == "global") apply_global()
			fire_output("OnEnable", activator, caller)
			return TRUE
		if("disable")
			enabled = FALSE
			if(mode == "global") remove_global()
			fire_output("OnDisable", activator, caller)
			return TRUE
		if("apply")
			if(mode == "input" && ishuman(activator))
				apply_to(activator)
			else if(mode == "manual_brush")
				apply_brush_manual()
			return TRUE
		if("remove")
			if(mode == "input" && ishuman(activator))
				remove_from(activator)
			else if(mode == "manual_brush")
				remove_brush_manual()
			return TRUE
		if("settime")
			transition_time = text2num(params["value"])
			return TRUE
	return FALSE

/obj/effect/map_entity/color_correction/Crossed(atom/movable/AM)
	. = ..()
	if(!enabled)
		return
	if(mode != "brush" && mode != "manual_brush")
		return
	if(!ishuman(AM))
		return
	
	LAZYADD(entities_inside, AM)
	
	if(mode == "brush")
		apply_to(AM)

/obj/effect/map_entity/color_correction/Uncrossed(atom/movable/AM)
	. = ..()
	if(mode != "brush" && mode != "manual_brush")
		return
	if(!ishuman(AM))
		return

	if(AM in entities_inside)
		LAZYREMOVE(entities_inside, AM)
		remove_from(AM)

/obj/effect/map_entity/color_correction/proc/apply_brush_manual()
	if(entities_inside)
		for(var/mob/M in entities_inside)
			apply_to(M)

/obj/effect/map_entity/color_correction/proc/remove_brush_manual()
	if(entities_inside)
		for(var/mob/M in entities_inside)
			remove_from(M)


/obj/effect/map_entity/color_correction/proc/apply_global()
	
	
	for(var/client/C in GLOB.clients)
		if(C.mob)
			apply_to(C.mob)
	
	

/obj/effect/map_entity/color_correction/proc/remove_global()
	for(var/client/C in GLOB.clients)
		if(C.mob)
			remove_from(C.mob)

/obj/effect/map_entity/color_correction/proc/apply_to(mob/M)
	if(!M.client) return
	
	if(transition_time > 0)
		animate(M.client, color = color_val, time = transition_time)
	else
		M.client.color = color_val
	
	if(transition_time > 0)
		animate(M.client, color = color_val, time = transition_time)
	else
		M.client.color = color_val
	
	fire_output("OnApply", M, src)

/obj/effect/map_entity/color_correction/proc/remove_from(mob/M)
	if(!M.client) return
	
	
	
	if(transition_time > 0)
		animate(M.client, color = null, time = transition_time)
	else
		M.client.color = null
	
	fire_output("OnRemove", M, src)
