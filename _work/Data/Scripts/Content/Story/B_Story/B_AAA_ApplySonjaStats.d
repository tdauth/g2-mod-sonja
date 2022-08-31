// ******************************************************************
// B_ApplySonjaStats
// ---------------
// setzt die gespeicherten Attribute und Talente für den NSC.
// ******************************************************************
var int SonjaEXP;
var int SonjaEXP_NEXT;
var int SonjaLP;
var int SonjaLevel;
var int SonjaSTR;
var int SonjaDEX;
var int SonjaHP_MAX;
var int SonjaMANA_MAX;
// Hit Chances
var int SonjaHitChance1H;
var int SonjaHitChance2H;
var int SonjaHitChanceBow;
var int SonjaHitChanceCrossBow;
// Talente
var int SonjaTalent1H;
var int SonjaTalent2H;
var int SonjaTalentBow;
var int SonjaTalentCrossBow;
var int SonjaTalentMage;
var int SonjaTalentSneak;
var int SonjaTalentAcrobat;

// Erlerntes Speichern für Reset
var int SonjaRaisedAttributes[ATR_INDEX_MAX];
var int SonjaRaisedAttributesSpentLP[ATR_INDEX_MAX];

func void B_StoreSonjaStats(var C_NPC slf)
{
    SonjaLP = slf.lp;
    SonjaEXP = slf.exp;
    SonjaEXP_NEXT = slf.exp_next;
    SonjaLevel = slf.level;
};

func void B_ApplySonjaStats(var C_NPC slf)
{
    slf.lp = SonjaLP;
    slf.exp = SonjaEXP;
    slf.exp_next = SonjaEXP_NEXT;
    slf.level = SonjaLevel;
};

func void B_ResetSonjaAttributesStartingFrom(var C_NPC slf, var int attrib)
{
    if (attrib == ATR_STRENGTH)
	{
        slf.attribute[ATR_STRENGTH] = slf.attribute[ATR_STRENGTH] - SonjaRaisedAttributes[ATR_STRENGTH];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_STRENGTH];
	}
	// ------ DEX steigern ------
	else if (attrib == ATR_DEXTERITY)
	{
		slf.attribute[ATR_DEXTERITY] = slf.attribute[ATR_DEXTERITY] - SonjaRaisedAttributes[ATR_DEXTERITY];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_DEXTERITY];

			//if (oth.attribute[ATR_DEXTERITY] >= 90)
			//&& (Npc_GetTalentSkill (oth, NPC_TALENT_ACROBAT) == 0)
			//{
				//Npc_SetTalentSkill 	(oth, NPC_TALENT_ACROBAT, 1);
				//PrintScreen	(PRINT_Addon_AcrobatBonus, -1, 55, FONT_Screen, 2);
			//};

	}
	// ------ MANA_MAX steigern ------
	else if (attrib == ATR_MANA_MAX)
	{
        slf.attribute[ATR_MANA_MAX] = slf.attribute[ATR_MANA_MAX] - SonjaRaisedAttributes[ATR_MANA_MAX];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_MANA_MAX];
	}
	// ------ HITPOINTS_MAX steigern ------
	else if (attrib == ATR_HITPOINTS_MAX)
	{
        slf.attribute[ATR_HITPOINTS_MAX] = slf.attribute[ATR_HITPOINTS_MAX] - SonjaRaisedAttributes[ATR_HITPOINTS_MAX];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_HITPOINTS_MAX];
	};

	var int next;
    next = attrib + 1;

    if (attrib < ATR_INDEX_MAX)
    {
        B_ResetSonjaAttributesStartingFrom(slf, attrib);
    };
};

// Setzt erlernte Attribute zurück und gibt dem NPC die dafür ausgegebenen Lernpunkte zurück. Sollte nur für die eine Sonja aufgerufen werden.
func void B_ResetSonja(var C_NPC slf)
{
    B_ResetSonjaAttributesStartingFrom(slf, 0);
};
