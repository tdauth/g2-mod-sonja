# Gothic II Modification Sonja

Allows to buy NPC Sonja (VLK_436_Sonja) as a companion with special services.

## How to Play

Download and run the installer setup [Sonja-1.0.exe](./Sonja-1.0.exe).
Run the "GothicStarter" and choose the mod Sonja to play Gothic II with.

## Features

Sonja provides the following features:

* Follows the player's hero as companion to fight with him and increase his XP.
* Sells useful items.
* Works for the player's hero which gives him extra gold.
* Teach her skills with her own XP.
* Buy her better equipment.
* Change her look.
* Make her summon new females.
* Make her do different routines and send her to different locations.
* Marry her to cook for the player's hero.
* Sleep with her to regenerate life and mana and or to change the time of day.
* New rune items to summon her anywhere and to teleport to her from anywhere.
* New rune to summon a dragon.
* New rune to transform into a dragon.
* Summoned creatures are allied now.
* She has only 90 mana maximum now instead of 1000 since she supports the hero now.
* Teaches the newly added skills "Womanizer" and "Pimp".
* Can sell the Meatbug pet Hans.
* You can buy the Rote Laterne from Bromor and run it.

## Modified Files

* [VLK_436_Sonja.d](./_work/Data/Scripts/Content/Story/NPC/VLK_436_Sonja.d)
* [DIA_VLK_436_Sonja.d](./_work/Data/Scripts/Content/Story/Dialoge/DIA_VLK_436_Sonja.d)
* [DIA_VLK_433_Bromor.d](./_work/Data/Scripts/Content/Story/Dialoge/DIA_VLK_433_Bromor.d)
* [DIA_VLK_434_Borka.d](./_work/Data/Scripts/Content/Story/Dialoge/DIA_VLK_434_Borka.d)
* [DIA_VLK_435_Nadja.d](./_work/Data/Scripts/Content/Story/Dialoge/DIA_VLK_435_Nadja.d)
* [IT_SonjaRune.d](./_work/Data/Scripts/Content/Items/IT_SonjaRune.d)
* [Spell_SummonDragon.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_SummonDragon.d)
* [Spell_SummonSonja.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_SummonSonja.d)
* [Spell_Teleport_Alle.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_Teleport_Alle.d)
* [Spell_Transform_Alle.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_Transform_Alle.d)
* [Spell_ProcessMana.d](./_work/Data/Scripts/Content/AI/Magic/Spell_ProcessMana.d)
* [C_CanNpcCollideWithSpell.d](./_work/Data/Scripts/Content/AI/Magic/C_CanNpcCollideWithSpell.d)
* [B_GiveTradeInv_Sonja.d](./_work/Data/Scripts/Content/Story/B_GiveTradeInv/B_GiveTradeInv_Sonja.d)
* [B_GiveTradeInv.d](./_work/Data/Scripts/Content/Story/B_GiveTradeInv/B_GiveTradeInv.d)
* [B_AAA_ApplySonjaStats.d](./_work/Data/Scripts/Content/Story/B_Story/B_AAA_ApplySonjaStats.d)
* [B_GetLearnCostAttribute.d](./_work/Data/Scripts/Content/Story/B_Story/B_GetLearnCostAttribute.d)
* [B_GivePlayerXP.d](./_work/Data/Scripts/Content/Story/B_Story/B_GivePlayerXP.d)
* [B_Enter_DragonIsland.d](./_work/Data/Scripts/Content/Story/B_Story/B_Enter_DragonIsland.d)
* [B_Enter_SonjaWorld.d](./_work/Data/Scripts/Content/Story/B_Story/B_Enter_SonjaWorld.d)
* [B_TeachAttributePoints.d](./_work/Data/Scripts/Content/Story/B_Story/B_TeachAttributePoints.d)
* [AI_Constants.d](./_work/Data/Scripts/Content/AI/AI_Intern/AI_Constants.d)
* [Species.d](./_work/Data/Scripts/Content/AI/AI_Intern/Species.d)
* [ZS_Talk.d](./_work/Data/Scripts/Content/AI/Human/ZS_Human/ZS_Talk.d)
* [B_AAA_AssignSonja.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_AssignSonja.d)
* [B_AAA_Aufreissen.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_Aufreissen.d)
* [B_AAA_Pimp.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_Pimp.d)
* [B_InitMonsterAttitudes.d](./_work/Data/Scripts/Content/Story/NPC/Monster/B_Monster/B_InitMonsterAttitudes.d)
* [MST_Dragon_Sonja.d](./_work/Data/Scripts/Content/Story/NPC/Monster/MST_Dragon_Sonja.d)
* [MST_Meatbug.d](./_work/Data/Scripts/Content/Story/NPC/Monster/MST_Meatbug.d)
* [NPC_Globals.d](./_work/Data/Scripts/Content/Story/NPC_Globals.d)
* [Text.d](./_work/Data/Scripts/Content/Story/Text.d)
* [Startup.d](./_work/Data/Scripts/Content/Story/Startup.d)
* [Menu_Status.d](./_work/Data/Scripts/System/MENU/Menu_Status.d)
* [Constants.d](./_work/Data/Scripts/Content/_intern/Constants.d)
* [VisualFxInst.d](./_work/Data/Scripts/System/VisualFX/VisualFxInst.d)
* [Gothic.src](./_work/Data/Scripts/Content/Gothic.src)
* [OUINFO.INF](./_work/Data/Scripts/_compiled/OUINFO.INF)
* [OU.BIN](./_work/Data/Scripts/content/CUTSCENE/OU.BIN)
* [CS.BIN](./_work/Data/Scripts/content/CUTSCENE/CS.BIN)
* Currently not used but maybe later for a custom home: [DieGestrandeten.zen](./_work/Data/Worlds/Sonja/DieGestrandeten.zen)

## TODOs

* Add Sonja to all other world and apply her stats, skills, XP, level, learn points and inventory when changing the world.
* Add a custom castle in a new world which can be bought for Sonja with guards etc.
* Add options to give her and make her use permanent potions or herbs.
* The skill "Womanizer" needs to be more balanced and give some useful gold, XP and items. Add the dialog option to more ambient NPCs.
* Add more items and collect item options to the dialog of Sonja.
* Integrate the patch menu and let the user configure the days until you can do some actions in the dialog.
* Fix the summon and teleport runes.
* Add more companions to be purchased from Sonja like a mage, warrior, archer etc.
* Add a real NSIS based installer (see [documentation](https://wiki.worldofgothic.de/doku.php?id=nsis)).
* German dubbing. Find German voice actors for Sonja and the hero after completing all dialogs.

## Credits

* nneka.: [Insel Zen](https://www.worldofgothic.de/?go=moddb&action=view&fileID=429&cat=18&page=2&order=0)
* Tandrael: [Velaya Rüstungen](https://www.worldofgothic.de/?go=moddb&action=view&fileID=1415&cat=0&page=0&order=0&searchkey=velaya&searchcat=0)

## Links

* [Announcement Thread on World of Gothic](https://forum.worldofplayers.de/forum/threads/1596847-Gothic-II-Erweiterungsmod-Ank%C3%BCndigung-Sonja?p=27037960#post27037960)
