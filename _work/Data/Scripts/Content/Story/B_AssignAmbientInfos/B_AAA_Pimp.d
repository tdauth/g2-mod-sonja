const int PIMP_STATE_NO_MONEY = 0;
const int PIMP_STATE_SUCCESS = 1;
const int PIMP_STATE_ATTACK = 2;

func int B_SetNpcPimpDay(var c_npc n, var int day)
{
    n.aivar[AIV_PimpDay] = day;
};

func int B_GetNpcPimpDay(var c_npc n)
{
    return n.aivar[AIV_PimpDay];
};

func int B_GetNpcPimpDaysPast(var c_npc n)
{
    return Wld_GetDay() - B_GetNpcPimpDay(n);
};


//------------------------------------------------------------------
FUNC VOID B_GivePimpGold()
{
    var string concatText;
    concatText = ConcatStrings ("Tage des Anschaffens: ", IntToString(B_GetNpcPimpDaysPast(self)));
    PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
    B_GiveInvItems (self, other, ItMi_Gold, B_GetNpcPimpDaysPast(self) * Npc_GetTalentSkill (other,NPC_TALENT_PIMP) * 10);
    B_SetNpcPimpDay(other, Wld_GetDay());
};

func int B_Pimp ()
{
	if (Npc_GetTalentSkill (other,NPC_TALENT_PIMP) > 0)
	{
        if (B_GetNpcPimpDaysPast(self) > 0)
        {
            B_GivePimpGold();
            Snd_Play ("Geldbeutel");

            return PIMP_STATE_SUCCESS;
        }
        else
        {
            AI_OutputSVM(self,other, "SpareMe");
            AI_OutputSVM(other,self, "NOTHINGTOGET02");

            return PIMP_STATE_NO_MONEY;
        };
	}
	else
	{
		AI_StopProcessInfos	(self);
		B_Attack (self, other, AR_UseMob, 1); //reagiert trotz IGNORE_Theft mit NEWS

		return PIMP_STATE_ATTACK;
	};
};
