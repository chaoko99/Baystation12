//Todo on clusternades: add a pin overlay to grenades, and handling for it.

/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT

	var/truncated_name = "nade" // Used for clusterbombs.
	var/active = 0
	var/det_time = 50
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/unique_lever = 0 //Applies a specific lever sprite if true, saved as ([icon_state] + "_lever") in grenade.dmi.
	var/is_digital = 1 //Is this an electronic grenade? Used for EMP_act. Required for spawner, gravity, radiation, shock, laser

/*
---Grenade traits.---
Controls the various behaviors of a grenade. Down the line it should allow for custom grenade synthesis without using chem grenades.
*/
	var/trait_flags
/*
Offensive grenades: Concussion; HE; Fragmentation; Incendiary; Shock; Tesla; Gravitating; Radioactive; Laser

Concussion: Extremely high damage close to the grenade; rapid damage falloff (Applies clumsy.) - Exclusive to gravitating

*/




/*
Tactical grenades: Flash; Sonic; Daze; EMP; Anti-Photon
*/

/*
Utility grenades: Cleaner; Metal foam; Pest killer (For space vines); Smoke; Tear gas; Tranq smoke; Berserk smoke; Medicine smoke;
	Mutually exclusive to all traits.
*/


/*
Spawner grenades: Carp; Holocarp; Viscerator; Spiderling
	Mutually exclusive to all traits.
*/







/obj/item/weapon/grenade/New()
	..()
	var/icon/L = image(icon, unique_lever ? "[src]_lever" : "lever")
	overlays += L

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")

		activate(user)
		add_fingerprint(user)
		spawn(5)
			detonate()
		return 0
	return 1

/obj/item/weapon/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")


/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/weapon/grenade/proc/activate()
	if(active)
		return

	if(iscarbon(src.loc))
		var/mob/living/carbon/user = src.loc
		if(user)
			msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 0, -3)

	spawn(det_time)
		detonate()
		return


/obj/item/weapon/grenade/proc/detonate()
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

/obj/item/weapon/grenade/throw_at()


/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()
	return

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
