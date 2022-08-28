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
                    Doc_PrintLine	( nDocID,  0, "Moe - schlaegt Leute und waescht sich nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Ignaz - fand den Eingang nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Alwin - will seine Frau nicht betruegen."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Fellan - haemmern kann er, aber vom Nageln versteht er nichts."					);

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
                    Doc_PrintLine	( nDocID,  0, "Vatras - erzaehlt immer etwas von diesem Adanos, der uns zusieht."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Lord Hagen - auch ein Diener Innos muss bedient werden."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Pyrokar - von seiner Zauberkraft war nichts zu spueren."	);
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
