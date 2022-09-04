///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Wache_1EXIT   (C_INFO)
{
	npc         = VLK_15001_Wache;
	nr          = 999;
	condition   = DIA_Wache_1EXIT_Condition;
	information = DIA_Wache_1EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Wache_1EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Wache_1EXIT_Info()
{
	AI_StopProcessInfos (self);
};
// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Wache_1PICKPOCKET (C_INFO)
{
	npc			= VLK_15001_Wache;
	nr			= 900;
	condition	= DIA_Wache_1PICKPOCKET_Condition;
	information	= DIA_Wache_1PICKPOCKET_Info;
	permanent	= TRUE;
	description = Pickpocket_20;
};                       

FUNC INT DIA_Wache_1PICKPOCKET_Condition()
{
	C_Beklauen (20, 10);
};
 
FUNC VOID DIA_Wache_1PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Wache_1PICKPOCKET);
	Info_AddChoice		(DIA_Wache_1PICKPOCKET, DIALOG_BACK 		,DIA_Wache_1PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Wache_1PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Wache_1PICKPOCKET_DoIt);
};

func void DIA_Wache_1PICKPOCKET_DoIt()
{
	B_Beklauen ();
	Info_ClearChoices (DIA_Wache_1PICKPOCKET);
};
	
func void DIA_Wache_1PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Wache_1PICKPOCKET);
};
///////////////////////////////////////////////////////////////////////
//	Info STANDARD
///////////////////////////////////////////////////////////////////////
instance DIA_Wache_1STANDARD		(C_INFO)
{
	npc			 = 	VLK_15001_Wache;
	condition	 = 	DIA_Wache_1STANDARD_Condition;
	information	 = 	DIA_Wache_1STANDARD_Info;
	important	 = 	TRUE;
	permanent	 = 	TRUE;
};

func int DIA_Wache_1STANDARD_Condition ()
{	
	return TRUE;
};
func void DIA_Wache_1STANDARD_Info ()
{
	AI_Output			(self, other, "DIA_Wache_STANDARD_14_00"); //Ich bin beschäftigt.
	AI_StopProcessInfos (self);
};
