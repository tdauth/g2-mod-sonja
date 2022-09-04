///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sklavin_EXIT   (C_INFO)
{
	npc         = VLK_15000_Sklavin;
	nr          = 999;
	condition   = DIA_Sklavin_EXIT_Condition;
	information = DIA_Sklavin_EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Sklavin_EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Sklavin_EXIT_Info()
{
	AI_StopProcessInfos (self);
};
// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Sklavin_PICKPOCKET (C_INFO)
{
	npc			= VLK_15000_Sklavin;
	nr			= 900;
	condition	= DIA_Sklavin_PICKPOCKET_Condition;
	information	= DIA_Sklavin_PICKPOCKET_Info;
	permanent	= TRUE;
	description = Pickpocket_20_Female;
};                       

FUNC INT DIA_Sklavin_PICKPOCKET_Condition()
{
	C_Beklauen (20, 10);
};
 
FUNC VOID DIA_Sklavin_PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Sklavin_PICKPOCKET);
	Info_AddChoice		(DIA_Sklavin_PICKPOCKET, DIALOG_BACK 		,DIA_Sklavin_PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Sklavin_PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Sklavin_PICKPOCKET_DoIt);
};

func void DIA_Sklavin_PICKPOCKET_DoIt()
{
	B_Beklauen ();
	Info_ClearChoices (DIA_Sklavin_PICKPOCKET);
};
	
func void DIA_Sklavin_PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Sklavin_PICKPOCKET);
};
///////////////////////////////////////////////////////////////////////
//	Info STANDARD
///////////////////////////////////////////////////////////////////////
instance DIA_Sklavin_STANDARD		(C_INFO)
{
	npc			 = 	VLK_15000_Sklavin;
	condition	 = 	DIA_Sklavin_STANDARD_Condition;
	information	 = 	DIA_Sklavin_STANDARD_Info;
	important	 = 	TRUE;
	permanent	 = 	TRUE;
};

func int DIA_Sklavin_STANDARD_Condition ()
{	
	return TRUE;
};
func void DIA_Sklavin_STANDARD_Info ()
{
	AI_Output			(self, other, "DIA_Vanja_STANDARD_17_00"); //Ich bin beschäftigt.
	AI_StopProcessInfos (self);
};
