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
// Inventar
var int SonjaEquippedArmor;
var int SonjaEquippedMeleeWeapon;
var int SonjaEquippedRangedWeapon;
var int SonjaInventoryItem[100];

var int SonjaLoad;

// Erlerntes Speichern für Reset
var int SonjaRaisedAttributes[ATR_INDEX_MAX];
var int SonjaRaisedAttributesSpentLP[ATR_INDEX_MAX];

func int B_StoreSonjaStats(var C_NPC slf)
{
    if (Hlp_IsValidNpc(slf))
    {
        SonjaLP = slf.lp;
        SonjaEXP = slf.exp;
        SonjaEXP_NEXT = slf.exp_next;
        SonjaLevel = slf.level;

        SonjaSTR = slf.attribute[ATR_STRENGTH];
        SonjaDEX = slf.attribute[ATR_DEXTERITY];
        SonjaMANA_MAX = slf.attribute[ATR_MANA_MAX];
        SonjaHP_MAX = slf.attribute[ATR_HITPOINTS_MAX];
        SonjaHitChance1H = slf.aivar[REAL_TALENT_1H];
        SonjaHitChance2H = slf.aivar[REAL_TALENT_2H];
        SonjaHitChanceBow = slf.aivar[REAL_TALENT_BOW];
        SonjaHitChanceCrossBow = slf.aivar[REAL_TALENT_CROSSBOW];

        SonjaTalentMage = Npc_GetTalentSkill(slf, NPC_TALENT_MAGE);
        SonjaTalentSneak = Npc_GetTalentSkill(slf, NPC_TALENT_SNEAK);
        SonjaTalentAcrobat = Npc_GetTalentSkill(slf, NPC_TALENT_ACROBAT);

        var c_item equippedItem;
        equippedItem = Npc_GetEquippedArmor(slf);
        SonjaEquippedArmor = Hlp_GetInstanceID(equippedItem);
        equippedItem = Npc_GetEquippedMeleeWeapon(slf);
        SonjaEquippedMeleeWeapon = Hlp_GetInstanceID(equippedItem);
        equippedItem = Npc_GetEquippedRangedWeapon(slf);
        SonjaEquippedRangedWeapon = Hlp_GetInstanceID(equippedItem);

        SonjaLoad = TRUE;

        return TRUE;
    };

    return FALSE;
};

func int B_ApplySonjaStats(var C_NPC slf)
{
    if (SonjaLoad)
    {
        slf.lp = SonjaLP;
        slf.exp = SonjaEXP;
        slf.exp_next = SonjaEXP_NEXT;
        slf.level = SonjaLevel;
        slf.attribute[ATR_STRENGTH] = SonjaSTR;
        slf.attribute[ATR_DEXTERITY] = SonjaDEX;
        slf.attribute[ATR_MANA_MAX] = SonjaMANA_MAX;
        slf.attribute[ATR_HITPOINTS_MAX] = SonjaHP_MAX;
        slf.HitChance[NPC_TALENT_1H] = SonjaHitChance1H;
        slf.aivar[REAL_TALENT_1H] = SonjaHitChance1H;
        slf.HitChance[NPC_TALENT_2H] = SonjaHitChance2H;
        slf.aivar[REAL_TALENT_2H] = SonjaHitChance2H;
        slf.HitChance[NPC_TALENT_BOW] = SonjaHitChanceBow;
        slf.aivar[REAL_TALENT_BOW] = SonjaHitChanceBow;
        slf.HitChance[NPC_TALENT_CROSSBOW] = SonjaHitChanceCrossBow;
        slf.aivar[REAL_TALENT_CROSSBOW] = SonjaHitChanceCrossBow;

        Npc_SetTalentSkill (slf, NPC_TALENT_MAGE, SonjaTalentMage);
        Npc_SetTalentSkill (slf, NPC_TALENT_SNEAK, SonjaTalentSneak);
        Npc_SetTalentSkill (slf, NPC_TALENT_ACROBAT, SonjaTalentAcrobat);

        if (SonjaEquippedArmor != 0)
        {
            if (Npc_HasItems(slf, SonjaEquippedArmor) == FALSE)
            {
                CreateInvItem(slf, SonjaEquippedArmor);
            };

            EquipItem(slf, SonjaEquippedArmor);
        };

        if (SonjaEquippedMeleeWeapon != 0)
        {
            if (Npc_HasItems(slf, SonjaEquippedMeleeWeapon) == FALSE)
            {
                CreateInvItem(slf, SonjaEquippedMeleeWeapon);
            };

            EquipItem(slf, SonjaEquippedMeleeWeapon);
        };

        if (SonjaEquippedRangedWeapon != 0)
        {
            if (Npc_HasItems(slf, SonjaEquippedRangedWeapon) == FALSE)
            {
                CreateInvItem(slf, SonjaEquippedRangedWeapon);
            };

            EquipItem(slf, SonjaEquippedRangedWeapon);
        };

        SonjaLoad = FALSE;

        return TRUE;
    };

    return FALSE;
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

    if (next < ATR_INDEX_MAX)
    {
        B_ResetSonjaAttributesStartingFrom(slf, next);
    };
};

// Setzt erlernte Attribute zurück und gibt dem NPC die dafür ausgegebenen Lernpunkte zurück. Sollte nur für die eine Sonja aufgerufen werden.
func void B_ResetSonja(var C_NPC slf)
{
    B_ResetSonjaAttributesStartingFrom(slf, 0);
};
