// **************
// B_GivePlayerXP
// **************
func void B_GiveNPCXP (var C_NPC self, var int add_xp)
{
    if (self.level == 0)
	{
		self.exp_next = 500;
	};
	//----------------------------------------------------------------------------
	self.exp = self.exp + add_xp;

	//----------------------------------------------------------------------------
	var string concatText;
	concatText = PRINT_XPGained;
	concatText = ConcatStrings (concatText,	IntToString(add_xp));
	PrintScreen	(concatText, -1, YPOS_XPGained, FONT_ScreenSmall, 2);

	//----------------------------------------------------------------------------
	if ( self.exp >= self.exp_next ) // ( XP > (500*((hero.level+2)/2)*(hero.level+1)) )
	{
		self.level = self.level+1;
		self.exp_next = self.exp_next +((hero.level+1)*500);

		self.attribute[ATR_HITPOINTS_MAX] 	= self.attribute[ATR_HITPOINTS_MAX]	+ HP_PER_LEVEL;
		self.attribute[ATR_HITPOINTS] 		= self.attribute[ATR_HITPOINTS]		+ HP_PER_LEVEL;

		self.LP = self.LP + LP_PER_LEVEL;

		concatText = PRINT_LevelUp;
		concatText = ConcatStrings (concatText,	" ");
		concatText = ConcatStrings (concatText,	self.name);

		PrintScreen (concatText, -1, YPOS_LevelUp, FONT_Screen, 2);
		Snd_Play ("LevelUp");
	};
};

func void B_GivePlayerXP (var int add_xp)
{
	if (hero.level == 0)
	{
		hero.exp_next = 500;
	};
	//----------------------------------------------------------------------------
	hero.exp = hero.exp + add_xp;

	//----------------------------------------------------------------------------
	var string concatText;
	concatText = PRINT_XPGained;
	concatText = ConcatStrings (concatText,	IntToString(add_xp));
	PrintScreen	(concatText, -1, YPOS_XPGained, FONT_ScreenSmall, 2);

	//----------------------------------------------------------------------------
	if ( hero.exp >= hero.exp_next ) // ( XP > (500*((hero.level+2)/2)*(hero.level+1)) )
	{
		hero.level = hero.level+1;
		hero.exp_next = hero.exp_next +((hero.level+1)*500);
		
		hero.attribute[ATR_HITPOINTS_MAX] 	= hero.attribute[ATR_HITPOINTS_MAX]	+ HP_PER_LEVEL;
		hero.attribute[ATR_HITPOINTS] 		= hero.attribute[ATR_HITPOINTS]		+ HP_PER_LEVEL;
		
		hero.LP = hero.LP + LP_PER_LEVEL;
				
		PrintScreen (PRINT_LevelUp, -1, YPOS_LevelUp, FONT_Screen, 2);				
		Snd_Play ("LevelUp");
	};
	B_Checklog ();

	if (SonjaFolgt)
	{
        B_GiveNPCXP(VLK_436_Sonja, add_xp);
    };
};








