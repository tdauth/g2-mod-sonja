///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Bromor_EXIT   (C_INFO)
{
	npc         = VLK_433_Bromor;
	nr          = 999;
	condition   = DIA_Bromor_EXIT_Condition;
	information = DIA_Bromor_EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Bromor_EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Bromor_EXIT_Info()
{
	B_NpcClearObsessionByDMT (self);
};
///////////////////////////////////////////////////////////////////////
//	Info GIRLS
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_GIRLS		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	2;
	condition	 = 	DIA_Bromor_GIRLS_Condition;
	information	 = 	DIA_Bromor_GIRLS_Info;
	permanent	 = 	FALSE;
	description	 = 	"Geh�rt dir der Laden hier?";
};

func int DIA_Bromor_GIRLS_Condition ()
{	
	if (NpcObsessedByDMT_Bromor == FALSE)
		{
				return TRUE;
		};
};
func void DIA_Bromor_GIRLS_Info ()
{
	//ADDON>
	AI_Output (other, self, "DIA_Addon_Bromor_GIRLS_15_00"); //Geh�rt dir der Laden hier?
	//ADDON<

	//AI_Output (other, self, "DIA_Bromor_GIRLS_15_00"); //Ich will mich am�sieren.
	//AI_Output (self, other, "DIA_Bromor_GIRLS_07_01"); //Deshalb bist du ja hergekommen.

	AI_Output (self, other, "DIA_Bromor_GIRLS_07_02"); //Ich bin Bromor. Das hier ist mein Haus und das sind meine M�dels. Ich mag meine M�dels.
	AI_Output (self, other, "DIA_Bromor_GIRLS_07_03"); //Und wenn du meine M�dels auch magst, dann bezahlst du daf�r - 50 Goldst�cke.
	AI_Output (self, other, "DIA_Bromor_GIRLS_07_04"); //Und komm nicht auf die Idee, hier �rger zu machen.
};

///////////////////////////////////////////////////////////////////////
//	Info MissingPeople
///////////////////////////////////////////////////////////////////////
instance DIA_Addon_Bromor_MissingPeople		(C_INFO)
{
	npc		 = 	VLK_433_Bromor;
	nr		 = 	2;
	condition	 = 	DIA_Addon_Bromor_MissingPeople_Condition;
	information	 = 	DIA_Addon_Bromor_MissingPeople_Info;

	description	 = 	"Sind deine M�dchen noch vollz�hlig?";
};

func int DIA_Addon_Bromor_MissingPeople_Condition ()
{
	if (NpcObsessedByDMT_Bromor == FALSE)
	&& (SC_HearedAboutMissingPeople == TRUE)
	&& (Npc_KnowsInfo (other, DIA_Bromor_GIRLS))
		{
			return TRUE;
		};
};

func void DIA_Addon_Bromor_MissingPeople_Info ()
{
	AI_Output	(other, self, "DIA_Addon_Bromor_MissingPeople_15_00"); //Sind deine M�dchen noch vollz�hlig?
	AI_Output	(self, other, "DIA_Addon_Bromor_MissingPeople_07_01"); //Selbstverst�ndlich. Oder glaubst du, ich will wegen so was im Knast landen?
	AI_Output	(other, self, "DIA_Addon_Bromor_MissingPeople_15_02"); //(irritiert) �h ... Nicht vollj�hrig, ich meine VOLLZ�HLIG. Ist dir mal ein M�dchen abhanden gekommen?
	AI_Output	(self, other, "DIA_Addon_Bromor_MissingPeople_07_03"); //Ach so. Ja. Tats�chlich ist eins meiner M�dchen weg. Lucia ist ihr Name.
	AI_Output	(self, other, "DIA_Addon_Bromor_MissingPeople_07_04"); //Ich habe es auch schon der Miliz gemeldet. Aber die behaupten, bisher noch keine Spur von ihr gefunden zu haben.
	
	Log_CreateTopic (TOPIC_Addon_MissingPeople, LOG_MISSION);
	Log_SetTopicStatus(TOPIC_Addon_MissingPeople, LOG_RUNNING);
	B_LogEntry (TOPIC_Addon_MissingPeople,"Ein Freudenm�dchen namens Lucia ist aus dem Bordell am Hafen verschwunden."); 
};

///////////////////////////////////////////////////////////////////////
//	Info Lucia
///////////////////////////////////////////////////////////////////////
instance DIA_Addon_Bromor_Lucia		(C_INFO)
{
	npc		 = 	VLK_433_Bromor;
	nr		 = 	5;
	condition	 = 	DIA_Addon_Bromor_Lucia_Condition;
	information	 = 	DIA_Addon_Bromor_Lucia_Info;

	description	 = 	"Seit wann ist Lucia nicht mehr da?";
};

func int DIA_Addon_Bromor_Lucia_Condition ()
{
	if (NpcObsessedByDMT_Bromor == FALSE)
	&& (SC_HearedAboutMissingPeople == TRUE)
	&& (Npc_KnowsInfo (other, DIA_Addon_Bromor_MissingPeople))
		{
			return TRUE;
		};
};

func void DIA_Addon_Bromor_Lucia_Info ()
{
	AI_Output	(other, self, "DIA_Addon_Bromor_Lucia_15_00"); //Seit wann ist Lucia nicht mehr da?
	AI_Output	(self, other, "DIA_Addon_Bromor_Lucia_07_01"); //Schon einige Tage. Genau wei� ich das nicht.
	AI_Output	(self, other, "DIA_Addon_Bromor_Lucia_07_02"); //Ich geh davon aus, dass sie mit einem ihrer Freier durchgebrannt ist.
	AI_Output	(self, other, "DIA_Addon_Bromor_Lucia_07_03"); //Das Mistst�ck hat einen Teil meiner Ersparnisse mitgehen lassen. Es war eine sehr wertvolle goldene Schale.
	AI_Output	(self, other, "DIA_Addon_Bromor_Lucia_07_04"); //Wenn ich sie zu fassen kriege, kann sie was erleben.
	AI_Output	(self, other, "DIA_Addon_Bromor_Lucia_07_05"); //Was geht DICH das eigentlich an? Willst du dich jetzt am�sieren oder was?

	Log_CreateTopic (TOPIC_Addon_BromorsGold, LOG_MISSION);
	Log_SetTopicStatus(TOPIC_Addon_BromorsGold, LOG_RUNNING);
	B_LogEntry (TOPIC_Addon_BromorsGold,"Das Freudenm�dchen Lucia hat ihrem Boss Bromor eine goldene Schale gestohlen. Bromor will sie wieder haben."); 

	MIS_Bromor_LuciaStoleGold = LOG_RUNNING;
};

///////////////////////////////////////////////////////////////////////
//	Info LuciaGold
///////////////////////////////////////////////////////////////////////
instance DIA_Addon_Bromor_LuciaGold		(C_INFO)
{
	npc		 = 	VLK_433_Bromor;
	nr		 = 	5;
	condition	 = 	DIA_Addon_Bromor_LuciaGold_Condition;
	information	 = 	DIA_Addon_Bromor_LuciaGold_Info;
	permanent	 = 	TRUE;

	description	 = 	"Ich habe deine Schale gefunden, die dir Lucia gestohlen hat.";
};

func int DIA_Addon_Bromor_LuciaGold_Condition ()
{
	if (NpcObsessedByDMT_Bromor == FALSE)
	&& (MIS_Bromor_LuciaStoleGold == LOG_RUNNING)
	&& (Npc_HasItems (other,ItMi_BromorsGeld_Addon))
		{
			return TRUE;
		};
};

func void DIA_Addon_Bromor_LuciaGold_Info ()
{
	AI_Output	(other, self, "DIA_Addon_Bromor_LuciaGold_15_00"); //Ich habe die Schale gefunden, die Lucia dir gestohlen hat.
	AI_Output	(self, other, "DIA_Addon_Bromor_LuciaGold_07_01"); //Gro�artig! Das wurde aber auch Zeit.
	
	Info_ClearChoices	(DIA_Addon_Bromor_LuciaGold);
	if (Bromor_Hausverbot == FALSE)
	{
		Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Wie sieht's aus mit Finderlohn?", DIA_Addon_Bromor_LuciaGold_lohn );
	};
	Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Hier ist deine Schale.", DIA_Addon_Bromor_LuciaGold_einfachgeben );
	if (DIA_Addon_Bromor_LuciaGold_lucia_OneTime == FALSE)
	{
		Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Willst du gar nicht wissen, wo Lucia ist?", DIA_Addon_Bromor_LuciaGold_lucia );
	};
};
func void DIA_Addon_Bromor_LuciaGold_einfachgeben ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_einfachgeben_15_00"); //Hier ist deine Schale.
	B_GiveInvItems (other, self, ItMi_BromorsGeld_Addon,1);
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_einfachgeben_07_01"); //Danke. Sehr gro�z�gig von dir. Sonst noch was?
	MIS_Bromor_LuciaStoleGold = LOG_SUCCESS;
	Bromor_Hausverbot = FALSE;
	B_GivePlayerXP (XP_Addon_Bromor_LuciaGold);
	Info_ClearChoices	(DIA_Addon_Bromor_LuciaGold);
};
var int DIA_Addon_Bromor_LuciaGold_lucia_OneTime;
func void DIA_Addon_Bromor_LuciaGold_lucia ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_lucia_15_00"); //Willst du gar nicht wissen, wo Lucia ist?
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_lucia_07_01"); //Nein. Wieso? Die Schale ist doch wieder da, oder nicht?
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_lucia_07_02"); //Es ist bisher ohne Lucia gegangen, dann wird es das auch weiterhin. Reisende soll man nicht aufhalten.
	DIA_Addon_Bromor_LuciaGold_lucia_OneTime = TRUE;
};
func void DIA_Addon_Bromor_LuciaGold_lohn ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_lohn_15_00"); //Wie sieht's aus mit Finderlohn?
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_lohn_07_01"); //Du kannst dich mit einem meiner M�dels umsonst vergn�gen. Ist das nichts?

	Info_ClearChoices	(DIA_Addon_Bromor_LuciaGold);
	if (DIA_Addon_Bromor_LuciaGold_lucia_OneTime == FALSE)
	{
		Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Willst du gar nicht wissen, wo Lucia ist?", DIA_Addon_Bromor_LuciaGold_lucia );
	};	
	Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Das ist mir zu wenig.", DIA_Addon_Bromor_LuciaGold_mehr );
	Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Abgemacht. Hier, deine Schale.", DIA_Addon_Bromor_LuciaGold_geben );
};
func void DIA_Addon_Bromor_LuciaGold_mehr ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_mehr_15_00"); //Das ist mir zu wenig.
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_mehr_07_01"); //Nimm es oder du brauchst hier gar nicht wieder aufzutauchen.
	Info_AddChoice	(DIA_Addon_Bromor_LuciaGold, "Vergiss es.", DIA_Addon_Bromor_LuciaGold_nein );
};
func void DIA_Addon_Bromor_LuciaGold_nein ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_nein_15_00"); //Vergiss es.
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_nein_07_01"); //Dann verschwinde aus meinem Laden, du Dreckskerl.
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_nein_07_02"); //Und glaub ja nicht, dass du hier noch mal bedient wirst.
	Info_ClearChoices	(DIA_Addon_Bromor_LuciaGold);
	Bromor_Hausverbot = TRUE;
	Bromor_Pay = 0;
};
func void DIA_Addon_Bromor_LuciaGold_geben ()
{
	AI_Output			(other, self, "DIA_Addon_Bromor_LuciaGold_geben_15_00"); //Abgemacht. Hier, deine Schale.
	B_GiveInvItems (other, self, ItMi_BromorsGeld_Addon,1);
	AI_Output			(self, other, "DIA_Addon_Bromor_LuciaGold_geben_07_01"); //Danke. Geh zu Nadja. Sie wird dich nach oben begleiten.
	Bromor_Pay = 1; 
	MIS_Bromor_LuciaStoleGold = LOG_SUCCESS;
	Bromor_Hausverbot = FALSE;
	B_GivePlayerXP (XP_Addon_Bromor_LuciaGold);
	Info_ClearChoices	(DIA_Addon_Bromor_LuciaGold);
};

///////////////////////////////////////////////////////////////////////
//	Info bezahlen
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_Pay		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	2;
	condition	 = 	DIA_Bromor_Pay_Condition;
	information	 = 	DIA_Bromor_Pay_Info;
	permanent	 = 	TRUE;
	description	 = 	"Ich will mich am�sieren (50 Goldst�cke zahlen)";
};

func int DIA_Bromor_Pay_Condition ()
{	
	if (Bromor_Pay == FALSE)
	&& (Bromor_Hausverbot == FALSE)//ADDON
	&& Npc_KnowsInfo (other,DIA_Bromor_GIRLS)
	&& (NpcObsessedByDMT_Bromor == FALSE)
	&& (Npc_IsDead (Nadja) == FALSE)
	&& (Bromor_RoteTaverneVerkauft == FALSE) // Sonja
	{	
		return TRUE;
	};
};

var int DIA_Bromor_Pay_OneTime;
func void DIA_Bromor_Pay_Info ()
{
	AI_Output (other, self, "DIA_Bromor_Pay_15_00"); //Ich will mich am�sieren.
	
	if B_GiveInvItems (other, self, ItMi_Gold, 50)
	{
		AI_Output (self, other, "DIA_Bromor_Pay_07_01"); //Gut. (grinst) Die n�chsten Stunden deines Lebens wirst du so schnell nicht vergessen.
		AI_Output (self, other, "DIA_Bromor_Pay_07_02"); //Geh mit Nadja nach oben. Viel Spa�.
	
		if (DIA_Bromor_Pay_OneTime == FALSE)
		{
			DIA_Bromor_Pay_OneTime = TRUE;
		};
	
		Bromor_Pay = 1; 
	}
	else
	{
		AI_Output (self, other, "DIA_Bromor_Pay_07_03"); //Ich kann's nicht leiden wenn man mich verarschen will. Verschwinde, wenn du nicht zahlen kannst.
	};
	B_NpcClearObsessionByDMT (self);
};
///////////////////////////////////////////////////////////////////////
//	Info DOPE
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_DOPE		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	3;
	condition	 = 	DIA_Bromor_DOPE_Condition;
	information	 = 	DIA_Bromor_DOPE_Info;
	permanent	 =  FALSE;
	description	 = 	"Kann ich hier auch 'besondere' Ware bekommen?";
};

func int DIA_Bromor_DOPE_Condition ()
{	
	if (MIS_Andre_REDLIGHT == LOG_RUNNING)
	&& (NpcObsessedByDMT_Bromor == FALSE)
	&& (Bromor_Hausverbot == FALSE)//ADDON
	&& (Bromor_RoteTaverneVerkauft == FALSE) // Sonja
	{
		return TRUE;
	};
};
func void DIA_Bromor_DOPE_Info ()
{
	AI_Output (other, self, "DIA_Bromor_DOPE_15_00"); //Kann ich hier auch 'besondere' Ware bekommen?
	AI_Output (self, other, "DIA_Bromor_DOPE_07_01"); //Klar, alle meine M�dels sind was ganz Besonderes. (grinst)
	AI_Output (self, other, "DIA_Bromor_DOPE_07_02"); //Wenn du genug Gold hast, dann kannst du mit Nadja hochgehen.
};

///////////////////////////////////////////////////////////////////////
//	Info Obsession
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_Obsession		(C_INFO)
{
	npc		 = 	VLK_433_Bromor;
	nr		 = 	30;
	condition	 = 	DIA_Bromor_Obsession_Condition;
	information	 = 	DIA_Bromor_Obsession_Info;

	description	 = 	"Geht�s dir gut?";
};

func int DIA_Bromor_Obsession_Condition ()
{
	if (Kapitel >= 3)
	&& (NpcObsessedByDMT_Bromor == FALSE)
	&& (hero.guild == GIL_KDF)
		{
				return TRUE;
		};
};

var int DIA_Bromor_Obsession_GotMoney;

func void DIA_Bromor_Obsession_Info ()
{
	B_NpcObsessedByDMT (self);
};

///////////////////////////////////////////////////////////////////////
//	Info Heilung
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_Heilung		(C_INFO)
{
	npc		 = 	VLK_433_Bromor;
	nr		 = 	55;
	condition	 = 	DIA_Bromor_Heilung_Condition;
	information	 = 	DIA_Bromor_Heilung_Info;
	permanent	 = 	TRUE;

	description	 = 	"Du bist besessen.";
};

func int DIA_Bromor_Heilung_Condition ()
{
 	if (NpcObsessedByDMT_Bromor == TRUE) && (NpcObsessedByDMT == FALSE)
	&& (hero.guild == GIL_KDF)
	 {
				return TRUE;
	 };
};

func void DIA_Bromor_Heilung_Info ()
{
	AI_Output			(other, self, "DIA_Bromor_Heilung_15_00"); //Du bist besessen.
	AI_Output			(self, other, "DIA_Bromor_Heilung_07_01"); //Was? Wovon redest du da? Verschwinde.
	B_NpcClearObsessionByDMT (self);
};

// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Bromor_PICKPOCKET (C_INFO)
{
	npc			= VLK_433_Bromor;
	nr			= 900;
	condition	= DIA_Bromor_PICKPOCKET_Condition;
	information	= DIA_Bromor_PICKPOCKET_Info;
	permanent	= TRUE;
	description = "(Es w�re gewagt seinen Schl�ssel zu stehlen)";
};                       

FUNC INT DIA_Bromor_PICKPOCKET_Condition()
{
	if (Npc_GetTalentSkill (other,NPC_TALENT_PICKPOCKET) == 1) 
	&& (self.aivar[AIV_PlayerHasPickedMyPocket] == FALSE)
	&& (Npc_HasItems(self, ItKE_Bromor) >= 1)
	&& (other.attribute[ATR_DEXTERITY] >= (50 - Theftdiff))
	{
		return TRUE;
	};
};
 
FUNC VOID DIA_Bromor_PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Bromor_PICKPOCKET);
	Info_AddChoice		(DIA_Bromor_PICKPOCKET, DIALOG_BACK 		,DIA_Bromor_PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Bromor_PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Bromor_PICKPOCKET_DoIt);
};

func void DIA_Bromor_PICKPOCKET_DoIt()
{
	if (other.attribute[ATR_DEXTERITY] >= 50)
	{
		B_GiveInvItems (self, other, ItKE_Bromor, 1);
		self.aivar[AIV_PlayerHasPickedMyPocket] = TRUE;
		B_GiveThiefXP();
		Info_ClearChoices (DIA_Bromor_PICKPOCKET);
	}
	else
	{
		B_ResetThiefLevel (); 
		AI_StopProcessInfos	(self);
		B_Attack (self, other, AR_Theft, 1); //reagiert trotz IGNORE_Theft mit NEWS
	};
};
	
func void DIA_Bromor_PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Bromor_PICKPOCKET);
};

///////////////////////////////////////////////////////////////////////
//	Info BUYASK
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_BUYASK		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	3;
	condition	 = 	DIA_Bromor_BUYASK_Condition;
	information	 = 	DIA_Bromor_BUYASK_Info;
	permanent	 =  FALSE;
	description	 = 	"Kann ich dir deinen Laden abkaufen?";
};

func int DIA_Bromor_BUYASK_Condition ()
{
    return Npc_KnowsInfo(other, DIA_Bromor_GIRLS);
};
func void DIA_Bromor_BUYASK_Info ()
{
	AI_Output (other, self, "DIA_Bromor_BUYASK_15_00"); //Kann ich dir deinen Laden abkaufen?
	AI_Output (self, other, "DIA_Bromor_BUYASK_07_01"); //Du willst was? Bist du verr�ckt? Ich verdiene damit meinen Lebensunterhalt. Da m�sstest du mir schon eine Menge Gold bezahlen.
	AI_Output (other, self, "DIA_Bromor_BUYASK_15_01"); //Was wenn ich genug habe?
	AI_Output (self, other, "DIA_Bromor_BUYASK_07_02"); //Das glaubst du doch selbst nicht. F�r 15 000 Goldm�nzen vermache ich dir die Rote Laterne. Aber nur wenn du auf mich einen vertrauensw�rdigen Eindruck gemacht hast.

	Log_CreateTopic ("Die Rote Laterne", LOG_NOTE);
	B_LogEntry ("Die Rote Laterne", "Bromor wird mir die Rote Laterne f�r 15 000 Goldm�nzen verkaufen, falls ich bis dahin sein Vertrauen gewonnen habe.");
};

///////////////////////////////////////////////////////////////////////
//	Info BUY
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_BUY		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	3;
	condition	 = 	DIA_Bromor_BUY_Condition;
	information	 = 	DIA_Bromor_BUY_Info;
	permanent	 =  TRUE;
	description	 = 	"�berlasse mir die Rote Laterne!";
};

func int DIA_Bromor_BUY_Condition ()
{
    return Npc_KnowsInfo(other, DIA_Bromor_BUYASK) && Bromor_RoteTaverneVerkauft == FALSE;
};
func void DIA_Bromor_BUY_Info ()
{
	AI_Output (other, self, "DIA_Bromor_BUY_15_00"); //�berlasse mir die Rote Laterne!
	AI_Output (self, other, "DIA_Bromor_BUY_07_01"); //Mal sehen ...

	if (Npc_HasItems(other, ItMi_Gold) < 15000)
	{
        AI_Output (self, other, "DIA_Bromor_BUY_07_02"); //Du hast nicht genug Gold bei dir!
	}
	else if (MIS_Bromor_LuciaStoleGold != LOG_SUCCESS)
	{
        AI_Output (self, other, "DIA_Bromor_BUY_07_03"); //Du hast mir meine Goldene Schale nicht zur�ck gebracht!
	}
	else if (SonjaFolgt == FALSE && Npc_IsDead(Sonja) == FALSE)
	{
        AI_Output (self, other, "DIA_Bromor_BUY_07_04"); //Du hast Sonja noch nicht freigekauft.
	}
	else
	{
        AI_Output (self, other, "DIA_Bromor_BUY_07_05"); //Du hast genug Gold bei dir!
        AI_Output (self, other, "DIA_Bromor_BUY_07_06"); //Du hast mir meine Goldene Schale wieder gebracht!
        AI_Output (self, other, "DIA_Bromor_BUY_07_07"); //Du hast Sonja freigekauft!
        AI_Output (self, other, "DIA_Bromor_BUY_07_08"); //Hier ist der Schl�ssel zu meinem Zimmer. Die Rote Taverne, die Perle von Khorinis geh�rt nun dir. Halte sie in Ehren!
        B_GiveInvItems (other, self, ItMi_Gold, 15000);
        B_GiveInvItems (self, other, ItKe_Bromor, 1);
        B_LogEntry ("Die Rote Laterne", "Die Rote Laterne geh�rt nun mir. Ich soll sie in Ehren halten.");
        Bromor_RoteTaverneVerkauft = TRUE;
        Npc_ExchangeRoutine	(self,"NEWLIFE");
        B_AssignSonjaPimp(Nadja);
        B_AssignSonjaPimp(Vanja);
	};
};

///////////////////////////////////////////////////////////////////////
//	Info NEW LIFE
///////////////////////////////////////////////////////////////////////
instance DIA_Bromor_NEW_LIFE		(C_INFO)
{
	npc			 = 	VLK_433_Bromor;
	nr			 = 	3;
	condition	 = 	DIA_Bromor_NEW_LIFE_Condition;
	information	 = 	DIA_Bromor_NEW_LIFE_Info;
	permanent	 =  TRUE;
	description	 = 	"Wie l�ufts?";
};

func int DIA_Bromor_NEW_LIFE_Condition ()
{
    return Bromor_RoteTaverneVerkauft;
};
func void DIA_Bromor_NEW_LIFE_Info ()
{
	AI_Output (other, self, "DIA_Bromor_NEW_LIFE_15_00"); //Wie l�ufts?
	AI_Output (self, other, "DIA_Bromor_NEW_LIFE_07_01"); //Ich kann mich nicht beklagen. Dein Geld hat mir das Leben im oberen Viertel erm�glicht.
};





