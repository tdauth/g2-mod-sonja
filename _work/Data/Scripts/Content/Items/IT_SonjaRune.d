INSTANCE ItRu_SummonSonja	(C_Item)
{
	name 				=	"Sonja herbeirufen";

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	0;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_STONE;

	spell				= 	SPL_SummonSonja;
	mag_circle			=	0;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER_RED";

	description			=	"Sonja herbeirufen";

	TEXT	[0]			=	"Ruft Sonja herbei, wo auch immer sie gerade ist.";
	COUNT	[0]			=	0;

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_Cost_SummonSonja;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};

INSTANCE ItRu_TeleportSonja (C_Item)
{
	name 				=	"Zu Sonja teleportieren";

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	0;

	visual 				=	"ItRu_PalTeleportSecret.3DS";
	material 			=	MAT_STONE;

	spell				= 	SPL_TeleportSonja;
	mag_circle			=	0;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER_RED";

	description			=	"Teleport zu Sonja";

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_Cost_TeleportSonja;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;


};

INSTANCE ItRu_TeleportRoteLaterne (C_Item)
{
	name 				=	"Zur Roten Laterne teleportieren";

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	0;

	visual 				=	"ItRu_PalTeleportSecret.3DS";
	material 			=	MAT_STONE;

	spell				= 	SPL_TeleportRoteLaterne;
	mag_circle			=	0;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER_RED";

	description			=	"Teleport zur Roten Laterne";

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_Cost_TeleportRoteLaterne;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;


};

//**********************************************************************************
//	ItWr_SonjasListMissing
//**********************************************************************************

INSTANCE ItWr_SonjasListMissing		(C_Item)
{
	name 				=	"Sonjas Liste fehlender Kunden";

	mainflag 			=	ITEM_KAT_DOCS;
	flags 				=	ITEM_MISSION;

	value 				=	0;

	visual 				=	"ItWr_Scroll_02.3DS";	//VARIATIONEN: ItWr_Scroll_01.3DS, ItWr_Scroll_02.3DS
	material 			=	MAT_LEATHER;
	on_state[0]			=   Use_SonjasListMissing;
	scemeName			=	"MAP";
	description			= 	name;
};
func void Use_SonjasListMissing ()
{
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;							// DocManager
					Doc_SetPages	( nDocID,  1 	);                         //wieviel Pages
					Doc_SetPage 	( nDocID,  0, "letters.TGA"  , 0 		);
					Doc_SetFont 	( nDocID,  0, FONT_BookHeadline  			); 	// -1 -> all pages
					Doc_SetMargins	( nDocID, -1, 50, 50, 50, 50, 1   		);  //  0 -> margins are in pixels
					Doc_PrintLine	( nDocID,  0, "Liste fehlender Kunden"					);
					Doc_SetFont 	( nDocID,  0, FONT_Book		); 	// -1 -> all pages

					Doc_PrintLine	( nDocID,  0, "Mit diesen Leuten lief bisher noch nichts - Sonja"					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Till - ist mir zu jung!"					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Valentino - bekam ihn nicht hoch, rannte weg."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Borka - fasst uns nicht an, steht auf Kerle."	);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Harad - zu nett."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Bosper - auch zu nett."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Moe - schlägt Leute und wäscht sich nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Ignaz - fand den Eingang nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Alwin - will seine Frau nicht betruegen."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Fellan - hämmern kann er, aber vom Nageln"					);
                    Doc_PrintLine	( nDocID,  0, "versteht er nichts.");

					Doc_Show		( nDocID );

};

//**********************************************************************************
//	ItWr_SonjasListCustomers
//**********************************************************************************

INSTANCE ItWr_SonjasListCustomers		(C_Item)
{
	name 				=	"Sonjas Liste ihrer letzten Kunden";

	mainflag 			=	ITEM_KAT_DOCS;
	flags 				=	ITEM_MISSION;

	value 				=	0;

	visual 				=	"ItWr_Scroll_02.3DS";	//VARIATIONEN: ItWr_Scroll_01.3DS, ItWr_Scroll_02.3DS
	material 			=	MAT_LEATHER;
	on_state[0]			=   Use_SonjasListCustomers;
	scemeName			=	"MAP";
	description			= 	name;
};
func void Use_SonjasListCustomers ()
{
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;							// DocManager
					Doc_SetPages	( nDocID,  1 	);                         //wieviel Pages
					Doc_SetPage 	( nDocID,  0, "letters.TGA"  , 0 		);
					Doc_SetFont 	( nDocID,  0, FONT_BookHeadline  			); 	// -1 -> all pages
					Doc_SetMargins	( nDocID, -1, 50, 50, 50, 50, 1   		);  //  0 -> margins are in pixels
					Doc_PrintLine	( nDocID,  0, "Liste meiner letzten Kunden"					);
					Doc_SetFont 	( nDocID,  0, FONT_Book		); 	// -1 -> all pages

					Doc_PrintLine	( nDocID,  0, "Diese Kunden haben mich zuletzt besucht - Sonja"					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Vatras - erzählt immer etwas von diesem Adanos,"					);
                    Doc_PrintLine	( nDocID,  0, "der uns zusieht."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Lord Hagen - auch ein Diener Innos"					);
                    Doc_PrintLine	( nDocID,  0, " muss bedient werden."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Pyrokar - von seiner Zauberkraft war"	);
                    Doc_PrintLine	( nDocID,  0, "nichts zu spüren.");
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Orlan - in der Hose so tot wie seine Harpyie."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Thorus - endlich ein richtiger Mann."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Daron - ziemlich geizig."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Sarah - aufregend."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Zuris - zu alt."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Abuyin - sah sein Kommen in der Zukunft voraus."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Herold - zu laut."					);

					Doc_Show		( nDocID );

};

//**********************************************************************************
//	ItWr_Womanizer
//**********************************************************************************

INSTANCE ItWr_Womanizer (C_ITEM)
{
	name 					=	"Das Manifest der Aufreißer";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	400;

	visual 					=	"ItWr_Book_02_02.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	description			    =	"Erhöht das Talent Aufreißer um maximal 20%. Die Grenze von 100% kann nicht überschritten werden.";

	scemeName				=	"MAP";
	description				= 	name;
	TEXT[5]					= 	NAME_Value;
	COUNT[5]				= 	value;
	on_state[0]				=	Use_Womanizer;
};

var int Womanizer_once;

FUNC VOID Use_Womanizer()
{
		if (Womanizer_once == FALSE)
		{
            var int realBonus;
            realBonus = 20;

            if (realBonus + Npc_GetTalentSkill(self, NPC_TALENT_WOMANIZER) > 100)
            {
                realBonus = 100 - Npc_GetTalentSkill(self, NPC_TALENT_WOMANIZER);
            };

            // ------ AUFREISSER steigern ------
            Npc_SetTalentSkill (self, NPC_TALENT_WOMANIZER, Npc_GetTalentSkill(self, NPC_TALENT_WOMANIZER) + realBonus);	//Aufreisser
            PrintScreen	("Verbessere: Aufreißen", -1, -1, FONT_Screen, 2);

			Print ("Manifest der Aufreißer gelesen.");
			Womanizer_once = TRUE;
		};
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;								// DocManager
					Doc_SetPages	( nDocID,  2 );                         //wieviel Pages
					Doc_SetPage 	( nDocID,  0, "Book_Mage_L.tga"  , 0 	); // VARIATIONEN: BOOK_BROWN_L.tga , BOOK_MAGE_L.tga , BOOK_RED_L.tga
					Doc_SetPage 	( nDocID,  1, "Book_Mage_R.tga" , 0	); // VARIATIONEN: BOOK_BROWN_R.tga , BOOK_MAGE_R.tga , BOOK_RED_R.tga

					//1.Seite
					Doc_SetFont 	( nDocID,  -1, FONT_Book	   			); 	// -1 -> all pages
 					Doc_SetMargins	( nDocID,  0,  275, 20, 30, 20, 1   		);  //  0 -> margins are in pixels
					Doc_PrintLine	( nDocID,  0, ""					);
					Doc_PrintLines	( nDocID,  0, "...sprich die Person an und frage nach dem Wetter. ");
					//2.Seite
					Doc_SetMargins	( nDocID,  -1, 30, 20, 275, 20, 1   		);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Manchmal klappt es. "	);
					Doc_PrintLines	( nDocID,  1, "- Valentino"	);
					Doc_PrintLine	( nDocID,  1, "");
					Doc_PrintLines	( nDocID,  1, "");
					Doc_Show		( nDocID );
};

//**********************************************************************************
//	ItWr_Pimp
//**********************************************************************************

INSTANCE ItWr_Pimp (C_ITEM)
{
	name 					=	"Zuhälterei für Fortgeschrittene";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	400;

	visual 					=	"ItWr_Book_02_02.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	description			    =	"Erhöht das Talent Zuhälter um einen Kreis. Die Grenze von 6 kann nicht überschritten werden.";

	scemeName				=	"MAP";
	description				= 	name;
	TEXT[5]					= 	NAME_Value;
	COUNT[5]				= 	value;
	on_state[0]				=	Use_Pimp;
};

var int Pimp_once;

FUNC VOID Use_Pimp()
{
		if (Pimp_once == FALSE)
		{
            var int realBonus;
            realBonus = 1;

            if (realBonus + Npc_GetTalentSkill(self, NPC_TALENT_PIMP) > 6)
            {
                realBonus = 6 - Npc_GetTalentSkill(self, NPC_TALENT_PIMP);
            };

            // ------ Pimp steigern ------
            Npc_SetTalentSkill (self, NPC_TALENT_PIMP, Npc_GetTalentSkill(self, NPC_TALENT_PIMP) + realBonus);	//Pimp
            PrintScreen	("Verbessere: Zuhälter", -1, -1, FONT_Screen, 2);

			Print ("Zuhälterei für Fortgeschrittene gelesen.");
			Pimp_once = TRUE;
		};
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;								// DocManager
					Doc_SetPages	( nDocID,  2 );                         //wieviel Pages
					Doc_SetPage 	( nDocID,  0, "Book_Mage_L.tga"  , 0 	); // VARIATIONEN: BOOK_BROWN_L.tga , BOOK_MAGE_L.tga , BOOK_RED_L.tga
					Doc_SetPage 	( nDocID,  1, "Book_Mage_R.tga" , 0	); // VARIATIONEN: BOOK_BROWN_R.tga , BOOK_MAGE_R.tga , BOOK_RED_R.tga

					//1.Seite
					Doc_SetFont 	( nDocID,  -1, FONT_Book	   			); 	// -1 -> all pages
 					Doc_SetMargins	( nDocID,  0,  275, 20, 30, 20, 1   		);  //  0 -> margins are in pixels
					Doc_PrintLine	( nDocID,  0, ""					);
					Doc_PrintLines	( nDocID,  0, "...versprich den Damen Reichtum und nutze sie aus. ");
					//2.Seite
					Doc_SetMargins	( nDocID,  -1, 30, 20, 275, 20, 1   		);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Das Gold hat alles gut gemacht. "	);
					Doc_PrintLines	( nDocID,  1, "- Bromor"	);
					Doc_PrintLine	( nDocID,  1, "");
					Doc_PrintLines	( nDocID,  1, "");
					Doc_Show		( nDocID );
};

const int Value_Sc_SummonDragon = 5000;

INSTANCE ItSc_SummonDragon (C_Item)
{
	name 				=	NAME_Spruchrolle;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	ITEM_MULTI;

	value 				=	Value_Sc_SummonDragon;

	visual				=	"ItSc_Shrink.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_SummonDragon;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_SummonDragon;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};

const int Value_Sc_TrfDragon = 5000;

/*******************************************************************************************/
INSTANCE ItSc_TrfDragon (C_Item)
{
	name 				=	NAME_Spruchrolle;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	ITEM_MULTI;

	value 				=	Value_Sc_TrfDragon;

	visual				=	"ItSc_TrfSheep.3DS";
	material			=	MAT_LEATHER;

	spell			    = 	SPL_TrfDragon;
	cond_atr[2]   		= 	ATR_MANA_MAX;
	cond_value[2]  		= 	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfDragon;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};

//**********************************************************************************
//	ItRu_SummonDragon
//**********************************************************************************

const	int	Value_Ru_SummonDragon				=	2000;

INSTANCE ItRu_SummonDragon (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Ru_SummonDragon;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_STONE;

	spell				= 	SPL_SummonDragon;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER_RED";

	description			=	NAME_SPL_SummonDragon;

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_COST_SUMMONDRAGON;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};

//**********************************************************************************
//	ItRu_TransformDragon
//**********************************************************************************

const	int	Value_Ru_TrfDragon				=	2000;

INSTANCE ItRu_TrfDragon (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Ru_TrfDragon;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_STONE;

	spell				= 	SPL_TrfDragon;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER_RED";

	description			=	NAME_SPL_TrfDragon;

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_Cost_TrfDragon;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};

/*******************************************************************************************/
INSTANCE ItRu_TrfSheep (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfSheep;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell			    = 	SPL_TrfSheep;
	cond_atr[2]   		= 	ATR_MANA_MAX;
	cond_value[2]  		= 	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfSheep;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfScavenger (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfScavenger;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfScavenger;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfScavenger;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfGiantRat (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfGiantrat;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfGiantRat;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfGiantRat;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfGiantBug (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfGiantBug;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfGiantBug;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfGiantBug;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;

};
/*******************************************************************************************/
INSTANCE ItRu_TrfWolf (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfWolf;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfWolf;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			= 	NAME_SPL_TrfWolf;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfWaran (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfWaran;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfWaran;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			= 	NAME_SPL_TrfWaran;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfSnapper (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfSnapper;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfSnapper;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			= NAME_SPL_TrfSnapper;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfWarg (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfWarg;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfWarg;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfWarg;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfFireWaran (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfFireWaran;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfFireWaran;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=  NAME_SPL_TrfFireWaran;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfLurker (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfLurker;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfLurker;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfLurker;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfShadowbeast (C_Item)
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfShadowbeast;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfShadowbeast;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=	NAME_SPL_TrfShadowbeast;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/
INSTANCE ItRu_TrfDragonSnapper (C_Item)//Joly:Auf Dracheninsel in Truhe der Schwarzmagiernovizen
{
	name 				=	NAME_Rune;

	mainflag 			=	ITEM_KAT_RUNE;
	flags 				=	0;

	value 				=	Value_Sc_TrfDragonSnapper;

	visual				=	"ItRu_SumGol.3DS";
	material			=	MAT_LEATHER;

	spell				= 	SPL_TrfDragonSnapper;
	cond_atr[2]   		=	ATR_MANA_MAX;
	cond_value[2]  		=	SPL_Cost_Scroll;

	wear				= 	WEAR_EFFECT;
	effect				=	"SPELLFX_WEAKGLIMMER";

	description			=  NAME_SPL_TrfDragonSnapper;

	TEXT	[0]			=	Name_MageScroll	;

	TEXT	[1]			=	NAME_Mana_needed;
	COUNT	[1]			=	SPL_Cost_Scroll;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
/*******************************************************************************************/

INSTANCE ITWR_Runemaking_Transform (C_ITEM)
{
	name 					=	"Verwandlungsbuch";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	100;

	visual 					=	"ItWr_Book_02_02.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	scemeName				=	"MAP";
	description				= 	"Runenbuch der Verwandlung";
	TEXT[5]					= 	NAME_Value;
	COUNT[5]				= 	value;
	on_state[0]				=	Use_Runemaking_Transform;
};

FUNC VOID Use_Runemaking_Transform()
{
	var C_NPC her; 	her = Hlp_GetNpc(PC_Hero);

	if  (Hlp_GetInstanceID(self) == Hlp_GetInstanceID(her))
	{
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;
					Doc_SetPages	( nDocID,  2 );
					Doc_SetPage 	( nDocID,  0, "Book_Mage_L.tga", 	0 		);
					Doc_SetPage 	( nDocID,  1, "Book_Mage_R.tga",	0		);

					Doc_SetFont 	( nDocID, -1, FONT_Book	   			);
					Doc_SetMargins	( nDocID,  0,  275, 20, 30, 20, 1   		);

					Doc_PrintLine	( nDocID,  0, "VERWANDLUNG"					);
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLines	( nDocID,  0, "Die Runen der Verwandlung und die zu deren Herstellung benötigten Ingredenzien ");
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLine	( nDocID,  0, ""	);

					Doc_PrintLine	( nDocID,  0, "Verwandlung Schaf");
					Doc_PrintLine	( nDocID,  0, "1 Schafsfell");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_PrintLine	( nDocID,  0, "Verwandlung Scavenger");
					Doc_PrintLine	( nDocID,  0, "10 Rohes Fleisch");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_PrintLine	( nDocID,  0, "Verwandlung Riesenratte");
					Doc_PrintLine	( nDocID,  0, "10 Rohes Fleisch");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_PrintLine	( nDocID,  0, "Verwandlung Feldräuber");
					Doc_PrintLine	( nDocID,  0, "2 Feldräuberzangen");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_SetMargins	( nDocID, -1, 30, 20, 275, 20, 1   		);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLine	( nDocID,  1, ""					);

					Doc_PrintLines	( nDocID,  1, "Für die Herstellung einer Rune sind jeweils die aufgeführten Ingredenzien erforderlich."					);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Dem Anwender muss die Formel für den Zauber bekannt sein und er muss einen blanken Runenstein, sowie eine Spruchrolle des jeweiligen Zaubers besitzen."					);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Erst wenn diese Vorraussetzungen erfüllt sind, kann er am Runentisch zu Werke gehen."					);
					Doc_Show		( nDocID );
	};
};

INSTANCE ITWR_Runemaking_Dragon (C_ITEM)
{
	name 					=	"Drachenbuch";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	100;

	visual 					=	"ItWr_Book_02_01.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	scemeName				=	"MAP";
	description				= 	"Runenbuch der Drachen";
	TEXT[5]					= 	NAME_Value;
	COUNT[5]				= 	value;
	on_state[0]				=	Use_Runemaking_Dragon;
};

FUNC VOID Use_Runemaking_Dragon()
{
	var C_NPC her; 	her = Hlp_GetNpc(PC_Hero);

	if  (Hlp_GetInstanceID(self) == Hlp_GetInstanceID(her))
	{
		var int nDocID;

		nDocID = 	Doc_Create		()			  ;
					Doc_SetPages	( nDocID,  2 );
					Doc_SetPage 	( nDocID,  0, "Book_Mage_L.tga", 	0 		);
					Doc_SetPage 	( nDocID,  1, "Book_Mage_R.tga",	0		);

					Doc_SetFont 	( nDocID, -1, FONT_Book	   			);
					Doc_SetMargins	( nDocID,  0,  275, 20, 30, 20, 1   		);

					Doc_PrintLine	( nDocID,  0, "DRACHEN"					);
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLines	( nDocID,  0, "Die Runen der Drachen und die zu deren Herstellung benötigten Ingredenzien ");
					Doc_PrintLine	( nDocID,  0, ""	);
					Doc_PrintLine	( nDocID,  0, ""	);

					Doc_PrintLine	( nDocID,  0, "Drachen beschwören");
					Doc_PrintLine	( nDocID,  0, "1 Drachenschuppe");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_PrintLine	( nDocID,  0, "Verwandlung Drache");
					Doc_PrintLine	( nDocID,  0, "1 Drachenschuppe");
					Doc_PrintLine	( nDocID,  0, "");

					Doc_SetMargins	( nDocID, -1, 30, 20, 275, 20, 1   		);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLine	( nDocID,  1, ""					);

					Doc_PrintLines	( nDocID,  1, "Für die Herstellung einer Rune sind jeweils die aufgeführten Ingredenzien erforderlich."					);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Dem Anwender muss die Formel für den Zauber bekannt sein und er muss einen blanken Runenstein, sowie eine Spruchrolle des jeweiligen Zaubers besitzen."					);
					Doc_PrintLine	( nDocID,  1, ""					);
					Doc_PrintLines	( nDocID,  1, "Erst wenn diese Vorraussetzungen erfüllt sind, kann er am Runentisch zu Werke gehen."					);
					Doc_Show		( nDocID );
	};
};

INSTANCE ITAR_Babe_Leather_L (C_Item)
{
	name 					=	"Lederrüstung";

	mainflag 				=	ITEM_KAT_ARMOR;
	flags 					=	0;

	protection [PROT_EDGE]	=	25;
	protection [PROT_BLUNT] = 	25;
	protection [PROT_POINT] = 	20;
	protection [PROT_FIRE] 	= 	 5;
	protection [PROT_MAGIC] = 	 0;

	value 					=	VALUE_ITAR_Leather_L;

	wear 					=	WEAR_TORSO;

	visual 					=	"ItAr_Leather_L.3ds";
	visual_change 			=	"BAB_ARMOR_LEATHER.ASC";
	visual_skin 			=	0;
	material 				=	MAT_LEATHER;

	on_equip				=	Equip_ITAR_Leather_L;
	on_unequip				=	UnEquip_ITAR_Leather_L;

	description				=	name;

	TEXT[1]					=	NAME_Prot_Edge;
	COUNT[1]				= 	protection	[PROT_EDGE];
	TEXT[2]					=	NAME_Prot_Point;
	COUNT[2]				= 	protection	[PROT_POINT];
	TEXT[3] 				=	NAME_Prot_Fire;
	COUNT[3]				= 	protection	[PROT_FIRE];
	TEXT[4]					=	NAME_Prot_Magic;
	COUNT[4]				= 	protection	[PROT_MAGIC];
	TEXT[5]					=	NAME_Value;
	COUNT[5]				= 	value;
};

INSTANCE ITAR_Babe_DJG_Crawler (C_Item)
{
	name 					=	"Rüstung aus Crawlerplatten";

	mainflag 				=	ITEM_KAT_ARMOR;
	flags 					=	0;

	protection [PROT_EDGE]	=	70;
	protection [PROT_BLUNT] = 	70;
	protection [PROT_POINT] = 	70;
	protection [PROT_FIRE] 	= 	15;
	protection [PROT_MAGIC] = 	0;

	value 					=	VALUE_ITAR_DJG_Crawler;

	wear 					=	WEAR_TORSO;

	visual 					=	"ItAr_Djg_Crawler.3ds";
	visual_change 			=	"DJG_CRW_VEL.ASC";
	visual_skin 			=	0;
	material 				=	MAT_LEATHER;

	on_equip				=	Equip_ITAR_DJG_Crawler;
	on_unequip				=	UnEquip_ITAR_DJG_Crawler;

	description				=	name;

	TEXT[1]					=	NAME_Prot_Edge;
	COUNT[1]				= 	protection	[PROT_EDGE];

	TEXT[2]					=	NAME_Prot_Point;
	COUNT[2]				= 	protection	[PROT_POINT];

	TEXT[3] 				=	NAME_Prot_Fire;
	COUNT[3]				= 	protection	[PROT_FIRE];

	TEXT[4]					=	NAME_Prot_Magic;
	COUNT[4]				= 	protection	[PROT_MAGIC];

	TEXT[5]					=	NAME_Value;
	COUNT[5]				= 	value;
};

INSTANCE ITAR_Babe_KDF_L (C_Item)
{
	name 					=	"Feuermagierrobe";

	mainflag 				=	ITEM_KAT_ARMOR;
	flags 					=	0;

	protection [PROT_EDGE]	=	40;
	protection [PROT_BLUNT] = 	40;
	protection [PROT_POINT] = 	40;
	protection [PROT_FIRE] 	= 	20;
	protection [PROT_MAGIC] = 	20;

	value 					=	VALUE_ITAR_KDF_L;

	wear 					=	WEAR_TORSO;

	visual 					=	"ItAr_KdF_L.3ds";
	visual_change 			=	"KDF_VEL.ASC";
	visual_skin 			=	0;
	material 				=	MAT_LEATHER;

	on_equip				=	Equip_ITAR_KDF_L;
	on_unequip				=	UnEquip_ITAR_KDF_L;

	description				=	name;

	TEXT[1]					=	NAME_Prot_Edge;
	COUNT[1]				= 	protection	[PROT_EDGE];

	TEXT[2]					=	NAME_Prot_Point;
	COUNT[2]				= 	protection	[PROT_POINT];

	TEXT[3] 				=	NAME_Prot_Fire;
	COUNT[3]				= 	protection	[PROT_FIRE];

	TEXT[4]					=	NAME_Prot_Magic;
	COUNT[4]				= 	protection	[PROT_MAGIC];

	TEXT[5]					=	NAME_Value;
	COUNT[5]				= 	value;
};
