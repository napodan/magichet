Most recent changes
===================

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
    + forbid console_key to close the console
    + make "Return" to close the console
    - move console to the bottom of the screen
    - add an optional bg setting for chat
    - create an api for per item definition swap

Game
----
    - proper on_blast for every node (!)
    - proper IC2 recipes (?)
    ~ different meshes for "ghostly_blocks"
    + replace 8x4 grid by 9x4 within all mods which are to include (!)
    + make all leaves and other handle_with_caution nodes to drop NOTHING (!)
    + change stone to desert_stone in fiery biomes
    + make node fillers to go even deeper
    - make bamboo replace water
    + make aluntra and ignis be a rare drop
    ~ delete optional dependencies to speedup the game a little (!)
    - make a wrench to dig machinery
    - blast machinery on dig otherwise
    - make wrench be able to rotate nodes (like a screwdriver)
    + remove itest upgrade aliases
    ~ Translate into Russian
    - and made some global option to switch to it "in one click"
    ~ fix typos... (will always b*n*e like "~")
    - create in-game documentation in a form of books
    - add villages
    - add villagers
    ~ add MC-like mobs
    ~ speed-up existing mobs
    + double energy requirements for hospital
    + slow down hospitals
    + make medpacks harder to get
    - debuff hospitals even more if concidered like cheating
    + just one-per-mod "loaded" message
    + generate voltbuild docs AFTER localization
    - redo mapp into LVM
    - make torches be entities (fixed by new 3d torches)
    + make chests be entities (hide a node inside the entity to store inv)
    + re-add double chests
    - add metallic covers to voltbuild (means hammers, plates, machinery) (!)
    + fix iron furnace's inventory
    + make any workbench drop its inventory when its formspec is being closed (!)
    - wiring tutorial (!)
    + make jetpack an armour
    + fix jetpack VS enchantment VS ghosts
    - create quests for layers
    + add CO(2) liquid
    ~ add CO(2) generation
    - make furnaces break down after mass CO(2) production
    + add breakdown param for nodes
    - make use of that param while performing dangerous activities
    + add CO2 generation on machinery blast
    + get rid of minetest.env
    + quartz in nether
    - fix cake's recipe
    + make furnaces show cook_time%, not fuel_total_time%
    + make furnaces be usable by ghosts (somewhat secretly)
    + sort buttons for inventories
    + fix formspecs for voltbuild 2
    + make mesecons an electric fuel of a 10 EU (single use)
    - tweak vesels
    ~ remove notices of violation if that didn't happen (allow_ functions)
    + make geothermal generator slightly unstable
    + move "ghosts" mod's stuff to a world dir
    + furnaces generate ectoplasm if a ghost is cooking it (available for alive only)
    + make furnace inv to be updated for everyone VS last opener(?)
    + fix ectoplasm generating in mid-air
    + 3d MC-like chests (no double chests ATM)
    + save ALL reincarnations' items [up to x5 items](?)
    + death's count
    ~ shrink inventory for ghosts if it's not the first death
    - make reincarnator to be usable w/o ghost blocks, but add some downside
    - fix default:chest wielt_image to be 3d
    + add armour
    - make armour HUD
    + make jetpack an armour
    - move lava_damage to enchantment (fire affinity, etc)
    + fix ice transparency
    - devoid ghosts of the ability to wear armour(?)
    - make fall damage based on speed(?)
    - make mobs use different behaviour patterns
    + make mossy cobble drop normal cobble
    - fix ethereal leaves

Legend
------
*-* means it's NOT done yet<br>
*~* means it's NOT done yet, but is in progress<br>
*+* means it's ALREADY has been done<br>
*(!)* means it's TOP priority<br>
*(?)* means I'm not sure about it<br>
