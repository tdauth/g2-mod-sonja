
instance VLK_433_Bromor (Npc_Default)
{
	// ------ NSC ------
	name 		= "Bromor"; 
	guild 		= GIL_VLK;
	id 			= 433;
	voice 		= 7;
	flags       = 0;																
	npctype		= NPCTYPE_MAIN;
	
	// ------ Attribute ------
	B_SetAttributesToChapter (self, 4);															
		
	// ------ Kampf-Taktik ------
	fight_tactic		= FAI_HUMAN_STRONG;	
	
	// ------ Equippte Waffen ------																
	EquipItem	(self, ItMw_1h_VLK_Dagger); 
	

	// ------ Inventory ------
	B_CreateAmbientInv 	(self);
	CreateInvItems (self,ItKE_Bromor,1);
		
	// ------ visuals ------																			
	B_SetNpcVisual 		(self, MALE, "Hum_Head_FatBald", Face_N_Fingers, BodyTex_N,ITAR_Vlk_H );	
	Mdl_SetModelFatness	(self,1);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); 
	
	// ------ NSC-relevante Talente vergeben ------
	B_GiveNpcTalents (self);
	
	// ------ Kampf-Talente ------																	
	B_SetFightSkills (self, 45); 

	// ------ TA anmelden ------
	daily_routine 		= Rtn_Start_433;
};

//Joly: NIE AUF EINE BANK ODER THRON SETZEN
FUNC VOID Rtn_Start_433()
{	
	TA_Stand_ArmsCrossed	(08,00,20,00,"NW_CITY_PUFF_COUNTER");
    TA_Stand_ArmsCrossed	(20,00,08,00,"NW_CITY_PUFF_COUNTER");
};

FUNC VOID Rtn_NewLife_433 ()
{
	TA_Sleep		(22,00,08,00,"NW_CITY_GERBRANDT_BED_01");

	TA_Smalltalk	(08,00,11,00,"NW_CITY_SMALLTALK_02");
    TA_Sit_Bench 	(11,00,15,00,"NW_CITY_UPTOWN_PATH_23_B");
    TA_Smalltalk	(15,00,18,00,"NW_CITY_SMALLTALK_02");
	TA_Sit_Bench 	(18,00,22,00,"NW_CITY_UPTOWN_PATH_23_B");
};
