// ******************
// SPL_SummonSonja		/k0
// ******************

const int SPL_Cost_SummonSonja		= 5;

INSTANCE Spell_SummonSonja (C_Spell_Proto)
{
	time_per_mana			= 0;
	spelltype 				= SPELL_GOOD;
	targetCollectAlgo		= TARGET_COLLECT_NONE;
};

func int Spell_Logic_SummonSonja(var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_SummonSonja && self != VLK_436_Sonja)
	{
		return SPL_SENDCAST;
	}
	else //nicht genug Mana
	{
		return SPL_SENDSTOP;
	};
};

func void Spell_Cast_SummonSonja()
{
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_SummonSonja;
	};

	var string wpName;
	wpName = Npc_GetNearestWP(hero);

	if (Hlp_IsValidNpc(Sonja))
	{
        if (Npc_IsDead(Sonja))
        {
            Sonja.attribute[ATR_HITPOINTS] = Sonja.attribute[ATR_HITPOINTS_MAX];
            PrintScreen ("Sonja wiederbelebt!", - 1, - 1, FONT_Screen, 2);

            Sonja.aivar[AIV_PARTYMEMBER] = TRUE;

            if (CurrentLevel == OLDWORLD_ZEN)
            {
                Npc_ExchangeRoutine	(Sonja,"FOLLOWOLDWORLD");
            }
            else if (CurrentLevel == NEWWORLD_ZEN)
            {
                Npc_ExchangeRoutine	(Sonja,"FOLLOW");
            }
            else if (CurrentLevel == ADDONWORLD_ZEN)
            {
                Npc_ExchangeRoutine	(Sonja, "FOLLOWADDONWORLD");
            }
            else if (CurrentLevel == DRAGONISLAND_ZEN)
            {
                Npc_ExchangeRoutine	(Sonja,"FOLLOWDRAGONISLAND");
            };

            Sonja.aivar[AIV_PARTYMEMBER] = TRUE;
            Sonja.flags = 0; // NPC_FLAG_IMMORTAL
        };

        AI_Teleport(Sonja, wpName);
        //AI_GotoNpc(VLK_436_Sonja, hero);
    }
    else
    {
        PrintScreen ("Sonja ist nicht zu finden!", - 1, - 1, FONT_Screen, 2);
    };

	self.aivar[AIV_SelectSpell] += 1;
};
