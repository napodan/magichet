Most recent changes
===================

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
    + nearly disabled fall damage (50+ nodes)
    + new speed-dependent FOV
    + forbid console_key to close the console
    + make "Return" to close the console
    - move console to the bottom of the screen
    - add an optional bg setting for chat
    - create an api for per item definition swap

Game
----
    - remove func duplicates
    - generate rubber trees with LVM
    - beds in villages
    - rnd loot in chests (villages, dungeons)
    - merge as many globalstep loops as possible
    - fix "SetNode ERROR" spamming the console
    - edit "scm" files
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
    - fix cake's recipe
    - tweak vesels
    - make reincarnator to be usable w/o ghost blocks, but add some downside
    - fix default:chest wielt_image to be 3d
    - make armour HUD
    - move lava_damage to enchantment (fire affinity, etc)
    - devoid ghosts of the ability to wear armour(?)
    - make fall damage based on speed(?)
    - make mobs use different behaviour patterns
    - fix stairs & slabs (groups, 6dir)
    ~ different meshes for "ghostly_blocks"
    ~ delete optional dependencies to speedup the game a little (!)
    ~ Translate into Russian
    ~ fix typos... (will always b*n*e like "~")
    ~ add MC-like mobs
    ~ speed-up existing mobs
    ~ add CO(2) generation
    ~ remove notices of violation if that didn't happen (allow_ functions)
    ~ shrink inventory for ghosts if it's not the first death
    + add villages
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
