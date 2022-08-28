var int AufreisserVictimCount;
var int AufreisserVictimLevel;
var int AufreisserLevel;

const int AufreisserXP = 30;
//------------------------------------------------------------------
FUNC VOID B_GiveAufreisserXP()
{

	AufreisserLevel = (AufreisserLevel +1);//zähl die Opfer


	if (AufreisserLevel == 0)
	{
		AufreisserLevel = 2; //Start
	};

	if (AufreisserVictimCount >= AufreisserVictimLevel)
	{
		//----------------Kalkulation-----------------

		AufreisserLevel = (AufreisserLevel +1);
		AufreisserVictimLevel =(AufreisserVictimLevel  + AufreisserLevel); //Erhöhe die Anzahl der ständigen Opfer zum nächsten Level (aktuelleOpfer + aktueller Level)

		//Platz fÃ¼r Goodies (Items, Attributes...)
	};

		//-------------------XP-----------------------

		B_GivePlayerXP (AufreisserXP + (AufreisserLevel * 10));
};
//------------------------------------------------------------------
FUNC VOID B_ResetAufreisserLevel()
{


	if (AufreisserVictimCount > AufreisserLevel)
	{
		AufreisserVictimCount = (AufreisserVictimCount - 1);
	};


};

func void B_Aufreissen ()
{
    var int random;
    random = Hlp_Random(100);


	if (Npc_GetTalentSkill (other,NPC_TALENT_WOMANIZER) > random)
	{
        AI_UnequipArmor(self);
		B_GiveAufreisserXP();//B_GivePlayerXP (XP_Ambient);
		CreateInvItems (other, ItPo_Health_02, 2);
		//Snd_Play ("Geldbeutel");
		AI_OutputSVM(self,other, "TOUGHGUY_ATTACKWON"); // ADDON_WRONGARMOR SC_HeyWaitASecond
	}
	else
	{
        AI_EquipBestArmor(self);
		B_ResetAufreisserLevel();
		AI_StopProcessInfos	(self);
		B_Attack (self, other, AR_UseMob, 1); //reagiert trotz IGNORE_Theft mit NEWS
	};
};
