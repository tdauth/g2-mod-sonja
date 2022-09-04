instance VLK_15002_Wache (Npc_Default)
{
	// ------ NSC ------
	name 		= "Wache der Roten Laterne";
	guild 		= GIL_VLK;
	id 			= 15002;
	voice 		= 12;
	flags      	= 0;
	npctype		= NPCTYPE_BL_MAIN;

	//------- AIVAR -------

	// ------ Attribute ------
	B_SetAttributesToChapter (self, 3);

	// ------ Kampf-Taktik ------
	fight_tactic = FAI_HUMAN_NORMAL;

	// ------ Equippte Waffen ------
	EquipItem (self, ItMw_2h_Pal_Sword);
	EquipItem (self, ItRw_Mil_Crossbow);


	// ------ Inventory ------
	B_CreateAmbientInv (self);

	// ------ visuals ------
	B_SetNpcVisual 		(self, MALE, "Hum_Head_Fighter", Face_N_Normal14, BodyTex_N, ITAR_Bloodwyn_Addon);
	Mdl_SetModelFatness	(self, 0);
	Mdl_ApplyOverlayMds	(self, "Humans_Militia.mds");

	// ------ NSC-relevante Talente vergeben ------
	B_GiveNpcTalents (self);

	// ------ Kampf-Talente ------
	B_SetFightSkills (self, 30);

	// ------ TA anmelden ------
	daily_routine 	= Rtn_Start_15002;
};

FUNC VOID Rtn_Start_15002()
{
	TA_Stand_ArmsCrossed		(08,00,22,00,"NW_CITY_HABOUR_PUFF_ENTRANCE");
    TA_Stand_ArmsCrossed		(22,00,08,00,"NW_CITY_HABOUR_PUFF_ENTRANCE");
};


