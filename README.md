Most recent changes
===================

####"The Bundled Update":
    + revert auto translation
    + fixed enchantment sharing vs explorer tools
    + fixed typos in "awards" mod
    + fixed shears not digging leaves and/or grass
    + fixed enchantments nullifying groups
    + removed creative references from every mod
    + revamped creative mod
    + added random loot to the chests in villages
    + fixed bananas & mushroom plants + 4hunger behaviour
    + fixed ghosts suffering hunger
    + save inv_size & restore it upon join
    + inv_size diminish if a player too often reincarnate w/o reincarnator
    + craft grid now drops it's items when inventory is closed (just like a workbench)
    + fixed undiggable apples
    + whereis now shows the pos of a player along with the distance and requires "whrereis" priv
    + privs4rus mod was moved to unused
    + kill/set HP mod language set to ENG; RUS version -> unused
    + modified __builtin:item to support XP drops
    + removed specialties tools from the creative inventory
    + specialties XP is a drop now
    + fixed furnace inventory never reaching 100%
    + closed chest's inventory is "closed" now
    + removed unnecessary on_right_click triggers
    + new improved shared chest with GUI
    + new wormhole chest
    + tools wear when player uses them (includes improper usage)
    + poison and other 4hunger effects are more predictable
    + new, lightweight mobs framework, heavily influenced by Adam's, but RE-coded from scratch:
        + flyings mobs
        + jumping mobs
        + swimming mobs
        + wandering mobs
        + shooting mobs
        + punches throw back mobs
        + faster choices thanks to change of type of state-holding variables
        + faster on_step thanks to deletion of unnecessary checks
        + even more CPU-time saving thanks to "busy" status
        + ease of adding new mobs
        + ID for every mob
        + environmental damage make mobs run forward in agony
        + breeding
        + childish ties
        + following algo
        + colorful sheep (and possibility to add more colorful mobs)
        + spawn-rate control (disabled by default)
        + more settings for spawn abm (light, tepm, humidity, altitude, etc)
        + 2 AIs:
            + the "smart" pathfinder one for killing machines
            + the "stupid" vidi-veni-follow one for friendly mobs and mobs in water
    + tools wear when hitting new mobs
    + fixed 3d_chests appearance (animated chests)
    + 3d_chests can be dug like normal blocks
    + particles around wormhole chests
    + dipping water & lava particles
    + lava & fire causes damage through lua (to be controllable by statuses)
    + the Lie (a cake with a proper recipe!)
    + tweaked village placement code
    + moved cobweb into "default"
    + added abandoned mine shafts with some rails and cobweb (coded from scratch!)
    + moved all "default" crafting from "nodes.lua" to "crafting.lua"
    + player shooting (improved)
    + arrows get stuck in nodes
    + don't turn arrows into "__builtin:item" - they're collect-able "as is"
    + highly customizable ammo registration: damage, initial speed and acceleration, movement algorithm
    + mobs will attack *whomever has shot* the arrow at them be it a player or a mob
    + mobs will breed *only* if no one took items they produce (cows = milk, sheep = wool), otherwise you'll need to feed them or to wait
    + ~5% of enemy arrows that got stuck can be picked up by players
    + fixed physics on jetpack's energy running low
    + carts_boost instead of carts
    + prevent multiple ghostly blocks @ pos, only the first one is preserved
    + mobs jump over obstacles when following the attractor/running away from the aggressor/wandering around the place
    + arrows don't hurt their "launcher"
    + arrows' power depends on their "launcher" attack power
    + redo the "everlast" enchantement to make it "not wearing" instead of "healing" tools
    + make fire_affinity respect groups in the 1st place
    + attacking mobs result in additional exhaustion
    + make use of the new glasslike_framed_optional drawtype
    + has prepared the ground to MC-like effects (added to those of enchantments)
    + even more fixes to 4hunger (food exhaustion & saturation)
    + mobs can use procs for different attacks patterns (combined with busy status it's quite effective)
    + mob-produced items are either random in count of fixed
    + a cow, a pig, a sheep, their "children", wormhole, skeleton (archer)
    + spawn eggs
    + new sprinting code
    + more reasons to be exhausted
    + melons, pumpkins, jack-o-lanterns, pumpkin helmets & fertilizer crafting
    + removed enchantement hud
    + some checks for huds

####"The Small Fixes Update":
    + fix armour wearing when damage is dealt by hunger/poison
    + optimize bookshelves + enchantment_table performance
    + remove label/goto from the "enchantment" mod (Lua 5.1 comp.)
    + add some new graphics
    + fix player's physics while going_to/in bed
    + wake up by pressing "jump" button/key
    + fix fall damage while flying with jetpack
    + disable fall damage for ghosts
    + random loot in chests in villages
    + add Russian version of the words used to make-up chants names
    + fix generation of basements for houses in villages
    + remove "mg:ignore" from the we files
    + mg renamed to villages
    + fix worms spawning, no more "as mob" option
    + Russian version of the README.md

####"The Sleepy Update":
    + new fixes to villages generation
    + "remember" al generated villages (per world)
    + colourful beds
    + exposed player data through default.*
    + "new-style" sorting buttons in pll inv (like everywhere else)
    + new approach to player physics: now easy-stackable!
    ~ removed strange portions of code @ *player_join*\'s

####"The "Villages Update":

    = restructured TODOs (-,~,+)
    + small fixes to furnaces
    + made some nodes invulnerable to mapgen v7
    + villages spawning (derived from "mg" mod by Nore, still buggy)
    + fixed broken inventory sorting


####"The "mid-examinations update":

    + make ice slippery
    + add cobweb (TenPlus1, uncraftable, useless ATM)
    + fixed gravity when unequip a jetpack
    + updated mesecons to [commit e88e213183] (https://github.com/Jeija/minetest-mod-mesecons/commit/e88e2131838caeb5fe66f22a57552936bd873916) (still buggy)
    + fixed furnaces inv to be updated for everyone
    + furnaces generate ectoplasm if a ghost uses it
    + new armour groups (just a notice, added by the prev. commit)
    ~ renamed README => "Game Description", because it *is* a description
    ~ renamed ToDos => README, cause it's much shorter and is used to track changes

TODOs
=====

Engine (not publicly available yet)
------
    + per-player controlled fall tolerance (damage caused by a fall)
    + new speed-dependent FOV
    + forbid console_key to close the console
    + make "Return" to close the console
    - move console to the bottom of the screen
    - add an optional bg setting for chat
    - create an api for per item definition swap

Game
----
    - re-implement "trails" mod
    - ghost blocks may turn normal blocks to corresponding nodes
    - exorcism for clearance :)
    - 10 first-met ghostly blocks to turn nodes into what they were after every reincarnation
    - added specialties formspec to blacksmith
    - remove func duplicates
    - generate rubber trees with LVM
    ~ global loot rarity values
    - merge as many globalstep loops as possible
    - proper on_blast for every node (!)
    - proper IC2 recipes (?)
    - make bamboo replace water
    - make a wrench to dig machinery
    - blast machinery on dig otherwise
    - make wrench be able to rotate nodes (like a screwdriver)
    - and made some global option to switch to it "in one click"
    - create in-game documentation in a form of books
    - add villagers
    - debuff hospitals even more if concidered like cheating
    - redo mapp into LVM
    - make torches be entities (fixed by new 3d torches)
    - add metallic covers to voltbuild (means hammers, plates, machinery) (!)
    - wiring tutorial (!)
    - create quests for layers
    - make furnaces break down after mass CO(2) production
    - make use of that param while performing dangerous activities
    - tweak vessels
    - make reincarnator to be usable w/o ghost blocks, but add some downside
    - make armour HUD
    - move lava_damage to enchantment (fire affinity, etc)
    - devoid ghosts of the ability to wear armour(?)
    - make fall damage based on speed(?)
    - fix stairs & slabs (groups, 6dir)
    ~ edit "scm" files
    ~ different meshes for "ghostly_blocks"
    ~ Translate into Russian
    ~ fix typos... (will always b*n*e like "~")
    ~ add CO(2) generation
    ~ remove notices of violation if that didn't happen (allow_ functions)
    + fix enchantment sharing vs explorer tools (shift)
    + add MC-like mobs
    + rnd loot in chests (villages, dungeons)
    + fix "SetNode ERROR" spamming the console
    + fix cake's recipe
    + fix default:chest wield_image to be 3d
    + make mobs use different behaviour patterns
    + speed-up existing mobs
    + shrink inventory for ghosts if it's not the first death
    + add villages
    + beds in villages
    + replace 8x4 grid by 9x4 within all mods which are to include (!)
    + make all leaves and other handle_with_caution nodes to drop NOTHING (!)
    + change stone to desert_stone in fiery biomes
    + make node fillers to go even deeper
    + make aluntra and ignis be a rare drop
    + remove itest upgrade aliases
    + double energy requirements for hospital
    + slow down hospitals
    + make medpacks harder to get
    + just one-per-mod "loaded" message
    + generate voltbuild docs AFTER localization
    + make chests be entities (hide a node inside the entity to store inv)
    + re-add double chests
    + fix iron furnace's inventory
    + make any workbench drop its inventory when its formspec is being closed (!)
    + make jetpack an armour
    + fix jetpack VS enchantment VS ghosts
    + add CO(2) liquid
    + add breakdown param for nodes
    + add CO2 generation on machinery blast
    + get rid of minetest.env
    + quartz in nether
    + make furnaces show cook_time%, not fuel_total_time%
    + make furnaces be usable by ghosts (somewhat secretly)
    + sort buttons for inventories
    + fix formspecs for voltbuild 2
    + make mesecons an electric fuel of a 10 EU (single use)
    + make geothermal generator slightly unstable
    + move "ghosts" mod's stuff to a world dir
    + furnaces generate ectoplasm if a ghost is cooking it (available for alive only)
    + make furnace inv to be updated for everyone VS last opener(?)
    + fix ectoplasm generating in mid-air
    + 3d MC-like chests (no double chests ATM)
    + save ALL reincarnations' items [up to x5 items](?)
    + death's count
    + add armour
    + make jetpack an armour
    + fix ice transparency
    + make mossy cobble drop normal cobble
    + fix ethereal leaves
    + make all but some nodes is_ground_content

Legend
------
*-* means it's NOT done yet<br>
*~* means it's NOT done yet, but is in progress<br>
*+* means it's ALREADY has been done<br>
*(!)* means it's TOP priority<br>
*(?)* means I'm not sure about it<br>
