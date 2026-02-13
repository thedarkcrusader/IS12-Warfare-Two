/obj/effect/lingering_haze
	name = "dust haze"
	desc = "A cloud of dust and debris kicked up by an explosion."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER + 1
	anchored = TRUE
	mouse_opacity = 0
	alpha = 0

/obj/effect/lingering_haze/Initialize(mapload, duration = 20)
	. = ..()
	pixel_x = rand(-32, 32)
	pixel_y = rand(-32, 32)
	transform = matrix() * rand(2.0, 4.0)
	
	animate(src, alpha = 180, time = 10)
	
	addtimer(CALLBACK(src, PROC_REF(fade_out), duration), 30)

/obj/effect/lingering_haze/proc/fade_out(duration)
	animate(src, alpha = 0, time = duration)
	QDEL_IN(src, duration)
