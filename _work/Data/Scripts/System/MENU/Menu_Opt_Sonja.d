INSTANCE MYPATCH_MENU(C_MENU_DEF) // <-- The actual Menu for your Patch
{
    backpic		= PATCHMENU_BACK_PIC;

    items[0]	= "MYPATCH_MENU_HEADING";

    items[1]	= "MENUITEM_OPT_BACK";

    defaultOutGame	= 0;	// PERFORMANCE-SETTINGS
    defaultInGame	= 0;	// PERFORMANCE-SETTINGS

    flags = flags | MENU_SHOW_INFO;
};

INSTANCE MYPATCH_MENU_HEADING(C_MENU_ITEM_DEF) // <-- Heading for your patches Menu
{
    text[0]		=	"Sonja";
    type		=	MENU_ITEM_TEXT;
    // Position und Dimension
    posx		=	0;		posy		=	0;
    dimx		=	8192;

    flags		= flags & ~IT_SELECTABLE;
    flags		= flags | IT_TXT_CENTER;
};


INSTANCE MYPATCH_MENU_OPEN(C_MENU_ITEM) // <-- Entry added to PatchMenu
{
    backpic		= PATCHMENU_ITEM_BACK_PIC;

    fontName	= PATCHMENU_PATCH_FONT;
    text[0]		= "Sonja";
    text[1]		= "Sonja einstellen";

    alphaMode		=	"BLEND";
    alpha			=	254;
    type			=	MENU_ITEM_TEXT;
    // Position und Dimension
    posx = PATCHMENU_PATCHES_COL3;  posy = 1200 + 350 * 0; // 1200 -> XPos, 350 Font Height, will be overriden by PatchMenu
    dimx = 2048; // maximum supported width, will be overriden by PatchMenu
    dimy = 350;  // Font Height, will be overriden by PatchMenu

    flags			=	IT_CHROMAKEYED|IT_TRANSPARENT|IT_SELECTABLE|IT_TXT_CENTER;

    openDelayTime	=	0;
    openDuration	=	-1;

    sizeStartScale  = 	1;

    userFloat[0]    =	100;
    userFloat[1]	=	200;

    onChgSetOption  			=	"";
    onChgSetOptionSection 		= "INTERNAL";
    hideIfOptionSectionSet		= "";
    hideIfOptionSet				= "";
    hideOnValue					= -1;

    frameSizeX		= 0;
    frameSizeY		= 0;

        // Aktionen
    onSelAction[0]	= SEL_ACTION_STARTMENU;
    onSelAction_S[0]= "MYPATCH_MENU";
    onSelAction_S[0]= "MYPATCH_MENU";
};
