

/obj/effect/map_entity/game_score
	name = "game_score"
	icon_state = "logic_counter"
	var/score = 0
	var/target_score = 100

/obj/effect/map_entity/game_score/proc/check_target()
	if(score >= target_score)
		fire_output("OnScoreReached", null, src)

/obj/effect/map_entity/game_score/receive_input(input_name, atom/activator, atom/caller, list/params)
	. = ..()
	if(.)
		return TRUE
	switch(lowertext(input_name))
		if("add")
			var/amount = text2num(params?["value"]) || 1
			score += amount
			fire_output("OnScoreChanged", activator, caller)
			check_target()
			return TRUE
		if("subtract")
			var/amount = text2num(params?["value"]) || 1
			score -= amount
			fire_output("OnScoreChanged", activator, caller)
			return TRUE
		if("set")
			score = text2num(params?["value"]) || 0
			fire_output("OnScoreChanged", activator, caller)
			check_target()
			return TRUE
		if("reset")
			score = 0
			fire_output("OnScoreChanged", activator, caller)
			return TRUE
		if("settarget")
			target_score = text2num(params?["value"]) || target_score
			return TRUE
	return FALSE


/obj/effect/map_entity/game_round_timer
	name = "game_round_timer"
	icon_state = "logic_timer"
	var/list/milestones = list()  
	var/list/milestones_fired = list()  
	var/running = FALSE
	var/start_time = 0

/obj/effect/map_entity/game_round_timer/Initialize()
	. = ..()
	for(var/m in milestones)
		milestones_fired += FALSE

/obj/effect/map_entity/game_round_timer/proc/start_timer()
	if(running)
		return
	running = TRUE
	start_time = world.time
	START_PROCESSING(SSobj, src)

/obj/effect/map_entity/game_round_timer/proc/stop_timer()
	running = FALSE
	STOP_PROCESSING(SSobj, src)

/obj/effect/map_entity/game_round_timer/proc/reset_timer()
	stop_timer()
	for(var/i = 1 to length(milestones_fired))
		milestones_fired[i] = FALSE
	start_time = 0

/obj/effect/map_entity/game_round_timer/Process()
	if(!running || !enabled)
		return
	var/elapsed = (world.time - start_time) / 10  
	for(var/i = 1 to length(milestones))
		if(milestones_fired[i])
			continue
		var/milestone_time = milestones[i]
		if(elapsed >= milestone_time)
			milestones_fired[i] = TRUE
			fire_output("OnMilestone", null, src)
			fire_output("OnMilestone[i]", null, src)  

/obj/effect/map_entity/game_round_timer/Destroy()
	stop_timer()
	return ..()

/obj/effect/map_entity/game_round_timer/receive_input(input_name, atom/activator, atom/caller, list/params)
	. = ..()
	if(.)
		return TRUE
	switch(lowertext(input_name))
		if("start")
			start_timer()
			return TRUE
		if("stop")
			stop_timer()
			return TRUE
		if("reset")
			reset_timer()
			return TRUE
		if("toggle")
			if(running)
				stop_timer()
			else
				start_timer()
			return TRUE
	return FALSE
