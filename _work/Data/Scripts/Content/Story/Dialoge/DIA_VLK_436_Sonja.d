var int SonjaFolgt;							//= TRUE Sonja folgt.
var int SonjaGeheiratet;					//= TRUE Sonja geheiratet.
var int SonjaGefragt;						//= TRUE Sonja nach Freikaufen gefragt.
var int SonjaSummonDays;
var int SonjaProfitDays;
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
    Npc_ExchangeRoutine	(self,"FOLLOW");
    self.aivar[AIV_PARTYMEMBER] = TRUE;
};

func void DIA_Sonja_BEZAHLEN_DoIt()
{
	if (Npc_HasItems (other, ItMi_Gold) < 1000)
	{
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_03"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
	}
	else
	{
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_04"); //1000 Goldstücke! Wahnsinn! Endlich mal ein reicher Mann im Hafen, der weiß wie man eine Dame behandelt.
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_05"); //Lass uns abhauen!
        B_LogEntry ("Sonja", "Sonja folgt mir nun und arbeitet für mich.");
        SonjaFolgt = TRUE;
        SonjaSummonDays = 0;
        SonjaProfitDays = 0;
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
    AI_Output (other, self, "Ich möchte dich freikaufen!"); //Ich möchte dich freikaufen!
    AI_Output (self, other, "DIA_Sonja_STANDARD_16_06"); //Oh Romeo, willst du das wirklich tun? Hast du denn überhaupt genug Gold, um eine Frau wie mich zu versorgen?
    AI_Output (other, self, "Du könntest weiterhin für mich arbeiten."); //Du könntest weiterhin für mich arbeiten.
    AI_Output (self, other, "DIA_Sonja_STANDARD_16_07"); //Sagen wir so: Wenn du mir eine Menge Gold gibst und mehr übrig lässt als Bromor, dann verlasse ich gerne die Rote Laterne.
    B_LogEntry ("Sonja", "Sonja, die Freudendame in der Roten Laterne, schließt sich mir an und arbeitet für mich, wenn ich ihr 1000 Goldstücke gebe.");
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
	description  =  "Was hältst du von ...";
	nr		 	= 99;
};

func int DIA_Sonja_PEOPLE_Condition ()
{
	return SonjaFolgt;
};

func void DIA_Sonja_PEOPLE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
	Info_AddChoice		(DIA_Sonja_PEOPLE, DIALOG_BACK 		,                 DIA_Sonja_PEOPLE_BACK);
	Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Nadja?"	,     DIA_Sonja_PEOPLE_Nadja);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was hältst du von Bromor?"	,     DIA_Sonja_PEOPLE_Bromor);
};

func void DIA_Sonja_PEOPLE_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
};

func void DIA_Sonja_PEOPLE_Nadja ()
{
    AI_Output (other, self, "Was hältst du von Nadja?"); //Was hältst du von Nadja?
    AI_Output (self, other, "DIA_Sonja_STANDARD_16_08"); //Nadja? Ach so eine graue Maus. Die kann doch gar nichts! Hübsch ist sie, zugegeben, aber Erfahrung hat sei kaum und Schönheit vergeht.
    B_LogEntry ("Sonja", "Sonja hält Nadja für eine graue Maus.");

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_09"); //Du findest sie doch nicht etwa hübscher als mich? Ich warne dich, schau sie bloß nicht an!
        B_LogEntry ("Sonja", "Sonja ist eifersüchtig auf Nadja.");
    };

    DIA_Sonja_PEOPLE_Info();
};


func void DIA_Sonja_PEOPLE_Bromor ()
{
    AI_Output (other, self, "Was hältst du von Bromor?");
    AI_Output (self, other, "DIA_Sonja_STANDARD_16_10"); //Bromor ist ein mieser Halsabschneider. Er nimmt den meisten Ertrag der Frauen für sich.

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_11"); //Aber was soll's? Meinen Prinzen habe ich ja jetzt gefunden!
    };

    B_LogEntry ("Sonja", "Sonja hält Bromor für einen miesen Halsabschneider.");

    DIA_Sonja_PEOPLE_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info XP
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_XP		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_XP_Condition;
	information	 = 	DIA_Sonja_XP_Info;
	permanent	 = 	TRUE;
	description  =  "Wie erfahren bist du?";
	nr		 	= 3;
};

func int DIA_Sonja_XP_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_XP_Info ()
{
    AI_Output (other, self, "Wie erfahren bist du?"); //Wie erfahren bist du?

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
};

///////////////////////////////////////////////////////////////////////
//	Info STATS
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_STATS		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_STATS_Condition;
	information	 = 	DIA_Sonja_STATS_Info;
	permanent	 = 	TRUE;
	description  =  "Wie stark bist du?";
	nr		 	= 4;
};

func int DIA_Sonja_STATS_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_STATS_Info ()
{
    AI_Output (other, self, "Wie stark bist du?"); //Wie stark bist du?

    var String levelText;
    var String hpText;
    var String manaText;
    var String lpText;
    var String strText;
    var String dexText;
    var String msg;

    levelText = ConcatStrings("Stufe: ", IntToString(self.level));
    lpText = ConcatStrings(" Lernpunkte: ", IntToString(self.lp));
    hpText = ConcatStrings(" Leben: ", IntToString(self.attribute[ATR_HITPOINTS_MAX]));
    manaText = ConcatStrings(" Mana: ", IntToString(self.attribute[ATR_MANA_MAX]));
    strText = ConcatStrings(" Stärke: ", IntToString(self.attribute[ATR_STRENGTH]));
    dexText = ConcatStrings(" Geschick: ", IntToString(self.attribute[ATR_DEXTERITY]));
    msg = "";
    msg = ConcatStrings(msg, levelText);
    msg = ConcatStrings(msg, lpText);
    msg = ConcatStrings(msg, hpText);
    msg = ConcatStrings(msg, manaText);
    msg = ConcatStrings(msg, strText);
    msg = ConcatStrings(msg, dexText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);
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
    AI_Output (self ,other, "DIA_Sonja_STANDARD_16_12"); //Ich folge dir mein Prinz!
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
	AI_Output (self ,other, "Wie du meinst, mein Süßer!"); //Wie du meinst, mein Süßer!

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
	AI_Output (other, self, "DIA_Sonja_GoHome_15_00"); //Ich brauch dich nicht mehr.
	AI_Output (self, other, "DIA_Sonja_STANDARD_16_13"); // Suche mich bald mein Prinz, ich warte auf dich!

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

    AI_Output			(self, other, "Klar. Schaden kann's nicht."); //Klar. Schaden kann's nicht.

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
	AI_Output			(self, other, "Ich schätze, ich muss warten, bis du einen übrig hast."); //Ich schätze, ich muss warten, bis du einen übrig hast.
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
	AI_Output			(self, other, "Im Moment hast du leider keinen. Ich komm später noch mal darauf zurück."); //Im Moment hast du leider keinen. Ich komm später noch mal darauf zurück.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_spaeter ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_spaeter_15_00"); //Ich werde dir später etwas geben.
	AI_Output			(self ,other, "Vergiss es aber nicht."); //Vergiss es aber nicht.

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
	AI_Output			(other, self, "Lass es uns tun!");

	if hero.attribute [ATR_HITPOINTS] < hero.attribute[ATR_HITPOINTS_MAX] || hero.attribute [ATR_MANA] < hero.attribute[ATR_MANA_MAX]
	{
		AI_Output			(self, other, "DIA_Sonja_STANDARD_16_14"); //Endlich erobert mein Prinz sein Schloss zurück!
		PlayVideo ("LOVESCENE.BIK");
		hero.attribute [ATR_HITPOINTS] = hero.attribute[ATR_HITPOINTS_MAX];
		hero.attribute [ATR_MANA] = hero.attribute[ATR_MANA_MAX];
		PrintScreen (PRINT_FullyHealed, - 1, - 1, FONT_Screen, 2);
		B_LogEntry ("Sonja", "Sonja hat gewisse Talente, die mich heilen und mein Mana regenerieren.");
	}
	else
	{
		AI_Output			(self, other,  "DIA_Sonja_STANDARD_16_15"); //Ich habe Migräne.
		B_LogEntry ("Sonja", "Sonja hat komischerweise öfter mal Migräne.");
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
	AI_Output			(other, self, "Wie fühlst du dich?"); //Wie fühlst du dich?

    if (Wld_IsRaining())
    {
        AI_Output			(self, other, "DIA_Sonja_STANDARD_16_16"); //Ach, das Wetter ist beschissen!
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_STANDARD_16_17"); //Das Wetter ist heute schön!
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
	AI_Output			(other, self, "DIA_Sonja_WAREZ_15_00"); //Zeig mir deine Ware.
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
	AI_Output			(other, self, "Möchtest du meine Frau werden?"); //Möchtest du meine Frau werden?
	AI_Output			(other, self, "DIA_Sonja_STANDARD_16_16"); //Hmmm, hast du mir denn wirklich genug zu bieten? Wie sieht es mit Schmuck aus? Was ist mit schöner Kleidung? Die kostet Geld. Wo sollen wir wohnen, mein Prinz?
	AI_Output			(other, self, "Ich sorge für alles."); //Ich sorge für alles.
	AI_Output			(other, self, "DIA_Sonja_STANDARD_16_17"); //Ich glaube an dich. Gib mir noch einmal 1000 Goldstücke und etwas Schmuck und wir können heiraten.

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
	AI_Output			(other, self, "Möchtest du meine Frau werden?"); //Möchtest du meine Frau werden?

	if (Npc_HasItems (other, ItMi_Gold) < 1000 || Npc_HasItems(other, ItMi_GoldRing) <= 0 || Npc_HasItems(other, ItMi_GoldChest) <= 0)
	{
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_03"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
	}
	else
	{
        AI_Output (self, other, "DIA_Sonja_STANDARD_16_04"); //Oh, mein Prinz, ich gebe dir das Ja-Wort. Wir sind nun Frau und Mann. Schnell gib, mir die Waren, damit ich sie für uns aufbewaren kann.
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        B_GiveInvItems (other, self, ItMi_GoldRing, 1);
        B_LogEntry ("Sonja", "Sonja und ich haben geheiratet. Wir sind nun Frau und Mann!");
        SonjaGeheiratet = TRUE;
	};
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
	AI_Output			(other, self, "Kannst du ein paar andere Frauen besorgen?"); //Kannst du ein paar Krieger beschwören?

	if (Wld_GetDay() - SonjaSummonDays >= 3)
	{
        AI_Output			(other, self, "DIA_Sonja_STANDARD_16_18"); //Ich kenne ein Bäurin, die Interesse haben könnte. Aber nur damit du mit ihr mehr Gold verdienen kannst, verstanden?
        Wld_SpawnNpcRange	(self,	BAU_915_Baeuerin,	1,	500);
        SonjaSummonDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(other, self, "DIA_Sonja_STANDARD_16_18"); //Komm in ein paar Tagen noch mal zu mir. Alle drei Tage kann ich dir eine Frau beschaffen.
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
	AI_Output			(other, self, "Warst du auch fleißig anschaffen?"); //Warst du auch fleißig anschaffen?
	AI_Output			(other, self, "DIA_Sonja_STANDARD_16_18"); //Mein Tor ist für jeden zahlenden geöffnet.

	if (Wld_GetDay() - SonjaProfitDays >= 5)
	{
        AI_Output			(other, self, "DIA_Sonja_STANDARD_16_18"); //Hier mein Prinz. 50 Goldstücke pro Kunde und du bekommst deine Hälfte!
        B_GiveInvItems (self, other, ItMi_Gold, (Wld_GetDay() - SonjaProfitDays) * 25); // 1 Kunde pro Tag
        SonjaProfitDays = Wld_GetDay();
	}
	else
	{
        AI_Output			(other, self, "DIA_Sonja_STANDARD_16_18"); //Komm in ein paar Tagen noch mal zu mir. Alle fünf Tage kann ich dir dein Gold geben.
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

FUNC VOID DIA_Sonja_TRAINING_Info()
{
    AI_Output			(other, self, "Lass mich dich trainieren!"); //Lass mich dich trainieren!
    B_LogEntry ("Sonja", "Ich kann Sonja mit ihrer eigenen gesammelten Erfahrung trainieren.");

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
	Info_AddChoice		(DIA_Sonja_TRAINING, "Stärke"	,    DIA_Sonja_TRAINING_STR);
	Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK 		, DIA_Sonja_TRAINING_BACK);
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
	DIA_Sonja_TRAINING_Info();
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
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_TWO_HAND ()
{
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_BOW ()
{
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_CROSSBOW ()
{
	DIA_Sonja_TRAINING_Info();
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
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_ALCHEMY ()
{
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_MORE ()
{
	DIA_Sonja_TRAINING_Info();
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
	description = "Kannst du meine Fähigkeit im Goldhacken einschätzen?";
};
FUNC INT DIA_Sonja_ein_Condition()
{
	return SonjaFolgt == TRUE;
};
var int Sonja_einmal;
var int Sonja_Gratulation;
FUNC VOID DIA_Sonja_ein_Info()
{
	AI_Output (other, self, "DIA_Addon_Finn_ein_15_00");//Kannst du meine Fähigkeit im Goldhacken einschätzen?

	if (Sonja_einmal == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_01");//Klar. Ich mache das schon seit über 35 Jahren. Es gibt nichts, das ich nicht erkenne!
		Sonja_einmal = TRUE;
	};
	AI_Output (self, other, "DIA_Sonja_ein_07_02");//Bei dir würde ich sagen, du bist ein ...

	if (Hero_HackChance < 20)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_03"); //blutiger Anfänger.
	}
	else if (Hero_HackChance < 40)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_04"); //ganz passabler Schürfer.
	}
	else if (Hero_HackChance < 55)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_05"); //erfahrener Goldschürfer.
	}
	else if (Hero_HackChance < 75)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_06"); //wachechter Buddler.
	}
	else if (Hero_HackChance < 90)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_07"); //verdammt guter Buddler.
	}
	else if (Hero_HackChance < 98)
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_08"); //Meister Buddler.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_ein_07_09"); //Guru - unter den Buddlern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Goldhacken: ", IntToString (Hero_HackChance));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);
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
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Xardas"	,    DIA_Sonja_ROUTINE_Xardas);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Vatras"	,    DIA_Sonja_ROUTINE_Vatras);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Pyrokar"	,    DIA_Sonja_ROUTINE_Pyrokar);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Tanzen"	,    DIA_Sonja_ROUTINE_Dance);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Für kleine Mädchen"	,    DIA_Sonja_ROUTINE_Pee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, DIALOG_BACK 		, DIA_Sonja_ROUTINE_BACK);
};

func void DIA_Sonja_ROUTINE_BACK()
{
	Info_ClearChoices (DIA_Sonja_ROUTINE);
};

func void DIA_Sonja_ROUTINE_Pee ()
{
	AI_Output			(other, self, "Geh mal für kleine Mädchen!"); //Geh mal für kleine Mädchen!
	Npc_ExchangeRoutine	(self,"PEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Dance ()
{
	AI_Output			(other, self, "Tanz!"); //Tanz!
	Npc_ExchangeRoutine	(self,"DANCE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Vatras()
{
    AI_StopProcessInfos (self);
    AI_GotoNpc(self, Vatras);
};

func void DIA_Sonja_ROUTINE_Pyrokar()
{
    AI_StopProcessInfos (self);
    AI_GotoNpc(self, Pyrokar);
};

func void DIA_Sonja_ROUTINE_Xardas()
{
    AI_StopProcessInfos (self);
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
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_BACK);
};

func void DIA_Sonja_AUSSEHEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_AUSSEHEN);
};


func void DIA_Sonja_AUSSEHEN_Nude ()
{
	AI_Output			(other, self, "Zieh dich aus!"); //Zieh dich aus!

    AI_UnequipArmor (self);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Clothing ()
{
	AI_Output			(other, self, "Zieh dir was an!"); //Zieh dir was an!

    AI_EquipBestArmor (self);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Fat ()
{
	AI_Output			(other, self, "Iss etwas!"); //Iss etwas!

    Mdl_SetModelFatness (self, 4);

    DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Thin ()
{
	AI_Output			(other, self, "Mach ein bisschen Sport!"); //Mach ein bisschen Sport!

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
	description		= "(Schönheits-Operation für Kopf)";
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
	description		= "(Schönheits-Operation für Haut)";
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
	description		= "(Schönheits-Operation für Gesicht)";
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
	description = "(Bekleidung und Ausrüstung)";
};

FUNC INT DIA_Sonja_KLEIDUNG_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_KLEIDUNG_Info()
{
	Info_ClearChoices	(DIA_Sonja_KLEIDUNG);

	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Drachenjägerin (2000 Gold)"	,    DIA_Sonja_KLEIDUNG_DragonSlayer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bäuerin (200 Gold)"	,    DIA_Sonja_KLEIDUNG_Farmer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Schwerer Ast (1 Gold)"	,    DIA_Sonja_KLEIDUNG_Schwerer_Ast);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Fernkampfwaffe aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestRangeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Nahkampfwaffe aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestMeleeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Rüstung aus ihrem Inventar"	,    DIA_Sonja_KLEIDUNG_BestArmor);
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
        AI_Output			(other, self, "Benutz das hier!"); //"Benutz das hier
        AI_Output			(self, other, "Wie du magst!"); //Wie du magst!
        EquipItem(self, armor);
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_STANDARD_16_03"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Ausrüstung für sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "Hier ist neue Ausrüstung!"); //Hier ist neue Ausrüstung!
            AI_Output			(self, other, "Danke!"); //Danke!

            B_GiveInvItems (other, self, armor, 1);
            EquipItem(self, armor);
            B_LogEntry ("Sonja", "Sonja freut sich über neue Ausrüstung.");
        };
    };
};

func void Sonja_Bekleiden(var int armor, var int cost)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "Zieh das hier an!"); //Zieh das hier an!
        AI_Output			(self, other, "Wie du magst!"); //Wie du magst!

        AI_UnequipArmor	(self);
        AI_EquipArmor 	(self, armor);
        //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_STANDARD_16_03"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Kleidung für sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "Hier ist etwas Neues zum Anziehen!"); //Hier ist etwas Neues zum Anziehen!
            AI_Output			(self, other, "Danke!"); //Danke!

            CreateInvItems (self, armor, 1);
            AI_UnequipArmor	(self);
            AI_EquipArmor 	(self, armor);
            //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
            B_LogEntry ("Sonja", "Sonja freut sich über neue Kleidung.");
        };
    };
};

func void DIA_Sonja_KLEIDUNG_Normal ()
{
    Sonja_Bekleiden(ITAR_VlkBabe_H, 0);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRangeWeapon()
{
    AI_EquipBestRangedWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestMeleeWeapon()
{
    AI_EquipBestMeleeWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestArmor()
{
    AI_EquipBestArmor(self);
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
    AI_Output			(other, self, "Koch mir was!"); //Koch mir was!

    if (SonjaGeheiratet)
    {
        if (Wld_GetDay() - SonjaCookDays >= 7)
        {
            AI_Output			(self, other, "Ich koche nur jede Woche etwas für dich! Komm in ein paar Tagen wieder!"); //Ich koche nur jede Woche etwas für dich! Komm in ein paar Tage wieder!
            B_LogEntry ("Sonja", "Sonja kocht für mich nur einmal in der Woche.");

            var String msg;
            msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaCookDays - Wld_GetDay()));
            PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
        }
        else
        {
            AI_Output			(self, other, "Gerne, mein Ehemann!"); //Gerne, mein Ehemann!
            B_GiveInvItems (self, other, ItFo_XPStew, 1);
            SonjaCookDays = 0;
        };
    }
    else
    {
        AI_Output			(self, other, "Koch dir doch selbst was! Ich bin nicht deine Frau!"); //Koch dir doch selbst was! Ich bin nicht deine Frau!
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
    AI_Output			(other, self, "Schau mal wie viel Erfahrung ich gesammelt habe!"); //Schau mal wie viel Erfahrung ich gesammelt habe!

    if (other.level <= SonjaAngebenLevel)
    {
        AI_Output			(self, other, "Ach, du Angeber! Du bist doch immer noch so wie beim letzten Mal!"); //Ach, du Angeber! Du bist doch immer noch so wie beim letzten Mal!
        B_LogEntry ("Sonja", "Sonja ist unbeeindruckt von meiner Angeberei, wenn ich nicht wirklich mehr Erfahrung gesammelt habe.");
    }
    else
    {
        AI_Output			(self, other, "Ja mein Prinz, du bist der Beste! Aus dir kann noch ein König werden!"); //Ja mein Prinz, du bist der Beste! Aus dir kann noch ein König werden!
        B_LogEntry ("Sonja", "Sonja mag mich mit mehr Erfahrung lieber. Ich sollte Erfahrung sammeln.");
    };

    SonjaAngebenLevel = other.level;
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








