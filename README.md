# Gothic II Modification Sonja

Allows to buy NPC Sonja (VLK_436_Sonja) as a companion with special services.

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
* She has only 90 mana maximum now instead of 1000 since she supports the hero now.
* Teaches the newly added skills "Womanizer" and "Pimp".
* Can sell the Meatbug pet Hans.

## Modified Files

* [VLK_436_Sonja.d](./_work/Data/Scripts/Content/Story/Dialoge/VLK_436_Sonja.d)
* [DIA_VLK_436_Sonja.d](./_work/Data/Scripts/Content/Story/NPC/DIA_VLK_436_Sonja.d)
* [IT_SonjaRune.d](./_work/Data/Scripts/Content/Items/IT_SonjaRune.d)
* [Spell_SummonSonja.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_SummonSonja.d)
* [Spell_Teleport_Alle.d](./_work/Data/Scripts/Content/AI/Magic/Spells/Spell_Teleport_Alle.d)
* [Spell_ProcessMana.d](./_work/Data/Scripts/Content/AI/Magic/Spell_ProcessMana.d)
* [B_GiveTradeInv_Sonja.d](./_work/Data/Scripts/Content/Story/B_GiveTradeInv/B_GiveTradeInv_Sonja.d)
* [B_GivePlayerXP.d](./_work/Data/Scripts/Content/Story/B_Story/B_GivePlayerXP.d)
* [B_Enter_SonjaWorld.d](./_work/Data/Scripts/Content/Story/B_Story/B_Enter_SonjaWorld.d)
* [AI_Constants.d](./_work/Data/Scripts/Content/AI/AI_Intern/AI_Constants.d)
* [ZS_Talk.d](./_work/Data/Scripts/Content/AI/Human/ZS_Human/ZS_Talk.d)
* [B_AAA_AssignSonja.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_AssignSonja.d)
* [B_AAA_Aufreissen.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_Aufreissen.d)
* [B_AAA_Pimp.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AAA_Pimp.d)
* [MST_Meatbug.d](./_work/Data/Scripts/Content/Story/NPC/Monster/MST_Meatbug.d)
* [B_AssignAmbientInfos_BAU_16.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AssignAmbientInfos_BAU_16.d)
* [B_AssignAmbientInfos_VLK_16.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AssignAmbientInfos_VLK_16.d)
* [B_AssignAmbientInfos_VLK_17.d](./_work/Data/Scripts/Content/Story/B_AssignAmbientInfos/B_AssignAmbientInfos_VLK_17.d)
* [NPC_Globals.d](./_work/Data/Scripts/Content/Story/NPC_Globals.d)
* [Text.d](./_work/Data/Scripts/Content/Story/Text.d)
* [Startup.d](./_work/Data/Scripts/Content/Story/Startup.d)
* [Menu_Opt_Sonja.d](./_work/Data/Scripts/System/MENU/Menu_Opt_Sonja.d)
* [Menu_Status.d](./_work/Data/Scripts/System/MENU/Menu_Status.d)
* [Constants.d](./_work/Data/Scripts/Content/_intern/Constants.d)
* [Gothic.src](./_work/Data/Scripts/Content/Gothic.src)
* [OUINFO.INF](./_work/Data/Scripts/_compiled/OUINFO.INF)
* [OU.BIN](./_work/Data/Scripts/content/CUTSCENE/OU.BIN)
* [CS.BIN](./_work/Data/Scripts/content/CUTSCENE/CS.BIN)
* Currently not used but maybe later for a custom home: [DieGestrandeten.zen](./_work/Data/Worlds/Sonja/DieGestrandeten.zen)

## TODOs

* Add a custom castle in a new world which can be bought for Sonja with guards etc.
* The skill "Womanizer" needs to be more balanced and give some useful gold, XP and items. Add the dialog option to more ambient NPCs.
* Add more items and collect item options to the dialog of Sonja.
* Integrate the patch menu and let the user configure the days until you can do some actions in the dialog.
* Fix the summon and teleport runes.
* Add more companions to be purchased from Sonja like a mage, warrior, archer etc.
* Add a real NSIS based installer (see [documentation](https://wiki.worldofgothic.de/doku.php?id=nsis)).

## Dependencies

* neocromicon: [PatchMenu - Ein eigenes Menü für Feature-Patches](https://www.worldofgothic.de/modifikation/download_674.htm)

## Credits

* nneka.: [Insel Zen](https://www.worldofgothic.de/?go=moddb&action=view&fileID=429&cat=18&page=2&order=0)
