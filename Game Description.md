Welcome to the bi-polar world of "Magichet"
===========================================


0 System prerequisites
----------------------
This game was tested on a rather slow hardware: Acer Aspire One.

But since there are a lot of different models hidden beyound that name, I'll put
some info here.

Note, that the game was only "playable" on this HW. And by "playable" I mean
that fps never got lower than 6 and has stayed at 14-21 for ~85% of time.

The game was launched from the "Server" tab and played locally. For client only
the HW given below are good enough to have more than 14 fps 99% of time.

The game was tested with the Freeminer engine, which means that MT Engine can
probably go a little bit faster.

CPU info:
---------
<pre>processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 28
model name  : Intel(R) Atom(TM) CPU N455   @ 1.66GHz
stepping    : 10
microcode   : 0x107
cpu MHz     : 1000.000
cache size  : 512 KB
physical id : 0
</pre>
Memory:
-------
MemTotal:        1022096 kB

Freeminer startup output:
-------------------------
Irrlicht Engine version 1.8.1<br />
Linux 3.2.0-4-686-pae #1 SMP Debian 3.2.53-2 i686<br />
Using renderer: OpenGL 2.1<br />
Mesa DRI Intel(R) IGD x86/MMX/SSE2: Intel Open Source Technology Center<br />
OpenGL driver version is 1.2 or better.<br />
GLSL version: 1.2<br />



I Introduction
--------------
This game was brought to you by 4aiman and all the authors of mods that I have
changed to suit my ideas of what a voxel sandbox should be.

Things you're about to experience may confuse you more than Minecraft & Minetest
default and "non-default" games all together. Or they may not.

This is NOT a clone of Minecraft.

Do NOT expect your Minecraft experience would help you much.

**However**
This was made by a hardcore MC player with years of experience to whom
Minecraft was the 1st sandbox. YES, that DOES mean that I tried to bring all
kinds of stuff from MC.

But I also did NOT change or remove Minetest-only features like locked chests,
desert stones, monsters or HP gauges above the players.
There's NO Redstone but Mesecons used instead.
There ARE fishing and farming but those are slightly different.
There are MC-like craft recipes for sticks, but any of the dyes should be get
NOT the way anyone does it in MC. Etc etc...

To a seasoned MC player this one should be familiar, yet different.
I hope that you will enjoy playing this game and make your suggestions known
to me by sending an e-mail to 4aiman@inbox.ru.

Players from Russia or anyone who can read Russian rather well are also welcomed
at 4aiman.ucoz.ru. Non-Russian players are also welcomed, but I doubt that many
people at 4aiman.ucoz.ru would speak English well enough to answer you. And
googletranslate does hideous things upon messages...

Also, the game includes some TODO info and all the mods in the "unused"
folder are to be added sooner or later.



II Game Mechanics (what's different from MC?)
---------------------------------------------
ATM, in terms of dig&build the game is pretty much the same as Minecraft.
Dig, build, upgrade your tools and have fun.


###II-1 Map generation

The most astonishing change is map generation: There are NO biomes like any
minecrafter know. This game uses ethereal map generator.

This means there are: jungles, grayness biome, mushroom biome, fiery plains,
icy biome, stone deserts, grassy plains, etc.

Note, that Minetest have a world of 65000 blocks height. That allowed me to put
extra realms inside one map - there are Nether deep below the surface (much
deeper than any minecrafter can dig in both Nether & Overworld) and a very
beautiful rivers realm high above the overworld (even farther from the Overworld
than the Nether).

But some places of that 65000^3 world would be inaccessible until certain
conditions are not met.

###II-2 Tools

The set of tools known to a minecrafter is expanded with bronze, silver, mese
and mithril.

Mese is the MT-only feature that adds new alien ore with different
purposes - from making any tools to creation of a redstone-like circuitry.

Mithril is a highly durable magic material that can be used to create tools
that can cut and dig through ANY known block and can be used for amount of time
more like eternity (diamond tools are NOWHERE near mithril).
But you see, the tools made of mithril are EXTREMELY slow. Magick has it's own
balancing ways too and the material itself is no better that your average
silver. So, those all-capability features just HAVE to drain something from the
material and/or it's user.

Bronze is like iron, but has x3 uses and is slightly (you won't notice) slower
than iron tools.


###II-3 Afterlife

Were you wondering what is there after the death?
Now you can see it for yourself!

After every death you have 2 options: to have another life or to remain a ghost
with a quest to reincarnate! However you are to cooperate with players who are
still alive.

The simplest way is to collect ghosts of dug blocks by right-clicking and craft
a reincarnator (furnace-like recipe for a furnace-like block). Then you need to
find a player able to spot you and convince him to place this reincarnator
anywhere in the world. You need others since you're not a material being anymore
an are devoid of ability to build or dig anything.

Reincarnator considers 2 things:
             - structure beneath it;
             - material that structure was built from.

Structure has 3 layers.
<pre>
                        [ ][ ][ ][ ][ ]
                        [ ][ ][ ][ ][ ]
        The bottom one: [ ][ ][ ][ ][ ]
                        [ ][ ][ ][ ][ ]
                        [ ][ ][ ][ ][ ]

                        [ ] ·  ·  · [ ]
                         ·  ·  ·  ·  ·
        The middle one:  ·  · [R] ·  ·
                         ·  ·  ·  ·  ·
                        [ ] ·  ·  · [ ]

                        [ ] ·  ·  · [ ]
                         ·  ·  ·  ·  ·
        The top one:     ·  ·  ·  ·  ·
                         ·  ·  ·  ·  ·
                        [ ] ·  ·  · [ ]

[R] means reincarnator block, dots mean empty pos,
[ ] means material block.

                            ------------------------------->
The suitable materials are: stone, iron, gold, mese, diamond.
The best materials are to the right.
</pre>
Unfinished structures may not be able to reincarnate you.
Efficienty is calculated based on material and % of "finishness" of a structure.

#####Example:

        If a structure is 90% finished and is made of mese then you'll be
        reincarnated with the probability of 90% and every item you had before your
        death will be decreased in count or durability left.

So, it's in your best interest to reincarnate in some finished structure made
of diamond blocks.

There's more about reincarnators comming soon.

####Life as a ghost:

- you cannot be hurted\*<br />
- you cannot die in a normal way<br />
- you cannot reincarnate by death once you've chosen to be a ghost<br />
- should you reincarnate and there's no one within 50 nodes from your death spot - your stuff will be as good as gone<br />
- you cannot pickup items<br />
- you cannot build<br />
- you cannot dig<br />
- you can collect and place ghostly blocks<br />
- you can punch entities (will be disabled)<br />
- every time you die (no matter if you\'re a ghost) your inventory is cleared<br />
- cleared items can be retreived upon reincarnation<br />
- you produce ectoplasm by walking<br />
- you can jump very high<br />
- your sight is not so clear, though<br />
- you can access inventories<br />
- you can cause a poltergeist by using a furnace (normal one and desert one)<br />
- your max HP will decrease every MAX_HP*5+60<br />
- the number of your inventory slots will be decreased upon multiple deaths<br />
- you\'ll die as a ghost in around 3 days if you wouldn\'t reincarnate<br />
- you need 10% of a dug nodes to fully reincarnate<br />
- you\'ll have to cooperate with others to reincarnate<br />
- a lot more ...

\* Actually you get healed every dtime, so nothing can kill you due to a
bug in MT's health tracking system.

###II-4 Chat commands

Some of you may have used stuff like "/teleport" or "/time set" in Minecraft.
Here we have some commands too. But those are generally prohibited for a regular
player.

The ones that are not present in vanilla Minecraft are "/home x" and
"/sethome x". Those 2 will help you to jump to any of your homes if you're
close enough (~300 blocks away).

Also, the "/spawn" command won't work if you're more than 2000 blocks away.
That CAN be easily changed to have no limit, but I'm not the one who will make
this change. Increasing the distance is a whole different case - make your
suggestions.

Another one is "/whereis x". With this you'll be able to find a distance to any
player. Comes in handy when you're lost and your friend is busy fighting for his
or her life. This, however, won't give you any directions, just the distance.

Eventually there will be clerics and black mages that can either heal or kill
you with magic. Maybe chat commands would be a way to cadt some spells.

Being beta there's a lot of debug comands too. I'm not going to remove
them until some certain point deeper in the development.

###II-5 Awards

Those are achievements one may be familiar with having played Minecraft.
However, awards are given for the whole different reasons such as:
 - using torches
 - digging caves
 - dying several times
 - crafting some items (ok, this *is* MC-like)
 - commiting your first suicide
 - upgrading your tools
 - etc...

###II-6 Enchantments

Yep, those are enchantments you know from MC. Will look different but do the
same thing. But to enchant anything you'll need ghostly blocks which can be
obtained only being a ghost yourself or taken from another ghost. Those blocks
should be cooked to become ectoplasm. That ectoplasm will substitute XP.
You don't need to make huge stacks of that stuff - just have it in your
inventory while trying to enchant some tool. Oh, yes, only tools can be
enchanted.

Also you may obtain some ectoplasm where ghosts dwell... But it's up to you to
find where they do. Even the sources won't help you to find any of those places.
I'll just tell everyone this: wherever is a ghost - there's a chance of some
ectoplasm to be found.

Moreover, enchanted tools can be used to grant the very same effect within close
radius. Enchantment level would be used as the radius of effect and the effect
itself would be of "enchantment_level-2" level. So only lvl 3+ enchantments can
be shared.

However... MESE tools are almost NOT enchantable!
MESE is already overpowered enough to make tools of it enchantable.

So, go down to -3000 and try to find some mithril - a metal of initially low
durability but high magic affinity. That means following:
    - mithril tools are SLOW. Even wooden tools are faster;
    - mithril tools are magically boosted to have 2x more uses than diamond ones;
    - mithril tools are easily enchanted (more easily then gold ones).

So, enchanting a mithril pick with "haste" would make you an incredible tool.

Also, any ghost will be able to use any enchanted tools. Too bad drops can't be
"harvested" if you're a ghost.

There's also a secondary way to get enchantments:

###II-7 Specialties

So you don't want to die but want to be rewarded for your activity?
Then dig, plant, build, cut down trees and became a specialist!
Having done enough you'll be able to fix your tools, get better ones or even
obtain a new tool that has enchantment-like effect instead of your ordinary one!

Anyone can use their xp for enchantments too. But there's something any
particular person should know:
     - you need 3x+ more xp to enchant anything compared to ectoplasm;
     - after enchantment your xp will be redistributed equally between specs;

The first one is rather fair: one doesn't need to become a ghost, pickup
anything etc. If you think you can just build a pillar and break it to get both
digger and builder xp, then you're wrong :) The game has a protection against
that, and you would only wear out your tool if you try to dig your own
buildings.
That means your builder xp WILL decrease and your digger xp will NOT increase
in such a case.

Th second one is another drawback - The Gods of Ancient Magic do NOT appreciate
your hacky ways of using their powers.
But maybe there ARE some cases when redistribution would help? ;)

###II-8 Vehicles

Boats, cars, jetpacks, helicopters and even UFOs! All are subject to be
included. Find recipes on your own ;)

###II-10 Industry

Do you know Industrial Craft addon?
Well, something like that is INBUILT in this game. That was made so one would
decide whether he's techie or "highly-spirited".

However, there are some new things - feel free to find which ;)
Some of BuildCraft features are also to be introduced.


###II-9 Inventory tools

ATM your inventory has unbuilt craft guide.
In the future there will be bags, skins and more!

And if you'll use this game inside Freeminer engine, you will have even more MC
features like a Z-key-zoom or a speed-based-FOV. So, try out Freeminer engine if
you lack those.


###II-10 Mobs

Some MC-like mobs are avaiilable: chickens, cows, sheeps and pigs.
There are also MT-only mobs: Oerkki, DungeonMaster, Stone, Sand and Dirt
Monsters, Rats, Tree Monster.

All the above are subject to be shaped and balanced.
However, you can breed any passive animal right now in a way you'd do it
while playing MC - feed them and let them multiply :o


###II-11 Farming

Farming is rather inferior ATM. Currently there are: wheat, pumpkins,
carrots, potatos, strawberries, onions, cotton. Melons are the subject
to be added, as well as other MC-like crops.

Fertilizer can be crafted too.



III - Textures
--------------
Default textures for this game are 32x.
That means you'll get faithful-like experience brought to you by the texturepack
with that name.
However, over 400 textures was redrawn from the scratch!
That's why I called this texturepack "Heretic".



IV - More great news
--------------------
Some parts of this game can be used on their own!
Texturepack, mods, models... They're all are free as in "freedom" and you can
use, edit and share! Licenses for every part can be found inside that part's
folder. If there are nothing - you're granted GPLv3 freedoms.



V - People to thank
-------------------
Those, who has made an engine for this are listed in "About" section of engine's
main menu. But there are also those who should be thanked for making this game
possible.

Here's a list of people you may want to say "Thanks!" to in no particular order:

**celeron55** for starting the whole thing<br />
**MT and FM devs** for bringing us joy even though sometimes I hate you all... That's a joke. I hate just *some* of you... :D <br />
Anyway, there quite a lot of them and the list is being changed and if we are to add those who had created issues too... <br />

**4aiman** for making this game out of his and other people's mods<br />
**PilzAdam** for creation of the Minitest game which was partially used to make this one. Also for all his mods and stuff.<br />
**Zeg9** for creating yet another craft guide and some other really cool stuff<br />
**0gb_us** for his old more_chests mod that was used for purposes he probably won't justify :D<br />
**Menche** for filling a huge hole by making desert stone to be craftable into desert furnaces<br />
**Chinchow** for creation of the astonishing Ethereal mapgen based on v7<br />
**TenPlus1** for developing and enhancing the astonishing Ethereal mapgen based on v7<br />
**Rubenwardy** for creation of the "Awards" mod to give you achievements<br />
**wulfsdad** for initial fishing mod<br />
**Mossmanikin** for tweaking fishing<br />
**Ironzorg**, **VanessaE** for flowers mod<br />
**cornernote**, **Zeg9** for inventory plus mod<br />
**Calinou** for moreores mod he finds obsolete<br />
**sfan5** for his oil mod<br />
**xyz** for sethome, xpane and other mods<br />
**metalstache** for specialties mod<br />
**Kilarin** and his son for explorer tools concept<br />
**sfan5**, **Anthony Zhang** (Uberi/Temperest), **Brett O'Donnell** (cornernote) for awesome worldedit functionality<br />

...and many others not listed here - tell me if you want someone's name to take
it's rightful place in the list above.

(Please, be patient, I'll fill this with all contributors to all mods
within mods itself and within this readme)


VI - License
------------

**Beta** is here!
All stuff in /mods has become GPLv3 if that's possible.
If it isn't for some mod - that is the subject to be replaced by my own
somewhat similar mod written/rewritten from scratch.

That means that:
 * You can fork it and make pull requests
 * I want to properly credit anyone who made this possible
 * I would appreciate any help
 * I want to add some things w/o being forced to support forks
 * I need time to create some basic features that are still not listed here
