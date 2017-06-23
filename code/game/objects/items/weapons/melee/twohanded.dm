#define GAINS_SHARP_ON_ACTIVE 0x3
#define GAINS_EDGE_ON_ACTIVE 0x6
#define PARRY_REQUIRES_ACTIVE 0x7//For energy weapons that need to be active to parry.

/obj/item/weapon/twohanded //Base type, never spawn this.
	icon_state = "DONGS"
	var/wielded = 0
	var/force_wielded = 0
	var/unwielded_force_divisor = 0.25
	var/parry_chance = 15
	var/parry_sound = 'sound/weapons/punchmiss.ogg'
	var/active = 0 //So we don't have to use copy-paste procs with one more argument.

/obj/item/weapon/twohanded/update_twohanding() //Lets us know if the weapon is being held in both hands
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		force = initial(force)
		name = "[initial(name)]"
	update_icon()
	..()

/obj/item/weapon/twohanded/New()
	..()
	update_icon()

//SPARKING
obj/item/weapon/twohanded/proc/attempt_spark(var/mob/user)
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, user.loc)
	spark_system.start()
	playsound(user.loc, parry_sound, 50, 1)

//Allow a small chance of parrying melee attacks when wielded
/obj/item/weapon/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance) && (flags & PARRY_REQUIRES_ACTIVE) <= active)
		var/obj/item/weapon/twohanded/toggled/energy/S
		if(istype(S))
			if(S.active)
				attempt_spark()
			else
				return 0 //Just in case.
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, parry_sound, 50, 1)
		return 1
	return 0

/obj/item/weapon/twohanded/update_icon()
	icon_state = "[initial(icon_state)][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state
	item_state_slots[slot_r_hand_str] = icon_state


/*
 * Togglable weapons.
 */

/obj/item/weapon/twohanded/toggled //Exists to hold variables. Do not spawn this.

	var/active_force = 0
	var/activation_sound = null
	var/deactivation_sound = null
	var/passive_sound = null
	var/active_throwforce

/*
 * Activation handling.
 */
/obj/item/weapon/twohanded/toggled/proc/activate(mob/living/user)

	if(active)
		return
	force = active_force
	throwforce = active_throwforce
	if(flags & GAINS_SHARP_ON_ACTIVE)
		sharp = 1
	if(flags & GAINS_EDGE_ON_ACTIVE)
		edge = 1
	slot_flags |= SLOT_DENYPOCKET
	playsound(user, activation_sound, 50, 1)
	active = 1
	update_icon()


obj/item/weapon/twohanded/toggled/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, deactivation_sound, 50, 1)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)
	active = 0
	update_icon()

/obj/item/weapon/twohanded/toggled/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>","<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/weapon/twohanded/toggled/get_storage_cost()
	if(active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/obj/item/weapon/twohanded/toggled/dropped(var/mob/user) // Protects us from potential incredible stupidity (IE the hypothetical "dropping a lightsaber on the death star" situation.)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

obj/item/weapon/twohanded/toggled/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance) && (flags & PARRY_REQUIRES_ACTIVE) <= active)
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, parry_sound, 50, 1)
		return 1
	return 0

////////////Energy weapons!/////////////

//Double saber
/obj/item/weapon/twohanded/toggled/energy/dualsaber
	icon_state = "dualsaber0"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	unwielded_force_divisor = 0.52
	sharp = 0
	edge = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	w_class = ITEM_SIZE_SMALL
	parry_chance = 70
	flags = GAINS_SHARP_ON_ACTIVE | GAINS_EDGE_ON_ACTIVE | PARRY_REQUIRES_ACTIVE | NOBLOODY
	active = 0
	active_force = 50
	active_throwforce = 40

	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'
	item_state_slots[slot_r_hand_str] = var/righthandbase
	item_state_slots[slot_l_hand_str] = var/lefthandbase
	var/overlay_control = 0
	var/blade_color = "#B3AFEA" //"#00AFEA"


/obj/item/weapon/twohanded/toggled/energy/dualsaber/New()
	..()
	update_icon()

/obj/item/weapon/twohanded/toggled/energy/dualsaber/proc/manage_overlay()

	var/image/LH = image('icons/mob/items/lefthand.dmi', icon_state = "dualsaber_overlay[wielded]")
	var/image/RH = image('icons/mob/items/righthand.dmi', icon_state = "dualsaber_overlay[wielded]")
	var/image/LB = image(icon, "dualsaber overlay[wielded]") //LB, as in Lightblade.
	righthandbase =  image('icons/mob/items/righthand.dmi', icon_state = "dualsaber[wielded]")
	lefthandbase =  image('icons/mob/items/lefthand.dmi', icon_state = "dualsaber[wielded]")

	if(!(active) || overlay_control == 1)
	//item_state -= image perhaps?
		item_state -= LH
		item_state -= RH
		src.overlays -= LB
		admin_notice("All E-sword overlays removed.")
		if(overlay_control == 1)
			overlay_control = 0
			admin_notice("E-sword has been dropped, and all overlays have been removed successfully.")

	if(active)
		var/mob/M = loc
		src.overlays += LB
		if(loc.l_hand == src)
			lefthandbase += LH
			righthandbase -= RH
			M.update_inv_l_hand()
			admin_notice("LH successfully activated.It exists in \"[LH.loc]\" RH disabled.")
		else
			admin_notice("LH was not able to be activated. RH may still be active.")
		if(M.r_hand == src)
			lefthandbase -= LH
			righthandbase += RH
			M.update_inv_r_hand()
			admin_notice("RH successfully activated. It exists in \"[RH.loc]\" LH disabled.")
		else
			admin_notice("RH was not able to be activated. LH may still be active.")
	LH.icon_state = "dualsaber_overlay[wielded]"
	admin_notice("LH Icon_state changed to [LH.icon_state]")
	RH.icon_state = "dualsaber_overlay[wielded]"
	admin_notice("RH Icon_state changed to [RH.icon_state]")


	LH.color = blade_color
	RH.color = blade_color
	LB.color = blade_color

/*

		var/image/I = overlay_image(icon,"glowstick-on",color)
		I.blend_mode = BLEND_ADD
		overlays += I
		item_state = "glowstick-on"
		set_light(brightness_on)
	else
		icon_state = "glowstick"
	var/mob/M = loc
	if(istype(M))
		if(M.l_hand == src)
			M.update_inv_l_hand()
		if(M.r_hand == src)
		M.update_inv_r_hand()
*/



/obj/item/weapon/twohanded/toggled/energy/dualsaber/equipped(var/mob/user, var/slot)
	..()
	update_icon()


/obj/item/weapon/twohanded/toggled/energy/dualsaber/update_icon()
	icon_state = "[initial(icon_state)][wielded]"
	manage_overlay()

obj/item/weapon/twohanded/toggled/energy/dualsaber/dropped()
	overlay_control = 1
	manage_overlay()
	deactivate()


obj/item/weapon/twohanded/toggled/energy/dualsaber/verb/choose_blade_color()
	set category = "Object"
	set name = "Set Lightblade Color"
	set src in usr
		input(usr, "Pick a new color", "Lightlade Color", rgb(0,0,0) ) as color|null

		manage_overlay()
#undef GAINS_SHARP_ON_ACTIVE
#undef GAINS_EDGE_ON_ACTIVE
#undef PARRY_REQUIRES_ACTIVE