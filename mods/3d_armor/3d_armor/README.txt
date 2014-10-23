[mod] Visible Player Armor [3d_armor]
=====================================

depends: default, inventory_plus

Adds craftable armor that is visible to other players. Each armor item worn contributes to
a player's armor group level making them less vulnerable to weapons.

Armor takes damage when a player is hurt but also offers a percentage chance of healing.
Overall level is boosted by 10% when wearing a full matching set.

default settings: [minetest.conf]

# Set number of seconds between armor updates.
3d_armor_update_time = 1

-----------------------------------
This version was modified by 4aiman
-----------------------------------
Changes:
 - disabled healing by armor;
 - changed levels of protection to be more like those of MC;
 - removed a certain someone's code for HUD support;
 - etc...
