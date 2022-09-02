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

//**********************************************************************************
//	ItRu_SummonDragon
//**********************************************************************************

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
	TEXT	[0]			=	NAME_Mag_Circle;
	COUNT	[0]			=	mag_circle;

	TEXT	[1]			=	NAME_Manakosten;
	COUNT	[1]			=	SPL_COST_SUMMONDRAGON;

	TEXT	[5]			=	NAME_Value;
	COUNT	[5]			=	value;
};
