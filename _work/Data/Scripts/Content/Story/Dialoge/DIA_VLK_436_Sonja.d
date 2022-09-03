var int SonjaFolgt;							//= TRUE Sonja wurde freigekauft.
var int SonjaGeheiratet;					//= TRUE Sonja geheiratet.
var int SonjaGefragt;						//= TRUE Sonja nach Freikaufen gefragt.
var int SonjaSummonDays;
var int SonjaSexDays;
var int SonjaProfitDays;
var int SonjaRespawnDays;
var int SonjaRespawnItemsDays;
var int SonjaCookDays;
var int 	Sonja_SkinTexture; // 137 Frau
var int 	Sonja_BodyTexture; // BodyTex_N
var string 	Sonja_HeadMesh; // Hum_Head_Babe8

// ************************************************************
// 			Change Sonja Visual
// ************************************************************

FUNC VOID	Change_Sonja_Visual()
{
	B_SetNpcVisual 		(self, FEMALE, Sonja_HeadMesh, Sonja_SkinTexture, Sonja_BodyTexture, NO_ARMOR);

	var string printText;

	PrintScreen	("SkinTexture:" 		, -1, 10, "FONT_OLD_10_WHITE.TGA", 4 );

	printText = IntToString	(Sonja_SkinTexture);
	PrintScreen	(printText		, -1, 12, "FONT_OLD_10_WHITE.TGA", 2 );


	PrintScreen	("HeadMesh:"		, -1, 20, "FONT_OLD_10_WHITE.TGA", 2 );
	PrintScreen	(Sonja_HeadMesh		, -1, 22, "FONT_OLD_10_WHITE.TGA", 2 );

	PrintScreen	("BodyTexture:" 		, -1, 30, "FONT_OLD_10_WHITE.TGA", 4 );

	printText = IntToString	(Sonja_BodyTexture);
	PrintScreen	(printText		, -1, 32, "FONT_OLD_10_WHITE.TGA", 2 );

};

///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_EXIT   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 999;
	condition   = DIA_Sonja_EXIT_Condition;
	information = DIA_Sonja_EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Sonja_EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Sonja_EXIT_Info()
{
	AI_StopProcessInfos (self);
};
// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Sonja_PICKPOCKET (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_PICKPOCKET_Condition;
	information	= DIA_Sonja_PICKPOCKET_Info;
	permanent	= TRUE;
	description = Pickpocket_60_Female;
};                       

FUNC INT DIA_Sonja_PICKPOCKET_Condition()
{
	C_Beklauen (58, 70);
};
 
FUNC VOID DIA_Sonja_PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Sonja_PICKPOCKET);
	Info_AddChoice		(DIA_Sonja_PICKPOCKET, DIALOG_BACK 		,DIA_Sonja_PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Sonja_PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Sonja_PICKPOCKET_DoIt);
};

func void DIA_Sonja_PICKPOCKET_DoIt()
{
	B_Beklauen ();
	Info_ClearChoices (DIA_Sonja_PICKPOCKET);
};
	
func void DIA_Sonja_PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Sonja_PICKPOCKET);
};

///////////////////////////////////////////////////////////////////////
//	Info STANDARD
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_STANDARD		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_STANDARD_Condition;
	information	 = 	DIA_Sonja_STANDARD_Info;
	important	 = 	TRUE;
	permanent	 = 	TRUE;
};

func int DIA_Sonja_STANDARD_Condition ()
{	
	if Npc_IsInState (self, ZS_Talk)
	&& (MIS_Andre_REDLIGHT != LOG_RUNNING)
	{
		return SonjaFolgt == FALSE;
	};
};
func void DIA_Sonja_STANDARD_Info ()
{
	if (self.aivar[AIV_TalkedToPlayer] == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_00"); //Sprich mit Bromor, wenn du Spaß haben willst.
	}
	else if (other.guild == GIL_DJG)
	&& (Sonja_Says == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_01"); //Das Problem mit euch Typen ist, dass ihr lieber Orks abschlachtet als zu vögeln.
		Sonja_Says = TRUE;
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_02"); //Wenn du quatschen willst, such dir 'ne Frau und heirate sie.
	};

	Log_CreateTopic ("Sonja", LOG_NOTE);
};

// ************************************************************
// 			  				BEZAHLEN
// ************************************************************

INSTANCE DIA_Sonja_BEZAHLEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	condition	= DIA_Sonja_BEZAHLEN_Condition;
	information	= DIA_Sonja_BEZAHLEN_Info;
	permanent	= TRUE;
	description = "Freikaufen (1000 Gold geben)";
};

func int DIA_Sonja_BEZAHLEN_Condition ()
{
	return SonjaGefragt && SonjaFolgt == FALSE;
};

FUNC VOID DIA_Sonja_BEZAHLEN_Info()
{
	Info_ClearChoices	(DIA_Sonja_BEZAHLEN);
	Info_AddChoice		(DIA_Sonja_BEZAHLEN, DIALOG_BACK 		,DIA_Sonja_BEZAHLEN_BACK);
	Info_AddChoice		(DIA_Sonja_BEZAHLEN, "1000 Gold geben"	,DIA_Sonja_BEZAHLEN_DoIt);
};

// Komm mit.

func void SonjaComeOn()
{
    if (C_BodyStateContains (self, BS_SIT))
    {
        AI_StandUp (self);
        B_TurnToNpc (self,other);
    };
    self.aivar[AIV_PARTYMEMBER] = TRUE;

    if (CurrentLevel == OLDWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOWOLDWORLD");
    }
    else if (CurrentLevel == NEWWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOW");
    }
    else if (CurrentLevel == ADDONWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self, "FOLLOWADDONWORLD");
    }
    else if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOWDRAGONISLAND");
    };

    self.aivar[AIV_PARTYMEMBER] = TRUE;
    self.flags = 0; // NPC_FLAG_IMMORTAL
};

func void DIA_Sonja_BEZAHLEN_DoIt()
{
	if (Npc_HasItems (other, ItMi_Gold) < 1000)
	{
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_00"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
	}
	else
	{
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_01"); //1000 Goldstücke! Wahnsinn! Endlich mal ein reicher Mann im Hafen, der weiß wie man eine Dame behandelt.
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_02"); //Lass uns abhauen!
        B_LogEntry ("Sonja", "Sonja folgt mir nun und arbeitet für mich.");
        SonjaFolgt = TRUE;
        SonjaSummonDays = 0;
        SonjaRespawnItemsDays = 0;
        SonjaSexDays = 0;
        SonjaProfitDays = 0;
        SonjaRespawnDays = 0;
        SonjaCookDays = 0;
        Sonja_SkinTexture = FaceBabe_L_Charlotte2;
        Sonja_BodyTexture = BodyTexBabe_L;
        Sonja_HeadMesh = "Hum_Head_Babe6";
        SonjaComeOn();
	};

	Info_ClearChoices (DIA_Sonja_BEZAHLEN);
};

func void DIA_Sonja_BEZAHLEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_BEZAHLEN);
};

///////////////////////////////////////////////////////////////////////
//	Info FREIKAUFEN
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FREIKAUFEN		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_FREIKAUFEN_Condition;
	information	 = 	DIA_Sonja_FREIKAUFEN_Info;
	permanent	 = 	FALSE;
	description  =  "Ich möchte dich freikaufen!";
};

func int DIA_Sonja_FREIKAUFEN_Condition ()
{
	return SonjaFolgt == FALSE;
};

func void DIA_Sonja_FREIKAUFEN_Info ()
{
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_00"); //Ich möchte dich freikaufen!
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_00"); //Oh Romeo, willst du das wirklich tun? Hast du denn überhaupt genug Gold, um eine Frau wie mich zu versorgen?
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_01"); //Du könntest weiterhin für mich arbeiten.
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_02"); //Sagen wir so: Wenn du mir eine Menge Gold gibst und mehr übrig lässt als Bromor, dann verlasse ich gerne die Rote Laterne.
    B_LogEntry ("Sonja", "Sonja, die Freudendame in der Roten Laterne, schließt sich mir an und arbeitet für mich, wenn ich ihr 1000 Goldstücke gebe.");
    SonjaGefragt = TRUE;
};

///////////////////////////////////////////////////////////////////////
//	Info HERBEIRUFEN
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HERBEIRUFEN		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_HERBEIRUFEN_Condition;
	information	 = 	DIA_Sonja_HERBEIRUFEN_Info;
	permanent	 = 	FALSE;
	description  =  "Wie kann ich dich rufen?";
};

func int DIA_Sonja_HERBEIRUFEN_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HERBEIRUFEN_Info ()
{
    AI_Output (other, self, "DIA_Sonja_HERBEIRUFEN_15_00"); //Wie kann ich dich rufen, wenn ich in Not bin?
    AI_Output (self, other, "DIA_Sonja_HERBEIRUFEN_16_00"); //Vatras hat mir eine Rune gebastelt, mit der er mich jederzeit beschwören konnte, nachdem seine Predigt fertig war. Ich habe noch welche bei mir. Kauf sie mir einfach ab.
};

///////////////////////////////////////////////////////////////////////
//	Info PEOPLE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_PEOPLE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_PEOPLE_Condition;
	information	 = 	DIA_Sonja_PEOPLE_Info;
	permanent	 = 	TRUE;
	description  =  "Was hältst du von ...";
	nr		 	= 99;
};

func int DIA_Sonja_PEOPLE_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_PEOPLE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du vom Richter?"	,     DIA_Sonja_PEOPLE_Richter);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Lord Hagen?"	,     DIA_Sonja_PEOPLE_Hagen);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Vatras?"	,     DIA_Sonja_PEOPLE_Vatras);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Vanja?"	,     DIA_Sonja_PEOPLE_Vanja);
	Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Nadja?"	,     DIA_Sonja_PEOPLE_Nadja);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Bromor?"	,     DIA_Sonja_PEOPLE_Bromor);
    Info_AddChoice		(DIA_Sonja_PEOPLE, DIALOG_BACK 		,                 DIA_Sonja_PEOPLE_BACK);
};

func void DIA_Sonja_PEOPLE_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
};


func void DIA_Sonja_PEOPLE_Bromor ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Bromor_15_00"); //Was hältst du von Bromor?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_00"); //Bromor ist ein mieser Halsabschneider. Er nimmt den meisten Ertrag der Frauen für sich.

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_01"); //Aber was soll's? Meinen Prinzen habe ich ja jetzt gefunden!
    };

    B_LogEntry ("Sonja", "Sonja hält Bromor für einen miesen Halsabschneider.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Nadja ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Nadja_15_00"); //Was hältst du von Nadja?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_00"); //Nadja? Ach so eine graue Maus. Die kann doch gar nichts! Hübsch ist sie, zugegeben, aber Erfahrung hat sei kaum und Schönheit vergeht.
    B_LogEntry ("Sonja", "Sonja hält Nadja für eine graue Maus.");

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_01"); //Du findest sie doch nicht etwa hübscher als mich? Ich warne dich, schau sie bloß nicht an!
        B_LogEntry ("Sonja", "Sonja ist eifersüchtig auf Nadja.");
    };

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Vanja ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Vanja_15_00"); //Was hältst du von Vanja?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Vanja_16_00"); //Vanja? Die treibt es ganz schön wild mit diesem Peck. Der kriegt aber auch nicht genug von ihr. Eigentlich ist sie ganz nett.
    B_LogEntry ("Sonja", "Sonja hält Vanja für eine Nette, die es mit Peck ganz schön wild treibt.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Vatras ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Vatras_15_00"); //Was hältst du von Vatras?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Vatras_16_00"); //Vatras predigt jetzt viel ruhiger, seitdem er mir seine Wasserzauber gezeigt hat.

    B_LogEntry ("Sonja", "Sonja hat Vatras ruhiger gestimmt.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Hagen ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Hagen_15_00"); //Was hältst du von Lord Hagen?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Hagen_16_00"); //Im Bett durfte ich ihn nur mit Eure Lordschaft ansprechen.

    B_LogEntry ("Sonja", "Lord Hagen wurde nur als Eure Lordschaft von Sonja angesprochen.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Richter ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Richter_15_00"); //Was hältst du vom Richter?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Richter_16_00"); //Über mich hat er jede Nacht gerichtet. Sein Urteil viel zu meinen Gunsten aus.

    B_LogEntry ("Sonja", "Der Richter urteilte zu Sonjas gunsten.");

    DIA_Sonja_PEOPLE_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info NOT YET
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_NOT_YET		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_NOT_YET_Condition;
	information	 = 	DIA_Sonja_NOT_YET_Info;
	permanent	 = 	FALSE;
	description  =  "Gibt es überhaupt jemanden, der noch nicht Kunde bei dir war?";
	nr		 	= 99;
};

func int DIA_Sonja_NOT_YET_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_NOT_YET_Info ()
{
    AI_Output (other, self, "DIA_Sonja_NOT_YET_15_00"); //Gibt es überhaupt jemanden, der noch nicht Kunde bei dir war?
    AI_Output (self, other, "DIA_Sonja_NOT_YET_16_00"); //Hmm, nicht sehr viele Leute, aber ja. Ich kann dir eine Liste geben.
    B_LogEntry ("Sonja", "Sonja hat mir eine Liste von Leuten gegeben, die noch nicht Kunden bei ihr waren.");
    CreateInvItems (self, ItWr_SonjasListMissing, 1);
    B_GiveInvItems (self, other, ItWr_SonjasListMissing, 1);
};

///////////////////////////////////////////////////////////////////////
//	Info SKILL
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_SKILL		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_SKILL_Condition;
	information	 = 	DIA_Sonja_SKILL_Info;
	permanent	 = 	TRUE;
	description  =  "Wie erfahren bist du?";
	nr		 	= 3;
};

func int DIA_Sonja_SKILL_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_SKILL_Info ()
{
    Info_ClearChoices	(DIA_Sonja_SKILL);
    Info_AddChoice		(DIA_Sonja_SKILL, "Schutz"	,     DIA_Sonja_PROTECTION_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "Talente"	,     DIA_Sonja_SKILL_Exact_Info);
	Info_AddChoice		(DIA_Sonja_SKILL, "Attribute"	,     DIA_Sonja_STATS_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "Erfahrung"	,     DIA_Sonja_XP_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "(Verbleibende Erfahrung geben)"	,     DIA_Sonja_XP_Add_Remaining);
    Info_AddChoice		(DIA_Sonja_SKILL, DIALOG_BACK 		,                 DIA_Sonja_SKILL_BACK);
};

func void DIA_Sonja_SKILL_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_SKILL);
};

func void DIA_Sonja_XP_Add_Remaining ()
{
    if (SonjasRemainingXP > 0)
    {
        B_GiveSonjaRemainingXP();
    }
    else
    {
        AI_Output (self, other, "DIA_Sonja_XP_16_00"); //Das weiß ich alles schon.
    };

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_XP_Info ()
{
    AI_Output (other, self, "DIA_Sonja_XP_15_00"); //Wie erfahren bist du?
    AI_Output (self, other, "DIA_Sonja_XP_16_01"); //Finde es heraus!

    var String levelText;
    var String lpText;
    var String xpText;
    var String xpNextText;
    var String msg;

    levelText = ConcatStrings("Stufe: ", IntToString(self.level));
    lpText = ConcatStrings(" Lernpunkte: ", IntToString(self.lp));
    xpText = ConcatStrings(" XP: ", IntToString(self.exp));
    xpNextText = ConcatStrings(" XP nächste Stufe: ", IntToString(self.exp_next));
    msg = "";
    msg = ConcatStrings(msg, levelText);
    msg = ConcatStrings(msg, lpText);
    msg = ConcatStrings(msg, xpText);
    msg = ConcatStrings(msg, xpNextText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_STATS_Info ()
{
    AI_Output (other, self, "DIA_Sonja_STATS_15_00"); //Wie stark bist du?
    AI_Output (self, other, "DIA_Sonja_STATS_16_01"); //Finde es heraus!

    var String hpText;
    var String manaText;
    var String strText;
    var String dexText;
    var String msg;

    hpText = ConcatStrings("Leben: ", IntToString(self.attribute[ATR_HITPOINTS_MAX]));
    manaText = ConcatStrings(" Mana: ", IntToString(self.attribute[ATR_MANA_MAX]));
    strText = ConcatStrings(" Stärke: ", IntToString(self.attribute[ATR_STRENGTH]));
    dexText = ConcatStrings(" Geschick: ", IntToString(self.attribute[ATR_DEXTERITY]));
    msg = "";
    msg = ConcatStrings(msg, hpText);
    msg = ConcatStrings(msg, manaText);
    msg = ConcatStrings(msg, strText);
    msg = ConcatStrings(msg, dexText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_SKILL_Exact_Info ()
{
    AI_Output (other, self, "DIA_Sonja_SKILL_15_00"); //Wie gut bist du ausgebildet?
    AI_Output (self, other, "DIA_Sonja_STATS_16_01"); //Finde es heraus!

    var String text1H;
    var String text2H;
    var String textBow;
    var String textCrossbow;
    var String textMage;
    var String textSneak;
    var String msg;

    text1H = ConcatStrings("1H : ", IntToString(self.HitChance[NPC_TALENT_1H]));
    text1H = ConcatStrings(text1H, "% ");
    text2H = ConcatStrings("2H : ", IntToString(self.HitChance[NPC_TALENT_2H]));
    text2H = ConcatStrings(text2H, "% ");
    textBow = ConcatStrings("Bogen: ", IntToString(self.HitChance[NPC_TALENT_BOW]));
    textBow = ConcatStrings(textBow, "% ");
    textCrossbow = ConcatStrings("Armbrust: ", IntToString(self.HitChance[NPC_TALENT_CROSSBOW]));
    textCrossbow = ConcatStrings(textCrossbow, "% ");
    textMage = ConcatStrings("Magiekreis: ", IntToString(Npc_GetTalentSkill (self, NPC_TALENT_MAGE)));
    textMage = ConcatStrings(textMage, " ");
    textSneak = ConcatStrings("Schleichen: ", IntToString(Npc_GetTalentSkill (self, NPC_TALENT_SNEAK)));

    msg = "";
    msg = ConcatStrings(msg, text1H);
    msg = ConcatStrings(msg, text2H);
    msg = ConcatStrings(msg, textBow);
    msg = ConcatStrings(msg, textCrossbow);
    msg = ConcatStrings(msg, textMage);
    msg = ConcatStrings(msg, textSneak);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_PROTECTION_Info ()
{
    AI_Output (other, self, "DIA_Sonja_PROTECTION_15_00"); //Wie gut bist du geschützt?
    AI_Output (self, other, "DIA_Sonja_STATS_16_00"); //Finde es heraus!

    //CONST INT PROT_BARRIER									= DAM_INDEX_BARRIER		;
//CONST INT PROT_BLUNT									= DAM_INDEX_BLUNT		;
//CONST INT PROT_EDGE										= DAM_INDEX_EDGE		;
//CONST INT PROT_FIRE										= DAM_INDEX_FIRE		;
//CONST INT PROT_FLY										= DAM_INDEX_FLY			;
//CONST INT PROT_MAGIC									= DAM_INDEX_MAGIC		;
//CONST INT PROT_POINT									= DAM_INDEX_POINT		;
//CONST INT PROT_FALL										= DAM_INDEX_FALL		;

    var String barrierText;
    var String bluntText;
    var String edgeText;
    var String fireText;
    var String flyText;
    var String magicText;
    var String pointText;
    var String fallText;
    var String msg;

    barrierText = ConcatStrings("Barrier: ", IntToString(self.protection[PROT_BARRIER]));
    bluntText = ConcatStrings(" Blunt: ", IntToString(self.attribute[PROT_BLUNT]));
    edgeText = ConcatStrings(" Edge: ", IntToString(self.attribute[PROT_EDGE]));
    fireText = ConcatStrings(" Feuer: ", IntToString(self.attribute[PROT_FIRE]));
    flyText = ConcatStrings(" Flug: ", IntToString(self.attribute[PROT_FLY]));
    magicText = ConcatStrings(" Magie: ", IntToString(self.attribute[PROT_MAGIC]));
    pointText = ConcatStrings(" Punkt: ", IntToString(self.attribute[PROT_POINT]));
    fallText = ConcatStrings(" Fall: ", IntToString(self.attribute[PROT_FALL]));
    msg = "";
    msg = ConcatStrings(msg, barrierText);
    msg = ConcatStrings(msg, bluntText);
    msg = ConcatStrings(msg, edgeText);
    msg = ConcatStrings(msg, fireText);
    msg = ConcatStrings(msg, flyText);
    msg = ConcatStrings(msg, magicText);
    msg = ConcatStrings(msg, pointText);
    msg = ConcatStrings(msg, fallText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};


// ------------------------------------------------------------
// 						Komm (wieder) mit!
// ------------------------------------------------------------
instance DIA_Sonja_ComeOn(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr		 	= 1;
	condition	= DIA_Sonja_ComeOn_Condition;
	information	= DIA_Sonja_ComeOn_Info;
	permanent	= TRUE;
	description	= "Komm mit.";
};
func int DIA_Sonja_ComeOn_Condition ()
{
	if (self.aivar[AIV_PARTYMEMBER] == FALSE && SonjaFolgt == TRUE)
	{
		return TRUE;
	};
};
func void DIA_Sonja_ComeOn_Info ()
{
	AI_Output (other, self, "DIA_Addon_Skip_ComeOn_15_00"); //Komm mit.
    AI_Output (self ,other, "DIA_Sonja_COMEON_16_00"); //Ich folge dir mein Prinz!
    AI_StopProcessInfos (self);

    SonjaComeOn();
};

// ************************************************************
// 			  			Warte hier
// ************************************************************
INSTANCE DIA_Sonja_WarteHier (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 1;
	condition	= DIA_Sonja_WarteHier_Condition;
	information	= DIA_Sonja_WarteHier_Info;
	permanent	= TRUE;
	description = "Warte hier!";
};
FUNC INT DIA_Sonja_WarteHier_Condition()
{
	return self.aivar[AIV_PARTYMEMBER] == TRUE;
};
FUNC VOID DIA_Sonja_WarteHier_Info()
{
	AI_Output (other, self,"DIA_Liesel_WarteHier_15_00");	//Warte hier!
	AI_Output (self ,other, "DIA_Sonja_WARTEHIER_16_00"); //Wie du meinst, mein Süßer!

	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;
	Npc_ExchangeRoutine	(self,"WAIT");

	AI_StopProcessInfos	(self);
};

// ------------------------------------------------------------
// 							Go Home!
// ------------------------------------------------------------
INSTANCE DIA_Sonja_GoHome(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr		 	= 2;
	condition	= DIA_Sonja_GoHome_Condition;
	information	= DIA_Sonja_GoHome_Info;
	permanent	= TRUE;
	description = "Ich brauch dich nicht mehr.";
};
FUNC INT DIA_Sonja_GoHome_Condition()
{
	return self.aivar[AIV_PARTYMEMBER];
};

FUNC VOID DIA_Sonja_GoHome_Info()
{
	AI_Output (other, self, "DIA_Addon_Skip_GoHome_15_00"); //Ich brauch dich nicht mehr.
	AI_Output (self, other, "DIA_Sonja_GoHome_16_00"); // Arschloch!

	self.aivar[AIV_PARTYMEMBER] = FALSE;
    self.flags = NPC_FLAG_IMMORTAL;

    if (CurrentLevel == OLDWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTOLDWORLD");
    }
    else if (CurrentLevel == NEWWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"START");
    }
    else if (CurrentLevel == ADDONWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTADDONWORLD");
    }
    else if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTDRAGONISLAND");
    };
};

///////////////////////////////////////////////////////////////////////
//	Info Heilung
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HEILUNG		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	3;
	condition	 = 	DIA_Sonja_HEILUNG_Condition;
	information	 = 	DIA_Sonja_HEILUNG_Info;
	permanent	 = 	TRUE;

	description	 = 	"Brauchst du Heilung?";
};

func int DIA_Sonja_HEILUNG_Condition ()
{
    return self.aivar[AIV_PARTYMEMBER];
};

func void DIA_Sonja_HEILUNG_Info ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_15_00"); //Brauchst du Heilung?

    AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_00"); //Klar. Schaden kann's nicht.

    Info_ClearChoices	(DIA_Sonja_HEILUNG);
    Info_AddChoice	(DIA_Sonja_HEILUNG, "(den kleinsten Heiltrank.)", DIA_Sonja_HEILUNG_heiltrankLow );
    Info_AddChoice	(DIA_Sonja_HEILUNG, "(den besten Heiltrank.)", DIA_Sonja_HEILUNG_heiltrank );
    Info_AddChoice	(DIA_Sonja_HEILUNG, "Ich werde dir später etwas geben.", DIA_Sonja_HEILUNG_spaeter );

};

func void DIA_Sonja_HEILUNG_heiltrank ()
{
	if (B_GiveInvItems (other, self, ItPo_Health_03,1))
	{
	B_UseItem (self, ItPo_Health_03);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_02,1))
	{
	B_UseItem (self, ItPo_Health_02);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_01,1))
	{
	B_UseItem (self, ItPo_Health_01);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_01"); //Ich schätze, ich muss warten, bis du einen übrig hast.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_heiltrankLow ()
{
	if (B_GiveInvItems (other, self, ItPo_Health_01,1))
	{
        B_UseItem (self, ItPo_Health_01);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_02,1))
	{
        B_UseItem (self, ItPo_Health_02);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_03,1))
	{
        B_UseItem (self, ItPo_Health_03);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_02"); //Im Moment hast du leider keinen. Ich komm später noch mal darauf zurück.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_spaeter ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_spaeter_15_00"); //Ich werde dir später etwas geben.
	AI_Output			(self ,other, "DIA_Sonja_HEILUNG_16_03"); //Vergiss es aber nicht.

	Info_ClearChoices	(DIA_Sonja_HEILUNG);
};

///////////////////////////////////////////////////////////////////////
//	Info HEAL
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_DI_HEAL		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	5;
	condition	 = 	DIA_Sonja_DI_HEAL_Condition;
	information	 = 	DIA_Sonja_DI_HEAL_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Wurst warm machen)";
};

func int DIA_Sonja_DI_HEAL_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_DI_HEAL_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HEAL_15_00"); //Lass es uns tun!

    if (Wld_GetDay() - SonjaSexDays >= 3)
	{
        if (hero.attribute [ATR_HITPOINTS] < hero.attribute[ATR_HITPOINTS_MAX] || hero.attribute [ATR_MANA] < hero.attribute[ATR_MANA_MAX])
        {
            AI_Output			(self, other, "DIA_Sonja_HEAL_16_00"); //Endlich erobert mein Prinz sein Schloss zurück!
            PlayVideo ("LOVESCENE.BIK");
            hero.attribute [ATR_HITPOINTS] = hero.attribute[ATR_HITPOINTS_MAX];
            hero.attribute [ATR_MANA] = hero.attribute[ATR_MANA_MAX];
            PrintScreen (PRINT_FullyHealed, - 1, - 1, FONT_Screen, 2);
            B_LogEntry ("Sonja", "Sonja hat gewisse Talente, die mich heilen und mein Mana regenerieren.");
        }
        else
        {
            AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migräne.
            B_LogEntry ("Sonja", "Sonja hat komischerweise öfter mal Migräne, wenn ich meine Wurst warm machen will.");
        };
        SonjaSexDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migräne.
        B_LogEntry ("Sonja", "Sonja hat komischerweise öfter mal Migräne, wenn ich meine Wurst warm machen will.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(3 + SonjaSexDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    };
};

///////////////////////////////////////////////////////////////////////
//	Info FEELINGS
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FEELINGS		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_FEELINGS_Condition;
	information	 = 	DIA_Sonja_FEELINGS_Info;
	permanent	 = 	TRUE;
	description	 = 	"Wie fühlst du dich?";
};

func int DIA_Sonja_FEELINGS_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_FEELINGS_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_FEELINGS_15_00"); //Wie fühlst du dich?

    if (Wld_IsRaining())
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_00"); //Ach, das Wetter ist beschissen!
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_01"); //Das Wetter ist heute schön!
    };
};

///////////////////////////////////////////////////////////////////////
//	Info VIDEOS
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_VIDEOS		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	99;
	condition	 = 	DIA_Sonja_VIDEOS_Condition;
	information	 = 	DIA_Sonja_VIDEOS_Info;
	permanent	 = 	TRUE;

	description	 = 	"Zeige mir ...";
};

func int DIA_Sonja_VIDEOS_Condition ()
{
    return SonjaFolgt == TRUE;
};

func void DIA_Sonja_VIDEOS_Info ()
{
    Info_ClearChoices	(DIA_Sonja_VIDEOS);

    if (UndeadDragonIsDead)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Tod des Untoten Drachen.", DIA_Sonja_VIDEOS_UndeadDragonDeath );
    };

    if (Kapitel >= 6)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... die Abfahrt nach Irdorath.", DIA_Sonja_VIDEOS_Ship );
    };

    if (RavenIsDead)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... Raven's Tod.", DIA_Sonja_VIDEOS_RavenDeath );
    };

    if (B_RAVENSESCAPEINTOTEMPELAVI_OneTime)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... Raven's Flucht in den Tempel.", DIA_Sonja_VIDEOS_RavenEscape );
    };

    if (Npc_KnowsInfo (other, DIA_Addon_Saturas_Hallo))
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... das magische Erz im Minental.", DIA_Sonja_VIDEOS_OreHeap );
    };

    if (ENTER_OLDWORLD_FIRSTTIME_TRIGGER_ONETIME)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Drachenangriff im Minental.", DIA_Sonja_VIDEOS_DragonAttack );
    };

    if (MIS_OCGateOpen)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Orkangriff im Minental.", DIA_Sonja_VIDEOS_OrcAttack );
    };

    Info_AddChoice	(DIA_Sonja_VIDEOS, "... die Vorgeschichte der Insel.", DIA_Sonja_VIDEOS_Intro_Beliar );
    Info_AddChoice	(DIA_Sonja_VIDEOS, "... meine Vorgeschichte.", DIA_Sonja_VIDEOS_Intro );
    Info_AddChoice	(DIA_Sonja_VIDEOS, DIALOG_BACK, DIA_Sonja_VIDEOS_Back );
};

func void DIA_Sonja_VIDEOS_Back()
{
    Info_ClearChoices	(DIA_Sonja_VIDEOS);
};

func void DIA_Sonja_VIDEOS_Intro ()
{
	PlayVideo ("INTRO.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_Intro_Beliar ()
{
	PlayVideo ("Addon_Title.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_DragonAttack ()
{
    PlayVideo ( "DRAGONATTACK.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_OrcAttack() {
    PlayVideo ( "ORCATTACK.BIK");

	DIA_Sonja_VIDEOS_Info();

};

func void DIA_Sonja_VIDEOS_OreHeap ()
{
    PlayVideo ("oreheap.bik");

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_RavenEscape ()
{
    PlayVideoEx	("PORTAL_RAVEN.BIK", TRUE,FALSE);

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_Ship()
{
    PlayVideo ("SHIP.BIK");

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_RavenDeath ()
{
    PlayVideoEx	("EXTRO_RAVEN.BIK", TRUE,FALSE);

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_UndeadDragonDeath()
{
    if ((hero.guild == GIL_MIL) || (hero.guild == GIL_PAL))
    {
        PlayVideoEx	("EXTRO_PAL.BIK", TRUE,FALSE);
    }
    else if ((hero.guild == GIL_SLD) || (hero.guild == GIL_DJG))
    {
        PlayVideoEx	("EXTRO_DJG.BIK", TRUE,FALSE);
    }
    else
    {
        PlayVideoEx	("EXTRO_KDF.BIK", TRUE,FALSE);
    };

    DIA_Sonja_VIDEOS_Info();
};


///////////////////////////////////////////////////////////////////////
//	Info ESCAPE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_ESCAPE		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	3;
	condition	 = 	DIA_Sonja_ESCAPE_Condition;
	information	 = 	DIA_Sonja_ESCAPE_Info;
	permanent	 = 	TRUE;

	description	 = 	"(Levelwechsel)";
};

func int DIA_Sonja_ESCAPE_Condition ()
{
    return SonjaFolgt == TRUE;
};

func void DIA_Sonja_ESCAPE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_ESCAPE);

    if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Info_AddChoice	(DIA_Sonja_ESCAPE, "Zurück nach Khorinis ...", DIA_Sonja_ESCAPE_Khorinis);
    }
    else if (CurrentLevel == NEWWORLD_ZEN && Kapitel >= 6)
    {
        Info_AddChoice	(DIA_Sonja_ESCAPE, "Zurück nach Irdorath ...", DIA_Sonja_ESCAPE_Irdorath);
    };

    Info_AddChoice	(DIA_Sonja_ESCAPE, "(Werte von Levelwechsel laden)", DIA_Sonja_ESCAPE_Apply );
    Info_AddChoice	(DIA_Sonja_ESCAPE, "(Werte für Levelwechsel speichern)", DIA_Sonja_ESCAPE_Store );
    Info_AddChoice	(DIA_Sonja_ESCAPE, DIALOG_BACK, DIA_Sonja_ESCAPE_Back );
};

func void DIA_Sonja_ESCAPE_Back()
{
    Info_ClearChoices	(DIA_Sonja_ESCAPE);
};

func void DIA_Sonja_ESCAPE_Store()
{
    if (B_StoreSonjaStats(self))
    {
        AI_Output			(self, other, "DIA_Sonja_ESCAPE_16_00"); //Los geht's! Ich habe mir alles gemerkt.
    } else {
        AI_Output			(self, other, "DIA_Sonja_ESCAPE_16_01"); //Ich kann mir nichts merken!
    };

    DIA_Sonja_ESCAPE_Info();
};

func void DIA_Sonja_ESCAPE_Apply()
{
    if (B_ApplySonjaStats(self))
    {
        AI_Output			(self, other, "DIA_Sonja_ESCAPE_16_02"); //Ich weiß immer noch alles!
    } else {
        AI_Output			(self, other, "DIA_Sonja_ESCAPE_16_03"); //Ich kann mich nicht mehr erinnern!
    };

    DIA_Sonja_ESCAPE_Info();
};

func void DIA_Sonja_ESCAPE_Irdorath()
{

    DIA_Sonja_ESCAPE_Info();
};

func void DIA_Sonja_ESCAPE_Khorinis ()
{
    DIA_Sonja_ESCAPE_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info WAREZ
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_WAREZ		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	0;
	condition	 = 	DIA_Sonja_WAREZ_Condition;
	information	 = 	DIA_Sonja_WAREZ_Info;
	permanent	 = 	TRUE;
	trade		 = 	TRUE;
	description	 = 	"Zeig mir deine Ware";
};

func int DIA_Sonja_WAREZ_Condition ()
{
	return SonjaFolgt == TRUE;
};

var int SonjaSummonHint;
var int SonjaTeleportHint;
var int SonjaArrowHint;

func void DIA_Sonja_WAREZ_Info ()
{
    if (Npc_HasItems (self, ItRu_SummonSonja) <= 0)
    {
        CreateInvItems (self, ItRu_SummonSonja, 1);

        if (SonjaSummonHint == FALSE)
        {
            B_LogEntry ("Sonja", "Bei Sonja gibt es eine Rune, um sie jederzeit herbeizurufen.");
            SonjaSummonHint = TRUE;
        };
    };

    if (Kapitel >= 3)
    {
        if (Npc_HasItems (self, ItRu_TeleportSonja) <= 0)
        {
            CreateInvItems (self, ItRu_TeleportSonja, 1);
        };

        if (Npc_HasItems (self, ItRu_TeleportRoteLaterne) <= 0)
        {
            CreateInvItems (self, ItRu_TeleportRoteLaterne, 1);
        };

        if (SonjaTeleportHint == FALSE)
        {
            B_LogEntry ("Sonja", "Bei Sonja gibt es nützliche Teleportrunen.");
            SonjaTeleportHint = TRUE;
        };
    };

    // Immer neuen Rohstahl
    if (Npc_HasItems (self, ItMiSwordraw) <= 0)
    {
        CreateInvItems (self, ItMiSwordraw, 5);
    };

    // Immer Pfeile und Bolzen auch für sich selbst.
    if (Npc_HasItems (self, ItRw_Arrow) <= 0)
    {
        CreateInvItems (self, ItRw_Arrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja füllt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Bolt) <= 0)
    {
        CreateInvItems (self, ItRw_Bolt, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja füllt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_MagicArrow) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_MagicArrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja füllt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_FireArrow) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_FireArrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja füllt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_MagicBolt) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_MagicBolt, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja füllt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

	B_GiveTradeInv (self);
	AI_Output			(other, self, "DIA_Isgaroth_Trade_15_00"); //Zeig mir deine Ware.
};

///////////////////////////////////////////////////////////////////////
//	Info HEIRATEN
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HEIRATEN		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HEIRATEN_Condition;
	information	 = 	DIA_Sonja_HEIRATEN_Info;
	permanent	 = 	FALSE;
	description	 = 	"Möchtest du meine Frau werden?";
};

func int DIA_Sonja_HEIRATEN_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HEIRATEN_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_00"); //Möchtest du meine Frau werden?
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_00"); //Hmmm, hast du mir denn wirklich genug zu bieten? Wie sieht es mit Schmuck aus? Was ist mit schöner Kleidung? Die kostet Geld. Wo sollen wir wohnen, mein Prinz?
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_01"); //Ich sorge für alles.
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_01"); //Ich glaube an dich. Gib mir noch einmal 1000 Goldstücke und etwas Schmuck und wir können heiraten.

	B_LogEntry ("Sonja", "Sonja wird meine Frau wenn ich ihr 1000 Goldstücke, einen goldenen Ring und eine Schatulle gebe.");
};

///////////////////////////////////////////////////////////////////////
//	Info HOCHZEIT
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HOCHZEIT		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HOCHZEIT_Condition;
	information	 = 	DIA_Sonja_HOCHZEIT_Info;
	permanent	 = 	TRUE;
	description	 = 	"Werde meine Frau!";
};

func int DIA_Sonja_HOCHZEIT_Condition ()
{
	return Npc_KnowsInfo(other, DIA_Sonja_HEIRATEN) && !SonjaGeheiratet;
};

func void DIA_Sonja_HOCHZEIT_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HOCHZEIT_15_00"); //Möchtest du meine Frau werden?

    if (Npc_HasItems (other, ItMi_Gold) < 1000)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_00"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
    }
    else if (Npc_HasItems(other, ItMi_GoldRing) <= 0)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_01"); //Willst du mich verarschen? Du hast keinen goldenen Ring dabei!
    }
    else if ( Npc_HasItems(other, ItMi_GoldChest) <= 0)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_02"); //Willst du mich verarschen? Du hast keine Schatulle dabei!
    }
	else
	{
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_03"); //Oh, mein Prinz, ich gebe dir das Ja-Wort. Wir sind nun Frau und Mann. Schnell gib, mir die Waren, damit ich sie für uns aufbewaren kann.
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        B_GiveInvItems (other, self, ItMi_GoldRing, 1);
        B_GiveInvItems (other, self, ItMi_GoldChest, 1);
        B_LogEntry ("Sonja", "Sonja und ich haben geheiratet. Wir sind nun Mann und Frau. Wenn mein alter Freund Xardas das nur wüsste!");
        SonjaGeheiratet = TRUE;
	};
};

///////////////////////////////////////////////////////////////////////
//	Info LIEBE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_LIEBE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_LIEBE_Condition;
	information	 = 	DIA_Sonja_LIEBE_Info;
	permanent	 = 	FALSE;
	description	 = 	"(Liebeserklärung)";
};

func int DIA_Sonja_LIEBE_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_LIEBE_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_LIEBE_15_00"); //Oh du holde Maid, welch wunderbares Antlitz! Wie das Feuer der Drachen glänzt es und Männer erblinden vor seiner Schönheit! Nur das Auge Innos kann ihm stand halten.

	AI_Output			(self, other, "DIA_Sonja_LIEBE_16_00"); //Hast du zu viel Sumpfkraut geraucht? Mach dich lieber nützlich!

	if (SonjaGeheiratet)
	{
        AI_Output			(self, other, "DIA_Sonja_LIEBE_16_01"); //Und diesen "Mann" habe ich geheiratet ...
	};

	B_LogEntry ("Sonja", "Sonja war von meiner Liebeserklärung nicht sonderlich beeindruckt.");
};

///////////////////////////////////////////////////////////////////////
//	Info FAMILIE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FAMILIE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_FAMILIE_Condition;
	information	 = 	DIA_Sonja_FAMILIE_Info;
	permanent	 = 	FALSE;
	description	 = 	"Möchtest du eine Familie mit mir gründen?";
};

func int DIA_Sonja_FAMILIE_Condition ()
{
	return SonjaFolgt == TRUE && SonjaGeheiratet == TRUE;
};

func void DIA_Sonja_FAMILIE_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_FAMILIE_15_00"); //Möchtest du eine Familie mit mir gründen?

	AI_Output			(self, other, "DIA_Sonja_FAMILIE_16_00"); //Du meinst mit Haus, Kindern und Haustier? Dann fang erst mal mit dem Haus an!

	B_LogEntry ("Sonja", "Sonja würde eine Familie mit mir gründen, wenn ich ein Haus habe.");
};

///////////////////////////////////////////////////////////////////////
//	Info PROFIT
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_PROFIT		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	6;
	condition	 = 	DIA_Sonja_PROFIT_Condition;
	information	 = 	DIA_Sonja_PROFIT_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Gold abholen)";
};

func int DIA_Sonja_PROFIT_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_PROFIT_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_PROFIT_15_00"); //Warst du auch fleißig anschaffen?
	AI_Output			(self, other, "DIA_Sonja_PROFIT_16_00"); //Mein Tor ist für jeden Zahlenden weit geöffnet.

	if (Wld_GetDay() - SonjaProfitDays >= 5)
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_01"); //Hier mein Prinz. 50 Goldstücke pro Kunde und du bekommst deine Hälfte!
        B_GiveInvItems (self, other, ItMi_Gold, (Wld_GetDay() - SonjaProfitDays) * 6 * 25); // 6 Kunden pro Tag
        SonjaProfitDays = Wld_GetDay();

        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_02"); //Und hier ist die Liste meiner letzten Kunden, damit du auch Bescheid weißt.

        CreateInvItems (self, ItWr_SonjasListCustomers, 1);
        B_GiveInvItems (self, other, ItWr_SonjasListCustomers, 1);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_03"); //Komm in ein paar Tagen noch mal zu mir. Alle fünf Tage kann ich dir dein Gold geben.
        B_LogEntry ("Sonja", "Sonja gibt mir alle fünf Tage meinen Anteil an ihrem verdienten Gold.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(5 + SonjaProfitDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
	};
};

// ************************************************************
// 			  				TRAINING
// ************************************************************

INSTANCE DIA_Sonja_TRAINING (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 7;
	condition	= DIA_Sonja_TRAINING_Condition;
	information	= DIA_Sonja_TRAINING_Info;
	permanent	= TRUE;
	description = "(Sonja trainieren)";
};

FUNC INT DIA_Sonja_TRAINING_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_TRAINING_Info_Choices()
{
    Info_ClearChoices	(DIA_Sonja_TRAINING);

	Info_AddChoice		(DIA_Sonja_TRAINING, "Weitere Talente"	,    DIA_Sonja_TRAINING_MORE);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Runenmagie"	,    DIA_Sonja_TRAINING_RUNES);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Alchemie"	,    DIA_Sonja_TRAINING_ALCHEMY);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Mana"	,    DIA_Sonja_TRAINING_MANA);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Leben"	,    DIA_Sonja_TRAINING_HITPOINTS);
			//oth.attribute[ATR_HITPOINTS_MAX] = oth.attribute[ATR_HITPOINTS_MAX] + points;
		//oth.attribute[ATR_HITPOINTS] = oth.attribute[ATR_HITPOINTS_MAX];

		//concatText = ConcatStrings(PRINT_BlessHitpoints_MAX, IntToString(points));
		//PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Armbrust"	,    DIA_Sonja_TRAINING_CROSSBOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Bogen"	,    DIA_Sonja_TRAINING_BOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Zweihandwaffen"	,    DIA_Sonja_TRAINING_TWO_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Einhandwaffen"	,    DIA_Sonja_TRAINING_ONE_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Geschick"	,    DIA_Sonja_TRAINING_DEX);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Stärke"	,    DIA_Sonja_TRAINING_STR);
	Info_AddChoice		(DIA_Sonja_TRAINING, "(Alles Verlernen)"	,    DIA_Sonja_TRAINING_RESET);
	Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK 		, DIA_Sonja_TRAINING_BACK);
};

FUNC VOID DIA_Sonja_TRAINING_Info()
{
    AI_Output			(other, self, "DIA_Sonja_TRAINING_15_00"); //Lass mich dich trainieren!
    B_LogEntry ("Sonja", "Ich kann Sonja mit ihrer eigenen gesammelten Erfahrung trainieren.");

    DIA_Sonja_TRAINING_Info_Choices();
};

func void DIA_Sonja_TRAINING_BACK()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
};

func void DIA_Sonja_TRAINING_RESET ()
{
    Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, "Ja"			,DIA_Sonja_Teach_Reset);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_Teach_Reset ()
{
    AI_Output			(other, self, "DIA_Sonja_TRAINING_15_01"); //Verlerne alles was ich dir beigebracht habe.

    B_ResetSonja(self);

    DIA_Sonja_TRAINING_Info_Choices();
};

func void DIA_Sonja_TRAINING_STR ()
{
    Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR1			, B_GetLearnCostAttribute(other, ATR_STRENGTH))			,DIA_Sonja_Teach_STR_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR5			, B_GetLearnCostAttribute(other, ATR_STRENGTH)*5)		,DIA_Sonja_Teach_STR_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_Teach_STR_1 ()
{
	B_TeachAttributePoints (other, self, ATR_STRENGTH, 1, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

FUNC VOID DIA_Sonja_Teach_STR_5 ()
{
	B_TeachAttributePoints (other, self, ATR_STRENGTH, 5, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

func void DIA_Sonja_TRAINING_DEX ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnDEX1			, B_GetLearnCostAttribute(other, ATR_DEXTERITY))			,DIA_Sonja_Teach_DEX_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnDEX5			, B_GetLearnCostAttribute(other, ATR_DEXTERITY)*5)		,DIA_Sonja_Teach_DEX_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_Teach_DEX_1 ()
{
	B_TeachAttributePoints (other, self, ATR_DEXTERITY, 1, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

FUNC VOID DIA_Sonja_Teach_DEX_5 ()
{
	B_TeachAttributePoints (other, self, ATR_DEXTERITY, 5, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

func void DIA_Sonja_TRAINING_ONE_HAND ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn1h1	, B_GetLearnCostTalent(other, NPC_TALENT_1H, 1))			,DIA_Sonja_Teach_1H_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn1h5	, B_GetLearnCostTalent(other, NPC_TALENT_1H, 1)*5)		,DIA_Sonja_Teach_1H_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_1H_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_1H, 1, T_MAX);

	DIA_Sonja_TRAINING_ONE_HAND();
};

FUNC VOID DIA_Sonja_Teach_1H_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_1H, 5, T_MAX);

	DIA_Sonja_TRAINING_ONE_HAND();
};


func void DIA_Sonja_TRAINING_TWO_HAND ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn2h1	, B_GetLearnCostTalent(other, NPC_TALENT_2H, 1))			,DIA_Sonja_Teach_2H_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn2h5	, B_GetLearnCostTalent(other, NPC_TALENT_2H, 1)*5)		,DIA_Sonja_Teach_2H_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_2H_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_2H, 1, T_MAX);

	DIA_Sonja_TRAINING_TWO_HAND();
};

FUNC VOID DIA_Sonja_Teach_2H_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_2H, 5, T_MAX);

	DIA_Sonja_TRAINING_TWO_HAND();
};

func void DIA_Sonja_TRAINING_BOW ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnBow1	, B_GetLearnCostTalent(other, NPC_TALENT_BOW, 1))			,DIA_Sonja_Teach_Bow_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnBow5	, B_GetLearnCostTalent(other, NPC_TALENT_BOW, 1)*5)		,DIA_Sonja_Teach_Bow_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_Bow_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_BOW, 1, T_MAX);

	DIA_Sonja_TRAINING_BOW();
};

FUNC VOID DIA_Sonja_Teach_Bow_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_BOW, 5, T_MAX);

	DIA_Sonja_TRAINING_BOW();
};

func void DIA_Sonja_TRAINING_CROSSBOW ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnCrossBow1	, B_GetLearnCostTalent(other, NPC_TALENT_CROSSBOW, 1))			,DIA_Sonja_Teach_CrossBow_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnCrossBow5	, B_GetLearnCostTalent(other, NPC_TALENT_CROSSBOW, 1)*5)		,DIA_Sonja_Teach_CrossBow_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_CrossBow_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_CROSSBOW, 1, T_MAX);

	DIA_Sonja_TRAINING_CROSSBOW();
};

FUNC VOID DIA_Sonja_Teach_CrossBow_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_CROSSBOW, 5, T_MAX);

	DIA_Sonja_TRAINING_CROSSBOW();
};

func void DIA_Sonja_TRAINING_HITPOINTS ()
{
    Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS1			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX))			,DIA_Sonja_TEACH_HITPOINTS_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS5			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX)*5)		,DIA_Sonja_TEACH_HITPOINTS_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS10			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX)*10)		,DIA_Sonja_TEACH_HITPOINTS_10);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS20			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX)*20)		,DIA_Sonja_TEACH_HITPOINTS_20);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_TEACH_HITPOINTS_1()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 1, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};

FUNC VOID DIA_Sonja_TEACH_HITPOINTS_5()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 5, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};

FUNC VOID DIA_Sonja_TEACH_HITPOINTS_10()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 10, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};

FUNC VOID DIA_Sonja_TEACH_HITPOINTS_20()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 20, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};

func void DIA_Sonja_TRAINING_MANA ()
{
	Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA1			, B_GetLearnCostAttribute(other, ATR_MANA_MAX))			,DIA_Sonja_TEACH_MANA_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA5			, B_GetLearnCostAttribute(other, ATR_MANA_MAX)*5)		,DIA_Sonja_TEACH_MANA_5);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_TEACH_MANA_1()
{
	B_TeachAttributePoints (other, self, ATR_MANA_MAX, 1, T_MEGA);

	DIA_Sonja_TRAINING_MANA();
};
FUNC VOID DIA_Sonja_TEACH_MANA_5()
{
	B_TeachAttributePoints (other, self, ATR_MANA_MAX, 5, T_MEGA);

	DIA_Sonja_TRAINING_MANA();
};

func void DIA_Sonja_TRAINING_RUNES ()
{
    Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_6, DIA_Sonja_TEACH_MAGIC_CIRCLE_6);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_5, DIA_Sonja_TEACH_MAGIC_CIRCLE_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_4, DIA_Sonja_TEACH_MAGIC_CIRCLE_4);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_3, DIA_Sonja_TEACH_MAGIC_CIRCLE_3);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_2, DIA_Sonja_TEACH_MAGIC_CIRCLE_2);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_1, DIA_Sonja_TEACH_MAGIC_CIRCLE_1);

    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_1 ()
{
    if (B_TeachMagicCircle (other,self, 1))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_02"); //Du bist bist nun im ersten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_2 ()
{
    if (B_TeachMagicCircle (other,self, 2))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_03"); //Du bist bist nun im zweiten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_3 ()
{
    if (B_TeachMagicCircle (other,self, 3))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_04"); //Du bist bist nun im dritten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_4 ()
{
    if (B_TeachMagicCircle (other,self, 4))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_05"); //Du bist bist nun im vierten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_5 ()
{
    if (B_TeachMagicCircle (other,self, 5))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_06"); //Du bist bist nun im fünften Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_6 ()
{
    if (B_TeachMagicCircle (other,self, 6))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_07"); //Du bist bist nun im sechsten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TRAINING_ALCHEMY ()
{
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_MORE ()
{
	Info_ClearChoices   (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString("Schleichen", B_GetLearnCostTalent(self, NPC_TALENT_SNEAK, 1)), DIA_Sonja_TEACH_SNEAK);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_TEACH_SNEAK ()
{
    if (B_TeachThiefTalent (other, self, NPC_TALENT_SNEAK))
	{
		AI_Output (self, other, "DIA_Sonja_TRAINING_15_08");//Du kannst jetzt schleichen.
	};

	DIA_Sonja_TRAINING_MORE();
};

//func void AI_SetWalkmode(var c_npc n, var int n0)
//gibt an mit welchem Walkmode Run etc der Character durch das Level läuft
//NPC_RUN : Rennen
//NPC_WALK : Gehen
//NPC_SNEAK : Schleichen
//NPC_RUN_WEAPON : Rennen mit gezogener Waffe
//NPC_WALK_WEAPON : Gehen mit gezogener Waffe
//NPC_SNEAK_WEAPON : Schleichen mit gezogener Waffe

//////////////////////////////////////////////////////////////////////
//	Info CHANGE
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_CHANGE   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 10;
	condition   = DIA_Sonja_CHANGE_Condition;
	information = DIA_Sonja_CHANGE_Action;
	permanent   = TRUE;
	description = "(Verhalten ändern)";
};

FUNC INT DIA_Sonja_CHANGE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_CHANGE_Action()
{
	Info_ClearChoices   (DIA_Sonja_CHANGE);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Ändere dein Kampfverhalten!", DIA_Sonja_FAI_Action);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Ändere deine Gangart!", DIA_Sonja_WALKMODE_Action);
    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_CHANGE_Back);

};

func void DIA_Sonja_CHANGE_Back()
{
    Info_ClearChoices   (DIA_Sonja_CHANGE);
};

FUNC VOID DIA_Sonja_WALKMODE_Action()
{
	Info_ClearChoices   (DIA_Sonja_CHANGE);
	if (Npc_GetTalentSkill(self, NPC_TALENT_SNEAK) == 1)
	{
        Info_AddChoice		(DIA_Sonja_CHANGE, "Schleiche", DIA_Sonja_WALKMODE_SNEAK);
    };
	Info_AddChoice		(DIA_Sonja_CHANGE, "Gehe", DIA_Sonja_WALKMODE_WALK);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Renne (Standard)", DIA_Sonja_WALKMODE_RUN);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Sprinte", DIA_Sonja_WALKMODE_SPRINT);

    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_WALKMODE_Back);

};

func void DIA_Sonja_WALKMODE_Back ()
{
    DIA_Sonja_CHANGE_Action();
};

func void DIA_Sonja_WALKMODE_SPRINT ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_01");//Sprinte!
    Mdl_ApplyOverlayMDSTimed	(self, "HUMANS_SPRINT.MDS", Time_Speed);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_RUN ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_02");//Renne!
    AI_SetWalkmode(self, NPC_RUN);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_WALK ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_03");//Gehe!
    AI_SetWalkmode(self, NPC_WALK);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_SNEAK ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_04");//Schleiche!
    AI_SetWalkmode(self, NPC_SNEAK);

    DIA_Sonja_WALKMODE_Action();
};

//const int FAI_HUMAN_COWARD				= 2		;
//const int FAI_HUMAN_NORMAL				= 42	;
//const int FAI_HUMAN_STRONG				= 3		;
//const int FAI_HUMAN_MASTER				= 4		;

FUNC VOID DIA_Sonja_FAI_Action()
{
	AI_Output (other, self, "DIA_Sonja_FAI_15_00");//Ändere dein Kampfverhalten!

	Info_ClearChoices   (DIA_Sonja_CHANGE);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Meister", DIA_Sonja_FAI_MASTER);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Stark", DIA_Sonja_FAI_STRONG);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Normal", DIA_Sonja_FAI_NORMAL);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Feigling (Standard)", DIA_Sonja_FAI_COWARD);
    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_FAI_Back);

};

func void DIA_Sonja_FAI_Back ()
{
    DIA_Sonja_CHANGE_Action();
};

func void DIA_Sonja_FAI_COWARD ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_01");//Kämpfe wie ein Feigling!
    self.fight_tactic = FAI_HUMAN_COWARD;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_NORMAL ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_02");//Kämpfe normal!
    self.fight_tactic = FAI_HUMAN_NORMAL;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_STRONG ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_03");//Kämpfe stark!
    self.fight_tactic = FAI_HUMAN_STRONG;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_MASTER ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_04");//Kämpfe wie ein Meister!
    self.fight_tactic = FAI_HUMAN_MASTER;

    DIA_Sonja_FAI_Action();
};

//---------------------------------------------------------------------
//	Info einschätzen
//---------------------------------------------------------------------
INSTANCE DIA_Sonja_ein   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 900;
	condition   = DIA_Sonja_ein_Condition;
	information = DIA_Sonja_ein_Info;
	permanent   = TRUE;
	description = "(Einschätzen lassen)";
};

FUNC INT DIA_Sonja_ein_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ein_Info()
{
    Info_ClearChoices   (DIA_Sonja_ein);
	Info_AddChoice		(DIA_Sonja_ein, "Fähigkeit als Zuhälter einschätzen lassen", DIA_Sonja_PIMP_Info);
	Info_AddChoice		(DIA_Sonja_ein, "Fähigkeit als Aufreißer einschätzen lassen", DIA_Sonja_AUFREISSER_Info);
    Info_AddChoice		(DIA_Sonja_ein, "Fähigkeit Goldhacken einschätzen lassen", DIA_Sonja_ein_Info_Gold);
    Info_AddChoice 		(DIA_Sonja_ein,DIALOG_BACK,DIA_Sonja_ein_Info_Back);
};

func void DIA_Sonja_ein_Info_Back()
{
    Info_ClearChoices   (DIA_Sonja_ein);
};

FUNC VOID DIA_Sonja_ein_Info_Gold()
{
	AI_Output (other, self, "DIA_Addon_Finn_ein_15_00");//Kannst du meine Fähigkeit im Goldhacken einschätzen?

	AI_Output (self, other, "DIA_Sonja_ein_16_01");//Bei dir würde ich sagen, du bist ein ...

	if (Hero_HackChance < 20)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_02"); //blutiger Anfänger.
	}
	else if (Hero_HackChance < 40)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_03"); //ganz passabler Schürfer.
	}
	else if (Hero_HackChance < 55)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_04"); //erfahrener Goldschürfer.
	}
	else if (Hero_HackChance < 75)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_05"); //wachechter Buddler.
	}
	else if (Hero_HackChance < 90)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_06"); //verdammt guter Buddler.
	}
	else if (Hero_HackChance < 98)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_07"); //Meister Buddler.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_08"); //Guru - unter den Buddlern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Goldhacken: ", IntToString (Hero_HackChance));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

FUNC VOID DIA_Sonja_AUFREISSER_Info()
{
	AI_Output (other, self, "DIA_Sonja_AUFREISSER_15_00");//Kannst du meine Fähigkeit als Aufreißer einschätzen?

	AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_00");//Bei dir würde ich sagen, du bist ein ...

	if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 20)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_01"); //blutiger Anfänger.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 40)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_02"); //ganz passabler Aufreißer.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 55)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_03"); //erfahrener Aufreißer.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 75)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_04"); //wachechter Aufreißer.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 90)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_05"); //verdammt guter Aufreißer.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 98)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_06"); //Meister-Aufreißer.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_07"); //Guru - unter den Aufreißern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Aufreißer: ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER)));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

FUNC VOID DIA_Sonja_PIMP_Info()
{
	AI_Output (other, self, "DIA_Sonja_PIMP_15_00");//Kannst du meine Fähigkeit als Zuhälter einschätzen?

	AI_Output (self, other, "DIA_Sonja_PIMP_16_00");//Bei dir würde ich sagen, du bist ein ...

	if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 1)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_01"); //blutiger Anfänger.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 2)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_02"); //ganz passabler Zuhälter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 3)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_03"); //erfahrener Zuhälter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 4)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_04"); //wachechter Zuhälter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 5)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_05"); //verdammt guter Zuhälter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 6)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_06"); //Meister-Zuhälter.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_07"); //Guru - unter den Zuhältern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Zuhälter: ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_PIMP)));
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

//*******************************************
//	TeachPlayerAufreisser
//*******************************************

INSTANCE DIA_Sonja_TEACH(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 99;
	condition	= DIA_Sonja_TEACH_Condition;
	information	= DIA_Sonja_TEACH_Info;
	permanent	= TRUE;
	description = "Bring mir etwas bei.";
};

FUNC INT DIA_Sonja_TEACH_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_TEACH_Info()
{
    Info_ClearChoices   (DIA_Sonja_TEACH);
	Info_AddChoice		(DIA_Sonja_TEACH, "Zeig mir, wie ich ein besserer Zuhälter werde.", DIA_Sonja_TEACHPIMP_Info);
    Info_AddChoice		(DIA_Sonja_TEACH, "Zeig mir, wie ich andere besser aufreißen kann.", DIA_Sonja_TEACHAUFREISSER_Info);
    Info_AddChoice 		(DIA_Sonja_TEACH,DIALOG_BACK,DIA_Sonja_TEACH_Back);
};

func void DIA_Sonja_TEACH_Back()
{
    Info_ClearChoices   (DIA_Sonja_TEACH);
};

func int B_TeachAufreisserTalentPercent (var C_NPC slf, var C_NPC oth, var int percent, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	//kosten = (B_GetLearnCostTalent(oth, NPC_TALENT_WOMANIZER, 1) * percent);
	kosten = percent; // 1 LP pro Aufreisser %

	//EXIT IF...

	// ------ Lernen NICHT über teacherMax ------
	var int realHitChance;
	realHitChance = Npc_GetTalentSkill(oth, NPC_TALENT_WOMANIZER);

	if (realHitChance >= teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
		B_Say (slf, oth, "$NOLEARNYOUREBETTER");

		return FALSE;
	};

	if ((realHitChance + percent) > teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
		B_Say (slf, oth, "$NOLEARNOVERPERSONALMAX");

		return FALSE;
	};

	// ------ Player hat zu wenig Lernpunkte ------
	if (oth.lp < kosten)
	{
		PrintScreen	(PRINT_NotEnoughLP, -1, -1, FONT_Screen, 2);
		B_Say (slf, oth, "$NOLEARNNOPOINTS");

		return FALSE;
	};


	// FUNC

	// ------ Lernpunkte abziehen ------
	oth.lp = oth.lp - kosten;

	// ------ AUFREISSER steigern ------
    Npc_SetTalentSkill (oth, NPC_TALENT_WOMANIZER, Npc_GetTalentSkill(oth, NPC_TALENT_WOMANIZER) + percent);	//Aufreisser

	concatText = ConcatStrings ("Verbessere: Aufreißen zu ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER)));
	concatText = ConcatStrings (ConcatText, " Prozent");
    PrintScreen	(concatText, -1, -1, FONT_Screen, 2);


    return TRUE;
};

func void SonjaTeachAufreisser()
{
    Info_ClearChoices (DIA_Sonja_TEACH);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufreißen +20"			, 20)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_20);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufreißen +10"			, 10)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_10);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufreißen +5"			, 5)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufreißen +1"			, 1)			,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1);
    Info_AddChoice		(DIA_Sonja_TEACH, DIALOG_BACK, DIA_Sonja_TEACHAUFREISSER_Back);
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Info()
{
	AI_Output (other,self ,"DIA_Sonja_TEACHAUFREISSER_15_00"); //Zeig mir, wie ich andere besser aufreißen kann.
    AI_Output (self, other, "DIA_Sonja_TEACHAUFREISSER_16_00"); //Ach du, als ob du jemals eine andere Frau beeindrucken wirst. Na gut, wir probieren es trotzdem.

    SonjaTeachAufreisser();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Back ()
{
	DIA_Sonja_TEACH_Info();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1 ()
{
	B_TeachAufreisserTalentPercent (self, other, 1, 100);

	SonjaTeachAufreisser();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5 ()
{
	B_TeachAufreisserTalentPercent (self, other, 5, 100);

	SonjaTeachAufreisser();
};


FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_10 ()
{
	B_TeachAufreisserTalentPercent (self, other, 10, 100);

	SonjaTeachAufreisser();
};


FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_20 ()
{
	B_TeachAufreisserTalentPercent (self, other, 20, 100);

	SonjaTeachAufreisser();
};

func int B_TeachPimpTalent (var C_NPC slf, var C_NPC oth, var int circle, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	//kosten = (B_GetLearnCostTalent(oth, NPC_TALENT_WOMANIZER, 1) * circle);
	kosten = circle; // 1 LP pro Aufreisser %

	//EXIT IF...

	// ------ Lernen NICHT über teacherMax ------
	var int realHitChance;
	realHitChance = Npc_GetTalentSkill(oth, NPC_TALENT_PIMP);

	if (realHitChance >= teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
		B_Say (slf, oth, "$NOLEARNYOUREBETTER");

		return FALSE;
	};

	if (circle > teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
		B_Say (slf, oth, "$NOLEARNOVERPERSONALMAX");

		return FALSE;
	};

	// ------ Player hat zu wenig Lernpunkte ------
	if (oth.lp < kosten)
	{
		PrintScreen	(PRINT_NotEnoughLP, -1, -1, FONT_Screen, 2);
		B_Say (slf, oth, "$NOLEARNNOPOINTS");

		return FALSE;
	};


	// FUNC

	// ------ Lernpunkte abziehen ------
	oth.lp = oth.lp - kosten;

	// ------ ZUHÄLTER steigern ------
    Npc_SetTalentSkill (oth, NPC_TALENT_PIMP, circle);	//Pimp

    concatText = ConcatStrings("Erlerne Kreis des Zuhälters: ", IntToString(circle));

    PrintScreen	(concatText, -1, -1, FONT_Screen, 2);

    return TRUE;
};

func void SonjaTeachPimp()
{
    Info_ClearChoices (DIA_Sonja_TEACH);
    if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 6)
    {
        var String concatText;
        concatText = ConcatStrings("Erlerne  ", IntToString(Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1));
        concatText = ConcatStrings(concatText, ". Kreis des Zuhälters");
        Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString(concatText, Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1)			,DIA_Sonja_TEACHPIMP_1);
    };
    Info_AddChoice		(DIA_Sonja_TEACH, DIALOG_BACK, DIA_Sonja_TEACHPIMP_Back);
};

FUNC VOID DIA_Sonja_TEACHPIMP_Info()
{
	AI_Output (other,self ,"DIA_Sonja_TEACHPIMP_15_00"); //Zeig mir, wie ich ein besserer Zuhälter werde.
    AI_Output (self, other, "DIA_Sonja_TEACHPIMP_16_00"); //Das ist ein schwieriges Handwerk. Mal schauen ob es dir liegt.

    SonjaTeachPimp();
};

FUNC VOID DIA_Sonja_TEACHPIMP_Back ()
{
	DIA_Sonja_TEACH_Info();
};

FUNC VOID DIA_Sonja_TEACHPIMP_1 ()
{
	B_TeachPimpTalent (self, other, Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1, 6);

	SonjaTeachPimp();
};

// ************************************************************
// 			  				ROUTINE
// ************************************************************

INSTANCE DIA_Sonja_ROUTINE (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ROUTINE_Condition;
	information	= DIA_Sonja_ROUTINE_Info;
	permanent	= TRUE;
	description = "(Tätigkeit)";
};

FUNC INT DIA_Sonja_ROUTINE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ROUTINE_Info()
{
	Info_ClearChoices	(DIA_Sonja_ROUTINE);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Orlan's Taverne"	,        DIA_Sonja_ROUTINE_Orlan);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Onars Hof"	,        DIA_Sonja_ROUTINE_Lee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Xardas Turm"	,    DIA_Sonja_ROUTINE_Xardas);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zum Kloster"	,    DIA_Sonja_ROUTINE_Pyrokar);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zum Marktplaz"	,    DIA_Sonja_ROUTINE_Vatras);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Tanzen"	,            DIA_Sonja_ROUTINE_Dance);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Für kleine Mädchen",    DIA_Sonja_ROUTINE_Pee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Sitze in der Roten Laterne (Standard)",    DIA_Sonja_ROUTINE_Start);
	Info_AddChoice		(DIA_Sonja_ROUTINE, DIALOG_BACK 		,    DIA_Sonja_ROUTINE_BACK);
};

func void DIA_Sonja_ROUTINE_BACK()
{
	Info_ClearChoices (DIA_Sonja_ROUTINE);
};

func void DIA_Sonja_ROUTINE_Start()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_00"); //Setz dich in die Rote Laterne!
	Npc_ExchangeRoutine	(self,"START");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Pee ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_01"); //Geh mal für kleine Mädchen!
	Npc_ExchangeRoutine	(self,"PEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Dance ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_02"); //Tanz!
	Npc_ExchangeRoutine	(self,"DANCE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Vatras()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_03"); //Gehe zum Marktplatz!
	Npc_ExchangeRoutine	(self,"VATRAS");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Pyrokar()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_04"); //Gehe zum Kloster!
	Npc_ExchangeRoutine	(self,"PYROKAR");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Xardas()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_05"); //Gehe zu Xardas Turm!
	Npc_ExchangeRoutine	(self,"XARDAS");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Lee()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_06"); //Gehe zu Onars Hof!
	Npc_ExchangeRoutine	(self,"LEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Orlan()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_07"); //Gehe zu Orlan's Taverne!
	Npc_ExchangeRoutine	(self,"ORLAN");

	DIA_Sonja_ROUTINE_Info();
};

//S_INNOS_S1
//S_RAKE_S1
//S_SLEEPGROUND
//S_WASH
//  func void TA_Pray_Innos_FP		(var int start_h, var int start_m, var int stop_h, var int stop_m, VAR string waypoint)	{TA_Min		(self,	start_h,start_m, stop_h, stop_m, ZS_Pray_Innos_FP,			waypoint);};
//func void TA_Dance				(var int start_h, var int start_m, var int stop_h, var int stop_m, VAR string waypoint)	{TA_Min		(self,	start_h,start_m, stop_h, stop_m, ZS_Dance,					waypoint);};


// ************************************************************
// 			  				AUSSEHEN
// ************************************************************

INSTANCE DIA_Sonja_AUSSEHEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_AUSSEHEN_Condition;
	information	= DIA_Sonja_AUSSEHEN_Info;
	permanent	= TRUE;
	description = "(Aussehen)";
};

FUNC INT DIA_Sonja_AUSSEHEN_Condition()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_AUSSEHEN_Info ()
{
    Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Schönheits-OP für Gesicht und Frisur)"	,              DIA_Sonja_Choose_Face_Info);
    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Schönheits-OP für die Hautfarbe)"	,              DIA_Sonja_Choose_BodyTex_Info);
    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Schönheits-OP für Kopf)"	,          DIA_Sonja_Choose_HeadMesh_Info);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Allgemeines Aussehen)"	,  DIA_Sonja_AUSSEHEN_Allegemein_Info);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_BACK);
};


func void DIA_Sonja_AUSSEHEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_AUSSEHEN);
};

FUNC VOID DIA_Sonja_AUSSEHEN_Allegemein_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Bürgerin"	,    DIA_Sonja_AUSSEHEN_Citizen);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Bäuerin"	,    DIA_Sonja_AUSSEHEN_Farmer);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Vanja"	,    DIA_Sonja_AUSSEHEN_Vanja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Lucia"	,    DIA_Sonja_AUSSEHEN_Lucia);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Nadja"	,    DIA_Sonja_AUSSEHEN_Nadja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Dick"	,    DIA_Sonja_AUSSEHEN_Fat);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Dünn"	,    DIA_Sonja_AUSSEHEN_Thin);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Anziehen"	,    DIA_Sonja_AUSSEHEN_Clothing);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Ausziehen"	,    DIA_Sonja_AUSSEHEN_Nude);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Normal"	,    DIA_Sonja_AUSSEHEN_Normal);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_Allgemein_BACK);
};

func void DIA_Sonja_AUSSEHEN_Allgemein_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Nude ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_00"); //Zieh dich aus!

    AI_UnequipArmor (self);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Clothing ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_01"); //Zieh dir was an!

    AI_EquipBestArmor (self);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Fat ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_02"); //Iss etwas!

    Mdl_SetModelFatness (self, 4);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Thin ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_03"); //Mach ein bisschen Sport!

    Mdl_SetModelFatness (self, 0);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Normal()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe6", FaceBabe_L_Charlotte2, BodyTexBabe_L, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Nadja()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_Hure, BodyTex_N, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Lucia()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_GreyCloth, BodyTexBabe_F, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Vanja()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe", FaceBabe_B_RedLocks, BodyTexBabe_B, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Farmer()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe4", FaceBabe_N_VlkBlonde, BodyTexBabe_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Citizen()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_BabeHair", FaceBabe_N_HairAndCloth, BodyTex_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

FUNC VOID DIA_Sonja_Choose_HeadMesh_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_BabeHair", DIA_Sonja_Choose_HeadMesh_17);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe8" 	, DIA_Sonja_Choose_HeadMesh_16);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe7" 	, DIA_Sonja_Choose_HeadMesh_15);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe6" 	, DIA_Sonja_Choose_HeadMesh_14);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe5" 	, DIA_Sonja_Choose_HeadMesh_13);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe4" 	, DIA_Sonja_Choose_HeadMesh_12);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe3" 	, DIA_Sonja_Choose_HeadMesh_11);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe2" 	, DIA_Sonja_Choose_HeadMesh_10);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe1" 	, DIA_Sonja_Choose_HeadMesh_9);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe" 	, DIA_Sonja_Choose_HeadMesh_8);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_HeadMesh_BACK);
};

func void DIA_Sonja_Choose_HeadMesh_8()
{
	Sonja_HeadMesh 	="Hum_Head_Babe";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_9()
{
	Sonja_HeadMesh 	="Hum_Head_Babe1";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_10()
{
	Sonja_HeadMesh 	="Hum_Head_Babe2";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_11()
{
	Sonja_HeadMesh 	="Hum_Head_Babe3";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_12()
{
	Sonja_HeadMesh 	="Hum_Head_Babe4";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_13()
{
	Sonja_HeadMesh 	="Hum_Head_Babe5";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_14()
{
	Sonja_HeadMesh 	="Hum_Head_Babe6";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_15()
{
	Sonja_HeadMesh 	="Hum_Head_Babe7";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_16()
{
	Sonja_HeadMesh 	="Hum_Head_Babe8";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_17()
{
	Sonja_HeadMesh 	="Hum_Head_BabeHair";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
// ------------------------------------------------

func void DIA_Sonja_Choose_HeadMesh_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

FUNC VOID DIA_Sonja_Choose_BodyTex_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Käseweiß" 	, DIA_Sonja_Choose_BodyTexBabe_P);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Weiß" 	,    DIA_Sonja_Choose_BodyTexBabe_N);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Latino" 	, DIA_Sonja_Choose_BodyTexBabe_L);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Farbig" 	, DIA_Sonja_Choose_BodyTexBabe_B);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_BodyTex_BACK);
};

func void DIA_Sonja_Choose_BodyTexBabe_B()
{
	Sonja_BodyTexture 	=BodyTexBabe_B;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_L()
{
	Sonja_BodyTexture 	=BodyTexBabe_L;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_N()
{
	Sonja_BodyTexture 	=BodyTexBabe_N;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_P()
{
	Sonja_BodyTexture 	=BodyTexBabe_P;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};

// ------------------------------------------------

func void DIA_Sonja_Choose_BodyTex_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

FUNC VOID DIA_Sonja_Choose_Face_Info()
{
    /*
const int FaceBabe_N_BlackHair		= 	137	;
const int FaceBabe_N_Blondie		= 	138	;
const int FaceBabe_N_BlondTattoo	= 	139	;
const int FaceBabe_N_PinkHair		= 	140	;
const int FaceBabe_L_Charlotte		= 	141	;
const int FaceBabe_B_RedLocks		= 	142	;
const int FaceBabe_N_HairAndCloth	= 	143	;
//
const int FaceBabe_N_WhiteCloth		= 	144	;
const int FaceBabe_N_GreyCloth		= 	145	;
const int FaceBabe_N_Brown			= 	146	;
const int FaceBabe_N_VlkBlonde		= 	147	;
const int FaceBabe_N_BauBlonde		= 	148 ;
const int FaceBabe_N_YoungBlonde	= 	149	;
const int FaceBabe_N_OldBlonde		= 	150 ;
const int FaceBabe_P_MidBlonde		= 	151 ;
const int FaceBabe_N_MidBauBlonde	= 	152 ;
const int FaceBabe_N_OldBrown		= 	153 ;
const int FaceBabe_N_Lilo			= 	154 ;
const int FaceBabe_N_Hure			= 	155 ;
const int FaceBabe_N_Anne			= 	156 ;
const int FaceBabe_B_RedLocks2		= 	157	;
const int FaceBabe_L_Charlotte2		= 	158 ;
*/

	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Freudendame" 	, DIA_Sonja_Choose_FaceBabe_N_Hure);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Charlotte" 	, DIA_Sonja_Choose_FaceBabe_L_Charlotte);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Pinke Haare" 	, DIA_Sonja_Choose_FaceBabe_N_PinkHair);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Blondine mit Tatoos" 	, DIA_Sonja_Choose_FaceBabe_N_BlondTattoo);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Blondine" 	, DIA_Sonja_Choose_FaceBabe_N_Blondie);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Schwarze Haare" 	, DIA_Sonja_Choose_FaceBabe_N_BlackHair);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_Face_BACK);
};

func void DIA_Sonja_Choose_FaceBabe_N_BlackHair()
{
	Sonja_SkinTexture 	=FaceBabe_N_BlackHair;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_Blondie()
{
	Sonja_SkinTexture 	=FaceBabe_N_Blondie;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_BlondTattoo()
{
	Sonja_SkinTexture 	=FaceBabe_N_BlondTattoo;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_PinkHair()
{
	Sonja_SkinTexture 	=FaceBabe_N_PinkHair;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_L_Charlotte()
{
	Sonja_BodyTexture 	=FaceBabe_L_Charlotte;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};

func void DIA_Sonja_Choose_FaceBabe_N_Hure()
{
    Sonja_BodyTexture 	=FaceBabe_N_Hure;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};

// ------------------------------------------------

func void DIA_Sonja_Choose_Face_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

// ************************************************************
// 			  				KLEIDUNG
// ************************************************************

INSTANCE DIA_Sonja_KLEIDUNG (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_KLEIDUNG_Condition;
	information	= DIA_Sonja_KLEIDUNG_Info;
	permanent	= TRUE;
	description = "(Bekleidung und Ausrüstung)";
};

FUNC INT DIA_Sonja_KLEIDUNG_Condition()
{
	return SonjaFolgt == TRUE;
};

func String BuildSonjaItemString(var String itemName, var int value)
{
    var String msg;
    msg = "";
    msg = ConcatStrings(" (", IntToString(value));
    msg = ConcatStrings(msg, " Gold)");
    msg = ConcatStrings(itemName, msg);

    return msg;
};

FUNC VOID DIA_Sonja_KLEIDUNG_Info()
{
	Info_ClearChoices	(DIA_Sonja_KLEIDUNG);

	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_MassDeath, Value_Ru_MassDeath),                 DIA_Sonja_KLEIDUNG_ItRu_MassDeath);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_ArmyOfDarkness, Value_Ru_ArmyofDarkness),       DIA_Sonja_KLEIDUNG_ItRu_ArmyOfDarkness);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_InstantFireball, Value_Ru_InstantFireball),     DIA_Sonja_KLEIDUNG_ItRu_InstantFireball);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbesiegbarkeit", Value_Ri_ProtTotal02),       DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_02);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbezwingbarkeit", Value_Ri_ProtTotal),        DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_01);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Wassermagierrobe", VALUE_ITAR_KDW_H),                   DIA_Sonja_KLEIDUNG_ITAR_KDW_H);
	if (Kapitel >= 5)
	{
        Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwere Drachenjägerrüstung", VALUE_ITAR_DJG_H),        DIA_Sonja_KLEIDUNG_ITAR_DJG_H);
    };
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Rüstung Drachenjägerin", 2000),          DIA_Sonja_KLEIDUNGITAR_DJG_BABE);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwere Banditenrüstung", VALUE_ITAR_BDT_H),            DIA_Sonja_KLEIDUNG_ITAR_BDT_H);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Mittlere Banditenrüstung", VALUE_ITAR_BDT_M),           DIA_Sonja_KLEIDUNG_ITAR_BDT_M);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kleidung Bäuerin", 200),                                DIA_Sonja_KLEIDUNG_Farmer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Leichte Armbrust", Value_LeichteArmbrust),              DIA_Sonja_KLEIDUNG_ItRw_Crossbow_L_02);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Buchenbogen", Value_Buchenbogen),                       DIA_Sonja_KLEIDUNG_ItRw_Bow_M_04);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kompositbogen", Value_Kompositbogen),                   DIA_Sonja_KLEIDUNG_ItRw_Bow_M_01);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Folteraxt", Value_Folteraxt),                           DIA_Sonja_KLEIDUNG_ItMw_Folteraxt);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kurzschwert", Value_ShortSword3),                       DIA_Sonja_KLEIDUNG_ItMw_ShortSword3);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwerer Ast", Value_BauMace),                          DIA_Sonja_KLEIDUNG_Schwerer_Ast);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Banditensachen",                                                             DIA_Sonja_KLEIDUNG_Banditensachen);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bester Gürtel aus ihrem Inventar",                                           DIA_Sonja_KLEIDUNG_BestBelt);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Ringe aus ihrem Inventar",                                             DIA_Sonja_KLEIDUNG_BestRings);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bestes Amulett aus ihrem Inventar",                                          DIA_Sonja_KLEIDUNG_BestAmulet);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Spruchrolle aus ihrem Inventar",                                       DIA_Sonja_KLEIDUNG_BestScroll);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Rune aus ihrem Inventar",                                              DIA_Sonja_KLEIDUNG_BestRune);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Fernkampfwaffe aus ihrem Inventar",                                    DIA_Sonja_KLEIDUNG_BestRangeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Nahkampfwaffe aus ihrem Inventar",                                     DIA_Sonja_KLEIDUNG_BestMeleeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Rüstung aus ihrem Inventar",                                           DIA_Sonja_KLEIDUNG_BestArmor);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Lege alle Ausrüstung ab",                                                    DIA_Sonja_KLEIDUNG_Unequip);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Normal",                                                                     DIA_Sonja_KLEIDUNG_Normal);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, DIALOG_BACK,                                                                  DIA_Sonja_KLEIDUNG_BACK);
};

func void DIA_Sonja_KLEIDUNG_BACK()
{
	Info_ClearChoices (DIA_Sonja_KLEIDUNG);
};

func void Sonja_Equip(var int armor, var int cost)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_00"); //Benutz das hier!
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_00"); //Wie du magst!
        EquipItem(self, armor);
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_KLEIDUNG_16_01"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Ausrüstung für sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_01"); //Hier ist neue Ausrüstung!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            B_GiveInvItems (other, self, armor, 1);
            EquipItem(self, armor);
            B_LogEntry ("Sonja", "Sonja freut sich über neue Ausrüstung.");
        };
    };
};

func void Sonja_BekleidenEx(var int armor, var int cost, var int equip)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_02"); //Zieh das hier an!
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_00"); //Wie du magst!

        AI_UnequipArmor	(self);

        if (equip == TRUE)
        {
            AI_EquipArmor 	(self, armor);
        };

        //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_KLEIDUNG_16_01"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Kleidung für sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_03"); //Hier ist etwas Neues zum Anziehen!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            CreateInvItems (self, armor, 1);
            AI_UnequipArmor	(self);

            if (equip == TRUE)
            {
                AI_EquipArmor 	(self, armor);
            };

            //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
            B_LogEntry ("Sonja", "Sonja freut sich über neue Kleidung.");
        };
    };
};

func void Sonja_Bekleiden(var int armor, var int cost)
{
    Sonja_BekleidenEx(armor, cost, TRUE);
};

// Irgendwie prüfen ob zweimal ausrüstbar.
func int Sonja_EquipFromInventoryEx(var int item, var String itemName, var int count)
{
    if (Npc_HasItems(self, item))
    {
        EquipItem(self, item);
        var String msg;
        //msg = ConcatStrings("Sonja ausgerüstet mit: ", Npc_GetInvItem(item).description);
        msg = ConcatStrings("Sonja ausgerüstet mit: ", itemName);
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2

        return TRUE;
    };

    return FALSE;
};

func int Sonja_EquipFromInventory(var int item, var String itemName)
{
    return Sonja_EquipFromInventoryEx(item, itemName, 1);
};

func void DIA_Sonja_KLEIDUNG_Normal ()
{
    Sonja_Bekleiden(ITAR_VlkBabe_H, 0);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Unequip ()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_04"); //Lege alles ab!
    AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_03"); //Wie du meinst, Süßer.

    AI_UnequipArmor(self);
    AI_UnequipWeapons(self);
    // TODO How to unequip rings and amulets etc.
    //if (Npc_HasEquippedArmor(self, ItAm_Hp_Mana_01))
    //{
      //  AI_UseItem(self, ItAm_Hp_Mana_01);
    //};

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestArmor()
{
    AI_EquipBestArmor(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestMeleeWeapon()
{
    AI_EquipBestMeleeWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRangeWeapon()
{
    AI_EquipBestRangedWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRune()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_04"); //Lege deine beste Rune an!

    if (Sonja_EquipFromInventory(ItRu_MassDeath, NAME_SPL_MassDeath))
    {
    }
    else if (Sonja_EquipFromInventory(ItRu_InstantFireball, NAME_SPL_InstantFireball))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestScroll()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege deine beste Spruchrolle an!

    if (Sonja_EquipFromInventory(ItSc_InstantFireball, NAME_SPL_InstantFireball))
    {
    }
    else if (Sonja_EquipFromInventory(ItSc_Firebolt, NAME_SPL_Firebolt))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestAmulet()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege dein bestes Amulett an!

    if (Sonja_EquipFromInventory(ItAm_Hp_Mana_01, "Amulett der Erleuchtung"))
    {
    }
    else if (Sonja_EquipFromInventory(ItAm_Prot_Point_01, "Amulett der Eichenhaut"))
    {
    }
    else if (Sonja_EquipFromInventory(ItAm_Hp_01, "Amulett der Lebenskraft"))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRings()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_06"); //Lege deine besten Ringe an!

    if (Sonja_EquipFromInventoryEx(ItRi_Prot_Edge_01, "Ring der Eisenhaut", 2))
    {
    }
    else if (Sonja_EquipFromInventoryEx(ItRi_Prot_Total_01, "Ring der Unbezwingbarkeit", 2))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestBelt()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_07"); //Zieh deinen besten Gürtel an!

    if (Sonja_EquipFromInventory(ItBE_Addon_Leather_01, "Ledergürtel"))
    {
    }
    else if (Sonja_EquipFromInventory(ItBE_Addon_MC, "Minecrawler Gürtel"))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Banditensachen()
{
    Info_ClearChoices	(DIA_Sonja_KLEIDUNG);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Banditensachen anlegen",                                                     DIA_Sonja_KLEIDUNG_Banditensachen_Confirm);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, DIALOG_BACK,                                                                  DIA_Sonja_KLEIDUNG_Info);
};

func void DIA_Sonja_KLEIDUNG_Banditensachen_Confirm()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_08"); //Zieh Banditensachen an!

    if (Npc_HasItems(self, ITAR_BDT_M))
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_07"); //Ich habe diese Mittlere Banditenrüstung.
        AI_EquipArmor(self, ITAR_BDT_M);
    }
    else if (Npc_HasItems(self, ITAR_BDT_H))
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_08"); //Ich habe diese Schwere Banditenrüstung.
        AI_EquipArmor(self, ITAR_BDT_H);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Schwerer_Ast()
{
    Sonja_Equip(ItMw_1h_Bau_Mace, Value_BauMace);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItMw_ShortSword3()
{
    Sonja_Equip(ItMw_ShortSword3, Value_ShortSword3);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItMw_Folteraxt()
{
    Sonja_Equip(ItMw_Folteraxt, Value_Folteraxt);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Bow_M_01()
{
    Sonja_Equip(ItRw_Bow_M_01, Value_Kompositbogen);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Bow_M_04()
{
    Sonja_Equip(ItRw_Bow_M_04, Value_Buchenbogen);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Crossbow_L_02()
{
    Sonja_Equip(ItRw_Crossbow_L_02, Value_LeichteArmbrust);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Farmer ()
{
    Sonja_Bekleiden(ITAR_BauBabe_M, 200);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_BDT_M ()
{
    Sonja_BekleidenEx(ITAR_BDT_M, VALUE_ITAR_BDT_M, FALSE);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_BDT_H ()
{
    Sonja_BekleidenEx(ITAR_BDT_H, VALUE_ITAR_BDT_H, FALSE);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNGITAR_DJG_BABE ()
{
    Sonja_Bekleiden(ITAR_DJG_BABE, 2000);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_DJG_H()
{
    Sonja_Bekleiden(ITAR_DJG_H, VALUE_ITAR_DJG_H);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_KDW_H()
{
    Sonja_Bekleiden(ITAR_KDW_H, VALUE_ITAR_KDW_H);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_01()
{
    Sonja_Equip(ItRi_Prot_Total_01, Value_Ri_ProtTotal);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_02()
{
    Sonja_Equip(ItRi_Prot_Total_02, Value_Ri_ProtTotal02);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_InstantFireball()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 2)
    {
        Sonja_Equip(ItRu_InstantFireball, Value_Ru_InstantFireball);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_05"); //Ich muss erst den zweiten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_ArmyOfDarkness()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 6)
    {
        Sonja_Equip(ItRu_ArmyOfDarkness, Value_Ru_ArmyofDarkness);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_06"); //Ich muss erst den sechsten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_MassDeath()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 6)
    {
        Sonja_Equip(ItRu_MassDeath, Value_Ru_MassDeath);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_06"); //Ich muss erst den sechsten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info HELP
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HELP		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HELP_Condition;
	information	 = 	DIA_Sonja_HELP_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Erledigen)";
};

func int DIA_Sonja_HELP_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HELP_Info ()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

    Info_AddChoice		(DIA_Sonja_HELP, "Sammle Gegenstände für mich ..."	,              DIA_Sonja_RESPAWN_ITEMS_Info);
    Info_AddChoice		(DIA_Sonja_HELP, "Rufe alle wilden Tiere herbei ..."	,          DIA_Sonja_RESPAWN_Info);
	Info_AddChoice		(DIA_Sonja_HELP, "Kannst du ein paar andere Frauen besorgen?"	,  DIA_Sonja_SUMMON_Info);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_HELP_BACK);
};

func void DIA_Sonja_HELP_BACK()
{
    Info_ClearChoices	(DIA_Sonja_HELP);
};

func void DIA_Sonja_SUMMON_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_SUMMON_15_00"); //Kannst du ein paar andere Frauen besorgen?

	if (Wld_GetDay() - SonjaSummonDays >= 3)
	{
        AI_Output			(self, other, "DIA_Sonja_SUMMON_16_00"); //Ich kenne ein Bäurin, die Interesse haben könnte. Aber nur damit du mit ihr mehr Gold verdienen kannst, verstanden?
        Wld_SpawnNpcRange	(self,	BAU_915_Baeuerin,	1,	500);
        SonjaSummonDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_SUMMON_16_01"); //Komm in ein paar Tagen noch mal zu mir. Alle drei Tage kann ich dir eine Frau beschaffen.
        B_LogEntry ("Sonja", "Sonja kann mir alle drei Tage eine neue Frau beschaffen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(3 + SonjaSummonDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    };

    DIA_Sonja_HELP_Info();
};


// RESPAWN

func void SonjaRespawnMonsterKhorinis ()
{
    Wld_InsertNpc 	(Gobbo_Skeleton, 	"FP_ROAM_MEDIUMFOREST_KAP2_24");
    Wld_InsertNpc 	(Skeleton, 			"FP_ROAM_MEDIUMFOREST_KAP2_22");
    Wld_InsertNpc 	(Lesser_Skeleton, 	"FP_ROAM_MEDIUMFOREST_KAP2_23");
    Wld_InsertNpc 	(Wolf, 			"FP_ROAM_MEDIUMFOREST_KAP2_25");
    Wld_InsertNpc 	(Wolf, 			"FP_ROAM_MEDIUMFOREST_KAP2_26");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_50");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_49");
    Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_10");
    Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_05");
    Wld_InsertNpc 	(Sheep, 			"NW_FARM3_MOUNTAINLAKE_05");
    Wld_InsertNpc 	(Sheep, 			"NW_FARM3_MOUNTAINLAKE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_06");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_04");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_04");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_72");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_72");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_75");
    Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_PATH_22_MONSTER");
    Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_PATH_22_MONSTER");
    Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_62_02");
    Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_62_02");
    Wld_InsertNpc 	(Molerat, "FP_ROAM_CITY_TO_FOREST_41");
    Wld_InsertNpc 	(Scavenger, 			"NW_FOREST_CONNECT_MONSTER2");
    Wld_InsertNpc 	(Scavenger, 			"NW_FOREST_CONNECT_MONSTER2");
    Wld_InsertNpc 	(Wolf, 			"NW_SHRINE_MONSTER");
    Wld_InsertNpc 	(Wolf, 			"NW_SHRINE_MONSTER");
    Wld_InsertNpc 	(Giant_Bug, 			"NW_PATH_TO_MONASTER_AREA_01");
    Wld_InsertNpc 	(Giant_Bug, 			"NW_PATH_TO_MONASTER_AREA_01");
    Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_AREA_11");
    Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_MONSTER22");
    Wld_InsertNpc	(Giant_Bug, 	"NW_FARM1_CITYWALL_RIGHT_02");
    Wld_InsertNpc	(Wolf, "NW_FARM1_PATH_CITY_10_B");
    Wld_InsertNpc	(Wolf, "NW_FARM1_PATH_CITY_SHEEP_04");

    Wld_InsertNpc	(Giant_Bug,	"NW_FARM1_PATH_SPAWN_07");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_34");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_36");

    Wld_InsertNpc 	(Scavenger,	"NW_TAVERNE_BIGFARM_MONSTER_01");
    Wld_InsertNpc 	(Scavenger,	"NW_TAVERNE_BIGFARM_MONSTER_01");

    Wld_InsertNpc 	(Lurker,	"NW_BIGFARM_LAKE_MONSTER_02_01");

    Wld_InsertNpc 	(Gobbo_Black, 		"NW_BIGFARM_LAKE_03_MOVEMENT");
    Wld_InsertNpc 	(Gobbo_Black, 		"NW_BIGFARM_LAKE_03_MOVEMENT");

    Wld_InsertNpc 	(Gobbo_Black,	"NW_TAVERNE_TROLLAREA_MONSTER_05_01");

    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
};

func void SonjaRespawnTrolleKhorinis ()
{
    Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_08");
	Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_07");


	//----- Schwarzer Troll -----
	Wld_InsertNpc 	(Troll_Black, 			"NW_TROLLAREA_PATH_84");
};

func void SonjaRespawnShadowBeastsKhorinis ()
{
    Wld_InsertNpc		(Shadowbeast, "NW_FARM1_CITYWALL_FOREST_04_B");
    Wld_InsertNpc 	(Shadowbeast,	"NW_FARM4_WOOD_MONSTER_08");
    Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_MEDIUMFOREST_KAP3_20");
    Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_CITYFOREST_KAP3_04");
    Wld_InsertNpc 	(Shadowbeast, "NW_FOREST_PATH_35_06");
    Wld_InsertNpc 	(Shadowbeast, "NW_CITYFOREST_CAVE_A06");
    Wld_InsertNpc 	(Shadowbeast, 	"FP_ROAM_NW_TROLLAREA_RUINS_10");
    Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_02");
    Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_07");
};

FUNC VOID DIA_Sonja_RESPAWN_Choices()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

    Info_AddChoice		(DIA_Sonja_HELP, "Alle Schattenläufer in Khorinis"	,Sonja_RESPAWN_ShadowBeastsKhorinis);
    Info_AddChoice		(DIA_Sonja_HELP, "Alle Trolle in Khorinis"	,Sonja_RESPAWN_TrolleKhorinis);
	Info_AddChoice		(DIA_Sonja_HELP, "Alle Tiere in Khorinis"	,Sonja_RESPAWN_Khorinis);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_RESPAWN_BACK);
};

FUNC VOID DIA_Sonja_RESPAWN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei ...
    DIA_Sonja_RESPAWN_Choices();
};

func void DIA_Sonja_RESPAWN_BACK()
{
	DIA_Sonja_HELP_Info();
};

FUNC VOID Sonja_RESPAWN_Khorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnMonsterKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

FUNC VOID Sonja_RESPAWN_TrolleKhorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnTrolleKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

FUNC VOID Sonja_RESPAWN_ShadowBeastsKhorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnShadowBeastsKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

func void SonjaRespawnItemsHerb()
{
    CreateInvItems (self, ItPl_Temp_Herb, 10);
    CreateInvItems (self, ItPl_SwampHerb, 2);
    CreateInvItems (self, ItPl_Health_Herb_01, 5);
    CreateInvItems (self, ItPl_Health_Herb_02, 2);
    CreateInvItems (self, ItPl_Mana_Herb_01, 5);
    CreateInvItems (self, ItPl_Mushroom_01, 5);
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Choices()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

	Info_AddChoice		(DIA_Sonja_HELP, "Sammle Kräuter für mich."	,Sonja_RESPAWN_ITEMS_Herb);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_RESPAWN_ITEMS_BACK);
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_15_00"); //Sammle Gegenstände für mich ...
    DIA_Sonja_RESPAWN_ITEMS_Choices();
};

func void DIA_Sonja_RESPAWN_ITEMS_BACK()
{
	DIA_Sonja_HELP_Info();
};

FUNC VOID Sonja_RESPAWN_ITEMS_Herb()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_Herb_15_00"); //Sammle Kräuter für mich.

    if (Wld_GetDay() - SonjaRespawnItemsDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche Gegenstände für mich sammeln.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnItemsHerb();

        PrintScreen ("Neues im Handelsinventar von Sonja!", - 1, - 1, FONT_Screen, 2);

        SonjaRespawnItemsDays = 0;
    };

    DIA_Sonja_RESPAWN_ITEMS_Choices();
};

// ************************************************************
// 			  				KOCHEN
// ************************************************************
INSTANCE DIA_Sonja_KOCHEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_KOCHEN_Condition;
	information	= DIA_Sonja_KOCHEN_Info;
	permanent	= TRUE;
	description = "(Bekochen lassen)";
};

FUNC INT DIA_Sonja_KOCHEN_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_KOCHEN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_KOCHEN_15_00"); //Koch mir was!

    if (SonjaGeheiratet)
    {
        if (Wld_GetDay() - SonjaCookDays < 7)
        {
            AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_00"); //Ich koche nur jede Woche etwas für dich! Komm in ein paar Tagen wieder!
            B_LogEntry ("Sonja", "Sonja kocht für mich nur einmal in der Woche.");

            var String msg;
            msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaCookDays - Wld_GetDay()));
            PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
        }
        else
        {
            AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_01"); //Gerne, mein Ehemann!
            B_GiveInvItems (self, other, ItFo_XPStew, 1);
            SonjaCookDays = 0;
        };
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_02"); //Koch dir doch selbst was! Ich bin nicht deine Frau!
    };
};

// ************************************************************
// 			  				ANGEBEN
// ************************************************************
var int SonjaAngebenLevel;

INSTANCE DIA_Sonja_ANGEBEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ANGEBEN_Condition;
	information	= DIA_Sonja_ANGEBEN_Info;
	permanent	= TRUE;
	description = "(Angeben)";
};

FUNC INT DIA_Sonja_ANGEBEN_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ANGEBEN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_ANGEBEN_15_00"); //Schau mal wie viel Erfahrung ich gesammelt habe!

    if (other.level <= SonjaAngebenLevel)
    {
        AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_00"); //Ach, du Angeber! Du bist doch immer noch so wie beim letzten Mal!
        B_LogEntry ("Sonja", "Sonja ist unbeeindruckt von meiner Angeberei, wenn ich nicht wirklich mehr Erfahrung gesammelt habe.");
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_01"); //Ja mein Prinz, du bist der Beste! Aus dir kann noch ein König werden!
        B_LogEntry ("Sonja", "Sonja mag mich mit mehr Erfahrung lieber. Ich sollte Erfahrung sammeln.");
    };

    SonjaAngebenLevel = other.level;
};

// ************************************************************
// 			  				SCHEIDUNG
// ************************************************************

INSTANCE DIA_Sonja_SCHEIDUNG (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_SCHEIDUNG_Condition;
	information	= DIA_Sonja_SCHEIDUNG_Info;
	permanent	= TRUE;
	description = "Ich möchte die Scheidung.";
};

FUNC INT DIA_Sonja_SCHEIDUNG_Condition()
{
	return SonjaFolgt == TRUE && SonjaGeheiratet == TRUE;
};

FUNC VOID DIA_Sonja_SCHEIDUNG_Info()
{
    AI_Output			(other, self, "DIA_Sonja_SCHEIDUNG_15_00"); //Ich möchte die Scheidung.

     AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_00"); //Berührt - geführt! Überleg dir lieber mal deinen nächsten Schachzug, damit wir zu mehr Gold kommen!
    B_LogEntry ("Sonja", "Für Sonja kommt eine Scheidung nicht in Frage. Ich soll lieber mehr Gold verdienen.");
};

// ************************************************************
// 			  				ADVICE
// ************************************************************

INSTANCE DIA_Sonja_ADVICE (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ADVICE_Condition;
	information	= DIA_Sonja_ADVICE_Info;
	permanent	= TRUE;
	description = "Was soll ich als Nächstes tun?";
};

FUNC INT DIA_Sonja_ADVICE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ADVICE_Info()
{
    AI_Output			(other, self, "DIA_Sonja_ADVICE_15_00"); //Was soll ich als Nächstes tun?

    if (Kapitel == 1)
    {
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_03"); //Geh zu Lord Hagen und hol dir das Auge Innos.
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
    else if (Kapitel == 2)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_04"); //Geh ins Minental und hole dir alle Informationen für Lord Hagen.
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 3)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_05"); //Kümmere dich um das Auge Innos.
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 4)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_06"); //Sprich mit den Drachen und mache sie fertig!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 5)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_07"); //Besorg dir die Informationen im Kloster und weiter geht's!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
    else if (Kapitel == 6)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_08"); //Vernichte die Diener Beliars!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
	else
	{
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_00"); //Ich weiß es nicht.
        B_LogEntry ("Sonja", "Sonja weiß auch nicht, was ich tun soll.");
	};
};

// ************************************************************
// 			  				Buy Hans
// ************************************************************
var int Sonja_Meatbugekauft;
var int HansIsDeadSaid;

instance DIA_Sonja_BuyLHans	(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	8;
	condition	 = 	DIA_Sonja_BuyHans_Condition;
	information	 = 	DIA_Sonja_BuyHans_Info;
	permanent	 = 	TRUE;
	description	 = 	"Hier sind 100 Goldstücke. Gib mir eine Fleischwanze.";
};
func int DIA_Sonja_BuyHans_Condition ()
{
	return SonjaFolgt == TRUE;
};
func void DIA_Sonja_BuyHans_Info ()
{
	AI_Output (other, self, "DIA_Sonja_BuyHans_15_00"); //Hier sind 100 Goldstücke. Gib mir eine Fleischwanze.

	if (B_GiveInvItems  (other, self, ItMi_Gold, 100))
	{
		if (Sonja_Meatbugekauft == 0)
		{
            B_LogEntry ("Sonja", "Bei Sonja kann ich eine Fleischwanze kaufen, damit wir ein gemeinsames Haustier haben.");

			AI_Output (self, other, "DIA_Sonja_BuyHans_03_01"); //Gut. Dann nimm dir Hans mit.
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_02"); //Sag ihm einfach, er soll dir folgen. Er ist ziemlich klug für eine Fleischwanze. Behandele ihn gut!
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_03"); //Endlich haben wir ein gemeinsames Haustier!
		}
		else
		{
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_03"); //Schon wieder? Na schön. Nimm dir die Hans mit.
			AI_Output (other, self, "DIA_Sonja_BuyHans_15_04"); //Hans? Die letzte Fleischwanze hieß schon Hans ...
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_05"); //Ja und wer weiß was du mit der vor hattest? Mein Haustier heißt immer Hans und jetzt pass besser auf ihn auf als das letzte Mal!
		};

		Sonja_Meatbugekauft = Sonja_Meatbugekauft + 1;
		Wld_SpawnNpcRange	(self,	Follow_Meatbug,	1,	500);
        Hans			= Hlp_GetNpc (Follow_Meatbug);
        HansIsDeadSaid = FALSE;

		AI_StopProcessInfos (self);
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_BuyHans_03_09"); //Soviel Gold hast du nicht. Billiger kann ich dir keins geben.
	};
};

// ************************************************************
// 			  				Hans is dead
// ************************************************************
instance DIA_Sonja_HansIsDead	(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	8;
	condition	 = 	DIA_Sonja_HansIsDead_Condition;
	information	 = 	DIA_Sonja_HansIsDead_Info;
	permanent	 = 	TRUE;
	important    =  TRUE;
};
func int DIA_Sonja_HansIsDead_Condition ()
{
	return SonjaFolgt == TRUE && Sonja_Meatbugekauft > 0 && Npc_IsDead(Hans) && HansIsDeadSaid == FALSE;
};
func void DIA_Sonja_HansIsDead_Info ()
{
    HansIsDeadSaid = TRUE;
	AI_Output (self, other, "DIA_Sonja_HansIsDead_16_00"); //Was hast du getan? Hans ist gestorben! Du hast nicht gut genug auf ihn aufgepasst! Ich hasse dich!
	AI_Output (self, other, "DIA_Sonja_HansIsDead_16_01"); //Kauf mir ein neues Haustier!
	B_LogEntry ("Sonja", "Sonja will, dass ich uns ein neues Haustier kaufe und dies mal besser darauf aufpasse.");
};

// ************************************************************
// 			  				SLEEP
// ************************************************************

INSTANCE DIA_Sonja_SLEEP (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_SLEEP_Condition;
	information	= DIA_Sonja_SLEEP_Info;
	permanent	= TRUE;
	description = "(Schlafen)";
};

FUNC INT DIA_Sonja_SLEEP_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_SLEEP_Info()
{
	Info_ClearChoices	(DIA_Sonja_SLEEP);

	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis Mitternacht schlafen"	,Sonja_SleepTime_Midnight_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum nächsten Abend schlafen"	,Sonja_SleepTime_Evening_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis Mittags schlafen"	,Sonja_SleepTime_Noon_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum nächsten Morgen schlafen"	,Sonja_SleepTime_Morning_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, DIALOG_BACK 		, DIA_Sonja_SLEEP_BACK);
};

func void DIA_Sonja_SLEEP_BACK()
{
	Info_ClearChoices (DIA_Sonja_SLEEP);
};

//---------------------- morgens --------------------------------------

func void Sonja_SleepTime_Morning_Info ()
{
	PC_Sleep (8);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//--------------------- mittags -----------------------------------------

func void Sonja_SleepTime_Noon_Info ()
{
	PC_Sleep (12);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//---------------------- abend --------------------------------------

func void Sonja_SleepTime_Evening_Info ()
{
	PC_Sleep (20);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//------------------------ nacht -----------------------------------------

func VOID Sonja_SleepTime_Midnight_Info()
{
	PC_Sleep (0);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};








