
// ****************************************************
// ROTELATERNE_S1
// --------------
// Funktion wird durch RoteLaterne-Mobsi-Benutzung aufgerufen!
// *****************************************************
FUNC VOID ROTELATERNE_S1 ()
{
	var C_NPC her; 	her = Hlp_GetNpc(PC_Hero); 
	
	if  (Hlp_GetInstanceID(self)==Hlp_GetInstanceID(her))
	{	
		self.aivar[AIV_INVINCIBLE]=TRUE; 
		PLAYER_MOBSI_PRODUCTION	=	MOBSI_ROTELATERNE;
		Ai_ProcessInfos (her);
	};
}; 

//*******************************************************
//	RoteLaterne Dialog abbrechen
//*******************************************************
INSTANCE PC_RoteLaterne_End (C_Info)
{
	npc				= PC_Hero;
	nr				= 999;
	condition		= PC_RoteLaterne_End_Condition;
	information		= PC_RoteLaterne_End_Info;
	permanent		= TRUE;
	description		= DIALOG_ENDE; 
};

FUNC INT PC_RoteLaterne_End_Condition ()
{
	if (PLAYER_MOBSI_PRODUCTION	==	MOBSI_ROTELATERNE)
	{	
		return TRUE;
	};
};

FUNC VOID PC_RoteLaterne_End_Info()
{
	B_ENDPRODUCTIONDIALOG ();
};

//*******************************************************
// Wachen anheuern
//---------------------------
//*******************************************************
INSTANCE PC_RoteLaterne_Guards (C_Info)
{
	npc				= PC_Hero;
	condition		= PC_RoteLaterne_Guards_Condition;
	information		= PC_RoteLaterne_Guards_Info;
	permanent		= TRUE;
	description		= "Wachen anheuern (5000 Gold)";
};

FUNC INT PC_RoteLaterne_Guards_Condition ()
{
	if (PLAYER_MOBSI_PRODUCTION	==	MOBSI_ROTELATERNE)
	&& (RoteLaterne_Guards == FALSE)
	{	
		return TRUE;
	};
};

FUNC VOID PC_RoteLaterne_Guards_Info()
{
	if (Npc_HasItems (self, ItMi_Gold) > 5000)
	{
        B_GiveInvItems (self, other, ItMi_Gold, 5000);
        RoteLaterne_Guards = TRUE;
        Wld_InsertNpc (VLK_15001_Wache,"NW_CITY_HABOUR_PUFF_ENTRANCE");
        Wld_InsertNpc (VLK_15002_Wache,"NW_CITY_HABOUR_PUFF_ENTRANCE");
        PrintScreen ("Zwei Wachen angeheuert.", -1, -1, FONT_ScreenSmall, 2);
	}
	else
	{
        AI_Output (self, other, "DIA_PC_RoteLaterne_Guards_15_00"); //Ich habe nicht genug Gold dabei.
	};
};

//*******************************************************
// Freudendamen ausbilden
//---------------------------
//*******************************************************
INSTANCE PC_RoteLaterne_TeachEmployees (C_Info)
{
	npc				= PC_Hero;
	condition		= PC_RoteLaterne_TeachEmployees_Condition;
	information		= PC_RoteLaterne_TeachEmployees_Info;
	permanent		= TRUE;
	description		= "Freudendamen ausbilden (500 Gold)";
};

FUNC INT PC_RoteLaterne_TeachEmployees_Condition ()
{
	if (PLAYER_MOBSI_PRODUCTION	==	MOBSI_ROTELATERNE)
	{
		return TRUE;
	};
};

FUNC VOID PC_RoteLaterne_TeachEmployees_Info()
{
	if (Npc_HasItems (self, ItMi_Gold) > 500)
	{
        if (B_TeachAufreisserTalentPercent (self, Sonja, 1, 100) || B_TeachAufreisserTalentPercent (self, Nadja, 1, 100) || B_TeachAufreisserTalentPercent (self, Vanja, 1, 100))
        {
            B_GiveInvItems (self, other, ItMi_Gold, 500);
        }
        else
        {
            AI_Output (self, other, "DIA_PC_RoteLaterne_TeachEmployees_15_00"); //Meine Freudendamen sind bereits zu gut ausgebildet.
        };
	}
	else
	{
        AI_Output (self, other, "DIA_PC_RoteLaterne_Guards_15_00"); //Ich habe nicht genug Gold dabei.
	};
};


//*******************************************************
// Info
//---------------------------
//*******************************************************
INSTANCE PC_RoteLaterne_Info (C_Info)
{
	npc				= PC_Hero;
	condition		= PC_RoteLaterne_Info_Condition;
	information		= PC_RoteLaterne_Info_Info;
	permanent		= TRUE;
	description		= "Zustand der Roten Laterne";
};

FUNC INT PC_RoteLaterne_Info_Condition ()
{
	if (PLAYER_MOBSI_PRODUCTION	==	MOBSI_ROTELATERNE)
	{
		return TRUE;
	};
};

FUNC VOID PC_RoteLaterne_Info_Info()
{
    var string ConcatText;

	ConcatText = ConcatStrings ("Nadja Aufreiﬂer: ", IntToString (Npc_GetTalentSkill(Nadja, NPC_TALENT_WOMANIZER)));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	ConcatText = ConcatStrings ("Vanja Aufreiﬂer: ", IntToString (Npc_GetTalentSkill(Vanja, NPC_TALENT_WOMANIZER)));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, 2, FONT_ScreenSmall,2);
};

