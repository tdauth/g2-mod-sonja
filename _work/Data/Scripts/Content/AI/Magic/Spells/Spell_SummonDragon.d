// ******************
// SPL_SummonDragon		/k6
// ******************

const int SPL_Cost_SummonDragon		= 120;

INSTANCE Spell_SummonDragon (C_Spell_Proto)
{
	time_per_mana			= 0;
	targetCollectAlgo		= TARGET_COLLECT_NONE;
};

func int Spell_Logic_SummonDragon(var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_SummonDragon && self != VLK_436_Sonja)
	{
		return SPL_SENDCAST;
	}
	else //nicht genug Mana
	{
		return SPL_SENDSTOP;
	};
};

func void Spell_Cast_SummonDragon()
{
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_SummonDragon;
	};


	if (Npc_IsPlayer(self))
	{
		Wld_SpawnNpcRange( self,Dragon_Sonja,1,500);
	}
	else
	{
		Wld_SpawnNpcRange( self,Dragon_Sonja,1,500);
	};

	self.aivar[AIV_SelectSpell] += 1;
};
