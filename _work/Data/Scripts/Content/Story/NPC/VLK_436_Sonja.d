
instance VLK_436_Sonja (Npc_Default)
{
	// ------ NSC ------
	name 		= "Sonja";	
	guild 		= GIL_VLK;
	id 			= 436;
	voice 		= 16;
	flags       = NPC_FLAG_IMMORTAL;	//Joly: NPC_FLAG_IMMORTAL
	npctype		= NPCTYPE_MAIN;
	
	//-----------AIVARS----------------
	aivar[AIV_ToughGuy] = TRUE; 
	
	// ------ Attribute ------
	B_SetAttributesToChapter (self, 1);
	// Sonja Mod: 1000 ist ein bisschen zu viel Mana.
    slf.attribute[ATR_MANA_MAX] 		= 90;
    slf.aivar[REAL_MANA_MAX]			= 90;
    slf.attribute[ATR_MANA] 			= 90;
		
	// ------ Kampf-Taktik ------
	fight_tactic		= FAI_HUMAN_COWARD;
	
	// ------ Equippte Waffen ------																	
	
	
	
	// ------ Inventory ------
	B_CreateAmbientInv 	(self);

		
	// ------ visuals ------																			
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe6", FaceBabe_L_Charlotte2, BodyTexBabe_L, ITAR_VlkBabe_H);	

	Mdl_SetModelFatness	(self,0);
	Mdl_ApplyOverlayMds	(self, "Humans_Babe.mds"); 
	
	// ------ NSC-relevante Talente vergeben ------
	B_GiveNpcTalents (self);
	// Sonja soll noch etwas vom Helden lernen.
	Npc_SetTalentSkill	(self, NPC_TALENT_MAGE, 			0);
	Npc_SetTalentSkill	(self, NPC_TALENT_WOMANIZER, 		100);
	Npc_SetTalentSkill	(self, NPC_TALENT_PIMP, 			6);

	// ------ Sonstige Talente ------
	Npc_SetTalentSkill	(self, NPC_TALENT_PICKLOCK, 		0); //hängt ab von DEX (auf Programmebene)
	Npc_SetTalentSkill	(self, NPC_TALENT_SNEAK, 			0);
	Npc_SetTalentSkill	(self, NPC_TALENT_ACROBAT, 			0);

	Npc_SetTalentSkill	(self, NPC_TALENT_PICKPOCKET, 		0);	//hängt ab von DEX (auf Scriptebene)
	Npc_SetTalentSkill	(self, NPC_TALENT_SMITH, 			0);
	Npc_SetTalentSkill	(self, NPC_TALENT_RUNES, 			0);
	Npc_SetTalentSkill	(self, NPC_TALENT_ALCHEMY, 			0);
	Npc_SetTalentSkill	(self, NPC_TALENT_TAKEANIMALTROPHY,	0);
	
	// ------ Kampf-Talente ------																	
	B_SetFightSkills (self, 30); 

	// ------ TA anmelden ------
	daily_routine 		= Rtn_Start_436;
};

FUNC VOID Rtn_Start_436 ()
{	
	TA_Sit_Throne	(08,00,23,00,"NW_CITY_PUFF_THRONE"); 
    TA_Sit_Throne	(23,00,08,00,"NW_CITY_PUFF_THRONE");
};

FUNC VOID Rtn_StartOldWorld_436 ()
{
    TA_Stand_Guarding		(08,00,23,00,"OC_CENTER_GUARD_03");
    TA_Stand_Guarding		(23,00,08,00,"OC_CENTER_GUARD_03");
};

FUNC VOID Rtn_StartAddOnWorld_436 ()
{
    TA_Stand_Guarding		(08,00,23,00,"ADW_ENTRANCE");
    TA_Stand_Guarding		(23,00,08,00,"ADW_ENTRANCE");
};

FUNC VOID Rtn_StartDragonIsland_436 ()
{
    TA_Stand_Guarding		(08,00,23,00,"SHIP");
    TA_Stand_Guarding		(23,00,08,00,"SHIP");
};

FUNC VOID Rtn_Follow_436 ()
{
	TA_Follow_Player (08,00,20,00,"NW_CITY_PUFF_THRONE");
	TA_Follow_Player (20,00,08,00,"NW_CITY_PUFF_THRONE");
};

FUNC VOID Rtn_FollowOldWorld_436 ()
{
	TA_Follow_Player (08,00,20,00,"OC_CENTER_GUARD_03");
	TA_Follow_Player (20,00,08,00,"OC_CENTER_GUARD_03");
};

FUNC VOID Rtn_FollowAddOnWorld_436 ()
{
	TA_Follow_Player (08,00,20,00,"ADW_ENTRANCE");
	TA_Follow_Player (20,00,08,00,"ADW_ENTRANCE");
};

FUNC VOID Rtn_FollowDragonIsland_436 ()
{
	TA_Follow_Player (08,00,20,00,"SHIP");
	TA_Follow_Player (20,00,08,00,"SHIP");
};

FUNC VOID Rtn_Wait_436 ()
{
	var string wpName;
	wpName = Npc_GetNearestWP(self);
	TA_Stand_Guarding (08,00,20,00,wpName);
	TA_Stand_Guarding (20,00,08,00,wpName);
};

FUNC VOID Rtn_Pee_436 ()
{
	var string wpName;
	wpName = Npc_GetNearestWP(self);
    TA_Pee				(0, 0, 23, 59, wpName);
};

FUNC VOID Rtn_Dance_436 ()
{
    var string wpName;
	wpName = Npc_GetNearestWP(self);
    TA_Dance				(0, 0, 23, 59, wpName);
};

FUNC VOID Rtn_Vatras_436 ()
{
    TA_Dance				(0, 0, 23, 59, "MARKT");
};

FUNC VOID Rtn_Pyrokar_436 ()
{
    TA_Dance				(0, 0, 23, 59, "KLOSTER");
};

FUNC VOID Rtn_Xardas_436 ()
{
    TA_Dance				(0, 0, 23, 59, "XARDAS");
};

FUNC VOID Rtn_Lee_436 ()
{
    TA_Dance				(0, 0, 23, 59, "BIGFARM");
};

FUNC VOID Rtn_Orlan_436 ()
{
    TA_Dance				(0, 0, 23, 59, "TAVERNE");
};
