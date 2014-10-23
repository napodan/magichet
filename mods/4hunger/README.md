This mod adds hunger.
=====================

What to expect (for MC players)
-------------------------------
Expect Minecraft-like hunger behavior.
There's a link to a wiki inside the init.lua where MC hunger mechanics are explained.

What to expect 2 (for non-MC players)
-------------------------------------
You have 20 hunger_points (visible statusbar) and 20 food_saturation points.
Every action you perform increases food_exhaustion level by some value (based on taken action type).
Every time the food_exhaustion level exceeds 4, your food_saturation decreases by 1.
When there's no food_saturation left you start losing hunger_points.
If there are no hunger_points left then you start losing HP - one per 5 seconds.
If that happens - just eat something! Not much food supported ATM.
If there are more than 17 hunger_points left then you start regenerating HP - one per 5 seconds.

Pay attention to what you're eating - you may get poisoned!
Poison drains your health and food saturation points.
HP decrease is RaNDoM. But it won't kill ya :)

Unless you'll be *very* hungry for 2 or more minutes. Then it WILL.

*Set up:* Edit or create an then edit the "4hinger.lua" in your world folder.

*Depends:* NONE

*Soft-depends:* NONE

*License:* CC BY-NC-SA (3.0)

--------------------------------
My "ghosts" mod supported and "sprint" mod "incorporated".
Also (for better experience) try out my 4items mod along this one.
Or eat only strange and default apples.

**NOTE:**

In order to work this mod need to substitute on_eat of every eatable item.
So do **not** expect supported items to heal hearts or to act like it was defined anywhere but this mod.
