func int B_TeachAufreisserTalentPercent (var C_NPC slf, var C_NPC oth, var int percent, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	kosten = B_GetLearnCostTalent(oth, NPC_TALENT_WOMANIZER, percent);

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
