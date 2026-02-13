GLOBAL_LIST_EMPTY(special_cryospawns)  
GLOBAL_LIST_EMPTY(all_cryospawns)      
GLOBAL_LIST_EMPTY(team_cryospawns)     

/obj/structure/soldiercryo/special
	icon_state = "cryo_loaded-gray"
	empty_state = "cryo_used-gray"
	density = TRUE
	var/id                    
	var/team                  
	var/enabled = TRUE        

/obj/structure/soldiercryo/special/Initialize()
	. = ..()
	
	if(!length(GLOB.all_cryospawns[id]))
		GLOB.all_cryospawns[id] = list()
	GLOB.all_cryospawns[id] += src

	
	if(enabled)
		
		if(!length(GLOB.special_cryospawns[id]))
			GLOB.special_cryospawns[id] = list()
		GLOB.special_cryospawns[id] += src

		
		if(team)
			if(!length(GLOB.team_cryospawns[team]))
				GLOB.team_cryospawns[team] = list()
			GLOB.team_cryospawns[team] += src

/obj/structure/soldiercryo/special/Destroy()
	
	if(length(GLOB.all_cryospawns[id]))
		GLOB.all_cryospawns[id] -= src
	if(length(GLOB.special_cryospawns[id]))
		GLOB.special_cryospawns[id] -= src
	if(team && length(GLOB.team_cryospawns[team]))
		GLOB.team_cryospawns[team] -= src
	. = ..()


/obj/structure/soldiercryo/special/proc/enable_spawn()
	if(enabled)
		return
	enabled = TRUE

	
	if(!length(GLOB.special_cryospawns[id]))
		GLOB.special_cryospawns[id] = list()
	GLOB.special_cryospawns[id] |= src

	
	if(team)
		if(!length(GLOB.team_cryospawns[team]))
			GLOB.team_cryospawns[team] = list()
		GLOB.team_cryospawns[team] |= src


/obj/structure/soldiercryo/special/proc/disable_spawn()
	if(!enabled)
		return
	enabled = FALSE

	
	if(length(GLOB.special_cryospawns[id]))
		GLOB.special_cryospawns[id] -= src

	
	if(team && length(GLOB.team_cryospawns[team]))
		GLOB.team_cryospawns[team] -= src

/obj/structure/soldiercryo/special/MouseDrop_T(mob/target, mob/user)
	return

/obj/structure/soldiercryo/special/attackby(obj/item/grab/normal/G, user)
	return


/obj/structure/soldiercryo/special/red
	id = RED_TEAM
	team = RED_TEAM


/obj/structure/soldiercryo/special/blue
	id = BLUE_TEAM
	team = BLUE_TEAM



/obj/structure/soldiercryo/special/red/forward
	id = "red_forward"
	enabled = FALSE  

/obj/structure/soldiercryo/special/blue/forward
	id = "blue_forward"
	enabled = FALSE  
