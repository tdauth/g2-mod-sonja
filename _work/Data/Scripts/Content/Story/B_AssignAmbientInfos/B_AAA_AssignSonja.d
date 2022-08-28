// *************************************************************************
// 									AUFREISSEN
// *************************************************************************
INSTANCE DIA_AUFREISSEN(C_INFO)
{
	nr			= 800;
	condition	= DIA_AUFREISSEN_Condition;
	information	= DIA_AUFREISSEN_Info;
	permanent	= TRUE;
	description = "(Aufreißen)";
};
func INT DIA_AUFREISSEN_Condition()
{
	return Npc_GetTalentSkill (other,NPC_TALENT_WOMANIZER) > 0;
};

FUNC VOID DIA_AUFREISSEN_Info()
{
    B_Aufreissen();
};

// *************************************************************************
// 									PIMP
// *************************************************************************
INSTANCE DIA_PIMP(C_INFO)
{
	nr			= 801;
	condition	= DIA_PIMP_Condition;
	information	= DIA_PIMP_Info;
	permanent	= TRUE;
	description = "(Geld eintreiben)";
};
func INT DIA_PIMP_Condition()
{
	return Npc_GetTalentSkill (other,NPC_TALENT_PIMP) > 0;
};

FUNC VOID DIA_PIMP_Info()
{
    B_Pimp();
};

// *********************************************************
// ---------------------------------------------------------

func void B_AssignSonja(var C_NPC slf)
{
	DIA_AUFREISSEN.npc = Hlp_GetInstanceID(slf);
	DIA_PIMP.npc = Hlp_GetInstanceID(slf);
};





