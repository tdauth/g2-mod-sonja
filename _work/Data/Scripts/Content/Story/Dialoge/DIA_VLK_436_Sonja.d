var int SonjaFolgt;							//= TRUE Sonja folgt.
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
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_00"); //Sprich mit Bromor, wenn du Spa� haben willst.
	}
	else if (other.guild == GIL_DJG)
	&& (Sonja_Says == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_01"); //Das Problem mit euch Typen ist, dass ihr lieber Orks abschlachtet als zu v�geln.
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
    Npc_ExchangeRoutine	(self,"FOLLOW");
    self.aivar[AIV_PARTYMEMBER] = TRUE;
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
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_01"); //1000 Goldst�cke! Wahnsinn! Endlich mal ein reicher Mann im Hafen, der wei� wie man eine Dame behandelt.
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_02"); //Lass uns abhauen!
        B_LogEntry ("Sonja", "Sonja folgt mir nun und arbeitet f�r mich.");
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
	description  =  "Ich m�chte dich freikaufen!";
};

func int DIA_Sonja_FREIKAUFEN_Condition ()
{
	return SonjaFolgt == FALSE;
};

func void DIA_Sonja_FREIKAUFEN_Info ()
{
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_00"); //Ich m�chte dich freikaufen!
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_00"); //Oh Romeo, willst du das wirklich tun? Hast du denn �berhaupt genug Gold, um eine Frau wie mich zu versorgen?
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_01"); //Du k�nntest weiterhin f�r mich arbeiten.
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_02"); //Sagen wir so: Wenn du mir eine Menge Gold gibst und mehr �brig l�sst als Bromor, dann verlasse ich gerne die Rote Laterne.
    B_LogEntry ("Sonja", "Sonja, die Freudendame in der Roten Laterne, schlie�t sich mir an und arbeitet f�r mich, wenn ich ihr 1000 Goldst�cke gebe.");
    SonjaGefragt = TRUE;
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
	description  =  "Was h�ltst du von ...";
	nr		 	= 99;
};

func int DIA_Sonja_PEOPLE_Condition ()
{
	return SonjaFolgt;
};

func void DIA_Sonja_PEOPLE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du vom Richter?"	,     DIA_Sonja_PEOPLE_Richter);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Lord Hagen?"	,     DIA_Sonja_PEOPLE_Hagen);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Vatras?"	,     DIA_Sonja_PEOPLE_Vatras);
	Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Nadja?"	,     DIA_Sonja_PEOPLE_Nadja);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Bromor?"	,     DIA_Sonja_PEOPLE_Bromor);
    Info_AddChoice		(DIA_Sonja_PEOPLE, DIALOG_BACK 		,                 DIA_Sonja_PEOPLE_BACK);
};

func void DIA_Sonja_PEOPLE_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
};

func void DIA_Sonja_PEOPLE_Nadja ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Nadja_15_00"); //Was h�ltst du von Nadja?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_00"); //Nadja? Ach so eine graue Maus. Die kann doch gar nichts! H�bsch ist sie, zugegeben, aber Erfahrung hat sei kaum und Sch�nheit vergeht.
    B_LogEntry ("Sonja", "Sonja h�lt Nadja f�r eine graue Maus.");

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_01"); //Du findest sie doch nicht etwa h�bscher als mich? Ich warne dich, schau sie blo� nicht an!
        B_LogEntry ("Sonja", "Sonja ist eifers�chtig auf Nadja.");
    };

    DIA_Sonja_PEOPLE_Info();
};


func void DIA_Sonja_PEOPLE_Bromor ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Bromor_15_00"); //Was h�ltst du von Bromor?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_00"); //Bromor ist ein mieser Halsabschneider. Er nimmt den meisten Ertrag der Frauen f�r sich.

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_01"); //Aber was soll's? Meinen Prinzen habe ich ja jetzt gefunden!
    };

    B_LogEntry ("Sonja", "Sonja h�lt Bromor f�r einen miesen Halsabschneider.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Vatras ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Vatras_15_00"); //Was h�ltst du von Vatras?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Vatras_16_00"); //Vatras predigt jetzt viel ruhiger, seitdem er mir seine Wasserzauber gezeigt hat.

    B_LogEntry ("Sonja", "Sonja hat Vatras ruhiger gestimmt.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Hagen ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Hagen_15_00"); //Was h�ltst du von Lord Hagen?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Hagen_16_00"); //Im Bett durfte ich ihn nur mit Eure Lordschaft ansprechen.

    B_LogEntry ("Sonja", "Lord Hagen wurde nur als Eure Lordschaft von Sonja angesprochen.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Richter ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Richter_15_00"); //Was h�ltst du vom Richter?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Richter_16_00"); //�ber mich hat er jede Nacht gerichtet. Sein Urteil viel zu meinen Gunsten aus.

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
	description  =  "Gibt es �berhaupt jemanden, der noch nicht Kunde bei dir war?";
	nr		 	= 99;
};

func int DIA_Sonja_NOT_YET_Condition ()
{
	return SonjaFolgt;
};

func void DIA_Sonja_NOT_YET_Info ()
{
    AI_Output (other, self, "DIA_Sonja_NOT_YET_15_00"); //Gibt es �berhaupt jemanden, der noch nicht Kunde bei dir war?
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
    Info_AddChoice		(DIA_Sonja_SKILL, DIALOG_BACK 		,                 DIA_Sonja_SKILL_BACK);
};

func void DIA_Sonja_SKILL_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_SKILL);
};

func void DIA_Sonja_XP_Info ()
{
    AI_Output (other, self, "DIA_Sonja_XP_15_00"); //Wie erfahren bist du?
    AI_Output (self, other, "DIA_Sonja_XP_16_00"); //Finde es heraus!

    var String levelText;
    var String lpText;
    var String xpText;
    var String xpNextText;
    var String msg;

    levelText = ConcatStrings("Stufe: ", IntToString(self.level));
    lpText = ConcatStrings(" Lernpunkte: ", IntToString(self.lp));
    xpText = ConcatStrings(" XP: ", IntToString(self.exp));
    xpNextText = ConcatStrings(" XP n�chste Stufe: ", IntToString(self.exp_next));
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
    AI_Output (self, other, "DIA_Sonja_STATS_16_00"); //Finde es heraus!

    var String hpText;
    var String manaText;
    var String strText;
    var String dexText;
    var String msg;

    hpText = ConcatStrings("Leben: ", IntToString(self.attribute[ATR_HITPOINTS_MAX]));
    manaText = ConcatStrings(" Mana: ", IntToString(self.attribute[ATR_MANA_MAX]));
    strText = ConcatStrings(" St�rke: ", IntToString(self.attribute[ATR_STRENGTH]));
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
    AI_Output (self, other, "DIA_Sonja_SKILL_16_00"); //Finde es heraus!

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
    AI_Output (other, self, "DIA_Sonja_PROTECTION_15_00"); //Wie gut bist du gesch�tzt?
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
	AI_Output (self ,other, "DIA_Sonja_WARTEHIER_16_00"); //Wie du meinst, mein S��er!

	self.aivar[AIV_PARTYMEMBER] = FALSE;

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
	if (self.aivar[AIV_PARTYMEMBER] == TRUE)
	{
		return TRUE;
	};
};

FUNC VOID DIA_Sonja_GoHome_Info()
{
	AI_Output (other, self, "DIA_Addon_Skip_GoHome_15_00"); //Ich brauch dich nicht mehr.
	AI_Output (self, other, "DIA_Sonja_GoHome_16_00"); // Arschloch!

	self.aivar[AIV_PARTYMEMBER] = FALSE;
	Npc_ExchangeRoutine	(self,"START");
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
    Info_AddChoice	(DIA_Sonja_HEILUNG, "Ich werde dir sp�ter etwas geben.", DIA_Sonja_HEILUNG_spaeter );

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
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_01"); //Ich sch�tze, ich muss warten, bis du einen �brig hast.
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
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_02"); //Im Moment hast du leider keinen. Ich komm sp�ter noch mal darauf zur�ck.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_spaeter ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_spaeter_15_00"); //Ich werde dir sp�ter etwas geben.
	AI_Output			(self ,other, "DIA_Sonja_HEILUNG_16_03"); //Vergiss es aber nicht.

	AI_StopProcessInfos (self);
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
            AI_Output			(self, other, "DIA_Sonja_HEAL_16_00"); //Endlich erobert mein Prinz sein Schloss zur�ck!
            PlayVideo ("LOVESCENE.BIK");
            hero.attribute [ATR_HITPOINTS] = hero.attribute[ATR_HITPOINTS_MAX];
            hero.attribute [ATR_MANA] = hero.attribute[ATR_MANA_MAX];
            PrintScreen (PRINT_FullyHealed, - 1, - 1, FONT_Screen, 2);
            B_LogEntry ("Sonja", "Sonja hat gewisse Talente, die mich heilen und mein Mana regenerieren.");
        }
        else
        {
            AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migr�ne.
            B_LogEntry ("Sonja", "Sonja hat komischerweise �fter mal Migr�ne, wenn ich meine Wurst warm machen will.");
        };
        SonjaSexDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migr�ne.
        B_LogEntry ("Sonja", "Sonja hat komischerweise �fter mal Migr�ne, wenn ich meine Wurst warm machen will.");

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
	description	 = 	"Wie f�hlst du dich?";
};

func int DIA_Sonja_FEELINGS_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_FEELINGS_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_FEELINGS_15_00"); //Wie f�hlst du dich?

    if (Wld_IsRaining())
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_00"); //Ach, das Wetter ist beschissen!
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_01"); //Das Wetter ist heute sch�n!
    };
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
	return SonjaFolgt;
};

func void DIA_Sonja_WAREZ_Info ()
{
    if (Npc_HasItems (self, ItRu_SummonSonja) <= 0)
    {
        CreateInvItems (self, ItRu_SummonSonja, 1);
    };

    if (Npc_HasItems (self, ItRu_TeleportSonja) <= 0)
    {
        CreateInvItems (self, ItRu_TeleportSonja, 1);
    };

    // Immer neuen Rohstahl
    if (Npc_HasItems (self, ItMiSwordraw) <= 0)
    {
        CreateInvItems (self, ItMiSwordraw, 5);
    };

    // Wir platzieren es hier, um die Datei B_GiveTradeInv.d nicht zu veraendern.
	if (self.aivar[AIV_ChapterInv] <= Kapitel)
	{
        B_ClearJunkTradeInv (self);
        B_GiveTradeInv_Sonja		(self);

        self.aivar[AIV_ChapterInv] = (Kapitel +1);
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
	description	 = 	"M�chtest du meine Frau werden?";
};

func int DIA_Sonja_HEIRATEN_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HEIRATEN_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_00"); //M�chtest du meine Frau werden?
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_00"); //Hmmm, hast du mir denn wirklich genug zu bieten? Wie sieht es mit Schmuck aus? Was ist mit sch�ner Kleidung? Die kostet Geld. Wo sollen wir wohnen, mein Prinz?
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_01"); //Ich sorge f�r alles.
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_01"); //Ich glaube an dich. Gib mir noch einmal 1000 Goldst�cke und etwas Schmuck und wir k�nnen heiraten.

	B_LogEntry ("Sonja", "Sonja wird meine Frau wenn ich ihr 1000 Goldst�cke, einen goldenen Ring und eine Schatulle gebe.");
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
	AI_Output			(other, self, "DIA_Sonja_HOCHZEIT_15_00"); //M�chtest du meine Frau werden?

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
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_03"); //Oh, mein Prinz, ich gebe dir das Ja-Wort. Wir sind nun Frau und Mann. Schnell gib, mir die Waren, damit ich sie f�r uns aufbewaren kann.
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        B_GiveInvItems (other, self, ItMi_GoldRing, 1);
        B_GiveInvItems (other, self, ItMi_GoldChest, 1);
        B_LogEntry ("Sonja", "Sonja und ich haben geheiratet. Wir sind nun Mann und Frau. Wenn mein alter Freund Xardas das nur w�sste!");
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
	description	 = 	"(Liebeserkl�rung)";
};

func int DIA_Sonja_LIEBE_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_LIEBE_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_LIEBE_15_00"); //Oh du holde Maid, so sch�n ist dein Antlitz, wie das Feuer der Drachen gl�nzt es und M�nner erblinden vor seiner Sch�nheit! Nur das Auge Innos kann dir stand halten.

	AI_Output			(self, other, "DIA_Sonja_LIEBE_16_00"); //Hast du zu viel Sumpfkraut geraucht? Mach dich lieber n�tzlich!

	if (SonjaGeheiratet)
	{
        AI_Output			(self, other, "DIA_Sonja_LIEBE_16_01"); //Und diesen "Mann" habe ich geheiratet ...
	};

	B_LogEntry ("Sonja", "Sonja war von meiner Liebeserkl�rung nicht sonderlich beeindruckt.");
};

///////////////////////////////////////////////////////////////////////
//	Info SUMMON
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_SUMMON		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_SUMMON_Condition;
	information	 = 	DIA_Sonja_SUMMON_Info;
	permanent	 = 	TRUE;
	description	 = 	"Kannst du ein paar andere Frauen besorgen?";
};

func int DIA_Sonja_SUMMON_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_SUMMON_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_SUMMON_15_00"); //Kannst du ein paar andere Frauen besorgen?

	if (Wld_GetDay() - SonjaSummonDays >= 3)
	{
        AI_Output			(other, self, "DIA_Sonja_SUMMON_16_00"); //Ich kenne ein B�urin, die Interesse haben k�nnte. Aber nur damit du mit ihr mehr Gold verdienen kannst, verstanden?
        Wld_SpawnNpcRange	(self,	BAU_915_Baeuerin,	1,	500);
        SonjaSummonDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(other, self, "DIA_Sonja_SUMMON_16_01"); //Komm in ein paar Tagen noch mal zu mir. Alle drei Tage kann ich dir eine Frau beschaffen.
        B_LogEntry ("Sonja", "Sonja kann mir alle drei Tage eine neue Frau beschaffen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(3 + SonjaSummonDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    };
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
	AI_Output			(other, self, "DIA_Sonja_PROFIT_15_00"); //Warst du auch flei�ig anschaffen?
	AI_Output			(self, other, "DIA_Sonja_PROFIT_16_00"); //Mein Tor ist f�r jeden Zahlenden weit ge�ffnet.

	if (Wld_GetDay() - SonjaProfitDays >= 5)
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_01"); //Hier mein Prinz. 50 Goldst�cke pro Kunde und du bekommst deine H�lfte!
        B_GiveInvItems (self, other, ItMi_Gold, (Wld_GetDay() - SonjaProfitDays) * 6 * 25); // 6 Kunden pro Tag
        SonjaProfitDays = Wld_GetDay();

        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_02"); //Und hier ist die Liste meiner Kunden, damit du auch Bescheid wei�t.

        CreateInvItems (self, ItWr_SonjasListCustomers, 1);
        B_GiveInvItems (self, other, ItWr_SonjasListCustomers, 1);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_03"); //Komm in ein paar Tagen noch mal zu mir. Alle f�nf Tage kann ich dir dein Gold geben.
        B_LogEntry ("Sonja", "Sonja gibt mir alle sieben Tage meinen Anteil an ihrem verdienten Gold.");

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
	Info_AddChoice		(DIA_Sonja_TRAINING, "Armbrust"	,    DIA_Sonja_TRAINING_CROSSBOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Bogen"	,    DIA_Sonja_TRAINING_BOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Zweihandwaffen"	,    DIA_Sonja_TRAINING_TWO_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Einhandwaffen"	,    DIA_Sonja_TRAINING_ONE_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Geschick"	,    DIA_Sonja_TRAINING_DEX);
	Info_AddChoice		(DIA_Sonja_TRAINING, "St�rke"	,    DIA_Sonja_TRAINING_STR);
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

func void DIA_Sonja_TRAINING_STR ()
{
    Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR1			, B_GetLearnCostAttribute(other, ATR_STRENGTH))			,DIA_Sonja_Teach_STR_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR5			, B_GetLearnCostAttribute(other, ATR_STRENGTH)*5)		,DIA_Sonja_Teach_STR_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
};

FUNC VOID DIA_Sonja_Teach_Back ()
{
	DIA_Sonja_TRAINING_Info_Choices();
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
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
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
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
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
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
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
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
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
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_Teach_Back);
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

func void DIA_Sonja_TRAINING_MANA ()
{
	Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA1			, B_GetLearnCostAttribute(other, ATR_MANA_MAX))			,DIA_Sonja_TEACH_MANA_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA5			, B_GetLearnCostAttribute(other, ATR_MANA_MAX)*5)		,DIA_Sonja_TEACH_MANA_5);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_Teach_Back);
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

    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_Teach_Back);
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_1 ()
{
    if (B_TeachMagicCircle (other,self, 1))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_01"); //Du bist bist nun im ersten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_2 ()
{
    if (B_TeachMagicCircle (other,self, 2))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_02"); //Du bist bist nun im zweiten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_3 ()
{
    if (B_TeachMagicCircle (other,self, 3))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_03"); //Du bist bist nun im dritten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_4 ()
{
    if (B_TeachMagicCircle (other,self, 4))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_04"); //Du bist bist nun im vierten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_5 ()
{
    if (B_TeachMagicCircle (other,self, 5))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_05"); //Du bist bist nun im f�nften Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_6 ()
{
    if (B_TeachMagicCircle (other,self, 6))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_06"); //Du bist bist nun im sechsten Kreis der Magie.
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
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_Teach_Back);
};

func void DIA_Sonja_TEACH_SNEAK ()
{
    if (B_TeachThiefTalent (other, self, NPC_TALENT_SNEAK))
	{
		AI_Output (self, other, "DIA_Sonja_TRAINING_15_07");//Du kannst jetzt schleichen.
	};

	DIA_Sonja_TRAINING_MORE();
};

//func void AI_SetWalkmode(var c_npc n, var int n0)
//gibt an mit welchem Walkmode Run etc der Character durch das Level l�uft
//NPC_RUN : Rennen
//NPC_WALK : Gehen
//NPC_SNEAK : Schleichen
//NPC_RUN_WEAPON : Rennen mit gezogener Waffe
//NPC_WALK_WEAPON : Gehen mit gezogener Waffe
//NPC_SNEAK_WEAPON : Schleichen mit gezogener Waffe

//////////////////////////////////////////////////////////////////////
//	Info WALKMODE
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_WALKMODE   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 10;
	condition   = DIA_Sonja_WALKMODE_Condition;
	information = DIA_Sonja_WALKMODE_Action;
	permanent   = TRUE;
	description = "�ndere deine Gangart!";
};

FUNC INT DIA_Sonja_WALKMODE_Condition()
{
	return SonjaFolgt == TRUE;
};
FUNC VOID DIA_Sonja_WALKMODE_Action()
{
	AI_Output (other, self, "DIA_Sonja_WALKMODE_15_00");//�ndere deine Gangart!

	Info_ClearChoices   (DIA_Sonja_WALKMODE);
	if (Npc_GetTalentSkill(self, NPC_TALENT_SNEAK) == 1)
	{
        Info_AddChoice		(DIA_Sonja_WALKMODE, "Schleiche", DIA_Sonja_WALKMODE_SNEAK);
    };
	Info_AddChoice		(DIA_Sonja_WALKMODE, "Gehe", DIA_Sonja_WALKMODE_WALK);
    Info_AddChoice		(DIA_Sonja_WALKMODE, "Renne (Standard)", DIA_Sonja_WALKMODE_RUN);
    Info_AddChoice		(DIA_Sonja_WALKMODE, "Sprinte", DIA_Sonja_WALKMODE_SPRINT);

    Info_AddChoice 		(DIA_Sonja_WALKMODE,DIALOG_BACK,DIA_Sonja_WALKMODE_Back);

};

func void DIA_Sonja_WALKMODE_Back ()
{
    Info_ClearChoices   (DIA_Sonja_WALKMODE);
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

//////////////////////////////////////////////////////////////////////
//	Info FAI
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_FAI   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 10;
	condition   = DIA_Sonja_FAI_Condition;
	information = DIA_Sonja_FAI_Action;
	permanent   = TRUE;
	description = "�ndere dein Kampfverhalten!";
};

FUNC INT DIA_Sonja_FAI_Condition()
{
	return SonjaFolgt == TRUE;
};
FUNC VOID DIA_Sonja_FAI_Action()
{
	AI_Output (other, self, "DIA_Sonja_FAI_15_00");//�ndere dein Kampfverhalten!

	Info_ClearChoices   (DIA_Sonja_FAI);
	Info_AddChoice		(DIA_Sonja_FAI, "Meister", DIA_Sonja_FAI_MASTER);
	Info_AddChoice		(DIA_Sonja_FAI, "Stark", DIA_Sonja_FAI_STRONG);
	Info_AddChoice		(DIA_Sonja_FAI, "Normal", DIA_Sonja_FAI_NORMAL);
    Info_AddChoice		(DIA_Sonja_FAI, "Feigling (Standard)", DIA_Sonja_FAI_COWARD);
    Info_AddChoice 		(DIA_Sonja_FAI,DIALOG_BACK,DIA_Sonja_FAI_Back);

};

func void DIA_Sonja_FAI_Back ()
{
    Info_ClearChoices   (DIA_Sonja_FAI);
};

func void DIA_Sonja_FAI_COWARD ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_01");//K�mpfe wie ein Feigling!
    self.fight_tactic = FAI_HUMAN_COWARD;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_NORMAL ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_02");//K�mpfe normal!
    self.fight_tactic = FAI_HUMAN_NORMAL;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_STRONG ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_03");//K�mpfe stark!
    self.fight_tactic = FAI_HUMAN_STRONG;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_MASTER ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_04");//K�mpfe wie ein Meister!
    self.fight_tactic = FAI_HUMAN_MASTER;

    DIA_Sonja_FAI_Action();
};

//---------------------------------------------------------------------
//	Info einsch�tzen
//---------------------------------------------------------------------
INSTANCE DIA_Sonja_ein   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 900;
	condition   = DIA_Sonja_ein_Condition;
	information = DIA_Sonja_ein_Info;
	permanent   = TRUE;
	description = "Kannst du meine F�higkeit im Goldhacken einsch�tzen?";
};

FUNC INT DIA_Sonja_ein_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ein_Info()
{
	AI_Output (other, self, "DIA_Addon_Finn_ein_15_00");//Kannst du meine F�higkeit im Goldhacken einsch�tzen?

	AI_Output (self, other, "DIA_Sonja_ein_16_01");//Bei dir w�rde ich sagen, du bist ein ...

	if (Hero_HackChance < 20)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_02"); //blutiger Anf�nger.
	}
	else if (Hero_HackChance < 40)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_03"); //ganz passabler Sch�rfer.
	}
	else if (Hero_HackChance < 55)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_04"); //erfahrener Goldsch�rfer.
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
};

//---------------------------------------------------------------------
//	Info AUFREISSER
//---------------------------------------------------------------------
INSTANCE DIA_Sonja_AUFREISSER   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 900;
	condition   = DIA_Sonja_AUFREISSER_Condition;
	information = DIA_Sonja_AUFREISSER_Info;
	permanent   = TRUE;
	description = "Kannst du meine F�higkeit als Aufrei�er einsch�tzen?";
};

FUNC INT DIA_Sonja_AUFREISSER_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_AUFREISSER_Info()
{
	AI_Output (other, self, "DIA_Sonja_AUFREISSER_15_00");//Kannst du meine F�higkeit im Goldhacken einsch�tzen?

	AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_00");//Bei dir w�rde ich sagen, du bist ein ...

	if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 20)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_01"); //blutiger Anf�nger.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 40)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_02"); //ganz passabler Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 55)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_02"); //erfahrener Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 75)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_03"); //wachechter Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 90)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_04"); //verdammt guter Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER) < 98)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_03"); //Meister-Aufrei�er.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_04"); //Guru - unter den Aufrei�ern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Aufrei�er: ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_AUFREISSER)));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);
};

//*******************************************
//	TeachPlayer
//*******************************************

INSTANCE DIA_Sonja_TEACHAUFREISSER(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 99;
	condition	= DIA_Sonja_TEACHAUFREISSER_Condition;
	information	= DIA_Sonja_TEACHAUFREISSER_Info;
	permanent	= TRUE;
	description = "Zeig mir, wie ich Frauen besser aufrei�en kann.";
};

FUNC INT DIA_Sonja_TEACHAUFREISSER_Condition()
{
	return SonjaFolgt == TRUE;
};

func int B_TeachAufreisserTalentPercent (var C_NPC slf, var C_NPC oth, var int percent, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	//kosten = (B_GetLearnCostTalent(oth, NPC_TALENT_AUFREISSER, 1) * percent);
	kosten = percent; // 1 LP pro Aufreisser %

	//EXIT IF...

	// ------ Lernen NICHT �ber teacherMax ------
	var int realHitChance;
	realHitChance = Npc_GetTalentSkill(oth, NPC_TALENT_AUFREISSER);

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
    Npc_SetTalentSkill (oth, NPC_TALENT_AUFREISSER, percent);	//Aufreisser

    PrintScreen	("Verbessere: Aufrei�en", -1, -1, FONT_Screen, 2);

    return TRUE;
};


func void SonjaTeach()
{
    Info_ClearChoices (DIA_Sonja_TEACHAUFREISSER);
    Info_AddChoice		(DIA_Sonja_TEACHAUFREISSER, B_BuildLearnString("Aufrei�en +1"			, 1)			,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1);
    Info_AddChoice		(DIA_Sonja_TEACHAUFREISSER, B_BuildLearnString("Aufrei�en +5"			, 5)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5);
    Info_AddChoice		(DIA_Sonja_TEACHAUFREISSER, DIALOG_BACK, DIA_Sonja_TEACHAUFREISSER_Back);
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Info()
{
	AI_Output (other,self ,"DIA_Sonja_AUFREISSER_15_00"); //Zeig mir, wie ich Frauen besser aufrei�en kann.
    AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_00"); //Ach du, als ob du jemals eine andere Frau beeindrucken wirst. Na gut, wir probieren es trotzdem.

    SonjaTeach();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Back ()
{
	Info_ClearChoices (DIA_Sonja_TEACHAUFREISSER);
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1 ()
{
	B_TeachAufreisserTalentPercent (self, other, 1, T_MAX);

	SonjaTeach();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5 ()
{
	B_TeachAufreisserTalentPercent (self, other, 5, T_MAX);

	SonjaTeach();
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
	description = "(T�tigkeit)";
};

FUNC INT DIA_Sonja_ROUTINE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ROUTINE_Info()
{
	Info_ClearChoices	(DIA_Sonja_ROUTINE);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Xardas"	,    DIA_Sonja_ROUTINE_Xardas);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Vatras"	,    DIA_Sonja_ROUTINE_Vatras);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Pyrokar"	,    DIA_Sonja_ROUTINE_Pyrokar);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Tanzen"	,    DIA_Sonja_ROUTINE_Dance);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "F�r kleine M�dchen"	,    DIA_Sonja_ROUTINE_Pee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, DIALOG_BACK 		, DIA_Sonja_ROUTINE_BACK);
};

func void DIA_Sonja_ROUTINE_BACK()
{
	Info_ClearChoices (DIA_Sonja_ROUTINE);
};

func void DIA_Sonja_ROUTINE_Pee ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_00"); //Geh mal f�r kleine M�dchen!
	Npc_ExchangeRoutine	(self,"PEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Dance ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_01"); //Tanz!
	Npc_ExchangeRoutine	(self,"DANCE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Vatras()
{
    self.aivar[AIV_PARTYMEMBER] = FALSE;
    AI_StopProcessInfos (self);
    // Der Dialog wird sonst nicht geschlossen:
    AI_Wait(self, 10);
    AI_GotoNpc(self, Vatras);
};

func void DIA_Sonja_ROUTINE_Pyrokar()
{
    self.aivar[AIV_PARTYMEMBER] = FALSE;
    AI_StopProcessInfos (self);
    // Der Dialog wird sonst nicht geschlossen:
    AI_Wait(self, 10);
    AI_GotoNpc(self, Pyrokar);
};

func void DIA_Sonja_ROUTINE_Xardas()
{
    self.aivar[AIV_PARTYMEMBER] = FALSE;
    AI_StopProcessInfos (self);
    // Der Dialog wird sonst nicht geschlossen:
    AI_Wait(self, 10);
    AI_GotoNpc(self, Xardas);
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

FUNC VOID DIA_Sonja_AUSSEHEN_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "B�rgerin"	,    DIA_Sonja_AUSSEHEN_Citizen);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "B�uerin"	,    DIA_Sonja_AUSSEHEN_Farmer);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Vanja"	,    DIA_Sonja_AUSSEHEN_Vanja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Lucia"	,    DIA_Sonja_AUSSEHEN_Lucia);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Nadja"	,    DIA_Sonja_AUSSEHEN_Nadja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Dick"	,    DIA_Sonja_AUSSEHEN_Fat);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "D�nn"	,    DIA_Sonja_AUSSEHEN_Thin);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Anziehen"	,    DIA_Sonja_AUSSEHEN_Clothing);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Ausziehen"	,    DIA_Sonja_AUSSEHEN_Nude);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Normal"	,    DIA_Sonja_AUSSEHEN_Normal);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_BACK);
};

func void DIA_Sonja_AUSSEHEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_AUSSEHEN);
};


func void DIA_Sonja_AUSSEHEN_Nude ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_00"); //Zieh dich aus!

    AI_UnequipArmor (self);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Clothing ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_01"); //Zieh dir was an!

    AI_EquipBestArmor (self);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Fat ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_02"); //Iss etwas!

    Mdl_SetModelFatness (self, 4);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Thin ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_03"); //Mach ein bisschen Sport!

    Mdl_SetModelFatness (self, 0);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Normal()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe6", FaceBabe_L_Charlotte2, BodyTexBabe_L, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Nadja()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_Hure, BodyTex_N, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Lucia()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_GreyCloth, BodyTexBabe_F, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Vanja()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe", FaceBabe_B_RedLocks, BodyTexBabe_B, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Farmer()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe4", FaceBabe_N_VlkBlonde, BodyTexBabe_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Citizen()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_BabeHair", FaceBabe_N_HairAndCloth, BodyTex_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Info();
};

// ************************************************************
// 			KOPF
// ************************************************************

INSTANCE DIA_Sonja_Choose_HeadMesh (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 901;
	condition		= DIA_Sonja_Choose_HeadMesh_Condition;
	information		= DIA_Sonja_Choose_HeadMesh_Info;
	permanent		= 1;
	description		= "(Sch�nheits-Operation f�r Kopf)";
};

FUNC INT DIA_Sonja_Choose_HeadMesh_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_Choose_HeadMesh_Info()
{
	Info_ClearChoices	(DIA_Sonja_Choose_HeadMesh);

	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_BabeHair", DIA_Sonja_Choose_HeadMesh_17);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe8" 	, DIA_Sonja_Choose_HeadMesh_16);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe7" 	, DIA_Sonja_Choose_HeadMesh_15);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe6" 	, DIA_Sonja_Choose_HeadMesh_14);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe5" 	, DIA_Sonja_Choose_HeadMesh_13);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe4" 	, DIA_Sonja_Choose_HeadMesh_12);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe3" 	, DIA_Sonja_Choose_HeadMesh_11);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe2" 	, DIA_Sonja_Choose_HeadMesh_10);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe1" 	, DIA_Sonja_Choose_HeadMesh_9);
	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, "Hum_Head_Babe" 	, DIA_Sonja_Choose_HeadMesh_8);

	Info_AddChoice		(DIA_Sonja_Choose_HeadMesh, DIALOG_BACK 				, DIA_Sonja_Choose_HeadMesh_BACK);
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
	Info_ClearChoices	(DIA_Sonja_Choose_HeadMesh);
};

// ************************************************************
// 			HAUTFARBE
// ************************************************************

INSTANCE DIA_Sonja_Choose_BodyTex (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 901;
	condition		= DIA_Sonja_Choose_BodyTex_Condition;
	information		= DIA_Sonja_Choose_BodyTex_Info;
	permanent		= 1;
	description		= "(Sch�nheits-Operation f�r Haut)";
};

FUNC INT DIA_Sonja_Choose_BodyTex_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_Choose_BodyTex_Info()
{
	Info_ClearChoices	(DIA_Sonja_Choose_BodyTex);

	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, "BodyTex_B" 	, DIA_Sonja_Choose_BodyTex_B);
	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, "BodyTexBabe_P" 	, DIA_Sonja_Choose_BodyTexBabe_P);
	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, "BodyTexBabe_N" 	, DIA_Sonja_Choose_BodyTexBabe_N);
	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, "BodyTexBabe_L" 	, DIA_Sonja_Choose_BodyTexBabe_L);
	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, "BodyTexBabe_B" 	, DIA_Sonja_Choose_BodyTexBabe_B);

	Info_AddChoice		(DIA_Sonja_Choose_BodyTex, DIALOG_BACK 				, DIA_Sonja_Choose_BodyTex_BACK);
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
func void DIA_Sonja_Choose_BodyTex_B()
{
	Sonja_BodyTexture 	=BodyTex_B;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};

// ------------------------------------------------

func void DIA_Sonja_Choose_BodyTex_BACK()
{
	Info_ClearChoices	(DIA_Sonja_Choose_BodyTex);
};

// ************************************************************
// 			GESICHT
// ************************************************************

INSTANCE DIA_Sonja_Choose_Face (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 902;
	condition		= DIA_Sonja_Choose_Face_Condition;
	information		= DIA_Sonja_Choose_Face_Info;
	permanent		= TRUE;
	description		= "(Sch�nheits-Operation f�r Gesicht)";
};

FUNC INT DIA_Sonja_Choose_Face_Condition()
{
	return SonjaFolgt == TRUE;
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

	Info_ClearChoices	(DIA_Sonja_Choose_Face);

	Info_AddChoice		(DIA_Sonja_Choose_Face, "FaceBabe_L_Charlotte" 	, DIA_Sonja_Choose_FaceBabe_L_Charlotte);
	Info_AddChoice		(DIA_Sonja_Choose_Face, "FaceBabe_N_PinkHair" 	, DIA_Sonja_Choose_FaceBabe_N_PinkHair);
	Info_AddChoice		(DIA_Sonja_Choose_Face, "FaceBabe_N_BlondTattoo" 	, DIA_Sonja_Choose_FaceBabe_N_BlondTattoo);
	Info_AddChoice		(DIA_Sonja_Choose_Face, "FaceBabe_N_Blondie" 	, DIA_Sonja_Choose_FaceBabe_N_Blondie);
	Info_AddChoice		(DIA_Sonja_Choose_Face, "FaceBabe_N_BlackHair" 	, DIA_Sonja_Choose_FaceBabe_N_BlackHair);

	Info_AddChoice		(DIA_Sonja_Choose_Face, DIALOG_BACK 				, DIA_Sonja_Choose_Face_BACK);
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
	Info_ClearChoices	(DIA_Sonja_Choose_HeadMesh);
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

// ------------------------------------------------

func void DIA_Sonja_Choose_Face_BACK()
{
	Info_ClearChoices	(DIA_Sonja_Choose_Face);
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
	description = "(Bekleidung und Ausr�stung)";
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
    msg = ConcatStrings(msg, ")");
    msg = ConcatStrings(itemName, msg);

    return msg;
};

FUNC VOID DIA_Sonja_KLEIDUNG_Info()
{
	Info_ClearChoices	(DIA_Sonja_KLEIDUNG);

	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_MassDeath, Value_Ru_MassDeath),   DIA_Sonja_KLEIDUNG_ItRu_MassDeath);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_InstantFireball, Value_Ru_InstantFireball),   DIA_Sonja_KLEIDUNG_ItRu_InstantFireball);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbesiegbarkeit", Value_Ri_ProtTotal02),   DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_02);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbezwingbarkeit", Value_Ri_ProtTotal),    DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_01);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("R�stung Drachenj�gerin", 2000)	,    DIA_Sonja_KLEIDUNG_DragonSlayer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kleidung B�uerin", 200)	,    DIA_Sonja_KLEIDUNG_Farmer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwerer Ast", 1),    DIA_Sonja_KLEIDUNG_Schwerer_Ast);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bester G�rtel aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestBelt);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Ringe aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestRings);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bestes Amulett aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestAmulet);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Spruchrolle aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestScroll);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Rune aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestRune);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Fernkampfwaffe aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestRangeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Nahkampfwaffe aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestMeleeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste R�stung aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestArmor);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Lege alle Ausr�stung ab"	,    DIA_Sonja_KLEIDUNG_Unequip);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Normal"	,    DIA_Sonja_KLEIDUNG_Normal);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, DIALOG_BACK 		, DIA_Sonja_KLEIDUNG_BACK);
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
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Ausr�stung f�r sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_01"); //Hier ist neue Ausr�stung!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            B_GiveInvItems (other, self, armor, 1);
            EquipItem(self, armor);
            B_LogEntry ("Sonja", "Sonja freut sich �ber neue Ausr�stung.");
        };
    };
};

func void Sonja_Bekleiden(var int armor, var int cost)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_02"); //Zieh das hier an!
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_00"); //Wie du magst!

        AI_UnequipArmor	(self);
        AI_EquipArmor 	(self, armor);
        //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_KLEIDUNG_16_01"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Kleidung f�r sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_03"); //Hier ist etwas Neues zum Anziehen!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            CreateInvItems (self, armor, 1);
            AI_UnequipArmor	(self);
            AI_EquipArmor 	(self, armor);
            //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
            B_LogEntry ("Sonja", "Sonja freut sich �ber neue Kleidung.");
        };
    };
};

func void DIA_Sonja_KLEIDUNG_Normal ()
{
    Sonja_Bekleiden(ITAR_VlkBabe_H, 0);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Unequip ()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_04"); //Lege alles ab!
    AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_03"); //Wie du meinst, S��er.

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

    if (Npc_HasItems(self, ItRu_InstantFireball))
    {
        EquipItem(self, ItRu_InstantFireball);
    };

    if (Npc_HasItems(self, ItRu_MassDeath))
    {
        EquipItem(self, ItRu_MassDeath);
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestScroll()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege deine beste Spruchrolle an!

    if (Npc_HasItems(self, ItSc_Firebolt))
    {
        EquipItem(self, ItSc_Firebolt);
    };

    if (Npc_HasItems(self, ItSc_InstantFireball))
    {
        EquipItem(self, ItSc_InstantFireball);
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestAmulet()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege dein bestes Amulett an!

    if (Npc_HasItems(self, ItAm_Hp_Mana_01))
    {
        EquipItem(self, ItAm_Hp_Mana_01);
    };

    if (Npc_HasItems(self, ItAm_Prot_Point_01))
    {
        EquipItem(self, ItAm_Prot_Point_01);
    };

    if (Npc_HasItems(self, ItAm_Hp_01))
    {
        EquipItem(self, ItAm_Hp_01);
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRings()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_06"); //Lege deine besten Ringe an!

    if (Npc_HasItems(self, ItRi_Prot_Edge_01))
    {
        EquipItem(self, ItRi_Prot_Edge_01);
        EquipItem(self, ItRi_Prot_Edge_01);
    };

    if (Npc_HasItems(self, ItRi_Prot_Total_01))
    {
        EquipItem(self, ItRi_Prot_Total_01);
        EquipItem(self, ItRi_Prot_Total_01);
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestBelt()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_07"); //Zieh deinen besten G�rtel an!

    if (Npc_HasItems(self, ItBE_Addon_Leather_01))
    {
        EquipItem(self, ItBE_Addon_Leather_01);
    };

    if (Npc_HasItems(self, ItBE_Addon_MC))
    {
        EquipItem(self, ItBE_Addon_MC);
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Schwerer_Ast()
{
    Sonja_Equip(ItMw_1h_Bau_Mace, Value_BauMace);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Farmer ()
{
    Sonja_Bekleiden(ITAR_BauBabe_M, 200);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_DragonSlayer ()
{
    Sonja_Bekleiden(ITAR_DJG_BABE, 2000);

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
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_03"); //Ich muss erst den zweiten Kreis der Magie erlernen.
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
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich muss erst den sechsten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
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

// ************************************************************
// 			  				RESPAWN
// ************************************************************
INSTANCE DIA_Sonja_RESPAWN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_RESPAWN_Condition;
	information	= DIA_Sonja_RESPAWN_Info;
	permanent	= TRUE;
	description = "Rufe alle wilden Tiere herbei ...";
};

FUNC INT DIA_Sonja_RESPAWN_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_RESPAWN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei ...

    Info_ClearChoices	(DIA_Sonja_RESPAWN);

    Info_AddChoice		(DIA_Sonja_RESPAWN, "Alle Schattenl�ufer in Khorinis"	,Sonja_RESPAWN_ShadowBeastsKhorinis);
    Info_AddChoice		(DIA_Sonja_RESPAWN, "Alle Trolle in Khorinis"	,Sonja_RESPAWN_TrolleKhorinis);
	Info_AddChoice		(DIA_Sonja_RESPAWN, "Alle Tiere in Khorinis"	,Sonja_RESPAWN_Khorinis);
	Info_AddChoice		(DIA_Sonja_RESPAWN, DIALOG_BACK 		, DIA_Sonja_RESPAWN_BACK);
};

func void DIA_Sonja_RESPAWN_BACK()
{
	Info_ClearChoices (DIA_Sonja_RESPAWN);
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

    DIA_Sonja_RESPAWN_Info();
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

    DIA_Sonja_RESPAWN_Info();
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

    DIA_Sonja_RESPAWN_Info();
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

// ************************************************************
// 			  				RESPAWN ITEMS
// ************************************************************
INSTANCE DIA_Sonja_RESPAWN_ITEMS (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_RESPAWN_ITEMS_Condition;
	information	= DIA_Sonja_RESPAWN_ITEMS_Info;
	permanent	= TRUE;
	description = "Sammle Gegenst�nde f�r mich ...";
};

FUNC INT DIA_Sonja_RESPAWN_ITEMS_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Choices()
{
    Info_ClearChoices	(DIA_Sonja_RESPAWN_ITEMS);

	Info_AddChoice		(DIA_Sonja_RESPAWN_ITEMS, "Sammle Kr�uter f�r mich."	,Sonja_RESPAWN_ITEMS_Herb);
	Info_AddChoice		(DIA_Sonja_RESPAWN_ITEMS, DIALOG_BACK 		, DIA_Sonja_RESPAWN_ITEMS_BACK);
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_15_00"); //Sammle Gegenst�nde f�r mich ...
    DIA_Sonja_RESPAWN_ITEMS_Choices();
};

func void DIA_Sonja_RESPAWN_ITEMS_BACK()
{
	Info_ClearChoices (DIA_Sonja_RESPAWN_ITEMS);
};

FUNC VOID Sonja_RESPAWN_ITEMS_Herb()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_Herb_15_00"); //Sammle Kr�uter f�r mich.

    if (Wld_GetDay() - SonjaRespawnItemsDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche Gegenst�nde f�r mich sammeln.");

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
            AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_00"); //Ich koche nur jede Woche etwas f�r dich! Komm in ein paar Tagen wieder!
            B_LogEntry ("Sonja", "Sonja kocht f�r mich nur einmal in der Woche.");

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
// 			  				IMMORTAL
// ************************************************************
INSTANCE DIA_Sonja_IMMORTAL (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_IMMORTAL_Condition;
	information	= DIA_Sonja_IMMORTAL_Info;
	permanent	= TRUE;
	description = "Werde unsterblich!";
};

FUNC INT DIA_Sonja_IMMORTAL_Condition()
{
	return SonjaFolgt == TRUE && self.flags != NPC_FLAG_IMMORTAL && self.aivar[AIV_PARTYMEMBER] == FALSE;
};

FUNC VOID DIA_Sonja_IMMORTAL_Info()
{
    AI_Output			(other, self, "DIA_Sonja_IMMORTAL_15_00"); //Werde unsterblich!
    AI_Output			(self, other, "DIA_Sonja_IMMORTAL_16_00"); //Aber sicher mein Prinz. Eine Prinzessin kann niemals sterben, sie wird immer gerettet.

    B_LogEntry ("Sonja", "Solange Sonja mir nicht folgt kann sie sich vor Feinden selbst sch�tzen.");
};

// ************************************************************
// 			  				MORTAL
// ************************************************************
INSTANCE DIA_Sonja_MORTAL (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_MORTAL_Condition;
	information	= DIA_Sonja_MORTAL_Info;
	permanent	= TRUE;
	description = "Werde unsterblich!";
};

FUNC INT DIA_Sonja_MORTAL_Condition()
{
	return SonjaFolgt == TRUE && self.flags == NPC_FLAG_IMMORTAL;
};

FUNC VOID DIA_Sonja_MORTAL_Info()
{
    AI_Output			(other, self, "DIA_Sonja_MORTAL_15_00"); //Werde sterblich!
    AI_Output			(self, other, "DIA_Sonja_MORTAL_16_00"); //Wie du meinst, mein Prinz. Du wirst mich schon besch�tzen.
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
        AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_01"); //Ja mein Prinz, du bist der Beste! Aus dir kann noch ein K�nig werden!
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
	description = "Ich m�chte die Scheidung.";
};

FUNC INT DIA_Sonja_SCHEIDUNG_Condition()
{
	return SonjaFolgt == TRUE && SonjaGeheiratet == TRUE;
};

FUNC VOID DIA_Sonja_SCHEIDUNG_Info()
{
    AI_Output			(other, self, "DIA_Sonja_SCHEIDUNG_15_00"); //Ich m�chte die Scheidung.

     AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_00"); //Ber�hrt - gef�hrt! �berleg dir lieber mal deinen n�chsten Schachzug, damit wir zu mehr Gold kommen!
    B_LogEntry ("Sonja", "F�r Sonja kommt eine Scheidung nicht in Frage. Ich soll lieber mehr Gold verdienen.");
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
	description = "Was soll ich als N�chstes tun?";
};

FUNC INT DIA_Sonja_ADVICE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ADVICE_Info()
{
    AI_Output			(other, self, "DIA_Sonja_ADVICE_15_00"); //Was soll ich als N�chstes tun?

    if (Kapitel == 1)
    {
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_03"); //Geh zu Lord Hagen und hol dir das Auge Innos.
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
    else if (Kapitel == 2)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_04"); //Geh ins Minental und hole dir alle Informationen f�r Lord Hagen.
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 3)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_05"); //K�mmere dich um das Auge Innos.
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
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_00"); //Ich wei� es nicht.
        B_LogEntry ("Sonja", "Sonja wei� auch nicht, was ich tun soll.");
	};
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
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum n�chsten Abend schlafen"	,Sonja_SleepTime_Evening_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis Mittags schlafen"	,Sonja_SleepTime_Noon_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum n�chsten Morgen schlafen"	,Sonja_SleepTime_Morning_Info);
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
	AI_StopProcessInfos (self);
};

//--------------------- mittags -----------------------------------------

func void Sonja_SleepTime_Noon_Info ()
{
	PC_Sleep (12);
	AI_StopProcessInfos (self);
};

//---------------------- abend --------------------------------------

func void Sonja_SleepTime_Evening_Info ()
{
	PC_Sleep (20);
	AI_StopProcessInfos (self);
};

//------------------------ nacht -----------------------------------------

func VOID Sonja_SleepTime_Midnight_Info()
{
	PC_Sleep (0);
	AI_StopProcessInfos (self);
};








