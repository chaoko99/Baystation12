#define FOOTSTEP_CARPET 	"carpet"
#define FOOTSTEP_TILES 		"tiles"
#define FOOTSTEP_PLATING 	"plating"
#define FOOTSTEP_WOOD 		"wood"
#define FOOTSTEP_ASTEROID 	"asteroid"
#define FOOTSTEP_GRASS 		"grass"
#define FOOTSTEP_WATER		"water"
#define FOOTSTEP_DIRT		"dirt"
#define FOOTSTEP_HULL		"hull"
#define FOOTSTEP_SAND		"sand"
#define FOOTSTEP_SNOW		"snow"
#define FOOTSTEP_BLANK		"blank"

/turf/simulated/floor/var/global/list/footstep_sounds = list(
	FOOTSTEP_WOOD = list(
		'sound/effects/footstep/wood/wood_step1.ogg',
		'sound/effects/footstep/wood/wood_step2.ogg',
		'sound/effects/footstep/wood/wood_step3.ogg',
		'sound/effects/footstep/wood/wood_step4.ogg',
		'sound/effects/footstep/wood/wood_step5.ogg',
		'sound/effects/footstep/wood/wood_step7.ogg',
		'sound/effects/footstep/wood/wood_step8.ogg',),
	FOOTSTEP_TILES = list(
		'sound/effects/footstep/floor/floor_step1.ogg',
		'sound/effects/footstep/floor/floor_step2.ogg',
		'sound/effects/footstep/floor/floor_step3.ogg',
		'sound/effects/footstep/floor/floor_step4.ogg',
		'sound/effects/footstep/floor/floor_step5.ogg'),
	FOOTSTEP_PLATING =  list(
		'sound/effects/footstep/plating/plating_step1.ogg',
		'sound/effects/footstep/plating/plating_step2.ogg',
		'sound/effects/footstep/plating/plating_step3.ogg',
		'sound/effects/footstep/plating/plating_step4.ogg',
		'sound/effects/footstep/plating/plating_step5.ogg'
		),
	FOOTSTEP_CARPET = list(
		'sound/effects/footstep/carpet/carpet_step1.ogg',
		'sound/effects/footstep/carpet/carpet_step2.ogg',
		'sound/effects/footstep/carpet/carpet_step3.ogg',
		'sound/effects/footstep/carpet/carpet_step4.ogg',
		'sound/effects/footstep/carpet/carpet_step5.ogg'
		),
	FOOTSTEP_ASTEROID = list(
		'sound/effects/footstep/asteroid/asteroid_step1.ogg',
		'sound/effects/footstep/asteroid/asteroid_step2.ogg',
		'sound/effects/footstep/asteroid/asteroid_step3.ogg',
		'sound/effects/footstep/asteroid/asteroid_step4.ogg',
		'sound/effects/footstep/asteroid/asteroid_step5.ogg'
		),
	FOOTSTEP_GRASS = list(
		'sound/effects/footstep/grass/grass_step1.ogg',
		'sound/effects/footstep/grass/grass_step2.ogg',
		'sound/effects/footstep/grass/grass_step3.ogg',
		'sound/effects/footstep/grass/grass_step4.ogg'
		),
	FOOTSTEP_WATER = list(
		'sound/effects/footstep/water/water_step1.ogg',
		'sound/effects/footstep/water/water_step2.ogg',
		'sound/effects/footstep/water/water_step3.ogg',
		'sound/effects/footstep/water/water_step4.ogg'
		),
	FOOTSTEP_DIRT = list(
		'sound/effects/footstep/dirt/dirt_step1.ogg',
		'sound/effects/footstep/dirt/dirt_step2.ogg',
		'sound/effects/footstep/dirt/dirt_step3.ogg',
		'sound/effects/footstep/dirt/dirt_step4.ogg'
		),
	FOOTSTEP_HULL = list(
		'sound/effects/footstep/hull/hull_step1.ogg',
		'sound/effects/footstep/hull/hull_step2.ogg',
		'sound/effects/footstep/hull/hull_step3.ogg',
		'sound/effects/footstep/hull/hull_step4.ogg',
		'sound/effects/footstep/hull/hull_step5.ogg'
		),
	FOOTSTEP_SAND = list(
		'sound/effects/footstep/sand/sand_step1.ogg',
		'sound/effects/footstep/sand/sand_step2.ogg',
		'sound/effects/footstep/sand/sand_step3.ogg',
		'sound/effects/footstep/sand/sand_step4.ogg',
		'sound/effects/footstep/sand/sand_step5.ogg',
		'sound/effects/footstep/sand/sand_step6.ogg',
		'sound/effects/footstep/sand/sand_step7.ogg',
		'sound/effects/footstep/sand/sand_step5.ogg'
		),
	FOOTSTEP_SNOW = list(
		'sound/effects/footstep/snow/snow_step1.ogg',
		'sound/effects/footstep/snow/snow_step2.ogg',
		'sound/effects/footstep/snow/snow_step3.ogg',
		'sound/effects/footstep/snow/snow_step4.ogg'
		),
	FOOTSTEP_BLANK = list(
		'sound/effects/footstep/blank.ogg')
)

/decl/flooring/var/footstep_type
/decl/flooring/footstep_type = FOOTSTEP_BLANK
/decl/flooring/carpet/footstep_type = FOOTSTEP_CARPET
/decl/flooring/tiling/footstep_type = FOOTSTEP_TILES
/decl/flooring/linoleum/footstep_type = FOOTSTEP_TILES
/decl/flooring/wood/footstep_type = FOOTSTEP_WOOD
/decl/flooring/reinforced/footstep_type = FOOTSTEP_PLATING

/turf/simulated/floor/proc/get_footstep_sound()
	if(is_plating())
		return safepick(footstep_sounds[FOOTSTEP_PLATING])
	else if(!flooring || !flooring.footstep_type)
		return safepick(footstep_sounds[FOOTSTEP_BLANK])
	else
		return safepick(footstep_sounds[flooring.footstep_type])

/turf/simulated/floor/asteroid/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_ASTEROID])

/turf/simulated/floor/exoplanet/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_CARPET])

/turf/simulated/floor/exoplanet/grass/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_GRASS])

/turf/simulated/floor/exoplanet/water/shallow/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_WATER])

/turf/simulated/floor/fixed/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_PLATING])

/turf/simulated/floor/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_SNOW])

/turf/simulated/floor/Entered(var/mob/living/carbon/human/H)
	..()
	if(istype(H))
		H.handle_footsteps()
		H.step_count++

/datum/species/var/silent_steps
/datum/species/nabber/silent_steps = 1

/mob/living/carbon/human/var/step_count

/mob/living/carbon/human/proc/handle_footsteps()
	var/turf/simulated/floor/T = get_turf(src)
	if(!istype(T))
		return

	if(buckled || lying || throwing)
		return //people flying, lying down or sitting do not step

	if(m_intent == "run")
		if(step_count % 2) //every other turf makes a sound
			return

	if(species.silent_steps)
		return //species is silent

	if(!has_gravity(src))
		if(step_count % 3) // don't need to step as often when you hop around
			return

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return //no feet no footsteps

	var/S = T.get_footstep_sound()
	if(S)
		var/range = -(world.view - 2)
		var/volume = 70
		if(m_intent == "walk")
			volume -= 45
			range -= 0.333
		if(!shoes)
			volume -= 60
			range -= 0.333

		playsound(T, S, volume, 1, range)