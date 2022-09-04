///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Wache_2EXIT   (C_INFO)
{
	npc         = VLK_15002_Wache;
	nr          = 999;
	condition   = DIA_Wache_2EXIT_Condition;
	information = DIA_Wache_2EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Wache_2EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Wache_2EXIT_Info()
{
	AI_StopProcessInfos (self);
};
// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Wache_2PICKPOCKET (C_INFO)
{
	npc			= VLK_15002_Wache;
	nr			= 900;
	condition	= DIA_Wache_2PICKPOCKET_Condition;
	information	= DIA_Wache_2PICKPOCKET_Info;
	permanent	= TRUE;
	description = Pickpocket_20;
};                       

FUNC INT DIA_Wache_2PICKPOCKET_Condition()
{
	C_Beklauen (20, 10);
};
 
FUNC VOID DIA_Wache_2PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Wache_2PICKPOCKET);
	Info_AddChoice		(DIA_Wache_2PICKPOCKET, DIALOG_BACK 		,DIA_Wache_2PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Wache_2PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Wache_2PICKPOCKET_DoIt);
};

func void DIA_Wache_2PICKPOCKET_DoIt()
{
	B_Beklauen ();
	Info_ClearChoices (DIA_Wache_2PICKPOCKET);
};
	
func void DIA_Wache_2PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Wache_2PICKPOCKET);
};
///////////////////////////////////////////////////////////////////////
//	Info STANDARD
///////////////////////////////////////////////////////////////////////
instance DIA_Wache_2STANDARD		(C_INFO)
{
	npc			 = 	VLK_15002_Wache;
	condition	 = 	DIA_Wache_2STANDARD_Condition;
	information	 = 	DIA_Wache_2STANDARD_Info;
	important	 = 	TRUE;
	permanent	 = 	TRUE;
};

func int DIA_Wache_2STANDARD_Condition ()
{	
	return TRUE;
};
func void DIA_Wache_2STANDARD_Info ()
{
	AI_Output			(self, other, "DIA_Wache_STANDARD_12_00"); //Ich bin beschäftigt.
	AI_StopProcessInfos (self);
};
