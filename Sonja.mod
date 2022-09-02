PSVDSC_V2.00

@   "   Q�"U� (  P   TOOLS                                                                     �    _WORK                                                                     �    NINJA                                                                     �    ITEMMAP                                                                   �    PATCHMENU                                                                 �    CONTENT                                                                   �    COLORS.D                                                        (  `          CONST.D                                                         �$  -          CORE.D                                                          �(  �6          NINJAINIT.D                                                     �_  -          TOGGLE.D                                                        �k  ]     @    CONTENT                                                                   �    SYSTEM                                                                    �    PATCHMENU.D                                                       �     @    MENU                                                                      �    MENU_DEFINES_PATCH.D                                            ΍  4          MENU_OPT_PATCH.D                                                �  �     @    DATA                                                                      �    SCRIPTS                                                                   �    CONTENT                                                                   �    SYSTEM                                                          <          �    AI                                                                        �    ITEMS                                                           $          �    STORY                                                           %          �    _INTERN                                                         ;          �    AI_INTERN                                                                 �    HUMAN                                                                     �    MAGIC                                                                     �    AI_CONSTANTS.D                                                  ��  �y     @    ZS_HUMAN                                                                  �    ZS_TALK.D                                                       j �     @    SPELLS                                                          !          �    SPELL_PROCESSMANA.D                                             ?a ~#     @    SPELL_SUMMONDRAGON.D                                            [, �          SPELL_SUMMONSONJA.D                                             C0 |          SPELL_TELEPORT_ALLE.D                                           �4 �,     @    IT_SONJARUNE.D                                                  �� R2     @    B_ASSIGNAMBIENTINFOS                                            -          �    B_GIVETRADEINV                                                  0          �    B_STORY                                                         1          �    DIALOGE                                                         6          �    NPC                                                             7          �    NPC_GLOBALS.D                                                   `M `]          STARTUP.D                                                       �� ��         TEXT.D                                                          A� S�     @    B_AAA_ASSIGNSONJA.D                                             � �          B_AAA_AUFREISSEN.D                                              �� V          B_AAA_PIMP.D                                                    �� u     @    B_GIVETRADEINV_SONJA.D                                          b� �     @    B_AAA_APPLYSONJASTATS.D                                         A�           B_ENTER_DRAGONISLAND.D                                          X� 1          B_ENTER_SONJAWORLD.D                                            o, ~          B_GIVEPLAYERXP.D                                                �. �          B_TEACHATTRIBUTEPOINTS.D                                        t; }     @    DIA_VLK_436_SONJA.D                                             �F @�    @    MONSTER                                                         9          �    VLK_436_SONJA.D                                                 �= �     @    MST_DRAGON_SONJA.D                                              1, 
          MST_MEATBUG.D                                                   ;3 o
     @    CONSTANTS.D                                                     �r 1�     @    MENU                                                            >          �    VISUALFX                                                        ?          �    MENU_STATUS.D                                                   �	 5P     @    VISUALFXINST.D                                                  �^	 4X    @    /*
 * Determine a color by item type
 */
func int Ninja_ItemMap_GetItemColor(var int mainflag) {
    const int categories[Ninja_ItemMap_NumItemCat] = {
        /*ITEM_KAT_NF*/      (1 <<  1) | /*ITEM_KAT_FF*/ (1 << 2) | /*ITEM_KAT_MUN*/ (1 << 3), // INV_WEAPON  COMBAT
        /*ITEM_KAT_ARMOR*/   (1 <<  4),                                                        // INV_ARMOR   ARMOR
        /*ITEM_KAT_RUNE*/    (1 <<  9),                                                        // INV_RUNE    RUNE
        /*ITEM_KAT_MAGIC*/   (1 << 31),                                                        // INV_MAGIC   MAGIC
        /*ITEM_KAT_FOOD*/    (1 <<  5),                                                        // INV_FOOD    FOOD
        /*ITEM_KAT_POTIONS*/ (1 <<  7),                                                        // INV_POTION  POTION
        /*ITEM_KAT_DOCS*/    (1 <<  6),                                                        // INV_DOC     DOCS
        /*ITEM_KAT_NONE*/    (1 <<  0) | /*ITEM_KAT_LIGHT*/ (1 <<  8)                          // INV_MISC    OTHER
    };

    // Match category
    repeat(i, Ninja_ItemMap_NumItemCat); var int i;
        if (mainflag & MEM_ReadStatArr(_@(categories), i)) {
            return MEM_ReadStatArr(_@(Ninja_ItemMap_Colors), i);
        };
    end;

    // Should never be reached
    return -1;
};

/*
 * Fix function from Ikarus: Based on MEMINT_ByteToKeyHex
 * Taken from https://forum.worldofplayers.de/forum/threads/?p=25717007
 */
func string Ninja_ItemMap_Byte2hex(var int byte) {
    const int ASCII_0 = 48;
    const int ASCII_A = 65;
    byte = byte & 255;

    // Fix ASCII characters (A to F)
    var int c1; c1 = (byte >> 4);
    if (c1 >= 10) {
        c1 += ASCII_A-ASCII_0-10;
    };
    var int c2; c2 = (byte & 15);
    if (c2 >= 10) {
        c2 += ASCII_A-ASCII_0-10;
    };

    const int mem = 0;
    if (!mem) { mem = MEM_Alloc(3); };

    MEM_WriteByte(mem    , c1 + ASCII_0);
    MEM_WriteByte(mem + 1, c2 + ASCII_0);
    return STR_FromChar(mem);
};
func int Ninja_ItemMap_Hex2Bytes(var int c) {
    const int ASCII_Ac = 65;
    const int ASCII_a = 97;
    const int ASCII_0 = 48;
    if (c >= ASCII_0 && c < ASCII_0 + 10) {
        return c - ASCII_0;
    } else if (c >= ASCII_a && c < ASCII_a + 6) {
        return 10 + c - ASCII_a;
    } else if (c >= ASCII_Ac && c < ASCII_Ac + 6) {
        return 10 + c - ASCII_Ac;
    } else {
        MEM_Error(ConcatStrings("Invalid Hex Char: ", IntToString(c)));
        return 0;
    };
};

/*
 * Read/write color values from/to Gothic.ini
 */
func int Ninja_ItemMap_ReadColor(var string value, var int default) {
    var string entry; entry = MEM_GetGothOpt("ITEMMAP", value);
    var zString str; str = _^(_@s(entry));

    if (str.len != 7) {

        // Mark to skip
        if (Hlp_StrCmp(entry, "0")) || (Hlp_StrCmp(entry, "FALSE")) {
            return 255<<24;
        };

        // Write default value to INI
        if (default == (255<<24)) {
            entry = "FALSE";
        } else {
            entry = "#";
            entry = ConcatStrings(entry, Ninja_ItemMap_Byte2hex(default>>16));
            entry = ConcatStrings(entry, Ninja_ItemMap_Byte2hex(default>>8));
            entry = ConcatStrings(entry, Ninja_ItemMap_Byte2hex(default));
        };
        MEM_SetGothOpt("ITEMMAP", value, entry);
        return default;
    };

    var int res; res = 0;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 1)) << 20;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 2)) << 16;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 3)) << 12;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 4)) << 8;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 5)) << 4;
    res += Ninja_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 6));

    return res;
};
/* Toggle state */
var   int    Ninja_ItemMap_State;

/* Marker texture name and pointer (cache) */
const string Ninja_ItemMap_TexName    = "NINJA_ITEMMAP_MARKER.TGA";
const int    Ninja_ItemMap_TexNamePtr = 0;
const int    Ninja_ItemMap_CoordShift = 0;
const int    Ninja_ItemMap_MarkerSize = 8;

/* Minimum item value (default) */
const int    Ninja_ItemMap_MinValue   = 0;

/* Maximum item radius (default) */
const int    Ninja_ItemMap_Radius     = -1;

/* Color table (defaults) */
const int    Ninja_ItemMap_NumItemCat = 8; // INV_CAT_MAX-1
const int    Ninja_ItemMap_NumColors  = Ninja_ItemMap_NumItemCat+1;
const int    Ninja_ItemMap_Colors[Ninja_ItemMap_NumColors] = {
    14826792, // COMBAT #E23D28 red
    16744192, // ARMOR  #FF7F00 orange
    16515324, // RUNE   #FC00FC purple
    16775680, // MAGIC  #FFFA00 yellow
    54104,    // FOOD   #00D358 green
    49151,    // POTION #00BFFF blue
    16577461, // DOCS   #FCF3B5 faint yellow/white
    9013641,  // OTHER  #898989 dark gray
    8343854   // CHEST  #7F512E brown
};
/*
 * Find all items in the current world
 */
func int Ninja_ItemMap_GetItems(var int classDef, var int arrPtr) {
    const int zCWorld__SearchVobListByBaseClass_G1 = 6250016; //0x5F5E20
    const int zCWorld__SearchVobListByBaseClass_G2 = 6439712; //0x624320

    var int vobTreePtr; vobTreePtr = _@(MEM_Vobtree);
    var int worldPtr;   worldPtr   = _@(MEM_World);
    if (!arrPtr) {
        arrPtr = MEM_ArrayCreate();
    };

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobTreePtr));
        CALL_PtrParam(_@(arrPtr));
        CALL_PtrParam(_@(classDef));
        CALL__thiscall(_@(worldPtr), MEMINT_SwitchG1G2(zCWorld__SearchVobListByBaseClass_G1,
                                                       zCWorld__SearchVobListByBaseClass_G2));
        call = CALL_End();
    };

    return arrPtr;
};

/*
 * Draw a marker into the parent document
 */
func void Ninja_ItemMap_DrawObject(var int parentPtr, var int x, var int y, var int color) {
    const int zCViewFX__Init_G1                 = 7684128; //0x754020
    const int zCViewFX__Init_G2                 = 6884192; //0x690B60
    const int zCViewObject__SetPixelSize_G1     = 7689744; //0x755610
    const int zCViewObject__SetPixelSize_G2     = 6889824; //0x692160
    const int zCViewObject__SetPixelPosition_G1 = 7689040; //0x755350
    const int zCViewObject__SetPixelPosition_G2 = 6889120; //0x691EA0
    const int zCViewDraw__SetTextureColor_G1    = 7681456; //0x7535B0
    const int zCViewDraw__SetTextureColor_G2    = 6881408; //0x690080
    const int oCViewDocument__oCViewDocument_G1 = 7491936; //0x725160
    const int oCViewDocument__oCViewDocument_G2 = 6866464; //0x68C620
    const int oCViewDocument__scal_del_destr_G1 = 7491888; //0x725130
    const int oCViewDocument__scal_del_destr_G2 = 6866416; //0x68C5F0
    const int oCViewDocument__SetTexture_G1     = 7493872; //0x7258F0
    const int oCViewDocument__SetTexture_G2     = 6868272; //0x68CD30

    // Arguments for the following function calls
    var int open; open = !Ninja_ItemMap_State;
    const int effect = 1; // Zoom
    const int duration = 1133903872; // 300.0f
    const int colorPtr = 0;
    const int sizePtr = 0;
    const int posPtr = 0;

    // Marker size
    var int size[2];
    size[0] = Ninja_ItemMap_MarkerSize;
    size[1] = Ninja_ItemMap_MarkerSize;

    // Centered
    var int pos[2];
    pos[0] = x - Ninja_ItemMap_MarkerSize/2;
    pos[1] = y - Ninja_ItemMap_MarkerSize/2;

    // Create new oCViewDocument object
    var int viewPtr; viewPtr = MEM_Alloc(252);

    const int call = 0;
    if (CALL_Begin(call)) {
        colorPtr = _@(color);
        sizePtr = _@(size);
        posPtr = _@(pos);

        CALL__thiscall(_@(viewPtr), MEMINT_SwitchG1G2(oCViewDocument__oCViewDocument_G1,
                                                      oCViewDocument__oCViewDocument_G2));

        CALL_PtrParam(_@(Ninja_ItemMap_TexNamePtr));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(open));
        CALL__fastcall(_@(viewPtr), _@(parentPtr), MEMINT_SwitchG1G2(zCViewFX__Init_G1, zCViewFX__Init_G2));

        CALL_IntParam(_@(FALSE));
        CALL__fastcall(_@(viewPtr), _@(Ninja_ItemMap_TexNamePtr), MEMINT_SwitchG1G2(oCViewDocument__SetTexture_G1,
                                                                                    oCViewDocument__SetTexture_G2));

        CALL__fastcall(_@(viewPtr), _@(colorPtr), MEMINT_SwitchG1G2(zCViewDraw__SetTextureColor_G1,
                                                                    zCViewDraw__SetTextureColor_G2));

        CALL__fastcall(_@(viewPtr), _@(sizePtr), MEMINT_SwitchG1G2(zCViewObject__SetPixelSize_G1,
                                                                   zCViewObject__SetPixelSize_G2));

        CALL__fastcall(_@(viewPtr), _@(posPtr), MEMINT_SwitchG1G2(zCViewObject__SetPixelPosition_G1,
                                                                  zCViewObject__SetPixelPosition_G2));
        call = CALL_End();
    };

    // I no longer refer to the object (it's in its parent's hands now)
    var int refCtr; refCtr = MEM_ReadInt(viewPtr+4); // zCObject.refCtr
    refCtr -= 1;
    MEM_WriteInt(viewPtr+4, refCtr);
    if (refCtr <= 0) {
        // Let's do this properly (although this should never be reached)
        const int call2 = 0;
        if (CALL_Begin(call2)) {
            CALL_IntParam(_@(TRUE));
            CALL__thiscall(_@(viewPtr), MEMINT_SwitchG1G2(oCViewDocument__scal_del_destr_G1,
                                                          oCViewDocument__scal_del_destr_G2));
            call2 = CALL_End();
        };
    };
};

/*
 * Find items/containers and draw them onto the map
 */
func void Ninja_ItemMap_AddItems() {
    const int oCItem__classDef_G1         =  9284224; //0x8DAA80
    const int oCItem__classDef_G2         = 11211112; //0xAB1168
    const int oCMobContainer__classDef_G1 =  9285504; //0x8DAF80
    const int oCMobContainer__classDef_G2 = 11212976; //0xAB18B0

    // If state is hidden, do not draw them yet
    if (Ninja_ItemMap_State) {
        return;
    };

    // Obtain map document
    var int docPtr; docPtr = EDI;

    // Obtain world coordinates
    var int wldPos[4]; MEM_Clear(_@(wldPos), 16); // Clear pseudo-locals
    if (GOTHIC_BASE_VERSION == 2) {
        // Gothic 2 allows to provide the coordinates from script with Doc_SetLevelCoords
        var int levelPos; levelPos = docPtr+528;
        wldPos[0] = MEM_ReadIntArray(levelPos, 0);
        wldPos[1] = MEM_ReadIntArray(levelPos, 3);
        wldPos[2] = MEM_ReadIntArray(levelPos, 2);
        wldPos[3] = MEM_ReadIntArray(levelPos, 1);
    };

    // Or obtain world coordinates from world mesh
    var int empty[4];
    if (MEM_CompareWords(_@(wldPos), _@(empty), 4)) {
        var int bbox; bbox = MEM_World.bspTree_bspRoot+4;
        wldPos[0] = MEM_ReadIntArray(bbox, 0);
        wldPos[1] = MEM_ReadIntArray(bbox, 2);
        wldPos[2] = MEM_ReadIntArray(bbox, 3);
        wldPos[3] = MEM_ReadIntArray(bbox, 5);
    };

    // Obtain map view dimensions
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504);
    var int docDim[4]; MEM_CopyWords(mapViewPtr+56, _@(docDim), 4);  // zCViewObject.posPixel and zCViewObject.sizepixel
    var int docCntr[2];
    docCntr[0] = fracf(docDim[0]*2 + docDim[2], 2);
    docCntr[1] = fracf(docDim[1]*2 + docDim[3], 2);

    // Create coordinate translations
    var int wld2map[2]; var int wldDim[2];
    wldDim[0] = subf(wldPos[2], wldPos[0]);
    wldDim[1] = subf(wldPos[3], wldPos[1]);
    wld2map[0] = divf(mkf(docDim[2]), wldDim[0]);
    wld2map[1] = divf(mkf(docDim[3]), wldDim[1]);
    if (GOTHIC_BASE_VERSION == 1) {
        wld2map[1] = negf(wld2map[1]);
    };

    // Drawing properties
    var int color;
    var int x; var int y;

    // Get hero to obtain current map item later
    var oCNpc her; her = Hlp_GetNpc(hero);
    var int herPos[2]; var int diff[2];
    herPos[0] = truncf(her._zCVob_trafoObjToWorld[ 3]) / 100;
    herPos[1] = truncf(her._zCVob_trafoObjToWorld[11]) / 100;

    // Obtain items
    var int arrPtr; arrPtr = Ninja_ItemMap_GetItems(MEMINT_SwitchG1G2(oCItem__classDef_G1, oCItem__classDef_G2), 0);

    // Iterate over items and add them to the map
    repeat(i, MEM_ArraySize(arrPtr)); var int i;
        var int itmPtr; itmPtr = MEM_ArrayRead(arrPtr, i);
        if (Hlp_Is_oCItem(itmPtr)) {
            // Skip the map item that is currently in use
            if (itmPtr == her.interactItem) {
                continue;
            };

            var oCItem itm; itm = _^(itmPtr);

            // Skip items of low value
            if (itm.value < Ninja_ItemMap_MinValue) {
                continue;
            };

            // Skip non-focusable items (items in use by NPC)
            if ((itm.flags & /*ITEM_NFOCUS (1<<23)*/ 8388608) == 8388608) {
                continue;
            };

            // Skip invalid items
            if (itm.instanz < 0) {
                continue;
            };

            // Determine color (or exclude)
            color = Ninja_ItemMap_GetItemColor(itm.mainflag);
            if (color == (255<<24)) {
                continue;
            };

            // Get item world position
            var int itmPos[2];
            itmPos[0] = itm._zCVob_trafoObjToWorld[ 3];
            itmPos[1] = itm._zCVob_trafoObjToWorld[11];

            // Exclude by distance
            if (Ninja_ItemMap_Radius > 0) {
                diff[0] = truncf(itmPos[0])/100 - herPos[0];
                diff[1] = truncf(itmPos[1])/100 - herPos[1];
                diff = diff[0] * diff[0] + diff[1] * diff[1];
                if (diff > Ninja_ItemMap_Radius) {
                    continue;
                };
            };

            // Calculate map position
            if (GOTHIC_BASE_VERSION == 1) {
                x = roundf(addf(mulf(wld2map[0], itmPos[0]), docCntr[0]));
                y = roundf(addf(mulf(wld2map[1], itmPos[1]), docCntr[1]));
            } else {
                x =             roundf(mulf(wld2map[0], subf(itmPos[0], wldPos[0]))) + docDim[0];
                y = docDim[3] - roundf(mulf(wld2map[1], subf(itmPos[1], wldPos[1]))) + docDim[1];
            };

            // Account for displacement in the coordinates
            x += Ninja_ItemMap_CoordShift;
            y += Ninja_ItemMap_CoordShift;

            // Create new view and place it on the map
            Ninja_ItemMap_DrawObject(mapViewPtr, x, y, color);
        };
    end;

    // Check if also containers are requested
    if (Ninja_ItemMap_Colors[8] != (255<<24)) {
        // Collect all containers in the world
        MEM_ArrayClear(arrPtr);
        arrPtr = Ninja_ItemMap_GetItems(MEMINT_SwitchG1G2(oCMobContainer__classDef_G1,
                                                          oCMobContainer__classDef_G2), arrPtr);

        // Iterate over containers and add them to the map
        color = Ninja_ItemMap_Colors[8];
        repeat(i, MEM_ArraySize(arrPtr));
            var int containerPtr; containerPtr = MEM_ArrayRead(arrPtr, i);
            if (Hlp_Is_oCMobContainer(containerPtr)) {
                var oCMobContainer container; container = _^(containerPtr);

                // Skip if already looted (empty)
                if (!container.containList_next) {
                    continue;
                };

                // Get container world position
                var int containerPos[2];
                containerPos[0] = container._zCVob_trafoObjToWorld[ 3];
                containerPos[1] = container._zCVob_trafoObjToWorld[11];

                // Exclude by distance
                if (Ninja_ItemMap_Radius > 0) {
                    diff[0] = truncf(containerPos[0])/100 - herPos[0];
                    diff[1] = truncf(containerPos[1])/100 - herPos[1];
                    diff = diff[0] * diff[0] + diff[1] * diff[1];
                    if (diff > Ninja_ItemMap_Radius) {
                        continue;
                    };
                };

                // Calculate map position
                if (GOTHIC_BASE_VERSION == 1) {
                    x = roundf(addf(mulf(wld2map[0], containerPos[0]), docCntr[0]));
                    y = roundf(addf(mulf(wld2map[1], containerPos[1]), docCntr[1]));
                } else {
                    x =             roundf(mulf(wld2map[0], subf(containerPos[0], wldPos[0]))) + docDim[0];
                    y = docDim[3] - roundf(mulf(wld2map[1], subf(containerPos[1], wldPos[1]))) + docDim[1];
                };

                // Account for displacement in the coordinates
                x += Ninja_ItemMap_CoordShift;
                y += Ninja_ItemMap_CoordShift;

                // Create new view and place it on the map
                Ninja_ItemMap_DrawObject(mapViewPtr, x, y, color);
            };
        end;
    };

    MEM_ArrayFree(arrPtr);
};

/*
 * Obtain the size of the player position marker (only called once, therefore no recyclable calls)
 * This functions helps to deal with the incorrectly centered player position marker
 */
func int Ninja_ItemMap_GetTexSize(var string texture) {
    const int zCTexture__Load_G1           = 6064880; //0x5C8AF0
    const int zCTexture__Load_G2           = 6239904; //0x5F36A0
    const int zCTexture__GetPixelSize_G1   = 6081488; //0x5CCBD0
    const int zCTexture__GetPixelSize_G2   = 6257680; //0x5F7C10
    const int zCTexture__scal_del_destr_G1 = 6064272; //0x5C8890
    const int zCTexture__scal_del_destr_G2 = 6239296; //0x5F3440

    // Retrieve (or load) one of the marker textures
    var int texPtr;
    CALL_IntParam(1); // Loading flag
    CALL_zStringPtrParam(texture);
    CALL_PutRetValTo(_@(texPtr));
    CALL__cdecl(MEMINT_SwitchG1G2(zCTexture__Load_G1, zCTexture__Load_G2));

    // Retrieve its dimensions
    CALL_PtrParam(_@(ret));
    CALL_PtrParam(_@(ret));
    CALL__thiscall(texPtr, MEMINT_SwitchG1G2(zCTexture__GetPixelSize_G1, zCTexture__GetPixelSize_G2));

    // Dereference (and possibly delete) the texture again
    var int refCtr; refCtr = MEM_ReadInt(texPtr+4); // zCObject.refCtr
    refCtr -= 1;
    MEM_WriteInt(texPtr+4, refCtr);
    if (refCtr <= 0) {
        CALL_IntParam(1);
        CALL__thiscall(texPtr, MEMINT_SwitchG1G2(zCTexture__scal_del_destr_G1, zCTexture__scal_del_destr_G2));
    };

    var int ret;
    return +ret;
};
func int Ninja_ItemMap_GetPositionMarkerSize() {
    return Ninja_ItemMap_GetTexSize("L.TGA");
};
func int Ninja_ItemMap_GetItemMarkerSize() {
    return Ninja_ItemMap_GetTexSize(Ninja_ItemMap_TexName);
};
/*
 * Menu initialization function called by Ninja every time a menu is opened
 */
func void Ninja_ItemMap_Menu() {
    // Only on game start
    const int once = 0;
    if (once) {
        return;
    };
    once = 1;

    // This code is only reached once: Do one-time initializations here
    MEM_InitAll();

    MEM_Info("ItemMap: Initializing entries in Gothic.ini.");

    if (!MEM_GothOptExists("ITEMMAP", "radius")) {
        MEM_SetGothOpt("ITEMMAP", "radius", "-1");
    };
    if (!MEM_GothOptExists("ITEMMAP", "minValue")) {
        MEM_SetGothOpt("ITEMMAP", "minValue", "0");
    };
    Ninja_ItemMap_Radius = STR_ToInt(MEM_GetGothOpt("ITEMMAP", "radius"));
    Ninja_ItemMap_MinValue = STR_ToInt(MEM_GetGothOpt("ITEMMAP", "minValue"));
    Ninja_ItemMap_Colors[0] = Ninja_ItemMap_ReadColor("combat", Ninja_ItemMap_Colors[0]);
    Ninja_ItemMap_Colors[1] = Ninja_ItemMap_ReadColor("armor",  Ninja_ItemMap_Colors[1]);
    Ninja_ItemMap_Colors[2] = Ninja_ItemMap_ReadColor("rune",   Ninja_ItemMap_Colors[2]);
    Ninja_ItemMap_Colors[3] = Ninja_ItemMap_ReadColor("magic",  Ninja_ItemMap_Colors[3]);
    Ninja_ItemMap_Colors[4] = Ninja_ItemMap_ReadColor("food",   Ninja_ItemMap_Colors[4]);
    Ninja_ItemMap_Colors[5] = Ninja_ItemMap_ReadColor("potion", Ninja_ItemMap_Colors[5]);
    Ninja_ItemMap_Colors[6] = Ninja_ItemMap_ReadColor("docs",   Ninja_ItemMap_Colors[6]);
    Ninja_ItemMap_Colors[7] = Ninja_ItemMap_ReadColor("other",  Ninja_ItemMap_Colors[7]);
    Ninja_ItemMap_Colors[8] = Ninja_ItemMap_ReadColor("chest",  Ninja_ItemMap_Colors[8]);

    // Already square the distance
    if (Ninja_ItemMap_Radius > 0) {
        Ninja_ItemMap_Radius = Ninja_ItemMap_Radius * Ninja_ItemMap_Radius;
    };

    // Additional speed-up
    Ninja_ItemMap_TexNamePtr = _@s(Ninja_ItemMap_TexName);

    // Obtain player marker texture displacement for shifting the markers
    Ninja_ItemMap_CoordShift = Ninja_ItemMap_GetPositionMarkerSize() / 2;

    // Obtain item marker size
    Ninja_ItemMap_MarkerSize = roundf(mulf(mkf(Ninja_ItemMap_GetItemMarkerSize()), Bar_GetInterfaceScaling()));
};

/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_ItemMap_Init() {
    // Initialize Ikarus
    MEM_InitAll();

    const int oCDocumentManager__HandleEvent_G1              = 7490873; //0x724D39
    const int oCDocumentManager__HandleEvent_G2              = 6681689; //0x65F459
    const int oCViewDocumentMap__UpdatePosition_drawItems_G1 = 7495977; //0x726129
    const int oCViewDocumentMap__UpdatePosition_drawItems_G2 = 6871204; //0x68D8A4

    // Place hook on updating the map
    HookEngineF(MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_drawItems_G1,
                                  oCViewDocumentMap__UpdatePosition_drawItems_G2), 7, Ninja_ItemMap_AddItems);

    // Place hook on key events
    HookEngineF(MEMINT_SwitchG1G2(oCDocumentManager__HandleEvent_G1,
                                  oCDocumentManager__HandleEvent_G2), 6, Ninja_ItemMap_HandleEvent);
};
/*
 * Toggle the markers
 */
func void Ninja_ItemMap_Toggle(var int docPtr, var int turnOn) {
    const int zCViewFX__OpenSafe_G1                = 7684304; //0x7540D0
    const int zCViewFX__OpenSafe_G2                = 6884368; //0x690C10
    const int zCViewFX__CloseSafe_G1               = 7684528; //0x7541B0
    const int zCViewFX__CloseSafe_G2               = 6884608; //0x690D00
    const int oCViewDocumentMap__UpdatePosition_G1 = 7495728; //0x726030
    const int oCViewDocumentMap__UpdatePosition_G2 = 6870960; //0x68D7B0

    // Iterate over view children and show/hide them
    var int arrViewPtr; arrViewPtr = docPtr+252; // oCViewDocumentMap.arrowView
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504); // oCViewDocumentMap.mapView
    var int list; list = MEM_ReadInt(mapViewPtr+88); // zCViewObject.childList
    var int zero;
    var int any; any = FALSE;
    while(list);
        var zCListSort l; l = _^(list);
        if (l.data) {
            var int viewPtr; viewPtr = l.data; // zCViewObject*
            if (viewPtr != arrViewPtr) {
                any = TRUE;

                if (turnOn) {
                    const int call = 0;
                    if (CALL_Begin(call)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__OpenSafe_G1,
                                                                                zCViewFX__OpenSafe_G2));
                        call = CALL_End();
                    };
                } else {
                    const int call2 = 0;
                    if (CALL_Begin(call2)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__CloseSafe_G1,
                                                                                zCViewFX__CloseSafe_G2));
                        call2 = CALL_End();
                    };
                };
            };
        };
        list = l.next;
    end;

    // If the items/containers were not added yet
    if ((!any) && (turnOn)) {
        // Account for incorrect player position marker shift (set to zero again)
        MEM_WriteInt(arrViewPtr+64, 0); // zCViewObject.sizepixel[0]
        MEM_WriteInt(arrViewPtr+68, 0); // zCViewObject.sizepixel[1]

        // Update/place the document markers
        const int call3 = 0;
        if (CALL_Begin(call3)) {
            CALL__fastcall(_@(docPtr), _@(zero), MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_G1,
                                                                   oCViewDocumentMap__UpdatePosition_G2));
            call3 = CALL_End();
        };
    };
};

/*
 * Check if a key binding is toggled (== pressed once)
 * This approach is more safe than using Ikarus' MEM_KeyState as it does not interfere with any other scripts
 */
func int Ninja_ItemMap_KeyBindingIsToggled(var int keyBinding, var int keyStroke) {
    const int zCInput__IsBinded_G1         = 4993104; //0x4C3050
    const int zCInput_Win32__GetToggled_G1 = 5015088; //0x4C8630
    const int zCInput__IsBindedToggled_G2  = 5031024; //0x4CC470

    var int zptr; zptr = MEM_ReadInt(zCInput_zinput);
    const int call = 0;
    if (CALL_Begin(call)) {
        if (GOTHIC_BASE_VERSION == 1) {
            // Emulating Gothic 2's zCInput::IsBindedToggled
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(_@(zptr), zCInput__IsBinded_G1);

            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret2));
            CALL__thiscall(_@(zptr), zCInput_Win32__GetToggled_G1);
        } else {
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(_@(zptr), zCInput__IsBindedToggled_G2);
        };
        call = CALL_End();
    };

    var int ret;
    var int ret2;
    return +MEMINT_SwitchG1G2(ret && ret2, ret);
};

/*
 * Handle key additional presses
 */
func void Ninja_ItemMap_HandleEvent() {
    const int oCViewDocumentMap__vtbl_G1 = 8254556; //0x7DF45C
    const int oCViewDocumentMap__vtbl_G2 = 8633036; //0x83BACC

    if (Ninja_ItemMap_KeyBindingIsToggled(/*zOPT_GAMEKEY_WEAPON*/8, ESI)) {
        // Toggle visibility
        Ninja_ItemMap_State = !Ninja_ItemMap_State;

        // Iterate over the list of documents
        var int docList; docList = MEM_ReadInt(MEM_ReadInt(ECX+4)+8); // oCDocumentManager.docList.next
        while(docList);
            var zCListSort l; l = _^(docList);
            // Only for map documents
            if (MEM_ReadInt(l.data) == MEMINT_SwitchG1G2(oCViewDocumentMap__vtbl_G1, oCViewDocumentMap__vtbl_G2)) {
                Ninja_ItemMap_Toggle(l.data, !Ninja_ItemMap_State);
            };
            docList = l.next;
        end;
    };
};
/*
 * Guess localization (0 = EN, 1 = DE, 2 = PL, 3 = RU)
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes#localization
 */
func int Ninja_PatchMenu_GuessLocalization() {
    var int pan; pan = MEM_GetSymbol("MOBNAME_PAN");
    if (pan) {
        var zCPar_Symbol panSymb; panSymb = _^(pan);
        var string panName; panName = MEM_ReadString(panSymb.content);
        if (Hlp_StrCmp(panName, "Pfanne")) { // DE (Windows 1252)
            return 1;
        } else if (Hlp_StrCmp(panName, "Patelnia")) { // PL (Windows 1250)
            return 2;
        } else if (Hlp_StrCmp(panName, "���������")) { // RU (Windows 1251)
            return 3;
        };
    };
    return 0; // Otherwise EN
};

/*
 * Set localization indicator in menu scripts
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Ninja_PatchMenu_SetMenuLocalization() {
    const int zCPar_SymbolTable__GetSymbol_G1 = 7316336; //0x6FA370
    const int zCPar_SymbolTable__GetSymbol_G2 = 8011328; //0x7A3E40

    var string symbolName; symbolName = "NINJA_PATCHMENU_LANG";
    var int symTab; symTab = MEM_ReadInt(menuParserPointerAddress) + 16;
    var int namePtr; namePtr = _@s(symbolName);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(namePtr));
        CALL_PutRetValTo(_@(symbPtr));
        CALL__thiscall(_@(symTab), MEMINT_SwitchG1G2(zCPar_SymbolTable__GetSymbol_G1, zCPar_SymbolTable__GetSymbol_G2));
        call = CALL_End();
    };

    var int symbPtr;
    if (symbPtr) {
        var zCPar_Symbol symb; symb = _^(symbPtr);
        symb.content = Ninja_PatchMenu_GuessLocalization();
    };
};

/*
 * Create menu item from script instance name
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func int Ninja_PatchMenu_CreateMenuItem(var string scriptName) {
    const int zCMenuItem__Create_G1 = 5052784; //0x4D1970
    const int zCMenuItem__Create_G2 = 5105600; //0x4DE7C0
    var int strPtr; strPtr = _@s(scriptName);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(strPtr));
        CALL_PutRetValTo(_@(ret));
        CALL__cdecl(MEMINT_SwitchG1G2(zCMenuItem__Create_G1,
                                      zCMenuItem__Create_G2));
        call = CALL_End();
    };

    var int ret;
    return +ret;
};

/*
 * Menu initialization function called by Ninja every time a menu is opened
 */
func void Ninja_PatchMenu_Menu(var int menuPtr) {
    MEM_InitAll();

	// Get menu and menu item list, corresponds to C_MENU_DEF.items[]
	
    var zCMenu menu; menu = _^(menuPtr);
    var int items; items = _@(menu.m_listItems_array);

    // Modify each menu by its name
    if (Hlp_StrCmp(menu.name, "MENU_MAIN")) {
		// New menu instances
		var string itm1Str; itm1Str = "MENUITEM_NINJA_PATCHMENU_OPT";
	
        // Get bottom most menu item and new menu items
        var int itmL; itmL = MEM_ArrayPop(items); // Typically "BACK"
        var int itm1; itm1 = MEM_GetMenuItemByString(itm1Str);		

        // If the new ones do not exist yet, create them the first time
        if (!itm1) {
			Ninja_PatchMenu_SetMenuLocalization();
            itm1 = Ninja_PatchMenu_CreateMenuItem(itm1Str);

            // Also adjust vertical positions of the menu items
            var zCMenuItem itm;
            itm = _^(itmL);
            var int y; y = itm.m_parPosY;
            itm.m_parPosY = y+560; // Move bottom item down

            itm = _^(itm1);
            itm.m_parPosY = y; // Move new item 1 up
        };

        // (Re-)insert the menu items in the correct order
        MEM_ArrayInsert(items, itm1);
        MEM_ArrayInsert(items, itmL);
    };
};
/*
 * Texturen
 */
	const string NINJA_PATCHMENU_MENU_BACK_PIC 			= "menu_ingame.tga"; 
	const string NINJA_PATCHMENU_MENU_CHOICE_BACK_PIC	= "menu_choice_back.tga";	// Hintergrund f�r Choicebox

/*
 * Fonts
 */
	const string NINJA_PATCHMENU_MENU_FONT_DEFAULT		= "font_old_10_white.tga";
	
/*
 * Actions
 */
	const int NINJA_PATCHMENU_SEL_ACTION_UNDEF			= 0;
	const int NINJA_PATCHMENU_SEL_ACTION_BACK			= 1;
	const int NINJA_PATCHMENU_SEL_ACTION_STARTMENU		= 2;

/*
 * Dimensions
 */	
 	const int NINJA_PATCHMENU_MENU_SLIDER_DX			= 2000;
	const int NINJA_PATCHMENU_MENU_TITLE_Y				= 800;
	const int NINJA_PATCHMENU_MENU_BACK_Y				= 6500;
	const int NINJA_PATCHMENU_MENU_CHOICE_DY			= 350;
	const int NINJA_PATCHMENU_MENU_CHOICE_YPLUS			= 120;

	const int NINJA_PATCHMENU_MENU_START_Y				= 1500;
	const int NINJA_PATCHMENU_MENU_DY					= 650;	

/*
 * Types
 */
	const int NINJA_PATCHMENU_MENU_ITEM_TEXT			= 1;
	const int NINJA_PATCHMENU_MENU_ITEM_INPUT			= 3;
	const int NINJA_PATCHMENU_MENU_ITEM_CHOICEBOX		= 5;
	
/*
 * Flags
 */
	const int NINJA_PATCHMENU_IT_SELECTABLE				= 4;
	const int NINJA_PATCHMENU_SEL_ACTION_EXECCOMMANDS	= 7;
	const int NINJA_PATCHMENU_IT_TXT_CENTER				= 16;
	const int NINJA_PATCHMENU_MENU_SHOW_INFO			= 64;
	const int NINJA_PATCHMENU_IT_EFFECTS_NEXT			= 128;
 const int Ninja_PatchMenu_Lang = 0; // Will be set automatically

/* posx = <-->
 * posy = /\
		  |
		  \/
 *--------------MEN� IN EINSTELLUNGEN--------------
 *
 */
instance MenuItem_Ninja_PatchMenu_Opt(C_MENU_ITEM_DEF)
{	
	if (Ninja_PatchMenu_Lang == 1) { // DE (Windows 1252)
		text[0] = "Patch Einstellungen"; //Name
		text[1] = "Installierte Patches verwalten";  // Kommentar
	} else if(Ninja_PatchMenu_Lang == 2) { // PO
		text[0] = "Ustawienia poprawek"; //Name
		text[1] = "Zarz�dzaj zainstalowanymi poprawkami"; // Kommentar
	} else if(Ninja_PatchMenu_Lang == 3) { // RU
		text[0] = "��������� �����"; //Name
		text[1] = "���������� �������������� �������"; // Kommentar
    } else { // EN
		text[0] = "Patch Settings"; //Name
		text[1] = "Manage installed patches"; // Kommentar
    };
	// Position und Dimension
	posx		= 0;		posy		= 0;
	dimx		= 18192;		dimy		= 750;
	// Aktionen
	onSelAction[0]	= Ninja_PatchMenu_SEL_ACTION_STARTMENU;
	onSelAction_S[0]= "Menu_Ninja_PatchMenu_Opt";
	// Weitere Eigenschaften
	flags = flags | Ninja_PatchMenu_IT_TXT_CENTER;
};


/*
 *--------------QUICKOPEN HAUPTMEN�--------------
 *
 */
instance Menu_Ninja_PatchMenu_Opt(C_MENU_DEF)
{
	backpic		= Ninja_PatchMenu_MENU_BACK_PIC;
	
	items[0]	= "MenuItem_Ninja_PatchMenu_Opt_Heading";
	
	items[1]	= "MenuItem_Ninja_PatchMenu_Opt_Back";
	
	defaultOutGame	= 0;	// PERFORMANCE-SETTINGS
	defaultInGame	= 0;	// PERFORMANCE-SETTINGS

	flags = flags | Ninja_PatchMenu_MENU_SHOW_INFO;
};


/*
 *--------------HEADLINE-------------
 *
 */
instance MenuItem_Ninja_PatchMenu_Opt_Heading(C_MENU_ITEM_DEF)
{
	if (Ninja_PatchMenu_Lang == 1) { // DE (Windows 1252)
		text[0] = "Patch Einstellungen"; //Name
	} else if(Ninja_PatchMenu_Lang == 2) { // PO
		text[0] = "Ustawienia poprawek"; //Name
	} else if(Ninja_PatchMenu_Lang == 3) { // RU
		text[0] = "��������� �����"; //Name
    } else { // EN
		text[0] = "Patch Settings"; //Name
    };
	type		=	Ninja_PatchMenu_MENU_ITEM_TEXT;
	// Position und Dimension
	posx		=	0;		posy		=	Ninja_PatchMenu_MENU_TITLE_Y;
	dimx		=	8192;
	// Weitere Eigenschaften
	flags		= flags & ~Ninja_PatchMenu_IT_SELECTABLE;
	flags		= flags | Ninja_PatchMenu_IT_TXT_CENTER;
};



/*
 *--------------ZUR�CK--------------
 *
 */
instance MenuItem_Ninja_PatchMenu_Opt_Back(C_MENU_ITEM_DEF)
{
	if (Ninja_PatchMenu_Lang == 1) { // DE (Windows 1252)
        text[0] = "Zur�ck"; //Name
    } else if (Ninja_PatchMenu_Lang == 2) { // PL (Windows 1250)
        text[0] = "Plecy"; //Name
    } else if (Ninja_PatchMenu_Lang == 3) { // RU (Windows 1251)
        text[0] = "�����"; //Name
    } else { // EN
        text[0] = "Back"; //Name
    };
	// Position und Dimension
	posx		=	1000;		posy		=	1700;
	dimx		=	6192;		dimy		= 	NINJA_PATCHMENU_MENU_DY;
	// Aktionen
	onSelAction[0]	= 	Ninja_PatchMenu_SEL_ACTION_BACK;
	// Weitere Eigenschaften
	flags			= flags | Ninja_PatchMenu_IT_TXT_CENTER;
};
// **************************
// AIVAR-Kennungen f�r Humans 
// **************************

// ------ NEWS und MEMORY Aivars ------
// - NUR Augenzeugen
// - NUR pers�nliches News-Ged�chtnis, geregelt �ber die folgenden Aivars
// - schwere Tat �berschreibt leichte Tat
// - KEINE automatische News-Verbreitung, AIV-Check bei aNSCs in Dialogen = Ersatz f�r News-Verbreitung
// - News-Vergabe �ber Dialog-Module

const int 	AIV_LastFightAgainstPlayer		= 0;
const int 		FIGHT_NONE				= 0;
const int 		FIGHT_LOST				= 1;	//in ZS_Unconscious
const int 		FIGHT_WON				= 2;	//in ZS_Unconscious (player)
const int 		FIGHT_CANCEL			= 3;	//in B_Attack, wenn other = Player

const int 	AIV_NpcSawPlayerCommit			= 1;
const int 		CRIME_NONE				= 0;
const int 		CRIME_SHEEPKILLER		= 1;
const int 		CRIME_ATTACK			= 2;	//Kampf self-SC --> feinere Analys in DIA-Modul �ber AIV_LastFightAgainstPlayer
const int 		CRIME_THEFT				= 3;
const int 		CRIME_MURDER			= 4;

const int 	AIV_NpcSawPlayerCommitDay		= 2;

// ------ B_AssessTalk -------------------------
const int 	AIV_NpcStartedTalk				= 3; 	//wenn der NSC mit Important Info den SC anquatscht

// ------ ZS_Talk ------------------------------
const int   AIV_INVINCIBLE					= 4;	//ist TRUE f�r beide Teilnehmer eines Dialogs
const int 	AIV_TalkedToPlayer				= 5;	

// ------ Pickpocket ---------------------------
const int 	AIV_PlayerHasPickedMyPocket		= 6;

// ------ ZS_Attack ----------------------------
const int	AIV_LASTTARGET					= 7;	//damit other erhalten bleibt
const int 	AIV_PursuitEnd					= 8;    //wenn Verfolgung abgebrochen

// ------ B_SayAttackReason --------------------
const int	AIV_ATTACKREASON				= 9;	//Grund des Angriffs - Reihenfolge PRIORISIERT
const int		AR_NONE					= 0;
const int 		AR_LeftPortalRoom		= 1;			//Spieler hat (unbefugten) Portalraum verlassen
const int 		AR_ClearRoom			= 2;			//Spieler ist unbefugt in meinem Raum
const int		AR_GuardCalledToRoom	= 3;
const int 		AR_MonsterVsHuman		= 4; 			//Monster k�mpft gegen Human - ich helfe Human
const int 		AR_MonsterMurderedHuman = 5;			//Monster hat Human get�tet
const int 		AR_SheepKiller			= 6;			//Schaf wurde angegriffen oder get�tet (von Mensch oder Monster)
const int 		AR_Theft				= 7;			//Spieler hat Item geklaut
const int 		AR_UseMob				= 8;			//Spieler hat an Mob mit Besitzflag rumgefummelt (kann JEDES Mob sein)
const int 		AR_GuardCalledToThief 	= 9;       
const int 		AR_ReactToWeapon		= 10;			//T�ter hat trotz zweimaliger Warnung Waffe nicht weggesteckt ODER ich fliehe direkt
const int 		AR_ReactToDamage		= 11;   	 	//T�ter hat mich verletzt
const int 		AR_GuardStopsFight		= 12;   	 	//Wache beendet Kampf, greift T�ter an
const int 		AR_GuardCalledToKill	= 13;   	 	//Wache durch WARN zum Mit-T�ten gerufen
const int 		AR_GuildEnemy			= 14;   	 	//Gilden-Feind = Mensch oder Monster
const int 		AR_HumanMurderedHuman	= 15;   	 	//other hat gemordet
const int 		AR_MonsterCloseToGate 	= 16;   	 	//GateGuards halten nicht-feindliches Monster auf
const int		AR_GuardStopsIntruder	= 17;   	 	//GateGuards attackieren Eindringling
const int 		AR_SuddenEnemyInferno	= 18;			//EnemyOverride Blockierung f�r mich selbst und alle NPCs im Umkreis aufheben.
const int 		AR_KILL					= 19;   	 	//Spieler aus Dialog heraus t�ten (SC hat keine Chance)

// ------ ZS_RansackBody ------------------------
const int 	AIV_RANSACKED					= 10; 	//damit nur EIN NSC einen Body pl�ndert

// ------ ZS_Dead -------------------------------
const int 	AIV_DeathInvGiven				= 11;	// F�r Mensch und Monster!

// ------ TA_GuardPassage -----------------------
const int	AIV_Guardpassage_Status			= 12;	// Enth�lt den Status einer Durchgangswache
const int		GP_NONE					= 0;		// ...Anfang; SC noch nicht in der N�he
const int		GP_FirstWarnGiven		= 1;		// ...nach der ersten Warnung an den SC
const int 		GP_SecondWarnGiven		= 2;		// ...nach der zweiten Warnung an den SC 
const int	AIV_LastDistToWP				= 13;	// enth�lt die letzte ermittelte Distanz zum Referenz-Waypoint (Checkpoint) (wird beim SPIELER gesetzt!) 
const int   AIV_PASSGATE					= 14;   // TRUE = Spieler kann durch, FALSE = Spieler wird aufgehalten

// ------ XP-Vergabe ----------------------------
const int	AIV_PARTYMEMBER					= 15;	//f�r XP-Vergabe, AUCH f�r Monster
const int 	AIV_VictoryXPGiven				= 16;	//wenn NSC schonmal besiegt, gibts keine XP mehr f�r den Spieler (z.B. bei unconscious Humans)

// ------ Geschlecht ----------------------------
const int AIV_Gender						= 17; 	//wird zusammen mit Visual �ber B_SetVisual gesetzt
const int 		MALE					= 0;
const int 		FEMALE					= 1;

// ------ TA_Stand_Eating -----------------------
const int AIV_Food							= 18;
const int 		FOOD_Apple				= 0;
const int 		FOOD_Cheese				= 1;
const int 		FOOD_Bacon				= 2;
const int 		FOOD_Bread				= 3;

// ------  TA Hilfsvariable -----------------------	//notwendig da lokale Hilfsvariablen anscheinend nicht immer neu initialisiert werden bitte nur f�r TAs verwenden!
const int AIV_TAPOSITION					= 19;
const int		ISINPOS					= 0;
const int		NOTINPOS				= 1;
const int 		NOTINPOS_WALK			= 2;

// ------ Finger weg!
const int AIV_SelectSpell					= 20;

// ------ ZS_ObservePlayer ---------------------
const int AIV_SeenLeftRoom					= 21;	//ist Player-aus-Raum-raus-Kommentar schon abgelassen worden?

////////////////////////////////////
var int Player_SneakerComment;
var int Player_LeftRoomComment;
var int Player_DrawWeaponComment;
var int Player_GetOutOfMyBedComment;
////////////////////////////////////

// ------ ZS_Attack ----------------------------
const int AIV_HitByOtherNpc					= 22;	//ANDERER GEGNER - zweiter Treffer
const int AIV_WaitBeforeAttack				= 23;
const int AIV_LastAbsolutionLevel			= 24; 

// ----------------------------------------------
const int AIV_ToughGuyNewsOverride			= 25;


// ***************************
// AIVAR-Kennungen f�r Monster
// ***************************

const int AIV_MM_ThreatenBeforeAttack		= 26;
const int AIV_MM_FollowTime 				= 27;	//wie lange verfolgt einen das Monster
const int 		FOLLOWTIME_SHORT		= 5;
const int 		FOLLOWTIME_MEDIUM		= 10;
const int 		FOLLOWTIME_LONG			= 20;
const int AIV_MM_FollowInWater 				= 28;	//AUCH f�r HUMANS! - folgt einem der NSC auch in Wasser?
// ----------------------------------------------
const int AIV_MM_PRIORITY 					= 29;	//ist meine Priorit�t gerade FRESSEN oder K�MPFEN (immer fressen, es sei denn ich werde getroffen)
const int 	PRIO_EAT 					= 0;
const int 	PRIO_ATTACK 				= 1;
// ----------------------------------------------
const int AIV_MM_SleepStart 				= 30;
const int AIV_MM_SleepEnd 					= 31;
const int AIV_MM_RestStart 					= 32;
const int AIV_MM_RestEnd 					= 33;		
const int AIV_MM_RoamStart 					= 34;
const int AIV_MM_RoamEnd 					= 35;
const int AIV_MM_EatGroundStart 			= 36;
const int AIV_MM_EatGroundEnd 				= 37;
const int AIV_MM_WuselStart 				= 38;
const int AIV_MM_WuselEnd 					= 39;
const int AIV_MM_OrcSitStart				= 40;
const int AIV_MM_OrcSitEnd					= 41;
const int 	OnlyRoutine 				= -1;
// ----------------------------------------------
const int AIV_MM_ShrinkState 				= 42;	//merkt sich das Schrumpf-Stadium des Monsters, wenn es von einem Shrink-Zauber getroffen wird
// ----------------------------------------------
const int AIV_MM_REAL_ID					= 43;
const int 	ID_MEATBUG					= 1; 				 
const int 	ID_SHEEP					= 2; 
const int 	ID_GOBBO_GREEN				= 3; 	
const int 	ID_GOBBO_BLACK				= 4;
const int 	ID_GOBBO_SKELETON			= 5; 	
const int 	ID_SUMMONED_GOBBO_SKELETON 	= 6;
const int 	ID_SCAVENGER				= 7;
const int 	ID_SCAVENGER_DEMON			= 8; 	
const int 	ID_GIANT_RAT				= 8; 
const int 	ID_GIANT_BUG				= 9; 
const int 	ID_BLOODFLY					= 10; 
const int 	ID_WARAN					= 11; 				
const int	ID_FIREWARAN				= 12;
const int 	ID_WOLF						= 13; 				
const int 	ID_WARG						= 14;
const int 	ID_SUMMONED_WOLF			= 15;
const int 	ID_MINECRAWLER				= 16; 	
const int 	ID_MINECRAWLERWARRIOR		= 17; 	
const int 	ID_LURKER					= 18;
const int 	ID_SKELETON					= 19;
const int 	ID_SUMMONED_SKELETON		= 20;
const int 	ID_SKELETON_MAGE			= 21;
const int 	ID_ZOMBIE					= 22;
const int 	ID_SNAPPER					= 23; 
const int 	ID_DRAGONSNAPPER			= 24; 	
const int 	ID_SHADOWBEAST				= 25; 
const int 	ID_SHADOWBEAST_SKELETON		= 26; 
const int 	ID_HARPY					= 27; 
const int 	ID_STONEGOLEM				= 28; 
const int 	ID_FIREGOLEM				= 29;
const int 	ID_ICEGOLEM					= 30;
const int 	ID_SUMMONED_GOLEM			= 31;
const int 	ID_DEMON					= 32; 
const int 	ID_SUMMONED_DEMON			= 33;
const int 	ID_DEMON_LORD				= 34;
const int 	ID_TROLL					= 35;
const int 	ID_TROLL_BLACK				= 36;
const int 	ID_SWAMPSHARK				= 37; 	
const int 	ID_DRAGON_FIRE				= 38;
const int 	ID_DRAGON_ICE				= 39; 
const int 	ID_DRAGON_ROCK				= 40; 
const int 	ID_DRAGON_SWAMP				= 41; 
const int 	ID_DRAGON_UNDEAD			= 42; 
const int 	ID_MOLERAT					= 43;
const int 	ID_ORCWARRIOR				= 44;
const int 	ID_ORCSHAMAN				= 45;
const int 	ID_ORCELITE					= 46;
const int 	ID_UNDEADORCWARRIOR			= 47;
const int 	ID_DRACONIAN				= 48;
const int 	ID_WISP						= 49;

//----- Addon ------

const int 	ID_Alligator				= 50;
const int 	ID_Swampgolem				= 51;
const int 	ID_Stoneguardian			= 52;
const int 	ID_Gargoyle					= 53;
const int 	ID_Bloodhound				= 54;
const int 	ID_Icewolf					= 55;
const int	ID_OrcBiter					= 56;
const int   ID_Razor					= 57;
const int 	ID_Swarm					= 58;
const int 	ID_Swamprat					= 59;
const int	ID_BLATTCRAWLER				= 60;
const int	ID_SummonedGuardian			= 61;
const int	ID_SummonedZombie			= 62;
const int	ID_Keiler					= 63;
const int 	ID_SWAMPDRONE				= 64;


// ----------------------------------------------
const int AIV_LASTBODY						= 44;	//der Body, an dem ich zuletzt gefressen habe




// **********************
// Weitere Human - AIVARs
// **********************

// ------ Petzen --------------------------------
const int AIV_ArenaFight					= 45;
const int 	AF_NONE						= 0;
const int 	AF_RUNNING					= 1;
const int 	AF_AFTER					= 2;
const int 	AF_AFTER_PLUS_DAMAGE		= 3;

// ------ zus�tzlich zur CRIME merken -----------
const int AIV_CrimeAbsolutionLevel			= 46;

// ------ ZS_Attack ----------------------------
const int AIV_LastPlayerAR					= 47;

// ------ ZS_Unconscious ------------------------
const int AIV_DuelLost						= 48;

// ------ Trade AIV -----------------------------
const int AIV_ChapterInv					= 49;

// ------ Monster: Rudeltier (reagiert auf WARN) ------
const int AIV_MM_Packhunter					= 50;

// ------ MAGIE -----
const int AIV_MagicUser						= 51;
const int 	MAGIC_NEVER					= 0;
const int 	MAGIC_ALWAYS				= 1;

// ------ C_DropUnconscious ------
const int AIV_DropDeadAndKill				= 52;

// ------ ZS_MagicFreeze ------
const int AIV_FreezeStateTime				= 53;

// ------ IGNORE Crime ------
const int AIV_IGNORE_Murder					= 54;
const int AIV_IGNORE_Theft					= 55;
const int AIV_IGNORE_Sheepkiller			= 56;

// ------ ToughGuy IGNORIERT Attack-Crime ------
const int AIV_ToughGuy						= 57;	//Jubelt beim Kampf, hat keine News bei Attack (kann �ber AIV_LastFightAgainstPlayer reagieren)

// ------ News Override (petzen aber nicht labern) ------
const int AIV_NewsOverride					= 58;

// ------ ZS_MM_Attack ------
const int AIV_MaxDistToWp					= 59;
const int AIV_OriginalFightTactic			= 60;

// ------ B_AssessEnemy ------
const int AIV_EnemyOverride					= 61;

// ------ f�r beschworene Monster ------
const int AIV_SummonTime					= 62;

// ------ ZS_Attack ------
const int AIV_FightDistCancel				= 63;
const int AIV_LastFightComment				= 64; //Hat der NSC den letzten Kampf kommentiert?

// -----------------------
const int AIV_LOADGAME						= 65; //frag nicht

// ------ ZS_Unconscious -------
const int AIV_DefeatedByPlayer				= 66;

// ------ ZS_Dead ------
const int AIV_KilledByPlayer				= 67;

// ------ diverse ZS -------
const int AIV_StateTime						= 68; //um mit zwei StateTime-Triggern arbeiten zu k�nnen.

// -------------------------
const int AIV_Dist							= 69;

const int AIV_IgnoresFakeGuild				= 70;

const int AIV_NoFightParker					= 71;	//wird von NSCs weder angegriffen, noch greift er selber welche an. (Archetyp: Gefangener)
const int AIV_NPCIsRanger					= 72;	//Der Typ geh�rt zum 'Ring des Wassers'
const int AIV_IgnoresArmor					= 73;	//Keine Reaktion oder Konsequenzen auf die R�stung des SC
const int AIV_StoryBandit					= 74;	//Banditen, mit denen gek�mpft werden darf
const int AIV_StoryBandit_Esteban			= 75;	//Estebans Dreigestirn

// ------ ZS_Whirlwind --------
const int AIV_WhirlwindStateTime			= 76;	//added by kairo

// ------ ZS_Inflate --------
const int AIV_InflateStateTime				= 77;	//added by kairo

// ------ ZS_Swarm --------
const int AIV_SwarmStateTime				= 78;	//added by kairo

// ------ ZS_SuckEnergy	--------
const int AIV_SuckEnergyStateTime			= 79;	//added by kairo

// ------ Party of Pirates ------
const int AIV_FollowDist					= 80;	

// ------ REAL Attributes ------
const int REAL_STRENGTH						= 81;
const int REAL_DEXTERITY					= 82;
const int REAL_MANA_MAX						= 83;
const int REAL_TALENT_1H					= 84;
const int REAL_TALENT_2H					= 85;
const int REAL_TALENT_BOW					= 86;
const int REAL_TALENT_CROSSBOW				= 87;

const int AIV_SpellLevel 					= 88;


// Sonja
const int AIV_PimpDay                       = 90;

// ***************************************************
// Globalvariablen f�r Petzen/Absolution/News - System
// ***************************************************

var int ABSOLUTIONLEVEL_OldCamp;
var int ABSOLUTIONLEVEL_City;
var int ABSOLUTIONLEVEL_Monastery;
var int ABSOLUTIONLEVEL_Farm;
var int ABSOLUTIONLEVEL_BL;//ADDON

var int PETZCOUNTER_OldCamp_Murder;
var int PETZCOUNTER_OldCamp_Theft;
var int PETZCOUNTER_OldCamp_Attack;
var int PETZCOUNTER_OldCamp_Sheepkiller;

var int PETZCOUNTER_City_Murder;
var int PETZCOUNTER_City_Theft;
var int PETZCOUNTER_City_Attack;
var int PETZCOUNTER_City_Sheepkiller;

var int PETZCOUNTER_Monastery_Murder;
var int PETZCOUNTER_Monastery_Theft;
var int PETZCOUNTER_Monastery_Attack;
var int PETZCOUNTER_Monastery_Sheepkiller;

var int PETZCOUNTER_Farm_Murder;
var int PETZCOUNTER_Farm_Theft;
var int PETZCOUNTER_Farm_Attack;
var int PETZCOUNTER_Farm_Sheepkiller;

var int PETZCOUNTER_BL_Murder;
var int PETZCOUNTER_BL_Theft;
var int PETZCOUNTER_BL_Attack;

// ***************************************************
// Location Konstanten
// ***************************************************

const int LOC_NONE		= 0;
const int LOC_OLDCAMP	= 1;
const int LOC_CITY		= 2;
const int LOC_MONASTERY = 3;
const int LOC_FARM		= 4;
const int LOC_BL		= 5;	//Addon Banditenlager
const int LOC_ALL		= 6;	//ALLE Locations


// ***************************************************
// Stadtviertel Konstanten
// ***************************************************

const int Q_KASERNE 	= 1;
const int Q_GALGEN 		= 2;
const int Q_MARKT 		= 3;
const int Q_TEMPEL 		= 4;
const int Q_UNTERSTADT 	= 5;
const int Q_HAFEN 		= 6;
const int Q_OBERSTADT 	= 7;


// ******************************
// Aktive Wahrnehmung der MONSTER
// ******************************
//---------------------------------------------
const int PERC_DIST_SUMMONED_ACTIVE_MAX	= 2000;	// Maximale Reichweite der aktiven Wahrnehmung aller beschworenen Monster
const int PERC_DIST_MONSTER_ACTIVE_MAX	= 1500; // Maximale Reichweite der aktiven Wahrnehmung ALLER anderen Monster
const int PERC_DIST_ORC_ACTIVE_MAX		= 2500; // 
const int PERC_DIST_DRAGON_ACTIVE_MAX	= 3500; //Damit das Vlippern endlich ein Ende hat
//---------------------------------------------
const int FIGHT_DIST_MONSTER_ATTACKRANGE = 700;	// Wann greifen Monster an bzw. ab welcher Distanz vertreiben sie dich vom Fressen
const int FIGHT_DIST_MONSTER_FLEE		= 300;	// Ab wann fliehe ich vor einem Feind
const int FIGHT_DIST_DRAGON_MAGIC		= 700;
//---------------------------------------------
const int MONSTER_THREATEN_TIME			= 4; 	// Sekunden, die Monster drohen, bevor sie angreifen (wenn Gegner nicht zu weit und nicht zu nah)
const int MONSTER_SUMMON_TIME			= 60;

/********************************************************************
**					Konstanten f�r Distanzen					   **
**					    der Menschen-AI							   **
********************************************************************/
// --------------------------------------------
const int TA_DIST_SELFWP_MAX			= 500; // 500
// --------------------------------------------
const int PERC_DIST_ACTIVE_MAX			= 2000;	// Maximal-Reichweite der AKTIVEN Wahrnehmungen - angegeben in Npc_Default.d
//---------------------------------------------
const int PERC_DIST_INTERMEDIAT			= 1000; // Mittlere Passive Wahrnehmung
const int PERC_DIST_DIALOG				= 500;	// Dialogreichweite
const int PERC_DIST_HEIGHT				= 1000; // ab welchem H�henunterschied wird Wn ignoriert
const int PERC_DIST_INDOOR_HEIGHT		= 250;  // dasselbe f�r Indoor (zum Ignorieren von anderen Stockwerken wenn ganzes Haus (H�hlensystem) EIN Portalraum ist)
//---------------------------------------------
const int FIGHT_DIST_MELEE				= 600;	// Bis zu welcher Entfernung Bedrohung durch SC-Waffe
const int FIGHT_DIST_RANGED_INNER		= 900;  // Ab welcher Entfernung NK w�hlen, wenn NSC im FK ist
const int FIGHT_DIST_RANGED_OUTER		= 1000; // Ab welcher Entfernung FK w�hlen, wenn NSC im NK ist oder Waffe zum ersten Mal gezogen wird
const int FIGHT_DIST_CANCEL				= 3500; // Bis wann hinterherschiessen, ab welcher Distanz Kampf abbrechen ODER Flucht abbrechen
//---------------------------------------------
const int WATCHFIGHT_DIST_MIN			= 300;
const int WATCHFIGHT_DIST_MAX			= 2000;
//---------------------------------------------
const int ZivilAnquatschDist 			= 400;	// Distanz, ab der dich ein NSC zivil anspricht (Maximum ist PERC_DIST_ACTIVE_MAX --> B_AssessPlayer)

//---------------------------------------------
const float RANGED_CHANCE_MINDIST		= 1500;	// Unterhalb dieser Distanz steigt die Trefferchance linear bis 100% an. (Default sind 10m)
const float RANGED_CHANCE_MAXDIST		= 4500; // Ab RANGED_CHANCE_MINDIST bis RANGED_CHANCE_MAXDIST sinkt die Trefferchance bis auf 0% ab (default sind 100m)


/********************************************************************
**					Zeit-Konstanten									*
********************************************************************/
CONST INT NPC_ANGRY_TIME 				= 120;	// MUSS SO HEISSEN, ist vom Programm ausgelagert - Spielsekunden, die die Temp_Att aufrechterhalten wird, bevor sie wieder auf Perm_Att gesetzt wird (gilt f�r alle At, nicht nur f�r angry)
// -------------------------------------------
const int HAI_TIME_UNCONSCIOUS			= 20;	// MUSS SO HEISSEN, ist vom Programm ausgelagert (Default = 20) - Zeit in Sekunden, die der SC und NSCs bewu�tlos bleiben
// -------------------------------------------
const int NPC_TIME_FOLLOW				= 10;	// Zeit, die sich das Opfer des NSCs maximal in BS_RUN befinden darf, um noch weiter verfolgt zu werden



/********************************************************************
**	Mindestschaden 				                                   **
********************************************************************/
const int NPC_MINIMAL_DAMAGE 	= 5; 	//MUSS SO HEISSEN, ist vom Programm ausgelagert - Untere Genze des Mindestschadens f�r Menschen (*** und Monster ??? ***)
const int NPC_MINIMAL_PERCENT	= 10;	//MUSS SO HEISSEN, ist vom Programm ausgelagert - Mindestschaden wird ermittelt durch X% vom normalen Gesamtschaden (NACH Abzug der R�stung), wobei NPC_MINIMAL_DAMAGE genommen wird, falls Mindestschaden NACH %-Berechnung kleiner als NPC_MINIMAL_DAMAGE!


/********************************************************************
**					Fight AI-Constanten								*
********************************************************************/

const int FAI_HUMAN_COWARD				= 2		;
const int FAI_HUMAN_NORMAL				= 42	;
const int FAI_HUMAN_STRONG				= 3		;
const int FAI_HUMAN_MASTER				= 4		;
//-----------------------------------------------
const int FAI_MONSTER_COWARD			= 10	; 	// Spielanfang
//-----------------------------------------------
const int FAI_NAILED					= 1		;
//-----------------------------------------------
const int FAI_GOBBO						= 7		; 	// Green Goblin / Black Goblin
const int FAI_SCAVENGER					= 15	; 	// (bei Bedarf) Scavenger / Evil Scavenger
const int FAI_GIANT_RAT					= 11	; 
const int FAI_GIANT_BUG					= 31	; 
const int FAI_BLOODFLY					= 24	; 
const int FAI_WARAN						= 21	; 	// Waren / Feuerwaran					
const int FAI_WOLF						= 22	; 	
const int FAI_MINECRAWLER				= 5		; 	// Minecrawler / Minecrawler Warrior
const int FAI_LURKER					= 9		;
const int FAI_ZOMBIE					= 23	;
const int FAI_SNAPPER					= 18	; 	// Snapper / Dragon Snapper
const int FAI_SHADOWBEAST				= 16	; 
const int FAI_HARPY						= 36	; 
const int FAI_STONEGOLEM				= 8 	; 
const int FAI_DEMON						= 6		; 
const int FAI_TROLL						= 20 	; 	// Troll / Schwarzer Troll
const int FAI_SWAMPSHARK				= 19	; 	// (bei Bedarf) 
const int FAI_DRAGON					= 39	; 	// Feuerdrache / Eisdrache / Felsdrache / Sumpfdrache / Untoter Drache
const int FAI_MOLERAT					= 40	; 	// Molerat
//-----------------------------------------------
const int FAI_ORC						= 12	;	// Ork-Krieger / Ork-Shamane / Ork-Elite
const int FAI_DRACONIAN					= 41 	; 				

//Alles Addon

const int FAI_Alligator					= 43	;	//Alligator Addon
const int FAI_Gargoyle					= 44	;   //Steinpuma
const int FAI_Bear						= 45	; 	//B�r
const int FAI_Stoneguardian				= 46	;	//Steinw�chter

/********************************************************************
**					Allgemeine Konstanten						   **
********************************************************************/
const int TRUE				= 1;
const int FALSE				= 0;

const INT LOOP_CONTINUE 	= 0;
CONST INT LOOP_END			= 1;

const int DEFAULT 			= 0; //wird in Monster-Instanzen (SetVisual) verwendet


// ***************************
// 		Spieler Constants
// ***************************

const int LP_PER_LEVEL				= 10;	// Lernpunkte pro Spieler-Stufe
const int HP_PER_LEVEL				= 12;	// Lebenspunkte pro Spieler-Stufe

const int XP_PER_VICTORY			= 10;	// Erfahrungspunkte pro Level des Gegners


/********************************************************************
**					NPC-Typ											*
********************************************************************/

const int NPCTYPE_AMBIENT		= 0;
const int NPCTYPE_MAIN			= 1;
const int NPCTYPE_FRIEND		= 2;
const int NPCTYPE_OCAMBIENT		= 3;
const int NPCTYPE_OCMAIN		= 4;
const int NPCTYPE_BL_AMBIENT	= 5;//Addon
const int NPCTYPE_TAL_AMBIENT	= 6;//Addon
const int NPCTYPE_BL_MAIN		= 7;//Addon

//****************************************************
//		Produktions-Mobsis
//****************************************************

//werden ben�tigt um eine Unterscheidung der Mobsi beim PC_Hero Dialog vorzunehmen.

const int 	MOBSI_NONE						= 0;
const int	MOBSI_SmithWeapon				= 1;
const int	MOBSI_SleepAbit					= 2;
const int	MOBSI_MakeRune					= 3;
const int	MOBSI_PotionAlchemy				= 4;
const int	MOBSI_PRAYSHRINE				= 5;	
const int	MOBSI_GOLDHACKEN				= 6;
const int	MOBSI_PRAYIDOL					= 7;

var int 	PLAYER_MOBSI_PRODUCTION;

// *****************************
// Konstanten f�r B_SetNpcVisual
// *****************************

// ------ Nacktmesh-Texturen f�r M�nner und Frauen (je 4) ------
const int BodyTex_P			= 0;	//Pale
const int BodyTex_N			= 1;	//Normal
const int BodyTex_L			= 2;	//Latino
const int BodyTex_B			= 3;	//Black 	- die gleichen Kennungen haben auch die Gesichter (zum direkten Vergleich)
const int BodyTexBabe_P		= 4;	//Pale Babe
const int BodyTexBabe_N		= 5;	//Normal Babe	
const int BodyTexBabe_L		= 6;	//Latino Babe 
const int BodyTexBabe_B		= 7;	//Black Babe   //Frauen werden auch mit den "M�nner"-Konstanten angegeben, dann vom Script +4 addiert, d.h. diese Konstanten werden nicht gebraucht
const int BodyTex_Player	= 8;

//---------ADD ON----------------------
const int BodyTex_T	= 10; //t�towierte psionikerhaut
const int BodyTexBabe_F	= 11; //Fellkragen Babe 
const int BodyTexBabe_S	= 12;//das kleine Schwarze 


// ------ Keine R�stung ------
const int NO_ARMOR			= -1;

// ------- Gesichter f�r M�nner ------
const int Face_N_Gomez 				=	0	;
const int Face_N_Scar 				= 	1	;
const int Face_N_Raven				= 	2	;
const int Face_N_Bullit				= 	3	;	//zu lieb!
const int Face_B_Thorus				= 	4	;
const int Face_N_Corristo			= 	5	;
const int Face_N_Milten				= 	6	;
const int Face_N_Bloodwyn			= 	7	;	//zu lieb!
const int Face_L_Scatty				= 	8	;
const int Face_N_YBerion			= 	9	;
const int Face_N_CoolPock			= 	10	;
const int Face_B_CorAngar			= 	11	;
const int Face_B_Saturas			= 	12	;
const int Face_N_Xardas				= 	13	;
const int Face_N_Lares				= 	14	;
const int Face_L_Ratford			= 	15	;
const int Face_N_Drax				= 	16	;	//Buster
const int Face_B_Gorn				= 	17	;
const int Face_N_Player				= 	18	;
const int Face_P_Lester				= 	19	;
const int Face_N_Lee				= 	20	;
const int Face_N_Torlof				= 	21	;
const int Face_N_Mud				= 	22	;
const int Face_N_Ricelord			= 	23	;
const int Face_N_Horatio			= 	24	;
const int Face_N_Richter			= 	25	;
const int Face_N_Cipher_neu			= 	26	;
const int Face_N_Homer				= 	27	;	//Headmesh thief
const int Face_B_Cavalorn			= 	28	;
const int Face_L_Ian				= 	29	;
const int Face_L_Diego				= 	30	;
const int Face_N_MadPsi				= 	31	;
const int Face_N_Bartholo			= 	32	;
const int Face_N_Snaf				= 	33	;
const int Face_N_Mordrag			= 	34	;
const int Face_N_Lefty				= 	35	;
const int Face_N_Wolf				= 	36	;
const int Face_N_Fingers			= 	37	;
const int Face_N_Whistler			= 	38	;
const int Face_P_Gilbert			= 	39	;
const int Face_L_Jackal				= 	40	;

//Pale
const int Face_P_ToughBald			= 	41	;
const int Face_P_Tough_Drago		= 	42	;
const int Face_P_Tough_Torrez		= 	43	;
const int Face_P_Tough_Rodriguez	= 	44	;
const int Face_P_ToughBald_Nek		= 	45	;
const int Face_P_NormalBald 		= 	46	;
const int Face_P_Normal01			= 	47	;
const int Face_P_Normal02			= 	48	;
const int Face_P_Normal_Fletcher	= 	49	;
const int Face_P_Normal03			= 	50	;
const int Face_P_NormalBart01		= 	51	;
const int Face_P_NormalBart_Cronos	= 	52	;
const int Face_P_NormalBart_Nefarius= 	53	;
const int Face_P_NormalBart_Riordian= 	54	;
const int Face_P_OldMan_Gravo		= 	55	;
const int Face_P_Weak_Cutter		= 	56	;
const int Face_P_Weak_Ulf_Wohlers	= 	57	;

//Normal
const int Face_N_Important_Arto		= 	58	;
const int Face_N_ImportantGrey		= 	59	;
const int Face_N_ImportantOld		= 	60	;
const int Face_N_Tough_Lee_�hnlich	= 	61	;
const int Face_N_Tough_Skip			= 	62	;
const int Face_N_ToughBart01		= 	63	;
const int Face_N_Tough_Okyl			= 	64	;
const int Face_N_Normal01			= 	65	;
const int Face_N_Normal_Cord		= 	66	;
const int Face_N_Normal_Olli_Kahn	= 	67	;	
const int Face_N_Normal02			= 	68	;
const int Face_N_Normal_Spassvogel	= 	69	;
const int Face_N_Normal03			= 	70	;
const int Face_N_Normal04			= 	71	;
const int Face_N_Normal05			= 	72	;
const int Face_N_Normal_Stone		= 	73	;
const int Face_N_Normal06			= 	74	;
const int Face_N_Normal_Erpresser	= 	75	;
const int Face_N_Normal07			= 	76	;
const int Face_N_Normal_Blade		= 	77	;
const int Face_N_Normal08			= 	78	;
const int Face_N_Normal14			= 	79	;
const int Face_N_Normal_Sly			= 	80	;
const int Face_N_Normal16			= 	81	;
const int Face_N_Normal17			= 	82	;
const int Face_N_Normal18			= 	83	;
const int Face_N_Normal19			= 	84	;
const int Face_N_Normal20			= 	85	;
const int Face_N_NormalBart01		= 	86	;
const int Face_N_NormalBart02		= 	87	;
const int Face_N_NormalBart03		= 	88	;
const int Face_N_NormalBart04		= 	89	;
const int Face_N_NormalBart05		= 	90	;
const int Face_N_NormalBart06		= 	91	;
const int Face_N_NormalBart_Senyan	= 	92	;
const int Face_N_NormalBart08		= 	93	;
const int Face_N_NormalBart09		= 	94	;
const int Face_N_NormalBart10		= 	95	;
const int Face_N_NormalBart11		= 	96	;
const int Face_N_NormalBart12		= 	97	;
const int Face_N_NormalBart_Dexter	= 	98	;
const int Face_N_NormalBart_Graham	= 	99	;
const int Face_N_NormalBart_Dusty	= 	100	;
const int Face_N_NormalBart16		= 	101	;
const int Face_N_NormalBart17		= 	102	;
const int Face_N_NormalBart_Huno	= 	103	;
const int Face_N_NormalBart_Grim	= 	104	;
const int Face_N_NormalBart20		= 	105	;
const int Face_N_NormalBart21		=	106	;
const int Face_N_NormalBart22		= 	107	;
const int Face_N_OldBald_Jeremiah	= 	108	;
const int Face_N_Weak_Ulbert		= 	109	;
const int Face_N_Weak_BaalNetbek	= 	110	;
const int Face_N_Weak_Herek			= 	111	;
const int Face_N_Weak04				= 	112	;
const int Face_N_Weak05				= 	113	;
const int Face_N_Weak_Orry			= 	114	;
const int Face_N_Weak_Asghan		= 	115	;
const int Face_N_Weak_Markus_Kark	= 	116	;
const int Face_N_Weak_Cipher_alt	= 	117	;
const int Face_N_NormalBart_Swiney 	= 	118	;
const int Face_N_Weak12				= 	119	;

//Latinos
const int Face_L_ToughBald01		= 	120	;
const int Face_L_Tough01			= 	121	;
const int Face_L_Tough02			= 	122	;
const int Face_L_Tough_Santino		= 	123	;
const int Face_L_ToughBart_Quentin	=	124	;
const int Face_L_Normal_GorNaBar	= 	125	;
const int Face_L_NormalBart01		= 	126	;
const int Face_L_NormalBart02		= 	127	;
const int Face_L_NormalBart_Rufus	= 	128	;

//Black
const int Face_B_ToughBald			= 	129	;
const int Face_B_Tough_Pacho		= 	130	;
const int Face_B_Tough_Silas		= 	131	;
const int Face_B_Normal01			= 	132	;
const int Face_B_Normal_Kirgo		= 	133	;
const int Face_B_Normal_Sharky		= 	134	;
const int Face_B_Normal_Orik		= 	135	;
const int Face_B_Normal_Kharim		= 	136	;

// ------ Gesichter f�r Frauen ------

const int FaceBabe_N_BlackHair		= 	137	;
const int FaceBabe_N_Blondie		= 	138	;
const int FaceBabe_N_BlondTattoo	= 	139	;
const int FaceBabe_N_PinkHair		= 	140	;
const int FaceBabe_L_Charlotte		= 	141	;
const int FaceBabe_B_RedLocks		= 	142	;
const int FaceBabe_N_HairAndCloth	= 	143	;
//
const int FaceBabe_N_WhiteCloth		= 	144	;
const int FaceBabe_N_GreyCloth		= 	145	;
const int FaceBabe_N_Brown			= 	146	;
const int FaceBabe_N_VlkBlonde		= 	147	;
const int FaceBabe_N_BauBlonde		= 	148 ;
const int FaceBabe_N_YoungBlonde	= 	149	;
const int FaceBabe_N_OldBlonde		= 	150 ;
const int FaceBabe_P_MidBlonde		= 	151 ;
const int FaceBabe_N_MidBauBlonde	= 	152 ;
const int FaceBabe_N_OldBrown		= 	153 ;
const int FaceBabe_N_Lilo			= 	154 ;
const int FaceBabe_N_Hure			= 	155 ;
const int FaceBabe_N_Anne			= 	156 ;
const int FaceBabe_B_RedLocks2		= 	157	;
const int FaceBabe_L_Charlotte2		= 	158 ;


//-----------------ADD ON---------------------------------
const int Face_N_Fortuno		= 	159;

//Piraten
const int Face_P_Greg		= 	160;
const int Face_N_Pirat01	= 	161;
const int Face_N_ZombieMud	= 	162;

// ********************
// ZS_Talk
// -------
// wird von Humans
// UND Monstern benutzt
// ********************

// ------------------
var int zsTalkBugfix; 	//s.u.
// ------------------

FUNC void ZS_Talk ()
{
	// --- Keine Wahrnehmungen angemeldet ---

	
	// EXIT IF...
	
	// ------ Spieler spricht schon mit jemand anderem ------
	if (other.aivar[AIV_INVINCIBLE] == TRUE)
	{
		return;				
	};
	
	
	// FUNC 
	
	// ------ damit kein Dialogteilnehmer angegriffen wird ------
	self.aivar[AIV_INVINCIBLE] = TRUE;
	other.aivar[AIV_INVINCIBLE] = TRUE;
		
	// ------ NUR bei Humans ------
	if (self.guild < GIL_SEPERATOR_HUM)
	{		
		// ------ NSC sieht Spieler an (funzt auch im Sitzen) ------
		if (C_BodyStateContains (self, BS_SIT))
		{
			var C_NPC target; target = Npc_GetLookAtTarget(self);
			if (!Hlp_IsValidNpc(target))
			{
				AI_LookAtNpc (self, other);
			};
		}
		else
		{
			B_LookAtNpc (self, other);
		};
	
		// ------ NSC steckt ggf. Waffe weg ------
		AI_RemoveWeapon (self);
	};
	
	// ------ NSC dreht sich zum Spieler ------------------------------------------
	if (!C_BodystateContains(self, BS_SIT))
	{	
		B_TurnToNpc (self,	other);
	};
	
	// ------ Spieler dreht sich zum Npc ------------------------------------------
	if (!C_BodystateContains(other, BS_SIT))
	{	
		B_TurnToNpc (other, self);
		
		// ------ Spieler zu nah dran ------
		if (Npc_GetDistToNpc(other,self) < 80) 
		{
			AI_Dodge (other);
		};
	};
	
	// ------ NUR bei Humans ------
	if (self.guild < GIL_SEPERATOR_HUM)
	{	
		// ------ Set Face Expression ------
		if (Npc_GetAttitude(self, other) == ATT_ANGRY)
		|| (Npc_GetAttitude(self, other) == ATT_HOSTILE)
		{
			if (!C_PlayerIsFakeBandit(self, other))
			|| (self.guild != GIL_BDT)
			{
				Mdl_StartFaceAni	(self,	"S_ANGRY",	1,	-1);
			};
		};
				
		// ------ Ambient Infos zuweisen ------
		if (self.npctype == NPCTYPE_AMBIENT)
		|| (self.npctype == NPCTYPE_OCAMBIENT)
		|| (self.npctype == NPCTYPE_BL_AMBIENT)
		|| (self.npctype == NPCTYPE_TAL_AMBIENT)
		{
			B_AssignAmbientInfos	(self);
			
			// ------ Cityguide -------
			if (C_NpcBelongsToCity(self))
			{
				B_AssignCityGuide(self);
			};

			B_AssignSonja(self);
		};
		
		// ------ Heiltrank geben k�nnen ------
		if (self.aivar[AIV_PARTYMEMBER] == TRUE)
		&& (Hlp_GetInstanceID (self) != Hlp_GetInstanceID (Biff))
		&& (Hlp_GetInstanceID (self) != Hlp_GetInstanceID (Biff_NW))
		&& (Hlp_GetInstanceID (self) != Hlp_GetInstanceID (Biff_DI))
		&& (Hlp_GetInstanceID (self) != Hlp_GetInstanceID (Pardos))
		&& (Hlp_GetInstanceID (self) != Hlp_GetInstanceID (Pardos_NW))
		{
			B_Addon_GivePotion(self);
		};

		// ------ ToughGuy NEWS zuweisen -------
		if (C_NpcIsToughGuy (self))
		&& (self.aivar[AIV_ToughGuyNewsOverride] == FALSE)
		{			
			B_AssignToughGuyNEWS (self);
		};
				
		// ------ Ambient NEWS zuweisen -------
		if (C_NpcHasAmbientNews(self))
		{
			B_AssignAmbientNEWS	(self);
		};
		
	};		
		
	if (self.guild == GIL_DRAGON)
	{
		AI_PlayAni  (self, "T_STAND_2_TALK");
	};
	
	/*
	if (self.aivar[AIV_TalkedToPlayer] == TRUE) && ...
	{
		B_Say (self,other,"$ABS_COMMANDER"); //Ich h�rte, du warst beim Kommandanten und hast die Sache wieder in Ordnung gebracht.
		B_Say (self,other,"$ABS_MONASTERY"); //Ich h�rte, du warst bei Vater Parlan und hast Bu�e getan..
		B_Say (self,other,"$ABS_FARM");	//Ich h�rte, du warst bei Lee und und hast die Sache wieder in Ordnung gebracht.
		ABS_GOOD		//Das ist gut!
	};
	*/ // *** FIXME ***

	// ------ START Multiple Choice Dialog ------
	AI_ProcessInfos(self);

	
	zsTalkBugfix = FALSE;	//var resetten!
};

func INT ZS_Talk_Loop ()
{
   	if (InfoManager_HasFinished())
   	&& (zsTalkBugfix == TRUE)			//verhindert, da� InfoManager_HasFinished im ERSTEN FRAME der Loop abgefragt wird --> f�hrt sonst bei MOB-SITZENDEN NSCs (kein Scheiss) zu Abbruch der Loop im ERSTEN FRAME! 
   										//(Problem besteht wegen falscher Reihenfolge der Befehle AI_ProcessInfos und InfoManager_HasFinished)
   	{
		self.aivar[AIV_INVINCIBLE] = FALSE;
		other.aivar[AIV_INVINCIBLE] = FALSE;
		self.aivar[AIV_NpcStartedTalk] = FALSE;
		self.aivar[AIV_TalkedToPlayer] = TRUE;
		
		// ------ NUR bei Humans ------
		if (self.guild < GIL_SEPERATOR_HUM)
		{
			B_StopLookAt (self);
			Mdl_StartFaceAni (self, "S_NEUTRAL", 1, -1); //Reset Face Expression
		};	
	
		if (self.guild == GIL_DRAGON)
		{
			AI_PlayAni (self, "T_TALK_2_STAND");
		};
		
		return LOOP_END;
  	}
  	else
   	{
   		zsTalkBugfix = TRUE;
   		
   		return LOOP_CONTINUE;
   	};
};

FUNC VOID ZS_Talk_End ()
{
	// ------ damit nicht nach Dialog+Losgehen gegr��t wird ------
	Npc_SetRefuseTalk(other,20); //BEACHTEN: other ist Spieler!

	// ------ wenn Spieler in meinem Raum ------
	if (C_NpcIsBotheredByPlayerRoomGuild(self))
	|| ( (Wld_GetPlayerPortalGuild() == GIL_PUBLIC) && (Npc_GetAttitude(self,other) != ATT_FRIENDLY) )
	{
		AI_StartState(self, ZS_ObservePlayer, 0, "");
	}
	else
	{

	};
};

// ******************
// SPL_SummonDragon		/k6
// ******************

const int SPL_Cost_SummonDragon		= 5;

INSTANCE Spell_SummonDragon (C_Spell_Proto)
{
	time_per_mana			= 0;
	targetCollectAlgo		= TARGET_COLLECT_NONE;
};

func int Spell_Logic_SummonDragon(var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_SummonDragon && self != VLK_436_Sonja)
	{
		return SPL_SENDCAST;
	}
	else //nicht genug Mana
	{
		return SPL_SENDSTOP;
	};
};

func void Spell_Cast_SummonDragon()
{
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_SummonDragon;
	};


	if (Npc_IsPlayer(self))
	{
		Wld_SpawnNpcRange( self,Dragon_Sonja,1,500);
	}
	else
	{
		Wld_SpawnNpcRange( self,Dragon_Sonja,1,500);
	};

	self.aivar[AIV_SelectSpell] += 1;
};
// ******************
// SPL_SummonSonja		/k0
// ******************

const int SPL_Cost_SummonSonja		= 5;

INSTANCE Spell_SummonSonja (C_Spell_Proto)
{
	time_per_mana			= 0;
	targetCollectAlgo		= TARGET_COLLECT_NONE;
};

func int Spell_Logic_SummonSonja(var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_SummonSonja && self != VLK_436_Sonja)
	{
		return SPL_SENDCAST;
	}
	else //nicht genug Mana
	{
		return SPL_SENDSTOP;
	};
};

func void Spell_Cast_SummonSonja()
{
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_SummonSonja;
	};

	var string wpName;
	wpName = Npc_GetNearestWP(hero);

	if (Npc_IsDead(Sonja))
	{
        Sonja.attribute[ATR_HITPOINTS] = Sonja.attribute[ATR_HITPOINTS_MAX];
		PrintScreen ("Sonja wiederbelebt!", - 1, - 1, FONT_Screen, 2);
	};

	AI_Teleport(Sonja, wpName);
	//AI_GotoNpc(VLK_436_Sonja, hero);

	self.aivar[AIV_SelectSpell] += 1;
};
// ********************
// Alle Teleport Spells
// ********************

const int SPL_Cost_Teleport		= 10;

// ****************************************
// Print, wenn im falschen Level aktiviert
// ****************************************

func void B_PrintTeleportTooFarAway (var int Level)
{
	if (Level != CurrentLevel)
	{
		PrintScreen	(PRINT_TeleportTooFarAway ,-1,YPOS_LevelUp,FONT_ScreenSmall,2);
	};
};

// ------ Instanz f�r alle Teleport-Spells ------
INSTANCE Spell_Teleport (C_Spell_Proto)
{
	time_per_mana			= 0;
	spelltype 				= SPELL_NEUTRAL;
	targetCollectAlgo		= TARGET_COLLECT_CASTER;
	canTurnDuringInvest		= 0;
	targetCollectRange		= 0;
	targetCollectAzi		= 0;
	targetCollectElev		= 0;
};



// ------ zum Paladin-Secret ------
func int Spell_Logic_PalTeleportSecret (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_PalTeleportSecret()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "NW_PAL_SECRETCHAMBER");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};


// ------ zur Hafen-Stadt ------
func int Spell_Logic_TeleportSeaport (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportSeaport()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "HAFEN");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zum Kloster ------
func int Spell_Logic_TeleportMonastery (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportMonastery()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "KLOSTER");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zum Bauernhof ------
func int Spell_Logic_TeleportFarm (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportFarm()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "BIGFARM");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zu Xardas ------
func int Spell_Logic_TeleportXardas (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportXardas()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "XARDAS"); 
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zum Pass in der NW ------
func int Spell_Logic_TeleportPassNW (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportPassNW()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "LEVELCHANGE");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zum Pass in der OW ------
func int Spell_Logic_TeleportPassOW (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};


func void Spell_Cast_TeleportPassOW()
{
	B_PrintTeleportTooFarAway (OLDWORLD_ZEN);
	
	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "SPAWN_MOLERAT02_SPAWN01");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ zum Old Camp ------
func int Spell_Logic_TeleportOC (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportOC()
{
	B_PrintTeleportTooFarAway (OLDWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "OC_MAGE_CENTER");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ in den OW D�monentower ------
func int Spell_Logic_TeleportOWDemonTower (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportOWDemonTower()
{
	B_PrintTeleportTooFarAway (OLDWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "DT_E3_03");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ------ Zur Taverne ------
func int Spell_Logic_TeleportTaverne (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};
	
	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportTaverne ()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	AI_Teleport		(self, "NW_TAVERNE_04");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// Sonja
const int SPL_Cost_TeleportSonja		= 5;

func int Spell_Logic_TeleportSonja (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};

	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportSonja()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

    var string wpName;
	wpName = Npc_GetNearestWP(VLK_436_Sonja);

	if (Npc_IsDead(Sonja))
	{
        Sonja.attribute[ATR_HITPOINTS] = Sonja.attribute[ATR_HITPOINTS_MAX];
		PrintScreen ("Sonja wiederbelebt!", - 1, - 1, FONT_Screen, 2);
	};

	AI_Teleport		(self, wpName);
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

const int SPL_Cost_TeleportRoteLaterne		= 5;

func int Spell_Logic_TeleportRoteLaterne (var int manaInvested)
{
	if (Npc_GetActiveSpellIsScroll(self) && (self.attribute[ATR_MANA] >= SPL_Cost_Scroll))
	{
		return SPL_SENDCAST;
	}
	else if (self.attribute[ATR_MANA] >= SPL_Cost_Teleport)
	{
		return SPL_SENDCAST;
	};

	return SPL_NEXTLEVEL;
};

func void Spell_Cast_TeleportRoteLaterne()
{
	B_PrintTeleportTooFarAway (NEWWORLD_ZEN);

	if (Npc_GetActiveSpellIsScroll(self))
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Scroll;
	}
	else
	{
		self.attribute[ATR_MANA] = self.attribute[ATR_MANA] - SPL_Cost_Teleport;
	};

	if (Npc_IsDead(Sonja))
	{
        Sonja.attribute[ATR_HITPOINTS] = Sonja.attribute[ATR_HITPOINTS_MAX];
		PrintScreen ("Sonja wiederbelebt!", - 1, - 1, FONT_Screen, 2);
	};

	AI_Teleport		(self, "ROTELATERNE");
	AI_PlayAni		(self, "T_HEASHOOT_2_STAND" );
};

// ----- neu 1.21 Verteiler f�r die Cast-Funcs -------
func void Spell_Cast_Teleport()
{
	if (Npc_GetActiveSpell(self) == SPL_PalTeleportSecret	)	{	Spell_Cast_PalTeleportSecret	(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportSeaport		)	{	Spell_Cast_TeleportSeaport		(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportMonastery	)	{	Spell_Cast_TeleportMonastery	(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportFarm		)	{	Spell_Cast_TeleportFarm			(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportXardas		)	{	Spell_Cast_TeleportXardas		(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportPassNW		)	{	Spell_Cast_TeleportPassNW		(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportPassOW		)	{	Spell_Cast_TeleportPassOW		(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportOC			)	{	Spell_Cast_TeleportOC			(); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportOWDemonTower)	{	Spell_Cast_TeleportOWDemonTower (); };
	if (Npc_GetActiveSpell(self) == SPL_TeleportTaverne		)	{	Spell_Cast_TeleportTaverne		(); };
//	if (Npc_GetActiveSpell(self) == SPL_Teleport_3			)	{	Spell_Cast_XXX					(); };

    // Sonja
    if (Npc_GetActiveSpell(self) == SPL_TeleportSonja		)	{	Spell_Cast_TeleportSonja		(); };
    if (Npc_GetActiveSpell(self) == SPL_TeleportRoteLaterne		)	{	Spell_Cast_TeleportRoteLaterne		(); };

};






// ******************************************************************************
// Spell_ProcessMana
// -----------------
// wird pro investiertem Mana aufgerufen 
// wieviele Mana bisher investiert wurden kann �ber manaInvested abgefragt werden
// diese Methode wird immer vom Caster aufgerufen
// self 	= Der Caster
// other 	= Das Opfer (kann auch leer sein)
// ******************************************************************************

func INT Spell_ProcessMana (VAR INT manaInvested)
{
	var int activeSpell; activeSpell = Npc_GetActiveSpell(self);

    // Sonja
	if (activeSpell == SPL_SummonSonja   		) 	{	return	Spell_Logic_SummonSonja		(manaInvested);	};
	if (activeSpell == SPL_TeleportSonja   		) 	{	return	Spell_Logic_TeleportSonja	(manaInvested);	};
	if (activeSpell == SPL_SummonDragon   		) 	{	return	Spell_Logic_SummonDragon	(manaInvested);	};
	
	//Paladin-Runen
	if (activeSpell == SPL_PalLight				)	{	return  Spell_Logic_PalLight			(manaInvested); };
	if (activeSpell == SPL_PalLightHeal			)	{	return  Spell_Logic_PalLightHeal		(manaInvested); };
	if (activeSpell == SPL_PalHolyBolt			)	{	return  Spell_Logic_PalHolyBolt			(manaInvested); };
	if (activeSpell == SPL_PalMediumHeal		)	{	return  Spell_Logic_PalMediumHeal		(manaInvested); };
	if (activeSpell == SPL_PalRepelEvil			)	{	return  Spell_Logic_PalRepelEvil		(manaInvested); };
	if (activeSpell == SPL_PalFullHeal			)	{	return  Spell_Logic_PalFullHeal			(manaInvested); };
	if (activeSpell == SPL_PalDestroyEvil		)	{	return  Spell_Logic_PalDestroyEvil		(manaInvested); };
	//Teleport-Runen
	if (activeSpell == SPL_PalTeleportSecret	)	{	return  Spell_Logic_PalTeleportSecret	(manaInvested); };
	if (activeSpell == SPL_TeleportSeaport		)	{	return  Spell_Logic_TeleportSeaport		(manaInvested); };
	if (activeSpell == SPL_TeleportMonastery	)	{	return  Spell_Logic_TeleportMonastery	(manaInvested); };
	if (activeSpell == SPL_TeleportFarm			)	{	return  Spell_Logic_TeleportFarm		(manaInvested); };
	if (activeSpell == SPL_TeleportXardas		)	{	return  Spell_Logic_TeleportXardas		(manaInvested); };
	if (activeSpell == SPL_TeleportPassNW		)	{	return  Spell_Logic_TeleportPassNW		(manaInvested); };
	if (activeSpell == SPL_TeleportPassOW		)	{	return  Spell_Logic_TeleportPassOW		(manaInvested); };
	if (activeSpell == SPL_TeleportOC			)	{	return  Spell_Logic_TeleportOC			(manaInvested); };
	if (activeSpell == SPL_TeleportOWDemonTower)	{	return  Spell_Logic_TeleportOWDemonTower(manaInvested); };
	if (activeSpell == SPL_TeleportTaverne		)	{	return  Spell_Logic_TeleportTaverne		(manaInvested); };
	//Runen und Scrolls
	//Kreis 1
	if (activeSpell == SPL_LIGHT				)	{	return  Spell_Logic_Light				(manaInvested); };
	if (activeSpell == SPL_Firebolt				)	{	return	Spell_Logic_Firebolt			(manaInvested);	};
	if (activeSpell == SPL_Icebolt				)	{	return	Spell_Logic_Icebolt				(manaInvested);	};
	if (activeSpell == SPL_Zap					)	{	return	Spell_Logic_Zap					(manaInvested);	};
	if (activeSpell == SPL_LightHeal			)	{	return	Spell_Logic_LightHeal			(manaInvested);	};
	if (activeSpell == SPL_SummonGoblinSkeleton)	{	return	Spell_Logic_SummonGoblinSkeleton(manaInvested);	};
	//Kreis 2
	if (activeSpell == SPL_InstantFireball		)	{	return	Spell_Logic_InstantFireball	(manaInvested);	};
	if (activeSpell == SPL_SummonWolf			)	{	return	Spell_Logic_SummonWolf		(manaInvested);	};
	if (activeSpell == SPL_WINDFIST				)	{	return	Spell_Logic_Windfist		(manaInvested);	};
	if (activeSpell == SPL_Sleep				)	{	return	Spell_Logic_Sleep			(manaInvested);	};
	//Kreis 3
	if (activeSpell == SPL_MediumHeal			)	{	return	Spell_Logic_MediumHeal		(manaInvested);	};
	if (activeSpell == SPL_LightningFlash		) 	{	return	Spell_Logic_LightningFlash	(manaInvested);	};
	if (activeSpell == SPL_ChargeFireball	    ) 	{	return	Spell_Logic_ChargeFireball	(manaInvested);	};
	if (activeSpell == SPL_ChargeZap		    ) 	{	return	Spell_Logic_ChargeZap		(manaInvested);	};
	if (activeSpell == SPL_SummonSkeleton	    ) 	{	return	Spell_Logic_SummonSkeleton	(manaInvested);	};
	if (activeSpell == SPL_Fear	    			) 	{	return	Spell_Logic_Fear			(manaInvested);	};
	if (activeSpell == SPL_IceCube	    		) 	{	return	Spell_Logic_IceCube			(manaInvested);	};
	//Kreis 4
	if (activeSpell == SPL_ChargeZap	    	) 	{	return	Spell_Logic_ChargeZap		(manaInvested);	};
	if (activeSpell == SPL_SummonGolem   		) 	{	return	Spell_Logic_SummonGolem		(manaInvested);	};
	if (activeSpell == SPL_DestroyUndead 		)	{	return	Spell_Logic_DestroyUndead	(manaInvested);	};
	if (activeSpell == SPL_Pyrokinesis	    	) 	{	return	Spell_Logic_Pyrokinesis		(manaInvested);	};
	//Kreis 5
	if (activeSpell == SPL_Firestorm       		) 	{	return	Spell_Logic_Firestorm		(manaInvested);	};
	if (activeSpell == SPL_IceWave        		) 	{	return	Spell_Logic_IceWave			(manaInvested);	};
	if (activeSpell == SPL_SummonDemon			)	{	return	Spell_Logic_SummonDemon		(manaInvested);	};
	if (activeSpell == SPL_FullHeal				)	{	return	Spell_Logic_FullHeal		(manaInvested);	};
	//Kreis 6
	if (activeSpell == SPL_Firerain				)	{	return	Spell_Logic_Firerain		(manaInvested);	};
	if (activeSpell == SPL_BreathOfDeath		)	{	return	Spell_Logic_BreathOfDeath	(manaInvested);	};
	if (activeSpell == SPL_MassDeath			)	{	return	Spell_Logic_MassDeath		(manaInvested);	};
	if (activeSpell == SPL_ArmyOfDarkness		)	{	return	Spell_Logic_ArmyOfDarkness	(manaInvested);	};
	if (activeSpell == SPL_Shrink				)	{	return	Spell_Logic_Shrink			(manaInvested);	};
	//Scrolls
	if (activeSpell == SPL_TrfSheep	    		)	{	return	Spell_Logic_TrfSheep 		(manaInvested);	};
	if (activeSpell == SPL_TrfScavenger			)	{	return	Spell_Logic_TrfScavenger 	(manaInvested);	};
	if (activeSpell == SPL_TrfGiantRat			)	{	return	Spell_Logic_TrfGiantRat		(manaInvested);	};
	if (activeSpell == SPL_TrfGiantBug			)	{	return	Spell_Logic_TrfGiantBug		(manaInvested);	};
	if (activeSpell == SPL_TrfWolf				)	{	return	Spell_Logic_TrfWolf			(manaInvested);	};
	if (activeSpell == SPL_TrfWaran				)	{	return	Spell_Logic_TrfWaran		(manaInvested);	};
	if (activeSpell == SPL_TrfSnapper			)	{	return	Spell_Logic_TrfSnapper		(manaInvested);	};
	if (activeSpell == SPL_TrfWarg				)	{	return	Spell_Logic_TrfWarg			(manaInvested);	};
	if (activeSpell == SPL_TrfFireWaran			)	{	return	Spell_Logic_TrfFireWaran	(manaInvested);	};
	if (activeSpell == SPL_TrfLurker			)	{	return	Spell_Logic_TrfLurker		(manaInvested);	};
	if (activeSpell == SPL_TrfShadowbeast		)	{	return	Spell_Logic_TrfShadowbeast	(manaInvested);	};
	if (activeSpell == SPL_TrfDragonSnapper		)	{	return	Spell_Logic_TrfDragonSnapper(manaInvested);	};
	if (activeSpell == SPL_Charm				)	{	return	Spell_Logic_Charm			(manaInvested);	};
	if (activeSpell == SPL_MasterOfDisaster		)	{	return	Spell_Logic_MasterOfDisaster(manaInvested);	};
	
	if (activeSpell == SPL_ConcussionBolt		)	{	return	Spell_Logic_ConcussionBolt	(manaInvested);	};
	if (activeSpell == SPL_Deathbolt			)	{	return	Spell_Logic_Deathbolt		(manaInvested);	};
	if (activeSpell == SPL_Deathball			)	{	return	Spell_Logic_Deathball		(manaInvested);	};
	
	//water
	if (activeSpell == SPL_Thunderstorm			)	{	return	Spell_Logic_Thunderstorm	(manaInvested);	};
	if (activeSpell == SPL_Waterfist			)	{	return	Spell_Logic_Waterfist		(manaInvested);	};
	if (activeSpell == SPL_Whirlwind			)	{	return	Spell_Logic_Whirlwind		(manaInvested);	};
	if (activeSpell == SPL_Geyser				) 	{	return	Spell_Logic_Geyser			(manaInvested);	};
	if (activeSpell == SPL_Inflate				) 	{	return	Spell_Logic_Inflate			(manaInvested);	};
	if (activeSpell == SPL_Icelance				) 	{	return	Spell_Logic_Icelance		(manaInvested);	};
	
	//beliar magic
	if (activeSpell == SPL_Swarm				)	{	return	Spell_Logic_Swarm			(manaInvested);	};
	if (activeSpell == SPL_Greententacle		)	{	return	Spell_Logic_Greententacle	(manaInvested);	};
	if (activeSpell == SPL_SummonGuardian		)	{	return	Spell_Logic_SummonGuardian	(manaInvested);	};
	if (activeSpell == SPL_Energyball			)	{	return	Spell_Logic_Energyball		(manaInvested);	};
	if (activeSpell == SPL_SuckEnergy			)	{	return	Spell_Logic_SuckEnergy		(manaInvested);	};
	if (activeSpell == SPL_Skull				)	{	return	Spell_Logic_Skull			(manaInvested);	};
	if (activeSpell == SPL_SummonZombie			)	{	return	Spell_Logic_SummonZombie	(manaInvested);	};
	if (activeSpell == SPL_SummonMud			)	{	return	Spell_Logic_SummonMud		(manaInvested);	};

//Leer

//	if (Npc_GetActiveSpell(self) == SPL_B					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_C					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_D					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_E					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_F					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_G					)	{	return	Spell_Logic_XXX				(manaInvested);	};
//	if (Npc_GetActiveSpell(self) == SPL_H					)	{	return	Spell_Logic_XXX				(manaInvested);	};
};
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
                    Doc_PrintLine	( nDocID,  0, "Moe - schl�gt Leute und w�scht sich nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Ignaz - fand den Eingang nicht."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Alwin - will seine Frau nicht betruegen."					);
                    Doc_PrintLine	( nDocID,  0, "");
                    Doc_PrintLine	( nDocID,  0, "Fellan - h�mmern kann er, aber vom Nageln"					);
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
                    Doc_PrintLine	( nDocID,  0, "Vatras - erz�hlt immer etwas von diesem Adanos,"					);
                    Doc_PrintLine	( nDocID,  0, "der uns zusieht."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Lord Hagen - auch ein Diener Innos"					);
                    Doc_PrintLine	( nDocID,  0, " muss bedient werden."					);
                    Doc_PrintLine	( nDocID,  0, ""					);
                    Doc_PrintLine	( nDocID,  0, "Pyrokar - von seiner Zauberkraft war"	);
                    Doc_PrintLine	( nDocID,  0, "nichts zu sp�ren.");
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
	name 					=	"Das Manifest der Aufrei�er";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	400;

	visual 					=	"ItWr_Book_02_02.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	description			    =	"Erh�ht das Talent Aufrei�er um maximal 20%. Die Grenze von 100% kann nicht �berschritten werden.";

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
            PrintScreen	("Verbessere: Aufrei�en", -1, -1, FONT_Screen, 2);

			Print ("Manifest der Aufrei�er gelesen.");
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
	name 					=	"Zuh�lterei f�r Fortgeschrittene";

	mainflag 				=	ITEM_KAT_DOCS;
	flags 					=	ITEM_MISSION;

	value 					=	400;

	visual 					=	"ItWr_Book_02_02.3ds";  					//BUCH VARIATIONEN: ItWr_Book_01.3DS , ItWr_Book_02_01.3DS, ItWr_Book_02_02.3DS, ItWr_Book_02_03.3DS, ItWr_Book_02_04.3DS, ItWr_Book_02_05.3DS
	material 				=	MAT_LEATHER;

	description			    =	"Erh�ht das Talent Zuh�lter um einen Kreis. Die Grenze von 6 kann nicht �berschritten werden.";

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
            PrintScreen	("Verbessere: Zuh�lter", -1, -1, FONT_Screen, 2);

			Print ("Zuh�lterei f�r Fortgeschrittene gelesen.");
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
// *************************************************************************
// 									AUFREISSEN
// *************************************************************************
INSTANCE DIA_AUFREISSEN(C_INFO)
{
	nr			= 800;
	condition	= DIA_AUFREISSEN_Condition;
	information	= DIA_AUFREISSEN_Info;
	permanent	= TRUE;
	description = "(Aufrei�en)";
};
func INT DIA_AUFREISSEN_Condition()
{
	return Npc_GetTalentSkill (other,NPC_TALENT_WOMANIZER) > 0;
};

FUNC VOID DIA_AUFREISSEN_Info()
{
    B_Aufreissen();
};

// *************************************************************************
// 									PIMP
// *************************************************************************
INSTANCE DIA_PIMP(C_INFO)
{
	nr			= 801;
	condition	= DIA_PIMP_Condition;
	information	= DIA_PIMP_Info;
	permanent	= TRUE;
	description = "(Geld eintreiben)";
};
func INT DIA_PIMP_Condition()
{
	return Npc_GetTalentSkill (other,NPC_TALENT_PIMP) > 0;
};

FUNC VOID DIA_PIMP_Info()
{
    B_Pimp();
};

// *********************************************************
// ---------------------------------------------------------

func void B_AssignSonja(var C_NPC slf)
{
    // Keine Suchenden usw.
    if (C_NpcBelongsToOldCamp(slf) || C_NpcBelongsToCity(slf) || C_NpcBelongsToMonastery(slf) || C_NpcBelongsToFarm(slf))
    {
        DIA_AUFREISSEN.npc = Hlp_GetInstanceID(slf);
        DIA_PIMP.npc = Hlp_GetInstanceID(slf);
    };
};



var int AufreisserVictimCount;
var int AufreisserVictimLevel;
var int AufreisserLevel;

const int AufreisserXP = 30;
//------------------------------------------------------------------
FUNC VOID B_GiveAufreisserXP()
{

	AufreisserLevel = (AufreisserLevel +1);//z�hl die Opfer


	if (AufreisserLevel == 0)
	{
		AufreisserLevel = 2; //Start
	};

	if (AufreisserVictimCount >= AufreisserVictimLevel)
	{
		//----------------Kalkulation-----------------

		AufreisserLevel = (AufreisserLevel +1);
		AufreisserVictimLevel =(AufreisserVictimLevel  + AufreisserLevel); //Erh�he die Anzahl der st�ndigen Opfer zum n�chsten Level (aktuelleOpfer + aktueller Level)

		//Platz für Goodies (Items, Attributes...)
	};

		//-------------------XP-----------------------

		B_GivePlayerXP (AufreisserXP + (AufreisserLevel * 10));
};
//------------------------------------------------------------------
FUNC VOID B_ResetAufreisserLevel()
{


	if (AufreisserVictimCount > AufreisserLevel)
	{
		AufreisserVictimCount = (AufreisserVictimCount - 1);
	};


};

func void B_Aufreissen ()
{
    var int random;
    random = Hlp_Random(100);


	if (Npc_GetTalentSkill (other,NPC_TALENT_WOMANIZER) > random)
	{
        AI_UnequipArmor(self);
		B_GiveAufreisserXP();//B_GivePlayerXP (XP_Ambient);
		CreateInvItems (other, ItPo_Health_02, 2);
		//Snd_Play ("Geldbeutel");
		AI_OutputSVM(self,other, "TOUGHGUY_ATTACKWON"); // ADDON_WRONGARMOR SC_HeyWaitASecond
	}
	else
	{
        AI_EquipBestArmor(self);
		B_ResetAufreisserLevel();
		AI_StopProcessInfos	(self);
		B_Attack (self, other, AR_UseMob, 1); //reagiert trotz IGNORE_Theft mit NEWS
	};
};
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
    B_SetNpcPimpDay(self, Wld_GetDay());
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
var int Sonja_ItemsGiven_Chapter_1;
var int Sonja_ItemsGiven_Chapter_2;
var int Sonja_ItemsGiven_Chapter_3;
var int Sonja_ItemsGiven_Chapter_4;
var int Sonja_ItemsGiven_Chapter_5;

FUNC VOID B_GiveTradeInv_Sonja (var C_NPC slf)
{
	if ((Kapitel >= 1)
	&& (Sonja_ItemsGiven_Chapter_1 == FALSE))
	{
		CreateInvItems (slf, ItMi_Gold, 100);
		CreateInvItems (slf,ItPo_Mana_01 	,10);
		CreateInvItems (slf,ItPo_Health_01	,10);
		CreateInvItems (slf, ItPo_Health_Addon_04,	2);
		CreateInvItems (slf, ItPo_Mana_Addon_04,		2);
		CreateInvItems (slf,ItMi_ApfelTabak	,2); //für Abuyin

		// ------ Scrolls ------
		CreateInvItems (slf,ItSc_Light			,6);
		CreateInvItems (slf,ItSc_Sleep			,1);
		CreateInvItems (slf,ItSc_Firebolt 		,20);
		CreateInvItems (slf,ItSc_Icebolt 		,8);
		CreateInvItems (slf,ItSc_InstantFireball ,10);
		CreateInvItems (slf,ItSc_LightningFlash	,5);
		CreateInvItems (slf,ItSc_HarmUndead		,3);
		CreateInvItems (slf,ItSc_Firestorm 		,3);
		CreateInvItems (slf,ItSc_IceWave		,1);
		CreateInvItems (slf,ItSc_Zap	 		,5);
		CreateInvItems (slf,ItSc_IceCube		,3);
		CreateInvItems (slf,ItSc_Windfist 		,3);
		CreateInvItems (slf,ItSc_IceWave		,1);
		CreateInvItems (slf,ItSc_Firerain		,1);
		CreateInvItems (slf,ItSc_Shrink 		,1);
		CreateInvItems (slf,ItSc_ThunderStorm 	,1);

		CreateInvItems (slf,ItSc_SumGobSkel	,1);
		CreateInvItems (slf,ItSc_SumSkel	,1);
		CreateInvItems (slf,ItSc_SumWolf	,1);
		CreateInvItems (slf,ItSc_SumGol		,1);
		CreateInvItems (slf,ItSc_SumDemon	,1);

		// ------ AmRiBe ------
		CreateInvItems (slf,ItBe_Addon_Prot_MAGIC, 1);
		CreateInvItems (slf,ItAm_Hp_Mana_01 ,1);

		// Alchemie
		CreateInvItems (slf, ItMi_Flask, 5);
		CreateInvItems (slf, ItPl_Temp_Herb, 10);
		CreateInvItems (slf, ItPl_SwampHerb, 2);
		CreateInvItems (slf, ItPl_Health_Herb_01, 5);
		CreateInvItems (slf, ItPl_Health_Herb_02, 2);
		CreateInvItems (slf, ItPl_Mana_Herb_01, 5);
		CreateInvItems (slf, ItAt_GoblinBone, 1);
		CreateInvItems (slf, ItAt_Wing, 3);

		// Schmieden
		CreateInvItems (slf,ItMw_1H_Mace_L_04	,1);

		// Fernkampf
		CreateInvItems (slf,ItRw_Arrow	,100);
		CreateInvItems (slf,ItRw_Bolt	,100);
		CreateInvItems (slf,ItRw_Addon_MagicArrow	,100);
		CreateInvItems (slf,ItRw_Addon_FireArrow	,100);
		CreateInvItems (slf,ItRw_Addon_MagicBolt	,100);

		// Talente
		CreateInvItems (slf,ItWr_Womanizer	,1);
		CreateInvItems (slf,ItWr_Pimp	,1);

		Sonja_ItemsGiven_Chapter_1 = TRUE;
	};

	if ((Kapitel >= 2)
	&& Sonja_ItemsGiven_Chapter_2 == FALSE)
	{
		CreateInvItems (slf, ItMi_Gold, 60);
		CreateInvItems   (slf, ItPo_Health_Addon_04,	2);
		CreateInvItems   (slf, ItPo_Mana_Addon_04,		2);
		CreateInvItems (slf,ItPo_Mana_01 	,15);
		CreateInvItems (slf,ItPo_Mana_02 	, 1);
		CreateInvItems (slf,ItPo_Health_01	,15);
		CreateInvItems (slf,ItPo_Health_02	, 2);
		CreateInvItems (slf,ItMi_ApfelTabak	,5);
		CreateInvItems (slf,ItPo_Perm_Str, 1);

		// Alchemie
		CreateInvItems (slf, ItMi_Flask, 5);
		CreateInvItems (slf, ItPl_Temp_Herb, 10);
		CreateInvItems (slf, ItPl_SwampHerb, 2);
		CreateInvItems (slf, ItPl_Health_Herb_01, 5);
		CreateInvItems (slf, ItPl_Health_Herb_02, 2);
		CreateInvItems (slf, ItPl_Mana_Herb_01, 5);
		CreateInvItems (slf, ItAt_GoblinBone, 1);
		CreateInvItems (slf, ItAt_Wing, 2);
		CreateInvItems (slf, ItMi_Rockcrystal, 2);
		CreateInvItems (slf, ItAt_GoblinBone, 2);
		CreateInvItems (slf, ItPl_Mushroom_01, 5);

		// Fernkampf
		CreateInvItems (slf,ItRw_Arrow	,100);
		CreateInvItems (slf,ItRw_Bolt	,100);
		CreateInvItems (slf,ItRw_Addon_MagicArrow	,100);
		CreateInvItems (slf,ItRw_Addon_FireArrow	,100);
		CreateInvItems (slf,ItRw_Addon_MagicBolt	,100);

		Sonja_ItemsGiven_Chapter_2 = TRUE;
	};

	if ((Kapitel >= 3)
	&& (Sonja_ItemsGiven_Chapter_3 == FALSE))
	{
		CreateInvItems (slf, ItMi_Gold, 120);
		CreateInvItems   (slf, ItPo_Health_Addon_04,	2);
		CreateInvItems   (slf, ItPo_Mana_Addon_04,		2);
		CreateInvItems (slf,ItPo_Mana_01 	,25);
		CreateInvItems (slf,ItPo_Mana_02 	, 3);
		CreateInvItems (slf,ItPo_Health_01	,25);
		CreateInvItems (slf,ItPo_Health_02	, 15);
		CreateInvItems (slf,ItPo_Perm_Mana	, 1);
		CreateInvItems (slf, ItPo_Speed, 1);

		// Alchemie
		CreateInvItems (slf, ItMi_Flask, 5);
		CreateInvItems (slf, ItPl_Temp_Herb, 10);
		CreateInvItems (slf, ItPl_SwampHerb, 2);
		CreateInvItems (slf, ItPl_Health_Herb_01, 5);
		CreateInvItems (slf, ItPl_Health_Herb_02, 2);
		CreateInvItems (slf, ItPl_Mana_Herb_01, 5);
		CreateInvItems (slf, ItAt_GoblinBone, 1);
		CreateInvItems (slf, ItAt_Wing, 2);
		CreateInvItems (slf, ItMi_Rockcrystal, 2);
		CreateInvItems (slf, ItAt_GoblinBone, 2);
		CreateInvItems (slf, ItPl_Mushroom_01, 5);

		// Fernkampf
		CreateInvItems (slf,ItRw_Arrow	,100);
		CreateInvItems (slf,ItRw_Bolt	,100);
		CreateInvItems (slf,ItRw_Addon_MagicArrow	,100);
		CreateInvItems (slf,ItRw_Addon_FireArrow	,100);
		CreateInvItems (slf,ItRw_Addon_MagicBolt	,100);

		Sonja_ItemsGiven_Chapter_3 = TRUE;
	};

	if ((Kapitel >= 4)
	&& (Sonja_ItemsGiven_Chapter_4 == FALSE))
	{
		CreateInvItems (slf, ItMi_Gold, 220);
		CreateInvItems   (slf, ItPo_Health_Addon_04,	3);
		CreateInvItems   (slf, ItPo_Mana_Addon_04,		3);
		CreateInvItems (slf,ItPo_Mana_01 	,35);
		CreateInvItems (slf,ItPo_Mana_02 	, 15);
		CreateInvItems (slf,ItPo_Health_01	,35);
		CreateInvItems (slf,ItPo_Health_02	, 20);
		CreateInvItems (slf,ItPo_Health_03	, 10);
		CreateInvItems (slf,ItPo_Perm_Mana	, 1);
		CreateInvItems (slf, ItPo_Speed, 1);

        // Alchemie
		CreateInvItems (slf, ItMi_Flask, 5);
		CreateInvItems (slf, ItPl_Temp_Herb, 10);
		CreateInvItems (slf, ItPl_SwampHerb, 2);
		CreateInvItems (slf, ItPl_Health_Herb_01, 5);
		CreateInvItems (slf, ItPl_Health_Herb_02, 2);
		CreateInvItems (slf, ItPl_Mana_Herb_01, 5);
		CreateInvItems (slf, ItAt_GoblinBone, 1);
		CreateInvItems (slf, ItAt_Wing, 2);
		CreateInvItems (slf, ItMi_Rockcrystal, 2);
		CreateInvItems (slf, ItAt_GoblinBone, 2);
		CreateInvItems (slf, ItPl_Mushroom_01, 5);

		// Fernkampf
		CreateInvItems (slf,ItRw_Arrow	,100);
		CreateInvItems (slf,ItRw_Bolt	,100);
		CreateInvItems (slf,ItRw_Addon_MagicArrow	,100);
		CreateInvItems (slf,ItRw_Addon_FireArrow	,100);
		CreateInvItems (slf,ItRw_Addon_MagicBolt	,100);

		Sonja_ItemsGiven_Chapter_4 = TRUE;
	};

	if ((Kapitel >= 5)
	&& (Sonja_ItemsGiven_Chapter_5 == FALSE))
	{
		CreateInvItems (slf, ItMi_Gold, 321);
		CreateInvItems   (slf, ItPo_Health_Addon_04,	5);
		CreateInvItems   (slf, ItPo_Mana_Addon_04,		5);
		CreateInvItems (slf,ItPo_Mana_01 	,55);
		CreateInvItems (slf,ItPo_Mana_02 	, 35);
		CreateInvItems (slf,ItPo_Mana_03 	, 15);
		CreateInvItems (slf,ItPo_Health_01	,55);
		CreateInvItems (slf,ItPo_Health_02	, 30);
		CreateInvItems (slf,ItPo_Health_03	, 20);
		CreateInvItems (slf,ItPo_Perm_Health, 1);
		CreateInvItems (slf, ItPo_Speed, 1);
		CreateInvItems (slf, ItMi_RuneBlank, 10);

        // Alchemie
		CreateInvItems (slf, ItMi_Flask, 5);
		CreateInvItems (slf, ItPl_Temp_Herb, 10);
		CreateInvItems (slf, ItPl_SwampHerb, 2);
		CreateInvItems (slf, ItPl_Health_Herb_01, 5);
		CreateInvItems (slf, ItPl_Health_Herb_02, 2);
		CreateInvItems (slf, ItPl_Mana_Herb_01, 5);
		CreateInvItems (slf, ItAt_GoblinBone, 1);
		CreateInvItems (slf, ItAt_Wing, 2);
		CreateInvItems (slf, ItMi_Rockcrystal, 2);
		CreateInvItems (slf, ItAt_GoblinBone, 2);
		CreateInvItems (slf, ItPl_Mushroom_01, 5);

		// Fernkampf
		CreateInvItems (slf,ItRw_Arrow	,100);
		CreateInvItems (slf,ItRw_Bolt	,100);
		CreateInvItems (slf,ItRw_Addon_MagicArrow	,100);
		CreateInvItems (slf,ItRw_Addon_FireArrow	,100);
		CreateInvItems (slf,ItRw_Addon_MagicBolt	,100);

		CreateInvItems (slf,ItRu_SummonDragon	,1);

		Sonja_ItemsGiven_Chapter_5 = TRUE;
	};
};
// ******************************************************************
// B_ApplySonjaStats
// ---------------
// setzt die gespeicherten Attribute und Talente für den NSC.
// ******************************************************************
var int SonjaEXP;
var int SonjaEXP_NEXT;
var int SonjaLP;
var int SonjaLevel;
var int SonjaSTR;
var int SonjaDEX;
var int SonjaHP_MAX;
var int SonjaMANA_MAX;
// Hit Chances
var int SonjaHitChance1H;
var int SonjaHitChance2H;
var int SonjaHitChanceBow;
var int SonjaHitChanceCrossBow;
// Talente
var int SonjaTalent1H;
var int SonjaTalent2H;
var int SonjaTalentBow;
var int SonjaTalentCrossBow;
var int SonjaTalentMage;
var int SonjaTalentSneak;
var int SonjaTalentAcrobat;
// Inventar
var int SonjaEquippedArmor;
var int SonjaEquippedMeleeWeapon;
var int SonjaEquippedRangedWeapon;
var int SonjaInventoryItem[100];

// Erlerntes Speichern für Reset
var int SonjaRaisedAttributes[ATR_INDEX_MAX];
var int SonjaRaisedAttributesSpentLP[ATR_INDEX_MAX];

func void B_StoreSonjaStats(var C_NPC slf)
{
    SonjaLP = slf.lp;
    SonjaEXP = slf.exp;
    SonjaEXP_NEXT = slf.exp_next;
    SonjaLevel = slf.level;

    SonjaSTR = slf.attribute[ATR_STRENGTH];
    SonjaDEX = slf.attribute[ATR_DEXTERITY];
    SonjaMANA_MAX = slf.attribute[ATR_MANA_MAX];
    SonjaHP_MAX = slf.attribute[ATR_HITPOINTS_MAX];
    SonjaHitChance1H = slf.aivar[REAL_TALENT_1H];
    SonjaHitChance2H = slf.aivar[REAL_TALENT_2H];
    SonjaHitChanceBow = slf.aivar[REAL_TALENT_BOW];
    SonjaHitChanceCrossBow = slf.aivar[REAL_TALENT_CROSSBOW];

    SonjaTalentMage = Npc_GetTalentSkill(slf, NPC_TALENT_MAGE);
    SonjaTalentSneak = Npc_GetTalentSkill(slf, NPC_TALENT_SNEAK);
    SonjaTalentAcrobat = Npc_GetTalentSkill(slf, NPC_TALENT_ACROBAT);

    SonjaEquippedArmor = Hlp_GetInstanceID(Npc_GetEquippedArmor());
    SonjaEquippedMeleeWeapon = Hlp_GetInstanceID(Npc_GetEquippedMeleeWeapon());
    SonjaEquippedRangedWeapon = Hlp_GetInstanceID(Npc_GetEquippedRangedWeapon());
};

func void B_ApplySonjaStats(var C_NPC slf)
{
    slf.lp = SonjaLP;
    slf.exp = SonjaEXP;
    slf.exp_next = SonjaEXP_NEXT;
    slf.level = SonjaLevel;
    slf.attribute[ATR_STRENGTH] = SonjaSTR;
    slf.attribute[ATR_DEXTERITY] = SonjaDEX;
    slf.attribute[ATR_MANA_MAX] = SonjaMANA_MAX;
    slf.attribute[ATR_HITPOINTS_MAX] = SonjaHP_MAX;
    slf.HitChance[NPC_TALENT_1H] = SonjaHitChance1H;
    slf.aivar[REAL_TALENT_1H] = SonjaHitChance1H;
    slf.HitChance[NPC_TALENT_2H] = SonjaHitChance2H;
    slf.aivar[REAL_TALENT_2H] = SonjaHitChance2H;
    slf.HitChance[NPC_TALENT_BOW] = SonjaHitChanceBow;
    slf.aivar[REAL_TALENT_BOW] = SonjaHitChanceBow;
    slf.HitChance[NPC_TALENT_CROSSBOW] = SonjaHitChanceCrossBow;
    slf.aivar[REAL_TALENT_CROSSBOW] = SonjaHitChanceCrossBow;

    Npc_SetTalentSkill (slf, NPC_TALENT_MAGE, SonjaTalentMage);
    Npc_SetTalentSkill (slf, NPC_TALENT_SNEAK, SonjaTalentSneak);
    Npc_SetTalentSkill (slf, NPC_TALENT_ACROBAT, SonjaTalentAcrobat);

    if (SonjaEquippedArmor != 0)
    {
        if (Npc_HasItems(slf, SonjaEquippedArmor) == FALSE)
        {
            CreateInvItem(slf, SonjaEquippedArmor);
        };

        EquipItem(slf, SonjaEquippedArmor);
    };

    if (SonjaEquippedMeleeWeapon != 0)
    {
        if (Npc_HasItems(slf, SonjaEquippedMeleeWeapon) == FALSE)
        {
            CreateInvItem(slf, SonjaEquippedMeleeWeapon);
        };

        EquipItem(slf, SonjaEquippedMeleeWeapon);
    };

    if (SonjaEquippedRangedWeapon != 0)
    {
        if (Npc_HasItems(slf, SonjaEquippedRangedWeapon) == FALSE)
        {
            CreateInvItem(slf, SonjaEquippedRangedWeapon);
        };

        EquipItem(slf, SonjaEquippedRangedWeapon);
    };
};

func void B_ResetSonjaAttributesStartingFrom(var C_NPC slf, var int attrib)
{
    if (attrib == ATR_STRENGTH)
	{
        slf.attribute[ATR_STRENGTH] = slf.attribute[ATR_STRENGTH] - SonjaRaisedAttributes[ATR_STRENGTH];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_STRENGTH];
	}
	// ------ DEX steigern ------
	else if (attrib == ATR_DEXTERITY)
	{
		slf.attribute[ATR_DEXTERITY] = slf.attribute[ATR_DEXTERITY] - SonjaRaisedAttributes[ATR_DEXTERITY];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_DEXTERITY];

			//if (oth.attribute[ATR_DEXTERITY] >= 90)
			//&& (Npc_GetTalentSkill (oth, NPC_TALENT_ACROBAT) == 0)
			//{
				//Npc_SetTalentSkill 	(oth, NPC_TALENT_ACROBAT, 1);
				//PrintScreen	(PRINT_Addon_AcrobatBonus, -1, 55, FONT_Screen, 2);
			//};

	}
	// ------ MANA_MAX steigern ------
	else if (attrib == ATR_MANA_MAX)
	{
        slf.attribute[ATR_MANA_MAX] = slf.attribute[ATR_MANA_MAX] - SonjaRaisedAttributes[ATR_MANA_MAX];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_MANA_MAX];
	}
	// ------ HITPOINTS_MAX steigern ------
	else if (attrib == ATR_HITPOINTS_MAX)
	{
        slf.attribute[ATR_HITPOINTS_MAX] = slf.attribute[ATR_HITPOINTS_MAX] - SonjaRaisedAttributes[ATR_HITPOINTS_MAX];
        slf.lp = slf.lp + SonjaRaisedAttributesSpentLP[ATR_HITPOINTS_MAX];
	};

	var int next;
    next = attrib + 1;

    if (next < ATR_INDEX_MAX)
    {
        B_ResetSonjaAttributesStartingFrom(slf, next);
    };
};

// Setzt erlernte Attribute zurück und gibt dem NPC die dafür ausgegebenen Lernpunkte zurück. Sollte nur für die eine Sonja aufgerufen werden.
func void B_ResetSonja(var C_NPC slf)
{
    B_ResetSonjaAttributesStartingFrom(slf, 0);
};

//###############################################
//##
//##	Die Dracheninsel
//##
//###############################################
FUNC VOID STARTUP_NEWWORLD_PART_DRAGON_ISLAND_01 ()
{
    // Sonja
	Wld_InsertNpc (VLK_436_Sonja	 	, "SHIP_DECK_01");	//???

	//-- Grotte -------------------------------------------
	
	Wld_InsertNpc 	(Firewaran, 	"FP_ROAM_DI_WARAN_01");	
	Wld_InsertNpc 	(Firewaran, 	"FP_ROAM_DI_WARAN_02");	
	Wld_InsertNpc 	(Firewaran, 	"FP_ROAM_DI_WARAN_03");	

	//----- Die Orks -----

	Wld_InsertNpc 	(Troll_DI, 	"DI_ORKAREA_TROLL");		
	Wld_InsertItem	(ItMi_DarkPearl , "FP_ITEM_DI_ENTER_03"); //Joly: Zutat f�r ItPo_MegaDrink
	Wld_InsertItem	(ItMi_Sulfur 	, "FP_ITEM_DI_ENTER_07"); //Joly: Zutat f�r ItPo_MegaDrink
	Wld_InsertItem	(ItWr_ZugBruecke_MIS, "FP_ITEM_DI_ENTER_09"); //Joly: Hinweis, die Zugbr�ckenProblematik zu l�sen.

	Wld_InsertNpc 	(OrcWarrior_Rest, 	"FP_ROAM_DI_ORK_01");	
	Wld_InsertNpc 	(OrcWarrior_Rest, 	"FP_ROAM_DI_ORK_02");	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_03");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_04");	
	Wld_InsertNpc 	(OrcShaman_Sit, 	"FP_ROAM_DI_ORK_05");	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_06");	
	Wld_InsertNpc 	(OrcWarrior_Rest, 	"FP_ROAM_DI_ORK_07");	
	Wld_InsertNpc 	(OrcElite_Rest , 	"FP_ROAM_DI_ORK_08");	
	Wld_InsertNpc 	(OrcWarrior_Rest, 	"FP_ROAM_DI_ORK_09");	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_11");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_14");	
	Wld_InsertNpc 	(OrcShaman_Sit, 	"FP_ROAM_DI_ORK_15");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_16");	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_17");	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_18");	
	Wld_InsertNpc 	(OrcWarrior_Rest, 	"FP_ROAM_DI_ORK_19");	
	Wld_InsertNpc 	(OrcShaman_Sit, 	"FP_ROAM_DI_ORK_20");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_21");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_22");	
	Wld_InsertNpc 	(OrcElite_Rest, 	"FP_ROAM_DI_ORK_23");	

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"FP_ROAM_DI_ORK_28");	
	Wld_InsertNpc 	(OrcElite_Roam, 	"FP_ROAM_DI_ORK_29");	
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"FP_ROAM_DI_ORK_30");	
	Wld_InsertNpc 	(OrcElite_Roam, 	"FP_ROAM_DI_ORK_33");	
	Wld_InsertNpc 	(OrcElite_Roam, 	"FP_ROAM_DI_ORK_34");	
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"FP_ROAM_DI_ORK_35");	
	
	Wld_InsertNpc 	(Warg, 	"FP_ROAM_DI_ORK_12");	
	Wld_InsertNpc 	(OrcShaman_Sit, 	"FP_ROAM_DI_ORK_13");	
	Wld_InsertNpc 	(OrkElite_AntiPaladinOrkOberst_DI, 	"DI_ORKOBERST");	
	Wld_InsertNpc 	(OrcElite_DIOberst1_Rest, 	"FP_ROAM_DI_ORK_24");	
	Wld_InsertNpc 	(OrcElite_DIOberst2_Rest, 	"FP_ROAM_DI_ORK_26");	
	Wld_InsertNpc 	(OrcElite_DIOberst3_Rest, 	"FP_ROAM_DI_ORK_27");	

	Wld_InsertNpc 	(DMT_DementorAmbientSpeaker, 	"DI_ORKAREA_24");		
	Wld_InsertNpc 	(DMT_DementorAmbientSpeaker, 	"DI_DRACONIANAREA_22");		
	Wld_InsertNpc 	(DMT_DementorAmbientSpeaker, 	"DI_DRACONIANAREA_08");		
	//----- Die Draconier -----
	Wld_InsertNpc 	(Dragon_Fire_Island, 	"DI_DRACONIANAREA_FIREDRAGON");	

	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_01");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_02");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_03");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_04");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_05");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_06");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_07");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_08");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_09");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_10");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_11");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_12");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_13");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_14");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_15");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_16");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_17");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_18");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_19");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_20");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_21");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_22");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_23");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_24");		
	Wld_InsertNpc 	(Draconian, 	"FP_ROAM_DI_DRACONIAN_25");		
};
FUNC VOID INIT_NEWWORLD_PART_DRAGON_ISLAND_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
};

FUNC VOID STARTUP_NEWWORLD_PART_DRAGON_UNDEAD_01 ()
{
	//----- Der Schwarzmagiernovize -----
	Wld_InsertItem	(ItWr_Rezept_MegaDrink_MIS 	, "FP_ITEM_DI_BLACKNOV_01"); 
	Wld_InsertItem	(ItWr_Diary_BlackNovice_MIS	, "FP_ITEM_DI_BLACKNOV_02"); 

	//----- Die Untoten -----
	Wld_InsertNpc 	(Skeleton_Lord_Archol, 	"DI_ARCHOL");	
	Wld_InsertNpc 	(Skeleton_Archol1, 	"DI_ARCHOL_SKELETON_01");	
	Wld_InsertNpc 	(Skeleton_Archol2, 	"DI_ARCHOL_SKELETON_02");	
	Wld_InsertNpc 	(Skeleton_Archol3, 	"DI_ARCHOL_SKELETON_03");	
	Wld_InsertNpc 	(Skeleton_Archol4, 	"DI_ARCHOL_SKELETON_04");	
	Wld_InsertNpc 	(Skeleton_Archol5, 	"DI_ARCHOL_SKELETON_05");	
	Wld_InsertNpc 	(Skeleton_Archol6, 	"DI_ARCHOL_SKELETON_06");	
	
	Wld_InsertNpc	(DMT_DementorAmbient,	"DI_DRACONIANAREA_53");
	Wld_InsertNpc	(DMT_DementorAmbient,	"DI_DRACONIANAREA_52");
	Wld_InsertNpc	(Lesser_Skeleton,		"DI_DRACONIANAREA_55");
	Wld_InsertNpc	(Lesser_Skeleton,		"DI_DRACONIANAREA_55");
	Wld_InsertNpc	(Skeleton,				"DI_DRACONIANAREA_56");
	Wld_InsertNpc	(Lesser_Skeleton,		"DI_DRACONIANAREA_56");
	Wld_InsertNpc	(Skeleton,				"DI_DRACONIANAREA_51");
	Wld_InsertNpc	(Lesser_Skeleton,		"DI_DRACONIANAREA_51");
	Wld_InsertNpc	(Skeleton,				"DI_DRACONIANAREA_51");

	//Marios Gruselkabinett
	
	Wld_InsertNpc	(Shadowbeast_Skeleton,	"WP_UNDEAD_SPAWN_POINT_01");

	//Supernova
	Wld_InsertNpc	(Skeleton_Lord,	"WP_UNDEAD_LEFT_DOWN_06");

	Wld_InsertNpc	(OrcElite_Rest,			"WP_UNDEAD_SPAWN_POINT_02");
	Wld_InsertNpc	(OrcElite_Rest,			"WP_UNDEAD_SPAWN_POINT_03");
	Wld_InsertNpc	(OrcShaman_Sit,			"WP_UNDEAD_SPAWN_POINT_04");
	
	Wld_InsertNpc	(Zombie01,				"WP_UNDEAD_SPAWN_POINT_05");
	Wld_InsertNpc	(Zombie02,				"WP_UNDEAD_SPAWN_POINT_06");
	Wld_InsertNpc	(Zombie03,				"WP_UNDEAD_SPAWN_POINT_07");
	Wld_InsertNpc	(Zombie04,				"WP_UNDEAD_SPAWN_POINT_08");
	
	Wld_InsertNpc	(Skeleton,				"DRAGONISLAND_UNDEAD_04_01");
	Wld_InsertNpc	(Skeleton,				"DRAGONISLAND_UNDEAD_04_02");
	
	Wld_InsertNpc	(Skeleton,				"DRAGONISLAND_UNDEAD_08_01");
	Wld_InsertNpc	(Skeleton_Lord,			"DRAGONISLAND_UNDEAD_08_02");
	Wld_InsertNpc	(Skeleton_Lord,			"DRAGONISLAND_UNDEAD_08_03");
	Wld_InsertNpc	(Skeleton,				"DRAGONISLAND_UNDEAD_08_04");
};

FUNC VOID INIT_NEWWORLD_PART_DRAGON_UNDEAD_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
};

FUNC VOID STARTUP_NEWWORLD_PART_DRAGON_FINAL_01 ()
{
	//----- Die Schwarzmagierakademie -----

	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_01,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_02,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_03,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_04,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_05,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbientWalker_DI_06,				"DI_UNDEADDRAGONTEMPEL_01");
	Wld_InsertNpc	(DMT_DementorAmbient,				"DI_UNDEADDRAGONTEMPEL_20");
	Wld_InsertNpc	(DMT_DementorAmbient,				"DI_UNDEADDRAGONTEMPEL_23");

	Wld_InsertNpc	(DMT_1299_OberDementor_DI,		"DI_SCHWARZMAGIER");
	
	Wld_InsertNpc 	(Dragon_Undead, 	"DI_UNDEADDRAGON");	

	// Dragon_Undead Trap UndeadOrks
	Wld_InsertNpc	(UndeadOrcWarrior,	"DI_UNDEADDRAGON_TRAP_01");
	Wld_InsertNpc	(UndeadOrcWarrior,	"DI_UNDEADDRAGON_TRAP_02");
	Wld_InsertNpc	(UndeadOrcWarrior,	"DI_UNDEADDRAGON_TRAP_03");
};

FUNC VOID INIT_NEWWORLD_PART_DRAGON_FINAL_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
};

// ------ DRAGONISLAND -------
FUNC VOID STARTUP_DRAGONISLAND ()
{
		/*	JorgenIsCaptain = TRUE;
	TorlofIsCaptain = TRUE;
	JackIsCaptain = TRUE;

	Lee_IsOnBoard = LOG_SUCCESS;
	MiltenNW_IsOnBoard = LOG_SUCCESS;			//Ist Milten an Bord?
	Lester_IsOnBoard = LOG_SUCCESS;				//Ist Lester an Bord?
	Mario_IsOnBoard = LOG_SUCCESS;				//Ist Mario an Bord?
	Wolf_IsOnBoard = LOG_SUCCESS;				//Ist Wolf an Bord?
	Lares_IsOnBoard = LOG_SUCCESS;				//Ist Lares an Bord?
	Diego_IsOnBoard = LOG_SUCCESS;				//Ist Diego an Bord?
	Bennet_IsOnBoard = LOG_SUCCESS;				//Ist Bennet an Bord?
	Vatras_IsOnBoard = LOG_SUCCESS;				//Ist Vatras an Bord?
	Gorn_IsOnBoard = LOG_SUCCESS;				//Ist Gorn an Bord?	
	Biff_IsOnBoard = LOG_SUCCESS;
	Angar_IsOnBoard = LOG_SUCCESS;
	Girion_IsOnBoard = LOG_SUCCESS;		*/	
	
//----- Die Kapit�ne -----
	
	if ( JorgenIsCaptain == TRUE)	//Jorgen
	{
		Wld_InsertNpc 	(VLK_4250_Jorgen_DI, 	"SHIP_DECK_01");
	};

	if ( TorlofIsCaptain == TRUE)	//Torlof
	{
		Wld_InsertNpc 	(SLD_801_Torlof_DI, 	"SHIP_DECK_01");
	};

	if ( JackIsCaptain == TRUE)		//Jack
	{
		Wld_InsertNpc 	(VLK_444_Jack_DI, 		"SHIP_DECK_01");
	};
	
//----- Die Crew -----
	
	if ( Lee_IsOnBoard == LOG_SUCCESS) //Lee
	{
		Wld_InsertNpc 	(SLD_800_Lee_DI, 		"SHIP_DECK_01");
	};

	if ( MiltenNW_IsOnBoard == LOG_SUCCESS) //Milten
	{
		Wld_InsertNpc 	(PC_Mage_DI, 			"SHIP_DECK_01");
		if ( Lester_IsOnBoard != LOG_SUCCESS) 
			{
				B_StartOtherRoutine	(PC_Mage_DI, "SittingShipDI");
			};
	};

	if ( Lester_IsOnBoard == LOG_SUCCESS)	//Lester
	{
		Wld_InsertNpc 	(PC_Psionic_DI, 		"SHIP_DECK_01");
		if ( MiltenNW_IsOnBoard != LOG_SUCCESS) 
			{
				B_StartOtherRoutine	(PC_Psionic_DI, "SittingShipDI");
			};
	};

	if ( Mario_IsOnBoard == LOG_SUCCESS) //Mario
	{
		Wld_InsertNpc 	(None_101_Mario_DI, 	"SHIP_DECK_01");
	};

	if ( Wolf_IsOnBoard== LOG_SUCCESS) //Wolf
	{
		Wld_InsertNpc 	(SLD_811_Wolf_DI, 		"SHIP_DECK_01");
	};


	if ( Vatras_IsOnBoard == LOG_SUCCESS)	//Vatras
	{
		Wld_InsertNpc 	(VLK_439_Vatras_DI, 	"SHIP_DECK_01");
	};	
	
	if ( Bennet_IsOnBoard == LOG_SUCCESS)	//Bennet
	{
		Wld_InsertNpc 	(SLD_809_Bennet_DI, 	"SHIP_DECK_01");
	};	

	if ( Diego_IsOnBoard == LOG_SUCCESS)	//Diego 
	{
		Wld_InsertNpc 	(PC_Thief_DI, 			"SHIP_DECK_01");
	
		if ( Lares_IsOnBoard != LOG_SUCCESS) 
			{
				B_StartOtherRoutine	(PC_Thief_DI, "SittingShipDI");
			};
	};

	if ( Gorn_IsOnBoard == LOG_SUCCESS)	//Gorn
	{
		Wld_InsertNpc 	(PC_Fighter_DI, 		"SHIP_DECK_01");
	};	

	if ( Lares_IsOnBoard == LOG_SUCCESS)	//Lares
	{
		Wld_InsertNpc 	(VLK_449_Lares_DI, 		"SHIP_DECK_01");

		if ( Diego_IsOnBoard != LOG_SUCCESS) 
			{
				B_StartOtherRoutine	(VLK_449_Lares_DI, "SittingShipDI");
			};
	};	

	if ( Biff_IsOnBoard == LOG_SUCCESS)	//Biff
	{
		Wld_InsertNpc 	(DJG_713_Biff_DI, 		"SHIP_DECK_01");
	};	

	if ( Angar_IsOnBoard == LOG_SUCCESS)	//Angar
	{
		Wld_InsertNpc 	(DJG_705_Angar_DI, 		"SHIP_DECK_01");
	};	

	if ( Girion_IsOnBoard == LOG_SUCCESS)	//Girion
	{
		Wld_InsertNpc 	(Pal_207_Girion_DI, 		"SHIP_DECK_01");
	};	

	Wld_InsertNpc 	(NOV_600_Pedro_DI, 		"SHIP_DECK_01");
	 
	Wld_InsertItem	(ItMi_Flask	, 	"FP_ITEM_SHIP_03"); 
	Wld_InsertItem	(ItMi_Flask,	"FP_ITEM_SHIP_07");

	// ------ StartUps der Unter-Parts ------ 
	STARTUP_NEWWORLD_PART_DRAGON_ISLAND_01();
	STARTUP_NEWWORLD_PART_DRAGON_UNDEAD_01();
	STARTUP_NEWWORLD_PART_DRAGON_FINAL_01();

	PlayVideo ("SHIP.BIK");	 
	
	
	
	Log_CreateTopic (TOPIC_HallenVonIrdorath, LOG_MISSION);
	Log_SetTopicStatus(TOPIC_HallenVonIrdorath, LOG_RUNNING);
	Log_AddEntry (TOPIC_HallenVonIrdorath,"Wir haben die Insel des Feindes erreicht. Innos wei�, welche Kreaturen im Innern dieses Berges auf mich warten werden."); 

	B_Kapitelwechsel (6, DRAGONISLAND_ZEN);
};


FUNC VOID INIT_DRAGONISLAND ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	CurrentLevel = DRAGONISLAND_ZEN;
	

	//----- Levelchange verbarrikadieren --------
	if (Npc_HasItems (hero,ITKE_SHIP_LEVELCHANGE_MIS))
	{
		Npc_RemoveInvItems	(hero,	ITKE_SHIP_LEVELCHANGE_MIS,1);	//Joly: denn SHIP zen wird bei DRAGONISLAND UND NEWWORLD benutzt. Beim betreten der Insel ist die T�r wieder zu!!!!
	};
	B_InitNpcGlobals (); 
};

// ***************************************************
//  			B_ENTER_SONJAWORLD
// ***************************************************

// ******************************************************************************************************************************************************************
// B_ENTER_SONJAWORLD			 (wird über INIT_SONJAWORLD)
// ******************************************************************************************************************************************************************

FUNC VOID B_ENTER_SONJAWORLD ()
{
	B_InitNpcGlobals ();

	CurrentLevel = SONJAWORLD_ZEN;
	B_InitNpcGlobals ();
};
// **************
// B_GivePlayerXP
// **************
var int SonjasRemainingXP;

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
	concatText = ConcatStrings (concatText,	" f�r Sonja");
	PrintScreen	(concatText, -1, YPOS_XPGained + 5, FONT_ScreenSmall, 2);

	//----------------------------------------------------------------------------
	if ( self.exp >= self.exp_next ) // ( XP > (500*((hero.level+2)/2)*(hero.level+1)) )
	{
		self.level = self.level+1;
		self.exp_next = self.exp_next +((hero.level+1)*500);

		self.attribute[ATR_HITPOINTS_MAX] 	= self.attribute[ATR_HITPOINTS_MAX]	+ HP_PER_LEVEL;
		self.attribute[ATR_HITPOINTS] 		= self.attribute[ATR_HITPOINTS]		+ HP_PER_LEVEL;

		self.LP = self.LP + LP_PER_LEVEL;

		concatText = PRINT_LevelUp;
		concatText = ConcatStrings (self.name, " ist eine ");
		concatText = ConcatStrings (concatText, PRINT_LevelUp);

		PrintScreen (concatText, -1, YPOS_LevelUp, FONT_Screen, 2);
		Snd_Play ("LevelUp");
	};
};

func void B_GiveSonjaRemainingXP()
{
     if (SonjasRemainingXP > 0)
    {
        B_GiveNPCXP(Sonja, SonjasRemainingXP);
        SonjasRemainingXP = 0;
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

	// Solange Sonja nicht freigekauft wurde, bekommt sie auch keine Erfahrung.
	if (SonjaFolgt)
	{
        // Sonja ist in anderen Welten nicht verfuegbar. Die Erfahrung wird solange in SonjasRemainingXP gesammelt und dann bei der n�chsten Erfahrung vergeben.
        if (Hlp_IsValidNpc(Sonja))
        {
            B_GiveSonjaRemainingXP();

            B_GiveNPCXP(Sonja, add_xp);
        }
        else
        {
            SonjasRemainingXP = add_xp;
        };
    }
    else
    {
        SonjasRemainingXP = add_xp;
    };
};








// **********************
// B_TeachAttributePoints
// ----------------------
// Kosten abh. v. Gilde
// **********************

// ----------------------------
func int B_TeachAttributePoints (var C_NPC slf, var C_NPC oth, var int attrib, var int points, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten; 
	
	kosten = (B_GetLearnCostAttribute (oth, attrib) * points);
	
	
	//EXIT IF...
	
	// ------ falscher Parameter ------
	if (attrib!=ATR_STRENGTH) && (attrib!=ATR_DEXTERITY) && (attrib!=ATR_MANA_MAX)
	{
		Print ("*** ERROR: Wrong Parameter ***");
		return FALSE;
	};
	
	// ------ Lernen NICHT �ber teacherMax ------
	var int realAttribute;
	if 		(attrib == ATR_STRENGTH)	{	realAttribute = oth.attribute[ATR_STRENGTH];	}	// Umwandeln von const-Parameter in VAR f�r folgende If-Abfrage
	else if (attrib == ATR_DEXTERITY)	{	realAttribute = oth.attribute[ATR_DEXTERITY];	}
	else if (attrib == ATR_MANA_MAX)	{	realAttribute = oth.attribute[ATR_MANA_MAX];	};
	
	if (realAttribute >= teacherMAX)				//Wenn der Spieler schon das teacherMAX erreicht oder �berschritten hat
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_Screen, 2);
		B_Say (slf, oth, "$NOLEARNYOUREBETTER");
	
		return FALSE;
	};
	
	if ((realAttribute + points) > teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_Screen, 2);
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
		
	B_RaiseAttribute (oth, attrib, points);

	if (oth == Sonja)
	{
        if (attrib == ATR_STRENGTH)
        {
            SonjaRaisedAttributes[ATR_STRENGTH] += points;
            SonjaRaisedAttributesSpentLP[ATR_STRENGTH] += kosten;
        }
        // ------ DEX steigern ------
        else if (attrib == ATR_DEXTERITY)
        {
            SonjaRaisedAttributes[ATR_DEXTERITY] += points;
            SonjaRaisedAttributesSpentLP[ATR_DEXTERITY] += kosten;
        }
        // ------ MANA_MAX steigern ------
        else if (attrib == ATR_MANA_MAX)
        {
            SonjaRaisedAttributes[ATR_MANA_MAX] += points;
            SonjaRaisedAttributesSpentLP[ATR_MANA_MAX] += kosten;
        }
        // ------ HITPOINTS_MAX steigern ------
        else if (attrib == ATR_HITPOINTS_MAX)
        {
            SonjaRaisedAttributes[ATR_HITPOINTS_MAX] += points;
            SonjaRaisedAttributesSpentLP[ATR_HITPOINTS_MAX] += kosten;
        };
	};
	
	return TRUE;
};
var int SonjaFolgt;							//= TRUE Sonja folgt.
var int SonjaGeheiratet;					//= TRUE Sonja geheiratet.
var int SonjaGefragt;						//= TRUE Sonja nach Freikaufen gefragt.
var int SonjaSummonDays;
var int SonjaSexDays;
var int SonjaProfitDays;
var int SonjaRespawnDays;
var int SonjaRespawnItemsDays;
var int SonjaCookDays;
var int 	Sonja_SkinTexture; // 137 Frau
var int 	Sonja_BodyTexture; // BodyTex_N
var string 	Sonja_HeadMesh; // Hum_Head_Babe8

// ************************************************************
// 			Change Sonja Visual
// ************************************************************

FUNC VOID	Change_Sonja_Visual()
{
	B_SetNpcVisual 		(self, FEMALE, Sonja_HeadMesh, Sonja_SkinTexture, Sonja_BodyTexture, NO_ARMOR);

	var string printText;

	PrintScreen	("SkinTexture:" 		, -1, 10, "FONT_OLD_10_WHITE.TGA", 4 );

	printText = IntToString	(Sonja_SkinTexture);
	PrintScreen	(printText		, -1, 12, "FONT_OLD_10_WHITE.TGA", 2 );


	PrintScreen	("HeadMesh:"		, -1, 20, "FONT_OLD_10_WHITE.TGA", 2 );
	PrintScreen	(Sonja_HeadMesh		, -1, 22, "FONT_OLD_10_WHITE.TGA", 2 );

	PrintScreen	("BodyTexture:" 		, -1, 30, "FONT_OLD_10_WHITE.TGA", 4 );

	printText = IntToString	(Sonja_BodyTexture);
	PrintScreen	(printText		, -1, 32, "FONT_OLD_10_WHITE.TGA", 2 );

};

///////////////////////////////////////////////////////////////////////
//	Info EXIT 
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_EXIT   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 999;
	condition   = DIA_Sonja_EXIT_Condition;
	information = DIA_Sonja_EXIT_Info;
	permanent   = TRUE;
	description = DIALOG_ENDE;
};

FUNC INT DIA_Sonja_EXIT_Condition()
{
	return TRUE;
};

FUNC VOID DIA_Sonja_EXIT_Info()
{
	AI_StopProcessInfos (self);
};
// ************************************************************
// 			  				PICK POCKET
// ************************************************************

INSTANCE DIA_Sonja_PICKPOCKET (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_PICKPOCKET_Condition;
	information	= DIA_Sonja_PICKPOCKET_Info;
	permanent	= TRUE;
	description = Pickpocket_60_Female;
};                       

FUNC INT DIA_Sonja_PICKPOCKET_Condition()
{
	C_Beklauen (58, 70);
};
 
FUNC VOID DIA_Sonja_PICKPOCKET_Info()
{	
	Info_ClearChoices	(DIA_Sonja_PICKPOCKET);
	Info_AddChoice		(DIA_Sonja_PICKPOCKET, DIALOG_BACK 		,DIA_Sonja_PICKPOCKET_BACK);
	Info_AddChoice		(DIA_Sonja_PICKPOCKET, DIALOG_PICKPOCKET	,DIA_Sonja_PICKPOCKET_DoIt);
};

func void DIA_Sonja_PICKPOCKET_DoIt()
{
	B_Beklauen ();
	Info_ClearChoices (DIA_Sonja_PICKPOCKET);
};
	
func void DIA_Sonja_PICKPOCKET_BACK()
{
	Info_ClearChoices (DIA_Sonja_PICKPOCKET);
};

///////////////////////////////////////////////////////////////////////
//	Info STANDARD
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_STANDARD		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_STANDARD_Condition;
	information	 = 	DIA_Sonja_STANDARD_Info;
	important	 = 	TRUE;
	permanent	 = 	TRUE;
};

func int DIA_Sonja_STANDARD_Condition ()
{	
	if Npc_IsInState (self, ZS_Talk)
	&& (MIS_Andre_REDLIGHT != LOG_RUNNING)
	{
		return SonjaFolgt == FALSE;
	};
};
func void DIA_Sonja_STANDARD_Info ()
{
	if (self.aivar[AIV_TalkedToPlayer] == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_00"); //Sprich mit Bromor, wenn du Spa� haben willst.
	}
	else if (other.guild == GIL_DJG)
	&& (Sonja_Says == FALSE)
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_01"); //Das Problem mit euch Typen ist, dass ihr lieber Orks abschlachtet als zu v�geln.
		Sonja_Says = TRUE;
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_STANDARD_16_02"); //Wenn du quatschen willst, such dir 'ne Frau und heirate sie.
	};

	Log_CreateTopic ("Sonja", LOG_NOTE);
};

// ************************************************************
// 			  				BEZAHLEN
// ************************************************************

INSTANCE DIA_Sonja_BEZAHLEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	condition	= DIA_Sonja_BEZAHLEN_Condition;
	information	= DIA_Sonja_BEZAHLEN_Info;
	permanent	= TRUE;
	description = "Freikaufen (1000 Gold geben)";
};

func int DIA_Sonja_BEZAHLEN_Condition ()
{
	return SonjaGefragt && SonjaFolgt == FALSE;
};

FUNC VOID DIA_Sonja_BEZAHLEN_Info()
{
	Info_ClearChoices	(DIA_Sonja_BEZAHLEN);
	Info_AddChoice		(DIA_Sonja_BEZAHLEN, DIALOG_BACK 		,DIA_Sonja_BEZAHLEN_BACK);
	Info_AddChoice		(DIA_Sonja_BEZAHLEN, "1000 Gold geben"	,DIA_Sonja_BEZAHLEN_DoIt);
};

// Komm mit.

func void SonjaComeOn()
{
    if (C_BodyStateContains (self, BS_SIT))
    {
        AI_StandUp (self);
        B_TurnToNpc (self,other);
    };
    self.aivar[AIV_PARTYMEMBER] = TRUE;

    if (CurrentLevel == OLDWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOWOLDWORLD");
    }
    else if (CurrentLevel == NEWWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOW");
    }
    else if (CurrentLevel == ADDONWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self, "FOLLOWADDONWORLD");
    }
    else if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Npc_ExchangeRoutine	(self,"FOLLOWDRAGONISLAND");
    };

    self.aivar[AIV_PARTYMEMBER] = TRUE;
    self.flags = 0; // NPC_FLAG_IMMORTAL
};

func void DIA_Sonja_BEZAHLEN_DoIt()
{
	if (Npc_HasItems (other, ItMi_Gold) < 1000)
	{
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_00"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
	}
	else
	{
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_01"); //1000 Goldst�cke! Wahnsinn! Endlich mal ein reicher Mann im Hafen, der wei� wie man eine Dame behandelt.
        AI_Output (self, other, "DIA_Sonja_BEZAHLEN_16_02"); //Lass uns abhauen!
        B_LogEntry ("Sonja", "Sonja folgt mir nun und arbeitet f�r mich.");
        SonjaFolgt = TRUE;
        SonjaSummonDays = 0;
        SonjaRespawnItemsDays = 0;
        SonjaSexDays = 0;
        SonjaProfitDays = 0;
        SonjaRespawnDays = 0;
        SonjaCookDays = 0;
        Sonja_SkinTexture = FaceBabe_L_Charlotte2;
        Sonja_BodyTexture = BodyTexBabe_L;
        Sonja_HeadMesh = "Hum_Head_Babe6";
        SonjaComeOn();
	};

	Info_ClearChoices (DIA_Sonja_BEZAHLEN);
};

func void DIA_Sonja_BEZAHLEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_BEZAHLEN);
};

///////////////////////////////////////////////////////////////////////
//	Info FREIKAUFEN
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FREIKAUFEN		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_FREIKAUFEN_Condition;
	information	 = 	DIA_Sonja_FREIKAUFEN_Info;
	permanent	 = 	FALSE;
	description  =  "Ich m�chte dich freikaufen!";
};

func int DIA_Sonja_FREIKAUFEN_Condition ()
{
	return SonjaFolgt == FALSE;
};

func void DIA_Sonja_FREIKAUFEN_Info ()
{
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_00"); //Ich m�chte dich freikaufen!
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_00"); //Oh Romeo, willst du das wirklich tun? Hast du denn �berhaupt genug Gold, um eine Frau wie mich zu versorgen?
    AI_Output (other, self, "DIA_Sonja_FREIKAUFEN_15_01"); //Du k�nntest weiterhin f�r mich arbeiten.
    AI_Output (self, other, "DIA_Sonja_FREIKAUFEN_16_02"); //Sagen wir so: Wenn du mir eine Menge Gold gibst und mehr �brig l�sst als Bromor, dann verlasse ich gerne die Rote Laterne.
    B_LogEntry ("Sonja", "Sonja, die Freudendame in der Roten Laterne, schlie�t sich mir an und arbeitet f�r mich, wenn ich ihr 1000 Goldst�cke gebe.");
    SonjaGefragt = TRUE;
};


///////////////////////////////////////////////////////////////////////
//	Info PEOPLE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_PEOPLE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_PEOPLE_Condition;
	information	 = 	DIA_Sonja_PEOPLE_Info;
	permanent	 = 	TRUE;
	description  =  "Was h�ltst du von ...";
	nr		 	= 99;
};

func int DIA_Sonja_PEOPLE_Condition ()
{
	return SonjaFolgt;
};

func void DIA_Sonja_PEOPLE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du vom Richter?"	,     DIA_Sonja_PEOPLE_Richter);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Lord Hagen?"	,     DIA_Sonja_PEOPLE_Hagen);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Vatras?"	,     DIA_Sonja_PEOPLE_Vatras);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Vanja?"	,     DIA_Sonja_PEOPLE_Vanja);
	Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Nadja?"	,     DIA_Sonja_PEOPLE_Nadja);
    Info_AddChoice		(DIA_Sonja_PEOPLE, "Was h�ltst du von Bromor?"	,     DIA_Sonja_PEOPLE_Bromor);
    Info_AddChoice		(DIA_Sonja_PEOPLE, DIALOG_BACK 		,                 DIA_Sonja_PEOPLE_BACK);
};

func void DIA_Sonja_PEOPLE_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_PEOPLE);
};


func void DIA_Sonja_PEOPLE_Bromor ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Bromor_15_00"); //Was h�ltst du von Bromor?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_00"); //Bromor ist ein mieser Halsabschneider. Er nimmt den meisten Ertrag der Frauen f�r sich.

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Bromor_16_01"); //Aber was soll's? Meinen Prinzen habe ich ja jetzt gefunden!
    };

    B_LogEntry ("Sonja", "Sonja h�lt Bromor f�r einen miesen Halsabschneider.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Nadja ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Nadja_15_00"); //Was h�ltst du von Nadja?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_00"); //Nadja? Ach so eine graue Maus. Die kann doch gar nichts! H�bsch ist sie, zugegeben, aber Erfahrung hat sei kaum und Sch�nheit vergeht.
    B_LogEntry ("Sonja", "Sonja h�lt Nadja f�r eine graue Maus.");

    if (SonjaFolgt == TRUE)
    {
        AI_Output (self, other, "DIA_Sonja_PEOPLE_Nadja_16_01"); //Du findest sie doch nicht etwa h�bscher als mich? Ich warne dich, schau sie blo� nicht an!
        B_LogEntry ("Sonja", "Sonja ist eifers�chtig auf Nadja.");
    };

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Vanja ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Vanja_15_00"); //Was h�ltst du von Vanja?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Vanja_16_00"); //Vanja? Die treibt es ganz sch�n wild mit diesem Peck. Der kriegt aber auch nicht genug von ihr. Eigentlich ist sie ganz nett.
    B_LogEntry ("Sonja", "Sonja h�lt Vanja f�r eine Nette, die es mit Peck ganz sch�n wild treibt.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Vatras ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Vatras_15_00"); //Was h�ltst du von Vatras?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Vatras_16_00"); //Vatras predigt jetzt viel ruhiger, seitdem er mir seine Wasserzauber gezeigt hat.

    B_LogEntry ("Sonja", "Sonja hat Vatras ruhiger gestimmt.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Hagen ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Hagen_15_00"); //Was h�ltst du von Lord Hagen?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Hagen_16_00"); //Im Bett durfte ich ihn nur mit Eure Lordschaft ansprechen.

    B_LogEntry ("Sonja", "Lord Hagen wurde nur als Eure Lordschaft von Sonja angesprochen.");

    DIA_Sonja_PEOPLE_Info();
};

func void DIA_Sonja_PEOPLE_Richter ()
{
    AI_Output (other, self, "DIA_Sonja_PEOPLE_Richter_15_00"); //Was h�ltst du vom Richter?
    AI_Output (self, other, "DIA_Sonja_PEOPLE_Richter_16_00"); //�ber mich hat er jede Nacht gerichtet. Sein Urteil viel zu meinen Gunsten aus.

    B_LogEntry ("Sonja", "Der Richter urteilte zu Sonjas gunsten.");

    DIA_Sonja_PEOPLE_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info NOT YET
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_NOT_YET		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_NOT_YET_Condition;
	information	 = 	DIA_Sonja_NOT_YET_Info;
	permanent	 = 	FALSE;
	description  =  "Gibt es �berhaupt jemanden, der noch nicht Kunde bei dir war?";
	nr		 	= 99;
};

func int DIA_Sonja_NOT_YET_Condition ()
{
	return SonjaFolgt;
};

func void DIA_Sonja_NOT_YET_Info ()
{
    AI_Output (other, self, "DIA_Sonja_NOT_YET_15_00"); //Gibt es �berhaupt jemanden, der noch nicht Kunde bei dir war?
    AI_Output (self, other, "DIA_Sonja_NOT_YET_16_00"); //Hmm, nicht sehr viele Leute, aber ja. Ich kann dir eine Liste geben.
    B_LogEntry ("Sonja", "Sonja hat mir eine Liste von Leuten gegeben, die noch nicht Kunden bei ihr waren.");
    CreateInvItems (self, ItWr_SonjasListMissing, 1);
    B_GiveInvItems (self, other, ItWr_SonjasListMissing, 1);
};

///////////////////////////////////////////////////////////////////////
//	Info SKILL
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_SKILL		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	condition	 = 	DIA_Sonja_SKILL_Condition;
	information	 = 	DIA_Sonja_SKILL_Info;
	permanent	 = 	TRUE;
	description  =  "Wie erfahren bist du?";
	nr		 	= 3;
};

func int DIA_Sonja_SKILL_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_SKILL_Info ()
{
    Info_ClearChoices	(DIA_Sonja_SKILL);
    Info_AddChoice		(DIA_Sonja_SKILL, "Schutz"	,     DIA_Sonja_PROTECTION_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "Talente"	,     DIA_Sonja_SKILL_Exact_Info);
	Info_AddChoice		(DIA_Sonja_SKILL, "Attribute"	,     DIA_Sonja_STATS_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "Erfahrung"	,     DIA_Sonja_XP_Info);
    Info_AddChoice		(DIA_Sonja_SKILL, "(Verbleibende Erfahrung geben)"	,     DIA_Sonja_XP_Add_Remaining);
    Info_AddChoice		(DIA_Sonja_SKILL, DIALOG_BACK 		,                 DIA_Sonja_SKILL_BACK);
};

func void DIA_Sonja_SKILL_BACK ()
{
    Info_ClearChoices	(DIA_Sonja_SKILL);
};

func void DIA_Sonja_XP_Add_Remaining ()
{
    if (SonjasRemainingXP > 0)
    {
        B_GiveSonjaRemainingXP();
    }
    else
    {
        AI_Output (self, other, "DIA_Sonja_XP_16_00"); //Das wei� ich alles schon.
    };

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_XP_Info ()
{
    AI_Output (other, self, "DIA_Sonja_XP_15_00"); //Wie erfahren bist du?
    AI_Output (self, other, "DIA_Sonja_XP_16_01"); //Finde es heraus!

    var String levelText;
    var String lpText;
    var String xpText;
    var String xpNextText;
    var String msg;

    levelText = ConcatStrings("Stufe: ", IntToString(self.level));
    lpText = ConcatStrings(" Lernpunkte: ", IntToString(self.lp));
    xpText = ConcatStrings(" XP: ", IntToString(self.exp));
    xpNextText = ConcatStrings(" XP n�chste Stufe: ", IntToString(self.exp_next));
    msg = "";
    msg = ConcatStrings(msg, levelText);
    msg = ConcatStrings(msg, lpText);
    msg = ConcatStrings(msg, xpText);
    msg = ConcatStrings(msg, xpNextText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_STATS_Info ()
{
    AI_Output (other, self, "DIA_Sonja_STATS_15_00"); //Wie stark bist du?
    AI_Output (self, other, "DIA_Sonja_STATS_16_01"); //Finde es heraus!

    var String hpText;
    var String manaText;
    var String strText;
    var String dexText;
    var String msg;

    hpText = ConcatStrings("Leben: ", IntToString(self.attribute[ATR_HITPOINTS_MAX]));
    manaText = ConcatStrings(" Mana: ", IntToString(self.attribute[ATR_MANA_MAX]));
    strText = ConcatStrings(" St�rke: ", IntToString(self.attribute[ATR_STRENGTH]));
    dexText = ConcatStrings(" Geschick: ", IntToString(self.attribute[ATR_DEXTERITY]));
    msg = "";
    msg = ConcatStrings(msg, hpText);
    msg = ConcatStrings(msg, manaText);
    msg = ConcatStrings(msg, strText);
    msg = ConcatStrings(msg, dexText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_SKILL_Exact_Info ()
{
    AI_Output (other, self, "DIA_Sonja_SKILL_15_00"); //Wie gut bist du ausgebildet?
    AI_Output (self, other, "DIA_Sonja_STATS_16_01"); //Finde es heraus!

    var String text1H;
    var String text2H;
    var String textBow;
    var String textCrossbow;
    var String textMage;
    var String textSneak;
    var String msg;

    text1H = ConcatStrings("1H : ", IntToString(self.HitChance[NPC_TALENT_1H]));
    text1H = ConcatStrings(text1H, "% ");
    text2H = ConcatStrings("2H : ", IntToString(self.HitChance[NPC_TALENT_2H]));
    text2H = ConcatStrings(text2H, "% ");
    textBow = ConcatStrings("Bogen: ", IntToString(self.HitChance[NPC_TALENT_BOW]));
    textBow = ConcatStrings(textBow, "% ");
    textCrossbow = ConcatStrings("Armbrust: ", IntToString(self.HitChance[NPC_TALENT_CROSSBOW]));
    textCrossbow = ConcatStrings(textCrossbow, "% ");
    textMage = ConcatStrings("Magiekreis: ", IntToString(Npc_GetTalentSkill (self, NPC_TALENT_MAGE)));
    textMage = ConcatStrings(textMage, " ");
    textSneak = ConcatStrings("Schleichen: ", IntToString(Npc_GetTalentSkill (self, NPC_TALENT_SNEAK)));

    msg = "";
    msg = ConcatStrings(msg, text1H);
    msg = ConcatStrings(msg, text2H);
    msg = ConcatStrings(msg, textBow);
    msg = ConcatStrings(msg, textCrossbow);
    msg = ConcatStrings(msg, textMage);
    msg = ConcatStrings(msg, textSneak);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};

func void DIA_Sonja_PROTECTION_Info ()
{
    AI_Output (other, self, "DIA_Sonja_PROTECTION_15_00"); //Wie gut bist du gesch�tzt?
    AI_Output (self, other, "DIA_Sonja_STATS_16_00"); //Finde es heraus!

    //CONST INT PROT_BARRIER									= DAM_INDEX_BARRIER		;
//CONST INT PROT_BLUNT									= DAM_INDEX_BLUNT		;
//CONST INT PROT_EDGE										= DAM_INDEX_EDGE		;
//CONST INT PROT_FIRE										= DAM_INDEX_FIRE		;
//CONST INT PROT_FLY										= DAM_INDEX_FLY			;
//CONST INT PROT_MAGIC									= DAM_INDEX_MAGIC		;
//CONST INT PROT_POINT									= DAM_INDEX_POINT		;
//CONST INT PROT_FALL										= DAM_INDEX_FALL		;

    var String barrierText;
    var String bluntText;
    var String edgeText;
    var String fireText;
    var String flyText;
    var String magicText;
    var String pointText;
    var String fallText;
    var String msg;

    barrierText = ConcatStrings("Barrier: ", IntToString(self.protection[PROT_BARRIER]));
    bluntText = ConcatStrings(" Blunt: ", IntToString(self.attribute[PROT_BLUNT]));
    edgeText = ConcatStrings(" Edge: ", IntToString(self.attribute[PROT_EDGE]));
    fireText = ConcatStrings(" Feuer: ", IntToString(self.attribute[PROT_FIRE]));
    flyText = ConcatStrings(" Flug: ", IntToString(self.attribute[PROT_FLY]));
    magicText = ConcatStrings(" Magie: ", IntToString(self.attribute[PROT_MAGIC]));
    pointText = ConcatStrings(" Punkt: ", IntToString(self.attribute[PROT_POINT]));
    fallText = ConcatStrings(" Fall: ", IntToString(self.attribute[PROT_FALL]));
    msg = "";
    msg = ConcatStrings(msg, barrierText);
    msg = ConcatStrings(msg, bluntText);
    msg = ConcatStrings(msg, edgeText);
    msg = ConcatStrings(msg, fireText);
    msg = ConcatStrings(msg, flyText);
    msg = ConcatStrings(msg, magicText);
    msg = ConcatStrings(msg, pointText);
    msg = ConcatStrings(msg, fallText);

    PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    //PrintScreen (ConcatStrings("Maximales Mana ", IntToString(self.attribute[ATR_MANA_MAX])), - 1, - 1, FONT_Screen, 2);
    //PrintScreen (ConcatStrings("Maximale Lebenspunkte ", IntToString(self.attribute[ATR_HITPOINTS_MAX])), - 1, - 1, FONT_Screen, 2);

    DIA_Sonja_SKILL_Info();
};


// ------------------------------------------------------------
// 						Komm (wieder) mit!
// ------------------------------------------------------------
instance DIA_Sonja_ComeOn(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr		 	= 1;
	condition	= DIA_Sonja_ComeOn_Condition;
	information	= DIA_Sonja_ComeOn_Info;
	permanent	= TRUE;
	description	= "Komm mit.";
};
func int DIA_Sonja_ComeOn_Condition ()
{
	if (self.aivar[AIV_PARTYMEMBER] == FALSE && SonjaFolgt == TRUE)
	{
		return TRUE;
	};
};
func void DIA_Sonja_ComeOn_Info ()
{
	AI_Output (other, self, "DIA_Addon_Skip_ComeOn_15_00"); //Komm mit.
    AI_Output (self ,other, "DIA_Sonja_COMEON_16_00"); //Ich folge dir mein Prinz!
    AI_StopProcessInfos (self);

    SonjaComeOn();
};

// ************************************************************
// 			  			Warte hier
// ************************************************************
INSTANCE DIA_Sonja_WarteHier (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 1;
	condition	= DIA_Sonja_WarteHier_Condition;
	information	= DIA_Sonja_WarteHier_Info;
	permanent	= TRUE;
	description = "Warte hier!";
};
FUNC INT DIA_Sonja_WarteHier_Condition()
{
	return self.aivar[AIV_PARTYMEMBER] == TRUE;
};
FUNC VOID DIA_Sonja_WarteHier_Info()
{
	AI_Output (other, self,"DIA_Liesel_WarteHier_15_00");	//Warte hier!
	AI_Output (self ,other, "DIA_Sonja_WARTEHIER_16_00"); //Wie du meinst, mein S��er!

	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;
	Npc_ExchangeRoutine	(self,"WAIT");

	AI_StopProcessInfos	(self);
};

// ------------------------------------------------------------
// 							Go Home!
// ------------------------------------------------------------
INSTANCE DIA_Sonja_GoHome(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr		 	= 2;
	condition	= DIA_Sonja_GoHome_Condition;
	information	= DIA_Sonja_GoHome_Info;
	permanent	= TRUE;
	description = "Ich brauch dich nicht mehr.";
};
FUNC INT DIA_Sonja_GoHome_Condition()
{
	return self.aivar[AIV_PARTYMEMBER];
};

FUNC VOID DIA_Sonja_GoHome_Info()
{
	AI_Output (other, self, "DIA_Addon_Skip_GoHome_15_00"); //Ich brauch dich nicht mehr.
	AI_Output (self, other, "DIA_Sonja_GoHome_16_00"); // Arschloch!

	self.aivar[AIV_PARTYMEMBER] = FALSE;
    self.flags = NPC_FLAG_IMMORTAL;

    if (CurrentLevel == OLDWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTOLDWORLD");
    }
    else if (CurrentLevel == NEWWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"START");
    }
    else if (CurrentLevel == ADDONWORLD_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTADDONWORLD");
    }
    else if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Npc_ExchangeRoutine	(self,"STARTDRAGONISLAND");
    };
};

///////////////////////////////////////////////////////////////////////
//	Info Heilung
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HEILUNG		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	3;
	condition	 = 	DIA_Sonja_HEILUNG_Condition;
	information	 = 	DIA_Sonja_HEILUNG_Info;
	permanent	 = 	TRUE;

	description	 = 	"Brauchst du Heilung?";
};

func int DIA_Sonja_HEILUNG_Condition ()
{
    return self.aivar[AIV_PARTYMEMBER];
};

func void DIA_Sonja_HEILUNG_Info ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_15_00"); //Brauchst du Heilung?

    AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_00"); //Klar. Schaden kann's nicht.

    Info_ClearChoices	(DIA_Sonja_HEILUNG);
    Info_AddChoice	(DIA_Sonja_HEILUNG, "(den kleinsten Heiltrank.)", DIA_Sonja_HEILUNG_heiltrankLow );
    Info_AddChoice	(DIA_Sonja_HEILUNG, "(den besten Heiltrank.)", DIA_Sonja_HEILUNG_heiltrank );
    Info_AddChoice	(DIA_Sonja_HEILUNG, "Ich werde dir sp�ter etwas geben.", DIA_Sonja_HEILUNG_spaeter );

};

func void DIA_Sonja_HEILUNG_heiltrank ()
{
	if (B_GiveInvItems (other, self, ItPo_Health_03,1))
	{
	B_UseItem (self, ItPo_Health_03);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_02,1))
	{
	B_UseItem (self, ItPo_Health_02);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_01,1))
	{
	B_UseItem (self, ItPo_Health_01);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_01"); //Ich sch�tze, ich muss warten, bis du einen �brig hast.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_heiltrankLow ()
{
	if (B_GiveInvItems (other, self, ItPo_Health_01,1))
	{
        B_UseItem (self, ItPo_Health_01);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_02,1))
	{
        B_UseItem (self, ItPo_Health_02);
	}
	else if (B_GiveInvItems (other, self, ItPo_Health_03,1))
	{
        B_UseItem (self, ItPo_Health_03);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_HEILUNG_16_02"); //Im Moment hast du leider keinen. Ich komm sp�ter noch mal darauf zur�ck.
	};

	AI_StopProcessInfos (self);
};

func void DIA_Sonja_HEILUNG_spaeter ()
{
	AI_Output			(other, self, "DIA_Biff_HEILUNG_spaeter_15_00"); //Ich werde dir sp�ter etwas geben.
	AI_Output			(self ,other, "DIA_Sonja_HEILUNG_16_03"); //Vergiss es aber nicht.

	Info_ClearChoices	(DIA_Sonja_HEILUNG);
};

///////////////////////////////////////////////////////////////////////
//	Info HEAL
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_DI_HEAL		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	5;
	condition	 = 	DIA_Sonja_DI_HEAL_Condition;
	information	 = 	DIA_Sonja_DI_HEAL_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Wurst warm machen)";
};

func int DIA_Sonja_DI_HEAL_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_DI_HEAL_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HEAL_15_00"); //Lass es uns tun!

    if (Wld_GetDay() - SonjaSexDays >= 3)
	{
        if (hero.attribute [ATR_HITPOINTS] < hero.attribute[ATR_HITPOINTS_MAX] || hero.attribute [ATR_MANA] < hero.attribute[ATR_MANA_MAX])
        {
            AI_Output			(self, other, "DIA_Sonja_HEAL_16_00"); //Endlich erobert mein Prinz sein Schloss zur�ck!
            PlayVideo ("LOVESCENE.BIK");
            hero.attribute [ATR_HITPOINTS] = hero.attribute[ATR_HITPOINTS_MAX];
            hero.attribute [ATR_MANA] = hero.attribute[ATR_MANA_MAX];
            PrintScreen (PRINT_FullyHealed, - 1, - 1, FONT_Screen, 2);
            B_LogEntry ("Sonja", "Sonja hat gewisse Talente, die mich heilen und mein Mana regenerieren.");
        }
        else
        {
            AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migr�ne.
            B_LogEntry ("Sonja", "Sonja hat komischerweise �fter mal Migr�ne, wenn ich meine Wurst warm machen will.");
        };
        SonjaSexDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(self, other,  "DIA_Sonja_HEAL_16_01"); //Ich habe Migr�ne.
        B_LogEntry ("Sonja", "Sonja hat komischerweise �fter mal Migr�ne, wenn ich meine Wurst warm machen will.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(3 + SonjaSexDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    };
};

///////////////////////////////////////////////////////////////////////
//	Info FEELINGS
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FEELINGS		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_FEELINGS_Condition;
	information	 = 	DIA_Sonja_FEELINGS_Info;
	permanent	 = 	TRUE;
	description	 = 	"Wie f�hlst du dich?";
};

func int DIA_Sonja_FEELINGS_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_FEELINGS_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_FEELINGS_15_00"); //Wie f�hlst du dich?

    if (Wld_IsRaining())
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_00"); //Ach, das Wetter ist beschissen!
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_FEELINGS_16_01"); //Das Wetter ist heute sch�n!
    };
};

///////////////////////////////////////////////////////////////////////
//	Info VIDEOS
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_VIDEOS		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	99;
	condition	 = 	DIA_Sonja_VIDEOS_Condition;
	information	 = 	DIA_Sonja_VIDEOS_Info;
	permanent	 = 	TRUE;

	description	 = 	"Zeige mir ...";
};

func int DIA_Sonja_VIDEOS_Condition ()
{
    return SonjaFolgt;
};

func void DIA_Sonja_VIDEOS_Info ()
{
    Info_ClearChoices	(DIA_Sonja_VIDEOS);

    if (UndeadDragonIsDead)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Tod des Untoten Drachen.", DIA_Sonja_VIDEOS_UndeadDragonDeath );
    };

    if (Kapitel >= 6)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... die Abfahrt nach Irdorath.", DIA_Sonja_VIDEOS_Ship );
    };

    if (RavenIsDead)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... Raven's Tod.", DIA_Sonja_VIDEOS_RavenDeath );
    };

    if (B_RAVENSESCAPEINTOTEMPELAVI_OneTime)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... Raven's Flucht in den Tempel.", DIA_Sonja_VIDEOS_RavenEscape );
    };

    if (Npc_KnowsInfo (other, DIA_Addon_Saturas_Hallo))
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... das magische Erz im Minental.", DIA_Sonja_VIDEOS_OreHeap );
    };

    if (ENTER_OLDWORLD_FIRSTTIME_TRIGGER_ONETIME)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Drachenangriff im Minental.", DIA_Sonja_VIDEOS_DragonAttack );
    };

    if (MIS_OCGateOpen)
    {
        Info_AddChoice	(DIA_Sonja_VIDEOS, "... den Orkangriff im Minental.", DIA_Sonja_VIDEOS_OrcAttack );
    };

    Info_AddChoice	(DIA_Sonja_VIDEOS, "... die Vorgeschichte der Insel.", DIA_Sonja_VIDEOS_Intro_Beliar );
    Info_AddChoice	(DIA_Sonja_VIDEOS, "... meine Vorgeschichte.", DIA_Sonja_VIDEOS_Intro );
    Info_AddChoice	(DIA_Sonja_VIDEOS, DIALOG_BACK, DIA_Sonja_VIDEOS_Back );
};

func void DIA_Sonja_VIDEOS_Back()
{
    Info_ClearChoices	(DIA_Sonja_VIDEOS);
};

func void DIA_Sonja_VIDEOS_Intro ()
{
	PlayVideo ("INTRO.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_Intro_Beliar ()
{
	PlayVideo ("Addon_Title.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_DragonAttack ()
{
    PlayVideo ( "DRAGONATTACK.BIK");

	DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_OrcAttack() {
    PlayVideo ( "ORCATTACK.BIK");

	DIA_Sonja_VIDEOS_Info();

};

func void DIA_Sonja_VIDEOS_OreHeap ()
{
    PlayVideo ("oreheap.bik");

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_RavenEscape ()
{
    PlayVideoEx	("PORTAL_RAVEN.BIK", TRUE,FALSE);

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_Ship()
{
    PlayVideo ("SHIP.BIK");

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_RavenDeath ()
{
    PlayVideoEx	("EXTRO_RAVEN.BIK", TRUE,FALSE);

    DIA_Sonja_VIDEOS_Info();
};

func void DIA_Sonja_VIDEOS_UndeadDragonDeath()
{
    if ((hero.guild == GIL_MIL) || (hero.guild == GIL_PAL))
    {
        PlayVideoEx	("EXTRO_PAL.BIK", TRUE,FALSE);
    }
    else if ((hero.guild == GIL_SLD) || (hero.guild == GIL_DJG))
    {
        PlayVideoEx	("EXTRO_DJG.BIK", TRUE,FALSE);
    }
    else
    {
        PlayVideoEx	("EXTRO_KDF.BIK", TRUE,FALSE);
    };

    DIA_Sonja_VIDEOS_Info();
};


///////////////////////////////////////////////////////////////////////
//	Info ESCAPE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_ESCAPE		(C_INFO)
{
	npc		 = 	VLK_436_Sonja;
	nr		 = 	99;
	condition	 = 	DIA_Sonja_ESCAPE_Condition;
	information	 = 	DIA_Sonja_ESCAPE_Info;
	permanent	 = 	TRUE;

	description	 = 	"Lass uns abhauen ...";
};

func int DIA_Sonja_ESCAPE_Condition ()
{
    return SonjaFolgt;
};

func void DIA_Sonja_ESCAPE_Info ()
{
    Info_ClearChoices	(DIA_Sonja_ESCAPE);

    if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        Info_AddChoice	(DIA_Sonja_ESCAPE, "Zur�ck nach Khorinis ...", DIA_Sonja_ESCAPE_Khorinis);
    }
    else if (CurrentLevel == NEWWORLD_ZEN && Kapitel >= 6)
    {
        Info_AddChoice	(DIA_Sonja_ESCAPE, "Zur�ck nach Irdorath ...", DIA_Sonja_ESCAPE_Irdorath);
    };

    Info_AddChoice	(DIA_Sonja_ESCAPE, DIALOG_BACK, DIA_Sonja_ESCAPE_Back );
};

func void DIA_Sonja_ESCAPE_Back()
{
    Info_ClearChoices	(DIA_Sonja_ESCAPE);
};

func void DIA_Sonja_ESCAPE_Irdorath()
{

    DIA_Sonja_ESCAPE_Info();
};

func void DIA_Sonja_ESCAPE_Khorinis ()
{
    DIA_Sonja_ESCAPE_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info WAREZ
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_WAREZ		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	0;
	condition	 = 	DIA_Sonja_WAREZ_Condition;
	information	 = 	DIA_Sonja_WAREZ_Info;
	permanent	 = 	TRUE;
	trade		 = 	TRUE;
	description	 = 	"Zeig mir deine Ware";
};

func int DIA_Sonja_WAREZ_Condition ()
{
	return SonjaFolgt;
};

var int SonjaSummonHint;
var int SonjaTeleportHint;
var int SonjaArrowHint;

func void DIA_Sonja_WAREZ_Info ()
{
    if (Npc_HasItems (self, ItRu_SummonSonja) <= 0)
    {
        CreateInvItems (self, ItRu_SummonSonja, 1);

        if (SonjaSummonHint == FALSE)
        {
            B_LogEntry ("Sonja", "Bei Sonja gibt es eine Rune, um sie jederzeit herbeizurufen.");
            SonjaSummonHint = TRUE;
        };
    };

    if (Kapitel >= 3)
    {
        if (Npc_HasItems (self, ItRu_TeleportSonja) <= 0)
        {
            CreateInvItems (self, ItRu_TeleportSonja, 1);
        };

        if (Npc_HasItems (self, ItRu_TeleportRoteLaterne) <= 0)
        {
            CreateInvItems (self, ItRu_TeleportRoteLaterne, 1);
        };

        if (SonjaTeleportHint == FALSE)
        {
            B_LogEntry ("Sonja", "Bei Sonja gibt es n�tzliche Teleportrunen.");
            SonjaTeleportHint = TRUE;
        };
    };

    // Immer neuen Rohstahl
    if (Npc_HasItems (self, ItMiSwordraw) <= 0)
    {
        CreateInvItems (self, ItMiSwordraw, 5);
    };

    // Immer Pfeile und Bolzen auch f�r sich selbst.
    if (Npc_HasItems (self, ItRw_Arrow) <= 0)
    {
        CreateInvItems (self, ItRw_Arrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja f�llt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Bolt) <= 0)
    {
        CreateInvItems (self, ItRw_Bolt, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja f�llt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_MagicArrow) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_MagicArrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja f�llt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_FireArrow) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_FireArrow, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja f�llt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    if (Npc_HasItems (self, ItRw_Addon_MagicBolt) <= 0)
    {
        CreateInvItems (self, ItRw_Addon_MagicBolt, 100);

        if (SonjaArrowHint == FALSE)
        {
            B_LogEntry ("Sonja", "Sonja f�llt ihre Pfeile und Bolzen auf, wenn ich mit ihr mir ihre Ware ansehe.");
            SonjaArrowHint = TRUE;
        };
    };

    // Wir platzieren es hier, um die Datei B_GiveTradeInv.d nicht zu veraendern.
	if (self.aivar[AIV_ChapterInv] <= Kapitel)
	{
        B_ClearJunkTradeInv (self);
        B_GiveTradeInv_Sonja		(self);

        self.aivar[AIV_ChapterInv] = (Kapitel +1);
    };

	B_GiveTradeInv (self);
	AI_Output			(other, self, "DIA_Isgaroth_Trade_15_00"); //Zeig mir deine Ware.
};

///////////////////////////////////////////////////////////////////////
//	Info HEIRATEN
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HEIRATEN		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HEIRATEN_Condition;
	information	 = 	DIA_Sonja_HEIRATEN_Info;
	permanent	 = 	FALSE;
	description	 = 	"M�chtest du meine Frau werden?";
};

func int DIA_Sonja_HEIRATEN_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HEIRATEN_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_00"); //M�chtest du meine Frau werden?
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_00"); //Hmmm, hast du mir denn wirklich genug zu bieten? Wie sieht es mit Schmuck aus? Was ist mit sch�ner Kleidung? Die kostet Geld. Wo sollen wir wohnen, mein Prinz?
	AI_Output			(other, self, "DIA_Sonja_HEIRATEN_15_01"); //Ich sorge f�r alles.
	AI_Output			(self, other, "DIA_Sonja_HEIRATEN_16_01"); //Ich glaube an dich. Gib mir noch einmal 1000 Goldst�cke und etwas Schmuck und wir k�nnen heiraten.

	B_LogEntry ("Sonja", "Sonja wird meine Frau wenn ich ihr 1000 Goldst�cke, einen goldenen Ring und eine Schatulle gebe.");
};

///////////////////////////////////////////////////////////////////////
//	Info HOCHZEIT
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HOCHZEIT		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HOCHZEIT_Condition;
	information	 = 	DIA_Sonja_HOCHZEIT_Info;
	permanent	 = 	TRUE;
	description	 = 	"Werde meine Frau!";
};

func int DIA_Sonja_HOCHZEIT_Condition ()
{
	return Npc_KnowsInfo(other, DIA_Sonja_HEIRATEN) && !SonjaGeheiratet;
};

func void DIA_Sonja_HOCHZEIT_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_HOCHZEIT_15_00"); //M�chtest du meine Frau werden?

    if (Npc_HasItems (other, ItMi_Gold) < 1000)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_00"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
    }
    else if (Npc_HasItems(other, ItMi_GoldRing) <= 0)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_01"); //Willst du mich verarschen? Du hast keinen goldenen Ring dabei!
    }
    else if ( Npc_HasItems(other, ItMi_GoldChest) <= 0)
    {
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_02"); //Willst du mich verarschen? Du hast keine Schatulle dabei!
    }
	else
	{
        AI_Output (self, other, "DIA_Sonja_HOCHZEIT_16_03"); //Oh, mein Prinz, ich gebe dir das Ja-Wort. Wir sind nun Frau und Mann. Schnell gib, mir die Waren, damit ich sie f�r uns aufbewaren kann.
        B_GiveInvItems (other, self, ItMi_Gold, 1000);
        B_GiveInvItems (other, self, ItMi_GoldRing, 1);
        B_GiveInvItems (other, self, ItMi_GoldChest, 1);
        B_LogEntry ("Sonja", "Sonja und ich haben geheiratet. Wir sind nun Mann und Frau. Wenn mein alter Freund Xardas das nur w�sste!");
        SonjaGeheiratet = TRUE;
	};
};

///////////////////////////////////////////////////////////////////////
//	Info LIEBE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_LIEBE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_LIEBE_Condition;
	information	 = 	DIA_Sonja_LIEBE_Info;
	permanent	 = 	FALSE;
	description	 = 	"(Liebeserkl�rung)";
};

func int DIA_Sonja_LIEBE_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_LIEBE_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_LIEBE_15_00"); //Oh du holde Maid, welch wunderbares Antlitz! Wie das Feuer der Drachen gl�nzt es und M�nner erblinden vor seiner Sch�nheit! Nur das Auge Innos kann ihm stand halten.

	AI_Output			(self, other, "DIA_Sonja_LIEBE_16_00"); //Hast du zu viel Sumpfkraut geraucht? Mach dich lieber n�tzlich!

	if (SonjaGeheiratet)
	{
        AI_Output			(self, other, "DIA_Sonja_LIEBE_16_01"); //Und diesen "Mann" habe ich geheiratet ...
	};

	B_LogEntry ("Sonja", "Sonja war von meiner Liebeserkl�rung nicht sonderlich beeindruckt.");
};

///////////////////////////////////////////////////////////////////////
//	Info FAMILIE
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_FAMILIE		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_FAMILIE_Condition;
	information	 = 	DIA_Sonja_FAMILIE_Info;
	permanent	 = 	FALSE;
	description	 = 	"M�chtest du eine Familie mit mir gr�nden?";
};

func int DIA_Sonja_FAMILIE_Condition ()
{
	return SonjaFolgt == TRUE && SonjaGeheiratet == TRUE;
};

func void DIA_Sonja_FAMILIE_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_FAMILIE_15_00"); //M�chtest du eine Familie mit mir gr�nden?

	AI_Output			(self, other, "DIA_Sonja_FAMILIE_16_00"); //Du meinst mit Haus, Kindern und Haustier? Dann fang erst mal mit dem Haus an!

	B_LogEntry ("Sonja", "Sonja w�rde eine Familie mit mir gr�nden, wenn ich ein Haus habe.");
};

///////////////////////////////////////////////////////////////////////
//	Info PROFIT
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_PROFIT		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	6;
	condition	 = 	DIA_Sonja_PROFIT_Condition;
	information	 = 	DIA_Sonja_PROFIT_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Gold abholen)";
};

func int DIA_Sonja_PROFIT_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_PROFIT_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_PROFIT_15_00"); //Warst du auch flei�ig anschaffen?
	AI_Output			(self, other, "DIA_Sonja_PROFIT_16_00"); //Mein Tor ist f�r jeden Zahlenden weit ge�ffnet.

	if (Wld_GetDay() - SonjaProfitDays >= 5)
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_01"); //Hier mein Prinz. 50 Goldst�cke pro Kunde und du bekommst deine H�lfte!
        B_GiveInvItems (self, other, ItMi_Gold, (Wld_GetDay() - SonjaProfitDays) * 6 * 25); // 6 Kunden pro Tag
        SonjaProfitDays = Wld_GetDay();

        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_02"); //Und hier ist die Liste meiner letzten Kunden, damit du auch Bescheid wei�t.

        CreateInvItems (self, ItWr_SonjasListCustomers, 1);
        B_GiveInvItems (self, other, ItWr_SonjasListCustomers, 1);
	}
	else
	{
        AI_Output			(self, other, "DIA_Sonja_PROFIT_16_03"); //Komm in ein paar Tagen noch mal zu mir. Alle f�nf Tage kann ich dir dein Gold geben.
        B_LogEntry ("Sonja", "Sonja gibt mir alle f�nf Tage meinen Anteil an ihrem verdienten Gold.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(5 + SonjaProfitDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
	};
};

// ************************************************************
// 			  				TRAINING
// ************************************************************

INSTANCE DIA_Sonja_TRAINING (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 7;
	condition	= DIA_Sonja_TRAINING_Condition;
	information	= DIA_Sonja_TRAINING_Info;
	permanent	= TRUE;
	description = "(Sonja trainieren)";
};

FUNC INT DIA_Sonja_TRAINING_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_TRAINING_Info_Choices()
{
    Info_ClearChoices	(DIA_Sonja_TRAINING);

	Info_AddChoice		(DIA_Sonja_TRAINING, "Weitere Talente"	,    DIA_Sonja_TRAINING_MORE);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Runenmagie"	,    DIA_Sonja_TRAINING_RUNES);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Alchemie"	,    DIA_Sonja_TRAINING_ALCHEMY);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Mana"	,    DIA_Sonja_TRAINING_MANA);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Leben"	,    DIA_Sonja_TRAINING_HITPOINTS);
			//oth.attribute[ATR_HITPOINTS_MAX] = oth.attribute[ATR_HITPOINTS_MAX] + points;
		//oth.attribute[ATR_HITPOINTS] = oth.attribute[ATR_HITPOINTS_MAX];

		//concatText = ConcatStrings(PRINT_BlessHitpoints_MAX, IntToString(points));
		//PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Armbrust"	,    DIA_Sonja_TRAINING_CROSSBOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Bogen"	,    DIA_Sonja_TRAINING_BOW);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Zweihandwaffen"	,    DIA_Sonja_TRAINING_TWO_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Einhandwaffen"	,    DIA_Sonja_TRAINING_ONE_HAND);
	Info_AddChoice		(DIA_Sonja_TRAINING, "Geschick"	,    DIA_Sonja_TRAINING_DEX);
	Info_AddChoice		(DIA_Sonja_TRAINING, "St�rke"	,    DIA_Sonja_TRAINING_STR);
	Info_AddChoice		(DIA_Sonja_TRAINING, "(Alles Verlernen)"	,    DIA_Sonja_TRAINING_RESET);
	Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK 		, DIA_Sonja_TRAINING_BACK);
};

FUNC VOID DIA_Sonja_TRAINING_Info()
{
    AI_Output			(other, self, "DIA_Sonja_TRAINING_15_00"); //Lass mich dich trainieren!
    B_LogEntry ("Sonja", "Ich kann Sonja mit ihrer eigenen gesammelten Erfahrung trainieren.");

    DIA_Sonja_TRAINING_Info_Choices();
};

func void DIA_Sonja_TRAINING_BACK()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
};

func void DIA_Sonja_TRAINING_RESET ()
{
    Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, "Ja"			,DIA_Sonja_Teach_Reset);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_Teach_Reset ()
{
    AI_Output			(other, self, "DIA_Sonja_TRAINING_15_01"); //Verlerne alles was ich dir beigebracht habe.

    B_ResetSonja(self);

    DIA_Sonja_TRAINING_Info_Choices();
};

func void DIA_Sonja_TRAINING_STR ()
{
    Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR1			, B_GetLearnCostAttribute(other, ATR_STRENGTH))			,DIA_Sonja_Teach_STR_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnSTR5			, B_GetLearnCostAttribute(other, ATR_STRENGTH)*5)		,DIA_Sonja_Teach_STR_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_Teach_STR_1 ()
{
	B_TeachAttributePoints (other, self, ATR_STRENGTH, 1, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

FUNC VOID DIA_Sonja_Teach_STR_5 ()
{
	B_TeachAttributePoints (other, self, ATR_STRENGTH, 5, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

func void DIA_Sonja_TRAINING_DEX ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnDEX1			, B_GetLearnCostAttribute(other, ATR_DEXTERITY))			,DIA_Sonja_Teach_DEX_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnDEX5			, B_GetLearnCostAttribute(other, ATR_DEXTERITY)*5)		,DIA_Sonja_Teach_DEX_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_Teach_DEX_1 ()
{
	B_TeachAttributePoints (other, self, ATR_DEXTERITY, 1, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

FUNC VOID DIA_Sonja_Teach_DEX_5 ()
{
	B_TeachAttributePoints (other, self, ATR_DEXTERITY, 5, T_MAX);

	DIA_Sonja_TRAINING_STR();
};

func void DIA_Sonja_TRAINING_ONE_HAND ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn1h1	, B_GetLearnCostTalent(other, NPC_TALENT_1H, 1))			,DIA_Sonja_Teach_1H_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn1h5	, B_GetLearnCostTalent(other, NPC_TALENT_1H, 1)*5)		,DIA_Sonja_Teach_1H_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_1H_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_1H, 1, T_MAX);

	DIA_Sonja_TRAINING_ONE_HAND();
};

FUNC VOID DIA_Sonja_Teach_1H_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_1H, 5, T_MAX);

	DIA_Sonja_TRAINING_ONE_HAND();
};


func void DIA_Sonja_TRAINING_TWO_HAND ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn2h1	, B_GetLearnCostTalent(other, NPC_TALENT_2H, 1))			,DIA_Sonja_Teach_2H_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_Learn2h5	, B_GetLearnCostTalent(other, NPC_TALENT_2H, 1)*5)		,DIA_Sonja_Teach_2H_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_2H_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_2H, 1, T_MAX);

	DIA_Sonja_TRAINING_TWO_HAND();
};

FUNC VOID DIA_Sonja_Teach_2H_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_2H, 5, T_MAX);

	DIA_Sonja_TRAINING_TWO_HAND();
};

func void DIA_Sonja_TRAINING_BOW ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnBow1	, B_GetLearnCostTalent(other, NPC_TALENT_BOW, 1))			,DIA_Sonja_Teach_Bow_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnBow5	, B_GetLearnCostTalent(other, NPC_TALENT_BOW, 1)*5)		,DIA_Sonja_Teach_Bow_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_Bow_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_BOW, 1, T_MAX);

	DIA_Sonja_TRAINING_BOW();
};

FUNC VOID DIA_Sonja_Teach_Bow_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_BOW, 5, T_MAX);

	DIA_Sonja_TRAINING_BOW();
};

func void DIA_Sonja_TRAINING_CROSSBOW ()
{
	Info_ClearChoices (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnCrossBow1	, B_GetLearnCostTalent(other, NPC_TALENT_CROSSBOW, 1))			,DIA_Sonja_Teach_CrossBow_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnCrossBow5	, B_GetLearnCostTalent(other, NPC_TALENT_CROSSBOW, 1)*5)		,DIA_Sonja_Teach_CrossBow_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, DIALOG_BACK, DIA_Sonja_TRAINING_Info_Choices);
};

func VOID DIA_Sonja_Teach_CrossBow_1()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_CROSSBOW, 1, T_MAX);

	DIA_Sonja_TRAINING_CROSSBOW();
};

FUNC VOID DIA_Sonja_Teach_CrossBow_5()
{
	B_TeachFightTalentPercent (other, self, NPC_TALENT_CROSSBOW, 5, T_MAX);

	DIA_Sonja_TRAINING_CROSSBOW();
};

func void DIA_Sonja_TRAINING_HITPOINTS ()
{
    Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS1			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX))			,DIA_Sonja_TEACH_HITPOINTS_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnHITPOINTS5			, B_GetLearnCostAttribute(other, ATR_HITPOINTS_MAX)*5)		,DIA_Sonja_TEACH_HITPOINTS_5);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_TEACH_HITPOINTS_1()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 1, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};
FUNC VOID DIA_Sonja_TEACH_HITPOINTS_5()
{
	B_TeachAttributePoints (other, self, ATR_HITPOINTS_MAX, 5, T_MEGA);

	DIA_Sonja_TRAINING_HITPOINTS();
};

func void DIA_Sonja_TRAINING_MANA ()
{
	Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA1			, B_GetLearnCostAttribute(other, ATR_MANA_MAX))			,DIA_Sonja_TEACH_MANA_1);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString(PRINT_LearnMANA5			, B_GetLearnCostAttribute(other, ATR_MANA_MAX)*5)		,DIA_Sonja_TEACH_MANA_5);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

FUNC VOID DIA_Sonja_TEACH_MANA_1()
{
	B_TeachAttributePoints (other, self, ATR_MANA_MAX, 1, T_MEGA);

	DIA_Sonja_TRAINING_MANA();
};
FUNC VOID DIA_Sonja_TEACH_MANA_5()
{
	B_TeachAttributePoints (other, self, ATR_MANA_MAX, 5, T_MEGA);

	DIA_Sonja_TRAINING_MANA();
};

func void DIA_Sonja_TRAINING_RUNES ()
{
    Info_ClearChoices   (DIA_Sonja_TRAINING);

    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_6, DIA_Sonja_TEACH_MAGIC_CIRCLE_6);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_5, DIA_Sonja_TEACH_MAGIC_CIRCLE_5);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_4, DIA_Sonja_TEACH_MAGIC_CIRCLE_4);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_3, DIA_Sonja_TEACH_MAGIC_CIRCLE_3);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_2, DIA_Sonja_TEACH_MAGIC_CIRCLE_2);
    Info_AddChoice		(DIA_Sonja_TRAINING, PRINT_LearnCircle_1, DIA_Sonja_TEACH_MAGIC_CIRCLE_1);

    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_1 ()
{
    if (B_TeachMagicCircle (other,self, 1))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_02"); //Du bist bist nun im ersten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_2 ()
{
    if (B_TeachMagicCircle (other,self, 2))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_03"); //Du bist bist nun im zweiten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_3 ()
{
    if (B_TeachMagicCircle (other,self, 3))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_04"); //Du bist bist nun im dritten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_4 ()
{
    if (B_TeachMagicCircle (other,self, 4))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_05"); //Du bist bist nun im vierten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_5 ()
{
    if (B_TeachMagicCircle (other,self, 5))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_06"); //Du bist bist nun im f�nften Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TEACH_MAGIC_CIRCLE_6 ()
{
    if (B_TeachMagicCircle (other,self, 6))
    {
        AI_Output			(other, self, "DIA_Sonja_TRAINING_15_07"); //Du bist bist nun im sechsten Kreis der Magie.
    };

	DIA_Sonja_TRAINING_RUNES();
};

func void DIA_Sonja_TRAINING_ALCHEMY ()
{
	DIA_Sonja_TRAINING_Info();
};

func void DIA_Sonja_TRAINING_MORE ()
{
	Info_ClearChoices   (DIA_Sonja_TRAINING);
    Info_AddChoice		(DIA_Sonja_TRAINING, B_BuildLearnString("Schleichen", B_GetLearnCostTalent(self, NPC_TALENT_SNEAK, 1)), DIA_Sonja_TEACH_SNEAK);
    Info_AddChoice 		(DIA_Sonja_TRAINING,DIALOG_BACK,DIA_Sonja_TRAINING_Info_Choices);
};

func void DIA_Sonja_TEACH_SNEAK ()
{
    if (B_TeachThiefTalent (other, self, NPC_TALENT_SNEAK))
	{
		AI_Output (self, other, "DIA_Sonja_TRAINING_15_08");//Du kannst jetzt schleichen.
	};

	DIA_Sonja_TRAINING_MORE();
};

//func void AI_SetWalkmode(var c_npc n, var int n0)
//gibt an mit welchem Walkmode Run etc der Character durch das Level l�uft
//NPC_RUN : Rennen
//NPC_WALK : Gehen
//NPC_SNEAK : Schleichen
//NPC_RUN_WEAPON : Rennen mit gezogener Waffe
//NPC_WALK_WEAPON : Gehen mit gezogener Waffe
//NPC_SNEAK_WEAPON : Schleichen mit gezogener Waffe

//////////////////////////////////////////////////////////////////////
//	Info CHANGE
///////////////////////////////////////////////////////////////////////
INSTANCE DIA_Sonja_CHANGE   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 10;
	condition   = DIA_Sonja_CHANGE_Condition;
	information = DIA_Sonja_CHANGE_Action;
	permanent   = TRUE;
	description = "(Verhalten �ndern)";
};

FUNC INT DIA_Sonja_CHANGE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_CHANGE_Action()
{
	Info_ClearChoices   (DIA_Sonja_CHANGE);
    Info_AddChoice		(DIA_Sonja_CHANGE, "�ndere dein Kampfverhalten!", DIA_Sonja_FAI_Action);
    Info_AddChoice		(DIA_Sonja_CHANGE, "�ndere deine Gangart!", DIA_Sonja_WALKMODE_Action);
    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_CHANGE_Back);

};

func void DIA_Sonja_CHANGE_Back()
{
    Info_ClearChoices   (DIA_Sonja_CHANGE);
};

FUNC VOID DIA_Sonja_WALKMODE_Action()
{
	AI_Output (other, self, "DIA_Sonja_WALKMODE_15_00");//�ndere deine Gangart!

	Info_ClearChoices   (DIA_Sonja_CHANGE);
	if (Npc_GetTalentSkill(self, NPC_TALENT_SNEAK) == 1)
	{
        Info_AddChoice		(DIA_Sonja_CHANGE, "Schleiche", DIA_Sonja_WALKMODE_SNEAK);
    };
	Info_AddChoice		(DIA_Sonja_CHANGE, "Gehe", DIA_Sonja_WALKMODE_WALK);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Renne (Standard)", DIA_Sonja_WALKMODE_RUN);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Sprinte", DIA_Sonja_WALKMODE_SPRINT);

    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_WALKMODE_Back);

};

func void DIA_Sonja_WALKMODE_Back ()
{
    DIA_Sonja_CHANGE_Action();
};

func void DIA_Sonja_WALKMODE_SPRINT ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_01");//Sprinte!
    Mdl_ApplyOverlayMDSTimed	(self, "HUMANS_SPRINT.MDS", Time_Speed);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_RUN ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_02");//Renne!
    AI_SetWalkmode(self, NPC_RUN);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_WALK ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_03");//Gehe!
    AI_SetWalkmode(self, NPC_WALK);

    DIA_Sonja_WALKMODE_Action();
};

func void DIA_Sonja_WALKMODE_SNEAK ()
{
    AI_Output (other, self, "DIA_Sonja_WALKMODE_15_04");//Schleiche!
    AI_SetWalkmode(self, NPC_SNEAK);

    DIA_Sonja_WALKMODE_Action();
};

//const int FAI_HUMAN_COWARD				= 2		;
//const int FAI_HUMAN_NORMAL				= 42	;
//const int FAI_HUMAN_STRONG				= 3		;
//const int FAI_HUMAN_MASTER				= 4		;

FUNC VOID DIA_Sonja_FAI_Action()
{
	AI_Output (other, self, "DIA_Sonja_FAI_15_00");//�ndere dein Kampfverhalten!

	Info_ClearChoices   (DIA_Sonja_CHANGE);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Meister", DIA_Sonja_FAI_MASTER);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Stark", DIA_Sonja_FAI_STRONG);
	Info_AddChoice		(DIA_Sonja_CHANGE, "Normal", DIA_Sonja_FAI_NORMAL);
    Info_AddChoice		(DIA_Sonja_CHANGE, "Feigling (Standard)", DIA_Sonja_FAI_COWARD);
    Info_AddChoice 		(DIA_Sonja_CHANGE,DIALOG_BACK,DIA_Sonja_FAI_Back);

};

func void DIA_Sonja_FAI_Back ()
{
    DIA_Sonja_CHANGE_Action();
};

func void DIA_Sonja_FAI_COWARD ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_01");//K�mpfe wie ein Feigling!
    self.fight_tactic = FAI_HUMAN_COWARD;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_NORMAL ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_02");//K�mpfe normal!
    self.fight_tactic = FAI_HUMAN_NORMAL;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_STRONG ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_03");//K�mpfe stark!
    self.fight_tactic = FAI_HUMAN_STRONG;

    DIA_Sonja_FAI_Action();
};

func void DIA_Sonja_FAI_MASTER ()
{
    AI_Output (other, self, "DIA_Sonja_FAI_15_04");//K�mpfe wie ein Meister!
    self.fight_tactic = FAI_HUMAN_MASTER;

    DIA_Sonja_FAI_Action();
};

//---------------------------------------------------------------------
//	Info einsch�tzen
//---------------------------------------------------------------------
INSTANCE DIA_Sonja_ein   (C_INFO)
{
	npc         = VLK_436_Sonja;
	nr          = 900;
	condition   = DIA_Sonja_ein_Condition;
	information = DIA_Sonja_ein_Info;
	permanent   = TRUE;
	description = "(Einsch�tzen lassen)";
};

FUNC INT DIA_Sonja_ein_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ein_Info()
{
    Info_ClearChoices   (DIA_Sonja_ein);
	Info_AddChoice		(DIA_Sonja_ein, "F�higkeit als Zuh�lter einsch�tzen lassen", DIA_Sonja_PIMP_Info);
	Info_AddChoice		(DIA_Sonja_ein, "F�higkeit als Aufrei�er einsch�tzen lassen", DIA_Sonja_AUFREISSER_Info);
    Info_AddChoice		(DIA_Sonja_ein, "F�higkeit Goldhacken einsch�tzen lassen", DIA_Sonja_ein_Info_Gold);
    Info_AddChoice 		(DIA_Sonja_ein,DIALOG_BACK,DIA_Sonja_ein_Info_Back);
};

func void DIA_Sonja_ein_Info_Back()
{
    Info_ClearChoices   (DIA_Sonja_ein);
};

FUNC VOID DIA_Sonja_ein_Info_Gold()
{
	AI_Output (other, self, "DIA_Addon_Finn_ein_15_00");//Kannst du meine F�higkeit im Goldhacken einsch�tzen?

	AI_Output (self, other, "DIA_Sonja_ein_16_01");//Bei dir w�rde ich sagen, du bist ein ...

	if (Hero_HackChance < 20)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_02"); //blutiger Anf�nger.
	}
	else if (Hero_HackChance < 40)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_03"); //ganz passabler Sch�rfer.
	}
	else if (Hero_HackChance < 55)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_04"); //erfahrener Goldsch�rfer.
	}
	else if (Hero_HackChance < 75)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_05"); //wachechter Buddler.
	}
	else if (Hero_HackChance < 90)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_06"); //verdammt guter Buddler.
	}
	else if (Hero_HackChance < 98)
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_07"); //Meister Buddler.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_ein_16_08"); //Guru - unter den Buddlern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Goldhacken: ", IntToString (Hero_HackChance));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

FUNC VOID DIA_Sonja_AUFREISSER_Info()
{
	AI_Output (other, self, "DIA_Sonja_AUFREISSER_15_00");//Kannst du meine F�higkeit als Aufrei�er einsch�tzen?

	AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_00");//Bei dir w�rde ich sagen, du bist ein ...

	if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 20)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_01"); //blutiger Anf�nger.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 40)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_02"); //ganz passabler Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 55)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_03"); //erfahrener Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 75)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_04"); //wachechter Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 90)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_05"); //verdammt guter Aufrei�er.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER) < 98)
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_06"); //Meister-Aufrei�er.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_AUFREISSER_16_07"); //Guru - unter den Aufrei�ern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Aufrei�er: ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER)));
	ConcatText = ConcatStrings (ConcatText, " Prozent");
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

FUNC VOID DIA_Sonja_PIMP_Info()
{
	AI_Output (other, self, "DIA_Sonja_PIMP_15_00");//Kannst du meine F�higkeit als Zuh�lter einsch�tzen?

	AI_Output (self, other, "DIA_Sonja_PIMP_16_00");//Bei dir w�rde ich sagen, du bist ein ...

	if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 1)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_01"); //blutiger Anf�nger.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 2)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_02"); //ganz passabler Zuh�lter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 3)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_03"); //erfahrener Zuh�lter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 4)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_04"); //wachechter Zuh�lter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 5)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_05"); //verdammt guter Zuh�lter.
	}
	else if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 6)
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_06"); //Meister-Zuh�lter.
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_PIMP_16_07"); //Guru - unter den Zuh�ltern.
	};


	var string ConcatText;

	ConcatText = ConcatStrings ("Zuh�lter: ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_PIMP)));
	PrintScreen (concatText, -1, -1, FONT_ScreenSmall,2);

	DIA_Sonja_ein_Info();
};

//*******************************************
//	TeachPlayerAufreisser
//*******************************************

INSTANCE DIA_Sonja_TEACH(C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 99;
	condition	= DIA_Sonja_TEACH_Condition;
	information	= DIA_Sonja_TEACH_Info;
	permanent	= TRUE;
	description = "Bring mir etwas bei.";
};

FUNC INT DIA_Sonja_TEACH_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_TEACH_Info()
{
    Info_ClearChoices   (DIA_Sonja_TEACH);
	Info_AddChoice		(DIA_Sonja_TEACH, "Zeig mir, wie ich ein besserer Zuh�lter werde.", DIA_Sonja_TEACHPIMP_Info);
    Info_AddChoice		(DIA_Sonja_TEACH, "Zeig mir, wie ich andere besser aufrei�en kann.", DIA_Sonja_TEACHAUFREISSER_Info);
    Info_AddChoice 		(DIA_Sonja_TEACH,DIALOG_BACK,DIA_Sonja_TEACH_Back);
};

func void DIA_Sonja_TEACH_Back()
{
    Info_ClearChoices   (DIA_Sonja_TEACH);
};

func int B_TeachAufreisserTalentPercent (var C_NPC slf, var C_NPC oth, var int percent, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	//kosten = (B_GetLearnCostTalent(oth, NPC_TALENT_WOMANIZER, 1) * percent);
	kosten = percent; // 1 LP pro Aufreisser %

	//EXIT IF...

	// ------ Lernen NICHT �ber teacherMax ------
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

	concatText = ConcatStrings ("Verbessere: Aufrei�en zu ", IntToString (Npc_GetTalentSkill(other, NPC_TALENT_WOMANIZER)));
	concatText = ConcatStrings (ConcatText, " Prozent");
    PrintScreen	(concatText, -1, -1, FONT_Screen, 2);


    return TRUE;
};

func void SonjaTeachAufreisser()
{
    Info_ClearChoices (DIA_Sonja_TEACH);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufrei�en +20"			, 10)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_20);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufrei�en +10"			, 10)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_10);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufrei�en +5"			, 5)		,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5);
    Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString("Aufrei�en +1"			, 1)			,DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1);
    Info_AddChoice		(DIA_Sonja_TEACH, DIALOG_BACK, DIA_Sonja_TEACHAUFREISSER_Back);
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Info()
{
	AI_Output (other,self ,"DIA_Sonja_TEACHAUFREISSER_15_00"); //Zeig mir, wie ich andere besser aufrei�en kann.
    AI_Output (self, other, "DIA_Sonja_TEACHAUFREISSER_16_00"); //Ach du, als ob du jemals eine andere Frau beeindrucken wirst. Na gut, wir probieren es trotzdem.

    SonjaTeachAufreisser();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_Back ()
{
	DIA_Sonja_TEACH_Info();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_1 ()
{
	B_TeachAufreisserTalentPercent (self, other, 1, T_MAX);

	SonjaTeachAufreisser();
};

FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_5 ()
{
	B_TeachAufreisserTalentPercent (self, other, 5, T_MAX);

	SonjaTeachAufreisser();
};


FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_10 ()
{
	B_TeachAufreisserTalentPercent (self, other, 10, T_MAX);

	SonjaTeachAufreisser();
};


FUNC VOID DIA_Sonja_TEACHAUFREISSER_AUFREISSER_20 ()
{
	B_TeachAufreisserTalentPercent (self, other, 20, T_MAX);

	SonjaTeachAufreisser();
};

func int B_TeachPimpTalent (var C_NPC slf, var C_NPC oth, var int circle, var int teacherMAX)
{
	var string concatText;

	// ------ Kostenberechnung ------
	var int kosten;
	//kosten = (B_GetLearnCostTalent(oth, NPC_TALENT_WOMANIZER, 1) * circle);
	kosten = circle; // 1 LP pro Aufreisser %

	//EXIT IF...

	// ------ Lernen NICHT �ber teacherMax ------
	var int realHitChance;
	realHitChance = Npc_GetTalentSkill(oth, NPC_TALENT_PIMP);

	if (realHitChance >= teacherMAX)
	{
		concatText = ConcatStrings (PRINT_NoLearnOverPersonalMAX, IntToString(teacherMAX));
		PrintScreen	(concatText, -1, -1, FONT_SCREEN, 2);
		B_Say (slf, oth, "$NOLEARNYOUREBETTER");

		return FALSE;
	};

	if (circle > teacherMAX)
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

	// ------ ZUH�LTER steigern ------
    Npc_SetTalentSkill (oth, NPC_TALENT_PIMP, circle);	//Pimp

    concatText = ConcatStrings("Erlerne Kreis des Zuh�lters: ", IntToString(circle));

    PrintScreen	(concatText, -1, -1, FONT_Screen, 2);

    return TRUE;
};

func void SonjaTeachPimp()
{
    Info_ClearChoices (DIA_Sonja_TEACH);
    if (Npc_GetTalentSkill(other, NPC_TALENT_PIMP) < 6)
    {
        var String concatText;
        concatText = ConcatStrings("Erlerne  ", IntToString(Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1));
        concatText = ConcatStrings(concatText, ". Kreis des Zuh�lters");
        Info_AddChoice		(DIA_Sonja_TEACH, B_BuildLearnString(concatText, Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1)			,DIA_Sonja_TEACHPIMP_1);
    };
    Info_AddChoice		(DIA_Sonja_TEACH, DIALOG_BACK, DIA_Sonja_TEACHPIMP_Back);
};

FUNC VOID DIA_Sonja_TEACHPIMP_Info()
{
	AI_Output (other,self ,"DIA_Sonja_TEACHPIMP_15_00"); //Zeig mir, wie ich ein besserer Zuh�lter werde.
    AI_Output (self, other, "DIA_Sonja_TEACHPIMP_16_00"); //Das ist ein schwieriges Handwerk. Mal schauen ob es dir liegt.

    SonjaTeachPimp();
};

FUNC VOID DIA_Sonja_TEACHPIMP_Back ()
{
	DIA_Sonja_TEACH_Info();
};

FUNC VOID DIA_Sonja_TEACHPIMP_1 ()
{
	B_TeachPimpTalent (self, other, Npc_GetTalentSkill(other, NPC_TALENT_PIMP) + 1, 6);

	SonjaTeachPimp();
};

// ************************************************************
// 			  				ROUTINE
// ************************************************************

INSTANCE DIA_Sonja_ROUTINE (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ROUTINE_Condition;
	information	= DIA_Sonja_ROUTINE_Info;
	permanent	= TRUE;
	description = "(T�tigkeit)";
};

FUNC INT DIA_Sonja_ROUTINE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ROUTINE_Info()
{
	Info_ClearChoices	(DIA_Sonja_ROUTINE);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Orlan's Taverne"	,        DIA_Sonja_ROUTINE_Orlan);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Onars Hof"	,        DIA_Sonja_ROUTINE_Lee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zu Xardas Turm"	,    DIA_Sonja_ROUTINE_Xardas);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zum Kloster"	,    DIA_Sonja_ROUTINE_Pyrokar);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Gehe zum Marktplaz"	,    DIA_Sonja_ROUTINE_Vatras);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Tanzen"	,            DIA_Sonja_ROUTINE_Dance);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "F�r kleine M�dchen",    DIA_Sonja_ROUTINE_Pee);
	Info_AddChoice		(DIA_Sonja_ROUTINE, "Sitze in der Roten Laterne (Standard)",    DIA_Sonja_ROUTINE_Start);
	Info_AddChoice		(DIA_Sonja_ROUTINE, DIALOG_BACK 		,    DIA_Sonja_ROUTINE_BACK);
};

func void DIA_Sonja_ROUTINE_BACK()
{
	Info_ClearChoices (DIA_Sonja_ROUTINE);
};

func void DIA_Sonja_ROUTINE_Start()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_00"); //Setz dich in die Rote Laterne!
	Npc_ExchangeRoutine	(self,"START");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Pee ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_01"); //Geh mal f�r kleine M�dchen!
	Npc_ExchangeRoutine	(self,"PEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Dance ()
{
	AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_02"); //Tanz!
	Npc_ExchangeRoutine	(self,"DANCE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Vatras()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_03"); //Gehe zum Marktplatz!
	Npc_ExchangeRoutine	(self,"VATRAS");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Pyrokar()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_04"); //Gehe zum Kloster!
	Npc_ExchangeRoutine	(self,"PYROKAR");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Xardas()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_05"); //Gehe zu Xardas Turm!
	Npc_ExchangeRoutine	(self,"XARDAS");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Lee()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_06"); //Gehe zu Onars Hof!
	Npc_ExchangeRoutine	(self,"LEE");

	DIA_Sonja_ROUTINE_Info();
};

func void DIA_Sonja_ROUTINE_Orlan()
{
    AI_Output			(other, self, "DIA_Sonja_ROUTINE_15_07"); //Gehe zu Orlan's Taverne!
	Npc_ExchangeRoutine	(self,"ORLAN");

	DIA_Sonja_ROUTINE_Info();
};

//S_INNOS_S1
//S_RAKE_S1
//S_SLEEPGROUND
//S_WASH
//  func void TA_Pray_Innos_FP		(var int start_h, var int start_m, var int stop_h, var int stop_m, VAR string waypoint)	{TA_Min		(self,	start_h,start_m, stop_h, stop_m, ZS_Pray_Innos_FP,			waypoint);};
//func void TA_Dance				(var int start_h, var int start_m, var int stop_h, var int stop_m, VAR string waypoint)	{TA_Min		(self,	start_h,start_m, stop_h, stop_m, ZS_Dance,					waypoint);};


// ************************************************************
// 			  				AUSSEHEN
// ************************************************************

INSTANCE DIA_Sonja_AUSSEHEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_AUSSEHEN_Condition;
	information	= DIA_Sonja_AUSSEHEN_Info;
	permanent	= TRUE;
	description = "(Aussehen)";
};

FUNC INT DIA_Sonja_AUSSEHEN_Condition()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_AUSSEHEN_Info ()
{
    Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Sch�nheits-OP f�r Gesicht und Frisur)"	,              DIA_Sonja_Choose_Face_Info);
    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Sch�nheits-OP f�r die Hautfarbe)"	,              DIA_Sonja_Choose_BodyTex_Info);
    Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Sch�nheits-OP f�r Kopf)"	,          DIA_Sonja_Choose_HeadMesh_Info);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "(Allgemeines Aussehen)"	,  DIA_Sonja_AUSSEHEN_Allegemein_Info);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_BACK);
};


func void DIA_Sonja_AUSSEHEN_BACK()
{
	Info_ClearChoices (DIA_Sonja_AUSSEHEN);
};

FUNC VOID DIA_Sonja_AUSSEHEN_Allegemein_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "B�rgerin"	,    DIA_Sonja_AUSSEHEN_Citizen);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "B�uerin"	,    DIA_Sonja_AUSSEHEN_Farmer);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Vanja"	,    DIA_Sonja_AUSSEHEN_Vanja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Lucia"	,    DIA_Sonja_AUSSEHEN_Lucia);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Nadja"	,    DIA_Sonja_AUSSEHEN_Nadja);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Dick"	,    DIA_Sonja_AUSSEHEN_Fat);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "D�nn"	,    DIA_Sonja_AUSSEHEN_Thin);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Anziehen"	,    DIA_Sonja_AUSSEHEN_Clothing);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Ausziehen"	,    DIA_Sonja_AUSSEHEN_Nude);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Normal"	,    DIA_Sonja_AUSSEHEN_Normal);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 		, DIA_Sonja_AUSSEHEN_Allgemein_BACK);
};

func void DIA_Sonja_AUSSEHEN_Allgemein_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

func void DIA_Sonja_AUSSEHEN_Nude ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_00"); //Zieh dich aus!

    AI_UnequipArmor (self);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Clothing ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_01"); //Zieh dir was an!

    AI_EquipBestArmor (self);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Fat ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_02"); //Iss etwas!

    Mdl_SetModelFatness (self, 4);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Thin ()
{
	AI_Output			(other, self, "DIA_Sonja_AUSSEHEN_15_03"); //Mach ein bisschen Sport!

    Mdl_SetModelFatness (self, 0);

    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Normal()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe6", FaceBabe_L_Charlotte2, BodyTexBabe_L, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Nadja()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_Hure, BodyTex_N, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Lucia()
{
	B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe8", FaceBabe_N_GreyCloth, BodyTexBabe_F, NO_ARMOR);
	DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Vanja()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe", FaceBabe_B_RedLocks, BodyTexBabe_B, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Farmer()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_Babe4", FaceBabe_N_VlkBlonde, BodyTexBabe_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

func void DIA_Sonja_AUSSEHEN_Citizen()
{
    B_SetNpcVisual 		(self, FEMALE, "Hum_Head_BabeHair", FaceBabe_N_HairAndCloth, BodyTex_N, NO_ARMOR);
    DIA_Sonja_AUSSEHEN_Allegemein_Info();
};

FUNC VOID DIA_Sonja_Choose_HeadMesh_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_BabeHair", DIA_Sonja_Choose_HeadMesh_17);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe8" 	, DIA_Sonja_Choose_HeadMesh_16);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe7" 	, DIA_Sonja_Choose_HeadMesh_15);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe6" 	, DIA_Sonja_Choose_HeadMesh_14);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe5" 	, DIA_Sonja_Choose_HeadMesh_13);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe4" 	, DIA_Sonja_Choose_HeadMesh_12);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe3" 	, DIA_Sonja_Choose_HeadMesh_11);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe2" 	, DIA_Sonja_Choose_HeadMesh_10);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe1" 	, DIA_Sonja_Choose_HeadMesh_9);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Hum_Head_Babe" 	, DIA_Sonja_Choose_HeadMesh_8);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_HeadMesh_BACK);
};

func void DIA_Sonja_Choose_HeadMesh_8()
{
	Sonja_HeadMesh 	="Hum_Head_Babe";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_9()
{
	Sonja_HeadMesh 	="Hum_Head_Babe1";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_10()
{
	Sonja_HeadMesh 	="Hum_Head_Babe2";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_11()
{
	Sonja_HeadMesh 	="Hum_Head_Babe3";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_12()
{
	Sonja_HeadMesh 	="Hum_Head_Babe4";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_13()
{
	Sonja_HeadMesh 	="Hum_Head_Babe5";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_14()
{
	Sonja_HeadMesh 	="Hum_Head_Babe6";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_15()
{
	Sonja_HeadMesh 	="Hum_Head_Babe7";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_16()
{
	Sonja_HeadMesh 	="Hum_Head_Babe8";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
func void DIA_Sonja_Choose_HeadMesh_17()
{
	Sonja_HeadMesh 	="Hum_Head_BabeHair";
	Change_Sonja_Visual();
	DIA_Sonja_Choose_HeadMesh_Info();
};
// ------------------------------------------------

func void DIA_Sonja_Choose_HeadMesh_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

FUNC VOID DIA_Sonja_Choose_BodyTex_Info()
{
	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "K�sewei�" 	, DIA_Sonja_Choose_BodyTexBabe_P);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Wei�" 	,    DIA_Sonja_Choose_BodyTexBabe_N);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Latino" 	, DIA_Sonja_Choose_BodyTexBabe_L);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Farbig" 	, DIA_Sonja_Choose_BodyTexBabe_B);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_BodyTex_BACK);
};

func void DIA_Sonja_Choose_BodyTexBabe_B()
{
	Sonja_BodyTexture 	=BodyTexBabe_B;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_L()
{
	Sonja_BodyTexture 	=BodyTexBabe_L;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_N()
{
	Sonja_BodyTexture 	=BodyTexBabe_N;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};
func void DIA_Sonja_Choose_BodyTexBabe_P()
{
	Sonja_BodyTexture 	=BodyTexBabe_P;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_BodyTex_Info();
};

// ------------------------------------------------

func void DIA_Sonja_Choose_BodyTex_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

FUNC VOID DIA_Sonja_Choose_Face_Info()
{
    /*
const int FaceBabe_N_BlackHair		= 	137	;
const int FaceBabe_N_Blondie		= 	138	;
const int FaceBabe_N_BlondTattoo	= 	139	;
const int FaceBabe_N_PinkHair		= 	140	;
const int FaceBabe_L_Charlotte		= 	141	;
const int FaceBabe_B_RedLocks		= 	142	;
const int FaceBabe_N_HairAndCloth	= 	143	;
//
const int FaceBabe_N_WhiteCloth		= 	144	;
const int FaceBabe_N_GreyCloth		= 	145	;
const int FaceBabe_N_Brown			= 	146	;
const int FaceBabe_N_VlkBlonde		= 	147	;
const int FaceBabe_N_BauBlonde		= 	148 ;
const int FaceBabe_N_YoungBlonde	= 	149	;
const int FaceBabe_N_OldBlonde		= 	150 ;
const int FaceBabe_P_MidBlonde		= 	151 ;
const int FaceBabe_N_MidBauBlonde	= 	152 ;
const int FaceBabe_N_OldBrown		= 	153 ;
const int FaceBabe_N_Lilo			= 	154 ;
const int FaceBabe_N_Hure			= 	155 ;
const int FaceBabe_N_Anne			= 	156 ;
const int FaceBabe_B_RedLocks2		= 	157	;
const int FaceBabe_L_Charlotte2		= 	158 ;
*/

	Info_ClearChoices	(DIA_Sonja_AUSSEHEN);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Freudendame" 	, DIA_Sonja_Choose_FaceBabe_N_Hure);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Charlotte" 	, DIA_Sonja_Choose_FaceBabe_L_Charlotte);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Pinke Haare" 	, DIA_Sonja_Choose_FaceBabe_N_PinkHair);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Blondine mit Tatoos" 	, DIA_Sonja_Choose_FaceBabe_N_BlondTattoo);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Blondine" 	, DIA_Sonja_Choose_FaceBabe_N_Blondie);
	Info_AddChoice		(DIA_Sonja_AUSSEHEN, "Schwarze Haare" 	, DIA_Sonja_Choose_FaceBabe_N_BlackHair);

	Info_AddChoice		(DIA_Sonja_AUSSEHEN, DIALOG_BACK 				, DIA_Sonja_Choose_Face_BACK);
};

func void DIA_Sonja_Choose_FaceBabe_N_BlackHair()
{
	Sonja_SkinTexture 	=FaceBabe_N_BlackHair;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_Blondie()
{
	Sonja_SkinTexture 	=FaceBabe_N_Blondie;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_BlondTattoo()
{
	Sonja_SkinTexture 	=FaceBabe_N_BlondTattoo;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_N_PinkHair()
{
	Sonja_SkinTexture 	=FaceBabe_N_PinkHair;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};
func void DIA_Sonja_Choose_FaceBabe_L_Charlotte()
{
	Sonja_BodyTexture 	=FaceBabe_L_Charlotte;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};

func void DIA_Sonja_Choose_FaceBabe_N_Hure()
{
    Sonja_BodyTexture 	=FaceBabe_N_Hure;
	Change_Sonja_Visual();

	DIA_Sonja_Choose_Face_Info();
};

// ------------------------------------------------

func void DIA_Sonja_Choose_Face_BACK()
{
	DIA_Sonja_AUSSEHEN_Info();
};

// ************************************************************
// 			  				KLEIDUNG
// ************************************************************

INSTANCE DIA_Sonja_KLEIDUNG (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_KLEIDUNG_Condition;
	information	= DIA_Sonja_KLEIDUNG_Info;
	permanent	= TRUE;
	description = "(Bekleidung und Ausr�stung)";
};

FUNC INT DIA_Sonja_KLEIDUNG_Condition()
{
	return SonjaFolgt == TRUE;
};

func String BuildSonjaItemString(var String itemName, var int value)
{
    var String msg;
    msg = "";
    msg = ConcatStrings(" (", IntToString(value));
    msg = ConcatStrings(msg, " Gold)");
    msg = ConcatStrings(itemName, msg);

    return msg;
};

FUNC VOID DIA_Sonja_KLEIDUNG_Info()
{
	Info_ClearChoices	(DIA_Sonja_KLEIDUNG);

	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_MassDeath, Value_Ru_MassDeath),                 DIA_Sonja_KLEIDUNG_ItRu_MassDeath);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_ArmyOfDarkness, Value_Ru_ArmyofDarkness),       DIA_Sonja_KLEIDUNG_ItRu_ArmyOfDarkness);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString(NAME_SPL_InstantFireball, Value_Ru_InstantFireball),     DIA_Sonja_KLEIDUNG_ItRu_InstantFireball);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbesiegbarkeit", Value_Ri_ProtTotal02),       DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_02);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Ring der Unbezwingbarkeit", Value_Ri_ProtTotal),        DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_01);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Wassermagierrobe", VALUE_ITAR_KDW_H),                   DIA_Sonja_KLEIDUNG_ITAR_KDW_H);
	if (Kapitel >= 5)
	{
        Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwere Drachenj�gerr�stung", VALUE_ITAR_DJG_H),        DIA_Sonja_KLEIDUNG_ITAR_DJG_H);
    };
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("R�stung Drachenj�gerin", 2000),          DIA_Sonja_KLEIDUNGITAR_DJG_BABE);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kleidung B�uerin", 200),                                DIA_Sonja_KLEIDUNG_Farmer);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Leichte Armbrust", Value_LeichteArmbrust),              DIA_Sonja_KLEIDUNG_ItRw_Crossbow_L_02);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Buchenbogen", Value_Buchenbogen),                       DIA_Sonja_KLEIDUNG_ItRw_Bow_M_04);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kompositbogen", Value_Kompositbogen),                   DIA_Sonja_KLEIDUNG_ItRw_Bow_M_01);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Folteraxt", Value_Folteraxt),                           DIA_Sonja_KLEIDUNG_ItMw_Folteraxt);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Kurzschwert", Value_ShortSword3),                       DIA_Sonja_KLEIDUNG_ItMw_ShortSword3);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, BuildSonjaItemString("Schwerer Ast", Value_BauMace),                          DIA_Sonja_KLEIDUNG_Schwerer_Ast);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bester G�rtel aus ihrem Inventar",                                           DIA_Sonja_KLEIDUNG_BestBelt);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Ringe aus ihrem Inventar",                                             DIA_Sonja_KLEIDUNG_BestRings);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Bestes Amulett aus ihrem Inventar",                                          DIA_Sonja_KLEIDUNG_BestAmulet);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Spruchrolle aus ihrem Inventar",                                       DIA_Sonja_KLEIDUNG_BestScroll);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Rune aus ihrem Inventar",                                              DIA_Sonja_KLEIDUNG_BestRune);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Fernkampfwaffe aus ihrem Inventar",                                    DIA_Sonja_KLEIDUNG_BestRangeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste Nahkampfwaffe aus ihrem Inventar",                                     DIA_Sonja_KLEIDUNG_BestMeleeWeapon);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Beste R�stung aus ihrem Inventar",                                           DIA_Sonja_KLEIDUNG_BestArmor);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Lege alle Ausr�stung ab",                                                    DIA_Sonja_KLEIDUNG_Unequip);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, "Normal",                                                                     DIA_Sonja_KLEIDUNG_Normal);
	Info_AddChoice		(DIA_Sonja_KLEIDUNG, DIALOG_BACK,                                                                  DIA_Sonja_KLEIDUNG_BACK);
};

func void DIA_Sonja_KLEIDUNG_BACK()
{
	Info_ClearChoices (DIA_Sonja_KLEIDUNG);
};

func void Sonja_Equip(var int armor, var int cost)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_00"); //Benutz das hier!
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_00"); //Wie du magst!
        EquipItem(self, armor);
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_KLEIDUNG_16_01"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Ausr�stung f�r sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_01"); //Hier ist neue Ausr�stung!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            B_GiveInvItems (other, self, armor, 1);
            EquipItem(self, armor);
            B_LogEntry ("Sonja", "Sonja freut sich �ber neue Ausr�stung.");
        };
    };
};

func void Sonja_Bekleiden(var int armor, var int cost)
{
    if (Npc_HasItems(self, armor))
    {
        AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_02"); //Zieh das hier an!
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_00"); //Wie du magst!

        AI_UnequipArmor	(self);
        AI_EquipArmor 	(self, armor);
        //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
        B_LogEntry ("Sonja", "Ich kann Sonja sagen, was sie anziehen soll. Sie findet das in Ordnung.");
    }
    else
    {
        if (Npc_HasItems (other, ItMi_Gold) < cost)
        {
            AI_Output (self, other, "DIA_Sonja_KLEIDUNG_16_01"); //Willst du mich verarschen? Du hast nicht genug Gold dabei!
            B_LogEntry ("Sonja", "Sonja ist genervt, dass ich mir Kleidung f�r sie nicht leisten kann.");
        }
        else
        {
            B_GiveInvItems (other, self, ItMi_Gold, cost);

            AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_03"); //Hier ist etwas Neues zum Anziehen!
            AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_02"); //Danke!

            CreateInvItems (self, armor, 1);
            AI_UnequipArmor	(self);
            AI_EquipArmor 	(self, armor);
            //AI_EquipArmor(self, Npc_GetInvItem(self, armor));
            B_LogEntry ("Sonja", "Sonja freut sich �ber neue Kleidung.");
        };
    };
};

// Irgendwie pr�fen ob zweimal ausr�stbar.
func int Sonja_EquipFromInventoryEx(var int item, var String itemName, var int count)
{
    if (Npc_HasItems(self, item))
    {
        EquipItem(self, item);
        var String msg;
        //msg = ConcatStrings("Sonja ausger�stet mit: ", Npc_GetInvItem(item).description);
        msg = ConcatStrings("Sonja ausger�stet mit: ", itemName);
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2

        return TRUE;
    };

    return FALSE;
};

func int Sonja_EquipFromInventory(var int item, var String itemName)
{
    return Sonja_EquipFromInventoryEx(item, itemName, 1);
};

func void DIA_Sonja_KLEIDUNG_Normal ()
{
    Sonja_Bekleiden(ITAR_VlkBabe_H, 0);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Unequip ()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_04"); //Lege alles ab!
    AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_03"); //Wie du meinst, S��er.

    AI_UnequipArmor(self);
    AI_UnequipWeapons(self);
    // TODO How to unequip rings and amulets etc.
    //if (Npc_HasEquippedArmor(self, ItAm_Hp_Mana_01))
    //{
      //  AI_UseItem(self, ItAm_Hp_Mana_01);
    //};

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestArmor()
{
    AI_EquipBestArmor(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestMeleeWeapon()
{
    AI_EquipBestMeleeWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRangeWeapon()
{
    AI_EquipBestRangedWeapon(self);
    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRune()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_04"); //Lege deine beste Rune an!

    if (Sonja_EquipFromInventory(ItRu_MassDeath, NAME_SPL_MassDeath))
    {
    }
    else if (Sonja_EquipFromInventory(ItRu_InstantFireball, NAME_SPL_InstantFireball))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestScroll()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege deine beste Spruchrolle an!

    if (Sonja_EquipFromInventory(ItSc_InstantFireball, NAME_SPL_InstantFireball))
    {
    }
    else if (Sonja_EquipFromInventory(ItSc_Firebolt, NAME_SPL_Firebolt))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestAmulet()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_05"); //Lege dein bestes Amulett an!

    if (Sonja_EquipFromInventory(ItAm_Hp_Mana_01, "Amulett der Erleuchtung"))
    {
    }
    else if (Sonja_EquipFromInventory(ItAm_Prot_Point_01, "Amulett der Eichenhaut"))
    {
    }
    else if (Sonja_EquipFromInventory(ItAm_Hp_01, "Amulett der Lebenskraft"))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestRings()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_06"); //Lege deine besten Ringe an!

    if (Sonja_EquipFromInventoryEx(ItRi_Prot_Edge_01, "Ring der Eisenhaut", 2))
    {
    }
    else if (Sonja_EquipFromInventoryEx(ItRi_Prot_Total_01, "Ring der Unbezwingbarkeit", 2))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_BestBelt()
{
    AI_Output			(other, self, "DIA_Sonja_KLEIDUNG_15_07"); //Zieh deinen besten G�rtel an!

    if (Sonja_EquipFromInventory(ItBE_Addon_Leather_01, "Lederg�rtel"))
    {
    }
    else if (Sonja_EquipFromInventory(ItBE_Addon_MC, "Minecrawler G�rtel"))
    {
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich habe keinen geeigneten Gegenstand im Inventar. Kauf mir doch etwas, mein Prinz!
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Schwerer_Ast()
{
    Sonja_Equip(ItMw_1h_Bau_Mace, Value_BauMace);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItMw_ShortSword3()
{
    Sonja_Equip(ItMw_ShortSword3, Value_ShortSword3);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItMw_Folteraxt()
{
    Sonja_Equip(ItMw_Folteraxt, Value_Folteraxt);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Bow_M_01()
{
    Sonja_Equip(ItRw_Bow_M_01, Value_Kompositbogen);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Bow_M_04()
{
    Sonja_Equip(ItRw_Bow_M_04, Value_Buchenbogen);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRw_Crossbow_L_02()
{
    Sonja_Equip(ItRw_Crossbow_L_02, Value_LeichteArmbrust);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_Farmer ()
{
    Sonja_Bekleiden(ITAR_BauBabe_M, 200);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNGITAR_DJG_BABE ()
{
    Sonja_Bekleiden(ITAR_DJG_BABE, 2000);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_DJG_H()
{
    Sonja_Bekleiden(ITAR_DJG_H, VALUE_ITAR_DJG_H);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ITAR_KDW_H()
{
    Sonja_Bekleiden(ITAR_KDW_H, VALUE_ITAR_KDW_H);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_01()
{
    Sonja_Equip(ItRi_Prot_Total_01, Value_Ri_ProtTotal);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRi_Prot_Total_02()
{
    Sonja_Equip(ItRi_Prot_Total_02, Value_Ri_ProtTotal02);

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_InstantFireball()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 2)
    {
        Sonja_Equip(ItRu_InstantFireball, Value_Ru_InstantFireball);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_03"); //Ich muss erst den zweiten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_ArmyOfDarkness()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 6)
    {
        Sonja_Equip(ItRu_ArmyOfDarkness, Value_Ru_ArmyofDarkness);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich muss erst den sechsten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

func void DIA_Sonja_KLEIDUNG_ItRu_MassDeath()
{
    if (Npc_GetTalentSkill(self, NPC_TALENT_MAGE) >= 6)
    {
        Sonja_Equip(ItRu_MassDeath, Value_Ru_MassDeath);
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KLEIDUNG_16_04"); //Ich muss erst den sechsten Kreis der Magie erlernen.
    };

    DIA_Sonja_KLEIDUNG_Info();
};

///////////////////////////////////////////////////////////////////////
//	Info HELP
///////////////////////////////////////////////////////////////////////
instance DIA_Sonja_HELP		(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr          = 	99;
	condition	 = 	DIA_Sonja_HELP_Condition;
	information	 = 	DIA_Sonja_HELP_Info;
	permanent	 = 	TRUE;
	description	 = 	"(Erledigen)";
};

func int DIA_Sonja_HELP_Condition ()
{
	return SonjaFolgt == TRUE;
};

func void DIA_Sonja_HELP_Info ()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

    Info_AddChoice		(DIA_Sonja_HELP, "Sammle Gegenst�nde f�r mich ..."	,              DIA_Sonja_RESPAWN_ITEMS_Info);
    Info_AddChoice		(DIA_Sonja_HELP, "Rufe alle wilden Tiere herbei ..."	,          DIA_Sonja_RESPAWN_Info);
	Info_AddChoice		(DIA_Sonja_HELP, "Kannst du ein paar andere Frauen besorgen?"	,  DIA_Sonja_SUMMON_Info);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_HELP_BACK);
};

func void DIA_Sonja_HELP_BACK()
{
    Info_ClearChoices	(DIA_Sonja_HELP);
};

func void DIA_Sonja_SUMMON_Info ()
{
	AI_Output			(other, self, "DIA_Sonja_SUMMON_15_00"); //Kannst du ein paar andere Frauen besorgen?

	if (Wld_GetDay() - SonjaSummonDays >= 3)
	{
        AI_Output			(self, other, "DIA_Sonja_SUMMON_16_00"); //Ich kenne ein B�urin, die Interesse haben k�nnte. Aber nur damit du mit ihr mehr Gold verdienen kannst, verstanden?
        Wld_SpawnNpcRange	(self,	BAU_915_Baeuerin,	1,	500);
        SonjaSummonDays = Wld_GetDay();
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_SUMMON_16_01"); //Komm in ein paar Tagen noch mal zu mir. Alle drei Tage kann ich dir eine Frau beschaffen.
        B_LogEntry ("Sonja", "Sonja kann mir alle drei Tage eine neue Frau beschaffen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(3 + SonjaSummonDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    };

    DIA_Sonja_HELP_Info();
};


// RESPAWN

func void SonjaRespawnMonsterKhorinis ()
{
    Wld_InsertNpc 	(Gobbo_Skeleton, 	"FP_ROAM_MEDIUMFOREST_KAP2_24");
    Wld_InsertNpc 	(Skeleton, 			"FP_ROAM_MEDIUMFOREST_KAP2_22");
    Wld_InsertNpc 	(Lesser_Skeleton, 	"FP_ROAM_MEDIUMFOREST_KAP2_23");
    Wld_InsertNpc 	(Wolf, 			"FP_ROAM_MEDIUMFOREST_KAP2_25");
    Wld_InsertNpc 	(Wolf, 			"FP_ROAM_MEDIUMFOREST_KAP2_26");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_50");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_49");
    Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_10");
    Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_05");
    Wld_InsertNpc 	(Sheep, 			"NW_FARM3_MOUNTAINLAKE_05");
    Wld_InsertNpc 	(Sheep, 			"NW_FARM3_MOUNTAINLAKE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_05");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_06");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_04");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_04");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_11");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_72");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_72");
    Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_75");
    Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_PATH_22_MONSTER");
    Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_PATH_22_MONSTER");
    Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_62_02");
    Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_62_02");
    Wld_InsertNpc 	(Molerat, "FP_ROAM_CITY_TO_FOREST_41");
    Wld_InsertNpc 	(Scavenger, 			"NW_FOREST_CONNECT_MONSTER2");
    Wld_InsertNpc 	(Scavenger, 			"NW_FOREST_CONNECT_MONSTER2");
    Wld_InsertNpc 	(Wolf, 			"NW_SHRINE_MONSTER");
    Wld_InsertNpc 	(Wolf, 			"NW_SHRINE_MONSTER");
    Wld_InsertNpc 	(Giant_Bug, 			"NW_PATH_TO_MONASTER_AREA_01");
    Wld_InsertNpc 	(Giant_Bug, 			"NW_PATH_TO_MONASTER_AREA_01");
    Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_AREA_11");
    Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_MONSTER22");
    Wld_InsertNpc	(Giant_Bug, 	"NW_FARM1_CITYWALL_RIGHT_02");
    Wld_InsertNpc	(Wolf, "NW_FARM1_PATH_CITY_10_B");
    Wld_InsertNpc	(Wolf, "NW_FARM1_PATH_CITY_SHEEP_04");

    Wld_InsertNpc	(Giant_Bug,	"NW_FARM1_PATH_SPAWN_07");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_34");
    Wld_InsertNpc 	(Bloodfly, "FP_ROAM_CITY_TO_FOREST_36");

    Wld_InsertNpc 	(Scavenger,	"NW_TAVERNE_BIGFARM_MONSTER_01");
    Wld_InsertNpc 	(Scavenger,	"NW_TAVERNE_BIGFARM_MONSTER_01");

    Wld_InsertNpc 	(Lurker,	"NW_BIGFARM_LAKE_MONSTER_02_01");

    Wld_InsertNpc 	(Gobbo_Black, 		"NW_BIGFARM_LAKE_03_MOVEMENT");
    Wld_InsertNpc 	(Gobbo_Black, 		"NW_BIGFARM_LAKE_03_MOVEMENT");

    Wld_InsertNpc 	(Gobbo_Black,	"NW_TAVERNE_TROLLAREA_MONSTER_05_01");

    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
    Wld_InsertNpc 	(Gobbo_Green,	"NW_BIGFARM_LAKE_MONSTER_05_01");
};

func void SonjaRespawnTrolleKhorinis ()
{
    Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_08");
	Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_07");


	//----- Schwarzer Troll -----
	Wld_InsertNpc 	(Troll_Black, 			"NW_TROLLAREA_PATH_84");
};

func void SonjaRespawnShadowBeastsKhorinis ()
{
    Wld_InsertNpc		(Shadowbeast, "NW_FARM1_CITYWALL_FOREST_04_B");
    Wld_InsertNpc 	(Shadowbeast,	"NW_FARM4_WOOD_MONSTER_08");
    Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_MEDIUMFOREST_KAP3_20");
    Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_CITYFOREST_KAP3_04");
    Wld_InsertNpc 	(Shadowbeast, "NW_FOREST_PATH_35_06");
    Wld_InsertNpc 	(Shadowbeast, "NW_CITYFOREST_CAVE_A06");
    Wld_InsertNpc 	(Shadowbeast, 	"FP_ROAM_NW_TROLLAREA_RUINS_10");
    Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_02");
    Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_07");
};

FUNC VOID DIA_Sonja_RESPAWN_Choices()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

    Info_AddChoice		(DIA_Sonja_HELP, "Alle Schattenl�ufer in Khorinis"	,Sonja_RESPAWN_ShadowBeastsKhorinis);
    Info_AddChoice		(DIA_Sonja_HELP, "Alle Trolle in Khorinis"	,Sonja_RESPAWN_TrolleKhorinis);
	Info_AddChoice		(DIA_Sonja_HELP, "Alle Tiere in Khorinis"	,Sonja_RESPAWN_Khorinis);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_RESPAWN_BACK);
};

FUNC VOID DIA_Sonja_RESPAWN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei ...
    DIA_Sonja_RESPAWN_Choices();
};

func void DIA_Sonja_RESPAWN_BACK()
{
	DIA_Sonja_HELP_Info();
};

FUNC VOID Sonja_RESPAWN_Khorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnMonsterKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

FUNC VOID Sonja_RESPAWN_TrolleKhorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnTrolleKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

FUNC VOID Sonja_RESPAWN_ShadowBeastsKhorinis()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_15_00"); //Rufe alle wilden Tiere herbei.

    if (Wld_GetDay() - SonjaRespawnDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche alle wilden Tiere herbei rufen.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnShadowBeastsKhorinis();
        SonjaRespawnDays = 0;
    };

    DIA_Sonja_RESPAWN_Choices();
};

func void SonjaRespawnItemsHerb()
{
    CreateInvItems (self, ItPl_Temp_Herb, 10);
    CreateInvItems (self, ItPl_SwampHerb, 2);
    CreateInvItems (self, ItPl_Health_Herb_01, 5);
    CreateInvItems (self, ItPl_Health_Herb_02, 2);
    CreateInvItems (self, ItPl_Mana_Herb_01, 5);
    CreateInvItems (self, ItPl_Mushroom_01, 5);
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Choices()
{
    Info_ClearChoices	(DIA_Sonja_HELP);

	Info_AddChoice		(DIA_Sonja_HELP, "Sammle Kr�uter f�r mich."	,Sonja_RESPAWN_ITEMS_Herb);
	Info_AddChoice		(DIA_Sonja_HELP, DIALOG_BACK 		, DIA_Sonja_RESPAWN_ITEMS_BACK);
};

FUNC VOID DIA_Sonja_RESPAWN_ITEMS_Info()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_15_00"); //Sammle Gegenst�nde f�r mich ...
    DIA_Sonja_RESPAWN_ITEMS_Choices();
};

func void DIA_Sonja_RESPAWN_ITEMS_BACK()
{
	DIA_Sonja_HELP_Info();
};

FUNC VOID Sonja_RESPAWN_ITEMS_Herb()
{
    AI_Output			(other, self, "DIA_Sonja_RESPAWN_ITEMS_Herb_15_00"); //Sammle Kr�uter f�r mich.

    if (Wld_GetDay() - SonjaRespawnItemsDays < 7)
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_00"); //Das kann ich nur einmal in der Woche tun! Komm in ein paar Tagen wieder!
        B_LogEntry ("Sonja", "Sonja kann nur einmal in der Woche Gegenst�nde f�r mich sammeln.");

        var String msg;
        msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaRespawnDays - Wld_GetDay()));
        PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_RESPAWN_16_01"); //Gerne, mein Ehemann!
        SonjaRespawnItemsHerb();

        PrintScreen ("Neues im Handelsinventar von Sonja!", - 1, - 1, FONT_Screen, 2);

        SonjaRespawnItemsDays = 0;
    };

    DIA_Sonja_RESPAWN_ITEMS_Choices();
};

// ************************************************************
// 			  				KOCHEN
// ************************************************************
INSTANCE DIA_Sonja_KOCHEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_KOCHEN_Condition;
	information	= DIA_Sonja_KOCHEN_Info;
	permanent	= TRUE;
	description = "(Bekochen lassen)";
};

FUNC INT DIA_Sonja_KOCHEN_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_KOCHEN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_KOCHEN_15_00"); //Koch mir was!

    if (SonjaGeheiratet)
    {
        if (Wld_GetDay() - SonjaCookDays < 7)
        {
            AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_00"); //Ich koche nur jede Woche etwas f�r dich! Komm in ein paar Tagen wieder!
            B_LogEntry ("Sonja", "Sonja kocht f�r mich nur einmal in der Woche.");

            var String msg;
            msg = ConcatStrings("Verbleibende Tage: ", IntToString(7 + SonjaCookDays - Wld_GetDay()));
            PrintScreen (msg, - 1, - 1, FONT_ScreenSmall, 5); // 2
        }
        else
        {
            AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_01"); //Gerne, mein Ehemann!
            B_GiveInvItems (self, other, ItFo_XPStew, 1);
            SonjaCookDays = 0;
        };
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_KOCHEN_16_02"); //Koch dir doch selbst was! Ich bin nicht deine Frau!
    };
};

// ************************************************************
// 			  				ANGEBEN
// ************************************************************
var int SonjaAngebenLevel;

INSTANCE DIA_Sonja_ANGEBEN (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ANGEBEN_Condition;
	information	= DIA_Sonja_ANGEBEN_Info;
	permanent	= TRUE;
	description = "(Angeben)";
};

FUNC INT DIA_Sonja_ANGEBEN_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ANGEBEN_Info()
{
    AI_Output			(other, self, "DIA_Sonja_ANGEBEN_15_00"); //Schau mal wie viel Erfahrung ich gesammelt habe!

    if (other.level <= SonjaAngebenLevel)
    {
        AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_00"); //Ach, du Angeber! Du bist doch immer noch so wie beim letzten Mal!
        B_LogEntry ("Sonja", "Sonja ist unbeeindruckt von meiner Angeberei, wenn ich nicht wirklich mehr Erfahrung gesammelt habe.");
    }
    else
    {
        AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_01"); //Ja mein Prinz, du bist der Beste! Aus dir kann noch ein K�nig werden!
        B_LogEntry ("Sonja", "Sonja mag mich mit mehr Erfahrung lieber. Ich sollte Erfahrung sammeln.");
    };

    SonjaAngebenLevel = other.level;
};

// ************************************************************
// 			  				SCHEIDUNG
// ************************************************************

INSTANCE DIA_Sonja_SCHEIDUNG (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_SCHEIDUNG_Condition;
	information	= DIA_Sonja_SCHEIDUNG_Info;
	permanent	= TRUE;
	description = "Ich m�chte die Scheidung.";
};

FUNC INT DIA_Sonja_SCHEIDUNG_Condition()
{
	return SonjaFolgt == TRUE && SonjaGeheiratet == TRUE;
};

FUNC VOID DIA_Sonja_SCHEIDUNG_Info()
{
    AI_Output			(other, self, "DIA_Sonja_SCHEIDUNG_15_00"); //Ich m�chte die Scheidung.

     AI_Output			(self, other, "DIA_Sonja_ANGEBEN_16_00"); //Ber�hrt - gef�hrt! �berleg dir lieber mal deinen n�chsten Schachzug, damit wir zu mehr Gold kommen!
    B_LogEntry ("Sonja", "F�r Sonja kommt eine Scheidung nicht in Frage. Ich soll lieber mehr Gold verdienen.");
};

// ************************************************************
// 			  				ADVICE
// ************************************************************

INSTANCE DIA_Sonja_ADVICE (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_ADVICE_Condition;
	information	= DIA_Sonja_ADVICE_Info;
	permanent	= TRUE;
	description = "Was soll ich als N�chstes tun?";
};

FUNC INT DIA_Sonja_ADVICE_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_ADVICE_Info()
{
    AI_Output			(other, self, "DIA_Sonja_ADVICE_15_00"); //Was soll ich als N�chstes tun?

    if (Kapitel == 1)
    {
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_03"); //Geh zu Lord Hagen und hol dir das Auge Innos.
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
    else if (Kapitel == 2)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_04"); //Geh ins Minental und hole dir alle Informationen f�r Lord Hagen.
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 3)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_05"); //K�mmere dich um das Auge Innos.
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 4)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_06"); //Sprich mit den Drachen und mache sie fertig!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
	}
	else if (Kapitel == 5)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_07"); //Besorg dir die Informationen im Kloster und weiter geht's!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
    else if (Kapitel == 6)
	{
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_08"); //Vernichte die Diener Beliars!
		AI_Output			(self, other, "DIA_Sonja_ADVICE_16_02"); //Du redest doch immer im Schlaf davon.
    }
	else
	{
        AI_Output			(self, other, "DIA_Sonja_ADVICE_16_00"); //Ich wei� es nicht.
        B_LogEntry ("Sonja", "Sonja wei� auch nicht, was ich tun soll.");
	};
};

// ************************************************************
// 			  				Buy Hans
// ************************************************************
var int Sonja_Meatbugekauft;
var int HansIsDeadSaid;

instance DIA_Sonja_BuyLHans	(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	8;
	condition	 = 	DIA_Sonja_BuyHans_Condition;
	information	 = 	DIA_Sonja_BuyHans_Info;
	permanent	 = 	TRUE;
	description	 = 	"Hier sind 100 Goldst�cke. Gib mir eine Fleischwanze.";
};
func int DIA_Sonja_BuyHans_Condition ()
{
	return SonjaFolgt == TRUE;
};
func void DIA_Sonja_BuyHans_Info ()
{
	AI_Output (other, self, "DIA_Sonja_BuyHans_15_00"); //Hier sind 100 Goldst�cke. Gib mir eine Fleischwanze.

	if (B_GiveInvItems  (other, self, ItMi_Gold, 100))
	{
		if (Sonja_Meatbugekauft == 0)
		{
            B_LogEntry ("Sonja", "Bei Sonja kann ich eine Fleischwanze kaufen, damit wir ein gemeinsames Haustier haben.");

			AI_Output (self, other, "DIA_Sonja_BuyHans_03_01"); //Gut. Dann nimm dir Hans mit.
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_02"); //Sag ihm einfach, er soll dir folgen. Er ist ziemlich klug f�r eine Fleischwanze. Behandele ihn gut!
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_03"); //Endlich haben wir ein gemeinsames Haustier!
		}
		else
		{
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_03"); //Schon wieder? Na sch�n. Nimm dir die Hans mit.
			AI_Output (other, self, "DIA_Sonja_BuyHans_15_04"); //Hans? Die letzte Fleischwanze hie� schon Hans ...
			AI_Output (self, other, "DIA_Sonja_BuyHans_03_05"); //Ja und wer wei� was du mit der vor hattest? Mein Haustier hei�t immer Hans und jetzt pass besser auf ihn auf als das letzte Mal!
		};

		Sonja_Meatbugekauft = Sonja_Meatbugekauft + 1;
		Wld_SpawnNpcRange	(self,	Follow_Meatbug,	1,	500);
        Hans			= Hlp_GetNpc (Follow_Meatbug);
        HansIsDeadSaid = FALSE;

		AI_StopProcessInfos (self);
	}
	else
	{
		AI_Output (self, other, "DIA_Sonja_BuyHans_03_09"); //Soviel Gold hast du nicht. Billiger kann ich dir keins geben.
	};
};

// ************************************************************
// 			  				Hans is dead
// ************************************************************
instance DIA_Sonja_HansIsDead	(C_INFO)
{
	npc			 = 	VLK_436_Sonja;
	nr			 = 	8;
	condition	 = 	DIA_Sonja_HansIsDead_Condition;
	information	 = 	DIA_Sonja_HansIsDead_Info;
	permanent	 = 	TRUE;
	important    =  TRUE;
};
func int DIA_Sonja_HansIsDead_Condition ()
{
	return SonjaFolgt == TRUE && Sonja_Meatbugekauft > 0 && Npc_IsDead(Hans) && HansIsDeadSaid == FALSE;
};
func void DIA_Sonja_HansIsDead_Info ()
{
    HansIsDeadSaid = TRUE;
	AI_Output (self, other, "DIA_Sonja_HansIsDead_16_00"); //Was hast du getan? Hans ist gestorben! Du hast nicht gut genug auf ihn aufgepasst! Ich hasse dich!
	AI_Output (self, other, "DIA_Sonja_HansIsDead_16_01"); //Kauf mir ein neues Haustier!
	B_LogEntry ("Sonja", "Sonja will, dass ich uns ein neues Haustier kaufe und dies mal besser darauf aufpasse.");
};

// ************************************************************
// 			  				SLEEP
// ************************************************************

INSTANCE DIA_Sonja_SLEEP (C_INFO)
{
	npc			= VLK_436_Sonja;
	nr			= 900;
	condition	= DIA_Sonja_SLEEP_Condition;
	information	= DIA_Sonja_SLEEP_Info;
	permanent	= TRUE;
	description = "(Schlafen)";
};

FUNC INT DIA_Sonja_SLEEP_Condition()
{
	return SonjaFolgt == TRUE;
};

FUNC VOID DIA_Sonja_SLEEP_Info()
{
	Info_ClearChoices	(DIA_Sonja_SLEEP);

	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis Mitternacht schlafen"	,Sonja_SleepTime_Midnight_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum n�chsten Abend schlafen"	,Sonja_SleepTime_Evening_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis Mittags schlafen"	,Sonja_SleepTime_Noon_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, "Bis zum n�chsten Morgen schlafen"	,Sonja_SleepTime_Morning_Info);
	Info_AddChoice		(DIA_Sonja_SLEEP, DIALOG_BACK 		, DIA_Sonja_SLEEP_BACK);
};

func void DIA_Sonja_SLEEP_BACK()
{
	Info_ClearChoices (DIA_Sonja_SLEEP);
};

//---------------------- morgens --------------------------------------

func void Sonja_SleepTime_Morning_Info ()
{
	PC_Sleep (8);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//--------------------- mittags -----------------------------------------

func void Sonja_SleepTime_Noon_Info ()
{
	PC_Sleep (12);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//---------------------- abend --------------------------------------

func void Sonja_SleepTime_Evening_Info ()
{
	PC_Sleep (20);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};

//------------------------ nacht -----------------------------------------

func VOID Sonja_SleepTime_Midnight_Info()
{
	PC_Sleep (0);
	self.aivar[AIV_PARTYMEMBER] = FALSE;
	self.flags = NPC_FLAG_IMMORTAL;

	AI_StopProcessInfos	(self);

	Npc_ExchangeRoutine	(self,"WAIT");
};








//****************************
//	Firedragon Prototype		
//****************************

PROTOTYPE Mst_Default_Dragon_Sonja(C_Npc)
{
	name							= "Beschworener Drache";
	guild							= GIL_DRAGON;
	aivar[AIV_MM_REAL_ID]			= ID_DRAGON_FIRE;
	level							= 500;
	
	bodyStateInterruptableOverride = TRUE;
	
	//----- Attribute ----	
	attribute	[ATR_STRENGTH]		=	200;
	attribute	[ATR_DEXTERITY]		=	200;
	attribute	[ATR_HITPOINTS_MAX]	=	1000;
	attribute	[ATR_HITPOINTS]		=	1000;
	attribute	[ATR_MANA_MAX] 		=	1000;
	attribute	[ATR_MANA] 			=	1000;
	
	//------ Protections ----	
	protection	[PROT_BLUNT]		=	170;
	protection	[PROT_EDGE]			=	170;
	protection	[PROT_POINT]		=	170;	
	protection	[PROT_FIRE]			=	170;
	protection	[PROT_FLY]			=	170;	
	protection	[PROT_MAGIC]		=	170;
	
	//------ Damage Types ----	
	damagetype 						=	DAM_FIRE|DAM_FLY;
//	damage		[DAM_INDEX_BLUNT]	=	0;
//	damage		[DAM_INDEX_EDGE]	=	0;
//	damage		[DAM_INDEX_POINT]	=	0;
	damage		[DAM_INDEX_FIRE]	=	149;
	damage		[DAM_INDEX_FLY]		=	1; //Opfer fliegt f�r Fire+Fly
//	damage		[DAM_INDEX_MAGIC]	=	0;

	//----- Kampf-Taktik ----	
	fight_tactic	=	FAI_DRAGON;
	
	//----- Sense & Ranges ----	
	senses			=	SENSE_HEAR | SENSE_SEE | SENSE_SMELL;
	senses_range	=	PERC_DIST_DRAGON_ACTIVE_MAX;

	aivar[AIV_MM_FollowTime]	= FOLLOWTIME_MEDIUM;
	aivar[AIV_MM_FollowInWater] = FALSE;

	//aivar[AIV_MaxDistToWp]		= 700;
	aivar[AIV_OriginalFightTactic] 	= FAI_DRAGON;
	
	//----- Daily Routine ----
	start_aistate				= ZS_MM_Rtn_DragonRest;

	aivar[AIV_MM_RestStart] 	= OnlyRoutine;
};

//*****************
//	Firedragon
//*****************

INSTANCE Dragon_Sonja	(Mst_Default_Dragon_Sonja)
{
	//flags				= 	NPC_FLAG_IMMORTAL;
	B_SetVisuals_Dragon_Fire();
	Npc_SetToFistMode(self);
};
//*************************
//	Meatbug Prototype
//*************************

PROTOTYPE Mst_Default_Meatbug(C_Npc)			
{
	//----- Monster ----
	name							=	"Fleischwanze";
	guild							=	GIL_MEATBUG;
	aivar[AIV_MM_REAL_ID]			= 	ID_MEATBUG;
	level							=	1;
	
	//----- Attribute ----
	attribute	[ATR_STRENGTH]		=	1;
	attribute	[ATR_DEXTERITY]		=	1;
	attribute	[ATR_HITPOINTS_MAX]	=	10;
	attribute	[ATR_HITPOINTS]		=	10;
	attribute	[ATR_MANA_MAX] 		=	0;
	attribute	[ATR_MANA] 			=	0;
	
	//----- Protections ----
	protection	[PROT_BLUNT]		=	0;
	protection	[PROT_EDGE]			=	0;
	protection	[PROT_POINT]		=	0;
	protection	[PROT_FIRE]			=	0;
	protection	[PROT_FLY]			=	0;
	protection	[PROT_MAGIC]		=	0;
	
	//----- Damage Types ----
	damagetype 						= 	DAM_EDGE;
	
	//----- Kampf-Taktik ----
//	fight_tactic					= ;		// k�mpfen nicht!

	//----- Senses & Ranges ----
	Senses			= 	SENSE_SMELL;
	senses_range	=	PERC_DIST_MONSTER_ACTIVE_MAX;
	
	aivar[AIV_MM_FollowInWater] = FALSE;

	//----- Daily Routine ----
	start_aistate					= ZS_MM_AllScheduler;
		
	aivar[AIV_MM_WuselStart] 		= OnlyRoutine;
};


//***********
//	Visuals
//***********

func void B_SetVisuals_Meatbug()
{
	Mdl_SetVisual			(self,	"Meatbug.mds");
	//								Body-Mesh		Body-Tex	Skin-Color	Head-MMS	Head-Tex	Teeth-Tex	ARMOR
	Mdl_SetVisualBody		(self,	"Mbg_Body",		DEFAULT,	DEFAULT,	"",			DEFAULT,  	DEFAULT,	-1);

};


//***************
//	Meatbug    	
//***************

INSTANCE Meatbug	(Mst_Default_Meatbug)
{
	B_SetVisuals_Meatbug();
};


//***************
//	Follow_Meatbug
//***************

INSTANCE Follow_Meatbug	(Mst_Default_Meatbug)
{
	name						= "Hans";

	aivar[AIV_ToughGuy] = TRUE; //Hans kann get�tet werden, ohne da� jemand sich anpi�t!

	B_SetVisuals_Meatbug();
	Npc_SetToFistMode(self);
	aivar[AIV_MM_RoamStart]		= OnlyRoutine;

	start_aistate				= ZS_MM_Rtn_Follow_Sheep;
	CreateInvItems (self, ItFoMuttonRaw, 1);
};



//******************************
// Mission Meatbugs Kapitel 4
//******************************

//***************
//	Meatbug_Brutus1    	
//***************
INSTANCE Meatbug_Brutus1	(Mst_Default_Meatbug)
{
	B_SetVisuals_Meatbug();
};
//***************
//	Meatbug_Brutus2   	
//***************

INSTANCE Meatbug_Brutus2	(Mst_Default_Meatbug)
{
	B_SetVisuals_Meatbug();
};
//***************
//	Meatbug_Brutus3    	
//***************

INSTANCE Meatbug_Brutus3	(Mst_Default_Meatbug)
{
	B_SetVisuals_Meatbug();
};
//***************
//	Meatbug_Brutus4    	
//***************

INSTANCE Meatbug_Brutus4	(Mst_Default_Meatbug)
{
	B_SetVisuals_Meatbug();
};

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
 //*******************************
 //			NPC Globals
 //*******************************
 
 //--------------------------ADDON--------------------------------------------
var C_NPC Raven;
var C_NPC Tom;
var C_NPC Logan;
var C_NPC Ramon;

var C_NPC BanditGuard;
var C_NPC Lehmar;

var C_NPC Franco;
var C_NPC Paul;
var C_NPC Lennar;
var C_NPC Esteban;
var C_NPC Carlos;
var C_NPC Finn;
var C_NPC Fisk;
var C_NPC Thorus;
var C_NPC Bloodwyn;
var C_NPC Freund;
var C_NPC Skinner;
var C_NPC Juan;
var C_NPC Senyan;
var C_NPC Fortuno;

var C_NPC Wache_01;
var C_NPC Wache_02;
var C_NPC Torwache2;
var C_NPC PrisonGuard;

var C_NPC Buddler_1;
var C_NPC Buddler_2;
var C_NPC Buddler_3;

//Gefangene Addonworld
var C_NPC Patrick;
var C_NPC Tonak;
var C_NPC Telbor;
var C_NPC Monty;
var C_NPC Pardos;

var C_NPC Patrick_NW;
var C_NPC Tonak_NW;
var C_NPC Telbor_NW;
var C_NPC Monty_NW;
var C_NPC Pardos_NW;



var C_NPC Cavalorn;
var C_NPC Greg_NW;
var C_NPC Skip_NW;
var C_NPC Erol;

var C_NPC Martin;
var C_NPC Gaan;
var C_NPC Farim;
var C_NPC Elvrich;
  
var C_NPC Morgan; 
var C_NPC AlligatorJack;	
var C_NPC Francis;
var C_NPC Henry;	
var C_NPC Bill;
var C_NPC Garett;
var C_NPC Samuel;
var C_NPC Angus;
var C_NPC Greg;
var C_NPC Malcom;
var C_NPC Owen;
//Gregs Trupp
var C_NPC Skip;
var C_NPC Brandon;
var C_NPC Matt;
var C_NPC RoastPirate;
var C_NPC BenchPirate;
//Henrys M�nner
var C_NPC SawPirate;
var C_NPC HammerPirate;


var C_NPC Merdarion_NW;
var C_NPC Riordian_NW;
var C_NPC Myxir_NW;
var C_NPC Nefarius_NW;
var C_NPC Cronos_ADW;
var C_NPC Cronos_NW;
var C_NPC Saturas_NW;
var C_NPC Myxir_ADW;
var C_NPC Myxir_CITY;

var C_NPC Quarhodron; 


var C_NPC Dexter;

//---------------------------------------------------------------------
// Haie 
//---------------------------------------------------------------------
var C_NPC  Sumpfi_01; 
var C_NPC  Sumpfi_02; 
var C_NPC  Sumpfi_03; 


 //--------------------------GOTHIC 2--------------------------------------------
 
 //Die 4 Freunde

  var C_NPC GornOW;
  var C_NPC GornDJG;
  var C_NPC GornNW_vor_DJG;
  var C_NPC GornNW_nach_DJG;
  var C_NPC Gorn_DI;
  var C_NPC Lester;
  var C_NPC Lester_DI;
  var C_NPC MiltenNW;
  var C_NPC Milten_DI;
  	
  var C_NPC DiegoOW;
  var C_NPC DiegoNW;	
  var C_NPC Diego_DI;	

 //----------NewWorld-------------
  var C_NPC Sonja;

  var C_NPC Xardas;
  var C_NPC Pyrokar;
  
  var C_NPC Ambusher_1013;
  var C_NPC Ambusher_1014;
  var C_NPC Ambusher_1015;
  
  var C_NPC Vino;
  var C_NPC Lobart;
  var C_NPC LobartsBauer1;  
  var C_NPC LobartsBauer2;  
  var C_NPC Hilda;  
  var C_NPC	Borka;
  var C_NPC	Stadtwache_310;
  var C_NPC	Stadtwache_333;
  var C_NPC	Schiffswache_212;
  var C_NPC	Schiffswache_213;
  var C_NPC	Torwache_305;
  var C_NPC Lagerwache; 
  var C_NPC Halvor; 
  var C_NPC Attila; 
  var C_NPC Brahim; 
  var C_Npc Nadja;
  var C_NPC Vanja;
  var C_Npc Moe;
  var C_Npc Valentino;
  var C_Npc Sagitta;		
  var C_Npc BDTWache;
  
  var C_NPC Karras;
  var C_NPC Gorax;
  var C_NPC Rengaru;
  var C_NPC Sarah;
  var C_NPC Canthar;
  var C_NPC Andre;
  var C_NPC Lothar;
  var C_NPC Girion;
  var C_NPC Girion_DI;
  var C_NPC Salandril;
  var C_NPC Cornelius;
  var C_NPC Bartok;
  var C_NPC CityOrc;
  var C_NPC Gritta;
  var C_NPC Richter;
  var C_NPC LordHagen;
  var C_NPC Albrecht;
  var C_NPC Ingmar;
  var C_NPC	Fellan;
  var C_NPC	Bromor;
  var C_NPC	Fernando;
  var C_NPC	Wulfgar;
  var C_NPC	Mario;
  var C_NPC	Mario_DI;
  var C_NPC	Ignaz;
  var C_NPC Constantino;
  var C_NPC Thorben;
  var C_NPC Bosper;
  var C_NPC Matteo;
  var C_NPC Jack;
  var C_NPC	Jack_DI;
  var C_NPC	Jorgen_DI;
  var C_NPC Peck;
  
  var C_NPC Cassia;
  var C_NPC Jesper;
  var C_NPC Ramirez;
  var C_NPC	Nagur;
  var C_NPC Rangar;
  
  var C_NPC Bronko;
  var C_NPC Sekob;
  var C_NPC Rosi;
  var C_NPC Till;
  var C_NPC Balthasar; 
  var C_NPC BalthasarSheep1; 
  var C_NPC BalthasarSheep2; 
  var C_NPC BalthasarSheep3;
  var C_NPC Rumbold;
  var C_NPC Rick;
  var C_NPC Bengar;
  var C_NPC Malak;
  var C_NPC Egill;
  var C_NPC Ehnim;
  var C_NPC Engardo;
  var C_NPC Alvares;
  var C_NPC Kati;
  var C_NPC Akil;
  var C_NPC Orlan;
  var C_NPC Rukhar;
  var C_NPC Randolph;
  var C_NPC Pedro;
  var C_NPC	Lares;
  var C_NPC	Vatras;
  var C_NPC Pablo;
  var C_NPC Nov607;
  
  var C_NPC Magic_Golem;
  var C_Npc Liesel;
  var C_Npc Hans;
  var C_Npc Igaraz;
  var C_Npc Agon; 
  var C_Npc	Opolos;
  var C_Npc Babo;
  var C_Npc Dyrian; 
  var C_NPC Feger1;
  var C_NPC Feger2;
  var C_NPC Feger3;
  var C_NPC Isgaroth;
  var C_NPC Sergio;	
  var C_NPC Ulf;
  var C_NPC Wolfi;
  
  var C_NPC Fed;
  var C_NPC Kervo;
  var C_NPC Geppert;
  
  var C_NPC	Bote;
  var C_NPC Jorgen;
  var C_NPC LeuchtturmBandit_1021;
  var C_NPC LeuchtturmBandit_1022;
  var C_NPC LeuchtturmBandit_1023;
  var C_NPC Brian;
  var C_NPC Harad;
  var C_Npc Gerbrandt;
  var C_NPC GerbrandtsFrau;
  var C_Npc Morgahard;
  var C_Npc Tengron;
  var C_Npc Engor;
  
 //----------Banditen-------------
  var C_Npc Bandit_1;
  var C_Npc Bandit_2; 
  var C_Npc Bandit_3;  

 //----------OldWorld-------------
 
 var C_NPC Koch;
 var C_NPC Bruder;
 var C_NPC VLK_Leiche1;
 var C_NPC VLK_Leiche2;
 var C_NPC VLK_Leiche3;
 var C_NPC STRF_Leiche1;
 var C_NPC STRF_Leiche2;
 var C_NPC STRF_Leiche3;
 var C_NPC STRF_Leiche4;
 var C_NPC STRF_Leiche5;
 var C_NPC STRF_Leiche6;
 var C_NPC STRF_Leiche7;
 var C_NPC STRF_Leiche8;
 var C_NPC PAL_Leiche1;
 var C_NPC PAL_Leiche2;
 var C_NPC PAL_Leiche3;
 var C_NPC PAL_Leiche4;
 var C_NPC PAL_Leiche5;
 var C_NPC Olav;
 
 
 var C_NPC Marcos_Guard1;
 var C_NPC Marcos_Guard2;
 
 var C_NPC Jergan;
 var C_NPC Parlaf;
 
 var C_NPC Garond;
 var C_NPC Oric;
 var C_NPC Parcival;
 var C_NPC DJG_Sylvio;
 var C_NPC DJG_Bullco;
 var C_NPC DJG_Cipher;
 var C_NPC DJG_Rod;
 var C_NPC DJG_Angar;
 var C_NPC Angar_NW;
 var C_NPC Angar_DI;

 var C_NPC Kurgan;
 var C_NPC Kjorn;
 var C_NPC Godar;
 var C_NPC Hokurn;
 var C_NPC Biff;
 var C_NPC Biff_NW;
 var C_NPC Biff_DI;
 
 var C_NPC Fajeth;
 var C_NPC Bilgot;
 var C_NPC Brutus;
 var C_NPC Rethon;
 var C_NPC Ferros;
 var C_NPC Jan;
 var C_NPC Hosh_Pak;
 var C_NPC Urshak;
 var C_NPC Sengrath;
 var C_NPC HaupttorWache_4143;
 var C_NPC Engrom;


 //---DMT---
 
 var C_NPC DMT_1200;
 var C_NPC DMT_1201;
 var C_NPC DMT_1202;
 var C_NPC DMT_1203;
 var C_NPC DMT_1204;
 var C_NPC DMT_1205;
 var C_NPC DMT_1206;
 var C_NPC DMT_1207;
 var C_NPC DMT_1208;
 var C_NPC DMT_1209;
 var C_NPC DMT_1210;
 var C_NPC DMT_1211;
 var C_NPC DMT_Vino1;
 var C_NPC DMT_Vino2;
 var C_NPC DMT_Vino3;
 var C_NPC DMT_Vino4;
 
 //---Drachen---
 
 var C_NPC SwampDragon; 
 var C_NPC RockDragon; 
 var C_NPC FireDragon; 
 var C_NPC IceDragon; 
 var C_NPC UndeadDragon; 
 var C_NPC FireDragonIsland; 
 
 //---DragonIsland---
 
 var C_NPC Pedro_DI; 
 var C_NPC Keymaster_DI;
 var C_NPC Archol;
 
//---S�ldner---
var C_NPC Lee;
var C_NPC Lee_DI;
var C_NPC Torlof;
var C_NPC Torlof_DI;
var C_NPC Buster;
var C_NPC Cipher; 	
var C_NPC Rod;		
var C_NPC Cord;		
var C_NPC Sylvio;
var C_NPC Bullco;	
var C_NPC Jarvis;	
var C_NPC Hodges;
var C_NPC Bennet;
var C_NPC Bennet_DI;
var C_NPC Dar;
var C_NPC SLD_Wolf; 
var C_NPC Sentenza;
var C_NPC Fester;	
var C_NPC Raoul;	

//-------------
var C_NPC Onar;
var C_NPC Bodo;
var C_NPC Pepe;

// --------------
var C_NPC Garwig;


//*******************************************************
//			NPC Globals f�llen
//*******************************************************
 
func void  B_InitNpcGlobals ()
{
 	// **********************
 	if (Kapitel == 0)
	{
		Kapitel = 1; //HACK - wenn man mal wieder Xardas nicht anquatscht...
	};
	// **********************
 	 	
 	//--------------------------ADDON--------------------------------------------
 	Raven 			= Hlp_GetNpc (BDT_1090_Addon_Raven);
 	Tom 			= Hlp_GetNpc (BDT_1080_Addon_Tom);
 	Logan			= Hlp_GetNpc (BDT_1072_Addon_Logan);
 	Ramon			= Hlp_GetNpc (BDT_1071_Addon_Ramon);
 	
 	BanditGuard 	= Hlp_GetNpc (BDT_1064_Bandit_L);
 	Lehmar 			= Hlp_GetNpc (VLK_484_Lehmar);
 	
 	Franco 			= Hlp_GetNpc (BDT_1093_Addon_Franco);
 	Paul			= Hlp_GetNpc (BDT_1070_Addon_Paul);
 	Esteban			= Hlp_GetNpc (BDT_1083_Addon_Esteban);			
 	Lennar			= Hlp_GetNpc (BDT_1096_Addon_Lennar);
 	Carlos			= Hlp_GetNpc (BDT_1079_Addon_Carlos);
 	Fisk		 	= Hlp_GetNpc (BDT_1097_Addon_Fisk);
 	Thorus		 	= Hlp_GetNpc (BDT_10014_Addon_Thorus);
 	Bloodwyn		= Hlp_GetNpc (BDT_1085_Addon_Bloodwyn);
 	Freund			= Hlp_GetNpc (BDT_10016_Addon_Bandit);
 	Skinner			= Hlp_GetNpc (BDT_1082_Addon_Skinner);
 	Juan			= Hlp_GetNpc (BDT_10017_Addon_Juan);
 	Senyan			= Hlp_GetNpc (BDT_1084_Addon_Senyan);
 	Fortuno			= Hlp_GetNpc (BDT_1075_Addon_Fortuno);
 	
 	Finn			= Hlp_GetNpc (BDT_10004_Addon_Finn);
 	Wache_02		= Hlp_GetNpc (BDT_10005_Addon_Wache_02);
 	Wache_01    	= Hlp_GetNpc (BDT_1081_Addon_Wache_01);
 	Torwache2		= Hlp_GetNpc (BDT_1088_Addon_Torwache);
 	PrisonGuard		= Hlp_GetNpc (BDT_10023_Addon_Wache);
 	Buddler_1		= Hlp_GetNpc (BDT_10027_Addon_Buddler);
 	Buddler_2		= Hlp_GetNpc (BDT_10028_Addon_Buddler);
 	Buddler_3		= Hlp_GetNpc (BDT_10029_Addon_Buddler);
 	
 	//gefangene Addonworld
 	Patrick			= Hlp_GetNpc (STRF_1118_Addon_Patrick);
 	Tonak			= Hlp_GetNpc (STRF_1120_Addon_Tonak);
 	Telbor			= Hlp_GetNpc (STRF_1121_Addon_Telbor);
 	Monty			= Hlp_GetNpc (STRF_1119_Addon_Monty);
 	Pardos			= Hlp_GetNpc (STRF_1122_Addon_Pardos);
 	
 	Patrick_NW 		= Hlp_GetNpc (STRF_1123_Addon_Patrick_NW);
 	Monty_NW 		= Hlp_GetNpc (STRF_1124_Addon_Monty_NW);
 	Tonak_NW 		= Hlp_GetNpc (STRF_1125_Addon_Tonak_NW);
 	Telbor_NW 		= Hlp_GetNpc (STRF_1126_Addon_Telbor_NW);
 	Pardos_NW 		= Hlp_GetNpc (STRF_1127_Addon_Pardos_NW);
 	
 	
 	Cavalorn 		= Hlp_GetNpc (BAU_4300_Addon_Cavalorn);
 	Greg_NW 		= Hlp_GetNpc (PIR_1300_Addon_Greg_NW);
 	Skip_NW 		= Hlp_GetNpc (PIR_1301_Addon_Skip_NW);
 	Erol 			= Hlp_GetNpc (VLK_4303_Addon_Erol);

	Martin			= Hlp_GetNpc (Mil_350_Addon_Martin);	
	Gaan			= Hlp_GetNpc (BAU_961_Gaan);				
	Farim			= Hlp_GetNpc (VLK_4301_Addon_Farim);				
	Elvrich			= Hlp_GetNpc (VLK_4302_Addon_Elvrich);				
  	
  	Morgan			= Hlp_GetNpc (PIR_1353_Addon_Morgan);
  	Samuel			= Hlp_GetNpc (PIR_1351_Addon_Samuel);
  	Henry			= Hlp_GetNpc (PIR_1354_Addon_Henry);
  	AlligatorJack	= Hlp_GetNpc (PIR_1352_Addon_AlligatorJack);
  	Bill			= Hlp_GetNpc (PIR_1356_Addon_Bill);
  	Garett			= Hlp_GetNpc (PIR_1357_Addon_Garett);
  	Francis			= Hlp_GetNpc (PIR_1350_Addon_Francis);	
  	Angus			= Hlp_GetNpc (PIR_1370_Addon_Angus);
  	Greg			= Hlp_GetNpc (PIR_1320_Addon_Greg);
  	Malcom			= Hlp_GetNpc (PIR_1368_Addon_Malcom);
  	Owen			= Hlp_GetNpc (PIR_1367_Addon_Owen);
  	

	//-------------------------------------------------
	Skip			= Hlp_GetNpc (PIR_1355_Addon_Skip);
	Matt			= Hlp_GetNpc (PIR_1365_Addon_Matt);
	Brandon			= Hlp_GetNpc (PIR_1366_Addon_Brandon);
	RoastPirate		= Hlp_GetNpc (PIR_1364_Addon_Pirat);
	BenchPirate		= Hlp_GetNpc (PIR_1363_Addon_PIRAT);
	//-------------------------------------------------
	SawPirate		= Hlp_GetNpc (PIR_1361_Addon_PIRAT);
	HammerPirate	= Hlp_GetNpc (PIR_1360_Addon_PIRAT);
	//-------------------------------------------------

	
  	
  	Saturas_NW		= Hlp_GetNpc (KDW_1400_Addon_Saturas_NW);	
  	Nefarius_NW		= Hlp_GetNpc (KDW_1402_Addon_Nefarius_NW);	
  	Cronos_ADW		= Hlp_GetNpc (KDW_14010_Addon_Cronos_ADW);
  	Cronos_NW		= Hlp_GetNpc (KDW_1401_Addon_Cronos_NW);
  	Myxir_ADW		= Hlp_GetNpc (KDW_14030_Addon_Myxir_ADW);	
  	Myxir_CITY		= Hlp_GetNpc (KDW_140300_Addon_Myxir_CITY);	
	Myxir_NW		= Hlp_GetNpc (KDW_1403_Addon_Myxir_NW);	
	Riordian_NW		= Hlp_GetNpc (KDW_1404_Addon_Riordian_NW);	
	Merdarion_NW	= Hlp_GetNpc (KDW_1405_Addon_Merdarion_NW);	
	
	Quarhodron 		= Hlp_GetNpc (NONE_ADDON_111_Quarhodron); 
  
  	Dexter			= Hlp_GetNpc (BDT_1060_Dexter);	
 	
 	Sumpfi_01		= Hlp_GetNpc (MIS_Addon_Swampshark_01); 
	Sumpfi_02		= Hlp_GetNpc (MIS_Addon_Swampshark_02); 
	Sumpfi_03 		= Hlp_GetNpc (MIS_Addon_Swampshark_03); 

 	//--------------------------GOTHIC 2--------------------------------------------
 	
 	
 	Garwig			= Hlp_GetNpc(Nov_608_Garwig);
 
 //Die 4 Freunde
	GornOW			= Hlp_GetNpc(PC_Fighter_OW);
	GornNW_vor_DJG	= Hlp_GetNpc(PC_Fighter_NW_vor_DJG);
	GornDJG			= Hlp_GetNpc(PC_Fighter_DJG);
	GornNW_nach_DJG	= Hlp_GetNpc(PC_Fighter_NW_nach_DJG);
	Gorn_DI			= Hlp_GetNpc(PC_Fighter_DI);
 	
 	Lester			= Hlp_GetNpc(PC_Psionic);
 	Lester_DI		= Hlp_GetNpc(PC_Psionic_DI);
 	
 	MiltenNW		= Hlp_GetNpc (PC_Mage_NW);
 	Milten_DI		= Hlp_GetNpc (PC_Mage_DI);
 
 	DiegoOW			= Hlp_GetNpc (PC_ThiefOW);
 	DiegoNW			= Hlp_GetNpc (PC_Thief_NW);
 	Diego_DI		= Hlp_GetNpc (PC_Thief_DI);
	
	
// ------ Banditen vom Gamestart
	Ambusher_1013	= Hlp_GetNpc (Bdt_1013_Bandit_L);
	Ambusher_1014	= Hlp_GetNpc (Bdt_1014_Bandit_L);
	Ambusher_1015	= Hlp_GetNpc (Bdt_1015_Bandit_L);
 
 //----NewWorld----
    Sonja			= Hlp_GetNpc (VLK_436_Sonja);

    if (Hlp_IsValidNpc(Sonja))
    {
        if (CurrentLevel == OLDWORLD_ZEN)
        {
            Npc_ExchangeRoutine	(Sonja,"STARTOLDWORLD");
        }
        else if (CurrentLevel == NEWWORLD_ZEN)
        {
            Npc_ExchangeRoutine	(Sonja,"START");
        }
        else if (CurrentLevel == ADDONWORLD_ZEN)
        {
            Npc_ExchangeRoutine	(Sonja,"STARTADDONWORLD");
        }
        else if (CurrentLevel == DRAGONISLAND_ZEN)
        {
            Npc_ExchangeRoutine	(Sonja,"STARTDRAGONISLAND");
        };
    };

	Xardas 			= Hlp_GetNpc (NONE_100_Xardas);
	Pyrokar 		= Hlp_GetNpc (KDF_500_Pyrokar);


	Lee 			= Hlp_GetNpc (SLD_800_Lee);
	Lee_DI 			= Hlp_GetNpc (SLD_800_Lee_DI);
	
	Vatras			= Hlp_GetNpc (VLK_439_Vatras);
	Pablo			= Hlp_GetNpc (MIL_319_Pablo);
	NOV607			= Hlp_GetNpc (NOV_607_Novize);
	Lares			= Hlp_GetNpc (VLK_449_Lares);
	Vino			= Hlp_GetNpc(BAU_952_Vino);
 	Lobart			= Hlp_GetNpc(BAU_950_Lobart);
  	LobartsBauer1	= Hlp_GetNpc(BAU_955_Bauer);
  	LobartsBauer2	= Hlp_GetNpc(BAU_953_Bauer);
  	Hilda			= Hlp_GetNpc(BAU_951_Hilda);
	Borka			= Hlp_GetNpc(VLK_434_Borka);
	Stadtwache_310	= Hlp_GetNpc(Mil_310_Stadtwache);
	Stadtwache_333	= Hlp_GetNpc(Mil_333_Stadtwache);
	Schiffswache_212= Hlp_GetNpc(PAL_212_Schiffswache);
	Schiffswache_213= Hlp_GetNpc(PAL_213_Schiffswache);
	Torwache_305	= Hlp_GetNpc(Mil_305_Torwache);
 	Lagerwache 		= Hlp_GetNpc(Mil_328_Miliz);
 	Halvor 			= Hlp_GetNpc (VLK_469_Halvor);
 	Attila 			= Hlp_GetNpc (VLK_494_Attila);
 	Brahim 			= Hlp_GetNpc (VLK_437_Brahim);
	Nadja			= Hlp_GetNpc (VLK_435_Nadja);
	Vanja			= Hlp_GetNpc (VLK_491_Vanja);
	Moe				= Hlp_GetNpc (VLK_432_Moe);
	Valentino		= Hlp_GetNpc (VLK_421_Valentino);
	Sagitta			= Hlp_GetNpc (BAU_980_Sagitta);
	BDTWache		= Hlp_GetNpc (BDT_1061_Wache);
	
	Karras			= Hlp_GetNpc (KDF_503_Karras);
	Gorax 			= Hlp_GetNpc (KDF_508_Gorax);
	Rengaru			= Hlp_GetNpc (VLK_492_Rengaru);
	Sarah			= Hlp_GetNpc (VLK_470_Sarah);
	Canthar			= Hlp_GetNpc (VLK_468_Canthar);
	Andre			= Hlp_GetNpc (MIL_311_Andre);
	Lothar			= Hlp_GetNpc (PAL_203_Lothar);
	Girion			= Hlp_GetNpc (Pal_207_Girion);
	Girion_DI		= Hlp_GetNpc (Pal_207_Girion_DI);
	Salandril		= Hlp_GetNpc (VLK_422_Salandril);
	Cornelius 		= Hlp_GetNpc (VLK_401_Cornelius);
	Hodges			= Hlp_GetNpc (BAU_908_Hodges);
	Bennet			= Hlp_GetNpc (SLD_809_Bennet);
	Bennet_DI		= Hlp_GetNpc (SLD_809_Bennet_DI);
	SLD_Wolf		= Hlp_GetNpc (SLD_811_Wolf);
	Buster			= Hlp_GetNpc (SLD_802_Buster);
	Bartok     		= Hlp_GetNpc (VLK_440_Bartok);
	CityOrc			= Hlp_GetNpc (OrcWarrior_Harad);
	Gritta			= Hlp_GetNpc (VLK_418_Gritta);
	Richter			= Hlp_GetNpc (Vlk_402_Richter);
	Constantino     = Hlp_GetNpc (VLK_417_Constantino);
  	Thorben    		= Hlp_GetNpc (VLK_462_Thorben);
  	Bosper     		= Hlp_GetNpc (VLK_413_Bosper);
  	Matteo     		= Hlp_GetNpc (VLK_416_Matteo);
  
	LordHagen		= Hlp_GetNpc (PAL_200_Hagen);
	Albrecht		= Hlp_GetNpc (PAL_202_Albrecht);
 	Ingmar			= Hlp_GetNpc (Pal_201_Ingmar);
	Fellan		    = Hlp_GetNpc (VLK_480_Fellan);
	Bromor		    = Hlp_GetNpc (VLK_433_Bromor);
	Fernando		= Hlp_GetNpc (VLK_405_Fernando);
	Wulfgar		    = Hlp_GetNpc (MIL_312_Wulfgar);
	Mario		    = Hlp_GetNpc (None_101_Mario);
	Mario_DI		= Hlp_GetNpc (None_101_Mario_DI);
	Ignaz			= Hlp_GetNpc (VLK_498_Ignaz);
	Jack			= Hlp_GetNpc (VLK_444_Jack);
	
	Jack_DI		    = Hlp_GetNpc (VLK_444_Jack_DI);
	Jorgen_DI		= Hlp_GetNpc (VLK_4250_Jorgen_DI);
	Torlof			= Hlp_GetNpc (SLD_801_Torlof);
	Torlof_DI		= Hlp_GetNpc (SLD_801_Torlof_DI);
	
	Peck			= Hlp_GetNpc (MIL_324_Peck);
	Cassia			= Hlp_GetNpc (VLK_447_Cassia);
	Jesper			= Hlp_GetNpc (VLK_446_Jesper);
	Ramirez			= Hlp_GetNpc (VLK_445_Ramirez);
	Nagur			= Hlp_GetNpc (VLK_493_Nagur);
	Rangar 			= Hlp_GetNpc (MIL_321_Rangar);
	
	Sylvio			= Hlp_GetNpc (SLD_806_Sylvio);
	Sentenza		= Hlp_GetNpc (SLD_814_Sentenza);
	Bronko			= Hlp_GetNpc (BAU_935_Bronko);
	Sekob			= Hlp_GetNpc (BAU_930_Sekob);
	Rosi			= Hlp_GetNpc (BAU_936_Rosi);
	Till			= Hlp_GetNpc (BAU_931_Till);
	Balthasar		= Hlp_GetNpc (BAU_932_Balthasar);
	BalthasarSheep1	= Hlp_GetNpc (Balthasar_Sheep1);
	BalthasarSheep2	= Hlp_GetNpc (Balthasar_Sheep2);
	BalthasarSheep3	= Hlp_GetNpc (Balthasar_Sheep3);
	Rumbold			= Hlp_GetNpc (Mil_335_Rumbold); 
	Rick			= Hlp_GetNpc (Mil_336_Rick); 
	Bengar			= Hlp_GetNpc (BAU_960_Bengar); 
	Malak			= Hlp_GetNpc (BAU_963_Malak); 
	Egill			= Hlp_GetNpc (BAU_945_Egill); 
	Ehnim			= Hlp_GetNpc (BAU_944_Ehnim); 
	Engardo			= Hlp_GetNpc (SLD_841_Engardo); 
	Alvares			= Hlp_GetNpc (SLD_840_Alvares); 
	Kati			= Hlp_GetNpc (BAU_941_Kati); 
	Akil			= Hlp_GetNpc (BAU_940_Akil); 
	Orlan			= Hlp_GetNpc (BAU_970_Orlan); 
	Rukhar			= Hlp_GetNpc (BAU_973_Rukhar); 
	Randolph		= Hlp_GetNpc (BAU_942_Randolph); 
 	Pedro			= Hlp_GetNpc (NOV_600_Pedro); 
 
	Magic_Golem		= Hlp_GetNpc (MagicGolem);
	Liesel			= Hlp_GetNpc (Follow_Sheep);
	Hans			= Hlp_GetNpc (Follow_Meatbug);
	Igaraz			= Hlp_GetNpc (NOV_601_Igaraz);
	Agon			= Hlp_GetNpc (NOV_603_Agon);
	Opolos			= Hlp_GetNpc (NOV_605_Opolos);
	Babo			= Hlp_GetNpc (NOV_612_Babo);
	Dyrian			= Hlp_GetNpc (NOV_604_Dyrian);	
	Feger1 			= Hlp_GetNpc (NOV_615_Novize);	//Feger im Keller
	Feger2 			= Hlp_GetNpc (NOV_611_Novize);	//Partner von Igaraz
	Feger3 			= Hlp_GetNpc (NOV_609_Novize);	//Beter
	Isgaroth		= Hlp_GetNpc (KDF_509_Isgaroth);
	Sergio			= Hlp_GetNpc (PAL_299_Sergio);	
	Wolfi		 	= Hlp_GetNpc (BlackWolf);	
	Ulf				= Hlp_GetNpc (NOV_602_Ulf);	
	
	Fed		 		= Hlp_GetNpc (STRF_1106_Fed);	
	Kervo		 	= Hlp_GetNpc (STRF_1116_Kervo);	
	Geppert		 	= Hlp_GetNpc (STRF_1115_Geppert);	
	

	Bote			= Hlp_GetNpc (VLK_4006_Bote);	
	Jorgen			= Hlp_GetNpc (VLK_4250_Jorgen);
	LeuchtturmBandit_1021	= Hlp_GetNpc (BDT_1021_LeuchtturmBandit);
	LeuchtturmBandit_1022	= Hlp_GetNpc (BDT_1022_LeuchtturmBandit);
	LeuchtturmBandit_1023	= Hlp_GetNpc (BDT_1023_LeuchtturmBandit);
	Brian					= Hlp_GetNpc (VLK_457_Brian);
	Harad					= Hlp_GetNpc (VLK_412_Harad);
	Gerbrandt				= Hlp_GetNpc (VLK_403_Gerbrandt);
	GerbrandtsFrau			= Hlp_GetNpc (VLK_497_Buergerin);
	Morgahard				= Hlp_GetNpc (BDT_1030_Morgahard);
	Tengron					= Hlp_GetNpc (PAL_280_Tengron);
	Engor					= Hlp_GetNpc (VLK_4108_Engor);

 //----------Banditen-------------
   Bandit_1			= Hlp_GetNpc(BDT_1009_Bandit_L); 
   Bandit_2 		= Hlp_GetNpc(BDT_1010_Bandit_L);
   Bandit_3			= Hlp_GetNpc(BDT_1011_Bandit_M); 
   
 //----OldWorld----
	Koch				= Hlp_GetNpc(STRF_1107_Straefling);
	Bruder				= Hlp_GetNpc(PAL_2004_Bruder);
	PAL_Leiche1			= Hlp_GetNpc(PAL_2002_Leiche);
	PAL_Leiche2			= Hlp_GetNpc(PAL_2003_Leiche);
	PAL_Leiche3			= Hlp_GetNpc(PAL_2005_Leiche);
	PAL_Leiche4			= Hlp_GetNpc(PAL_2006_Leiche);
	PAL_Leiche5			= Hlp_GetNpc(PAL_2007_Leiche);
	VLK_Leiche1			= Hlp_GetNpc(VLK_4150_Leiche);
	VLK_Leiche2			= Hlp_GetNpc(VLK_4151_Leiche);
	VLK_Leiche3			= Hlp_GetNpc(VLK_4112_Den);
	STRF_Leiche1		= Hlp_GetNpc(STRF_1150_Leiche);
	STRF_Leiche2		= Hlp_GetNpc(STRF_1151_Leiche);
	STRF_Leiche3		= Hlp_GetNpc(STRF_1153_Leiche);
	STRF_Leiche4		= Hlp_GetNpc(STRF_1152_Leiche);
	STRF_Leiche5		= Hlp_GetNpc(STRF_1154_Leiche);
	STRF_Leiche6		= Hlp_GetNpc(STRF_1155_Leiche);
	STRF_Leiche7		= Hlp_GetNpc(STRF_1156_Leiche);
	STRF_Leiche8		= Hlp_GetNpc(STRF_1157_Leiche);
	Olav				= Hlp_GetNpc(VLK_4152_Olav);
	
	Marcos_Guard1		= Hlp_GetNpc(PAL_253_Wache);
	Marcos_Guard2		= Hlp_GetNpc(PAL_257_Ritter);
	
	Jergan				= Hlp_GetNpc(VLK_4110_Jergan);
	Parlaf 				= Hlp_GetNpc (VLK_4107_Parlaf);
	
	Garond				= Hlp_GetNpc(PAL_250_Garond);
	Oric				= Hlp_GetNpc(PAL_251_Oric);
	Parcival			= Hlp_GetNpc(PAL_252_Parcival);
	DJG_Sylvio			= Hlp_GetNpc(DJG_700_Sylvio);
	DJG_Bullco 			= Hlp_GetNpc(DJG_701_Bullco);
	DJG_Rod 			= Hlp_GetNpc(DJG_702_Rod);	 
	DJG_Cipher 			= Hlp_GetNpc(DJG_703_Cipher);
	DJG_Angar 			= Hlp_GetNpc(DJG_705_Angar);
	Angar_NW 			= Hlp_GetNpc(DJG_705_Angar_NW);
	Angar_DI 			= Hlp_GetNpc(DJG_705_Angar_DI);

	Kurgan				= Hlp_GetNpc(DJG_708_Kurgan);	 
	Kjorn			 	= Hlp_GetNpc(DJG_710_Kjorn);	  
	Godar			 	= Hlp_GetNpc(DJG_711_Godar);	  
	Hokurn 				= Hlp_GetNpc(DJG_712_Hokurn);	  
	Biff			 	= Hlp_GetNpc(DJG_713_Biff);	  
	Biff_NW			 	= Hlp_GetNpc(DJG_713_Biff_NW);	  
	Biff_DI			 	= Hlp_GetNpc(DJG_713_Biff_DI);	  

	Fajeth 			= Hlp_GetNpc(PAL_281_Fajeth);	 
	Bilgot			= Hlp_GetNpc(VLK_4120_Bilgot);	 
 	Brutus 			= Hlp_GetNpc(VLK_4100_Brutus);	 
	Rethon 			= Hlp_GetNpc(DJG_709_Rethon);	 
 	Ferros 			= Hlp_GetNpc(DJG_715_Ferros);	 
 	Jan 			= Hlp_GetNpc(DJG_714_Jan);	 
 	Hosh_Pak 		= Hlp_GetNpc(OrcShaman_Hosh_Pak);	 
	Urshak			= Hlp_GetNpc(NONE_110_Urshak);	 
	Sengrath		= Hlp_GetNpc(PAL_267_Sengrath);	 
	HaupttorWache_4143		= Hlp_GetNpc(VLK_4143_HaupttorWache);	 
	Engrom					= Hlp_GetNpc(VLK_4131_Engrom);	 
 
 //---DMT---

 	DMT_1200		= Hlp_GetNpc(DMT_1200_Dementor);	 
 	DMT_1201		= Hlp_GetNpc(DMT_1201_Dementor);	 
 	DMT_1202		= Hlp_GetNpc(DMT_1202_Dementor);	 
 	DMT_1203		= Hlp_GetNpc(DMT_1203_Dementor);	 
 	DMT_1204		= Hlp_GetNpc(DMT_1204_Dementor);	 
 	DMT_1205		= Hlp_GetNpc(DMT_1205_Dementor);	 
 	DMT_1206		= Hlp_GetNpc(DMT_1206_Dementor);	 
 	DMT_1207		= Hlp_GetNpc(DMT_1207_Dementor);	 
 	DMT_1208		= Hlp_GetNpc(DMT_1208_Dementor);	 
 	DMT_1209		= Hlp_GetNpc(DMT_1209_Dementor);	 
 	DMT_1210		= Hlp_GetNpc(DMT_1210_Dementor);	 
 	DMT_1211		= Hlp_GetNpc(DMT_1211_Dementor);	 

 	DMT_Vino1		= Hlp_GetNpc(DMT_DementorSpeakerVino1);	 
 	DMT_Vino2		= Hlp_GetNpc(DMT_DementorSpeakerVino2);	 
 	DMT_Vino3		= Hlp_GetNpc(DMT_DementorSpeakerVino3);	 
 	DMT_Vino4		= Hlp_GetNpc(DMT_DementorSpeakerVino4);	 
 
 //---Drachen---
	
	SwampDragon 	= Hlp_GetNpc(Dragon_Swamp);
	RockDragon 		= Hlp_GetNpc(Dragon_Rock);
	FireDragon 		= Hlp_GetNpc(Dragon_Fire);
	IceDragon 		= Hlp_GetNpc(Dragon_Ice);
	FireDragonIsland= Hlp_GetNpc(Dragon_Fire_Island);
	UndeadDragon 	= Hlp_GetNpc(Dragon_Undead);

 //---DragonIsland---

	Pedro_DI 		= Hlp_GetNpc(NOV_600_Pedro_DI);
	Keymaster_DI	= Hlp_GetNpc(DragonIsle_Keymaster);
	Archol 			= Hlp_GetNpc(Skeleton_Lord_Archol);
	
 //---Sld Onar---
	Cipher			= Hlp_GetNpc(Sld_803_Cipher);
	Rod				= Hlp_GetNpc(Sld_804_Rod);
	Cord			= Hlp_GetNpc(Sld_805_Cord);
	Bullco			= Hlp_GetNpc(Sld_807_Bullco);
	Jarvis			= Hlp_GetNpc(Sld_808_Jarvis);
	Fester			= Hlp_GetNpc(Sld_816_Fester);
	Raoul			= Hlp_GetNpc(Sld_822_Raoul);
	Dar				= Hlp_GetNpc(Sld_810_Dar);

	Onar 			= Hlp_GetNpc(Bau_900_Onar);
	Bodo			= Hlp_GetNpc(Bau_903_Bodo);
	Pepe			= Hlp_GetNpc(Bau_912_Pepe);


//Ende von B_InitNpcGlobals	 
};
// *******************************************************************
// Startup und Init Funktionen der Level-zen-files
// -----------------------------------------------
// Die STARTUP-Funktionen werden NUR beim ersten Betreten eines Levels 
// (nach NewGame) aufgerufen, die INIT-Funktionen jedesmal
// Die Funktionen m�ssen so heissen wie die zen-files
// *******************************************************************

// *********
// GLOBAL
// *********

func void STARTUP_GLOBAL()
{
	// wird fuer jede Welt aufgerufen (vor STARTUP_<LevelName>)
	Game_InitGerman();
};

func void INIT_GLOBAL()
{
	// wird fuer jede Welt aufgerufen (vor INIT_<LevelName>)
	Game_InitGerman();
};


// *********
// Testlevel
// *********


func void STARTUP_Testlevel ()
{

};

	func void INIT_SUB_Testlevel ()
	{
	};

func void INIT_Testlevel ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_Testlevel();
};

//------------------------------------------------------------
//		Addon World ADANOSTEMPEL
//------------------------------------------------------------
func void STARTUP_ADDON_PART_ADANOSTEMPLE_01 ()
{
	Wld_InsertNpc (BDT_1090_Addon_Raven,"ADW_ADANOSTEMPEL_RAVEN_11");

	Wld_InsertNpc (BDT_10400_Addon_DeadBandit,"ADW_ADANOSTEMPEL_RHADEMES_DEADBDT_01");
	Wld_InsertNpc (BDT_10401_Addon_DeadBandit,"ADW_ADANOSTEMPEL_RHADEMES_DEADBDT_02");

	Wld_InsertNpc (Stoneguardian_ADANOSTEMPELENTRANCE_01,"ADW_ADANOSTEMPEL_ENTRANCE_17");
	//Wld_InsertNpc (Stoneguardian_ADANOSTEMPELENTRANCE_02,"ADW_ADANOSTEMPEL_ENTRANCE_18M");
	Wld_InsertNpc (Stoneguardian_ADANOSTEMPELENTRANCE_03,"ADW_ADANOSTEMPEL_ENTRANCE_20");
	Wld_InsertNpc (Stoneguardian_ADANOSTEMPELENTRANCE_04,"ADW_ADANOSTEMPEL_ENTRANCE_13");

	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05A,"ADW_ADANOSTEMPEL_TREASUREPITS_05A");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05B,"ADW_ADANOSTEMPEL_TREASUREPITS_05B");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05C,"ADW_ADANOSTEMPEL_TREASUREPITS_05C");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05D,"ADW_ADANOSTEMPEL_TREASUREPITS_05D");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05E,"ADW_ADANOSTEMPEL_TREASUREPITS_05E");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_05F,"ADW_ADANOSTEMPEL_TREASUREPITS_05F");

	Wld_InsertNpc (Giant_Rat,"ADW_ADANOSTEMPEL_TREASUREPITS_07A");
	Wld_InsertNpc (Giant_Rat,"ADW_ADANOSTEMPEL_TREASUREPITS_07B");
	
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09A,"ADW_ADANOSTEMPEL_TREASUREPITS_09A");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09B,"ADW_ADANOSTEMPEL_TREASUREPITS_09B");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09C,"ADW_ADANOSTEMPEL_TREASUREPITS_09C");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09D,"ADW_ADANOSTEMPEL_TREASUREPITS_09D");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09E,"ADW_ADANOSTEMPEL_TREASUREPITS_09E");
	Wld_InsertNpc (Stoneguardian_TREASUREPITS_09F,"ADW_ADANOSTEMPEL_TREASUREPITS_09F");


	Wld_InsertNpc (Stoneguardian_RHADEMES_14A,"ADW_ADANOSTEMPEL_RHADEMES_14A");
	Wld_InsertNpc (Stoneguardian_RHADEMES_14B,"ADW_ADANOSTEMPEL_RHADEMES_14B");
	Wld_InsertNpc (Stoneguardian_RHADEMES_14C,"ADW_ADANOSTEMPEL_RHADEMES_14C");
	Wld_InsertNpc (Stoneguardian_RHADEMES_14D,"ADW_ADANOSTEMPEL_RHADEMES_14D");
	Wld_InsertNpc (Stoneguardian_RHADEMES_14E,"ADW_ADANOSTEMPEL_RHADEMES_14E");
	Wld_InsertNpc (Stoneguardian_RHADEMES_14F,"ADW_ADANOSTEMPEL_RHADEMES_14F");

	Wld_InsertNpc (NONE_ADDON_112_Rhademes,"ADW_ADANOSTEMPEL_RHADEMES");
};

func void INIT_SUB_ADDON_PART_ADANOSTEMPLE_01 ()
{
	
};

func void INIT_ADDON_PART_ADANOSTEMPLE_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();

	CurrentLevel = ADDONWORLD_ZEN;	 

	INIT_SUB_ADDON_PART_ADANOSTEMPLE_01();
};

//------------------------------------------------------------
//		Addon World GOLDMINE
//------------------------------------------------------------
func void STARTUP_ADDON_PART_GOLDMINE_01 ()
{
	//----------------------Humans----------------------------
	Wld_InsertNpc 	(STRF_1118_Addon_Patrick, 	"ADDON_GOLDMINE");
	Wld_InsertNpc 	(STRF_1119_Addon_Monty, 	"ADDON_GOLDMINE");
	Wld_InsertNpc 	(STRF_1120_Addon_Tonak, 	"ADDON_GOLDMINE");
	Wld_InsertNpc 	(STRF_1121_Addon_Telbor, 	"ADDON_GOLDMINE");
	Wld_InsertNpc 	(STRF_1122_Addon_Pardos, 	"ADDON_GOLDMINE");
	
	Wld_InsertNpc 	(BDT_1095_Addon_Crimson, 	"ADDON_GOLDMINE");
	
	
	Wld_InsertNpc   (BDT_10023_Addon_Wache,		"ADDON_GOLDMINE");
	Wld_InsertNpc   (BDT_10024_Addon_Garaz,		"ADDON_GOLDMINE");
	
	//----------------tote Sklaven--------------------
	Wld_InsertNpc	(STRF_1131_Addon_Sklave, "ADW_MINE_SKLAVENTOD_01");
	Wld_InsertNpc	(STRF_1132_Addon_Sklave, "ADW_MINE_SKLAVENTOD_01");
	Wld_InsertNpc	(STRF_1133_Addon_Sklave, "ADW_MINE_SKLAVENTOD_01");
	Wld_InsertNpc	(STRF_1134_Addon_Sklave, "ADW_MINE_SKLAVENTOD_01");
	Wld_InsertNpc	(STRF_1135_Addon_Sklave, "ADW_MINE_SKLAVENTOD_01");
	
	//----------------Plus Buddler, Wachen, Sklaven--------------------
	Wld_InsertNpc	(STRF_1128_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1129_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1130_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1136_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1137_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1138_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1139_Addon_Sklave, "ADDON_GOLDMINE");
	Wld_InsertNpc	(STRF_1140_Addon_Sklave, "ADDON_GOLDMINE");
	
	Wld_InsertNpc	(BDT_10025_Addon_Wache, "ADDON_GOLDMINE");
	Wld_InsertNpc	(BDT_10026_Addon_Wache, "ADDON_GOLDMINE");
	Wld_InsertNpc	(BDT_10027_Addon_Buddler, "ADDON_GOLDMINE");
	Wld_InsertNpc	(BDT_10028_Addon_Buddler, "ADDON_GOLDMINE");
	Wld_InsertNpc	(BDT_10029_Addon_Buddler, "ADDON_GOLDMINE");
	Wld_InsertNpc	(BDT_10030_Addon_Buddler, "ADDON_GOLDMINE");
	
		
		
	//------------ Monster ANZAHL (10) WICHTIG f�r Garaz (FIXME_FILLER) ----------------------------
	Wld_InsertNpc 	(GoldMinecrawler, 	"ADW_MINE_MC_04");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_04");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_03");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_03");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_08");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_08");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_07");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_07");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_02");
	Wld_InsertNpc 	(GoldMinecrawler, 			"ADW_MINE_MC_02");

	Wld_InsertNpc 	(Meatbug, 			"ADW_MINE_LAGER_08");
	Wld_InsertNpc 	(Meatbug, 			"ADW_MINE_LAGER_09");
	Wld_InsertNpc 	(Meatbug, 			"ADW_MINE_LAGER_05");
	Wld_InsertNpc 	(Meatbug, 			"ADW_MINE_LAGER_SIDE_04");
	
	Wld_InsertNpc 	(Stoneguardian_MineDead1, 	"ADW_GRUFT_01");
	Wld_InsertNpc 	(Stoneguardian_MineDead2, 	"ADW_GRUFT_02");
	Wld_InsertNpc 	(Stoneguardian_MineDead3, 	"ADW_MINE_TO_GRUFT_05");
	Wld_InsertNpc 	(Stoneguardian_MineDead4, 	"ADW_MINE_TO_GRUFT_06");
	
	
	
	
	

};

func void INIT_SUB_ADDON_PART_GOLDMINE_01 ()
{
	
};

func void INIT_ADDON_PART_GOLDMINE_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_GOLDMINE_01();
};

//------------------------------------------------------------
//		Addon World CANYON
//------------------------------------------------------------
func void STARTUP_ADDON_PART_CANYON_01 ()
{
	//----------------------freies Land------------------------

	Wld_InsertNpc 	(Blattcrawler, 	"ADW_CANYON_TELEPORT_PATH_09");
	Wld_InsertNpc 	(Blattcrawler, 	"ADW_CANYON_TELEPORT_PATH_09");
	Wld_InsertNpc 	(Blattcrawler, 	"ADW_CANYON_TELEPORT_PATH_09");

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_TELEPORT_PATH_03");
	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_TELEPORT_PATH_03");

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_TELEPORT_PATH_04");

	Wld_InsertNpc 	(CanyonRazor01, 	"ADW_CANYON_MINE1_01");
	

	Wld_InsertNpc 	(CanyonRazor02, 	"ADW_CANYON_PATH_TO_LIBRARY_07A");
	Wld_InsertNpc 	(CanyonRazor03, 	"ADW_CANYON_PATH_TO_LIBRARY_07A");
	

	Wld_InsertNpc 	(CanyonRazor04, 	"ADW_CANYON_PATH_TO_LIBRARY_36");
	Wld_InsertNpc 	(CanyonRazor05, 	"ADW_CANYON_PATH_TO_LIBRARY_36");
	

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_LIBRARY_40");
	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_LIBRARY_40");

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_LIBRARY_03");

	Wld_InsertNpc 	(Bloodhound, 	"ADW_CANYON_PATH_TO_BANDITS_31");

	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_BANDITS_52");
	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_BANDITS_52");

	Wld_InsertNpc 	(CanyonRazor06, 	"ADW_CANYON_PATH_TO_MINE2_04");
	

	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_31A");
	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_31A");
	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_31A");

	Wld_InsertNpc 	(Blattcrawler, 	"ADW_CANYON_PATH_TO_BANDITS_55");
	Wld_InsertNpc 	(Blattcrawler, 	"ADW_CANYON_PATH_TO_BANDITS_55");

	Wld_InsertNpc 	(Shadowbeast_Addon_Fire, 	"ADW_CANYON_PATH_TO_BANDITS_06E");

	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_16A");
	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_16A");
	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_16A");

	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_PATH_TO_LIBRARY_17");

	Wld_InsertNpc 	(orcbiter, 	"ADW_CANYON_ORCS_09");


	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_37");
	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_37");
	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_12A");
	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_12A");
	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_12A");
	Wld_InsertNpc 	(Wolf, 	"ADW_CANYON_PATH_TO_LIBRARY_12A");

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_ORCS_08");
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_ORCS_08");

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_PATH_TO_LIBRARY_14");
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_PATH_TO_LIBRARY_14");

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_PATH_TO_LIBRARY_19");
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_PATH_TO_LIBRARY_20");
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_PATH_TO_LIBRARY_20");

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_ORCS_04");

	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_ORCS_05");
	Wld_InsertNpc 	(OrcWarrior_Roam, 	"ADW_CANYON_ORCS_05");

	Wld_InsertNpc 	(OrcWarrior_Rest, 	"ADW_CANYON_ORCS_02");
	Wld_InsertNpc 	(OrcShaman_Sit_CanyonLibraryKey, 	"ADW_CANYON_ORCS_02");
	Wld_InsertNpc 	(OrcShaman_Sit, 	"ADW_CANYON_ORCS_02");

	Wld_InsertNpc 	(Bloodhound, 	"ADW_CANYON_PATH_TO_MINE2_09");
	Wld_InsertNpc 	(Bloodhound, 	"ADW_CANYON_PATH_TO_MINE2_09");

	Wld_InsertNpc 	(Bloodhound, 	"ADW_CANYON_PATH_TO_MINE2_06");
	

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_BANDITS_26");
	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_BANDITS_26");

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_BANDITS_24");

	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_BANDITS_66");
	Wld_InsertNpc 	(Giant_DesertRat, 	"ADW_CANYON_PATH_TO_BANDITS_66");
	
	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_22");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"ADW_CANYON_PATH_TO_BANDITS_22");

	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_21");

	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_17");
	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_17");
	
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"ADW_CANYON_PATH_TO_BANDITS_14");
	Wld_InsertNpc 	(Minecrawler, 	"ADW_CANYON_PATH_TO_BANDITS_14");
	
	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_62");
	Wld_InsertNpc 	(Minecrawler, 			"ADW_CANYON_PATH_TO_BANDITS_19");
	
	Wld_InsertNpc 	(Blattcrawler, 			"ADW_CANYON_PATH_TO_BANDITS_06");

	Wld_InsertNpc 	(Blattcrawler, 			"ADW_CANYON_PATH_TO_BANDITS_09");

	//H�hle 
	Wld_InsertItem (ItRi_Addon_Health_02,"FP_ITEM_CANYON_02"); 
	
	//hintere Mine
	Wld_InsertItem (ItRi_Addon_MANA_01,"FP_ITEM_CANYON_09");
	
	//----------------------Library----------------------------
	Wld_InsertNpc 	(Shadowbeast_Addon_Fire_CanyonLib, 	"ADW_CANYON_LIBRARY_04");
	Wld_InsertNpc 	(Shadowbeast_Addon_Fire, 	"ADW_CANYON_LIBRARY_LEFT_08");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_LEFT_07");
	Wld_InsertNpc 	(Shadowbeast_Addon_Fire, 	"ADW_CANYON_LIBRARY_RIGHT_07");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_RIGHT_13");

	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_STONIE_01");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_STONIE_02");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_STONIE_03");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_STONIE_04");
	Wld_InsertNpc 	(Stoneguardian, 	"ADW_CANYON_LIBRARY_STONIE_05");
	Wld_InsertItem  (ItMi_Addon_Stone_05,"ADW_ITEM_CANYON_TOKEN_01"); 
	
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"ADW_CANYON_MINE1_13");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"ADW_CANYON_MINE2_09");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"ADW_CANYON_MINE2_09");

	Wld_InsertNpc 	(Minecrawler, 	"ADW_CANYON_MINE1_10");
	Wld_InsertNpc 	(Minecrawler, 	"ADW_CANYON_MINE1_05");

	Wld_InsertItem  (ItMi_Zeitspalt_Addon,"FP_ITEM_CANYON_UNIQUE");  
	
};
func void INIT_SUB_ADDON_PART_CANYON_01 ()
{

};
func void INIT_ADDON_PART_CANYON_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_CANYON_01();
};
//------------------------------------------------------------
//		Addon World ENTRANCE
//------------------------------------------------------------
func void STARTUP_ADDON_PART_ENTRANCE_01 ()
{
    // Sonja
	Wld_InsertNpc (VLK_436_Sonja	 	, "ADW_ENTRANCE");	//???

	Wld_InsertNpc (KDW_14000_Addon_Saturas_ADW   ,"ADW_ENTRANCE");
	Wld_InsertNpc (KDW_14010_Addon_Cronos_ADW    ,"ADW_ENTRANCE");
	Wld_InsertNpc (KDW_14020_Addon_Nefarius_ADW  ,"ADW_ENTRANCE");
	Wld_InsertNpc (KDW_14030_Addon_Myxir_ADW     ,"ADW_ENTRANCE");
	Wld_InsertNpc (KDW_14040_Addon_Riordian_ADW  ,"ADW_ENTRANCE");
	Wld_InsertNpc (KDW_14050_Addon_Merdarion_ADW ,"ADW_ENTRANCE");
	
	Wld_InsertNpc (NONE_Addon_114_Lance_ADW,"ADW_ENTRANCE"); 			//Leiche im Sumpf
	Wld_InsertNpc (VLK_4304_Addon_William,"ADW_ENTRANCE"); 			//Unterhalpb des H�gels, auf der PIR Seite
	Wld_InsertNpc (PIR_1352_Addon_AlligatorJack,"ADW_ENTRANCE");	//Auf dem weg zu den Banditen
	
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_PLATEAU_08");
	
	
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_05");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_05");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_05");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_02B");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_02B");


	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_11");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_11");
	//Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_VALLEY_02A"); //RAUS wegen AlliJack

	Wld_InsertNpc (Waran ,"ADW_ENTRANCE_2_VALLEY_08");
	
	Wld_InsertNpc (Waran ,"ADW_ENTRANCE_PATH2BANDITS_05P");
	Wld_InsertNpc (Waran ,"ADW_ENTRANCE_PATH2BANDITS_05P");
 

	Wld_InsertNpc (Sleepfly ,"ADW_ENTRANCE_PATH2BANDITS_10");
	Wld_InsertNpc (Sleepfly ,"ADW_ENTRANCE_PATH2BANDITS_10");
	
	Wld_InsertNpc (Bloodfly ,"ADW_ENTRANCE_PATH2BANDITS_03");

	Wld_InsertNpc (Waran ,"ADW_ENTRANCE_PATH2BANDITS_05");

	Wld_InsertNpc (Razor ,"ADW_ENTRANCE_RUIN1_01");
	Wld_InsertNpc (Giant_Rat ,"ADW_ENTRANCE_RUIN1_01");
	
	
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_BEHINDAKROPOLIS_04");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_BEHINDAKROPOLIS_04");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_PIRATECAMP_13");
	Wld_InsertNpc (Blattcrawler ,"ADW_ENTRANCE_2_PIRATECAMP_13");

	Wld_InsertNpc (Stoneguardian_NailedPortalADW1 ,"ADW_PORTALTEMPEL_08A");
	Wld_InsertNpc (Stoneguardian_NailedPortalADW2 ,"ADW_PORTALTEMPEL_08B");

	Wld_InsertNpc (Molerat ,"ADW_ENTRANCE_PATH2BANDITSCAVE1_05");
	Wld_InsertNpc (Molerat ,"ADW_ENTRANCE_PATH2BANDITSCAVE1_06");
	Wld_InsertNpc (Molerat ,"ADW_ENTRANCE_2_PIRATECAMP_05");
	Wld_InsertNpc (Molerat ,"ADW_ENTRANCE_2_PIRATECAMP_05");

	Wld_InsertNpc (Gobbo_Warrior ,"ADW_ENTRANCE_2_PIRATECAMP_19");
	Wld_InsertNpc (Gobbo_Black ,"ADW_ENTRANCE_2_PIRATECAMP_19");
	Wld_InsertNpc (Gobbo_Black ,"ADW_ENTRANCE_2_PIRATECAMP_19");

	Wld_InsertNpc (Shadowbeast ,"ADW_ENTRANCE_2_PIRATECAMP_22");
	
	//Items
	Wld_InsertItem (ItWr_StonePlateCommon_Addon,"FP_ITEM_ADWPORTAL_01");
	Wld_InsertItem (ItWr_HitPointStonePlate3_Addon,"FP_ITEM_ADWPORTAL_02"); 
	
	Wld_InsertItem (ItRi_Addon_Health_01,"FP_ITEM_ENTRANCE_09"); 
	
};

func void INIT_SUB_ADDON_PART_ENTRANCE_01 ()
{
};

func void INIT_ADDON_PART_ENTRANCE_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_ENTRANCE_01();
};
//------------------------------------------------------------
//		Addon World Banditenlager
//------------------------------------------------------------
FUNC VOID STARTUP_ADDON_PART_BANDITSCAMP_01()
{
	//FUNKTIONEN
	//Machvoll_Goldmobis_ADW();
	//ITEMS 
		
	//Pflanzen auf den Stufen von Bloodwyns Behausung
	
	Wld_InsertItem (ItPl_Health_Herb_02,"FP_ITEM_BL_STAIRS_01"); 
	Wld_InsertItem (ItPl_Mana_Herb_01,"FP_ITEM_BL_STAIRS_02");
	Wld_InsertItem (ItPl_Mana_Herb_03,"FP_ITEM_BL_STAIRS_03");
	Wld_InsertItem (ItPl_Mana_Herb_02,"FP_ITEM_BL_STAIRS_04");
	Wld_InsertItem (ItPl_Health_Herb_03,"FP_ITEM_BL_STAIRS_05");
	
	Wld_InsertItem (ItSc_LightningFlash,"FP_BL_ITEM_SMITH_01"); //Regal
	Wld_InsertItem (ItPl_Speed_Herb_01,"FP_BL_ITEM_SMITH_02"); //hinter den Kisten im Hof
	Wld_InsertItem (ItPl_Temp_Herb,"FP_BL_ITEM_SMITH_BACK_01");//links neben dem Haus
	
	Wld_InsertItem (ItPo_Mana_02,"FP_ITEM_BL_TRYSTAN");
	
	Wld_InsertItem (ItAm_Addon_Health,"FP_ITEM_MINE_01");//BALKEN VERSTECK
	
	Wld_InsertItem (ITKE_ADDON_BUDDLER_01,"FP_ITEM_BL_CHEST");
	Wld_InsertItem (ITWr_Addon_Hinweis_02,"FP_ITEM_BL_SNAF");
	
	Wld_InsertItem (ItPo_Health_Addon_04,"FP_RAVEN_01");
	Wld_InsertItem (ItPo_Mana_Addon_04,"FP_RAVEN_02");
	
	
	//IM SUMPF 
	Wld_InsertItem (ItPl_Temp_Herb,"FP_ITEM_BANDITSCAMP_01"); 
	Wld_InsertItem (ItPo_Mana_03,"FP_ITEM_BANDITSCAMP_02"); 
	
	Wld_InsertItem (ItRi_Addon_MANA_02,"FP_ITEM_BANDITSCAMP_03"); //TOLLES ITEM !!!
	
	Wld_InsertItem (ItSc_IceCube,"FP_ITEM_BANDITSCAMP_04"); 
	Wld_InsertItem (ItPl_Speed_Herb_01,"FP_ITEM_BANDITSCAMP_05"); 
	Wld_InsertItem (ItPo_Health_03,"FP_ITEM_BANDITSCAMP_06"); 
	Wld_InsertItem (ItPo_Mana_03,"FP_ITEM_BANDITSCAMP_07"); 
	Wld_InsertItem (ItPl_Perm_Herb,"FP_ITEM_BANDITSCAMP_08"); 
	Wld_InsertItem (ItPl_Temp_Herb,"FP_ITEM_BANDITSCAMP_09"); 
	Wld_InsertItem (ItPo_Health_02,"FP_ITEM_BANDITSCAMP_10"); 
	Wld_InsertItem (ItMi_GoldNugget_Addon,"FP_ITEM_BANDITSCAMP_11"); 
	Wld_InsertItem (ItPo_Health_02,"FP_ITEM_BANDITSCAMP_12"); 
	Wld_InsertItem (ItPo_Speed,"FP_ITEM_BANDITSCAMP_13"); 
	Wld_InsertItem (ItPl_Temp_Herb,"FP_ITEM_BANDITSCAMP_14"); 
	Wld_InsertItem (ItPo_Health_03,"FP_ITEM_BANDITSCAMP_15"); 
	Wld_InsertItem (ItMW_Addon_Keule_2h_01,"FP_ITEM_BANDITSCAMP_16"); 
	Wld_InsertItem (ItMi_GoldNugget_Addon,"FP_ITEM_BANDITSCAMP_17"); 
	Wld_InsertItem (ItPl_Speed_Herb_01,"FP_ITEM_BANDITSCAMP_19"); 
	Wld_InsertItem (ItPl_Temp_Herb,"FP_ITEM_BANDITSCAMP_20"); 
	//NSCs
	
	//-----------------VORPOSTEN--------------------------------------
	
	//Franco und seine J�ger
	Wld_InsertNpc (BDT_1093_Addon_Franco,"BANDIT");
	
	Wld_InsertNpc (BDT_10011_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10012_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_1076_Addon_Bandit,"BANDIT");//EX Schmied
	Wld_InsertNpc (BDT_1077_Addon_Bandit,"BANDIT");//EX H�ndler
	
	//Vorposten 1 Holzbau/Palisade
	
	Wld_InsertNpc (BDT_1073_Addon_Sancho,"BANDIT");
	Wld_InsertNpc (BDT_1087_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10022_Addon_Miguel,"BANDIT");
	
	//Vorposten 2 Versteck
	Wld_InsertNpc (BDT_1072_Addon_Logan,"BANDIT");
	Wld_InsertNpc (BDT_1080_Addon_Tom,"BANDIT");
	
	//Vorposten 3 Ruine
	Wld_InsertNpc (BDT_1074_Addon_Edgor,"BANDIT");
	Wld_InsertNpc (BDT_1078_Addon_Bandit,"BANDIT");//EX Wirt
	
	//Sonstige im Sumpf 
	Wld_InsertNpc (BDT_10016_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10017_Addon_Juan  ,"BANDIT");
	//--------------------LAGER-----------------------------------------
	
	Wld_InsertNpc (BDT_10014_Addon_Thorus, "BANDIT");//
	
	Wld_InsertNpc (BDT_1071_Addon_Ramon, "BANDIT");//TORWACHE
	Wld_InsertNpc (BDT_10004_Addon_Finn,"BANDIT");
	Wld_InsertNpc (BDT_1088_Addon_Torwache,"BL_ENTRANCE_GUARD_02");
	
	
	Wld_InsertNpc (BDT_1083_Addon_Esteban,"BANDIT");
	Wld_InsertNpc (BDT_1081_Addon_Wache_01,"BANDIT");
	Wld_InsertNpc (BDT_10005_Addon_Wache_02,"BANDIT");
	
	Wld_InsertNpc (BDT_1097_Addon_Fisk,"BANDIT");//H�ndler
	Wld_InsertNpc (BDT_1098_Addon_Snaf,"BANDIT");//Wirt
	Wld_InsertNpc (BDT_1099_Addon_Huno,"BANDIT");//Schmied
	
	
	Wld_InsertNpc (BDT_1070_Addon_Paul,"BL_DOWN_CENTER_07");
	Wld_InsertNpc (BDT_1082_Addon_Skinner,"BANDIT");
	Wld_InsertNpc (BDT_1075_Addon_Fortuno,"BANDIT");
	Wld_InsertNpc (BDT_1084_Addon_Senyan,"BANDIT");
	Wld_InsertNpc (BDT_10015_Addon_Emilio,"BANDIT");
	
	Wld_InsertNpc (BDT_1096_Addon_Lennar,"BANDIT");
	Wld_InsertNpc (BDT_1079_Addon_Carlos,"BANDIT");
	
	Wld_InsertNpc (BDT_1091_Addon_Lucia ,"BANDIT");
	//Wld_InsertNpc (BDT_1092_Addon_Isabel,"BANDIT"); 
	
	Wld_InsertNpc	(BDT_10031_Addon_Wache, "BANDIT");
	Wld_InsertNpc   (BDT_1086_Addon_Scatty,	"BANDIT");
	
	Wld_InsertNpc (BDT_1085_Addon_Bloodwyn,"BANDIT");
	
	Wld_InsertNpc (STRF_1141_Addon_Sklave,"BANDIT");
	Wld_InsertNpc (STRF_1142_Addon_Sklave,"BANDIT");
	Wld_InsertNpc (STRF_1143_Addon_Sklave,"BANDIT");
	Wld_InsertNpc (STRF_1144_Addon_Sklave,"BANDIT");
	
	
	Wld_InsertNpc (BDT_10001_Addon_Bandit_L,"BANDIT");
	Wld_InsertNpc (BDT_10002_Addon_Bandit_M,"BANDIT");
	Wld_InsertNpc (BDT_10003_Addon_Bandit_H,"BANDIT");
	
	Wld_InsertNpc (BDT_10006_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10007_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10008_Addon_Bandit,"BANDIT");
	
	Wld_InsertNpc (BDT_10009_Addon_Bandit,"BANDIT");
	Wld_InsertNpc (BDT_10010_Addon_Bandit,"BANDIT");
	
	Wld_InsertNpc (BDT_10018_Addon_Torwache,"BANDIT");
	Wld_InsertNpc (BDT_10019_Addon_Wache,"BANDIT");
	Wld_InsertNpc (BDT_10020_Addon_Wache,"BANDIT");
	Wld_InsertNpc (BDT_10021_Addon_Wache,"BANDIT");
	
	//-----------------Ravens Tempel ---------------------- 
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_17");
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_18");
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_19");
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_20");
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_21");
	Wld_InsertNpc (Zombie_Addon_Knecht,"BL_RAVEN_SIDE_22");
	
	
	//-----------------MONSTER------------------------------------ 
	Wld_InsertNpc (SwampGolem,"ADW_PATH_TO_GOLEM_05");
	Wld_InsertNpc (SwampGolem,"ADW_PATH_TO_GOLEM_06");
	Wld_InsertNpc (SwampGolem,"ADW_PATH_TO_GOLEM_08");
	
	Wld_InsertNpc (SwampGolem,"ADW_SWAMP_GOLEM_02");
	Wld_InsertNpc (SwampGolem,"ADW_SWAMP_GOLEM_03");
	Wld_InsertNpc (SwampGolem,"ADW_SWAMP_GOLEM_04");
	
	//Bloodflies rechts vom Eingang BL
	Wld_InsertNpc (Bloodfly,"ADW_BL_FLIES_03");
	Wld_InsertNpc (Bloodfly,"ADW_BL_FLIES_04");
	Wld_InsertNpc (Bloodfly,"ADW_BL_FLIES_06");
	Wld_InsertNpc (Bloodfly,"ADW_BL_FLIES_07");
	
	//Steg
	Wld_InsertNpc (Gobbo_Black,"ADW_BANDIT_VP1_05");
	
	
	//Sharks hinter Vorposten 3
	Wld_InsertNpc (MIS_Addon_Swampshark_Lou,"ADW_SHARK_01");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_02");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_03");
	//und Weg zur�ck zum Damm
	Wld_InsertNpc (Swampshark,"ADW_SHARK_04");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_05");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_06");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_07");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_08");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_09");
	Wld_InsertNpc (Swampshark,"ADW_SHARK_10");
	
	
	//Swamp Shark Stra�e
	Wld_InsertNpc (SwampGolem,"ADW_SWAMP_WAND_01");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_WAND_02");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_WAND_03");
	
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_02");
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_03");
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_07");
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_08");
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_09");
	Wld_InsertNpc (Swampshark,"ADW_SWAMP_SHARKSTREET_10");

	Wld_InsertNpc (Swamprat,"ADW_CANYON_PATH_TO_BANDITS_01B");
	
	Wld_InsertNpc (Sleepfly,"ADW_LITTLE_HILL_03");
	Wld_InsertNpc (Sleepfly,"ADW_LITTLE_HILL_03");
	Wld_InsertNpc (Sleepfly,"ADW_LITTLE_HILL_04");
	
	//Weg rauf zum Big Sea
	Wld_InsertNpc (Sleepfly,"ADW_SWAMP_04");
	Wld_InsertNpc (Sleepfly,"ADW_SWAMP_04");
	
	Wld_InsertNpc (Sleepfly,"ADW_SWAMP_05");
	Wld_InsertNpc (Sleepfly,"ADW_SWAMP_05");

	//Little Sea 
	
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_01");
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_01");
	
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_02");
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_02");
	
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_03");
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_LITTLE_SEA_03");
	
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_12");
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_13");
	
	//Pfuetze 
	Wld_InsertNpc (Swamprat,"ADW_PFUETZE_01");
	Wld_InsertNpc (Swamprat,"ADW_PFUETZE_02");
	Wld_InsertNpc (Swamprat,"ADW_PFUETZE_03");
	Wld_InsertNpc (Swamprat,"ADW_PFUETZE_04");
	
	//Ruine
	Wld_InsertNpc (Gobbo_Warrior,"ADW_BANDIT_VP1_07_D");
	Wld_InsertNpc (Gobbo_Black,"ADW_BANDIT_VP1_07_E");
	Wld_InsertNpc (Gobbo_Black,"ADW_BANDIT_VP1_07_F");
	Wld_InsertNpc (Gobbo_Black,"ADW_SWAMP_LITTLE_SEA_03_B");
	Wld_InsertNpc (Gobbo_Black,"ADW_SWAMP_09_C");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HOHLWEG_01");
	
	
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_LOCH_01");
	Wld_InsertNpc (Waran,"ADW_SWAMP_LOCH_02");
	Wld_InsertNpc (Waran,"ADW_SWAMP_LOCH_03");
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_LOCH_04");

	Wld_InsertNpc (Gobbo_Black,"ADW_SWAMP_08_D");
	Wld_InsertNpc (Gobbo_Black,"ADW_SWAMP_08_E");
	
	Wld_InsertNpc (Bloodfly,"ADW_PATH_TO_BL_09");
	Wld_InsertNpc (Swampdrone,"ADW_PATH_TO_BL_10");
	Wld_InsertNpc (Bloodfly,"ADW_PATH_TO_BL_10");
	Wld_InsertNpc (Bloodfly,"ADW_PATH_TO_LOCH_01");
	Wld_InsertNpc (Bloodfly,"ADW_PATH_TO_LOCH_01");

	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HILLS_DOWN_05");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_10");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_13");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_14");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_06");
	Wld_InsertNpc (Bloodfly,"ADW_SWAMP_05");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_12");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_BF_NEST_06");

	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HOHLWEG_03");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HOHLWEG_04");
	
	//----------------Senat--- (und Wege dorthin)--------------------
	
	//Items
	Wld_InsertItem (ItPl_Mana_Herb_01,"FP_ITEM_SENAT_01");
	Wld_InsertItem (ItPl_Health_Herb_02,"FP_ITEM_SENAT_02");
	Wld_InsertItem (ItPl_Temp_Herb,"FP_ITEM_SENAT_03");
	Wld_InsertItem (ItPl_Health_Herb_03,"FP_ITEM_SENAT_04");
	Wld_InsertItem (ItPl_Mana_Herb_02,"FP_ITEM_SENAT_05");
	//Monster	
	Wld_InsertNpc (Stoneguardian_Sani01,"ADW_SENAT_SIDE_01");
	Wld_InsertNpc (Stoneguardian_Sani02,"ADW_SENAT_SIDE_02");
	Wld_InsertNpc (Stoneguardian_Sani03,"ADW_SENAT_SIDE_03");
	
	
	Wld_InsertNpc (Stoneguardian_Sani04,"ADW_SENAT_GUARDIAN_01");
	Wld_InsertNpc (Stoneguardian_Sani05,"ADW_SENAT_GUARDIAN_02");
	Wld_InsertNpc (Stoneguardian_Sani06,"ADW_SENAT_GUARDIAN_03");
	
	Wld_InsertNpc (StoneGuardian_Heiler,"ADW_SENAT_INSIDE_01");
	
	Wld_InsertNpc (Waran,"ADW_SENAT_MONSTER_01");
	Wld_InsertNpc (Waran,"ADW_SENAT_MONSTER_02");
	Wld_InsertNpc (Waran,"ADW_SENAT_MONSTER_03");
	Wld_InsertNpc (Waran,"ADW_SENAT_MONSTER_04");

	Wld_InsertNpc (Waran,"ADW_SENAT_05");
	Wld_InsertNpc (Waran,"ADW_SENAT_05");
	
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_HILLS_DOWN_07");
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_HILLS_DOWN_07");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HILLS_DOWN_05");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HILLS_DOWN_06");
	
	
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HILLS_DOWN_03");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HILLS_DOWN_03");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_15");
	Wld_InsertNpc (Swamprat,"ADW_HOHLWEG_CENTER");
	Wld_InsertNpc (Swamprat,"FP_ROAM_BF_NEST_26");
	Wld_InsertNpc (Swamprat,"ADW_BANDITSCAMP_RAKEPLACE_03");
	Wld_InsertNpc (Swampdrone,"ADW_CANYON_PATH_TO_BANDITS_02");
	Wld_InsertNpc (Swampdrone,"ADW_PFUETZE_02");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_LOCH_05");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_LOCH_06");


	Wld_InsertNpc (Swamprat,"ADW_SWAMP_TO_BIGSEA_01");
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_TO_BIGSEA_01");
	
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_HOHLWEG_02");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HOHLWEG_05");
	Wld_InsertNpc (Swampdrone,"ADW_SWAMP_HOHLWEG_05");
	
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_07");
	Wld_InsertNpc (Swamprat,"ADW_SWAMP_07");
};



FUNC VOID INIT_SUB_ADDON_PART_BANDITSCAMP_01()
{	
		//Die portalr�ume im banditenlager
		Wld_AssignRoomToGuild("tavern01"  , GIL_NONE);
		Wld_AssignRoomToGuild("beds01"	  , GIL_PUBLIC);
		Wld_AssignRoomToGuild("merchant01", GIL_PUBLIC);
		Wld_AssignRoomToGuild("schmied01" , GIL_NONE);
		Wld_AssignRoomToGuild("zoll01"	  , GIL_NONE);
		Wld_AssignRoomToGuild("raven01"	  , GIL_PUBLIC);
};
FUNC VOID INIT_ADDON_PART_BANDITSCAMP_01()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_BANDITSCAMP_01();
};

//#############################################
//###										###
//###			Piratenlager				###
//###										###
//#############################################

FUNC VOID STARTUP_ADDON_PART_PIRATESCAMP_01 ()
{
	//--------- Piraten --------------------------
	Wld_InsertNpc (PIR_1350_Addon_Francis,"STRAND");		//Vor Gregs H�tte -->SitBench
	Wld_InsertNpc (PIR_1351_Addon_Samuel,"STRAND");			//In der H�hle    
	Wld_InsertNpc (PIR_1353_Addon_Morgan,"STRAND");			//Vor Sams H�hle
	Wld_InsertNpc (PIR_1354_Addon_Henry,"STRAND");			//An der Palisade --> ArmsCrossed
	Wld_InsertNpc (PIR_1355_Addon_Skip,"STRAND");			//
	Wld_InsertNpc (PIR_1356_Addon_Bill,"STRAND");			//Am Strand -->Saw
	Wld_InsertNpc (PIR_1357_Addon_Garett ,"STRAND");		//Am Lagerschuppen
	
	Wld_InsertNpc (PIR_1360_Addon_Pirat,"STRAND");			//An der Palisade --> RepairHut
	Wld_InsertNpc (PIR_1361_Addon_Pirat,"STRAND");			//An der Palisade --> Saw
	Wld_InsertNpc (PIR_1362_Addon_Bones,"STRAND");			//Trainiert
	Wld_InsertNpc (PIR_1363_Addon_Pirat,"STRAND");			//Bank
	Wld_InsertNpc (PIR_1364_Addon_Pirat,"STRAND");			//FixME_Hoshi --> noch TA setzen!!!
	Wld_InsertNpc (PIR_1365_Addon_Matt,"STRAND");			//SmallTalk
	Wld_InsertNpc (PIR_1366_Addon_Brandon,"STRAND");			//Smalltalk
	
	Wld_InsertNpc (PIR_1367_Addon_Owen,"STRAND");			//Holzf�lelrlager
	Wld_InsertNpc (PIR_1368_Addon_Malcom,"STRAND");			//tot ind er geheimen H�hle
	
	
	Wld_InsertNpc (PIR_1370_Addon_Angus,"STRAND");			//tot
	Wld_InsertNpc (PIR_1371_Addon_Hank ,"STRAND");			//tot
	
	
	//--------- Turm Banditen-------------------------
	
	Wld_InsertNpc (BDT_10100_Addon_TowerBandit,"STRAND");			
	Wld_InsertNpc (BDT_10101_Addon_TowerBandit,"STRAND");			
	Wld_InsertNpc (BDT_10102_Addon_TowerBandit,"STRAND");	
	
	Wld_InsertItem (ItMi_Addon_GregsTreasureBottle_MIS,"FP_ADW_GREGSBOTTLE"); 		
	
	
	// --------- Monster -----------------------------
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_ISLE1_01");
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_ISLE1_01");
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_ISLE1_01");
	
	// -------- Strandlurker ------------------------
	Wld_InsertNpc (BeachWaran1,"ADW_PIRATECAMP_BEACH_27");
	Wld_InsertNpc (BeachWaran2,"ADW_PIRATECAMP_BEACH_27");
	
	Wld_InsertNpc (BeachLurker1,"ADW_PIRATECAMP_BEACH_28");
	Wld_InsertNpc (BeachLurker2,"ADW_PIRATECAMP_BEACH_28");
	Wld_InsertNpc (BeachLurker2,"ADW_PIRATECAMP_BEACH_28");
	
	Wld_InsertNpc (BeachShadowbeast1,"ADW_PIRATECAMP_CAVE3_04");
	
	//-------- Einsamer Strand -----------------------
	
	Wld_InsertNpc (Waran,"ADW_PIRATECAMP_LONEBEACH_11");
	Wld_InsertNpc (Waran,"ADW_PIRATECAMP_LONEBEACH_12");
	Wld_InsertNpc (FireWaran,"ADW_PIRATECAMP_LONEBEACH_10");
	Wld_InsertNpc (FireWaran,"ADW_PIRATECAMP_LONEBEACH_10");
	Wld_InsertNpc (FireWaran,"DAW_PIRTECAMP_LONEBEACH_07");
	Wld_InsertNpc (FireWaran,"ADW_PIRATECAMP_LONEBEACH_08");
	Wld_InsertNpc (Waran,"ADW_PIRATECAMP_LONEBEACH_05");
	Wld_InsertNpc (Waran,"ADW_PIRATECAMP_LONEBEACH_04");
	
	Wld_InsertNpc (ZOMBIE01,"ADW_PIRATECAMP_LONEBEACH_CAVE_03");
	Wld_InsertNpc (MAYAZOMBIE02,"ADW_PIRATECAMP_LONEBEACH_CAVE_03");
	Wld_InsertNpc (ZOMBIE03,"ADW_PIRATECAMP_LONEBEACH_CAVE_03");
	
	// --------- Versteckte H�hle ----------------------
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_SECRETCAVE_01");
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_SECRETCAVE_01");
	
	//---------- Holzf�llerlager -----------------------
	
	Wld_InsertNpc (Meatbug,"ADW_PIRATECAMP_LUMBER_01");
	Wld_InsertNpc (Meatbug,"ADW_PIRATECAMP_LUMBER_01");
	Wld_InsertNpc (Meatbug,"ADW_PIRATECAMP_LUMBER_01");
	
	// --------- Vor dem Turm ------------------------
	
	Wld_InsertNpc (Gobbo_Black,"ADW_PIRATECAMP_PLAIN_01");
	Wld_InsertNpc (Gobbo_Black,"ADW_PIRATECAMP_PLAIN_01");
	Wld_InsertNpc (Gobbo_Black,"ADW_PIRATECAMP_PLAIN_02");
	
	// --------- Hinter dem Turm --------------------
	
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATCAMP_PLAIN_05");
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATCAMP_PLAIN_05");
	
	//---------- Wasserloch -------------------------
	 
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATCAMP_PLAIN_05");
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATCAMP_PLAIN_05");
	
	Wld_InsertNpc (Waran,"ADW_PIRATECAMP_WATERHOLE_08");
	
	Wld_InsertNpc (Lurker,"ADW_PIRATECAMP_WATERHOLE_04");
	
	//---------- Weg ---------------------------------
	
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATECAMP_WAY_SPAWN_01");
	Wld_InsertNpc (Blattcrawler,"ADW_PIRATECAMP_WAY_SPAWN_02");
	
	
	//========================================================
	//				Items
	//========================================================
	
	
	
	//-------- Treibgut im Seichten Wasser -----
	
	Wld_InsertItem (ItFo_Addon_Rum,"FP_ITEMSPAWN_SHALLOWWATER_01");	
	Wld_InsertItem (ItMi_GoldNugget_Addon,"FP_ITEMSPAWN_SHALLOWWATER_02");	
	Wld_InsertItem (ItMi_Addon_Shell_01,"FP_ITEMSPAWN_SHALLOWWATER_03");
	Wld_InsertItem (ItMi_JeweleryChest,"FP_ITEMSPAWN_SHALLOWWATER_04");
	Wld_InsertItem (ItMi_GoldChalice,"FP_ITEMSPAWN_SHALLOWWATER_05");	
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_06");	
	Wld_InsertItem (ItMi_GoldRing,"FP_ITEMSPAWN_SHALLOWWATER_07");
	Wld_InsertItem (ItMi_Addon_Shell_01,"FP_ITEMSPAWN_SHALLOWWATER_08");
	Wld_InsertItem (ItSe_GoldPocket100,"FP_ITEMSPAWN_SHALLOWWATER_09");
	Wld_InsertItem (ItMi_RuneBlank,"FP_ITEMSPAWN_SHALLOWWATER_10");	
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_11");	
	Wld_InsertItem (ItPo_Health_Addon_04,"FP_ITEMSPAWN_SHALLOWWATER_12");	
	Wld_InsertItem (ItMi_Skull,"FP_ITEMSPAWN_SHALLOWWATER_13");	
	Wld_InsertItem (ItPo_Health_Addon_04,"FP_ITEMSPAWN_SHALLOWWATER_14");	
	Wld_InsertItem (ItMi_SilverCandleHolder,"FP_ITEMSPAWN_SHALLOWWATER_15");	
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_16");
	Wld_InsertItem (ItMi_SilverRing,"FP_ITEMSPAWN_SHALLOWWATER_17");	
	Wld_InsertItem (ItMi_Addon_Shell_01,"FP_ITEMSPAWN_SHALLOWWATER_18");	
	Wld_InsertItem (ItPo_Mana_Addon_04,"FP_ITEMSPAWN_SHALLOWWATER_19");
	Wld_InsertItem (ItMi_GoldCup,"FP_ITEMSPAWN_SHALLOWWATER_20");
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_21");	
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_22");
	Wld_InsertItem (ItMi_GoldChest,"FP_ITEMSPAWN_SHALLOWWATER_23");
	Wld_InsertItem (ItMi_GoldCup,"FP_ITEMSPAWN_SHALLOWWATER_24");	
	Wld_InsertItem (ItSe_GoldPocket100,"FP_ITEMSPAWN_SHALLOWWATER_25");	
	Wld_InsertItem (ItMi_Nugget,"FP_ITEMSPAWN_SHALLOWWATER_26");
	Wld_InsertItem (ItMi_Addon_Shell_01,"FP_ITEMSPAWN_SHALLOWWATER_27");	
	Wld_InsertItem (ItMi_SilverPlate,"FP_ITEMSPAWN_SHALLOWWATER_28");
	Wld_InsertItem (ItMi_SilverCup,"FP_ITEMSPAWN_SHALLOWWATER_29");	
	Wld_InsertItem (ItMi_Addon_Shell_02,"FP_ITEMSPAWN_SHALLOWWATER_30");	
	
	
	Wld_InsertItem (ItAm_Addon_STR,"FP_ITEMSPAWN_LONEBEACH_02");	//-->Feuerwaranstrand in der H�hle
/*

	//-------- Sonstige Item FP ------------
	
	
	
	
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_WATERHOLE_01");	//-->Hinten im Talkessel mit dem See
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_SECRETCAVE_01");	//-->In der unterirdische Stunth�hle
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_WAY_01");			//-->Auf dem Platz vor dem Piratenlager, an dem grossen Felsen zum Canyon hin
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_WAY_02");			//-->Auf dem grossen Platz vor Piratenlager, an der Felswand
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_BANDITS_01");		//-->Zwischen Turm und Abgrund zum Wasserloch
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_BANDITS_02");		//-->Hinterm Turm
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_BANDITS_03");		//-->Auf dem Turm
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_LONEBEACH_01");	//-->Feuerwaranstrand
	
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_WATER_01");		//-->Auf Felseninsel
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_BEACH_01");		//-->Piratenstrand ganz links
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_BEACH_02");		//-->Piratenstrand, hinter der ersten H�tte
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_LURKERBEACH_01");	//-->Lurkerstrand vorne
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_LURKERBEACH_02");	//-->Lurkerstrand hinten
	Wld_InsertItem (XXX,"FP_ITEMSPAWN_LURKERBEACH_03");	//-->Lurkerstrand H�hle
	
	*/
};

FUNC VOID INIT_SUB_ADDON_PART_PIRATESCAMP_01 ()
{
};

FUNC VOID INIT_ADDON_PART_PIRATESCAMP_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_PIRATESCAMP_01();
};

//#############################################
//###										###
//###			Part VALLEY					###
//###										###
//#############################################

FUNC VOID STARTUP_ADDON_PART_VALLEY_01 ()
{
	Wld_InsertNpc (None_Addon_115_Eremit,"ADW_VALLEY_PATH_031_HUT");
	
	// ------ Troll ------
	Wld_InsertNpc (Valley_Troll,"ADW_VALLEY_BIGCAVE_07");
	Wld_InsertNpc (Valley_Troll,"ADW_VALLEY_PATH_048_B");

	// ------ Gobbo_Black ------
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_PATH_003_A");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_BIGCAVE_08");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_BIGCAVE_08");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_BIGCAVE_08");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_BIGCAVE_08");
	Wld_InsertNpc (MayaZombie03,"ADW_VALLEY_BIGCAVE_18");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_PATH_012");
	Wld_InsertNpc (Gobbo_Warrior_Visir,"ADW_VALLEY_PATH_115_F");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_PATH_115_F");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_PATH_054_B");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_PATH_054_B");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_PATH_054_D");
	Wld_InsertNpc (Gobbo_Black,"ADW_VALLEY_PATH_054_E");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_PATH_054_F");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_PATH_058_CAVE_09");
	Wld_InsertNpc (Gobbo_Warrior_Visir,"ADW_VALLEY_PATH_058_CAVE_09");
	Wld_InsertNpc (Gobbo_Warrior,"ADW_VALLEY_PATH_058_CAVE_09");

	// ------ Harpie ------
	Wld_InsertNpc (Harpie,"ADW_VALLEY_BIGCAVE_06");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_BIGCAVE_06");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_BIGCAVE_15");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_BIGCAVE_15");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_BIGCAVE_15");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_PATH_110");
	Wld_InsertNpc (Harpie,"ADW_VALLEY_PATH_110");

	// ------ Snapper ------
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_020");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_020");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_BIGCAVE_01");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_048_A");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_048_A");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_048_A");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_047_D");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_047_D");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_047_D");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_047_G");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_047_G");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_038_E");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_038_E");
	Wld_InsertNpc (Snapper,"ADW_VALLEY_PATH_038_J");
	
	// ------ Shadowbeast ------
	Wld_InsertNpc (Shadowbeast,"ADW_VALLEY_PATH_029");

	// ------ Skeleton ------
	Wld_InsertNpc (Skeleton,"ADW_VALLEY_PATH_020_CAVE_05");
	Wld_InsertNpc (Skeleton,"ADW_VALLEY_PATH_020_CAVE_05");
	
	// ------Scavenger ------
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_032_G");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_032_G");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_032_G");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_121_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_121_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_121_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_120_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_120_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_120_A");

	// ------ Molerat ------
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_027");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_045");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_129_B");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_129_B");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_129_B");

	// ------ Minecrawler ------
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_131");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_131");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_132_A");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_132_A");
	Wld_InsertNpc (Minecrawler_Priest,"ADW_VALLEY_PATH_134");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_134");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_135");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_135");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_135");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_135");
	Wld_InsertNpc (Minecrawler,"ADW_VALLEY_PATH_135");
	Wld_InsertNpc (MinecrawlerWarrior,"ADW_VALLEY_PATH_058_CAVE_13");
	
	// ------ Blattcrawler ------
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_024_A");
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_024_A");
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_125");
	Wld_InsertNpc (SwampGolem_Valley,"ADW_VALLEY_PATH_064_A");	
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_062");
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_062");

	// ------ Bloodfly ------
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_102_A");
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_102_A");
	Wld_InsertNpc (Scavenger_Demon,"ADW_VALLEY_PATH_116_A");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_043");
	Wld_InsertNpc (Swamprat,"ADW_VALLEY_PATH_043");
	Wld_InsertNpc (Blattcrawler,"ADW_VALLEY_PATH_053");
	Wld_InsertNpc (Bloodfly,"ADW_VALLEY_PATH_017");
	
	// ------ Meatbug ------
	Wld_InsertNpc (Meatbug,"ADW_VALLEY_PATH_058");

	// ------ Orcs ------
	Wld_InsertNpc (OrcWarrior_Rest,"ADW_VALLEY_PATH_033_A");
	Wld_InsertNpc (OrcWarrior_Sit,"ADW_VALLEY_PATH_035");
	Wld_InsertNpc (OrcWarrior_Sit,"ADW_VALLEY_PATH_036");
	Wld_InsertNpc (OrcShaman_Sit,"ADW_VALLEY_PATH_115_E");
	
	// ------ Zombie ------
	Wld_InsertNpc (MayaZombie01,"ADW_VALLEY_PATH_072");
	Wld_InsertNpc (Zombie04,"ADW_VALLEY_PATH_072");
	Wld_InsertNpc (Zombie03,"ADW_VALLEY_PATH_073");
	Wld_InsertNpc (MayaZombie04_Totenw,"ADW_VALLEY_PATH_072");
	Wld_InsertNpc (Zombie04,"ADW_VALLEY_PATH_073");
	Wld_InsertNpc (Zombie02,"ADW_VALLEY_PATH_073");
	
	
	Wld_InsertNpc (Stoneguardian_NailedValleyShowcase_01,"ADW_VALLEY_SHOWCASE1_02");
	Wld_InsertNpc (Stoneguardian_NailedValleyShowcase_02,"ADW_VALLEY_SHOWCASE1_03");
	Wld_InsertItem (ItMi_Zeitspalt_Addon,"FP_ITEM_VALLEY_02");
	
	//Qurahodrons Grab
	Wld_InsertItem (ItRi_Addon_STR_02,"FP_ITEM_VALLEY_12");
};

FUNC VOID INIT_SUB_ADDON_PART_VALLEY_01 ()
{
};

FUNC VOID INIT_ADDON_PART_VALLEY_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_ADDON_PART_VALLEY_01();
};




// *************
// Alte Oberwelt
// *************

func void STARTUP_OLDCAMP ()
{
	
	//ITEMS
	Wld_InsertItem (ItMi_GornsTreasure_MIS,"FP_ITEM_GORN");
	Wld_InsertItem (ItKE_ErzbaronFlur,"FP_ITEM_OC_01");
	Wld_InsertItem (ItKE_ErzbaronRaum,"FP_ITEM_OC_02");

	Wld_InsertItem (ItWr_HitPointStonePlate2_Addon,"FP_ROAM_ORK_OC_04_2");

	
	// Foltermeister
	//------------------------------------------
	Wld_InsertNpc	(VLK_4100_Brutus,"OC1"); 
	
	// Gefangene im Kerker
	//------------------------------------------
	Wld_InsertNpc	(STRF_1100_Straefling,"OC1"); 
	Wld_InsertNpc	(STRF_1101_Draal	 ,"OC1"); 
	Wld_InsertNpc	(STRF_1102_Straefling,"OC1"); 
	Wld_InsertNpc	(STRF_1103_Straefling,"OC1"); 
	Wld_InsertNpc	(PC_FIGHTER_OW		 ,"OC1"); 
	
	// Kerker Wache 
	//------------------------------------------
	Wld_InsertNpc	(PAL_261_Gerold,"OC1"); 
	
	// Vorstand 
	//------------------------------------------
	Wld_InsertNpc	(PAL_250_Garond,"OC1"); 
	Wld_InsertNpc	(PAL_251_Oric,"OC1"); 
	Wld_InsertNpc	(PAL_252_Parcival,"OC1"); 
	
	// Koch und Wachen EBR Haus
	//------------------------------------------
	Wld_InsertNpc	(PAL_262_Wache,"OC1"); 
	Wld_InsertNpc	(PAL_263_Wache,"OC1"); 
	Wld_InsertNpc	(STRF_1107_Straefling,"OC1"); 
	
	// Haupt- Tor  Wachen
	//------------------------------------------
	Wld_InsertNpc	(PAL_253_Wache,"OC1"); 
	Wld_InsertNpc	(PAL_254_Wache,"OC1"); 
	
	// Training, Abends Campfire
	//------------------------------------------
	Wld_InsertNpc	(PAL_255_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_256_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_257_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_258_Keroloth,"OC1"); 
	
	// Palisadenwachen
	//------------------------------------------
	Wld_InsertNpc	(PAL_267_Sengrath,"OC1"); 
	Wld_InsertNpc	(PAL_268_Udar,"OC1"); 

	Wld_InsertNpc	(PAL_264_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_265_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_266_Ritter,"OC1"); 
	
	// Magier
	//------------------------------------------
	Wld_InsertNpc	(PC_Mage_OW,"OC1"); 
	
	// sonstige Typen 
	//------------------------------------------
	Wld_InsertNpc	(PAL_260_Tandor,"OC1"); // Lagerhaus Wache 
	
	Wld_InsertNpc	(Sheep,"FP_SLEEP_OC_SHEEP_01"); 
	Wld_InsertNpc	(Sheep,"FP_SLEEP_OC_SHEEP_02"); 
	Wld_InsertNpc	(Sheep,"FP_SLEEP_OC_SHEEP_03"); 
	
	Wld_InsertNpc	(PAL_269_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_270_Ritter,"OC1"); 
	Wld_InsertNpc	(PAL_271_Ritter,"OC1"); 

	Wld_InsertNpc	(PAL_272_Ritter,"OC1"); 
	
	Wld_InsertNpc	(VLK_4101_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4102_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4103_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4104_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4105_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4106_Dobar,"OC1");
	Wld_InsertNpc	(VLK_4107_Parlaf,"OC1");
	Wld_InsertNpc	(VLK_4108_Engor,"OC1");
	Wld_InsertNpc	(VLK_4109_Waffenknecht,"OC1"); 
	
	Wld_InsertNpc	(VLK_4140_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4141_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4142_Waffenknecht,"OC1"); 
	Wld_InsertNpc	(VLK_4143_Haupttorwache,"OC1");
	Wld_InsertNpc	(VLK_4144_Waffenknecht,"OC1");

	Wld_InsertNpc	(VLK_4145_Waffenknecht,"OC1");
	Wld_InsertNpc	(VLK_4146_Waffenknecht,"OC1");
	Wld_InsertNpc	(VLK_4147_Waffenknecht,"OC1");

	Wld_InsertNpc	(PAL_273_Ritter,"OC1");
	Wld_InsertNpc	(PAL_274_Ritter,"OC1"); 
	
	// arbeitende STRF + Wache
	//------------------------------------------
	Wld_InsertNpc	(STRF_1108_Straefling,"OC1"); 
	Wld_InsertNpc	(STRF_1109_Straefling,"OC1");
	Wld_InsertNpc	(PAL_259_Wache,"OC1"); 
	
	// Orks  ** noch mehr Roamer ***
	//------------------------------------------
	Wld_InsertNpc	(OrcElite_Roam,"OC14");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC_ORK_BETWEEN_CAMPS_01"); 
	Wld_InsertNpc	(OrcElite_Roam,"OC_ORK_LITTLE_CAMP_01"); 
	Wld_InsertNpc	(OrcWarrior_Roam,"OC_ORK_BETWEEN_CAMPS_02"); 
	Wld_InsertNpc	(OrcElite_Roam,"OC_ORK_LITTLE_CAMP_03");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC10");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC9");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC_ORK_BACK_CAMP_02");
	Wld_InsertNpc	(OrcElite_Roam,"OC8");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC6");
	Wld_InsertNpc	(OrcWarrior_Roam,"OC_ORK_BACK_CAMP_15");
	
	
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_MAIN_CAMP_05");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_MAIN_CAMP_05");	
	Wld_InsertNpc   (OrcWarrior_Roam,"OC_ORK_MAIN_CAMP_04");
		
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_01");	
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_MAIN_CAMP_02");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_MAIN_CAMP_03");
		
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_LITTLE_CAMP_03");	
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_LITTLE_CAMP_03");
		
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_BACK_CAMP_16");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_16");
		
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_06");	
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_BACK_CAMP_06");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_06");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_06");	
	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_07");	
	Wld_InsertNpc   (OrcShaman_Sit,"OC7");	
	Wld_InsertNpc   (OrcElite_Roam,"OC7");
	
	Wld_InsertNpc   (OrcShaman_Sit,"OC_ORK_LITTLE_CAMP_05");
	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_10");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_MAIN_CAMP_11");
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_12");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_03");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_02");
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_MAIN_CAMP_07");
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_MAIN_CAMP_04");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC1");
	Wld_InsertNpc   (OrcWarrior_Rest,"OC2");		
	Wld_InsertNpc   (OrcWarrior_Rest,"OC1");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC13");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC11");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_LITTLE_CAMP_02");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_LITTLE_CAMP_02");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_LITTLE_CAMP_06");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_LITTLE_CAMP_04");
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_01");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_02");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_03");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_04");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_05");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_06");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_07");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_08");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_09");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_10");	
	Wld_InsertNpc   (OrcElite_Roam,"OC_ORK_BACK_CAMP_11");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_12");
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_13");	
	Wld_InsertNpc   (OrcWarrior_Rest,"OC_ORK_BACK_CAMP_14");
	
	Wld_InsertNpc   (OrcWarrior_Rest,"FP_REST_ORK_OC_18");
	Wld_InsertNpc   (Sheep			,"FP_SLEEP_SHEEP_ORK");	
	
	// Hoshpak
	
	Wld_InsertNpc   (OrcShaman_Hosh_Pak	,"FP_CAMPFIRE_HOSHPAK_01");
	Wld_InsertNpc   (OrcShaman_Sit	,"FP_CAMPFIRE_HOSHPAK_02");	
	Wld_InsertNpc   (OrcWarrior_Rest,"FP_ROAM_HOSHPAK_05");	
	Wld_InsertNpc   (OrcWarrior_Rest,"FP_ROAM_HOSHPAK_03");	

	// Warge 
	Wld_InsertNpc	(Warg,"OC_PATH_04");
	Wld_InsertNpc	(Warg,"OC_PATH_02");
	Wld_InsertNpc	(Warg,"OC_PATH_02");
	Wld_InsertNpc	(Warg,"OC_PATH_02");
	Wld_InsertNpc	(Warg,"FP_ROAM_WARG_OC_10");
	Wld_InsertNpc	(Warg,"FP_ROAM_WARG_OC_10");
	Wld_InsertNpc	(Warg,"FP_ROAM_WARG_OC_13");
	Wld_InsertNpc	(Warg,"FP_ROAM_WARG_OC_13");
	
};

	func void INIT_SUB_OLDCAMP()
	{
		// ------ LIGHTS ------
		
		//Wld_SetMobRoutine			(00,00, "FIREPLACE", 1);
		//Wld_SetMobRoutine			(22,00, "FIREPLACE", 1);
		//Wld_SetMobRoutine			(05,00, "FIREPLACE", 0);
			
		// ------ PORTAL-R�UME ------		//Gro�- und Kleinschreibung beachten!
	
		//Wld_AssignRoomToGuild("h�tte77",GIL_VLK);
		
		//Kirche im alten Lager
		Wld_AssignRoomToGuild("ki1", GIL_NONE); //Hauptraum
		Wld_AssignRoomToGuild("ki2", GIL_NONE); //rechter Raum
		Wld_AssignRoomToGuild("ki3", GIL_NONE); //linker raum
		
		//Brutus
		Wld_AssignRoomToGuild("tu1", GIL_NONE); //wegen Mission besser gil_none (l�uft raus)
		
		//Wehrg�nge
		Wld_AssignRoomToGuild("he3", GIL_NONE); //einzelner Raum �ber Knast
		Wld_AssignRoomToGuild("he1", GIL_NONE); //Schalterraum
		Wld_AssignRoomToGuild("he2", GIL_NONE); //raum mit verbindung zu gardistenhaus
		
		//Gardistenhaus
		Wld_AssignRoomToGuild("eg1",	-1); //Eingangsbereich
		//unten
		Wld_AssignRoomToGuild("eg4",	-1); //Engor
		Wld_AssignRoomToGuild("eg2",	GIL_PUBLIC); //linker Schlafraum
		Wld_AssignRoomToGuild("sthaus",	GIL_PUBLIC); //gang hinter engor
		Wld_AssignRoomToGuild("st",		GIL_PUBLIC); //lagerraum
		Wld_AssignRoomToGuild("klo",	GIL_PUBLIC); //kleiner raum hinterm lager
		//oben
		Wld_AssignRoomToGuild("eg3",	GIL_MIL); //Schlafraum oben
		Wld_AssignRoomToGuild("eg5",	GIL_MIL); //Schlafraum oben - (verbindung zu he2)
		
		//Erzbaronhaus - alle Flure (auch oben)
		Wld_AssignRoomToGuild("hh1",	-1); //Eingangsbereich = DRAUSSEN (wegen B_AssessEnterRoom)
		//EBr unten
		Wld_AssignRoomToGuild("hh2",	GIL_PUBLIC); //Waffenkammer
		Wld_AssignRoomToGuild("hh3",	GIL_PUBLIC); //K�che
		Wld_AssignRoomToGuild("hhmh1",	GIL_PUBLIC); //Thronsaal
		//EBr oben
		Wld_AssignRoomToGuild("hh8",	GIL_MIL); //Schlafraum vorne links
		Wld_AssignRoomToGuild("hh7",	GIL_MIL); //Schlafraum vorne rechts
		Wld_AssignRoomToGuild("hh5",	GIL_MIL); //Gomez grosser raum hinten
		Wld_AssignRoomToGuild("hh4",	GIL_MIL); //Raum rechts hinten (mit gang zum turm)
		Wld_AssignRoomToGuild("wg3",	GIL_MIL); //gang zum turm
		Wld_AssignRoomToGuild("tu2",	GIL_MIL); //turmzimmer
	};

func void INIT_OLDCAMP ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_OLDCAMP();
};

func void STARTUP_DEMONTOWER ()
{
	
	Wld_InsertNpc				(Gobbo_SkeletonOWDemonTower,"DT_E1_06"); // Hat den Teleport ItRu_TeleportOWDemonTower in der Tasche
	Wld_InsertNpc				(Gobbo_Skeleton,"DT_E2_07");
	Wld_InsertNpc				(Gobbo_Skeleton,"DT_E2_09");
	Wld_InsertNpc				(Gobbo_Skeleton,"DT_E2_04");
	Wld_InsertNpc				(Gobbo_Skeleton,"DT_E2_05");
	Wld_InsertNpc				(Gobbo_Skeleton,"DT_E2_08");

	Wld_InsertNpc				(Demon,"DT_E2_06");

	Wld_InsertItem	(ItMi_Zeitspalt_Addon,"FP_ITEM_XARDASALTERTURM_01");
	Wld_InsertNpc				(Skeleton,"DT_E3_07");
	Wld_InsertNpc				(Skeleton,"DT_E3_04");

};

	func void INIT_SUB_DEMONTOWER ()
	{
	};

func void INIT_DEMONTOWER ()
{
	INIT_SUB_DEMONTOWER();
};


func void STARTUP_SURFACE ()
{


//*******************************************************
//		NSCs
//*******************************************************

    // Sonja
	Wld_InsertNpc (VLK_436_Sonja	 	, "OC1");	//???
	
	//ITEMS

	Wld_InsertItem (ItSe_ADDON_CavalornsBeutel,"FP_OW_ITEM_02");//ADDON

	Wld_InsertItem (ItWr_KDWLetter,"FP_ITEM_OW_01");
	Wld_InsertItem (ItWr_GilbertLetter,"FP_ITEM_OW_02");
	
	Wld_InsertItem (ItWr_DexStonePlate2_Addon,"OW_ITEM_ROCKHORT_01");
	Wld_InsertItem (ItWr_DexStonePlate1_Addon,"FP_REST_ORK_OC_29");
	Wld_InsertItem (ItWr_HitPointStonePlate1_Addon,"FP_ROAM_ORK_04");
	Wld_InsertItem (ItWr_StonePlateCommon_Addon,"FP_ROAM_OW_WARAN_DEMON_02");
	Wld_InsertItem (ItWr_OneHStonePlate1_Addon,"FP_ROAM_ITEM_SPECIAL_01");
	Wld_InsertItem (ItWr_ManaStonePlate2_Addon,"OW_ITEM_ICEHORT_01");
	Wld_InsertItem (ItWr_BowStonePlate2_Addon ,"FP_OW_ITEM_05");
	Wld_InsertItem (ItWr_CrsBowStonePlate2_Addon  ,"FP_ROAM_OW_LURKER_NC_LAKE_03");
	Wld_InsertItem (ItWr_StonePlateCommon_Addon  ,"FP_ROAM_OW_WOLF_NEAR_SHADOW3");
	Wld_InsertItem (ItWr_HitPointStonePlate1_Addon   ,"FP_OW_GORNS_VERSTECK");
	Wld_InsertItem (ItWr_CrsBowStonePlate1_Addon   ,"FP_ROAM_OW_GOBBO_CAVE03_02");
	Wld_InsertItem (ItWr_BowStonePlate1_Addon   ,"FP_ROAM_OW_WARAN_EBENE_02_01");
	Wld_InsertItem (ItWr_BowStonePlate1_Addon   ,"OW_ITEM_ROCKHORT_02");
	Wld_InsertItem (ItPl_Dex_Herb_01   ,"OW_ITEM_ROCKHORT_02");
	Wld_InsertItem (ItPl_Dex_Herb_01   ,"FP_ROAM_OW_LURKER_NC_LAKE_03");
	
	//-------------J�ger Camp im Lager �ber ehem. Cavalorns H�tte---------------------------
	Wld_InsertNpc		(VLK_4130_Talbin,"SPAWN_TALL_PATH_BANDITOS2_03");	
	Wld_InsertNpc		(VLK_4131_Engrom,"SPAWN_TALL_PATH_BANDITOS2_03");
	//-------------Swampcamp---------------------------
	Wld_InsertNpc		(VLK_4148_Gestath,"OW_DJG_ROCKCAMP_01");
	
	//-------------H�hle von Cavalorns H�tte---------------------------
	Wld_InsertNpc		(PAL_217_Marcos,"OC1");
	
	//-------------Entflohene Str�flinge im sp�teren DJG Vorposten Camp---------------------------------------------------------
	
	Wld_InsertNpc		(STRF_1115_Geppert,"OC1"); 		
	Wld_InsertNpc		(STRF_1116_Kervo,"OC1"); 		

	Wld_InsertNpc		(Kervo_Lurker1,"SPAWN_OW_BLACKGOBBO_A2");
	Wld_InsertNpc		(Kervo_Lurker2,"SPAWN_OW_WARAN_CAVE1_1");
	Wld_InsertNpc		(Kervo_Lurker3,"SPAWN_OW_WARAN_CAVE1_1");
	Wld_InsertNpc		(Kervo_Lurker4,"SPAWN_OW_NEARBGOBBO_LURKER_A1");
	Wld_InsertNpc		(Kervo_Lurker6,"SPAWN_OW_NEARBGOBBO_LURKER_A1");
	Wld_InsertNpc		(Kervo_Lurker5,"OW_MOVEMENT_LURKER_NEARBGOBBO03");
	
	
	
		
	Wld_InsertNpc		(VLK_4110_Jergan,"OC1"); //Sp�her		
	Wld_InsertNpc		(PAL_2004_Bruder,"OC1"); //Leiche 	
	Wld_InsertNpc		(VLK_4112_Den 	,"OC1"); //Leiche Den 		
	
	//Im Versteck der 4 Freunde
	//------------------------------------------
	Wld_InsertNpc		(PC_ThiefOW, 				"OC1");
	Wld_InsertNpc		(PAL_2006_Leiche, 			"OC1");
	Wld_InsertNpc		(PAL_2007_Leiche, 			"OC1");
	
	//-----------------------neue Erzmine 1 (Fajeth)----------------------------------------------
	Wld_InsertNpc		(Pal_281_Fajeth, 		"OC1"); 
	Wld_InsertNpc		(Pal_280_Tengron, 		"OC1");

	Wld_InsertNpc		(VLK_4120_Bilgot, 		"OC1");


	Wld_InsertNpc		(STRF_1106_Fed, 		"OC1");
	Wld_InsertNpc		(STRF_1104_Straefling,	"OC1");
	Wld_InsertNpc		(STRF_1105_Straefling, 	"OC1");
	Wld_InsertNpc		(STRF_1110_Straefling, 	"OC1");
	Wld_InsertNpc		(STRF_1111_Straefling, 	"OC1");
	Wld_InsertNpc		(STRF_1112_Straefling, 	"OC1");
	Wld_InsertNpc		(STRF_1113_Straefling, 	"OC1");
	Wld_InsertNpc		(STRF_1114_Straefling, 	"OC1");
	
	Wld_InsertNpc		(VLK_4152_Olav, 		"OC1");
	
	//-----------------------neue Erzmine 2 (Marcos)----------------------------------------------
	Wld_InsertNpc		(VLK_4111_Grimes,"OW_MINE2_GRIMES");
	Wld_InsertNpc		(STRF_1117_Straefling,"OW_MINE2_STRF");	
	Wld_InsertNpc		(PAL_218_Ritter,"OW_PATH_264");	
	Wld_InsertNpc		(PAL_219_Ritter,"OW_PATH_148_A");	
	
	//Treck Leichen
	Wld_InsertNpc		(VLK_4151_Leiche,"OW_SPAWN_TRACK_LEICHE_00");	
	Wld_InsertNpc		(STRF_1150_Leiche,"OW_SPAWN_TRACK_LEICHE_01");	
	Wld_InsertNpc		(STRF_1151_Leiche,"OW_SPAWN_TRACK_LEICHE_03");	
	Wld_InsertNpc		(STRF_1153_Leiche,"OW_SPAWN_TRACK_LEICHE_04");	
	
	//-----------------------neue Erzmine 3 (Silvestro)----------------------------------------------	
	Wld_InsertNpc		(PAL_2005_Leiche,"OW_MINE3_LEICHE_05");	
	Wld_InsertNpc		(PAL_2002_Leiche,"OW_MINE3_LEICHE_01");	
	Wld_InsertNpc		(PAL_2003_Leiche,"OW_MINE3_LEICHE_04");	
	
	Wld_InsertNpc		(STRF_1152_Leiche,"OW_MINE3_LEICHE_02");	
	Wld_InsertNpc		(STRF_1154_Leiche,"OW_MINE3_LEICHE_07");	
	Wld_InsertNpc		(STRF_1155_Leiche,"OW_MINE3_LEICHE_06");	
	Wld_InsertNpc		(STRF_1156_Leiche,"OW_MINE3_LEICHE_09");	
	Wld_InsertNpc		(STRF_1157_Leiche,"OW_MINE3_LEICHE_08");	
	
	Wld_InsertNpc		(VLK_4150_Leiche,"OW_MINE3_LEICHE_03");	


//*******************************************************
//		MONSTER
//*******************************************************

	//-----------------------Drachen OW ----------------------------------------------
	Wld_InsertNpc		(Dragon_Swamp,			"OW_SWAMPDRAGON_01");
	Wld_InsertNpc		(Dragon_Rock, 			"OW_ROCKDRAGON_11");
	Wld_InsertNpc		(Dragon_Fire, 			"CASTLE_36");
	Wld_InsertNpc		(Dragon_Ice, 			"OW_ICEDRAGON_01");


		////////////////////////////////////////////////////////////////////////////
		//-----------------------alter Spielstart Gothic1-------------------------//
		////////////////////////////////////////////////////////////////////////////
	
		// Orks am Oretrail:
		
	Wld_InsertNpc       (OrcWarrior_Roam,"SPAWN_OW_MEATBUG_01_01");	
	Wld_InsertNpc       (OrcWarrior_Roam,"OW_PATH_1_16_4");
		
	Wld_InsertNpc       (OrcWarrior_Roam,"OW_PATH_1_16_8");		
	Wld_InsertNpc       (OrcWarrior_Roam,"WP_INTRO_FALL3");
	
	Wld_InsertNpc       (OrcWarrior_Rest,"WP_INTRO21");			
	Wld_InsertNpc       (OrcWarrior_Rest,"WP_INTRO_WI07");

	Wld_InsertItem		(ItSe_DiegosTreasure_Mis,"WP_INTRO_WI15"); 

	
		// hinter der Br�cke gegen�ber der verlassenen Mine

	Wld_InsertNpc		(Giant_Bug,"SPAWN_MOLERAT02_SPAWN01");	
	Wld_InsertNpc		(Giant_Bug,"SPAWN_MOLERAT02_SPAWN01");	
	
		// Pfad zum OC
	Wld_InsertNpc		(DragonSnapper,"SPAWN_TOTURIAL_CHICKEN_2_2"); 	
	Wld_InsertNpc		(Bloodfly, "OW_PATH_1_5_4");  
	Wld_InsertNpc		(Bloodfly, "OW_PATH_1_5_4");  
	Wld_InsertNpc		(Bloodfly, "OW_PATH_1_5_3");  
	
	Wld_InsertNpc		(DragonSnapper, "FP_ROAM_OW_MAETBUG_ROOT_03"); 

		// Sandbank im Flu�
	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_E_3");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_E_3");
	
		// bei Ratford und Drax am Zaun
	Wld_InsertNpc		(Snapper,"FP_ROAM_OW_GOBBO_07_02");  
	Wld_InsertNpc		(Snapper,"FP_ROAM_OW_GOBBO_07_02");
	Wld_InsertNpc		(Snapper,"FP_ROAM_OW_GOBBO_07_02"); 

	Wld_InsertNpc		(Snapper,"OW_PATH_1_5_A"); 
		
		// zwischen ehem. Ratford und Br�cke zum OC
	Wld_InsertNpc		(Snapper,"SPAWN_OW_STARTSCAVNGERBO_01_02"); 
	Wld_InsertNpc		(Snapper,"SPAWN_OW_STARTSCAVENGER_02_01");

	Wld_InsertNpc		(Snapper,"SPAWN_OW_SCA_05_01");
	Wld_InsertNpc		(Snapper,"SPAWN_OW_SCA_05_01"); 

	// bei oc1  und ums Oldcamp!

	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_MEATBUG_04_02");	
	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_MEATBUG_04_02");	
	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_MEATBUG_03_03");	
	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_MEATBUG_03_03");	

	Wld_InsertNpc		(OrcShaman_Sit,"SPAWN_O_SCAVENGER_05_02");	


	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_O_SCAVENGER_05_02");	
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_OW_BLOODFLY_OC_WOOD05");	
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_OW_BLOODFLY_OC_WOOD05");	
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_OW_BLOODFLY_OC_WOOD05");	

	Wld_InsertNpc		(OrcWarrior_Roam,"OC1");	

	Wld_InsertNpc		(OrcWarrior_Roam,"OC2");	
	Wld_InsertNpc		(OrcShaman_Sit,"OC2");	


	Wld_InsertNpc		(OrcWarrior_Roam,"OC7");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC8");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC10");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC12");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC13");	

	Wld_InsertNpc		(OrcWarrior_Roam,"OC14");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC_ROUND_22_CF_2");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OC_ROUND_22_CF_2");	
	Wld_InsertNpc		(OrcShaman_Sit,"OC_ROUND_22_CF_2");	
	
	//--------------------Scavenger Horde-------------------------------------
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_01");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_01");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_01");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_01");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_01");	
	
	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_02");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_02");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_02");	
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_02");
	Wld_InsertNpc		(Scavenger,"OW_SPAWN_SCAVENGER_02");		
	
	//--------------------Direkter Weg ins Orkgebiet (Zaun)-------------------------------------
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_GATE_ORCS_01");	
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_GATE_ORCS_02");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_GATE_ORCS_03");
	
	// entsch�fter alternativ Weg zur Newmine
	
	Wld_InsertNpc		(Giant_Bug,"OC3");	
	Wld_InsertNpc		(Giant_Bug,"OW_SCAVENGER_SPAWN_TREE");
	Wld_InsertNpc		(Giant_Bug,"OW_SCAVENGER_SPAWN_TREE");

	Wld_InsertNpc		(Bloodfly,"OC4");	
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_SCAVENGER_AL_ORC");

	Wld_InsertNpc		(Bloodfly,"OC5");	
	Wld_InsertNpc		(Bloodfly,"OC6");	

	Wld_InsertNpc		(Wolf,"SPAWN_PATH_GUARD1");


	Wld_InsertNpc		(Wolf,"SPAWN_OW_BLACKWOLF_02_01");

	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_BLACKWOLF_02_01");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_BLACKWOLF_02_01");

	Wld_InsertNpc		(Bloodfly,"FP_ROAM_ORC_09");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_ORC_08");

	Wld_InsertNpc		(Bloodfly,"OW_PATH_103"); 

	Wld_InsertNpc		(Bloodfly,"FP_ROAM_OW_WARAN_ORC_01");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_OW_WARAN_ORC_04");


	// Fluss am Oldcamp!

	Wld_InsertNpc		(Lurker,"OW_PATH_WARAN05_SPAWN02");
	Wld_InsertNpc		(Lurker,"OW_PATH_WARAN05_SPAWN02");
	Wld_InsertNpc		(Warg,"SPAWN_O_SCAVENGER_05_02");

	Wld_InsertNpc		(Lurker,"OW_PATH_OW_PATH_WARAN05_SPAWN01");

//------------------ nahe der NewMine	------------------

	Wld_InsertNpc	(NewMine_Snapper1,"SPAWN_OW_SCAVENGER_ORC_03");  // Fajeths Snapper	
	Wld_InsertNpc	(NewMine_Snapper2,"SPAWN_OW_SCAVENGER_ORC_03");
	Wld_InsertNpc	(NewMine_Snapper4,"SPAWN_OW_BLOCKGOBBO_CAVE_DM6");
	Wld_InsertNpc	(NewMine_Snapper5,"SPAWN_OW_BLOCKGOBBO_CAVE_DM6");
	Wld_InsertNpc	(NewMine_Snapper6,"OW_PATH_333");	

	// Bei eingest�rtzter Orcbr�cke	
	Wld_InsertNpc	(Wolf,"OW_PATH_099");
	Wld_InsertNpc	(Wolf,"OW_PATH_099");

	Wld_InsertNpc	(Bloodfly,"SPAWN_OW_WARAN_ORC_01");
	Wld_InsertNpc	(Bloodfly,"SPAWN_OW_WARAN_ORC_01");

//------------ neue Mine 3 --------------------------------------------------
	Wld_InsertNpc (Minecrawler, "OW_MINE3_05"); 
	Wld_InsertNpc (Minecrawler, "OW_MINE3_05");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_05");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_06");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_06");
	
	Wld_InsertNpc (Minecrawler, "OW_MINE3_08");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_08");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_10");
	Wld_InsertNpc (MinecrawlerWarrior, "OW_MINE3_10");
	
	Wld_InsertNpc (Minecrawler, "OW_MINE3_LEICHE_02");
	Wld_InsertNpc (Minecrawler, "OW_MINE3_LEICHE_03");

//--------------------------------------------------------------------------	
	/*
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MOLERAT_SPAWN01");
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MOLERAT_SPAWN01");
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MOLERAT_SPAWN01");
	*/
	Wld_InsertNpc		(Giant_Bug,"PATH_OC_NC_6");
	Wld_InsertNpc		(Giant_Bug,"PATH_OC_NC_4");
	Wld_InsertNpc		(Giant_Bug,"PATH_OC_NC_4");

	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MEATBUG_SPAWN");
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MEATBUG_SPAWN");
	
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MEATBUG_SPAWN");
	Wld_InsertNpc		(Giant_Rat,"OW_SAWHUT_MEATBUG_SPAWN");

	//-------------BanditenLager------------------ ehem. Aidan 
 	
	Wld_InsertNpc		(BDT_1000_Bandit_L,"OW_WOODRUIN_FOR_WOLF_SPAWN");
	Wld_InsertNpc		(BDT_1001_Bandit_L,"OW_WOODRUIN_FOR_WOLF_SPAWN");
	
	Wld_InsertNpc		(BDT_1002_Bandit_L,"OW_WOODRUIN_WOLF_SPAWN");
	Wld_InsertNpc		(BDT_1003_Bandit_M,"PATH_OC_NC_14");

	
	//------------------Mine 2 zu Banditenlager  Die Br�cken--------------------------
	Wld_InsertNpc		(Gobbo_Green,"OW_PATH_149");
	Wld_InsertNpc		(Gobbo_Green,"OW_PATH_150");
	Wld_InsertNpc		(Gobbo_Green,"OW_PATH_057");
	Wld_InsertNpc		(Gobbo_Green,"OW_PATH_059");
	
	//------------------ Zwischen Eisregion und Banditenlager------------------------ 
	
	Wld_InsertNpc		(Bloodfly,"OW_PATH_055");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_055");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_055");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_055");
	
	Wld_InsertNpc		(Giant_Rat,"OW_SPAWN_TRACK_LEICHE_01");
	Wld_InsertNpc		(Giant_Rat,"OW_SPAWN_TRACK_LEICHE_01");
	
	//--------------------------------------------------- 
	
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_FORCAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_FORCAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_FORCAVE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_FORCAVE_SPAWN");


	
	Wld_InsertNpc		(Icewolf,"OW_SCAVENGER_COAST_NEWCAMP_SPAWN");
	Wld_InsertNpc		(Icewolf,"OW_SCAVENGER_COAST_NEWCAMP_SPAWN");
	Wld_InsertNpc		(Icewolf,"OW_SCAVENGER_COAST_NEWCAMP_SPAWN");
		
		//----IceRegion----------------


	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_BLOODFLY_05_07");

	Wld_InsertNpc		(Wisp,"FP_ROAM_OW_BLOODFLY_05_05");

	Wld_InsertNpc		(Icewolf,"FP_SLEEP_OW_BLOODFLY_05_02");
	Wld_InsertNpc		(Icewolf,"FP_SLEEP_OW_BLOODFLY_05_01");
	
	Wld_InsertNpc		(IceGolem_Sylvio1,"FP_ROAM_OW_ICEREGION_ENTRANCE_ICEGOLEM_02");
	Wld_InsertNpc		(IceGolem_Sylvio2,"FP_ROAM_OW_ICEREGION_ENTRANCE_ICEGOLEM_01");
	
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_1_01");
	Wld_InsertNpc		(IceGolem,"OW_ICEREGION_11");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_2_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_2_02");
	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_3_01");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_3_02");
	
	Wld_InsertNpc		(Wisp,"FP_ROAM_OW_ICEREGION_4_01");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_5_02");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_6_01");
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_7_01");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_8_01");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_9_01");
	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_10_01");	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_12_01");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_12_02");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_11_01");
	
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_13_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_13_02");
	
	Wld_InsertNpc		(Wisp,"FP_ROAM_OW_ICEREGION_14_01");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_15_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_15_02");
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_16_01");
	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_17_01");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_17_02");
	
	Wld_InsertNpc		(Wisp,"FP_ROAM_OW_ICEREGION_18_02");
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_19_01");
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_19_02");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_20_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_20_02");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_21_01");
	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_22_02");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_22_02");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_22_02");
	
	Wld_InsertNpc		(Icewolf,"OW_ICEREGION_86");
	Wld_InsertNpc		(Icewolf,"OW_ICEREGION_62");

	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_23_02");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_23_02");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_24_01");
	
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_25_01");

	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ICEREGION_27_01");
	
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_28_01");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_28_01");
	Wld_InsertNpc		(Icewolf,"FP_ROAM_OW_ICEREGION_28_01");
	 
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_31_01");
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_32_02");
	
	Wld_InsertNpc		(IceGolem,"FP_ROAM_OW_ICEREGION_33_02");//auf der ehem. NC-Kneipe

	//-----------------------------------
	
	Wld_InsertNpc		(Giant_Bug,"OW_SCAVENGER_CAVE3_SPAWN");
	Wld_InsertNpc		(Giant_Bug,"OW_SCAVENGER_CAVE3_SPAWN");
	Wld_InsertNpc		(Giant_Bug,"OW_SCAVENGER_TREE_SPAWN");
	Wld_InsertNpc		(Gobbo_Black,"OW_MOLERAT_CAVE_SPAWN");

	
	//--------------------------------------------------------
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_CAVE1_OC");
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_CAVE1_OC");
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_CAVE1_OC");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_C3");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_C3");


	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_12");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_BLOODFLY_12");

	//ehem. Neks H�hle, Gothic2 Gorns Versteck----------------

	Wld_InsertNpc		(Giant_Bug,"SPAWN_OW_SMALLCAVE01_MOLERAT");
	Wld_InsertNpc		(Giant_Bug,"SPAWN_OW_SMALLCAVE01_MOLERAT");
	Wld_InsertNpc		(Giant_Bug,"SPAWN_OW_SMALLCAVE01_MOLERAT");
	//--------------------------------
	Wld_InsertNpc		(Keiler,"SPAWN_OW_MOLERAT_OCWOOD_OC2");
	Wld_InsertNpc		(Keiler,"SPAWN_OW_MOLERAT_OCWOOD_OC2");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_MOLERAT_OLDWOOD1_M");
	Wld_InsertNpc		(Warg,"SPAWN_OW_MOLERAT_OCWOOD_OLDMINE3");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_MOLERAT_OCWOOD_OLDMINE3");


	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_WOLF_WOOD05_02");
	Wld_InsertNpc		(Warg,"FP_ROAM_OW_WOLF_08_08");
	Wld_InsertNpc		(OrcWarrior_Roam,"FP_ROAM_OW_WOLF_08_08");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_DEADWOOD_WOLF_SPAWN01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_DEADWOOD_WOLF_SPAWN01");
	Wld_InsertNpc		(Warg,"OW_DEADWOOD_WOLF_SPAWN01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_DEADWOOD_WOLF_SPAWN01");

	Wld_InsertNpc		(Lurker,"FP_ROAM_OW_BLOODFLY_04_02_02");

	Wld_InsertNpc		(Bloodfly,"OW_LAKE_NC_BLOODFLY_SPAWN01");
	Wld_InsertNpc		(Lurker,"OW_LAKE_NC_BLOODFLY_SPAWN01");
	Wld_InsertNpc		(Bloodfly,"OW_LAKE_NC_BLOODFLY_SPAWN01");
	
	Wld_InsertNpc		(Bloodfly,"OW_PATH_BLOODFLY01_SPAWN01");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_BLOODFLY01_SPAWN01");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_BLOODFLY01_SPAWN01");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_BLOODFLY01_SPAWN01");
	Wld_InsertNpc		(Lurker,"OW_PATH_BLOODFLY01_SPAWN01");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_BLOODFLY_WOOD05_01");

	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_BLOODFLY_WOOD05_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_BLOODFLY_WOOD05_01");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_MINICOAST_LURKER_A1");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_MINICOAST_LURKER_A1");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_MINICOAST_LURKER_A1");
	Wld_InsertNpc		(Bloodfly,"OW_LAKE_NC_LURKER_SPAWN01");
	
	//H�hle unter Wasserfall nahe Iceregion

	Wld_InsertNpc		(Lurker,"FP_CONVINCECORRISTO_KEY");
	
	//------------------------------------
	Wld_InsertNpc		(Gobbo_Black,"OW_PATH_WARAN06_SPAWN01");
	Wld_InsertNpc		(Gobbo_Black,"OW_PATH_WARAN06_SPAWN01");
	Wld_InsertNpc		(Gobbo_Black,"OW_PATH_WARAN06_SPAWN01");
	Wld_InsertNpc		(Gobbo_Black,"OW_PATH_WARAN06_SPAWN01");

	
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER03_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER03_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER03_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER03_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER12_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER12_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER12_SPAWN01");
	Wld_InsertNpc		(Snapper,"FP_ROAM_OW_SCAVENGER_12_07");
	Wld_InsertNpc		(Snapper,"FP_ROAM_OW_SCAVENGER_12_07");

	

	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER01_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER01_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER01_SPAWN01");
	Wld_InsertNpc		(Snapper,"OW_PATH_SCAVENGER01_SPAWN01");
	
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_OLDWOOD_C3");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_OLDWOOD_C3");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_SCAVENGER_OLDWOOD_C3");
	Wld_InsertNpc		(Warg,"SPAWN_OW_SHADOWBEAST_NEAR_SHADOW4");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_SHADOWBEAST_NEAR_SHADOW4");

	Wld_InsertNpc		(OrcShaman_Sit,"SPAWN_OW_SCAVENGER_OCWOOD1");	
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_OCWOOD1");

	
	//######################################################################
	//	 An der Orcbarriere 
	//######################################################################
	
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_01");

	
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_04_01");
	Wld_InsertNpc		(OrcElite_Roam,"OW_ORCBARRIER_04_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_04_01");

	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_06");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_06");


	Wld_InsertNpc		(OrcShaman_Sit,"OW_ORCBARRIER_08_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_08_01");
	Wld_InsertNpc		(OrcElite_Roam,"OW_ORCBARRIER_08_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_08_01");

	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_11");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_11");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_14");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_14");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_16");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_16");
	
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_17");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_ORCBARRIER_17");

	Wld_InsertNpc		(OrcWarrior_Roam,"PATH_OC_FOGTOWER03");
	Wld_InsertNpc		(OrcWarrior_Roam,"PATH_OC_FOGTOWER03");
	
	//######################################################################
	//	 bei alter Gobboh�hle: Orclager
	//######################################################################


	Wld_InsertNpc		(OrcWarrior_Roam,"MOVEMENT_GOBBO_LOCATION_29_01");	
	Wld_InsertNpc		(OrcWarrior_Roam,"MOVEMENT_GOBBO_LOCATION_29_01");
	Wld_InsertNpc		(OrcWarrior_Roam,"LOCATION_29_04");
	Wld_InsertNpc		(OrcShaman_Sit,"MOVEMENT_GOBBO_LOCATION_29_03");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_GOBBO_LOCATION_29_03");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_WATERFALL_GOBBO6");
	// vor der Br�cke
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_WATERFALL_GOBBO10"); 
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_WATERFALL_GOBBO10");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_WATERFALL_GOBBO10");
	Wld_InsertNpc		(OrcWarrior_Roam,"OW_WATERFALL_GOBBO10");
	
	//-------------------------------------------------------------------------------//
	
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_06_CAVE_GUARD3");
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_06_CAVE_GUARD3");
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_WOODOLDMINE2");
	Wld_InsertNpc		(DragonSnapper,"SPAWN_OW_SNAPPER_WOOD05_05");
	Wld_InsertNpc		(DragonSnapper,"SPAWN_OW_SNAPPER_WOOD05_05");

	Wld_InsertNpc		(DragonSnapper,"OW_PATH_187"); 
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_185");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_185");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_190");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_190");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_190");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_189"); 
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_189");


	
			
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_MOLERAT2_WALD_OC1");
	
	Wld_InsertNpc		(Lurker,"SPAWN_OW_LURKER_RIVER2");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_LURKER_RIVER2");
	Wld_InsertNpc		(Bloodfly,"SPAWN_OW_SCAVENGER_OCWOODEND2");


	Wld_InsertNpc		(Lurker,"SPAWN_OW_GOBBO_WATERFALLCAVE_2");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_GOBBO_WATERFALLCAVE_2");
	Wld_InsertNpc		(Lurker,"SPAWN_OW_GOBBO_WATERFALLCAVE_2");


	Wld_InsertNpc       (Shadowbeast_Skeleton_Angar,"OW_PATH_033_TO_CAVE5");					
	
	////////////////////////////////////////////////////////////////////////////
	Wld_InsertNpc		(DragonSnapper,"SPAWN_OW_SNAPPER_OCWOOD1_05_02");
	Wld_InsertNpc		(DragonSnapper,"SPAWN_OW_SNAPPER_OCWOOD1_05_02");


	////////////////////////////////////////////////////////////////////////////


	// umgest�rtzter Demonenbeschw�rer Turm im Wasser
	
	Wld_InsertNpc		(Lurker,"MT16");	
	Wld_InsertNpc		(Lurker,"MT15");
	
	Wld_InsertNpc		(Lurker,"MT09");
	Wld_InsertNpc		(Lurker,"MT08");
	Wld_InsertNpc		(Lurker,"MT08");
	
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_210");
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_210");
	
	Wld_InsertNpc		(StoneGolem,"OW_PATH_116");
	

	// OW D�monentower umgebung

	Wld_InsertNpc		(Bloodfly,"OW_PATH_205");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_208");
	Wld_InsertNpc		(Bloodfly,"OW_PATH_206");


	Wld_InsertNpc		(Bloodfly,"OW_DT_BLOODFLY_01"); 
	Wld_InsertNpc		(Bloodfly,"OW_DT_BLOODFLY_01");

	Wld_InsertNpc		(FireWaran,"SPAWN_OW_WARAN_DEMON_02_01");


	//-----------------------------------------------






	Wld_InsertNpc		(Lurker,"SPAWN_OW_SCAVENGER_BANDIT_02");
	
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_03_04");
	Wld_InsertNpc		(Gobbo_Warrior,"SPAWN_OW_MOLERAT_03_04");
	Wld_InsertNpc		(Gobbo_Black,"SPAWN_OW_MOLERAT_03_04");

	
	Wld_InsertNpc		(Draconian,"SPAWN_OW_WARAN_NC_03");
	Wld_InsertNpc		(Draconian,"SPAWN_OW_WARAN_NC_03");

	Wld_InsertNpc		(FireWaran,"SPAWN_OW_WARAN_DEMON_01");
	Wld_InsertNpc		(FireWaran,"SPAWN_OW_WARAN_DEMON_01");

	Wld_InsertNpc		(Waran,"SPAWN_OW_WARAN_EBENE2_02_05");
	Wld_InsertNpc		(FireWaran,"SPAWN_OW_WARAN_EBENE2_02_05");
	Wld_InsertNpc		(Waran,"SPAWN_OW_WARAN_EBENE2_02_05");
	Wld_InsertNpc		(Waran,"SPAWN_OW_WARAN_EBENE_02_05");
	Wld_InsertNpc		(FireWaran,"SPAWN_OW_WARAN_EBENE_02_05");
	Wld_InsertNpc		(Waran,"SPAWN_OW_WARAN_EBENE_02_05");
	
	
	Wld_InsertNpc		(Lurker,"SPAWN_OW_LURKER_RIVER2_BEACH3");


	Wld_InsertNpc		(Lurker,"SPAWN_OW_LURKER_RIVER2_BEACH3_2");
	
	
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_WOOD10_04");   
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_WOOD10_04");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_WOOD10_04");
	

	

	
		//------------Mordrags Weg vom Al ins NL-------------------------------//
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_06_04"); 
	Wld_InsertNpc		(OrcShaman_Sit,"SPAWN_OW_SCAVENGER_06_04");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_06_04");
	Wld_InsertNpc		(OrcWarrior_Roam,"SPAWN_OW_SCAVENGER_06_04");
			
	//H�hle vor Iceregion
	Wld_InsertNpc				(BDT_1000_Bandit_L,"LOCATION_23_CAVE_1_IN_1");	
	Wld_InsertNpc				(BDT_1007_Bandit_H,"LOCATION_23_CAVE_1_IN_1");
	Wld_InsertNpc				(BDT_1008_Bandit_H,"LOCATION_23_CAVE_1_IN_1");
	Wld_InsertNpc				(BDT_1003_Bandit_M,"LOCATION_23_CAVE_1_IN_1");

	Wld_InsertNpc				(BDT_1006_Bandit_H,"LOCATION_23_CAVE_1_OUT");

	//-----------------------bei DJG Swampcamp--------------------------
	Wld_InsertNpc		(Meatbug,"OW_SCAVENGER_AL_NL_SPAWN"); 
	Wld_InsertNpc		(Meatbug,"OW_SCAVENGER_AL_NL_SPAWN");
	Wld_InsertNpc		(Meatbug,"OW_SCAVENGER_AL_NL_SPAWN");
	Wld_InsertNpc		(Meatbug,"OW_SCAVENGER_AL_NL_SPAWN");
	Wld_InsertNpc		(Meatbug,"OW_SCAVENGER_AL_NL_SPAWN");

	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_SNAPPER_ENTRANCE_03");
	Wld_InsertNpc		(Meatbug,"FP_ROAM_OW_SNAPPER_ENTRANCE_01");

	//-------------SwampDragongebiet------------------
	

	Wld_InsertNpc		(Swampdrone,"FP_ROAM_SWAMP_ENTRANCE_01");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_SWAMP_ENTRANCE_02");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_SWAMP_ENTRANCE_02");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_SWAMP_ENTRANCE_02");

	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_02");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_03");

	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_2_02");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_SWAMP_3_01");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_3_02");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_4_01");
	Wld_InsertNpc		(Bloodfly,"FP_ROAM_SWAMP_4_02");

	Wld_InsertNpc		(Swampshark,"FP_ROAM_SWAMP_5_01");

	//Wld_InsertNpc		(Swampshark,"FP_ROAM_SWAMP_6_01");
	Wld_InsertNpc		(Swampshark,"FP_ROAM_SWAMP_6_02");

	Wld_InsertNpc		(Swampshark,"FP_ROAM_SWAMP_7_01");

	Wld_InsertNpc		(Swampdrone,"OW_DRAGONSWAMP_023");
	Wld_InsertNpc		(Swampdrone,"OW_DRAGONSWAMP_023");
	Wld_InsertNpc		(Swamprat,"OW_PATH_046");

	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_9_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_9_02");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_9_02");

	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_10_01");
	Wld_InsertNpc		(Swamprat,"FP_ROAM_SWAMP_10_01");

	Wld_InsertNpc		(Swamprat,"FP_ROAM_SWAMP_11_01");
	Wld_InsertNpc		(Swampdrone,"FP_ROAM_SWAMP_17_01");

	//Wld_InsertNpc		(Swampshark,"FP_ROAM_SWAMP_12_02");


	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_13_01");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_13_02");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_14_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_14_02");
	//Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_15_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_15_02");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_16_01");
	Wld_InsertNpc		(Draconian,"FP_ROAM_SWAMP_16_02");

	//------------------------------------------------------------

		// H�hle auf Bergweg vor Milten N�he Stonehenge
	Wld_InsertNpc		(DragonSnapper,"OW_PATH_07_15_CAVE3");
	Wld_InsertNpc		(DragonSnapper,	"OW_PATH_07_15");
	Wld_InsertNpc		(DragonSnapper,	"OW_PATH_07_15");
	Wld_InsertNpc		(DragonSnapper,	"OW_PATH_07_15");

	

	// Gebiet um Stonehenge

   	Wld_InsertNpc		(SkeletonMage_Angar,"OW_UNDEAD_DUNGEON_03"); //Joly: in der H�hle
   	Wld_InsertNpc		(Skeleton,			"FP_ROAM_OW_UNDEAD_DUNGEON_01"); 
	Wld_InsertNpc		(Skeleton,			"FP_ROAM_OW_UNDEAD_DUNGEON_04");
   	Wld_InsertNpc		(Skeleton,			"FP_ROAM_OW_UNDEAD_DUNGEON_02"); 

	Wld_InsertNpc		(Skeleton,			"OW_PATH_07_03");	
	Wld_InsertNpc		(Skeleton,			"OW_PATH_07_03");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_07_04");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_07_04");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_35");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_033_TO_CAVE5");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_033_TO_CAVE5");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_092");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_092");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_091");
	Wld_InsertNpc		(Skeleton,			"OW_PATH_036");

	Wld_InsertNpc		(Keiler,			"OW_PATH_274_RIGHT2");

	
	Wld_InsertNpc		(OrcWarrior_Roam,			"FP_ROAM_ORC_05");	
	Wld_InsertNpc		(OrcWarrior_Roam,			"FP_ROAM_ORC_06");	
	Wld_InsertNpc		(OrcWarrior_Roam,			"OW_PATH_3_06");



    //-------------------------FELSENFESTUNG: RockDragon------------------------
 	// Berggebiet vor Br�cke (ehemaliges Bloodhound-gebiet)

	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND01"); 
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND02");
	Wld_InsertNpc		(StoneGolem,"PLATEAU_ROUND04");
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND02_CAVE");
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND02_CAVE_MOVE");
	Wld_InsertNpc		(Draconian,"LOCATION_18_OUT");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04_RIGHT");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04_RIGHT");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04_SMALLPATH");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ROCK_DRACONIAN_09_1");
	Wld_InsertNpc		(Draconian,"FP_ROAM_OW_ROCK_DRACONIAN_07_1");
	

	//Serpentinenwge nach oben
	Wld_InsertNpc		(StoneGolem,"LOCATION_19_03");    
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND07");    
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND07");    
	Wld_InsertNpc		(Draconian,"PLATEAU_ROUND07");    
	Wld_InsertNpc		(Draconian,"LOCATION_19_01");
	Wld_InsertNpc		(Draconian,"LOCATION_19_02_1");


	    //Br�cke
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04_BRIDGE2");
	Wld_InsertNpc		(Draconian,"PATH_TO_PLATEAU04_BRIDGE2");
	    
		//Platz vor Fokusplattform & Eingang
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_PATH_RUIN5");    

	Wld_InsertNpc		(Draconian,"LOCATION_19_03_PATH_RUIN7"); 
		
	Wld_InsertNpc		(StoneGolem,"LOCATION_19_03_PATH_RUIN8");    
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_PATH_RUIN11");    
	
	Wld_InsertNpc		(Harpie,"LOCATION_19_03_PATH_RUIN13");    
	Wld_InsertNpc		(Harpie,"LOCATION_19_03_PATH_RUIN15");    
	Wld_InsertNpc		(Harpie,"LOCATION_19_03_PATH_RUIN16");    
		//EG: Leiterraum
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_PEMTAGRAM_ENTRANCE");    
	Wld_InsertNpc		(StoneGolem,"LOCATION_19_03_PEMTAGRAM_MOVEMENT");    
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_PENTAGRAMM");    
	
		//EG: Biblothek
	Wld_InsertNpc		(Harpie,"LOCATION_19_03_ROOM6");    
	Wld_InsertNpc		(Harpie,"LOCATION_19_03_ROOM6_BARRELCHAMBER");    
	
		//EG: Geheimkammer
	Wld_InsertNpc		(Demon,"LOCATION_19_03_ROOM6_BARRELCHAMBER2");
		
		//EG: Linker Raum
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_ROOM3");
	
		//1.OG: Raum links vorne
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_HARPYE1");
	Wld_InsertNpc		(StoneGolem,"LOCATION_19_03_SECOND_HARPYE2");
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_ETAGE6");
		
		//1.OG: Raum links hinten
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_HARPYE3");
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_HARPYE4");
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_ETAGE7");

		//Balkon vorne
	Wld_InsertNpc		(Draconian,"LOCATION_19_03_SECOND_ETAGE_BALCON2");
		

		//Burg zinnen
	Wld_InsertNpc		(Harpie,"OW_ROCKDRAGON_15");
	Wld_InsertNpc		(Harpie,"OW_ROCKDRAGON_14");
	Wld_InsertNpc		(Harpie,"OW_ROCKDRAGON_13");
		// beim Drachen
	Wld_InsertNpc		(Draconian,"OW_ROCKDRAGON_03");
	Wld_InsertNpc		(Draconian,"OW_ROCKDRAGON_07");

	

			
	//-----------------------ORK-GEBIET---------------------------------//
	
	Wld_InsertNpc	(Wolf,"OW_PATH_SNAPPER02_SPAWN01"); 
	Wld_InsertNpc	(Wolf,"OW_PATH_SNAPPER02_SPAWN01");
	Wld_InsertNpc	(Wolf,"OW_PATH_SNAPPER02_SPAWN01");
	Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_02_08");
	
	// �stlicher Zugang vom AL

		Wld_InsertNpc		(Wolf,"SPAWN_O_SCAVENGER_OCWOODL2");
		Wld_InsertNpc		(Bloodfly,"SPAWN_O_SCAVENGER_OCWOODL2");

		//der Wald
		Wld_InsertNpc		(Keiler,"FP_ROAM_OW_SCAVENGER_LONE_WALD_OC3");
		Wld_InsertNpc		(Keiler,"FP_ROAM_OW_SCAVENGER_LONE_WALD_OC3");
		Wld_InsertNpc		(Bloodfly,"SPAWN_OW_WOLF2_WALD_OC3");
		Wld_InsertNpc		(Bloodfly,"SPAWN_OW_WOLF2_WALD_OC3");

		Wld_InsertNpc		(Bloodfly,"SPAWN_WALD_OC_BLOODFLY01");
		Wld_InsertNpc		(Bloodfly,"SPAWN_WALD_OC_BLOODFLY01");
		Wld_InsertNpc		(Wolf,"SPAWN_OW_MOLERAT2_WALD_OC1");
		Wld_InsertNpc		(Wolf,"SPAWN_OW_MOLERAT2_WALD_OC1");
		Wld_InsertNpc		(Wolf,"SPAWN_OW_MOLERAT2_WALD_OC1");
	
		Wld_InsertNpc		(Snapper,"SPAWN_OW_SCAVENGER_OC_PSI_RUIN1");
		
		Wld_InsertNpc		(Wolf,"PATH_WALD_OC_MOLERATSPAWN");
		Wld_InsertNpc		(Wolf,"PATH_WALD_OC_MOLERATSPAWN");

		Wld_InsertNpc		(Wolf,"SPAWN_OW_WOLF2_WALD_OC2");
		Wld_InsertNpc		(Wolf,"SPAWN_OW_SCAVENGER_INWALD_OC2");

		// vor OC2
		Wld_InsertNpc		(Snapper,"SPAWN_OW_SCAVENGER_OC_PSI_RUIN1");
		Wld_InsertNpc		(Snapper,"SPAWN_OW_SCAVENGER_OC_PSI_RUIN1");

		Wld_InsertNpc		(Snapper,"SPAWN_OW_WARAN_OC_PSI3");
		Wld_InsertNpc		(Snapper,"SPAWN_OW_WARAN_OC_PSI3");

	// Kapitel2 Canyon "Gilbert�s H�hle"
		
		Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_OW_ORC5"); 
		Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_OW_ORC_MOVE");
	
		Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_OW_ORC3");
		Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_OW_ORC");
	
		Wld_InsertNpc	(Wolf,"FP_ROAM_OW_SNAPPER_OW_ORC");
	
		Wld_InsertNpc	(Wolf,"FP_ROAM_ORC_01");
		
		Wld_InsertNpc	(Wolf,"CASTLE_2"); 
	
		Wld_InsertNpc	(Waran,"OW_PATH_104");
		Wld_InsertNpc	(Waran,"OW_PATH_104");
			
		Wld_InsertNpc	(Wolf,"OW_PATH_BLACKWOLF07_SPAWN01");
		Wld_InsertNpc	(Wolf,"OW_PATH_BLACKWOLF07_SPAWN01");
		
		Wld_InsertNpc	(Waran,"CASTLE_3");
		Wld_InsertNpc	(Waran,"CASTLE_4");
		Wld_InsertNpc	(Waran,"OW_PATH_109");

	// westlicher Zugang vom AL

	
	Wld_InsertNpc	(Bloodfly,"OW_ORC_ORCDOG_MOVEMENT_02"); 
	
	
	Wld_InsertNpc	(Wolf,"OW_PATH_195");
	Wld_InsertNpc	(Wolf,"OW_PATH_195");

	Wld_InsertNpc	(Warg,"OW_ORC_ORCDOG_SPAWN01");
	Wld_InsertNpc	(Warg,"FP_ROAM_OW_WOLF_02_12");
	
	
	Wld_InsertNpc	(Bloodfly,"SPAWN_OW_MOLERAT_ORC_04");
	Wld_InsertNpc	(Bloodfly,"SPAWN_OW_MOLERAT_ORC_04");
	Wld_InsertNpc	(Bloodfly,"SPAWN_OW_MOLERAT_ORC_04");



	//Zugang von NL 
	
	Wld_InsertNpc	(Snapper,"SPAWN_OW_WOLF_NEAR_SHADOW3");
	
	Wld_InsertNpc	(Snapper,"OW_PATH_3_09");
	Wld_InsertNpc	(Snapper,"OW_PATH_3_09");
	Wld_InsertNpc	(Snapper,"OW_PATH_3_09"); 
	Wld_InsertNpc	(Snapper,"SPAWN_OW_SHADOWBEAST_10_03");
	Wld_InsertNpc	(Snapper,"SPAWN_OW_SHADOWBEAST_10_03");
	
	
	Wld_InsertNpc	(OrcShaman_Sit,"FP_ROAM_ORC_2_1_9");
	Wld_InsertNpc	(OrcWarrior_Roam,"OW_PATH_3_05");
	Wld_InsertNpc	(OrcWarrior_Roam,"FP_ROAM_ORC_2_1_8");
		
	

		//-----------------------Kastell FireDragon---------------------------------//
	
	
	Wld_InsertNpc	(FireWaran,	"CASTLE_5_1"); 
	Wld_InsertNpc	(FireWaran,	"CASTLE_5_1");
	Wld_InsertNpc	(FireWaran,	"CASTLE_5_1");
	
	
	Wld_InsertNpc	(FireWaran,	"CASTLE_8_1");
	Wld_InsertNpc	(FireWaran,	"CASTLE_8_1"); 
	Wld_InsertNpc	(FireWaran,	"CASTLE_8_1");
	
	
	Wld_InsertNpc	(FireGolem,	"FP_ROAM_CASTLE_8_02");
	Wld_InsertNpc	(Draconian,	"CASTLE_8");
	Wld_InsertNpc	(Draconian,	"CASTLE_8");
	Wld_InsertNpc	(Draconian,	"CASTLE_8");
	
	Wld_InsertNpc	(FireGolem,	"CASTLE_15");
	
	Wld_InsertNpc	(Draconian,	"CASTLE_16"); 
	Wld_InsertNpc	(Draconian,	"CASTLE_16");
	Wld_InsertNpc	(Draconian,	"CASTLE_18");
	Wld_InsertNpc	(Draconian,	"CASTLE_20");
	Wld_InsertNpc	(Draconian,	"CASTLE_22");
	Wld_InsertNpc	(Draconian,	"CASTLE_22");
	Wld_InsertNpc	(Draconian,	"CASTLE_27");
	
	Wld_InsertNpc	(Draconian,	"CASTLE_28");
	
	Wld_InsertItem	(ItMi_Zeitspalt_Addon,"OW_ITEM_FIREHORT_01");

	
		//-------Beim FireDragon--------//
	
	//Joly:Wld_InsertNpc	(Draconian,	"CASTLE_31");
	//Joly:Wld_InsertNpc	(Draconian,	"CASTLE_34");
	
		//---------------//
		
	Wld_InsertNpc	(FireGolem,	"OW_PATH_012");
	Wld_InsertNpc	(Draconian,	"OW_PATH_012");
	Wld_InsertNpc	(Draconian,	"OW_PATH_012");
	Wld_InsertNpc	(Draconian,	"OW_PATH_012");
	
		
	Wld_InsertNpc	(Draconian,	"PATH_CASTLE_TO_WATERFALL");
	Wld_InsertNpc	(Draconian,	"PATH_CASTLE_TO_WATERFALL");
	Wld_InsertNpc	(Draconian,	"PATH_CASTLE_TO_WATERFALL");
	

	//Wld_InsertNpc				(GRD_254_Orry,"OC1");
	//bis
	//Wld_InsertNpc				(Non_1500_Gilbert,"LOCATION_01_07");	


	//------------Toter Gardist---------------------------------------------
	//Wld_InsertNpc				(GRD_282_Nek,"");
	//var C_NPC nek; nek = Hlp_GetNpc(GRD_282_Nek);
	//Npc_ChangeAttribute	(nek, ATR_HITPOINTS, -nek.attribute[ATR_HITPOINTS_MAX]);
	
	
	// --------ITEMS in den vergessenen H�hlen/Locations -----------------
	//Wld_InsertItem			(ItArScrollIcecube,"FP_SLEEP_OW_SNAPPER_HERD1_02");
	//bis
	//Wld_InsertItem			(ItFo_POTION_HEALTH_03,"FP_ROAM_OW_LURKER_BEACH_04");
	

	//----------------------- MH: Monster werden neu verteilt ----------------------
	//Wld_InsertNpc		(Bloodhound, "OW_PATH_012");
	//bis	
	//Wld_InsertNpc	(Zombie4,			"MAGICTOWER_06"); 

};

	FUNC VOID INIT_SUB_SURFACE()
	{
		// ------ Xardas Turm ------- 
		Wld_AssignRoomToGuild("DT1", GIL_DMT);
		Wld_AssignRoomToGuild("DT2", GIL_DMT); //wichtig, damit Diego nicht folgt
		
		B_ENTER_OLDWORLD();
	};

FUNC VOID INIT_SURFACE ()
{
    B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();    
	
	INIT_SUB_SURFACE();
};



// ------  OLDWORLD.zen ------
FUNC VOID INIT_OLDWORLD ()
{
    B_StoreSonjaStats(Sonja);

	INIT_SUB_Oldcamp();
	INIT_SUB_Demontower();
	INIT_SUB_Surface();

    B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();    
	B_ENTER_OLDWORLD();

	if (MIS_ReadyForChapter4  == TRUE )	//Joly: mu� hier in der INIT ganz zum schluss stehen, nachdem alle NSCs f�rs Kapitel insertet wurden!!!
	&& (B_Chapter4_OneTime == FALSE)
	{
		B_Kapitelwechsel (4, OLDWORLD_ZEN);
		B_Chapter4_OneTime = TRUE;
	};

	B_ApplySonjaStats(Sonja);
};

FUNC VOID STARTUP_OLDWORLD ()
{
	Startup_Oldcamp();
	Startup_Demontower();
	Startup_Surface();
	Wld_SetTime	(00,00);//Joly:nachtstart wegen video
};

// *************
// Neue Oberwelt
// *************

// ------ CITY -------
func void STARTUP_NewWorld_Part_City_01()
{
	// Allgemein 
	// ----------------------
	// 5 - 6 Uhr Vorbereitung
	// 6 - 20 Uhr Arbeiten
	// 20 - 0 Uhr Freizeit
	// 0 - 5 Uhr Schlafen oder Kneipe
	// ------------------------------
	
	//ITEMS T�rme
	Wld_InsertItem (ItMw_Zweihaender1,"FP_CITY_WEAPON_01");//
	Wld_InsertItem (ItMw_Schwert,"FP_CITY_WEAPON_02");//
	Wld_InsertItem (ItMw_Zweihaender2,"FP_CITY_WEAPON_03");//
	Wld_InsertItem (ItMw_Schwert4,"FP_CITY_WEAPON_04");//
	Wld_InsertItem (ItMw_Kriegshammer2,"FP_CITY_WEAPON_05");//
	Wld_InsertItem (ItMw_ShortSword5,"FP_CITY_WEAPON_06");//
	
	Wld_InsertItem (Itke_Buerger,"FP_ITEM_OV_01");//
	Wld_InsertItem (ItWr_Pfandbrief_MIS,"FP_ITEM_OV_02");//
	
	//---S�dtor--------------------
	Wld_InsertNpc (Mil_309_Stadtwache	,"NW_CITY_ENTRANCE_01");	//Stadttorwache
	Wld_InsertNpc (Mil_310_Stadtwache	,"NW_CITY_ENTRANCE_01");	//Stadttorwache Important
	
	//---Hauptstrasse--------------
	Wld_InsertNpc (VLK_458_Rupert		, "NW_CITY_ENTRANCE_01");	//Essensstand, pennt bei Matteo - NW_City_Bed_Rupert
	Wld_InsertNpc (VLK_499_Buerger		, "NW_CITY_ENTRANCE_01");	//OV-B�rger. I�t an Stand, Smalltalk im OV, pennt iv ??? (OV)
	Wld_InsertNpc (VLK_416_Matteo		, "NW_CITY_ENTRANCE_01");	//Ausr�stungs-H�ndler, pennt in NW_City_Bed_Matteo
	Wld_InsertNpc (MIL_325_Miliz 		, "NW_CITY_ENTRANCE_01");	//TORWACHE vor Matteos Lager
	Wld_InsertNpc (VLK_425_Regis		, "NW_CITY_ENTRANCE_01");	//Bank, Abends Smalltalk vor Kneipe, nachts in Stadtkneipe.
	Wld_InsertNpc (VLK_451_Buerger		, "NW_CITY_ENTRANCE_01");	//Smalltalk mit 452, Smalltalk mit Thorben, nachts in Kneipe 
	Wld_InsertNpc (VLK_452_Buerger		, "NW_CITY_ENTRANCE_01");	//Smalltalk mit 451, pennt in OV - wo ???
	//-----------------------------
	Wld_InsertNpc (VLK_413_Bosper 		, "NW_CITY_ENTRANCE_01");	//Bogner, lebt und pennt in NW_CITY_BED_GRITTA
	Wld_InsertNpc (VLK_427_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Bospers Frau, Smalltalk mit 452, pennt in NW_CITY_MERCHANT_SHOP01_IN_01
	//-----------------------------
	Wld_InsertNpc (VLK_462_Thorben		, "NW_CITY_ENTRANCE_01"); 	//Schreiner, pennt in NW_CITY_BED_BOSPER
	Wld_InsertNpc (VLK_418_Gritta		, "NW_CITY_ENTRANCE_01"); 	//Nichte vom Schreiner - Mission "Kleid" - lebt und pennt in NW_CITY_BED_BOSPER_B
	//-----------------------------
	Wld_InsertNpc (VLK_412_Harad	 	, "NW_CITY_ENTRANCE_01");	//Schmied, pennt in NW_City_Bed_Harad
	Wld_InsertNpc (VLK_457_Brian		, "NW_CITY_ENTRANCE_01");	//Schmiedgehilfe, abends Smalltalk vor Kneipe, pennt in NW_City_Bed_Brian
	
	//--------------------Turm bei Gritta -----------------------
	Wld_InsertNpc (VLK_448_Joe			, "NW_CITY_ENTRANCE_01");	//Dieb wurde dummerweise eingesperrt
	//-----------------------------
	Wld_InsertNpc (Mil_319_Pablo		, "NW_CITY_ENTRANCE_01");	//Steckbrief-Miliz, Rotationswache Hauptstrasse/Kneipenstrasse/Vatras-Platz
	
	//---Alchemist-----------------
	Wld_InsertNpc (VLK_417_Constantino	, "NW_CITY_ENTRANCE_01");	//Alchemy Master, lebt und pennt in NW_City_Bed_Velax
	
	//---Kneipenstrasse und Vatras-Platz---
	Wld_InsertNpc (VLK_420_Coragon 		, "NW_CITY_ENTRANCE_01");	//Wirt Stadtkneipe 24h
	//------------------------------
	Wld_InsertNpc (Mil_323_Miliz		, "NW_CITY_ENTRANCE_01"); 	//Rotationswache Hauptstrasse/Kneipenstrasse/Vatras-Platz
	//------------------------------
	Wld_InsertNpc (VLK_439_Vatras	 	, "NW_CITY_ENTRANCE_01");	//24 im Schrein, betet nachts am Schrein
	Wld_InsertNpc (VLK_426_Buergerin	, "NW_CITY_ENTRANCE_01");	//Zuh�rerin, nachts vor Stadtkneipe
	Wld_InsertNpc (VLK_428_Buergerin	, "NW_CITY_ENTRANCE_01");	//Zuh�rerin, nachts Smalltalk Bierstand
	Wld_InsertNpc (VLK_450_Buerger		, "NW_CITY_ENTRANCE_01");	//Zuh�rer, nachts vor Stadtkneipe
	Wld_InsertNpc (VLK_454_Buerger		, "NW_CITY_ENTRANCE_01");	//Zuh�rer, nachts an Blubber
	Wld_InsertNpc (VLK_455_Buerger		, "NW_CITY_ENTRANCE_01");	//Zuh�rer, nachts Smalltalk Bierstand
	Wld_InsertNpc (VLK_421_Valentino	, "NW_CITY_ENTRANCE_01"); 	//OV-B�rger, 
	//------------------------------	
	Wld_InsertNpc (Mil_322_Miliz		, "NW_CITY_ENTRANCE_01");	//Rotationswache Hauptstrasse/Kneipenstrasse/Vatras-Platz
	
	//---Galgenplatz-------------------
	Wld_InsertNpc (VLK_4201_Wirt		, "NW_CITY_ENTRANCE_01"); 	//Bierstand Wirt, 24h
	Wld_InsertNpc (NOV_602_Ulf			, "NW_CITY_ENTRANCE_01");	//am saufen, 24h, ab Kap ??? wo?		
	Wld_InsertNpc (VLK_406_Herold		, "NW_CITY_ENTRANCE_01");	//HEROLD, pennt in OV oder Kaserne - wo ???
	Wld_InsertNpc (VLK_456_Abuyin		, "NW_CITY_ENTRANCE_01");	//Wasserpfeifen-H�ndler, pennt in Hotel
	Wld_InsertNpc (VLK_440_Bartok	 	, "NW_CITY_ENTRANCE_01");	//Bogenlehrer, nachts vor Stadtkneipe
	
	//---Hotel-------------------------
	Wld_InsertNpc (VLK_414_Hanna	 	, "NW_CITY_ENTRANCE_01"); 	//Hotelbesitzerin, 24h
	
	//---Marktplatz--------------------
	Wld_InsertNpc (VLK_407_Hakon		, "NW_CITY_ENTRANCE_01");	//Waffenh�ndler, nachts in Hotel
	Wld_InsertNpc (VLK_408_Jora			, "NW_CITY_ENTRANCE_01");	//Kr�mer, nachts in Hotel
	Wld_InsertNpc (VLK_409_Zuris		, "NW_CITY_ENTRANCE_01");	//Trankh�ndler, nachts in Zuris Haus
	Wld_InsertNpc (VLK_410_Baltram		, "NW_CITY_ENTRANCE_01");	//Lebensmittelh�ndler, nachts in Hotel
	Wld_InsertNpc (VLK_470_Sarah		, "NW_CITY_ENTRANCE_01");	//Waffenh�ndlerin (Canthars Opfer), nachts in Hotel
	Wld_InsertNpc (VLK_492_Rengaru		, "NW_CITY_ENTRANCE_01");	//Dieb, der wegrennt, wenn man ihn zur Rede stellt, nachts an Bierstand
	Wld_InsertNpc (KDF_511_Daron		, "NW_CITY_ENTRANCE_01");	//Magier auf Marktplats, nachts in Zuris Haus
	//---------------------------------
	Wld_InsertNpc (VLK_486_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Zuris Frau, nachts in Zuris Haus
	Wld_InsertNpc (VLK_495_Buergerin	, "NW_CITY_ENTRANCE_01");	//Coragons Frau, nachts in Kneipe (kocht)	
	Wld_InsertNpc (VLK_496_Buergerin	, "NW_CITY_ENTRANCE_01");	//OV-Frau, nachts ???		
	Wld_InsertNpc (VLK_497_Buergerin	, "NW_CITY_ENTRANCE_01");	//OV-Frau, nachts ???
	//---------------------------------
	Wld_InsertNpc (Mil_320_Miliz		, "NW_CITY_ENTRANCE_01");	//Marktplatzwache 24h
			
	//---Osttor------------------------
	Wld_InsertNpc (Mil_332_Stadtwache 	, "NW_CITY_ENTRANCE_01");	//Stadttorwache
	Wld_InsertNpc (Mil_333_Stadtwache 	, "NW_CITY_ENTRANCE_01");	//Stadttorwache Important

	//---------------------------------
	//---Weg zum Hafen-----------------
	Wld_InsertNpc (VLK_484_Lehmar		, "NW_CITY_ENTRANCE_01"); 	//Geldverleiher, hafen04, pennt in hafen04
	Wld_InsertNpc (VLK_488_Buergerin	, "NW_CITY_ENTRANCE_01");	//Lehmars Frau, pennt in hafen04
	Wld_InsertNpc (VLK_415_Meldor		, "NW_CITY_ENTRANCE_01"); 	//Einer von Lehmars Schl�gern, pennt in hafen03
	Wld_InsertNpc (VLK_487_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Meldors Frau, pennt in hafen03

	//---Platz A----------- (Fight Club)	
	Wld_InsertNpc (VLK_438_Alrik	 	, "NW_CITY_ENTRANCE_01");	//Kampf-Veranstalter, NW_City_Path_Habour_16_01, nachts in Hintrhof auf Bank
	Wld_InsertNpc (VLK_467_Buerger		, "NW_CITY_ENTRANCE_01"); 	//Kampf-Zuschauer, NW_City_Watch_Fight_01, nachts in Puff
	Wld_InsertNpc (VLK_475_Buerger		, "NW_CITY_ENTRANCE_01"); 	//Kampf-Zuschauer, NW_City_Watch_Fight_02, nachts in Puff
	Wld_InsertNpc (VLK_489_Buerger		, "NW_CITY_ENTRANCE_01"); 	//Kampf-Zuschauer, NW_City_Watch_Fight_03, nachts in Puff
		
	//---Platz B-----------	(Schrebergarten)
	//Alwins Frau und Fellans Frau

	//---Platz C----------- (Schlachter)
	Wld_InsertNpc (VLK_424_Alwin		, "NW_CITY_ENTRANCE_01");	//Metzger, pennt in hafen02 - NW_City_Habour_Hut_07_Bed_01
	Wld_InsertNpc (VLK_479_Lucy	, "NW_CITY_ENTRANCE_01"); 	//Alwins Frau, G�rtnerin, NW_City_Pick_02, pennt in hafen02
	Wld_InsertNpc (Hammel			, "NW_CITY_SHEEP_SPAWN_02");	//Schaf
	Wld_InsertNpc (Sheep			, "NW_CITY_SHEEP_SPAWN_01");	//Schaf
	Wld_InsertNpc (Sheep			, "NW_CITY_SHEEP_SPAWN_01");	//Schaf
	
	//---Ratten in Gasse---------------
	//Wld_InsertNpc (Giant_Rat			, "NW_CITY_RATS_01");		//Hintergasse 04/05/06
	//Wld_InsertNpc (Giant_Rat			, "NW_CITY_RATS_01");		//Hintergasse 04/05/06
		
	//---Platz D----------- (Arme Handwerker)
	Wld_InsertNpc (VLK_461_Carl			, "NW_CITY_ENTRANCE_01"); 	//Schmied, pennt in hafen07
	Wld_InsertNpc (VLK_429_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Carls Frau, pennt in hafen07
	Wld_InsertNpc (VLK_453_Buerger		, "NW_CITY_ENTRANCE_01");	//S�gt, pennt in hafen06
	Wld_InsertNpc (VLK_430_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Frau vom S�ger, pennt in hafen 06
	
	//---Forscher----------
	Wld_InsertNpc (VLK_498_Ignaz		, "NW_CITY_ENTRANCE_01"); 	//verr�ckter Forscher, hafen09, lebt und pennt da
	
	//---Platz E----------- (Edda)
	Wld_InsertNpc (VLK_471_Edda			, "NW_CITY_ENTRANCE_01"); 	//Kocht f�r die Armen, pennt in hafen08 - NW_City_Habour_Poor_Area_Hut_06_Bed_02
	//Bett frei (Bed_01)

	//---Platz F----------- (Fellan)
	Wld_InsertNpc (VLK_480_Fellan		, "NW_CITY_ENTRANCE_01"); 	//irrer H�mmerer, pennt in FELLAN - NW_City_Habour_Hut_05_Bed_01
	Wld_InsertNpc (VLK_478_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Fellans Frau, G�rtnerin, NW_City_Pick_01, pennt in FELLAN
	Wld_InsertNpc (VLK_481_Buerger		, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen01
	Wld_InsertNpc (VLK_482_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen01
	
	//---Platz G -----------
	Wld_InsertNpc (VLK_466_Gernod		, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen05
	Wld_InsertNpc (VLK_485_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Gernods Frau, pennt in hafen05
	
	//---Spazierg�nger f�r Hafen---------
	Wld_InsertNpc (VLK_459_Buerger		, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen10
	Wld_InsertNpc (VLK_472_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen10
	//--------------------------------
	Wld_InsertNpc (VLK_460_Buerger		, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen11
	Wld_InsertNpc (VLK_473_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//pennt in hafen11
	
	//---Hafen--------------
	Wld_InsertNpc (VLK_449_Lares		, "NW_CITY_ENTRANCE_01");	//Steht am Kai (PreStart 24h), dann nachts in Kneipe
	Wld_InsertNpc (VLK_444_Jack			, "NW_CITY_ENTRANCE_01");	//am Kai, wartet, da� der Leuchtturm frei wird

	//---Hafenkneipe---------
	Wld_InsertNpc (VLK_432_Moe	 		, "NW_CITY_ENTRANCE_01");	//Rausschmeisser 24h
	Wld_InsertNpc (VLK_431_Kardif	 	, "NW_CITY_ENTRANCE_01");	//24h Wirt
	Wld_InsertNpc (VLK_493_Nagur		, "NW_CITY_ENTRANCE_01");	//24h an Tisch in Hafenkneipe
	
	//---Puff-----------------
	Wld_InsertNpc (VLK_433_Bromor	 	, "NW_CITY_ENTRANCE_01");	//Puff-Besitzer hinter Theke, pennt in ???
	Wld_InsertNpc (VLK_434_Borka	 	, "NW_CITY_ENTRANCE_01");	//T�rsteher Puff 24h
	Wld_InsertNpc (VLK_435_Nadja	 	, "NW_CITY_ENTRANCE_01");	//pennt in ???
	Wld_InsertNpc (VLK_436_Sonja	 	, "NW_CITY_ENTRANCE_01");	//???
	Wld_InsertNpc (VLK_491_Vanja	 	, "NW_CITY_ENTRANCE_01");	//???
	
	//---Fischh�ndler------------------
	Wld_InsertNpc (VLK_469_Halvor	 	, "NW_CITY_ENTRANCE_01");	//hinter Stand, pennt in NW_City_Bed_Halvor
	Wld_InsertNpc (VLK_476_Fenia	   	, "NW_CITY_ENTRANCE_01"); 	//Halvors Frau, H�ndlerin auf Hafenstrasse, pennt in FISCH

	//---Kartenzeichner----------------
	Wld_InsertNpc (VLK_437_Brahim	 	, "NW_CITY_ENTRANCE_01"); 	//Kartenzeichner, pennt in KARTEN
	Wld_InsertNpc (VLK_477_Buergerin	, "NW_CITY_ENTRANCE_01"); 	//Brahims Frau, pennt in KARTEN

	//---Werft-------------------------
	Wld_InsertNpc (VLK_441_Garvell		, "NW_CITY_ENTRANCE_01");	//Bootsbauer, nachts in Kneipe
	Wld_InsertNpc (VLK_442_Arbeiter		, "NW_CITY_ENTRANCE_01");	//Werft Arbeiter, nachts vor Kneipe
	Wld_InsertNpc (VLK_443_Arbeiter		, "NW_CITY_ENTRANCE_01");	//Werft Arbeiter, nachts vor Kneipe

	//---Schiff--------------------
	Wld_InsertNpc (Pal_212_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//GateGuard, 24h
	Wld_InsertNpc (Pal_213_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//GateGuard, 24h 
	Wld_InsertNpc (Pal_220_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	Wld_InsertNpc (Pal_221_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	Wld_InsertNpc (Pal_222_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff 
	Wld_InsertNpc (Pal_223_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	Wld_InsertNpc (Pal_224_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff 
	Wld_InsertNpc (Pal_225_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	Wld_InsertNpc (Pal_226_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff 
	Wld_InsertNpc (Pal_227_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	Wld_InsertNpc (Pal_228_Schiffswache, "NW_CITY_ENTRANCE_01"); 	//auf dem Schiff
	
	//Items, die auf dem Schiff zu finden sind!
		
	Wld_InsertItem			(ItMi_Moleratlubric_MIS,"FP_ITEM_SHIP_07");	//zur Sicherheit f�r Vinos Brennerei!
	Wld_InsertItem			(ItSe_GoldPocket25,"FP_ITEM_SHIP_01"); 
	Wld_InsertItem			(ItRi_Prot_Point_02,"FP_ITEM_SHIP_02");
	Wld_InsertItem			(ItPo_Mana_03,"FP_ITEM_SHIP_03");
	Wld_InsertItem			(ItSe_GoldPocket25,"FP_ITEM_SHIP_04");
	Wld_InsertItem			(ItPo_Speed,"FP_ITEM_SHIP_05");
	Wld_InsertItem			(ItPo_Perm_STR,"FP_ITEM_SHIP_06");
	Wld_InsertItem			(ItPo_Health_03,"FP_ITEM_SHIP_08");
	Wld_InsertItem			(ItMiSwordraw,"FP_ITEM_SHIP_09");
	Wld_InsertItem			(ItSe_GoldPocket25,"FP_ITEM_SHIP_10");
	Wld_InsertItem			(ItSe_GoldPocket50,"FP_ITEM_SHIP_11");
	Wld_InsertItem			(ItSc_Zap,"FP_ITEM_SHIP_12");
	Wld_InsertItem			(ItSc_SumWolf,"FP_ITEM_SHIP_12");
	Wld_InsertItem			(ItSc_Sleep,"FP_ITEM_SHIP_12");
	Wld_InsertItem			(ItMi_nugget,"FP_ITEM_SHIP_13");
	Wld_InsertItem			(ItPo_Mana_02,"FP_ITEM_SHIP_14");
	Wld_InsertItem			(ItSe_GoldPocket25,"FP_ITEM_SHIP_15");

	//---PaladinCamp am Hafen---------
	Wld_InsertNpc (Pal_230_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_231_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_232_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_233_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_234_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_235_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_236_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_237_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_238_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_239_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_240_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Pal_241_Ritter, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (Mil_350_Addon_Martin, "NW_CITY_ENTRANCE_01"); 	
	Wld_InsertNpc (VLK_4301_Addon_Farim, "NW_CITY_ENTRANCE_01"); 	
	
	//---------------------------------
	//---Kaserne-----------------------
	Wld_InsertNpc (Mil_311_Andre		, "NW_CITY_ENTRANCE_01");	//Paladin, Milizkommandant
	
	Wld_InsertNpc (Mil_324_Peck			, "NW_CITY_ENTRANCE_01");	//Waffenausgabe, PreStart im Puff
	//***Gehilfe
	
	Wld_InsertNpc (Mil_312_Wulfgar		, "NW_CITY_ENTRANCE_01");	//1h - 60
	Wld_InsertNpc (Mil_317_Ruga			, "NW_CITY_ENTRANCE_01");	//2h - 60 und  STR Lehrer
	Wld_InsertNpc (Mil_313_Boltan		, "NW_CITY_ENTRANCE_01");	//Gef�ngnisw�rter
	//NEU Mortis: STR-Lehrer
	
	Wld_InsertNpc (Mil_327_Miliz		, "NW_CITY_ENTRANCE_01");	//SMALLTALK Partner von Boltan
	Wld_InsertNpc (Mil_314_Mortis		, "NW_CITY_ENTRANCE_01");	//Schmied
	Wld_InsertNpc (Mil_315_Kasernenwache, "NW_CITY_ENTRANCE_01");	//Schleifer
	
	Wld_InsertNpc (Mil_329_Miliz		, "NW_CITY_ENTRANCE_01");	//Azubi
 	Wld_InsertNpc (Mil_330_Miliz		, "NW_CITY_ENTRANCE_01");	//Azubi
	Wld_InsertNpc (Mil_331_Miliz		, "NW_CITY_ENTRANCE_01");	//Azubi
	Wld_InsertNpc (Mil_318_Miliz		, "NW_CITY_ENTRANCE_01");	// KasernenWache

	//---------Kanalisation ------------------
	Wld_InsertNpc (VLK_445_Ramirez		, "NW_CITY_ENTRANCE_01");	// 
	Wld_InsertNpc (VLK_446_Jesper		, "NW_CITY_ENTRANCE_01");	// 
	Wld_InsertNpc (VLK_447_Cassia		, "NW_CITY_ENTRANCE_01");	// 
	
	Wld_InsertNpc (Giant_Rat			, "NW_CITY_KANAL_ROOM_01_01");	// 
	Wld_InsertNpc (Giant_Rat			, "NW_CITY_KANAL_ROOM_01_02");	// 
	Wld_InsertNpc (Giant_Rat			, "NW_CITY_KANAL_ROOM_01_03");	// 
	Wld_InsertNpc (Giant_Rat			, "NW_CITY_KANAL_06");	// 
	Wld_InsertNpc (Giant_Rat			, "NW_CITY_KANAL_07");	// 
	//----------------------------------------------------------------
	Wld_InsertNpc	(Mil_328_Miliz, "NW_CITY_ENTRANCE_01");// Lagerhaus Wache
	//----------------------------------------------------------------

	//Wld_InsertNpc 	(VLK_474_Buerger	, "NW_CITY_ENTRANCE_01"); //
	//Wld_InsertNpc		(VLK_463_Buerger	, "NW_CITY_ENTRANCE_01"); // SMALLTALK  GEM�SE
	//Wld_InsertNpc		(VLK_464_Buerger	, "NW_CITY_ENTRANCE_01"); // SMALLTALK  GEM�SE
	//Wld_InsertNpc		(VLK_465_Buerger	, "NW_CITY_ENTRANCE_01"); // DRINKING 	GEM�SE
	
	//Wld_InsertNpc		(VLK_483_Buergerin	, "NW_CITY_ENTRANCE_01"); // SMALLTALK  GEM�SE
	//Wld_InsertNpc		(VLK_490_Buergerin	, "NW_CITY_ENTRANCE_01"); // SMALLTALK  GEM�SE

	//Wld_InsertNpc		(VLK_4200_Buergerin	, "NW_CITY_ENTRANCE_01"); //Smalltalk

	//ADDON>
	//Piratenlager an der K�ste
	Wld_InsertNpc	(PIR_1301_Addon_Skip_NW, "NW_CITY_ENTRANCE_01");
	//ADDON<

	//------------------------------------
	//---oberes Viertel-------------------
	//------------------------------------
	Wld_InsertNpc		(Mil_304_Torwache	, "NW_CITY_ENTRANCE_01");	//Torwache B�rgerviertel 24h
	Wld_InsertNpc		(Mil_305_Torwache	, "NW_CITY_ENTRANCE_01");	//Torwache B�rgerviertel Important 24h
	//------------------------------------
	Wld_InsertNpc		(PAL_200_Hagen			, "NW_CITY_ENTRANCE_01");// 
	Wld_InsertNpc		(PAL_201_Ingmar			, "NW_CITY_ENTRANCE_01");//Str-Lehrer
	Wld_InsertNpc		(PAL_202_Albrecht		, "NW_CITY_ENTRANCE_01");//Mana-Lehrer
	Wld_InsertNpc		(PAL_203_Lothar			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_204_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_205_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_206_Ritter			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_207_Girion			, "NW_CITY_ENTRANCE_01");//2H-Lehrer
	//NEU Cedric: 1H Lehrer
	Wld_InsertNpc		(PAL_208_Paladin		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_209_Paladin		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_210_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_211_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_214_Ritter			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_215_Ritter			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(PAL_216_Cedric			, "NW_CITY_ENTRANCE_01");//
	
	Wld_InsertNpc		(VLK_400_Larius			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_401_Cornelius		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_402_Richter		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_403_Gerbrandt		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_404_Lutero			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_405_Fernando		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_411_Gaertner		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_422_Salandril		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_419_Buerger		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4000_Buerger		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4001_Buergerin		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4002_Buergerin		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4003_Buergerin		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4004_Arbeiter		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(VLK_4005_Arbeiter		, "NW_CITY_ENTRANCE_01");//
	
	Wld_InsertNpc		(MIL_302_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_303_Torwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_306_Tuerwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_307_Tuerwache		, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_316_Wambo			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_321_Rangar			, "NW_CITY_ENTRANCE_01");//
	Wld_InsertNpc		(MIL_326_Miliz			, "NW_CITY_ENTRANCE_01");//
	
	//------------------------------------
	//---Insel-------------------
	//------------------------------------
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_01");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_03");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_05");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_07");//
	Wld_InsertItem 		(ItWr_OneHStonePlate2_Addon		, "FP_ROAM_INSEL_07");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_09");//
	Wld_InsertItem 		(ItWr_BowStonePlate2_Addon		, "FP_ROAM_INSEL_10");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_11");//
	Wld_InsertNpc		(Waran					, "FP_ROAM_INSEL_13");//


	//-------------------------------------
	//------ Muscheln --------
	//-------------------------------------
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_01");
	Wld_InsertItem		(ItWr_ManaStonePlate2_Addon, "FP_SHELLSPAWN_CITY_02");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_02");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_03");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_04");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_05");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_06");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_07");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_08");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_09");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_10");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_11");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_12");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_13");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_14");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_15");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_16");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_17");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_18");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_19");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_20");	
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_21");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_22");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_23");
	Wld_InsertItem		(ItMi_Addon_Shell_02, "FP_SHELLSPAWN_CITY_24");
	Wld_InsertItem		(ItMi_Addon_Shell_01, "FP_SHELLSPAWN_CITY_25");
	
};

	func void INIT_SUB_NewWorld_Part_City_01()
	{
		//---Laternen---
		Wld_SetMobRoutine (00,00, "FIREPLACE", 1);
		Wld_SetMobRoutine (20,00, "FIREPLACE", 1);
		Wld_SetMobRoutine (05,00, "FIREPLACE", 0);
		
		
		//---------------- PORTALR�UME ------------------------ 
		
		//Hafenviertel
		Wld_AssignRoomToGuild ("hafen01",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen02",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen03",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen04",		GIL_PUBLIC); //Lehmar
		Wld_AssignRoomToGuild ("hafen05",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen06",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen07",		GIL_VLK);
		
		if (Edda_Schlafplatz == TRUE)
		{
			Wld_AssignRoomToGuild ("hafen08",	GIL_NONE); //EDDA
		}
		else
		{
			Wld_AssignRoomToGuild ("hafen08",		GIL_VLK); //EDDA
		};
		Wld_AssignRoomToGuild ("hafen09",		GIL_PUBLIC); //Ignaz
		Wld_AssignRoomToGuild ("hafen10",		GIL_VLK);
		Wld_AssignRoomToGuild ("hafen11",		GIL_VLK);
		Wld_AssignRoomToGuild ("fellan",		GIL_VLK);
		//Wld_AssignRoomToGuild ("boot",			GIL_VLK); - ist RAUS
		Wld_AssignRoomToGuild ("fisch",			GIL_VLK);
		Wld_AssignRoomToGuild ("lagerhaus",		GIL_NONE);
		Wld_AssignRoomToGuild ("karten",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("hafenkneipe",	GIL_NONE);
		Wld_AssignRoomToGuild ("puff",			GIL_NONE);
		
		//Handwerker und H�ndler
		Wld_AssignRoomToGuild ("bogner",		GIL_PUBLIC);		// = Thorben und Gritta!
		Wld_AssignRoomToGuild ("matteo",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("hotel",			GIL_NONE);
		Wld_AssignRoomToGuild ("stadtkneipe",	GIL_NONE);
		Wld_AssignRoomToGuild ("zuris",			GIL_VLK);
		
		if (Player_IsApprentice == APP_Constantino)
		{
			Wld_AssignRoomToGuild ("alchemist",	GIL_NONE);
		}
		else
		{
			Wld_AssignRoomToGuild ("alchemist",	GIL_PUBLIC);
		};
		
		if (Player_IsApprentice == APP_Bosper)
		{
			Wld_AssignRoomToGuild ("gritta",	GIL_NONE);		// = BOSPER!
		}
		else
		{
			Wld_AssignRoomToGuild ("gritta",	GIL_PUBLIC); 	// = BOSPER!
		};
		
		if (Player_IsApprentice == APP_Harad)
		{
			Wld_AssignRoomToGuild ("schmied",	GIL_NONE);
		}
		else
		{
			Wld_AssignRoomToGuild ("schmied",	GIL_VLK);
		};
		
		//T�rme
		Wld_AssignRoomToGuild ("turmsued01",	GIL_MIL);
		Wld_AssignRoomToGuild ("turmsued02",	GIL_MIL);
		Wld_AssignRoomToGuild ("turmost01",		GIL_MIL);
		Wld_AssignRoomToGuild ("turmost02",		GIL_MIL);
		Wld_AssignRoomToGuild ("turmschmied",	GIL_MIL);
		Wld_AssignRoomToGuild ("turmbogner",	GIL_MIL);
		
		//Kaserne 
		Wld_AssignRoomToGuild ("andre",			GIL_PUBLIC);
		Wld_AssignRoomToGuild ("waffenkammer",	GIL_PUBLIC);
		Wld_AssignRoomToGuild ("barracke",		GIL_MIL);
		
		//Oberes Viertel
		Wld_AssignRoomToGuild ("nwcityrich01", 	GIL_MIL);
		Wld_AssignRoomToGuild ("rathaus",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("reich01",		GIL_VLK);
		Wld_AssignRoomToGuild ("reich02",		GIL_VLK);
		Wld_AssignRoomToGuild ("reich03",		GIL_VLK);
		Wld_AssignRoomToGuild ("reich04",		GIL_VLK);
		Wld_AssignRoomToGuild ("reich05",		GIL_VLK);
		Wld_AssignRoomToGuild ("reich06",		GIL_PUBLIC); //Salandril Alchemist -> Wegen Mission!!!
		Wld_AssignRoomToGuild ("richter",		GIL_PUBLIC); //wegen SLD Mission Kap.3 
		Wld_AssignRoomToGuild ("leomar",		GIL_VLK);
	};

func void INIT_NewWorld_Part_City_01()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();

	INIT_SUB_NewWorld_Part_City_01();
};


// ------ Farm1 -------

func void STARTUP_NewWorld_Part_Farm_01()
{
	//---NSCs---
	Wld_InsertNpc		(BAU_954_Maleth, 		"NW_FARM1_OUT_01"); //erster Hirte
	Wld_InsertNpc		(BAU_950_Lobart, 		"NW_FARM1_OUT_01");
	Wld_InsertNpc		(BAU_951_Hilda, 		"NW_FARM1_OUT_01");
	
	Wld_InsertNpc		(BAU_952_Vino, 			"NW_FARM1_OUT_01");
	Wld_InsertNpc		(BAU_953_Bauer, 		"NW_FARM1_OUT_01");
	Wld_InsertNpc		(BAU_955_Bauer, 		"NW_FARM1_OUT_01");

	Wld_InsertNpc		(VLK_468_Canthar, 		"NW_FARM1_OUT_01"); 
	
	//---Schafherde---
	Wld_InsertNpc		(Hammel, 	"NW_FARM1_PATH_CITY_SHEEP_07");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_07");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_07");
	Wld_InsertNpc		(Hammel, 	"NW_FARM1_PATH_CITY_SHEEP_08");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_08");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_08");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_09");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_09");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_09");
	
	//---Schafe auf dem Hof---
	Wld_InsertNpc		(Hammel, 	"NW_FARM1_PATH_CITY_SHEEP_10");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_10");
	Wld_InsertNpc		(Hammel, 	"NW_FARM1_PATH_CITY_SHEEP_11");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_11");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_12");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_PATH_CITY_SHEEP_12");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_OUT_03");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_OUT_03");
	
	//---Schafe bei der Windm�hle---
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_MILL_01");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_MILL_01");
	Wld_InsertNpc		(Sheep, 	"NW_FARM1_MILL_01");

	//---Monster zur Stadt---
	Wld_InsertNpc		(YBloodfly, "NW_FARM1_PATH_SPAWN_02");
	Wld_InsertNpc		(YBloodfly, "NW_FARM1_PATH_SPAWN_02");
	Wld_InsertNpc		(YBloodfly, "NW_FARM1_PATH_SPAWN_02");

	Wld_InsertNpc		(YWolf,		"NW_FARM1_PATH_SPAWN_07");
	Wld_InsertNpc		(YWolf, 	"NW_FARM1_PATH_SPAWN_07");

	Wld_InsertNpc		(YGobbo_Green,"NW_FARM1_PATH_CITY_19_B");

	Wld_InsertNpc		(YBloodfly, "NW_FARM1_PATH_CITY_10_B");
	Wld_InsertNpc		(YBloodfly, "NW_FARM1_PATH_CITY_10_B");

	Wld_InsertNpc		(YWolf,		"NW_FARM1_PATH_CITY_05_B");
	Wld_InsertNpc		(YWolf,		"NW_FARM1_PATH_CITY_05_B");
	
	//---GIANT BUGS---
	Wld_InsertNpc		(YGiant_Bug, 	"NW_FARM1_CITYWALL_RIGHT_02");	


	Wld_InsertNpc		(YGiant_Bug, 	"NW_FARM1_OUT_13");	
	
	//---Stonehendge ---

	Wld_InsertNpc		(YGiant_Bug_VinoRitual1, 	"NW_FARM1_OUT_15");	
	Wld_InsertNpc		(YGiant_Bug_VinoRitual2, 	"NW_FARM1_OUT_15");	
	Wld_InsertItem		(ItWr_HitPointStonePlate1_Addon, 	"FP_ITEM_HERB_11");	

	//---Kapitel2 Waldgraben---
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_02_B"); 
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_02_B");
	
	Wld_InsertNpc		(Snapper, 	"NW_FARM1_CITYWALL_05");
	Wld_InsertNpc		(Snapper, 	"NW_FARM1_CITYWALL_05");
	Wld_InsertNpc		(Snapper, 	"NW_FARM1_CITYWALL_05");
	
	Wld_InsertNpc		(Wolf, 		"NW_FARM1_CITYWALL_FOREST_03");
	Wld_InsertNpc		(Wolf, 		"NW_FARM1_CITYWALL_FOREST_03");
	Wld_InsertNpc		(Wolf, 		"NW_FARM1_CITYWALL_FOREST_03");
	
	Wld_InsertNpc		(Shadowbeast, "NW_FARM1_CITYWALL_FOREST_04_B");
	
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_FOREST_06");
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_FOREST_06");
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_FOREST_06");
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_FOREST_06");
	Wld_InsertNpc		(Bloodfly,	"NW_FARM1_CITYWALL_FOREST_06");

	Wld_InsertNpc		(OrcWarrior_Harad, "NW_FARM1_CITYWALL_FOREST_08_B");

	Wld_InsertNpc		(Gobbo_Black, 	"NW_FARM1_CITYWALL_FOREST_14");
	Wld_InsertNpc		(Gobbo_Black, 	"NW_FARM1_CITYWALL_FOREST_14");
	Wld_InsertNpc		(Gobbo_Black,	"NW_FARM1_CITYWALL_FOREST_15");
	Wld_InsertNpc		(Gobbo_Black, 	"NW_FARM1_CITYWALL_FOREST_15");
	Wld_InsertNpc		(Gobbo_Black, 	"NW_FARM1_CITYWALL_FOREST_16");
	
	//---FARM1CAVE---
	Wld_InsertNpc		(BDT_1000_Bandit_L, 	"NW_FARM1_BANDITS_CAVE_06");
	Wld_InsertNpc		(BDT_1001_Bandit_L, 	"NW_FARM1_BANDITS_CAVE_07");
	Wld_InsertNpc		(BDT_1002_Bandit_L, 	"NW_FARM1_BANDITS_CAVE_08");
	
	Wld_InsertItem		(ItWr_BowStonePlate2_Addon, 	"FP_STAND_DEMENTOR_KDF_29");
	
	Wld_InsertNpc		(BDT_1001_Bandit_L, 	"NW_FARM1_BANDITS_CAVE_03");
};

	func void INIT_SUB_NewWorld_Part_Farm_01()
	{
		Wld_AssignRoomToGuild ("farm01", GIL_PUBLIC);	//hildas Raum
		Wld_AssignRoomToGuild ("farm02", GIL_PUBLIC);  	//Scheune 
		if (Lobart_Kleidung_Verkauft == TRUE)
		{
			Wld_AssignRoomToGuild ("farm03", GIL_NONE);  	//Schlaf Raum
		}
		else
		{		
			Wld_AssignRoomToGuild ("farm03", GIL_PUBLIC);  	//Schlaf Raum
		};
		
	};
	
func void INIT_NewWorld_Part_Farm_01()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_NewWorld_Part_Farm_01();
};


// ------ Xardas -------
func void STARTUP_NewWorld_Part_Xardas_01()
{
	Wld_InsertItem (ItBE_Addon_STR_5, "FP_SPAWN_X_GUERTEL");

	////////////////////////////////////////////////////////////////////////////
	//----------------------- Spielstart Gothic2------------------------------//
	////////////////////////////////////////////////////////////////////////////

	//---NSCs---
	Wld_InsertNpc		(NONE_100_Xardas, 	"NW_XARDAS_START");
	Wld_InsertNpc		(PC_Psionic, 		"NW_XARDAS_TOWER_PATH_01");
		
	Wld_InsertItem 		(ItWr_StonePlateCommon_Addon,		"FP_ITEM_XARDAS_STPLATE_01");//ADDON
	Wld_InsertItem 		(Itke_Xardas,		"FP_ITEM_XARDAS_07");

	Wld_InsertNpc		(BDT_1013_Bandit_L, "NW_XARDAS_STAIRS_01");
	Wld_InsertNpc		(BDT_1014_Bandit_L, "NW_XARDAS_BANDITS_LEFT");
	Wld_InsertNpc		(BDT_1015_Bandit_L, "NW_XARDAS_BANDITS_RIGHT");
	//---Monster auf dem Weg zu Farm1---
	Wld_InsertNpc		(Sheep, 			"NW_XARDAS_TOWER_04");
	
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_PATH_FARM1_11");
	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_GOBBO_01");
	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_GOBBO_02");
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_MONSTER_INSERT_01");
	
	//---Xardas Secret---
	Wld_InsertNpc		(Keiler,		"FP_ROAM_XARDAS_SECRET_23");
	Wld_InsertNpc		(Keiler,		"FP_ROAM_XARDAS_SECRET_23");

	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_08");
	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_08");

	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_15");
	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_15");

	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_04");
	Wld_InsertNpc		(Waran,		"FP_ROAM_XARDAS_SECRET_04");

	Wld_InsertNpc		(Giant_Rat,		"FP_ROAM_XARDAS_SECRET_27");
	Wld_InsertNpc		(Giant_Rat,		"FP_ROAM_XARDAS_SECRET_27");

	Wld_InsertNpc		(Meatbug,		"FP_ROAM_XARDAS_SECRET_01");
	Wld_InsertNpc		(Meatbug,		"FP_ROAM_XARDAS_SECRET_01");

	//---H�hlengang---
	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_TOWER_WATERFALL_CAVE_03");

	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_TOWER_WATERFALL_CAVE_ENTRANCE_02");

	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_TOWER_WATERFALL_CAVE_ENTRANCE_05");
	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_TOWER_WATERFALL_CAVE_ENTRANCE_05");
	Wld_InsertNpc		(YGobbo_Green,		"NW_XARDAS_TOWER_WATERFALL_CAVE_ENTRANCE_GOBBO");

	Wld_InsertNpc		(YGiant_Bug, 		"NW_XARDAS_TOWER_WATERFALL_CAVE_SIDE_02"); 
	Wld_InsertNpc		(YGiant_Bug, 		"NW_XARDAS_TOWER_WATERFALL_CAVE_SIDE_02");

	//---im Tal---
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_VALLEY_03"); 
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_VALLEY_04");  
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_VALLEY_06"); 
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_VALLEY_08"); 

	Wld_InsertNpc		(YGiant_Rat, 		"NW_XARDAS_TOWER_VALLEY_RAT"); 
	Wld_InsertNpc		(YWolf, 			"NW_XARDAS_TOWER_VALLEY_WOLF");
	
	Wld_InsertNpc		(YBloodfly, 		"NW_XARDAS_TOWER_VALLEY_08");

	//---kleine H�hle im Tal---
	Wld_InsertNpc		(YGiant_Rat, 		"NW_XARDAS_TOWER_SECRET_CAVE_01"); 
	Wld_InsertNpc		(YGiant_Rat, 		"NW_XARDAS_TOWER_SECRET_CAVE_01");
	Wld_InsertNpc		(YGiant_Rat, 		"NW_XARDAS_TOWER_SECRET_CAVE_01");
	
	Wld_InsertNpc		(YGiant_Rat, 		"NW_XARDAS_TOWER_SECRET_CAVE_03");
	
	//ADDON	
	Wld_InsertNpc		(Bau_4300_Addon_Cavalorn, 		"NW_XARDAS_START");
	Wld_InsertNpc		(PIR_1300_Addon_Greg_NW, 		"FARM1");

};

	func void INIT_SUB_NewWorld_Part_Xardas_01()
	{
	};

func void INIT_NewWorld_Part_Xardas_01()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();	
	
	INIT_SUB_NewWorld_Part_Xardas_01();
};


// KLOSTER 
FUNC VOID STARTUP_NewWorld_Part_Monastery_01 ()
{
	Wld_InsertItem 	(ItWr_Manarezept, 	"FP_ITEM_KLOSTER_01");
	
	Wld_InsertNpc 	(PAL_299_Sergio, 	"NW_MONASTERY_ENTRY_01");
	
	Wld_InsertNpc 	(KDF_500_Pyrokar, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_501_Serpentes, "NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_502_Ulthar,	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_503_Karras, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_504_Parlan, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_505_Marduk, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_506_Neoras, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_507_Talamon, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_508_Gorax, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_509_Isgaroth,  "NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(KDF_510_Hyglas, 	"NW_MONASTERY_ENTRY_01");
	
	Wld_InsertNpc 	(NOV_600_Pedro,  	"NW_MONASTERY_ENTRY_01");	//steht vor dem Kloster
	Wld_InsertNpc 	(NOV_601_Igaraz, 	"NW_MONASTERY_ENTRY_01");	//Erw�hlter im Smalltalk im Hof
	Wld_InsertNpc 	(NOV_603_Agon, 		"NW_MONASTERY_ENTRY_01");	//Kr�utergarten
	Wld_InsertNpc 	(NOV_604_Dyrian, 	"NW_MONASTERY_ENTRY_01");	//
	Wld_InsertNpc 	(NOV_605_Opolos, 	"NW_MONASTERY_ENTRY_01");	//H�tet Schafe
	Wld_InsertNpc 	(NOV_606_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(NOV_607_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(NOV_608_Garwig, 	"NW_MONASTERY_ENTRY_01");	//Bewacht den Hammer
	Wld_InsertNpc 	(NOV_609_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(NOV_610_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(NOV_611_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(NOV_612_Babo, 		"NW_MONASTERY_ENTRY_01");	//Fegt den Hof
	Wld_InsertNpc 	(NOV_615_Novize, 	"NW_MONASTERY_ENTRY_01");
	Wld_InsertNpc 	(Sheep, 			"FP_ROAM_MONASTERY_01");
	Wld_InsertNpc 	(Sheep, 			"FP_ROAM_MONASTERY_02");
	Wld_InsertNpc 	(Sheep, 			"FP_ROAM_MONASTERY_03");
			
	Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_AREA_11");
	Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_AREA_11");

	Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_MONSTER22");
	Wld_InsertItem 	(ItWr_BowStonePlate1_Addon, 			"FP_ROAM_NW_NW_PATH_TO_MONASTER_MONSTER22_03");
	Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, 			"FP_ITEM_MONASTERY_01");

	Wld_InsertNpc 	(Scavenger, 			"NW_PATH_TO_MONASTER_AREA_01");

	Wld_InsertNpc 	(Giant_Rat, 			"NW_PATH_TO_MONASTER_AREA_02");

	Wld_InsertNpc 	(Giant_Rat, 			"NW_PATH_TO_MONASTER_AREA_10");
	Wld_InsertNpc 	(Giant_Rat, 			"NW_PATH_TO_MONASTER_AREA_10");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_PATH_TO_MONASTER_AREA_08");

	Wld_InsertNpc 	(Giant_Rat, 			"NW_SHRINE_MONSTER");

	Wld_InsertNpc 	(Scavenger, 			"NW_FOREST_CONNECT_MONSTER2");
};

	FUNC VOID INIT_SUB_NewWorld_Part_Monastery_01()
	{
		Wld_AssignRoomToGuild ("kloster01",GIL_PUBLIC); //Kirche
		Wld_AssignRoomToGuild ("kloster02",GIL_PUBLIC); //B�cherei
		Wld_AssignRoomToGuild ("kloster03",GIL_PUBLIC); //Kapelle 
		
		Wld_AssignRoomToGuild ("kloster11",GIL_PUBLIC); //Der Keller
		Wld_AssignRoomToGuild ("kloster13",GIL_PUBLIC); //Weinkelterei
		
		Wld_AssignRoomToGuild ("kloster04",GIL_NOV); //Schlafraum Novizen
		Wld_AssignRoomToGuild ("kloster05",GIL_NOV); //Schlafraum Novizen
		Wld_AssignRoomToGuild ("kloster10",GIL_NOV); //Schlafraum Novizen
		Wld_AssignRoomToGuild ("kloster12",GIL_NOV); //Schlafraum Novizen
		
		Wld_AssignRoomToGuild ("kloster06",GIL_KDF); //Schlafraum Magier
		Wld_AssignRoomToGuild ("kloster07",GIL_KDF); //Schlafraum Magier
		Wld_AssignRoomToGuild ("kloster08",GIL_KDF); //Schlafraum Magier
		Wld_AssignRoomToGuild ("kloster09",GIL_KDF); //Schlafraum Magier
	};

FUNC VOID INIT_NewWorld_Part_Monastery_01 ()
{
	B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();	
	
	INIT_SUB_NewWorld_Part_Monastery_01();
};


//---Der grosse Bauernhof--------


FUNC VOID STARTUP_NewWorld_Part_GreatPeasant_01 ()
{
	// ------ Vorposten
	Wld_InsertNpc 	(SLD_802_Buster, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_827_Soeldner, 	"BIGFARM");
	
	// ------ Feldr�uberh�hle ------
	
	//3 rausgenommen, wegen Fester-> werden sp�ter insertet
	
	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FELDREUBER"); 
	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FELDREUBER2");
	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FELDREUBER4");
	
	Wld_InsertNpc (Giant_Bug, "FP_ROAM_MONSTERMILL_11");
	Wld_InsertNpc (Giant_Bug, "FP_ROAM_MONSTERMILL_13");
	Wld_InsertNpc (Giant_Bug, "FP_ROAM_MONSTERMILL_04");
	Wld_InsertNpc (Giant_Bug, "FP_ROAM_MONSTERMILL_03");
	
	
	//BIGMILL Felder
	Wld_InsertNpc (Lurker, "NW_BIGMILL_FIELD_MONSTER_03");
	Wld_InsertNpc (Lurker, "NW_BIGMILL_FIELD_MONSTER_03");

	Wld_InsertItem (ItWr_OneHStonePlate1_Addon, "FP_ROAM_NW_BIGMILL_FIELD_MONSTER_04_03");
	
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_01");
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_01");
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_01");
	
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_02");
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_02");
	Wld_InsertNpc (Giant_Bug, "NW_BIGMILL_FIELD_MONSTER_02");
	
	//2 Bugs rausgenommen, wegen Fester

	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FIELD_MONSTER_01");
	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FIELD_MONSTER_01");
	Wld_InsertNpc (Giant_Bug, "NW_BIGFARM_FIELD_MONSTER_01");

	// NSCs
	Wld_InsertNpc 	(BAU_900_Onar, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_901_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_902_Gunnar, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_903_Bodo, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_904_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_905_Bauer, 	"BIGFARM");
	//Wld_InsertNpc 	(BAU_906_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_907_Wasili, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_908_Hodges, 	"BIGFARM");
	//Wld_InsertNpc 	(BAU_909_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_910_Maria, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_911_Elena, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_912_Pepe, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_913_Thekla, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_914_Baeuerin, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_915_Baeuerin, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_916_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_917_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_918_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_919_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_920_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_921_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_980_Sagitta, 	"BIGFARM");
	
	
	Wld_InsertNpc 	(SLD_800_Lee, 		"BIGFARM");
	Wld_InsertNpc 	(SLD_801_Torlof, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_803_Cipher, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_804_Rod, 		"BIGFARM");
	Wld_InsertNpc 	(SLD_805_Cord, 		"BIGFARM");
	Wld_InsertNpc 	(SLD_806_Sylvio, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_807_Bullco, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_808_Jarvis, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_809_Bennet, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_810_Dar, 		"BIGFARM");
	Wld_InsertNpc 	(SLD_811_Wolf, 		"BIGFARM");

	Wld_InsertNpc 	(SLD_814_Sentenza, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_815_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_816_Fester, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_817_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_818_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_819_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_820_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_821_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_822_Raoul, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_823_Khaled, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_824_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_825_Soeldner, 	"BIGFARM");
	Wld_InsertNpc 	(SLD_826_Soeldner, 	"BIGFARM");


	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_01");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_01");
	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_SHEEP1_01");

	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_02");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_02");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_02");

	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_SHEEP1_03");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_03");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP1_03");

	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_12");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_13");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_14");

	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_07");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_08");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_BIGFARM_SHEEP2_09");

	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_SHEEP2_02");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP2_02");

	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_SHEEP2_03");
	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_SHEEP2_03");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP2_03");

	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP2_04");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_SHEEP2_04");


	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_KITCHEN_OUT_02");
	Wld_InsertNpc 	(Sheep, 		"NW_BIGFARM_KITCHEN_OUT_02");
	Wld_InsertNpc 	(Hammel, 		"NW_BIGFARM_KITCHEN_OUT_02");

	
	//Farm3

	Wld_InsertNpc 	(BAU_960_Bengar, 		"BIGFARM");

	Wld_InsertNpc 	(BAU_961_Gaan, 			"BIGFARM");

	Wld_InsertNpc 	(Gaans_Snapper, 		"NW_FARM3_BIGWOOD_04");  

	Wld_InsertNpc 	(BAU_962_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_963_Malak, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_964_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_965_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_966_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_967_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_968_Bauer, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_969_Bauer, 		"BIGFARM");
	
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_FARM3_OUT_05_01");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_FARM3_OUT_05_02");
	Wld_InsertNpc 	(Hammel, 		"FP_ROAM_NW_FARM3_OUT_05_03");
	Wld_InsertNpc 	(Sheep, 		"FP_ROAM_NW_FARM3_OUT_05_04");

	
	//Farm4
	
	Wld_InsertNpc 	(BAU_930_Sekob, 	"BIGFARM");  
	Wld_InsertNpc 	(BAU_931_Till, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_932_Balthasar, "BIGFARM");

	Wld_InsertNpc 	(Balthasar_Sheep1, "NW_FARM4_BALTHASAR");	
	Wld_InsertNpc 	(Balthasar_Sheep2, "NW_FARM4_BALTHASAR");	
	Wld_InsertNpc 	(Balthasar_Sheep3, "NW_FARM4_BALTHASAR");	
	
	Wld_InsertNpc 	(BAU_933_Rega, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_934_Babera, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_935_Bronko, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_936_Rosi, 		"BIGFARM");
	Wld_InsertNpc 	(BAU_937_Bauer, 	"BIGFARM");
	Wld_InsertNpc 	(BAU_938_Bauer, 	"BIGFARM");

	//Holzf�ller\J�ger
	Wld_InsertNpc 	(BAU_981_Grom, 	"BIGFARM");

	// Monster
	//***************************************************************************************

	Wld_InsertNpc 	(Scavenger,	"NW_TAVERNE_TROLLAREA_MONSTER_01_01"); 


 	Wld_InsertNpc 	(Zombie02,	"NW_FARM2_TAVERNCAVE1_09"); 
	Wld_InsertNpc 	(Zombie03,	"NW_FARM2_TAVERNCAVE1_10"); 
	Wld_InsertNpc 	(Zombie04,	"NW_FARM2_TAVERNCAVE1_08"); 

	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM2_TAVERNCAVE1_02"); 
	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM2_TAVERNCAVE1_02"); 
	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM2_TAVERNCAVE1_02"); 

 	Wld_InsertNpc 	(Wolf,	"NW_TAVERNE_TROLLAREA_MONSTER_04_01"); 
	Wld_InsertNpc 	(Wolf,	"NW_TAVERNE_TROLLAREA_MONSTER_04_01"); 

  	Wld_InsertNpc 	(Gobbo_Green,	"NW_TAVERNE_TROLLAREA_MONSTER_05_01"); 
	Wld_InsertNpc 	(Gobbo_Green,	"NW_TAVERNE_TROLLAREA_MONSTER_05_01"); 
  	Wld_InsertNpc 	(Gobbo_Green,	"NW_TAVERNE_TROLLAREA_MONSTER_05_01"); 

  	Wld_InsertNpc 	(Wolf,	"NW_BIGFARM_LAKE_MONSTER_01_01"); 
	Wld_InsertNpc 	(Wolf,	"NW_BIGFARM_LAKE_MONSTER_01_01"); 

  	Wld_InsertNpc 	(Lurker,	"NW_BIGFARM_LAKE_MONSTER_02_01"); 
	Wld_InsertNpc 	(Lurker,	"NW_BIGFARM_LAKE_MONSTER_02_01"); 
  	Wld_InsertNpc 	(Bloodfly,	"NW_BIGFARM_LAKE_MONSTER_02_01"); 

  	Wld_InsertNpc 	(Wolf,	"NW_BIGFARM_LAKE_MONSTER_03_01"); 
	Wld_InsertNpc 	(Wolf,	"NW_BIGFARM_LAKE_MONSTER_03_01"); 

  	Wld_InsertNpc 	(Lurker,	"NW_LAKE_GREG_TREASURE_01"); 


//J�gerlager

	Wld_InsertNpc 	(BAU_983_Dragomir,	"NW_CITY_TO_LIGHTHOUSE_13_MONSTER5"); 
	Wld_InsertItem	(ItRw_DragomirsArmbrust_MIS , "FP_NW_ITEM_TROLL_06"); 
	Wld_InsertNpc 	(BAU_984_Niclas,	"NW_TAVERNE_TROLLAREA_MONSTER_02_01"); 
	


	// Kap3

 	Wld_InsertNpc 	(Warg,	"NW_FARM4_WOOD_MONSTER_01"); 
	Wld_InsertNpc 	(Warg,	"NW_FARM4_WOOD_MONSTER_01"); 

 	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_02"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_02"); 
 	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_02"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_02"); 

	Wld_InsertNpc 	(Wolf,	"NW_FARM4_WOOD_MONSTER_03"); 
	Wld_InsertNpc 	(Wolf,	"NW_FARM4_WOOD_MONSTER_03"); 

	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM4_WOOD_MONSTER_04"); 
	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM4_WOOD_MONSTER_04"); 

	Wld_InsertNpc 	(Wolf,	"NW_FARM4_WOOD_MONSTER_05"); 

	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_06"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_06"); 

	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_07"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_07"); 

	Wld_InsertNpc 	(Shadowbeast,	"NW_FARM4_WOOD_MONSTER_08"); 

 	Wld_InsertNpc 	(Gobbo_Skeleton,	"NW_FARM4_WOOD_MONSTER_09"); 

 	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_10"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_10"); 
	Wld_InsertNpc 	(Bloodfly,	"NW_FARM4_WOOD_MONSTER_10"); 
 
  	// Crypt 
	Wld_InsertNpc 	(Crypt_Skeleton_Room_01, "EVT_CRYPT_ROOM_01_SPAWNMAIN");
	Wld_InsertNpc 	(Crypt_Skeleton_Room_02, "EVT_CRYPT_ROOM_02_SPAWNMAIN");
	Wld_InsertNpc 	(Crypt_Skeleton_Room_03, "EVT_CRYPT_ROOM_03_SPAWNMAIN");
	
 	Wld_InsertItem 	(ItMi_Zeitspalt_Addon, "EVT_CRYPT_ROOM_01_SPAWN_03");
 	Wld_InsertItem 	(ItWr_ManaStonePlate2_Addon, "EVT_CRYPT_ROOM_FINAL_SPAWN_01");
 	Wld_InsertItem 	(ItWr_ManaStonePlate3_Addon, "EVT_CRYPT_ROOM_02_SPAWN_05");
	
	//Castlemines
	
	Wld_InsertItem 	(ItWr_HitPointStonePlate3_Addon, "FP_STAND_DEMENTOR_KDF_12");
	Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, "FP_SIT_CAMPFIRE_TOWER_01");
	
	Wld_InsertNpc 	(BDT_1040_Bandit_L, 	"NW_CASTLEMINE_01");
	Wld_InsertNpc 	(BDT_1041_Bandit_L, 	"NW_CASTLEMINE_TOWER_REP_HUT");
	Wld_InsertNpc 	(BDT_1042_Bandit_L, 	"NW_CASTLEMINE_PATH_HUT_02");
	Wld_InsertNpc 	(BDT_1043_Bandit_L, 	"CASTLEMINE");
	Wld_InsertNpc 	(BDT_1044_Bandit_L, 	"NW_CASTLEMINE_TOWER_01");
	Wld_InsertNpc 	(BDT_1045_Bandit_L, 	"NW_CASTLEMINE_PATH_OUTSIDEHUT_02");
	Wld_InsertNpc 	(BDT_1046_Bandit_L, 	"NW_CASTLEMINE_PATH_01");
	Wld_InsertNpc 	(BDT_1047_Bandit_L, 	"NW_CASTLEMINE_TOWER_CAMPFIRE_01");
	Wld_InsertNpc 	(BDT_1048_Bandit_L, 	"NW_CASTLEMINE_TOWER_CAMPFIRE_02");
	Wld_InsertNpc 	(BDT_1049_Bandit_L, 	"NW_CASTLEMINE_TOWER_CAMPFIRE_03");
	Wld_InsertNpc 	(BDT_1060_Dexter, 		"NW_CASTLEMINE_HUT_10");
	Wld_InsertNpc 	(BDT_1061_Wache, 		"NW_CASTLEMINE_PATH_03");
	Wld_InsertNpc 	(BDT_1062_Bandit_L, 	"NW_CASTLEMINE_TOWER_CAMPFIRE_04");
	//Wld_InsertNpc 	(BDT_1063_Bandit_L, 	"NW_CASTLEMINE_HUT_01"); //Joly://ADDON Macht nur Probleme !!!
	Wld_InsertNpc 	(BDT_1064_Bandit_L, 	"NW_CASTLEMINE_HUT_01");
	Wld_InsertNpc 	(BDT_1065_Bandit_L, 	"NW_CASTLEMINE_HUT_01");
	Wld_InsertNpc 	(BDT_1066_Bandit_L, 	"NW_CASTLEMINE_HUT_01");
	Wld_InsertNpc 	(BDT_1067_Bandit_L, 	"NW_CASTLEMINE_HUT_01");
	Wld_InsertNpc 	(BDT_1068_Bandit_L, 	"NW_CASTLEMINE_HUT_01");
	
	/*
	Wld_InsertNpc 	(Giant_Rat, 			"NW_CASTLEMINE_HUT_01");
 	Wld_InsertNpc 	(Giant_Rat, 			"NW_CASTLEMINE_HUT_01");

 	Wld_InsertNpc 	(Giant_Rat, 			"NW_CASTLEMINE_HUT_01_MONSTER");
 	Wld_InsertNpc 	(Giant_Rat, 			"NW_CASTLEMINE_HUT_01_MONSTER");
 	*/
 	
	Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_08");
	Wld_InsertNpc 	(Troll, 				"NW_CASTLEMINE_TROLL_07");
	Wld_InsertItem 	(ItWr_BowStonePlate2_Addon, "FP_ROAM_CASTLEMILL_TROLL_05");

	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_01");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_02");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_03");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_04");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_05");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_06");
	Wld_InsertNpc 	(Skeleton, 				"FP_ROAM_CASTLEMINE2_07");
	Wld_InsertNpc 	(SkeletonMage, 			"FP_ROAM_CASTLEMINE2_08");
	Wld_InsertNpc 	(Zombie01, 				"FP_ROAM_CASTLEMINE2_09");
	Wld_InsertNpc 	(Zombie02, 				"FP_ROAM_CASTLEMINE2_10");
	Wld_InsertNpc 	(Zombie03, 				"FP_ROAM_CASTLEMINE2_11");
	Wld_InsertNpc 	(Zombie04, 				"FP_ROAM_CASTLEMINE2_12");
	Wld_InsertNpc 	(Zombie01, 				"FP_ROAM_CASTLEMINE2_13");
	
	Wld_InsertNpc 	(Minecrawler, 			"NW_CASTLEMINE_13");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"NW_CASTLEMINE_10");
	Wld_InsertNpc 	(Minecrawler, 			"NW_CASTLEMINE_12");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"NW_CASTLEMINE_06");

	Wld_InsertNpc 	(Gobbo_Black, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_01");
	Wld_InsertNpc 	(Gobbo_Warrior, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_02");
	Wld_InsertNpc 	(Gobbo_Black, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_03");
	Wld_InsertNpc 	(Gobbo_Black, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_04");
	Wld_InsertItem 	(ItWr_CrsBowStonePlate2_Addon, 	"FP_NW_ITEM_BIGFARMFORESTCAVE_EGG");

	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_02");
	Wld_InsertNpc 	(Gobbo_Black, 			"FP_ROAM_BIGFARM_LAKE_CAVE_07");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_08");
	//Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_09");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_10");
	Wld_InsertNpc 	(Gobbo_Black, 			"FP_ROAM_BIGFARM_LAKE_CAVE_11");
	//Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_12");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_13");

	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_05");
	//Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_06");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_07");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_08");
	//Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_09");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_NW_BIGFARMFORESTCAVE_10");


	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_01");
	Wld_InsertNpc 	(Gobbo_DaronsStatuenKlauer, 	"FP_ROAM_BIGFARM_LAKE_CAVE_02");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_03");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_04");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_05");
	Wld_InsertNpc 	(Gobbo_Green, 			"FP_ROAM_BIGFARM_LAKE_CAVE_06");


	//andere
	Wld_InsertNpc 	(Bloodfly, 			"NW_BIGFARM_LAKE_MONSTER_BLOODFLY");
	Wld_InsertNpc 	(Bloodfly, 			"NW_BIGFARM_LAKE_MONSTER_BLOODFLY");
	Wld_InsertNpc 	(Bloodfly, 			"NW_BIGFARM_LAKE_MONSTER_BLOODFLY");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_TAVERNE_TROLLAREA_MONSTER_03_01M1");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_TAVERNE_TROLLAREA_MONSTER_03_01M1");

	Wld_InsertNpc 	(Wolf, 			"NW_SAGITTA_MOREMONSTER_01");
	Wld_InsertNpc 	(Wolf, 			"NW_SAGITTA_MOREMONSTER_01");
	Wld_InsertNpc 	(Wolf, 			"NW_SAGITTA_MOREMONSTER_01");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_SAGITTA_MOREMONSTER_03");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_SAGITTA_MOREMONSTER_03");

	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT7");
	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT7");

	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT2_14");
	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT2_14");
	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT2_14");

	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT2_10");
	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM4_WOOD_NEARPEASANT2_10");

	Wld_InsertNpc 	(Wolf, 			"NW_FARM4_WOOD_NEARPEASANT2_8");
	Wld_InsertNpc 	(Wolf, 			"NW_FARM4_WOOD_NEARPEASANT2_8");

	Wld_InsertNpc 	(Scavenger, 			"NW_FARM4_WOOD_NEARPEASANT2_7");
	Wld_InsertNpc 	(Scavenger, 			"NW_FARM4_WOOD_NEARPEASANT2_7");
	Wld_InsertNpc 	(Scavenger, 			"NW_FARM4_WOOD_NEARPEASANT2_7");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_NEARPEASANT2_12");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_NEARPEASANT2_12");

	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_FARM4_WOOD_MONSTER_MORE_02");
	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_FARM4_WOOD_MONSTER_MORE_02");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_MONSTER_MORE_01");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_MONSTER_N_3");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_MONSTER_N_3");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_MONSTER_N_2");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_FARM4_WOOD_MONSTER_N_2");

	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_FOREST_02");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_FOREST_02");

	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_CRYPT_MONSTER08");
	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_CRYPT_MONSTER08");

	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_CRYPT_MONSTER02");
	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_CRYPT_MONSTER02");
	Wld_InsertNpc 	(Gobbo_skeleton, 			"NW_CRYPT_MONSTER02");

	Wld_InsertNpc 	(Lesser_skeleton, 			"NW_CRYPT_MONSTER04");
	Wld_InsertNpc 	(Skeleton, 					"NW_CRYPT_MONSTER04");
	Wld_InsertNpc 	(Lesser_skeleton, 			"NW_CRYPT_MONSTER04");
	Wld_InsertItem 	(ItWr_StrStonePlate2_Addon, 	"FP_ROAM_NW_CRYPT_MONSTER04_02");

	Wld_InsertNpc 	(Lesser_skeleton, 			"NW_CRYPT_MONSTER06");
	Wld_InsertNpc 	(Lesser_skeleton, 			"NW_CRYPT_MONSTER06");

	Wld_InsertNpc 	(Wisp, 			"NW_BIGFARM_FOREST_03_NAVIGATION");

	Wld_InsertNpc 	(Keiler, 			"NW_BIGFARM_FOREST_03_NAVIGATION");

 	Wld_InsertNpc 	(Keiler, 			"NW_FARM4_WOOD_NAVIGATION_09");
	Wld_InsertNpc 	(Keiler, 			"NW_FARM4_WOOD_NAVIGATION_09");

	Wld_InsertNpc 	(Wolf, 			"NW_CASTLEMINE_TROLL_05");
 	Wld_InsertNpc 	(Wolf, 			"NW_CASTLEMINE_TROLL_05");

 	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N");

 	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N_2");
 	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N_2");

 	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N_5");
 	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N_5");
	Wld_InsertNpc 	(Giant_Bug, 			"NW_BIGFARM_ALLEE_08_N_5");

 	Wld_InsertNpc 	(Scavenger, 			"NW_BIGMILL_05");
 	Wld_InsertNpc 	(Scavenger, 			"NW_BIGMILL_05");
 	Wld_InsertNpc 	(Scavenger, 			"NW_BIGMILL_05");

 	Wld_InsertNpc 	(Scavenger, 			"NW_BIGMILL_FARM3_03");
 	Wld_InsertNpc 	(Scavenger, 			"NW_BIGMILL_FARM3_03");


 	Wld_InsertNpc 	(Scavenger, 			"NW_FARM3_BIGWOOD_02");
 	Wld_InsertNpc 	(Scavenger, 			"NW_FARM3_BIGWOOD_02");
 
 	//PATCH M.F. 
 	//Wld_InsertNpc 	(Keiler, 			"NW_FARM3_BIGWOOD_03");
 	//Wld_InsertNpc 	(Keiler, 			"NW_FARM3_BIGWOOD_03");
 	Wld_InsertNpc 	(Keiler, 			"NW_FARM3_BIGWOOD_03");
 
 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_02");
 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_02");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_04");

	Wld_InsertNpc 	(Scavenger, 			"NW_FARM3_PATH_11_SMALLRIVER_08");

	Wld_InsertNpc 	(Scavenger, 			"NW_FARM3_PATH_11_SMALLRIVER_10");
	Wld_InsertNpc 	(Scavenger, 			"NW_FARM3_PATH_11_SMALLRIVER_10");

 
 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_17");
 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_17");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVER_20");

 	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM3_PATH_11_SMALLRIVER_24");
 	Wld_InsertNpc 	(Bloodfly, 			"NW_FARM3_PATH_11_SMALLRIVER_24");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVERMID_03");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVERMID_02");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_PATH_11_SMALLRIVERMID_03");

 	Wld_InsertNpc 	(Keiler, 			"NW_FARM3_PATH_12_MONSTER_01");
 	Wld_InsertNpc 	(Keiler, 			"NW_FARM3_PATH_12_MONSTER_01");

	Wld_InsertNpc 	(Keiler, 			"NW_FARM3_PATH_12_MONSTER_03");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_MOUNTAINLAKE_03");

 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_MOUNTAINLAKE_MONSTER_01");
 	Wld_InsertNpc 	(Lurker, 			"NW_FARM3_MOUNTAINLAKE_MONSTER_01");


 	Wld_InsertNpc 	(Keiler, 		"NW_BIGFARM_LAKE_03_MOVEMENT");
 	Wld_InsertNpc 	(Keiler, 		"NW_BIGFARM_LAKE_03_MOVEMENT");

 	Wld_InsertNpc 	(Giant_Bug, 		"NW_BIGFARM_LAKE_03_MOVEMENT3");
 	Wld_InsertNpc 	(Giant_Bug, 		"NW_BIGFARM_LAKE_03_MOVEMENT3");

 	Wld_InsertNpc 	(Gobbo_skeleton, 	"NW_BIGFARM_LAKE_03_MOVEMENT5");
 	Wld_InsertNpc 	(Gobbo_skeleton, 	"NW_BIGFARM_LAKE_03_MOVEMENT5");
 	
 	//TAVERNECAVE1
 	//Wld_InsertNpc 	(Molerat, 			"WP_BIGFARM_TAVERNCAVE2_01");
 	//Wld_InsertNpc 	(Molerat, 			"WP_BIGFARM_TAVERNCAVE2_02");
 	Wld_InsertItem 	(ItWr_ManaStonePlate1_Addon, 	"FP_ROAM_WP_BIGFARM_TAVERNCAVE2_02_01");
 	
 	
 	//ADDON
 	//Rangerbandits2
 	
  	Wld_InsertNpc 	(BDT_10307_Addon_RangerBandit_M, 	"NW_BIGMILL_FARM3_RANGERBANDITS_01");
  	Wld_InsertNpc 	(BDT_10308_Addon_RangerBandit_L, 	"NW_BIGMILL_FARM3_RANGERBANDITS_02");
  	Wld_InsertNpc 	(BDT_10309_Addon_RangerBandit_L, 	"NW_BIGMILL_FARM3_RANGERBANDITS_03");
  	Wld_InsertNpc 	(BDT_10310_Addon_RangerBandit_M, 	"NW_BIGMILL_FARM3_RANGERBANDITS_04");
  	Wld_InsertNpc 	(VLK_4302_Addon_Elvrich, 			"NW_BIGMILL_FARM3_RANGERBANDITS_04");
	
    	//Rangerbandits1
 	
  	Wld_InsertNpc 	(BDT_10311_Addon_RangerBandit_M, 	"NW_FARM4_WOOD_RANGERBANDITS_04");
  	Wld_InsertNpc 	(BDT_10312_Addon_RangerBandit_L, 	"NW_FARM4_WOOD_RANGERBANDITS_03");
  	Wld_InsertNpc 	(BDT_10313_Addon_RangerBandit_L, 	"NW_FARM4_WOOD_RANGERBANDITS_04");
  	Wld_InsertNpc 	(BDT_10314_Addon_RangerBandit_M, 	"NW_FARM4_WOOD_RANGERBANDITS_05");
  	Wld_InsertItem 	(ItWr_LuciasLoveLetter_Addon, 	"FP_ITEM_NW_FARM4_WOOD_LUCIASLETTER");
  	
  	 Wld_InsertItem 	(ItWr_HitPointStonePlate3_Addon, "FP_ITEM_GREATPEASANT_STPLATE_05");
  	 Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, "FP_ITEM_GREATPEASANT_STPLATE_07");
  	 Wld_InsertItem 	(ItWr_DexStonePlate2_Addon, "FP_ITEM_GREATPEASANT_STPLATE_08");

	//Die Spur der Banditen:
 	
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_STAND_DEMENTOR_05");
    Wld_InsertItem 	(ItWr_StrStonePlate1_Addon, "FP_STAND_DEMENTOR_09");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_FARM3_PATH_11_SMALLRIVER_09");
    Wld_InsertItem 	(ItWr_DexStonePlate1_Addon, "FP_ROAM_NW_FARM3_PATH_11_SMALLRIVER_05");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_FARM3_BIGWOOD_02_04");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_BIGMILL_FARM3_01");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_STAND_DEMENTOR_03");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_BIGMILL_FARM3_03_02");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_STAND_DEMENTOR_07");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_BIGFARM_ALLEE_08_N2");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_STAND_DEMENTOR_02");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_FARM4_SHEEP_02");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_FARM4_WOOD_MONSTER_MORE_02");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_NW_FARM4_WOOD_LUCIASLETTER");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ROAM_NW_FARM4_WOOD_MONSTER_N_17");

    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_GREATPEASANT_FERNANDOSWEAPONS_01");
    Wld_InsertItem 	(ItWr_ManaStonePlate1_Addon, "FP_ITEM_GREATPEASANT_FERNANDOSWEAPONS_01");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_GREATPEASANT_FERNANDOSWEAPONS_02");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_GREATPEASANT_FERNANDOSWEAPONS_03");
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_GREATPEASANT_FERNANDOSWEAPONS_04");
    Wld_InsertItem 	(ItWr_Addon_BanditTrader, "FP_ITEM_NW_FARM4_WOOD_FERNANDOLETTER");
 
	//****************************************************************************************

};

	FUNC VOID INIT_SUB_NewWorld_Part_GreatPeasant_01()
	{
		// ------- Sld-Vorposten -------
		if (MIS_Addon_Erol_BanditStuff == LOG_SUCCESS)
		{
			Wld_AssignRoomToGuild ("grpwaldhuette01",	GIL_PUBLIC);
		}
		else
		{
			Wld_AssignRoomToGuild ("grpwaldhuette01",	GIL_SLD);
		};		
	
		// ------ Onars Hof ------
		Wld_AssignRoomToGuild ("grphaupthaus01",	GIL_PUBLIC);
		Wld_AssignRoomToGuild ("grpschmiede01",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("grpscheune01",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("grpkapelle01",		GIL_NONE);
		
		// ------ abgelegene Gruft ------
		Wld_AssignRoomToGuild ("cementary01",		GIL_NONE);
				
		// ------ Sekobs Farm ------
		if (Sekob_RoomFree == FALSE)
		{
			Wld_AssignRoomToGuild ("grpbauer01",		GIL_PUBLIC);
		}
		else
		{
			Wld_AssignRoomToGuild ("grpbauer01",		GIL_NONE);
		};
		Wld_AssignRoomToGuild ("grpbauerscheune01",	GIL_PUBLIC);
		
		// ------ Bengars Farm ------
		Wld_AssignRoomToGuild ("grpbauer02",		GIL_PUBLIC);
		Wld_AssignRoomToGuild ("grpbauerscheune02",	GIL_PUBLIC);
		
		// ------ Abenteuerspielplatz -------
		Wld_AssignRoomToGuild ("grpturm02",			GIL_PUBLIC); //vorderer Turm
		Wld_AssignRoomToGuild ("grpturm01",			GIL_PUBLIC); //hinterer Turm
		Wld_AssignRoomToGuild ("grpwaldhuette02",	GIL_PUBLIC); //Banditenh�tte
	};

FUNC VOID INIT_NewWorld_Part_GreatPeasant_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();	
	
	INIT_SUB_NewWorld_Part_GreatPeasant_01();
};
//--------------------------- PASS -------------------------------------------------------
FUNC VOID STARTUP_NewWorld_Part_Pass_To_OW_01 ()
{
	// ------NSCs --------

	Wld_InsertNpc 	(PAL_297_Ritter, "NW_PASS_01");
	Wld_InsertNpc 	(PAL_298_Ritter, "NW_PASS_01");
	Wld_InsertItem 	(ItWr_HitPointStonePlate2_Addon, "FP_ITEM_PASS_01");

	Wld_InsertNpc	(YWolf,"NW_PASS_06");
	Wld_InsertNpc	(YWolf,"NW_PASS_06");
	
	Wld_InsertNpc	(YWolf,"NW_PASS_11");
	Wld_InsertNpc	(YWolf,"NW_PASS_11");
	
	Wld_InsertNpc	(YWolf,"NW_PASS_SECRET_15");
	Wld_InsertNpc	(YWolf,"NW_PASS_SECRET_16");
	Wld_InsertNpc	(YWolf,"NW_PASS_SECRET_16");
	Wld_InsertNpc	(YWolf,"NW_PASS_SECRET_17");
	
	Wld_InsertNpc	(Giant_Rat,"NW_PASS_SECRET_05");
	Wld_InsertNpc	(Giant_Rat,"NW_PASS_SECRET_06");
	Wld_InsertNpc	(Giant_Rat,"NW_PASS_SECRET_07");
	Wld_InsertNpc	(Giant_Rat,"NW_PASS_SECRET_08");
	
	Wld_InsertNpc	(Gobbo_Green,"NW_PASS_GRAT_04");
	Wld_InsertNpc	(Gobbo_Green,"NW_PASS_GRAT_05");
	Wld_InsertNpc	(Gobbo_Green,"NW_PASS_GRAT_05");
	Wld_InsertNpc	(Gobbo_Green,"NW_PASS_GRAT_06");
	Wld_InsertNpc	(Gobbo_Green,"NW_PASS_GRAT_06");
	
	//Wld_InsertNpc	(OrcShaman_Sit,"NW_PASS_ORKS_07");
	Wld_InsertNpc	(OrcShaman_Sit,"NW_PASS_ORKS_02");
	//Wld_InsertNpc	(OrcShaman_Sit,"NW_PASS_ORKS_02_B");
	
	Wld_InsertNpc	(OrcShaman_Sit,"NW_PASS_ORKS_13");
	Wld_InsertNpc	(OrcShaman_Sit,"NW_PASS_ORKS_04_B");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_13");
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_14");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_07");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_06");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_06");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_01");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_01");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_01");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_04");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_04");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_04");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_08");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_08");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_03");
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_03");
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_03");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_09");
	
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_10");
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_10");
	
	//Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_11");
	Wld_InsertNpc	(OrcWarrior_Roam,"NW_PASS_ORKS_12");
};
FUNC VOID INIT_SUB_NewWorld_Part_Pass_To_OW_01 ()
{

};
FUNC VOID INIT_NewWorld_Part_Pass_To_OW_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();	
	
	INIT_SUB_NewWorld_Part_Pass_To_OW_01();
};
//---Medium Forest--------

FUNC VOID STARTUP_NewWorld_Part_Forest_01 ()
{
	Wld_InsertItem 		(itmi_erolskelch,"FP_SPAWN_KELCH"); 
	
	Wld_InsertNpc		(BDT_1009_Bandit_L, "NW_FOREST_CAVE1_IN_04"); 
	Wld_InsertNpc		(BDT_1010_Bandit_L, "NW_FOREST_CAVE1_IN_05"); 
	Wld_InsertNpc		(BDT_1011_Bandit_M, "NW_FOREST_CAVE1_IN_06"); 
	//Wld_InsertNpc		(BDT_1016_Bandit_M, "NW_CITY_SMFOREST_BANDIT_03"); 
	//Wld_InsertNpc		(BDT_1017_Bandit_L, "NW_CITY_SMFOREST_BANDIT_04"); 
	
	//Farm2
	Wld_InsertNpc 	(SLD_840_Alvares, 		"FARM2");
	Wld_InsertNpc 	(SLD_841_Engardo, 		"FARM2");

	Wld_InsertNpc 	(BAU_940_Akil, 			"FARM2");
	Wld_InsertNpc 	(BAU_941_Kati, 			"FARM2");
	Wld_InsertNpc 	(BAU_942_Randolph, 		"FARM2");
	Wld_InsertNpc 	(BAU_943_Bauer, 		"FARM2");
	Wld_InsertNpc 	(BAU_944_Ehnim, 		"FARM2");
	Wld_InsertNpc 	(BAU_945_Egill, 		"FARM2");

	Wld_InsertNpc 	(Sheep, 		"NW_FARM2_OUT_02");
	Wld_InsertNpc 	(Sheep, 		"NW_FARM2_OUT_02");

	// Taverne
	
	Wld_InsertNpc 	(BAU_970_Orlan, 		"TAVERNE");
	Wld_InsertNpc 	(BAU_971_Bauer, 		"TAVERNE");
	Wld_InsertNpc 	(BAU_972_Bauer, 		"TAVERNE");
	Wld_InsertNpc 	(BAU_973_Rukhar, 		"TAVERNE");
	Wld_InsertNpc 	(BAU_974_Bauer ,		"NW_TAVERNE_IN_07"); 

	Wld_InsertNpc 	(VLK_4303_Addon_Erol ,	"NW_TAVERNE_IN_07"); 

	// Monster

	Wld_InsertNpc 	(Giant_Rat, 			"FP_ROAM_MEDIUMFOREST_KAP2_12");
	Wld_InsertNpc 	(Giant_Rat, 			"FP_ROAM_MEDIUMFOREST_KAP2_10");

	Wld_InsertNpc 	(Scavenger, 	"FP_ROAM_MEDIUMFOREST_KAP2_28");
	Wld_InsertNpc 	(Scavenger, 	"FP_ROAM_MEDIUMFOREST_KAP2_29");
	
	Wld_InsertNpc 	(Scavenger, 		"FP_ROAM_MEDIUMFOREST_KAP2_17");
	Wld_InsertNpc 	(Scavenger, 		"FP_ROAM_MEDIUMFOREST_KAP2_13");
	Wld_InsertNpc 	(Wolf, 		"FP_ROAM_MEDIUMFOREST_KAP2_36");
	Wld_InsertNpc 	(Wolf, 		"FP_ROAM_MEDIUMFOREST_KAP2_34");


	Wld_InsertNpc 	(Skeleton, 		"FP_ROAM_MEDIUMFOREST_KAP3_04");
	Wld_InsertNpc 	(Skeleton, 		"FP_ROAM_MEDIUMFOREST_KAP3_05");

	Wld_InsertNpc 	(Zombie01, "FP_ROAM_MEDIUMFOREST_KAP3_01");
	Wld_InsertNpc 	(Zombie02, "FP_ROAM_MEDIUMFOREST_KAP3_02");
	Wld_InsertNpc 	(Zombie03, "FP_ROAM_MEDIUMFOREST_KAP3_03");

	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_08");
	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_09");
	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_11");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_MEDIUMFOREST_KAP3_15");
	Wld_InsertNpc 	(Wolf, "FP_ROAM_MEDIUMFOREST_KAP3_17");
	Wld_InsertNpc 	(Keiler, "FP_ROAM_MEDIUMFOREST_KAP3_21");
	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_23");
	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_28");
	Wld_InsertNpc 	(Warg, "FP_ROAM_MEDIUMFOREST_KAP3_29");

	Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_MEDIUMFOREST_KAP3_20");

	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_MEDIUMFOREST_KAP3_27");
	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_MEDIUMFOREST_KAP3_26");

	Wld_InsertNpc 	(OrcWarrior_Roam, "FP_ROAM_MEDIUMFOREST_KAP3_32");

	// ------- vom Osttor zum Leuchtturm ------
	Wld_InsertNpc 	(Bloodfly, "NW_CITY_TO_LIGHTHOUSE_03"); //mehr FPs
	Wld_InsertNpc 	(Bloodfly, "NW_CITY_TO_LIGHTHOUSE_03");
	
	// ------- K�ste ------
	Wld_InsertNpc 	(Waran, "FP_ROAM_SHIPWRECK_04"); 
	Wld_InsertItem  (ItWr_ManaStonePlate1_Addon, "FP_ROAM_SHIPWRECK_03");
	Wld_InsertNpc 	(Waran, "FP_ROAM_SHIPWRECK_01"); 
	
	//ADDON Wld_InsertNpc	(Waran,"FP_ROAM_FISHERCOAST_01");	
	//ADDON Wld_InsertNpc	(Waran,"FP_ROAM_FISHERCOAST_02");

	//ADDON: Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_FISHERMAN_01");
	Wld_InsertNpc 	(Waran, "FP_ROAM_FISHERMAN_04");
	
	// ------- vom Osttor zu Farm2 ------
	Wld_InsertNpc 	(Mil_337_Mika, "FARM2");
	
	Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_05");
	Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_07");
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_TO_FOREST_11");
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_TO_FOREST_12");
	Wld_InsertNpc 	(Gobbo_Green, "NW_CITY_TO_FOREST_15"); //FPs fehlen
	
	Wld_InsertNpc 	(Wolf, "FP_ROAM_CITY_TO_FOREST_47");

	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_CITY_TO_FOREST_11");
	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_CITY_TO_FOREST_10");
	
	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_CITYFOREST_KAP3_22");
	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_CITYFOREST_KAP3_20");
	Wld_InsertNpc 	(Giant_Rat, "FP_ROAM_CITYFOREST_KAP3_21");

	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_23");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_27");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_28");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_29");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_30");
	Wld_InsertNpc 	(Giant_Bug, "FP_ROAM_CITYFOREST_KAP3_38");

	Wld_InsertNpc 	(Waran, "FP_ROAM_CITY_TO_FOREST_32");
	Wld_InsertNpc 	(Waran, "FP_ROAM_CITY_TO_FOREST_29");
	Wld_InsertNpc 	(Waran, "FP_ROAM_CITY_TO_FOREST_31");

	Wld_InsertNpc 	(Molerat, "FP_ROAM_CITY_TO_FOREST_42");
	Wld_InsertNpc 	(Molerat, "FP_ROAM_CITY_TO_FOREST_41");

	Wld_InsertNpc 	(Shadowbeast, "FP_ROAM_CITYFOREST_KAP3_04");

	Wld_InsertNpc 	(Gobbo_Black, "FP_ROAM_CITYFOREST_KAP3_07");
	Wld_InsertNpc 	(Gobbo_Black, "FP_ROAM_CITYFOREST_KAP3_06");
	Wld_InsertNpc 	(Gobbo_Black, "FP_ROAM_CITYFOREST_KAP3_08");

	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_09");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_10");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_11");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_12");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_14");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_15");
	Wld_InsertNpc 	(Warg, "FP_ROAM_CITYFOREST_KAP3_17");
	
	// VINOSKELLEREI
	Wld_InsertNpc 		(Giant_Rat ,"NW_FOREST_VINOSKELLEREI_01"); 
	Wld_InsertNpc 		(Giant_Rat ,"NW_FOREST_VINOSKELLEREI_01"); 
	Wld_InsertItem 		(ItWr_VinosKellergeister_Mis ,"FP_ITEM_NW_VINOKELLEREI"); 

	// ----------- Lighthouse ------------
	
	Wld_InsertNpc 	(BDT_1021_LeuchtturmBandit, "LIGHTHOUSE"); 
	Wld_InsertNpc 	(BDT_1022_LeuchtturmBandit, "NW_LIGHTHOUSE_IN_01");
	Wld_InsertNpc 	(BDT_1023_LeuchtturmBandit, "NW_CITY_TO_LIGHTHOUSE_16");
	
	// ----------- SMForestCave ------------
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_SMFOREST_05");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_05");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_05");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_06");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_06");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_06");
	
	Wld_InsertNpc 	(BDT_1000_Bandit_L, "NW_CITY_SMFOREST_07");
	Wld_InsertNpc 	(BDT_1002_Bandit_L, "NW_CITY_SMFOREST_BANDIT_02");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_08");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_08");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_09");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_09");
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_SMFOREST_09");
	
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_SMFOREST_03");
	Wld_InsertNpc 	(Giant_Rat, "NW_CITY_SMFOREST_03");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_01_01");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_01_01");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_SMFOREST_01_01");
	
	// ----------- COASTCAVE ------------
	Wld_InsertNpc 	(Shadowbeast, "NW_FOREST_PATH_35_06");
	
	// ----------- City2Cave ------------
	Wld_InsertNpc 	(Orcwarrior_Rest, "NW_CITY_TO_FOREST_04_08");
	Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_04_09");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_TO_FOREST_04_05");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_TO_FOREST_04_05");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_TO_FOREST_04_05");
	
	Wld_InsertNpc 	(Meatbug, "NW_CITY_TO_FOREST_04_05_01");
	Wld_InsertNpc 	(Meatbug, "NW_CITY_TO_FOREST_04_05_01");
	
	// ----------- BridgeCave ------------
	Wld_InsertNpc 	(Molerat, "NW_TAVERN_TO_FOREST_05_05");
	Wld_InsertNpc 	(Molerat, "NW_TAVERN_TO_FOREST_05_06");
	
	// ----------- ShadowBeastCave ------------
	Wld_InsertNpc 	(Gobbo_Green, "NW_CITYFOREST_CAVE_A01");
	Wld_InsertNpc 	(Gobbo_Green, "NW_CITYFOREST_CAVE_A01");
	
	Wld_InsertNpc 	(Gobbo_Black, "NW_CITYFOREST_CAVE_A02");
	
	Wld_InsertNpc 	(Giant_Rat, "NW_CITYFOREST_CAVE_04");
	Wld_InsertNpc 	(Giant_Rat, "NW_CITYFOREST_CAVE_04");
	
	Wld_InsertNpc 	(Molerat, "NW_CITYFOREST_CAVE_06");
	Wld_InsertNpc 	(Molerat, "NW_CITYFOREST_CAVE_06");
	Wld_InsertNpc 	(Molerat, "NW_CITYFOREST_CAVE_06");
		
	Wld_InsertNpc 	(Shadowbeast, "NW_CITYFOREST_CAVE_A06");
	
	// andere
	Wld_InsertNpc 	(Giant_Rat, "NW_FARM1_CITYWALL_RIGHT_04");
	Wld_InsertNpc 	(Giant_Rat, "NW_FARM1_CITYWALL_RIGHT_04");

	Wld_InsertNpc 	(Scavenger, "NW_FOREST_PATH_38_MONSTER");
	Wld_InsertNpc 	(Scavenger, "NW_FOREST_PATH_38_MONSTER");

	Wld_InsertNpc 	(Keiler, "NW_CITY_TO_LIGHTHOUSE_13_MONSTER");

	Wld_InsertNpc 	(Wolf, "NW_FOREST_PATH_35_01");
	Wld_InsertNpc 	(Wolf, "NW_FOREST_PATH_35_01");

	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_31_MONSTER");
	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_31_MONSTER");

	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_21_MONSTER");
	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_21_MONSTER");

	Wld_InsertNpc 	(Giant_Bug, "NW_FARM2_TO_TAVERN_09_MONSTER");

	Wld_InsertNpc 	(Giant_Bug, "NW_FARM2_TO_TAVERN_09_MONSTER2");
	Wld_InsertNpc 	(Giant_Bug, "NW_FARM2_TO_TAVERN_09_MONSTER2");

	Wld_InsertNpc 	(Giant_Bug, "NW_FARM2_TO_TAVERN_09_MONSTER3");
	Wld_InsertNpc 	(Giant_Bug, "NW_FARM2_TO_TAVERN_09_MONSTER3");

	Wld_InsertNpc 	(Molerat, "NW_FARM2_TO_TAVERN_09_MONSTER4");
	Wld_InsertNpc 	(Molerat, "NW_FARM2_TO_TAVERN_09_MONSTER4");
	Wld_InsertNpc 	(Molerat, "NW_FARM2_TO_TAVERN_09_MONSTER4");

	Wld_InsertNpc 	(Bloodfly, "NW_FARM2_TO_TAVERN_09_MONSTER5");
	Wld_InsertNpc 	(Bloodfly, "NW_FARM2_TO_TAVERN_09_MONSTER5");

	Wld_InsertNpc 	(Wolf, "NW_CITY_TO_FOREST_04");

	Wld_InsertNpc 	(Wolf, "NW_FOREST_CAVE1_01");

	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_75_2_MONSTER");
	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_75_2_MONSTER");

	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_79");
	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_79");

	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_80_1");
	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_80_1");

	Wld_InsertNpc 	(Waran, "NW_FOREST_PATH_82");
	Wld_InsertNpc 	(Waran, "NW_FOREST_PATH_82");

	Wld_InsertNpc 	(Waran, "NW_FOREST_PATH_82_M");
	Wld_InsertNpc 	(Waran, "NW_FOREST_PATH_82_M");

	Wld_InsertNpc 	(Wolf, "NW_FOREST_PATH_66_M");
	Wld_InsertNpc 	(Wolf, "NW_FOREST_PATH_66_M");

 	Wld_InsertNpc 	(Gobbo_Skeleton, "NW_FOREST_PATH_62_M");
 	Wld_InsertNpc 	(Gobbo_Skeleton, "NW_FOREST_PATH_62_M");

 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_57");
 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_57");

 	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_35_01_MONSTER");
 	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_35_01_MONSTER");

 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_80_1_MOVEMENT8_M");
 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_80_1_MOVEMENT8_M");

 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_80_1_MOVEMENTF");
 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_80_1_MOVEMENTF");

 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_31_NAVIGATION3");
 	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_31_NAVIGATION3");

  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_31_NAVIGATION10");
  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_31_NAVIGATION10");

  	Wld_InsertNpc 	(Giant_Rat, "NW_FOREST_PATH_31_NAVIGATION11");

  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT6");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT6");

  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT15");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT15");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT15");

  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT8_M5");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT8_M5");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_31_NAVIGATION16");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_31_NAVIGATION16");

  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT8_M3");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT8_M3");
  	Wld_InsertNpc 	(Snapper, "NW_FOREST_PATH_80_1_MOVEMENT8_M3");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_04_16_MONSTER");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_04_16_MONSTER");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_04_16_MONSTER");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_04_16_MONSTER2");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_04_16_MONSTER2");

  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_13");
  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_13");

  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_3");

  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_4");
  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_4");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_72_MONSTER");

  	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_62_06");
  	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_62_06");

  	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_56_MONSTER");
  	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_56_MONSTER");

  	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_27_03");
  	Wld_InsertNpc 	(Bloodfly, "NW_FOREST_PATH_27_03");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_27_02");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_27_02");

  	Wld_InsertNpc 	(Scavenger, "NW_CITY_TO_LIGHTHOUSE_13_MONSTER7");
  	Wld_InsertNpc 	(Scavenger, "NW_CITY_TO_LIGHTHOUSE_13_MONSTER7");

  	Wld_InsertNpc 	(Bloodfly, "NW_CITY_TO_LIGHTHOUSE_13_MONSTER8");
  	Wld_InsertNpc 	(Bloodfly, "NW_CITY_TO_LIGHTHOUSE_13_MONSTER8");

  	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_35_MONSTER");

  	Wld_InsertNpc 	(Orcwarrior_Roam, "NW_FOREST_PATH_31_NAVIGATION_M");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_31_NAVIGATION_M");

  	Wld_InsertNpc 	(Orcwarrior_Roam, "NW_FOREST_PATH_31_NAVIGATION19");
  	Wld_InsertNpc 	(Orcwarrior_Roam, "NW_FOREST_PATH_31_NAVIGATION19");

  	Wld_InsertNpc 	(Orcelite_Roam, "NW_FOREST_PATH_18_MONSTER");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_18_MONSTER");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_72_MONSTER23");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_72_MONSTER23");

  	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_76");

  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_66_MONSTER");
  	Wld_InsertNpc 	(Warg, "NW_FOREST_PATH_66_MONSTER");

  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_5");
  	Wld_InsertNpc 	(Giant_Bug, "NW_FOREST_PATH_04_5");

  	//Egill/Enim-FIX
  	//Wld_InsertNpc 	(Giant_Bug, "NW_CITY_TO_FARM2_05_MOV5");
  	//Wld_InsertNpc 	(Giant_Bug, "NW_CITY_TO_FARM2_05_MOV5");

  	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_04_14_MONSTER");
  	Wld_InsertNpc 	(Keiler, "NW_FOREST_PATH_04_14_MONSTER");

   	Wld_InsertNpc 	(Molerat, "NW_CITY_SMFOREST_03_M");
   	Wld_InsertNpc 	(Molerat, "NW_CITY_SMFOREST_03_M");

   	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_25_01_M");
   	Wld_InsertNpc 	(Molerat, "NW_FOREST_PATH_25_01_M");
   	
   	//ADDON
   	
   	//Beim ersten H�ndler�berfall
    Wld_InsertNpc 	(BDT_10300_Addon_RangerBandit_L, "NW_FARM2_TO_TAVERN_RANGERBANDITS_01");
    Wld_InsertNpc 	(BDT_10301_Addon_RangerBandit_M, "NW_FARM2_TO_TAVERN_RANGERBANDITS_02");	
    Wld_InsertNpc 	(BDT_10302_Addon_RangerBandit_L, "NW_FARM2_TO_TAVERN_RANGERBANDITS_01");
    Wld_InsertNpc 	(BDT_10303_Addon_RangerBandit_L, "NW_FARM2_TO_TAVERN_RANGERBANDITS_01");
  	
    Wld_InsertNpc 	(BDT_10304_Addon_RangerBandit_M, "NW_FARM2_TO_TAVERN_RANGERBANDITS_01");
    Wld_InsertNpc 	(BDT_10305_Addon_RangerBandit_L, "NW_FARM2_TO_TAVERN_RANGERBANDITS_01");
    
    Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_ITEM_FOREST_BANDITTRADER_01");
	Wld_InsertItem 	(ItMw_Addon_BanditTrader, "FP_SMALLTALK_NW_FARM2_TO_TAVERN_08_02");
 
    //Stoneplates
    Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, "FP_ITEM_FOREST_STPLATE_01");
    Wld_InsertItem 	(ItWr_StrStonePlate1_Addon, "FP_ITEM_FOREST_STPLATE_02");
    Wld_InsertItem 	(ItMi_Zeitspalt_Addon, "FP_ITEM_FOREST_STPLATE_04");
    Wld_InsertItem 	(ItWr_HitPointStonePlate1_Addon, "FP_ITEM_FOREST_STPLATE_06");
};

	FUNC VOID INIT_SUB_NewWorld_Part_Forest_01()
	{
	};

FUNC VOID INIT_NewWorld_Part_Forest_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();	
	
	INIT_SUB_NewWorld_Part_Forest_01();
};
	
//------- Troll Area ---------------------------
FUNC VOID STARTUP_NewWorld_Part_TrollArea_01 ()
{
	
	
	
	
	
	
	
	
	//----- Magierh�hle -----
	/*
	Wld_InsertNpc 	(Skeleton, 				"NW_MAGECAVE_SKELETON");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_15");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_16");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_GUARD_02");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_GUARD_01");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_CROSSING");
	Wld_InsertNpc 	(Lesser_Skeleton, 		"NW_MAGECAVE_CROSSING");
	*/
	Wld_InsertNpc 	(Meatbug, 				"NW_MAGECAVE_20");
	Wld_InsertNpc 	(Meatbug, 				"NW_MAGECAVE_20");
	Wld_InsertNpc 	(Meatbug, 				"NW_MAGECAVE_20");
	Wld_InsertNpc 	(Minecrawler, 			"NW_MAGECAVE_23");
	Wld_InsertNpc 	(Minecrawler, 			"NW_MAGECAVE_23");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"NW_MAGECAVE_27");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"NW_MAGECAVE_27");
	Wld_InsertItem 	(ItWr_HitPointStonePlate3_Addon, "FP_NW_ITEM_MAGECAVE_EGG");



	//----- Schwarzer Troll -----
	Wld_InsertNpc 	(Troll_Black, 			"NW_TROLLAREA_PATH_84");
	Wld_InsertItem	(ItPl_Sagitta_Herb_MIS, "FP_NW_ITEM_TROLL_05");
	Wld_InsertItem	(ItWr_ManaStonePlate3_Addon, "FP_NW_ITEM_TROLL_01");
	Wld_InsertNpc 	(BAU_982_Grimbald, 		"TROLL");

	//----- Der Weg -----
	Wld_InsertNpc 	(Gobbo_Green, 			"NW_TROLLAREA_PATH_56");
	Wld_InsertNpc 	(Gobbo_Green, 			"NW_TROLLAREA_PATH_56");
	Wld_InsertNpc 	(YGobbo_Green, 			"NW_TROLLAREA_PATH_56");
	
	//----- Der gro�e See -----
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_TROLLAREA_SEA_01");
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_TROLLAREA_SEA_02");
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_TROLLAREA_SEA_03");
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_TROLLAREA_SEA_04");
	
	//RitualForest
	
	Wld_InsertNpc 	(Giant_Rat, 			"FP_ROAM_RITUALFOREST_CAVE_05");
	Wld_InsertNpc 	(Giant_Rat, 			"FP_ROAM_RITUALFOREST_CAVE_05");

	Wld_InsertNpc 	(MinecrawlerWarrior, 	"FP_ROAM_RITUALFOREST_CAVE_07");
	Wld_InsertNpc 	(Skeleton, 	"FP_ROAM_RITUALFOREST_CAVE_08");
	Wld_InsertNpc 	(Skeleton, 	"FP_ROAM_RITUALFOREST_CAVE_09");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"FP_ROAM_RITUALFOREST_CAVE_11");
	
	//----- Die Maya Pyramiden ------
	
	Wld_InsertNpc 	(Giant_Bug, 	"FP_ROAM_NW_TROLLAREA_RUINS_01");
	
	Wld_InsertNpc 	(Snapper, 	"FP_ROAM_NW_TROLLAREA_RUINS_05");
	Wld_InsertNpc 	(Snapper, 	"FP_ROAM_NW_TROLLAREA_RUINS_09");
	
	Wld_InsertNpc 	(Giant_Rat, 	"FP_ROAM_NW_TROLLAREA_RUINS_14");
	Wld_InsertNpc 	(Giant_Rat, 	"FP_ROAM_NW_TROLLAREA_RUINS_15");
	
	Wld_InsertNpc 	(FireWaran, 	"NW_TROLLAREA_RUINS_21");
	Wld_InsertNpc 	(FireWaran, 	"FP_ROAM_NW_TROLLAREA_RUINS_21");
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_NW_TROLLAREA_RUINS_22");
	Wld_InsertNpc 	(Bloodfly, 	"FP_ROAM_NW_TROLLAREA_RUINS_24");
	
	Wld_InsertNpc 	(Waran, 	"FP_ROAM_NW_TROLLAREA_RUINS_28");
	Wld_InsertNpc 	(Waran, 	"FP_ROAM_NW_TROLLAREA_RUINS_29");
	Wld_InsertNpc 	(Waran, 	"FP_ROAM_NW_TROLLAREA_RUINS_30");
	
	Wld_InsertNpc 	(Shadowbeast, 	"FP_ROAM_NW_TROLLAREA_RUINS_10");
	
	Wld_InsertItem 	(ItWr_HitPointStonePlate1_Addon,"FP_NW_ITEM_TROLL_07");
	Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, 	"FP_NW_ITEM_TROLL_08");
	Wld_InsertItem 	(ItWr_CrsBowStonePlate1_Addon, 	"FP_ROAM_NW_TROLLAREA_PORTALTEMPEL_26");

	
	//in der Maya-H�hle
	
	//Gobbos in Eingangsh�hle
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_01");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_02");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_03");
	
	//Gobbos in 2. H�hle
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_05");
	Wld_InsertItem 	(ItWr_HitPointStonePlate1_Addon, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_05");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_06");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_07");
	
	//Gobbos in 3. H�hle
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_09");
	Wld_InsertNpc 	(Gobbo_Warrior, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_10");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_11");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_12");
	Wld_InsertNpc 	(Gobbo_Black, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_14");
	
	//MineCrawler 1. H�hle
	Wld_InsertNpc 	(Minecrawler, 			"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_16");
	
	//2. H�hle
	Wld_InsertNpc 	(Minecrawler, 			"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_21");
	Wld_InsertNpc 	(Minecrawler, 			"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_23");
	
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_20");
	Wld_InsertNpc 	(MinecrawlerWarrior, 	"FP_ROAM_NW_TROLLAREA_RUINS_CAVE_26");
	
	//Golems		
	Wld_InsertNpc 	(Shattered_Golem, 		"FP_SHATTERED_GOLEM_01");
	Wld_InsertNpc 	(Shattered_Golem, 		"FP_SHATTERED_GOLEM_02");
	Wld_InsertNpc 	(Shattered_Golem, 		"FP_SHATTERED_GOLEM_03");
	Wld_InsertNpc 	(Shattered_Golem, 		"FP_SHATTERED_GOLEM_04");
	
	
				//ADDON
				//ADDON
				Wld_InsertNpc 	(KDW_1400_Addon_Saturas_NW, 		"MAYA");
				Wld_InsertNpc 	(KDW_1401_Addon_Cronos_NW, 			"MAYA");
				Wld_InsertNpc 	(KDW_1402_Addon_Nefarius_NW, 		"MAYA");
				Wld_InsertNpc 	(KDW_1403_Addon_Myxir_NW, 			"MAYA");
				Wld_InsertNpc 	(KDW_1404_Addon_Riordian_NW, 		"MAYA");
				Wld_InsertNpc 	(KDW_1405_Addon_Merdarion_NW, 		"MAYA");
				Wld_InsertItem (ItMi_AmbossEffekt_Addon,"FP_ITEM_TROLLAREA_PORTALRITUAL_01");
				
				
				Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_PORTALTEMPEL_15_A");
				Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_PORTALTEMPEL_15_B");
				Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_PORTALTEMPEL_15_B");
				Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_PORTALTEMPEL_17_A");
				
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_12");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_12");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_09");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_08");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_08");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_06");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_06");
				Wld_InsertNpc 	(Giant_Rat, 		"NW_TROLLAREA_PORTALTEMPEL_06");
				
				//Wld_InsertNpc 	(Alligator_PortalDead, 		"NW_TROLLAREA_PORTALTEMPEL_DEADALLIGATOR");
				//B_KillNpc 		(Alligator_PortalDead);
				Wld_InsertNpc 	(Stoneguardian_Dead1, 		"NW_TROLLAREA_PORTALTEMPEL_08");
				B_KillNpc 		(Stoneguardian_Dead1); 
				Wld_InsertNpc 	(Stoneguardian_Dead2, 		"AMBOSS");
				B_KillNpc 		(Stoneguardian_Dead2); 
				Wld_InsertNpc 	(Stoneguardian_Dead3, 		"PORTAL");
				B_KillNpc 		(Stoneguardian_Dead3); 
				
			    Wld_InsertItem 	(ItWr_HitpointStonePlate1_Addon, "FP_ITEM_TROLLAREA_STPLATE_06");
			    Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, "FP_ITEM_TROLLAREA_STPLATE_07");
			    Wld_InsertItem 	(ItWr_ManaStonePlate1_Addon, "FP_ITEM_TROLLAREA_STPLATE_08");
			    Wld_InsertItem 	(ItWr_BowStonePlate1_Addon, "FP_ITEM_TROLLAREA_STPLATE_09");
			    Wld_InsertItem 	(ItWr_CrsBowStonePlate1_Addon, "FP_ITEM_TROLLAREA_STPLATE_12");
			    Wld_InsertItem 	(ItWr_TwoHStonePlate2_Addon, "FP_ITEM_TROLLAREA_STPLATE_13");
			    Wld_InsertItem 	(ItWr_OneHStonePlate2_Addon, "FP_ITEM_TROLLAREA_STPLATE_14");
			    Wld_InsertItem 	(ItWr_StonePlateCommon_Addon, "FP_ROAM_NW_TROLLAREA_PORTALTEMPEL_DEADALLIGATOR");
			 
 				//ADDON
 				//ADDON

	
	//andere
	
	Wld_InsertNpc 	(Wolf, 		"NW_TROLLAREA_PATH_66_MONSTER");
	Wld_InsertNpc 	(Wolf, 		"NW_TROLLAREA_PATH_66_MONSTER");
	Wld_InsertItem 	(ItWr_ManaStonePlate1_Addon, "FP_ROAM_NW_TROLLAREA_PATH_66_MONSTER_03");

	Wld_InsertItem 	(ItWr_HitPointStonePlate2_Addon, "FP_NW_ITEM_TROLL_03");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_07");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_07");


	Wld_InsertNpc 	(Molerat, 		"NW_TROLLAREA_NOVCHASE_01");

	Wld_InsertNpc 	(Bloodfly, 		"NW_TROLLAREA_PATH_38_MONSTER");
	Wld_InsertItem 	(ItWr_OneHStonePlate1_Addon, 		"FP_NW_ITEM_TROLL_02");
	Wld_InsertItem 	(ItWr_TwoHStonePlate1_Addon, 		"FP_ROAM_NW_TROLLAREA_PATH_38_MONSTER_02");
	Wld_InsertNpc 	(Bloodfly, 		"NW_TROLLAREA_PATH_38_MONSTER");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PLANE_04");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_RUINS_17");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_RUINS_17");

	Wld_InsertNpc 	(Gobbo_Black, 		"NW_TROLLAREA_RUINS_14");
	Wld_InsertNpc 	(Gobbo_Black, 		"NW_TROLLAREA_RUINS_14");

	Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_RUINS_32");
	Wld_InsertNpc 	(Waran, 		"NW_TROLLAREA_RUINS_32");

	Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_71_MONSTER");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_71_MONSTER2");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_71_MONSTER2");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_71_MONSTER2");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_15_MONSTER");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_15_MONSTER");

	Wld_InsertNpc 	(Grimbald_Snapper1, 		"NW_TROLLAREA_BRIGDE_01");
	Wld_InsertNpc 	(Grimbald_Snapper2, 		"NW_TROLLAREA_BRIGDE_01");
	Wld_InsertNpc 	(Grimbald_Snapper3, 		"NW_TROLLAREA_BRIGDE_01");

	Wld_InsertNpc 	(Molerat, 		"NW_TROLLAREA_RITUALFOREST_04_MONSTER");
	Wld_InsertNpc 	(Molerat, 		"NW_TROLLAREA_RITUALFOREST_04_MONSTER");
	Wld_InsertItem 	(ItWr_HitPointStonePlate1_Addon, 	"FP_ROAM_NW_TROLLAREA_RITUAL_08_02");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_RITUALPATH_04");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_RITUALPATH_04");
	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_RITUALPATH_04");

	Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_RITUAL_13");
	Wld_InsertNpc 	(Gobbo_Skeleton, 		"NW_TROLLAREA_RITUAL_13");

	Wld_InsertNpc 	(Bloodfly, 		"NW_TROLLAREA_RITUALPATH_032");
	Wld_InsertNpc 	(Bloodfly, 		"NW_TROLLAREA_RITUALPATH_032");
	Wld_InsertNpc 	(Bloodfly, 		"NW_TROLLAREA_RITUALPATH_032");

	Wld_InsertNpc 	(Wisp, 		"NW_TROLLAREA_PLANE_01");
	Wld_InsertItem 	(ItWr_HitPointStonePlate2_Addon, 		"FP_ROAM_NW_TROLLAREA_PLANE_01_01");

	Wld_InsertNpc 	(Scavenger, 		"NW_TROLLAREA_PATH_22_MONSTER");

	Wld_InsertNpc 	(Molerat, 		"NW_TROLLAREA_RITUALFOREST_06_MONSTER");
	Wld_InsertNpc 	(Molerat, 		"NW_TROLLAREA_RITUALFOREST_06_MONSTER");

	Wld_InsertNpc 	(Lurker, 		"NW_TROLLAREA_PATH_08");

	Wld_InsertNpc 	(Giant_Rat, 	"NW_TROLLAREA_BRIGDE_05");
	Wld_InsertNpc 	(Giant_Rat, 	"NW_TROLLAREA_BRIGDE_05");
	
	//TROLLROCKCAVE
	Wld_InsertNpc 	(Skeleton, 	"NW_TROLLAREA_TROLLROCKCAVE_03");
	Wld_InsertNpc 	(Skeleton, 	"NW_TROLLAREA_TROLLROCKCAVE_03");
	
	Wld_InsertNpc 	(Skeleton, 	"NW_TROLLAREA_TROLLROCKCAVE_05");
	
	Wld_InsertNpc 	(Skeleton_Lord, 	"NW_TROLLAREA_TROLLROCKCAVE_07");
	Wld_InsertNpc 	(Skeleton_Lord, 	"NW_TROLLAREA_TROLLROCKCAVE_10");
	
	//TROLLLAKECAVE
	Wld_InsertNpc 	(Meatbug, 				"NW_TROLLAREA_TROLLLAKECAVE_03A");
	Wld_InsertNpc 	(Meatbug, 				"NW_TROLLAREA_TROLLLAKECAVE_03A");
	Wld_InsertNpc 	(Meatbug, 				"NW_TROLLAREA_TROLLLAKECAVE_03A");
	Wld_InsertNpc 	(Meatbug, 				"NW_TROLLAREA_TROLLLAKECAVE_03A");
	
	Wld_InsertNpc 	(Giant_Rat, 	"NW_TROLLAREA_TROLLLAKECAVE_02");
	
	Wld_InsertNpc 	(Gobbo_Warrior, 	"NW_TROLLAREA_TROLLLAKECAVE_08");
	Wld_InsertNpc 	(Gobbo_Black, 	"NW_TROLLAREA_TROLLLAKECAVE_08");
	Wld_InsertNpc 	(Gobbo_Green, 	"NW_TROLLAREA_TROLLLAKECAVE_08");
	
	Wld_InsertNpc 	(Gobbo_Green, 	"NW_TROLLAREA_TROLLLAKECAVE_09");
	
	//RIVERSIDECAVE
	Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_02");
	Wld_InsertItem 	(ItWr_HitPointStonePlate3_Addon, 	"FP_ROAM_NW_TROLLAREA_RIVERSIDECAVE_01_03");
	
	Wld_InsertNpc 	(Shadowbeast, 	"NW_TROLLAREA_RIVERSIDECAVE_07");
		
};

	FUNC VOID INIT_SUB_NewWorld_Part_TrollArea_01()
	{
	};

FUNC VOID INIT_NewWorld_Part_TrollArea_01 ()
{
	B_InitMonsterAttitudes (); 
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	INIT_SUB_NewWorld_Part_TrollArea_01();	
};

// ------ World -------
FUNC VOID STARTUP_NewWorld()
{	
	// ------ StartUps der Unter-Parts ------ 
	STARTUP_NewWorld_Part_City_01();
	STARTUP_NewWorld_Part_Farm_01();
	STARTUP_NewWorld_Part_Xardas_01();
	STARTUP_NewWorld_Part_Monastery_01();
	STARTUP_NewWorld_Part_GreatPeasant_01();
	STARTUP_NewWorld_Part_TrollArea_01();
	STARTUP_NewWorld_Part_Forest_01();
	STARTUP_NewWorld_Part_Pass_To_OW_01();
	// ------ INTRO - muss ganz am Ende der Startup stehen ------
	Kapitel = 1; //Joly: Kann hier stehen bleiben!
	PlayVideo ("INTRO.BIK");
	PlayVideo ("Addon_Title.BIK");
	
	//-----Addon Talent Goldhacken---------
	Hero_HackChance = 10;
};
FUNC VOID INIT_NewWorld()
{
    B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	B_ENTER_NEWWORLD ();
	
	// ------- Diebesgilde abt�ten ------ 
	if (Diebesgilde_Verraten)
	&& (Andre_Diebesgilde_aufgeraeumt != TRUE)
	{
		if (!Npc_IsDead(Cassia))
		|| (!Npc_IsDead(Jesper))
		|| (!Npc_IsDead(Ramirez))
		{
			B_KillNpc(VLK_447_Cassia);
			B_KillNpc(VLK_446_Jesper);
			B_KillNpc(VLK_445_Ramirez);
			Andre_Diebesgilde_aufgeraeumt = TRUE;
		};
	};
	
	// ------ INITS der Unter-Parts ------ 
	INIT_SUB_NewWorld_Part_City_01();
	INIT_SUB_NewWorld_Part_Farm_01();
	INIT_SUB_NewWorld_Part_Xardas_01();
	INIT_SUB_NewWorld_Part_Monastery_01();
	INIT_SUB_NewWorld_Part_GreatPeasant_01();
	INIT_SUB_NewWorld_Part_TrollArea_01();
	INIT_SUB_NewWorld_Part_Forest_01();
	INIT_SUB_NewWorld_Part_Pass_To_OW_01();
	
	if (MIS_ReadyForChapter3  == TRUE )	//Joly: mu� hier in der INIT ganz zum schluss stehen, nachdem alle NSCs f�rs Kapitel insertet wurden!!!
	&& (B_Chapter3_OneTime == FALSE)
	{
		B_Kapitelwechsel (3,NEWWORLD_ZEN);
		B_Chapter3_OneTime = TRUE;
	};

	if (MIS_AllDragonsDead  == TRUE )	//Joly: mu� hier in der INIT ganz zum schluss stehen, nachdem alle NSCs f�rs Kapitel insertet wurden!!!
	&& (B_Chapter5_OneTime == FALSE)
	{
		B_Kapitelwechsel (5, NEWWORLD_ZEN);
		B_Chapter5_OneTime = TRUE;
	};
};


// ------ AddonWorld -------
FUNC VOID STARTUP_AddonWorld ()
{	
	STARTUP_ADDON_PART_BANDITSCAMP_01 ();
	STARTUP_ADDON_PART_PIRATESCAMP_01 ();
	STARTUP_ADDON_PART_ENTRANCE_01 ();
	STARTUP_ADDON_PART_GOLDMINE_01 ();
	STARTUP_ADDON_PART_CANYON_01 ();
	STARTUP_ADDON_PART_VALLEY_01 ();
	STARTUP_ADDON_PART_ADANOSTEMPLE_01 ();
		
	// ------ StartUps der Unter-Parts ------ 
	ENTERED_ADDONWORLD = TRUE;
	CurrentLevel = ADDONWORLD_ZEN;	 
	Wld_SetTime	(60,00);//Joly: KDW sind schon 2 Tag da. SC hat ein biosschen l�nger gebraucht.
};
FUNC VOID INIT_AddonWorld ()
{
	INIT_SUB_ADDON_PART_BANDITSCAMP_01 ();
	INIT_SUB_ADDON_PART_PIRATESCAMP_01 ();
 	INIT_SUB_ADDON_PART_ENTRANCE_01 ();
   	INIT_SUB_ADDON_PART_GOLDMINE_01 ();
   	INIT_SUB_ADDON_PART_CANYON_01 ();
   	INIT_SUB_ADDON_PART_VALLEY_01 ();
   	INIT_SUB_ADDON_PART_ADANOSTEMPLE_01 ();
   
    B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();
	
	B_ENTER_ADDONWORLD ();
	
	// ------ INITS der Unter-Parts ------ 
};

// ------ SonjaWorld -------
FUNC VOID STARTUP_SonjaWorld ()
{

	// ------ StartUps der Unter-Parts ------
	CurrentLevel = SONJAWORLD_ZEN;
	Wld_SetTime	(60,00);//Joly: KDW sind schon 2 Tag da. SC hat ein biosschen l�nger gebraucht.
};

FUNC VOID INIT_SonjaWorld ()
{
    B_InitMonsterAttitudes ();
	B_InitGuildAttitudes();
	B_InitNpcGlobals ();

	B_ENTER_SONJAWORLD ();

	// ------ INITS der Unter-Parts ------
};



// *****************************************************************************************
// Mobsi-Fokusnamen
// *****************************************************************************************

CONST STRING MOBNAME_CRATE			= "Kiste";					//Kisten
CONST STRING MOBNAME_CHEST			= "Truhe";					//Truhen
CONST STRING MOBNAME_BED			= "Bett";					//Betten
CONST STRING MOBNAME_DOOR			= "T�r";					//T�ren
CONST STRING MOBNAME_CAMPFIRE		= "";						//Lagerfeuer
CONST STRING MOBNAME_TORCH			= "";						//Fackel
CONST STRING MOBNAME_TORCHHOLDER	= "";						//Fackelhalter
CONST STRING MOBNAME_BARBQ_SCAV		= "";						//Scavebger	am Spiess
CONST STRING MOBNAME_BARBQ_SHEEP	= "";						//Schafe am	Spiess
CONST STRING MOBNAME_BENCH			= "";						//Bank
CONST STRING MOBNAME_ANVIL			= "Amboss";					//Amboss
CONST STRING MOBNAME_BUCKET			= "Wasser-Eimer";			//Wassereimer
CONST STRING MOBNAME_FORGE			= "Schmiede-Feuer";			//Schmiede
CONST STRING MOBNAME_GRINDSTONE		= "Schleifstein";			//Schleifstein
CONST STRING MOBNAME_WHEEL			= "Winde";					//Winde
CONST STRING MOBNAME_LAB			= "Alchemietisch";			//Alchemietisch
CONST STRING MOBNAME_BOOKSTAND		= "Buchst�nder";			//Buchst�nder
CONST STRING MOBNAME_BOOKSBOARD		= "Buchkommode";			//Kommode mit Buch
CONST STRING MOBNAME_CHAIR			= "";						//St�hle
CONST STRING MOBNAME_CAULDRON		= "Kessel";					//Kochkessel
CONST STRING MOBNAME_SEAT			= "";						//Sessel
CONST STRING MOBNAME_THRONE			= "";						//Thron
CONST STRING MOBNAME_PAN			= "Pfanne";					//Lagerfeuer mit Pfanne
CONST STRING MOBNAME_REPAIR			= "";						//Repair Mobsi
CONST STRING MOBNAME_WATERPIPE		= "Wasserpfeife";			//Blubber
CONST STRING MOBNAME_SWITCH			= "Schalter";				//alle Schalter
CONST STRING MOBNAME_ORE			= "Erzklumpen";				//Erzmobsi
CONST STRING MOBNAME_WINEMAKER		= "";						//Weinstampfe
CONST STRING MOBNAME_ORCDRUM		= "";						//Orkische Kriegstrommel
CONST STRING MOBNAME_STOVE			= "Herd";					//HerdMobsi
CONST STRING MOBNAME_INNOS			= "Innos Statue";			//Innos	Staue
CONST STRING MOBNAME_RUNEMAKER		= "Runentisch";				//Runentisch
CONST STRING MOBNAME_SAW			= "Baums�ge";				//S�gemobsi
CONST STRING MOBNAME_ARMCHAIR		= "Sessel";
CONST STRING MOBNAME_LIBRARYLEVER	= "Lampe";
CONST STRING MOBNAME_SECRETSWITCH	= "";
CONST STRING MOBNAME_BIBLIOTHEK		= "Bibliothek";
CONST STRING MOBNAME_VORRATSKAMMER	= "Vorratskammer";
CONST STRING MOBNAME_SCHATZKAMMER	= "Schatzkammer";
CONST STRING MOBNAME_IGARAZ			= "Igaraz Truhe";
const string MOBNAME_ALMANACH		= "Almanach";
//Wegweiser
CONST STRING MOBNAME_CITY			= "Nach Khorinis";
CONST STRING MOBNAME_TAVERN			= "Zur Taverne";
CONST STRING MOBNAME_GR_PEASANT		= "Zum Gro�bauer";
CONST STRING MOBNAME_MONASTERY		= "Zum Kloster";
CONST STRING MOBNAME_PASSOW			= "Zum Pass";
CONST STRING MOBNAME_CITY2			= "Zur Taverne";//
CONST STRING MOBNAME_LIGHTHOUSE		= "Zum Leuchturm";
CONST STRING MOBNAME_MONASTERY2		= "Zur Taverne";//
CONST STRING MOBNAME_PRISON			= "zur Gef�ngnis-Kolonie";
CONST STRING MOBNAME_GR_PEASANT2	= "Zur Taverne";//
CONST STRING MOBNAME_INCITY01		= "zum Hafen";
CONST STRING MOBNAME_INCITY02		= "zum Marktplatz";
CONST STRING MOBNAME_INCITY03		= "zum Oberen Viertel";
CONST STRING MOBNAME_INCITY04		= "zur Kaufmannsgasse";
CONST STRING MOBNAME_INCITY05		= "zum Tempelplatz";


//Ladenschilder
CONST STRING MOBNAME_BOW_01			= "Bognerei 'Zum T�dlichen Pfeil'";
CONST STRING MOBNAME_MIX_01			= "Matteo's Allerlei";
CONST STRING MOBNAME_MIX_02			= "Halvor's Fischstube 'zur glitschigen Forelle'";
CONST STRING MOBNAME_SMITH_01		= "Zum gl�henden Amboss";
CONST STRING MOBNAME_BAR_01			= "Taverne 'zum Einbeinigen Klabauter'";
CONST STRING MOBNAME_BAR_02			= "Taverne 'zur fr�hlichen Mastsau'";
CONST STRING MOBNAME_Hotel_01		= "Herberge 'zum Schlafenden Geldsack'";
CONST STRING MOBNAME_Hotel_02		= "Die rote Laterne";
CONST STRING MOBNAME_TAVERN_01		= "Zur toten Harpie";
CONST STRING MOBNAME_SALANDRIL		= "Salandril's Tr�nke";


//Grabsteine TEAM
CONST STRING MOBNAME_GRAVETEAM_01	 = "Snoelk - 'Oh guck mal ein Schalter'";
CONST STRING MOBNAME_GRAVETEAM_02	 = "Oelk - 'NEINNNNNNNNNNNNNNNNNN'";
CONST STRING MOBNAME_GRAVETEAM_03	 = "Hodges - 'Alles wird gut'";
CONST STRING MOBNAME_GRAVETEAM_04	 = "Hosh - 'Der letzte Scheiss'";
CONST STRING MOBNAME_GRAVETEAM_05	 = "Chase - 'Was haltet ihr davon ?'";
CONST STRING MOBNAME_GRAVETEAM_06	 = "Bj�rn - 'Weiter auf�s Ziel zu!'";
CONST STRING MOBNAME_GRAVETEAM_07	 = "Michael - 'Ich ruhe mich nur kurz aus...'";
CONST STRING MOBNAME_GRAVETEAM_08	 = "Kairo - 'Sek�ndchen noch!'";
CONST STRING MOBNAME_GRAVETEAM_09	 = "Onkel Kronkel - 'zum Schlu� fand er den Skorpionmann'";
CONST STRING MOBNAME_GRAVETEAM_10	 = "NicoDE - 'Hello, World!'";
CONST STRING MOBNAME_GRAVETEAM_11	 = "Sascha - 'Der Spieler wei� gar nicht, warum er dahin gehen soll...'";
CONST STRING MOBNAME_GRAVETEAM_12	 = "Andre - 'Fallen die Segel schnell oder langsam runter?'";
CONST STRING MOBNAME_GRAVETEAM_13	 = "Mihai - 'Yeah, I can show you something..'";
CONST STRING MOBNAME_GRAVETEAM_14	 = "Uwe - 'Welcher Level bist du denn mit deinem Paladin'";


//Grabsteine
CONST STRING MOBNAME_GRAVE_01	 = "Baron Heinrich von Stahl 551 - 589 'Er kam, sah, und starb'";
CONST STRING MOBNAME_GRAVE_02	 = "Bertran 465 - 480 'Ich wollte immer schon mal Fliegenpilze essen'";
CONST STRING MOBNAME_GRAVE_03	 = "Isolde 525 - 550";
CONST STRING MOBNAME_GRAVE_04	 = "Unbekannt";
CONST STRING MOBNAME_GRAVE_05	 = "Dex Cantionis 325 - 431 'Ich hab schon seit Tagen Magenkr�mpfe?'";
CONST STRING MOBNAME_GRAVE_06	 = "Uthar Lichtbringer 205 - 531";
CONST STRING MOBNAME_GRAVE_07	 = "Yasmin 510 - 545";
CONST STRING MOBNAME_GRAVE_08	 = "Onurb 634 - 579 - 'Etlepmerkegmu red'";
CONST STRING MOBNAME_GRAVE_09	 = "unbekannter Soldat";
CONST STRING MOBNAME_GRAVE_10	 = "Mighty Alien Dwarf 2894-3787 - 'This is all fake! Believe me...'";
CONST STRING MOBNAME_GRAVE_11	 = "Theodor 220 - 310 - 'Sein Geist sei befreit'";
CONST STRING MOBNAME_GRAVE_12	 = "Veranim Sadea 390 - 'Die Unterwelt war sein Belang'";
CONST STRING MOBNAME_GRAVE_13	 = "Serano Ukara 234 - 298 'Der, der den Turm bewachte'";
CONST STRING MOBNAME_GRAVE_14	 = "Victimo Sorn 456 - 512 'Erst der Phoenix stoppte ihn'";
CONST STRING MOBNAME_GRAVE_15	 = " +432 'Man nannte ihn Heristun, er kam vom Meer''";
CONST STRING MOBNAME_GRAVE_16	 = "Ernesto Ortoj 350 - 410 'Ich werde immer bei dir bleiben'";
CONST STRING MOBNAME_GRAVE_17	 = "Arthag Amashrog 730 - 756";
CONST STRING MOBNAME_GRAVE_18	 = "Iotar 721 - 762";
CONST STRING MOBNAME_GRAVE_19	 = "Midos 757 - 759";
CONST STRING MOBNAME_GRAVE_20	 = "Oskar Sorn 703 - 736";
CONST STRING MOBNAME_GRAVE_21	 = "Marta Ukara 732 - 771";
CONST STRING MOBNAME_GRAVE_22	 = "Wilfied Ukara 722 - 764";
CONST STRING MOBNAME_GRAVE_23	 = "Viktorus Stahl 741 - 755";
CONST STRING MOBNAME_GRAVE_24	 = "Seb 725 - 773";
CONST STRING MOBNAME_GRAVE_25	 = "Unbekannt";
CONST STRING MOBNAME_GRAVE_26	 = "Mart Mulgo 721 - 779";
CONST STRING MOBNAME_GRAVE_27	 = "Zahra 713 - 752";
CONST STRING MOBNAME_GRAVE_28	 = "Freiherr Simbus von Kahr 120 - 212";
CONST STRING MOBNAME_GRAVE_29	 = "Graf Anieb zu Waldfried 117 - 212";
CONST STRING MOBNAME_GRAVE_30	 = "Graf Lazar von Siegburg 156 - 212";
CONST STRING MOBNAME_GRAVE_31	 = "Schwerttr�ger Asub Ukara 145 - 212";
CONST STRING MOBNAME_GRAVE_32	 = "Schwerttr�ger Dietmar Ukara 112 - 212";
CONST STRING MOBNAME_GRAVE_33	 = "Ehrengardist Uthar Seranis 178 - 212";


//ADDON>

const string MOBNAME_ADDON_SOCKEL				= "Sockel";
const string MOBNAME_ADDON_FORTUNO				= "Fortuno's Truhe"; 
const string MOBNAME_ADDON_IDOL					= "Beliar Statue"; 
const string MOBNAME_ADDON_GOLD					= "Goldklumpen";
CONST STRING MOBNAME_ADDON_STONEBOOK			= "Pult";
const string MOBNAME_ADDON_ORNAMENT				= "Ringf�rmige Vorrichtung";
const string MOBNAME_ADDON_ORNAMENTSWITCH		= "Schalter";
const string MOBNAME_ADDON_WACKELBAUM			= "Wackeliger Baum";
const string NAME_ADDON_TengronsRing			= "Tengron's Ring";
const string NAME_ADDON_CASSIASBELOHNUNGSRING	= "Ring der Lebenskraft";

const string MOBNAME_ADDON_TELEPORT_01 = "zum Tempelportal";
const string MOBNAME_ADDON_TELEPORT_02 = "zum Banditenlager";
const string MOBNAME_ADDON_TELEPORT_03 = "zum Sumpf";
const string MOBNAME_ADDON_TELEPORT_04 = "zum Tal";
const string MOBNAME_ADDON_TELEPORT_05 = "zum Canyon";

//ADDON<

// *****************************************************************************************
// Gildennamen
// *****************************************************************************************

CONST STRING TXT_GUILDS	[GIL_MAX] =	{
// - Charakterblatt	(Text der Spielergilde)
// - Debuganzeige (Taste "G")

	"Gildenlos"		,
	"Paladin"		,
	"Miliz"			,
	"B�rger"		,
	"Magier"		,
	"Novize"		,
	"Drachenj�ger"	,
	"S�ldner"		,
	"Bauer"			,
	"Bandit"		,
	"Str�fling"		,
	"Suchender"		,
	"Landbewohner"	,
	"Pirat"			, //Addon
	"Wassermagier"	, //Addon
	"D"				,
	""				, //16 - Gil_Seperator_Hum
	"Fleischwanze"	,
	"Schaf"			,
	"Goblin"		,
	"Goblin Skelett",
	"B. Goblin Skelett",
	"Scavenger"		,
	"Riesenratte"	,
	"Feldr�uber"	,
	"Blutfliege"	,
	"Waran"			,
	"Wolf"			,
	"B. Wolf"		,
	"Minecrawler"	,
	"Lurker"		,
	"Skelett"		,
	"B. Skelett"	,
	"Skelett-Magier",
	"Zombie"		,
	"Snapper"		,
	"Schattenl�ufer",
	"Skelettmonster",
	"Harpie"		,
	"Steingolem"	,
	"Feuergolem"	,
	"Eisgolem"		,
	"B. Golem"		, //beschworener Golem
	"D�mon"			,
	"B. D�mon"		,
	"Troll"			,
	"Sumpfhai"		,
	"Drache"		,
	"Molerat"		,
	"Alligator"		, //Addon
	"Sumpfgolem"	, //Addon
	"W�chter"		, //Addon
	"Steinpuma"		, //Addon
	"A"				, //Addon
	"W�chter"		, //Addon
	"Zombie"		, //Addon
	""				,
	""				,
	""				, //58 - Gil_Seperator_Orc
	"Ork"			,
	"Ork"			,
	"Untoter Ork"	,
	"Drakonier"		,
	"X"				,
	"Y"				,
	"Z"				
};


//FixMeHoshi Fokus und Spellnamen abgleichen. (auch	im B_TEachTalentRunes!!)

////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Spell-Namen (Array)
//

const string TXT_SPELLS[MAX_SPELL] =
{
	// Paladin-Runen
	"Heiliges Licht",			// 0	SPL_PalLight
	"Kleine Wundheilung",		// 1	SPL_PalLightHeal
	"Heiliger Pfeil",			// 2	SPL_PalHolyBolt
	"Mittlere Wundheilung",		// 3	SPL_PalMediumHeal
	"B�ses Vertreiben",			// 4	SPL_PalRepelEvil
	"Grosse Wundheilung",		// 5	SPL_PalFullHeal
	"B�ses Vernichten",			// 6	SPL_PalDestroyEvil

	// Teleport-Runen
	"Teleport",					// 7	SPL_PalTeleportSecret
	"Zur Hafenstadt",			// 8	SPL_TeleportSeaport
	"Zum Kloster",				// 9	SPL_TeleportMonastery
	"Zum Grossbauern",			// 10	SPL_TeleportFarm
	"Zu Xardas",				// 11	SPL_TeleportXardas
	"Zum Pass in Khorinis",		// 12	SPL_TeleportPassNW
	"Zum Pass im Minental",		// 13	SPL_TeleportPassOW
	"Zur Burg",					// 14	SPL_TeleportOC
	"Zum alten D�monenturm",	// 15	SPL_TeleportOWDemonTower
	"Zur Taverne",				// 16	SPL_TeleportTaverne
	"TXT_SPL_TELEPORT_3",		// 17	SPL_Teleport_3

	// Kreis 1
	"Licht",					// 18	SPL_Light
	"Feuerpfeil",				// 19	SPL_Firebolt

	// Kreis 2
	"Eispfeil",					// 20	SPL_Icebolt

	// Kreis 1
	"leichte Wunden heilen",	// 21	SPL_LightHeal
	"Goblin Skelett",			// 22	SPL_SummonGoblinSkeleton

	// Kreis 2
	"Feuerball",				// 23	SPL_InstantFireball

	// Kreis 1
	"Blitz",					// 24	SPL_Zap

	// Kreis 2
	"Wolf rufen",				// 25	SPL_SummonWolf
	"Windfaust",				// 26	SPL_WindFist
	"Schlaf",					// 27	SPL_Sleep

	// Kreis 3
	"mittlere Wunden heilen",	// 28	SPL_MediumHeal
	"Blitzschlag",				// 29	SPL_LightningFlash
	"Grosser Feuerball",		// 30	SPL_ChargeFireball
	"Skelett",					// 31	SPL_SummonSkeleton
	"Angst",					// 32	SPL_Fear
	"Eisblock",					// 33	SPL_IceCube
	"Kugelblitz",				// 34	SPL_ChargeZap

	// Kreis 4
	"Golem erschaffen",			// 35	SPL_SummonGolem
	"Untote vernichten",		// 36	SPL_DestroyUndead
	"Grosser Feuersturm",		// 37	SPL_Pyrokinesis

	// Kreis 5
	"Kleiner Feuersturm",		// 38	SPL_Firestorm
	"Eiswelle",					// 39	SPL_IceWave
	"D�mon",					// 40	SPL_SummonDemon
	"Vollheilung",				// 41	SPL_FullHeal

	// Kreis 6
	"Feuerregen",				// 42	SPL_Firerain
	"Todeshauch",				// 43	SPL_BreathOfDeath
	"Massensterben",			// 44	SPL_MassDeath
	"Armee der Finsternis",		// 45	SPL_ArmyOfDarkness
	"Schrumpfen",				// 46	SPL_Shrink

	// Scrolls
	"Schaf",					// 47	SPL_TrfSheep
	"Scavenger",				// 48	SPL_TrfScavenger
	"Riesenratte",				// 49	SPL_TrfGiantRat
	"Feldr�uber",				// 50	SPL_TrfGiantBug
	"Wolf",						// 51	SPL_TrfWolf
	"Waran",					// 52	SPL_TrfWaran
	"Snapper",					// 53	SPL_TrfSnapper
	"Warg",						// 54	SPL_TrfWarg
	"Feuerwaran",				// 55	SPL_TrfFireWaran
	"Lurker",					// 56	SPL_TrfLurker
	"Shadowbeast",				// 57	SPL_TrfShadowbeast
	"Dragon Snapper",			// 58	SPL_TrfDragonSnapper
	"Vergessen"	,				// 59	SPL_Charm

	// Kreis 5
	"Heiliges Gescho�",			// 60	SPL_MasterOfDisaster

	// ???
	"TXT_SPL_DEATHBOLT",		// 61	SPL_Deathbolt
	"TXT_SPL_DEATHBALL",		// 62	SPL_Deathball
	"TXT_SPL_CONCUSSIONBOLT",	// 63	SPL_ConcussionBolt
	"TXT_SPL_RESERVED_64",		// 64	SPL_Reserved_64
	"TXT_SPL_RESERVED_65",		// 65	SPL_Reserved_65
	"TXT_SPL_RESERVED_66",		// 66	SPL_Reserved_66
	"TXT_SPL_RESERVED_67",		// 67	SPL_Reserved_67
  	"TXT_SPL_RESERVED_68",		// 68	SPL_Reserved_68
  	"TXT_SPL_RESERVED_69",		// 69	SPL_Reserved_69
  
  	// Magick (Wasser)
 	"Unwetter",					// 70	SPL_Thunderstorm
	"Windhose",					// 71	SPL_Whirlwind
	"Wasserfaust",				// 72	SPL_WaterFist
	"Eislanze",					// 73	SPL_IceLance
	"Menschen Aufbl�hen",		// 74	SPL_Inflate
	"Geysir",					// 75	SPL_Geyser
	"Wasserwand",				// 76	SPL_Waterwall
	"TXT_SPL_RESERVED_77",		// 77	SPL_Reserved_77
	"TXT_SPL_RESERVED_78",		// 78	SPL_Reserved_78
	"TXT_SPL_RESERVED_79",		// 79	SPL_Reserved_79

	// Magick (Maya)
	"Insektenplage",			// 80	SPL_Plague
	"Insektenschwarm",			// 81	SPL_Swarm
	"Wurzelschlingen",			// 82	SPL_GreenTentacle
	"Erdbeben",					// 83	SPL_Earthquake
	"W�chter erschaffen",		// 84	SPL_SummonGodzilla
	"Beliar's Zorn",			// 85	SPL_Energyball
	"Energie stehlen",			// 86	SPL_SuckEnergy
	"Schrei der Toten",			// 87	SPL_Skull
	"Zombie erschaffen",		// 88	SPL_SummonZombie
	"Mud beschw�ren",			// 89	SPL_SummonMud

	// ...
	"TXT_SPL_Reserved_90n",		// 90	SPL_Reserved_90
	"TXT_SPL_Reserved_91",		// 91	SPL_Reserved_91
	"TXT_SPL_RESERVED_92",		// 92	SPL_Reserved_92
	"TXT_SPL_RESERVED_93",		// 93	SPL_Reserved_93
	"TXT_SPL_RESERVED_94",		// 94	SPL_Reserved_94
	"TXT_SPL_RESERVED_95",		// 95	SPL_Reserved_95
	"TXT_SPL_RESERVED_96",		// 96	SPL_Reserved_96
	"TXT_SPL_RESERVED_97",		// 97	SPL_Reserved_97
	"TXT_SPL_RESERVED_98",		// 98	SPL_Reserved_98
	"TXT_SPL_RESERVED_99",		// 99	SPL_Reserved_99

	// Sonja
	"Sonja herbeirufen",		 // 100	SPL_SummonSonja
	"Zu Sonja",		             // 101	SPL_teleportSonja
	"Zur Roten Laterne"		     // 102	SPL_TeleportRoteLaterne
};

////////////////////////////////////////////////////////////////////////////////
//
//	Spells:	Spell-Namen (Konstanten)
//

// Paladin Runen
const string NAME_SPL_PalLight				= "Heiliges Licht";
const string NAME_SPL_PalLightHeal			= "Kleine Wundheilung";
const string NAME_SPL_PalHolyBolt			= "Heiliger Pfeil";
const string NAME_SPL_PalMediumHeal			= "Mittlere Wundheilung";
const string NAME_SPL_PalRepelEvil			= "B�ses vertreiben";
const string NAME_SPL_PalFullHeal			= "Grosse Wundheilung";
const string NAME_SPL_PalDestroyEvil		= "B�ses vernichten";

// Teleport	Runen
const string NAME_SPL_PalTeleportSecret		= "Teleport";
const string NAME_SPL_TeleportSeaport		= "Teleport zur Hafenstadt";
const string NAME_SPL_TeleportMonastery		= "Teleport zum Kloster";
const string NAME_SPL_TeleportFarm			= "Teleport zum Grossbauern";
const string NAME_SPL_TeleportXardas		= "Teleport zu Xardas";
const string NAME_SPL_TeleportPassNW		= "Teleport zum Pass in Khorinis";
const string NAME_SPL_TeleportPassOW		= "Teleport zum Pass im Minental";
const string NAME_SPL_TeleportOC			= "Teleport zur Burg";
const string NAME_SPL_TeleportOWDemonTower	= "Teleport zum alten D�monenturm";
const string NAME_SPL_TeleportTaverne		= "Teleport zur Taverne";
const string NAME_SPL_Teleport_3			= "NAME_SPL_TELEPORT_3";

// Kreis 1
const string NAME_SPL_LIGHT					= "Licht";
const string NAME_SPL_Firebolt				= "Feuerpfeil";

// Kreis 2
const string NAME_SPL_Icebolt				= "Eispfeil";

// Kreis 1
const string NAME_SPL_LightHeal				= "Leichte Wunden heilen";
const string NAME_SPL_SummonGoblinSkeleton	= "Goblin Skelett erschaffen";

// Kreis 2
const string NAME_SPL_InstantFireball		= "Feuerball";

// Kreis 1
const string NAME_SPL_Zap					= "Blitz";

// Kreis 2
const string NAME_SPL_SummonWolf			= "Wolf rufen";
const string NAME_SPL_WINDFIST				= "Windfaust";
const string NAME_SPL_Sleep					= "Schlaf";

// Kreis 3
const string NAME_SPL_MediumHeal			= "Mittlere Wunden heilen";
const string NAME_SPL_Firestorm				= "Kleiner Feuersturm";
const string NAME_SPL_SummonSkeleton		= "Skelett erschaffen";
const string NAME_SPL_Fear					= "Angst";
const string NAME_SPL_IceCube				= "Eisblock";
const string NAME_SPL_ChargeZap				= "Kugelblitz";

// Kreis 4
const string NAME_SPL_LightningFlash		= "Blitzschlag";
const string NAME_SPL_SummonGolem			= "Golem erwecken";
const string NAME_SPL_DestroyUndead			= "Untote vernichten";
const string NAME_SPL_ChargeFireball		= "Grosser Feuerball";

// Kreis 5
const string NAME_SPL_Pyrokinesis			= "Grosser Feuersturm";
const string NAME_SPL_IceWave				= "Eiswelle";
const string NAME_SPL_SummonDemon			= "D�mon beschw�ren";
const string NAME_SPL_FullHeal				= "Schwere Wunden heilen";

// Kreis 6
const string NAME_SPL_Firerain				= "Feuerregen";
const string NAME_SPL_BreathOfDeath			= "Todeshauch";
const string NAME_SPL_MassDeath				= "Todeswelle";
const string NAME_SPL_ArmyOfDarkness		= "Armee der Finsternis";
const string NAME_SPL_Shrink				= "Monster schrumpfen";

// Scrolls
const string NAME_SPL_TrfSheep				= "Verwandlung Schaf";
const string NAME_SPL_TrfScavenger			= "Verwandlung Scavenger";
const string NAME_SPL_TrfGiantRat			= "Verwandlung Riesenratte";
const string NAME_SPL_TrfGiantBug			= "Verwandlung Feldr�uber";
const string NAME_SPL_TrfWolf				= "Verwandlung Wolf";
const string NAME_SPL_TrfWaran				= "Verwandlung Waran";
const string NAME_SPL_TrfSnapper			= "Verwandlung Snapper";
const string NAME_SPL_TrfWarg				= "Verwandlung Warg";
const string NAME_SPL_TrfFireWaran			= "Verwandlung Feuerwaran";
const string NAME_SPL_TrfLurker				= "Verwandlung Lurker";
const string NAME_SPL_TrfShadowbeast		= "Verwandlung Schattenl�ufer";
const string NAME_SPL_TrfDragonSnapper		= "Verwandlung Drachensnapper";
const string NAME_SPL_Charm					= "Vergessen";

// Kreis 5
const string NAME_SPL_MasterOfDisaster		= "Heiliges Geschoss";

// ???
const string NAME_SPL_Deathbolt				= "NAME_SPL_DEATHBOLT";
const string NAME_SPL_Deathball				= "NAME_SPL_DEATHBALL";
const string NAME_SPL_ConcussionBolt		= "NAME_SPL_CONCUSSIONBOLT";
const string NAME_SPL_Reserved_64			= "NAME_SPL_RESERVED_64";
const string NAME_SPL_Reserved_65			= "NAME_SPL_RESERVED_65";
const string NAME_SPL_Reserved_66			= "NAME_SPL_RESERVED_66";
const string NAME_SPL_Reserved_67			= "NAME_SPL_RESERVED_67";
const string NAME_SPL_Reserved_68			= "NAME_SPL_RESERVED_68";
const string NAME_SPL_Reserved_69			= "NAME_SPL_RESERVED_69";

// Magick (Wasser)
const string NAME_SPL_Thunderstorm			= "Unwetter";
const string NAME_SPL_Whirlwind				= "Windhose";
const string NAME_SPL_WaterFist				= "Wasserfaust";
const string NAME_SPL_IceLance				= "Eislanze";
const string NAME_SPL_Inflate				= "Menschen Aufbl�hen";
const string NAME_SPL_Geyser				= "Geysir";
const string NAME_SPL_Waterwall				= "Wasserwand";
const string NAME_SPL_Reserved_77			= "NAME_SPL_RESERVED_77";
const string NAME_SPL_Reserved_78			= "NAME_SPL_RESERVED_78";
const string NAME_SPL_Reserved_79			= "NAME_SPL_RESERVED_79";

// Magick (Maya)
const string NAME_SPL_Plague				= "Insektenplage";
const string NAME_SPL_Swarm					= "Insektenschwarm";
const string NAME_SPL_GreenTentacle			= "Wurzelschlingen";
const string NAME_SPL_Earthquake			= "Erdbeben";
const string NAME_SPL_SummonGuardian		= "W�chter erschaffen";
const string NAME_SPL_BeliarsRage			= "Beliar's Zorn";
const string NAME_SPL_SuckEnergy			= "Energie stehlen";
const string NAME_SPL_Skull					= "Schrei der Toten";
const string NAME_SPL_SummonZombie			= "Zombie erschaffen";
const string NAME_SPL_SummonMud				= "Mud beschw�ren";

// ...
const string NAME_SPL_Reserved_90			= "NAME_SPL_RESERVED_90";
const string NAME_SPL_Reserved_91			= "NAME_SPL_RESERVED_91";
const string NAME_SPL_Reserved_92			= "NAME_SPL_RESERVED_92";
const string NAME_SPL_Reserved_93			= "NAME_SPL_RESERVED_93";
const string NAME_SPL_Reserved_94			= "NAME_SPL_RESERVED_94";
const string NAME_SPL_Reserved_95			= "NAME_SPL_RESERVED_95";
const string NAME_SPL_Reserved_96			= "NAME_SPL_RESERVED_96";
const string NAME_SPL_Reserved_97			= "NAME_SPL_RESERVED_97";
const string NAME_SPL_Reserved_98			= "NAME_SPL_RESERVED_98";
const string NAME_SPL_Reserved_99			= "NAME_SPL_RESERVED_99";


// *****************************************************************************************
// Charakterbogen-Texte: TALENTE
// *****************************************************************************************

CONST STRING TXT_TALENTS [NPC_TALENT_MAX] =
{
	"",							//NPC_TALENT_UNKNOWN			= 0;
	"Einh�nder",				//NPC_TALENT_1H					= 1;
	"Zweih�nder",				//NPC_TALENT_2H					= 2;
	"Bogen",					//NPC_TALENT_BOW				= 3;
	"Armbrust",					//NPC_TALENT_CROSSBOW			= 4;
	"Schl�sser �ffnen",			//NPC_TALENT_PICKLOCK			= 5;	//wird jetzt per DEX geregelt UND es gibt nur noch Level 0 und 1 (nicht	mehr 2)
	"",							//altes	Pickpocket aus Gothic 1	- NICHT	benutzen! Bleibt als Relikt	im Code	= 6;
	"Magie",					//NPC_TALENT_MAGE				= 7;	// Magiekreis
	"Schleichen",				//NPC_TALENT_SNEAK				= 8;
	"",							//raus //NPC_TALENT_REGENERATE	= 9;
	"",							//raus //NPC_TALENT_FIREMASTER	= 10;
	"Akrobatik",				//NPC_TALENT_ACROBAT			= 11;
	"Taschendiebstahl",			//NPC_TALENT_PICKPOCKET			= 12;	//NEUES	Pickpocket
	"Schmieden",				//NPC_TALENT_SMITH				= 13;
	"Runen erschaffen",			//NPC_TALENT_RUNES				= 14;
	"Alchemie",					//NPC_TALENT_ALCHEMY			= 15;
	"Tiere ausweiden",			//NPC_TALENT_TAKEANIMALTROPHY	= 16;
	"Fremde Sprache lesen",		//NPC_TALENT_FOREIGNLANGUAGE	= 17;
	"Irrlicht F�higkeiten",		//NPC_TALENT_WISPDETECTOR		= 18;
	"Aufrei�er",				//NPC_TALENT_C					= 19; // Sonja
	"Zuh�lter",		            //NPC_TALENT_D					= 20;
	""			                //NPC_TALENT_E					= 21;
};


CONST STRING TXT_TALENTS_SKILLS	[NPC_TALENT_MAX] =
{
	"",															//NPC_TALENT_UNKNOWN			= 0;
	"Anf�nger|K�mpfer|Meister",									//NPC_TALENT_1H					= 1;
	"Anf�nger|K�mpfer|Meister",									//NPC_TALENT_2H					= 2;
	"Anf�nger|Sch�tze|Meister",									//NPC_TALENT_BOW				= 3;
	"Anf�nger|Sch�tze|Meister",									//NPC_TALENT_CROSSBOW			= 4;
	"-|Gelernt|-",												//NPC_TALENT_PICKLOCK			= 5;	//wird jetzt per DEX geregelt UND es gibt nur noch Level 0 und 1 (nicht	mehr 2)
	"0|1|2",													//altes	Pickpocket aus Gothic 1	- NICHT	benutzen! Bleibt als Relikt	im Code	= 6;
	"0|1|2|3|4|5|6",											//NPC_TALENT_MAGE				= 7;	// Magiekreis
	"-|Gelernt",												//NPC_TALENT_SNEAK				= 8;
	"-|-",														//raus //NPC_TALENT_REGENERATE	= 9;
	"-|-",														//raus //NPC_TALENT_FIREMASTER	= 10;
	"-|Gelernt",												//NPC_TALENT_ACROBAT			= 11;
	"-|Gelernt",												//NPC_TALENT_PICKPOCKET			= 12;	//NEUES	Pickpocket
	"-|Gelernt",												//NPC_TALENT_SMITH				= 13;
	"-|Gelernt",												//NPC_TALENT_RUNES				= 14;
	"-|Gelernt",												//NPC_TALENT_ALCHEMY			= 15;
	"-|Gelernt",												//NPC_TALENT_TAKEANIMALTROPHY	= 16;
	"-|Gelernt",												//NPC_TALENT_FOREIGNLANGUAGE	= 17;	//ADDON
	"-|Gelernt",												//NPC_TALENT_WISPDETECTOR		= 18;
	"Anf�nger|Player|Guru",							            //NPC_TALENT_C					= 19; // Sonja NPC_TALENT_WOMANIZER
	"0|1|2|3|4|5|6",											//NPC_TALENT_D					= 20; // Sonja NPC_TALENT_PIMP
	""											                //NPC_TALENT_E					= 21;
};


// *****************************************************************************************
// Inventory-Kategorien
// *****************************************************************************************

CONST STRING TXT_INV_CAT [INV_CAT_MAX] = {
	"",
	"Waffen",
	"R�stungen",
	"Magie",
	"Artefakte",
	"Nahrung",
	"Tr�nke",
	"Schriften",
	"Verschiedenes"
};


// ***************************************************************************************
// Fokusnamen der Ambient-NSCs
// ***************************************************************************************

CONST STRING NAME_Paladin		= "Paladin";
CONST STRING NAME_Miliz			= "Stadtwache";
CONST STRING NAME_Torwache		= "Torwache";
CONST STRING NAME_Tuerwache		= "T�rwache";
CONST STRING NAME_Stadtwache	= "Stadtwache";
CONST STRING NAME_Arbeiter		= "Arbeiter";
CONST STRING NAME_Ritter		= "Ritter";
CONST STRING NAME_Wache			= "Wache";
const string NAME_Buerger		= "B�rger";
const string NAME_Buergerin		= "B�rgerin";
const string NAME_Magd			= "Magd";
const string NAME_Magier		= "Magier";
CONST STRING NAME_Novize		= "Novize";
const string NAME_Drachenjaeger	= "Drachenj�ger";
const string NAME_ToterDrachenjaeger = "Toter Drachenj�ger";
CONST STRING NAME_Soeldner		= "S�ldner";
CONST STRING NAME_Bauer			= "Bauer";
CONST STRING NAME_Baeuerin		= "B�uerin";
const string NAME_Bandit		= "Bandit";
const string NAME_Halsabschneider	= "Halsabschneider";
const string NAME_Straefling	= "Str�fling";
const string NAME_Waffenknecht	= "Waffenknecht";
const string NAME_Dementor		= "Suchender";
const string NAME_ToterNovize	= "Toter Novize";
const string NAME_Antipaldin	= "Orkischer Kriegsherr";
const string NAME_Schiffswache	= "Schiffswache";
const string NAME_Fluechtling	= "Fl�chtling";


//**************************************************
//		Addon
//**************************************************

const string NAME_Addon_Pirat			= "Pirat"; //_addon_ ?
const string NAME_Addon_Guard			= "Gardist";
const string NAME_Addon_Esteban_Guard	= "Leibwache";
const string NAME_Addon_Sklave			= "Sklave";
const string NAME_Addon_Buddler			= "Buddler";
const string NAME_ADDON_SCAVENGERGL		= "Grasland-Scavenger";

const string NAME_Addon_Summoned_Guardian	=	"Beschworener Steinw�chter";
const string NAME_Addon_Summoned_Zombie		=	"Beschworener Zombie";	
const string NAME_ADDON_BELIARSWEAPON 		= 	"Die Klaue Beliars";

const string NAME_Addon_Undead_Mud		=	"Untoter Mud";	
const string NAME_Addon_Summoned_Mud	=	"Beschworener Mud";	

// *************************************************************
// DIALOG OPTIONEN
// *************************************************************

CONST STRING DIALOG_ENDE		= "ENDE";
CONST STRING DIALOG_BACK		= "ZUR�CK";
const string DIALOG_TRADE		= "(Handeln)";
const string DIALOG_PICKPOCKET	= "(Taschendiebstahl versuchen)";


// *************************************************************
// FOKUSNAMEN DER ITEMS
// *************************************************************

const string NAME_Ring			= "Ring";
const string NAME_Amulett		= "Amulett";
const string NAME_Trank			= "Trank";
const string NAME_Rune			= "Rune";
const string NAME_Spruchrolle	= "Spruchrolle";
const string NAME_Key			= "Schl�ssel";

const string NAME_Addon_Belt			= "G�rtel";
const string NAME_Addon_BeltMage		= "Sch�rpe";

const string NAME_Addon_BeArSLD			= "Zusammen mit S�ldnerr�stung  + ";
const string NAME_Addon_BeArMIL			= "Zusammen mit Milizr�stung    + ";
const string NAME_Addon_BeArKDF			= "Zusammen mit Magierrobe      + ";
const string NAME_Addon_BeArNOV			= "Zusammen mit Novizenrobe     + ";
const string NAME_Addon_BeArMC			= "Zusammen mit Crawlerr�stung  + ";
const string NAME_Addon_BeArLeather		= "Zusammen mit Lederr�stung    + ";

const string PRINT_Addon_BDTArmor		= "Wer diese R�stung tr�gt, geh�rt zu den Banditen";

const string PRINT_Addon_KUMU_01		= "Wir sind drei Br�der aus einer Kaste.";//Texte f�r kumulative Amulette
const string PRINT_Addon_KUMU_02		= "Zusammmen sind wir st�rker.";

const string PRINT_Addon_NadjaWait		= "Warte noch. Wegen dem Kraut ...";
// *************************************************************
// INVENTAR
// *************************************************************

const string NAME_Currency					= "Gold: ";
const string PRINT_Trade_Not_Enough_Gold	= "Du hast nicht genug Gold um den Gegenstand zu kaufen.";

// *************************************************************
// TEXTE F�R ITEM-BESCHREIBUNGEN IM	INV.
// *************************************************************

const string NAME_Value			= "Wert:";

const string NAME_Mag_Circle	= "Kreis:";
const string NAME_Manakosten	= "Manakosten:";
const string NAME_MinManakosten = "Manakosten (min):";
const string NAME_ManakostenMax	= "Manakosten (max):";
const string NAME_ManaPerSec	= "Mana pro Sec.";
const string NAME_Duration		= "Dauer (Minuten)";
const string NAME_Sec_Duration	= "Dauer (Sekunden)";

const string NAME_Mana_needed	= "ben�tigtes Mana:";
const string NAME_Str_needed	= "ben�tigte St�rke:";
const string NAME_Dex_needed	= "ben�tigte Geschicklichkeit:";

const string NAME_Spell_Load	= "Aufladbarer Zauber";
const string NAME_Spell_Invest	= "Aufrechterhaltungs-Zauber";

const string NAME_Dam_Edge		= "Waffenschaden";
const string NAME_Dam_Point		= "Pfeilschaden";
const string NAME_Dam_Fire		= "Feuerschaden";
const string NAME_Dam_Magic		= "Magieschaden";
const string NAME_Dam_Fly		= "Wirbelschaden";

const string NAME_Damage		= "Schaden";
const string NAME_Damage_Max	= "Schaden (max)";
const string NAME_PerMana		= " (pro Mana)";
const string NAME_DamagePerSec	= "Schaden pro Sec.";

const string NAME_Prot_Edge		= "Schutz vor Waffen:";
const string NAME_Prot_Point	= "Schutz vor Pfeilen:";
const string NAME_Prot_Fire		= "Schutz vor Feuer:";
const string NAME_Prot_Magic	= "Schutz vor Magie:";

const string NAME_Bonus_HP		= "Lebensenergie-Bonus:";
const string NAME_Bonus_Mana	= "Mana-Bonus:";


const string NAME_Bonus_HpMax	= "Bonus f�r maximale Lebensenergie:";
const string NAME_Bonus_ManaMax	= "Bonus f�r maximales Mana:";

const string NAME_Bonus_Dex		= "Geschicklichkeits-Bonus:";
const string NAME_Bonus_Str		= "St�rke-Bonus:";

const string NAME_OneHanded		= "Einhandwaffe";
const string NAME_TwoHanded		= "Zweihandwaffe";

const string NAME_HealingPerMana = "Heilung pro Mana";
const string NAME_HealingPerCast = "Heilkraft:";

const string NAME_Addon_NostalgieBonus = "Nostalgie-Bonus: ";

const string NAME_Addon_NeedsAllMana	= "Braucht kompletten Manavorrat auf.";
const string NAME_Addon_SpellDontKill	= "Spruch t�tet nicht";	
const string NAME_Addon_Damage_Min		= "Schaden (min)";	

//ADDON
const string NAME_ADDON_WISPSKILL_FF 		= "Fernkampfwaffen und Munition";
const string NAME_ADDON_WISPSKILL_NONE  	= "Gold, Schl�ssel und Gebrauchsgegenst�nde";
const string NAME_ADDON_WISPSKILL_RUNE 		= "Runen und Schriftrollen";
const string NAME_ADDON_WISPSKILL_MAGIC 	= "Ringe und Amulette";
const string NAME_ADDON_WISPSKILL_FOOD 		= "Nahrung und Planzen";
const string NAME_ADDON_WISPSKILL_POTIONS 	= "Magische und andere Tr�nke";

const string NAME_ADDON_LEARNLANGUAGE_1 	= "Sprache der Bauern lernen";
const string NAME_ADDON_LEARNLANGUAGE_2 	= "Sprache der Krieger lernen";
const string NAME_ADDON_LEARNLANGUAGE_3 	= "Sprache der Priester lernen";

const string NAME_ADDON_MALUS_2H					= "Zweihand Talent - Malus";
const string NAME_ADDON_MALUS_1H					= "Einhand Talent - Malus";
const string NAME_ADDON_BONUS_1H					= "Einhand Talent - Bonus";
const string NAME_ADDON_BONUS_2H					= "Zweihand Talent - Bonus";
const string NAME_ADDON_ONEHANDED_BELIAR			= "Chance auf Extraschaden"; 
const string NAME_ADDON_TWOHANDED_BELIAR			= "Chance auf Extraschaden"; 

const string NAME_ADDON_UPGRATEBELIARSWEAPON		= "'Die Klaue Beliars' verbessern";
const string NAME_ADDON_BETEN						= "Beten";

const string NAME_ADDON_PRAYIDOL_GIVENOTHING			= "Ich will beten und spende nichts.";
const string NAME_ADDON_PRAYIDOL_GIVEHITPOINT1			= "Ich will beten und spende 1 Lebensenergie.";
const string NAME_ADDON_PRAYIDOL_GIVEHITPOINT2			= "Ich will beten und spende 2 Lebensenergie.";
const string NAME_ADDON_PRAYIDOL_GIVEHITPOINT3			= "Ich will beten und spende 3 Lebensenergie.";
const string NAME_ADDON_PRAYIDOL_GIVEMANA				= "Ich will beten und spende 1 Mana.";
							

// *************************************************************
// NAMEN F�R Produktionsitems
// *************************************************************
const string NAME_ItMw_1H_Common_01	 = "Schwert"; //(40/30)
const string NAME_ItMw_1H_Special_01 = "Erz-Langschwert";
const string NAME_ItMw_2H_Special_01 = "Erz-Zweih�nder";
const string NAME_ItMw_1H_Special_02 = "Erz-Bastardschwert";
const string NAME_ItMw_2H_Special_02 = "Schwerer Erz-Zweih�nder";
const string NAME_ItMw_1H_Special_03 = "Erz-Schlachtklinge";
const string NAME_ItMw_2H_Special_03 = "Schwere Erz-Schlachtklinge";
const string NAME_ItMw_1H_Special_04 = "Erz-Drachent�ter";
const string NAME_ItMw_2H_Special_04 = "Grosser Erz-Drachent�ter";

const string NAME_Addon_Harad_01 = "Edles Schwert"; //ItMw_Schwert1 (60/50)
const string NAME_Addon_Harad_02 = "Edles Langschwert"; //ItMw_Schwert4 (80/70)
const string NAME_Addon_Harad_03 = "Rubinklinge"; //ItMw_Rubinklinge (100/90)
const string NAME_Addon_Harad_04 = "El Bastardo"; //ItMw_ElBastardo (120/110)


// *************************************************************
// PrintScreen Texte f�r B_GiveInvItems
// *************************************************************

const string PRINT_Addon_gegeben			= " gegeben";
const string PRINT_GoldGegeben				= " Gold gegeben";
const string PRINT_ItemGegeben				= " Gegenstand gegeben";
const string PRINT_ItemsGegeben				= " Gegenst�nde gegeben";

const string PRINT_Addon_erhalten			= " erhalten";
const string PRINT_GoldErhalten				= " Gold erhalten";
const string PRINT_ItemErhalten				= " Gegenstand erhalten";
const string PRINT_ItemsErhalten			= " Gegenst�nde erhalten";
const string PRINT_Addon_RuneGiven			= " Beliar schenkt dir einen anderen Zauber";	


// *************************************************************
// PrintScreen Texte f�r Steigerung	(Lernen)
// *************************************************************

// ------ B_BuildLearnString ------
const string PRINT_Kosten					= ". Kosten: ";
const string PRINT_LP						= " LP";

// ------ Zu wenig LP /	techerMAX �berschritten	------
const string PRINT_NotEnoughLP				= "Nicht genug Lernpunkte!";
const string PRINT_NoLearnOverPersonalMAX	= "Maximum dieses Lehrers liegt bei ";

// ------ Attribute	------------------------------------------------------------------------------
const string PRINT_LearnSTR					= "St�rke + ";
const string PRINT_LearnDEX					= "Geschicklichkeit + ";
const string PRINT_LearnMANA_MAX			= "Mana + ";
const string PRINT_Learnhitpoints_MAX		= "Lebensenergie + ";
const string PRINT_LearnLP					= "Lernpunkte + ";

// ------ Kreise der Magie -----------------------------------------------------------------------
const string PRINT_LearnCircle_1			= "Lerne: 1. Kreis der Magie";
const string PRINT_LearnCircle_2			= "Lerne: 2. Kreis der Magie";
const string PRINT_LearnCircle_3			= "Lerne: 3. Kreis der Magie";
const string PRINT_LearnCircle_4			= "Lerne: 4. Kreis der Magie";
const string PRINT_LearnCircle_5			= "Lerne: 5. Kreis der Magie";
const string PRINT_LearnCircle_6			= "Lerne: 6. Kreis der Magie";

// ------ 1H -------------------------------------------------------------------------------------
const string PRINT_Learn1H					= "Verbessere: Kampf mit Einhandwaffen";
const string PRINT_Learn1H_and_2H			= "Verbessere: Kampf mit Ein- und Zweihandwaffen"; //ADDON ge�ndert M.F. 
// ------ 2H -------------------------------------------------------------------------------------
const string PRINT_Learn2H					= "Verbessere: Kampf mit Zweihandwaffen";
const string PRINT_Learn2H_and_1H			= "Verbessere: Kampf mit Zwei- und Einhandwaffen";//ADDON ge�ndert M.F. 
// ------ Bow ------------------------------------------------------------------------------------
const string PRINT_LearnBow					= "Verbessere: Treffen mit Bogen";
const string PRINT_LearnBow_and_Crossbow	= "Verbessere: Treffen mit Bogen und Armbrust";
// ------ Crossbow -------------------------------------------------------------------------------
const string PRINT_LearnCrossbow			= "Verbessere: Treffen mit Armbrust";
const string PRINT_LearnCrossbow_and_Bow	= "Verbessere: Treffen mit Armbrust und Bogen";

// ------ Diebestalente	--------------------------------------------------------------------------
const string PRINT_LearnPicklock			= "Lerne: Schl�sser knacken";
const string PRINT_LearnSneak				= "Lerne: Schleichen";
const string PRINT_LearnAcrobat				= "Lerne: Akrobatik";
const string PRINT_Addon_AcrobatBonus		= "Akrobatik-Bonus!";
const string PRINT_LearnPickpocket			= "Lerne: Taschendiebstahl";
const string PRINT_Beliarshitpoints_MAX		= "Lebensenergie - ";

// ------ Player Talents -------------------------------------------------------------------------
const string PRINT_LearnSmith				= "Lerne: Waffe schmieden";
const string PRINT_LearnRunes				= "Lerne: Rune erschaffen";
const string PRINT_LearnAlchemy				= "Lerne: Trank brauen";
const string PRINT_LearnAlchemyInnosEye		= "Lerne: Auge Innos aufladen";
const string PRINT_LearnTakeAnimalTrophy	= "Lerne: Tiere ausschlachten";
const string PRINT_LearnForeignLanguage		= "Lerne: Sprache der Erbauer";//ADDON
const string PRINT_LearnWispDetector		= "Dein Irrlicht hat gelernt";//ADDON
const string PRINT_LearnPalTeleportSecret	= "Lerne: Geheime Teleport Rune bauen";

const string PRINT_NotEnoughLearnPoints		= "Zu wenig Lernpunkte!";

//-------- Lern	Konstanten der Descriptions	---------------------------------------------------
const string PRINT_LearnSTR1				= "St�rke + 1";
const string PRINT_LearnSTR5				= "St�rke + 5";

const string PRINT_LearnDEX1				= "Geschicklichkeit + 1";
const string PRINT_LearnDEX5				= "Geschicklichkeit + 5";

const string PRINT_LearnMANA1				= "Mana + 1";
const string PRINT_LearnMANA5				= "Mana + 5";

const string PRINT_Learn1h1					= "Einhand - Waffen + 1";
const string PRINT_Learn1h5					= "Einhand - Waffen + 5";

const string PRINT_Learn2h1					= "Zweihand - Waffen + 1";
const string PRINT_Learn2h5					= "Zweihand - Waffen + 5";

const string PRINT_LearnBow1				= "Bogen + 1";
const string PRINT_LearnBow5				= "Bogen + 5";

const string PRINT_LearnCrossBow1			= "Armbrust + 1";
const string PRINT_LearnCrossBow5			= "Armbrust + 5";

// Sonja

const string PRINT_LearnHITPOINTS1			= "Leben + 1";
const string PRINT_LearnHITPOINTS5			= "Leben + 5";



// ************************************
// Konstanten aus Dialog_Mobsi Skripten
// ************************************

const string PRINT_SleepOver				= "Du hast geschlafen und bist ausgeruht!";
const string PRINT_SleepOverObsessed		= "Alptr�ume verwehren dir Erholung!";
const string PRINT_SmithSuccess				= "Waffe hergestellt!";
const string PRINT_RuneSuccess				= "Rune hergestellt!";
const string PRINT_AlchemySuccess			= "Trank hergestellt!";
const string PRINT_AlchemySuccessInnoseye	= "Das Auge Innos pulsiert voller Energie!";
const string PRINT_ProdItemsMissing			= "Zu wenig Rohstoffe";
const string PRINT_TabakSuccess				= "Neue Tabaksorte gemischt!";
const string PRINT_JointSuccess				= "Sumpfkraut - Stengel gedreht!";
const string PRINT_Addon_Joint_01_Success	= "Gr�ner Novize gedreht!"; //ADDON
const string PRINT_NoInnosTears				= "Dir fehlen die `Tr�nen Innos�.";
const string PRINT_Addon_GuildNeeded		= "Dir fehlt eine Gilde.";
const string PRINT_Addon_GuildNeeded_NOV	= "Du bist noch kein Magier.";

// ************************************
//B_RefuseAction
// ************************************
const string PRINT_KeyMissing				= "Daf�r brauche ich den richtigen Schl�ssel";
const string PRINT_PicklockMissing			= "Ich brauche einen Dietrich";
const string PRINT_Picklock_or_KeyMissing	= "Ich brauche entweder den Schl�ssel oder einen Dietrich";
const string PRINT_NeverOpen				= "Da l�sst sich nichts machen";
const string PRINT_Toofar_Away				= "Das ist zu weit entfernt";
const string PRINT_WrongSide				= "Das ist die falsche Seite";
const string PRINT_MissingItem				= "Mir fehlt der entsprechende Gegenstand";
const string PRINT_AnotherUser				= "Das wird gerade benutzt";
const string PRINT_NoPicklockTalent			= "Daf�r habe ich kein Talent";

const string PRINT_NOTHINGTOGET				= "Da ist nichts zu holen...";
const string PRINT_NOTHINGTOGET02			= "Nichts zu holen...";
const string PRINT_NOTHINGTOGET03			= "Nichts zu pl�ndern...";

// *************************************
// StringKonstanten	f�r	Beten
// *************************************

const string PRINT_BlessSTR					= "Innos schenkt dir: St�rke + ";
const string PRINT_BlessDEX					= "Innos schenkt dir: Geschicklichkeit + ";
const string PRINT_BlessMANA_MAX			= "Innos schenkt dir: Mana + ";
const string PRINT_BlessHitpoints_MAX		= "Innos schenkt dir: Lebensenergie + ";
const string PRINT_BlessMANA				= "Du bist erf�llt von geistiger Klarheit.";
const string PRINT_BlessHitpoints			= "Innos erh�rt dich und heilt dich.";
const string Print_BlessMana_Hit			= "Du f�hlst dich wie neugeboren.";
const string Print_BlessNone				= "Innos dankt f�r dein Gebet.";
const string Print_NotEnoughGold			= "Zu wenig Gold.";
const string Bless_Sword					= "Schwert weihen (5000 Gold)";
const string Bless_Sword2					= "Schwert weihen (Tr�nen Innos)";

const string Pray_Paladin1					= "...Innos, halte deine sch�tzende Hand �ber deine Streiter..." ;
const string Pray_Paladin2					= "...segne sie mit deinem Feuer und schenke ihnen Kraft..." ;
const string Pray_Paladin3					= "...auf das sie in deinem Namen mutig k�mpfen... ";
const string Pray_Paladin4					= "...bis zum Sieg oder zum Tod, so wie es dein Wille ist.";

// ***************************************************************************************
// PrintScreen Texte Story
// ***************************************************************************************

//--- Addon ------------------------------

//---------- Dialoge Banditenlager -----------------
const string DIALOG_ADDON_ATTENTAT_DESCRIPTION 		= "Was wei�t du �ber das Attentat gegen Esteban?";
const string DIALOG_ADDON_ATTENTAT_PRO 				= "Ich will diese Verr�ter t�ten.";
const string DIALOG_ADDON_ATTENTAT_CONTRA 			= "Ich suche diese Typen, um gegen Esteban vorzugehen.";

const string DIALOG_ADDON_MINE_DESCRIPTION			= "Du wirst in der Mine gebraucht. (Roten Stein geben)";
const string DIALOG_ADDON_GOLD_DESCRIPTION			= "Was muss ich �ber's Goldhacken wissen?";
const string PRINT_ADDON_KNOWSBF					= "Wissen �ber Stachelgift gelernt";	
const string PRINT_ADDON_HACKCHANCE					= "Wissen �ber Goldhacken gesteigert! (+ ";		
const string PRINT_ADDON_STUNTBONUS					= "Stunt Bonus";
const string PRINT_ADDON_EXPLOITBONUS				= "Exploit Malus";	
	
	
const string PRINT_ADDON_ENOUGHTALK					= "Genug geredet. Lass uns k�mpfen.";	
// ------ allgemeine ------
const string PRINT_FullyHealed					= "Vollst�ndig geheilt";
const string PRINT_Eat1							= "Du f�hlst dich erfrischt";
const string PRINT_Eat2							= "Schmeckt saftig und frisch";
const string PRINT_Eat3							= "Du f�hlst dich gesund und stark!";

const string Print_ReadAstronomy				= "Ein Gef�hl g�ttlicher Erkenntnis erf�llt dich.";

// ------ spezielle	-------
const string PRINT_GornsTreasure				= "100 Gold erhalten.";
const string PRINT_KerolothsGeldBeutel			= "300 Gold erhalten.";
const string PRINT_MalethBanditsGold			= "300 Gold erhalten";
const string Print_DiegosTreasure				= "2000 Gold erhalten";
const string PRINT_IrdorathBookDoesntOpen		= "Der Einband des Buches l�sst sich nicht �ffnen.";
const string PRINT_IrdorathBookHiddenKey		= "Im Einband des Buches ist ein Schl�ssel versteckt!";
const string PRINT_FishLetter					= "Im Fisch ist ein Zettel versteckt";
const string Print_InnoseyeGiven				= "Auge Innos gegeben";
const STRING Print_InnosEyeGet					= "Auge Innos erhalten";

const string PRINT_GotFourItems					= "4 Gegenst�nde erhalten ";
const string PRINT_OrcEliteRingEquip			= "Du f�hlst dich geschw�cht.";
const string PRINT_SCIsObsessed					= "Ein beklemmendes Gef�hl bef�llt dich!";
const string PRINT_ClearSCObsession				= "Du f�hlst dich erl�st!";
const string PRINT_NumberLeft					= "  �brig";
const string PRINT_NovizenLeft					= "  Novizen �brig";

//------ Addon-----
const string PRINT_Addon_CanyonRazorsLeft				= "  Razor �brig";
//-----------------

const string PRINT_DragKillCount				= "Der Feind ist besiegt und diesmal werde ich nicht wieder unter Felsen verschimmeln. Nichts wie raus hier, zur�ck auf�s Schiff.";

// ------ Smith	Weapon ------
const string PRINT_Smith_1H_Special_01			= " (1 Erz)";
const string PRINT_Smith_2H_Special_01			= " (2 Erz)";
const string PRINT_Smith_1H_Special_02			= " (2 Erz)";
const string PRINT_Smith_2H_Special_02			= " (3 Erz)";
const string PRINT_Smith_1H_Special_03			= " (3 Erz)";
const string PRINT_Smith_2H_Special_03			= " (4 Erz)";
const string PRINT_Smith_1H_Special_04			= " (4 Erz, 5 Drachenblut)";
const string PRINT_Smith_2H_Special_04			= " (5 Erz, 5 Drachenblut)";


const string NAME_MageScroll			= "Spruchrolle";



//----------- Items	in Items finden	--------------------

const string PRINT_FoundRing					= "Ring gefunden";
const string PRINT_FoundAmulett					= "Amulett gefunden";
const string PRINT_FoundScroll					= "Spruchrolle gefunden";
const string PRINT_FoundPotion					= "Trank gefunden";
const string PRINT_FoundMap						= "Karte gefunden";

const string PRINT_FoundGold10					= "10 Gold gefunden";
const string PRINT_FoundGold25					= "25 Gold gefunden";
const string PRINT_FoundGold50					= "50 Gold gefunden";
const string PRINT_FoundGold100					= "100 Gold gefunden";
const string PRINT_FoundRuneBlank				= "Runenstein gefunden";
const string PRINT_FoundOreNugget				= "Erzbrocken gefunden";
const string PRINT_FoundLockpick				= "Dietrich gefunden";
const string PRINT_HannasBeutel					= "Ein kleiner Schl�ssel und ein paar Dietriche...";
const string PRINT_GotPlants					= "Einige Kr�uter gefunden";

//-------------
const string PRINT_NoSweeping					= "Alle Kammern auszufegen dauert ewig!";

const string PRINT_Mandibles					= "Das Sekret zeigt keine Wirkung mehr.";
const string PRINT_Bloodfly						= "Schmeckt bitter und giftig";
// ***************************************************************************************
// Abuyin Patchwork
// ***************************************************************************************
const string PRINT_PILZ 	= "Pilz Tabak";
const string PRINT_DOPPEL 	= "Doppelter Apfel";
const string PRINT_HONIG	= "Honig Tabak";
const string PRINT_KRAUT 	= "Krautabak";

// ***************************************************************************************
// sonstige	PrintScreen	Texte
// ***************************************************************************************

const string PRINT_XPGained				= "Erfahrung + ";			// bei jedem Erfahrungsgewinn
const string PRINT_LevelUp				= "Stufe gestiegen!";		// beim	Stufenaufstieg
const string PRINT_NewLogEntry			= "Neuer Tagebucheintrag";
const string PRINT_TeleportTooFarAway	= "Zu weit entfernt";
const string PRINT_BiffsAnteil	= "Biffs Anteil: ";
const string PRINT_BiffGold		= " Gold";
const string PRINT_Addon_SCIsWearingRangerRing = "Du tr�gst jetzt das Erkennungszeichen des 'Rings des Wassers'";

// ***************************************************************************************
// variable	Item Inventory Texte
// ***************************************************************************************

var	string TEXT_Innoseye_Setting;

const string TEXT_Innoseye_Setting_Broken	= "Die Fassung des Amuletts ist zerbrochen";
const string TEXT_Innoseye_Setting_Repaired	= "Die Fassung des Amuletts ist intakt";
const string TEXT_Innoseye_Gem		= "Der Edelstein ist matt und kraftlos";

// ***************************************************************************************
// Diebtstahl Text Konstanten
// ***************************************************************************************
const string Pickpocket_20	=	"(Es w�re ein Kinderspiel seinen Geldbeutel zu stehlen)";
const string Pickpocket_40	=	"(Es w�re einfach seinen Geldbeutel zu stehlen)";
const string Pickpocket_60	=	"(Es w�re gewagt seinen Geldbeutel zu stehlen)";
const string Pickpocket_80	=	"(Es w�re schwierig seinen Geldbeutel zu stehlen)";
const string Pickpocket_100	=	"(Es w�re verdammt schwierig seinen Geldbeutel zu stehlen)";
const string Pickpocket_120	=	"(Es w�re fast unm�glich seinen Geldbeutel zu stehlen)";

const string Pickpocket_20_Female	=	"(Es w�re ein Kinderspiel ihren Geldbeutel zu stehlen)";
const string Pickpocket_40_Female	=	"(Es w�re einfach ihren Geldbeutel zu stehlen)";
const string Pickpocket_60_Female	=	"(Es w�re gewagt ihren Geldbeutel zu stehlen)";
const string Pickpocket_80_Female	=	"(Es w�re schwierig ihren Geldbeutel zu stehlen)";
const string Pickpocket_100_Female	=	"(Es w�re verdammt schwierig ihren Geldbeutel zu stehlen)";
const string Pickpocket_120_Female	=	"(Es w�re fast unm�glich ihren Geldbeutel zu stehlen)";

// ****************************************************************************************
// Relative	Y-Koordinaten f�r die Bildschirmausgabe	(in	% der aktuellen	Bildh�he, von oben)
// ****************************************************************************************

const int YPOS_GoldGiven		= 34;
const int YPOS_GoldTaken		= 34;
const int YPOS_ItemGiven		= 37;
const int YPOS_ItemTaken		= 40;

const int YPOS_LOGENTRY			= 45;
const int YPOS_LEVELUP			= 50;
const int YPOS_XPGAINED			= 55;


// ******************************
// Konstanten aus den G_FUNCTIONS
// ******************************

// ------ G_PickLock ------
const string PRINT_PICKLOCK_SUCCESS	= "Das h�rte sich gut an";
const string PRINT_PICKLOCK_UNLOCK	= "Das Schlo� ist geknackt";
const string PRINT_PICKLOCK_FAILURE	= "Mist.. wieder von vorne";
const string PRINT_PICKLOCK_BROKEN	= "Der Dietrich ist abgebrochen";

// ------ G_CanNotUse ------
const string PRINT_HITPOINTS_MISSING		= "Lebenspunkte zu wenig";
const string PRINT_HITPOINTS_MAX_MISSING	= "maximale Lebenspunkte zu wenig";
const string PRINT_MANA_MISSING				= "Manapunkte zu wenig";
const string PRINT_MANA_MAX_MISSING			= "maximale Manapunkte zu wenig";
const string PRINT_STRENGTH_MISSING			= "St�rkepunkte zu wenig";
const string PRINT_DEXTERITY_MISSING		= "Geschicklichkeitspunkte zu wenig";

// ------ G_CanNotCast ------
const string PRINT_MAGCIRCLES_MISSING		= "magische Kreise zu niedrig, um die Rune anzulegen";

//ADDON
const string PRINT_ADDON_BELIARSCOURSE_MISSING		= "Die Waffe l�sst sich nicht anlegen.";


// ************************************
// Vom Programm	ausgelagerte Konstanten
// ------------------------------------
// NAMEN NICHT �NDERN!
// ************************************

// Bidschrimausgabe	zum	Thema Schlo� �ffnen/knacken
const string _STR_MESSAGE_INTERACT_NO_KEY	= "kein Dietrich oder passender Schl�ssel";

// Bidschrimausgabe	f�rs Tausch-Fenster
const string _STR_MESSAGE_TRADE_FAILURE		= "der Wert deiner Tauschware ist nicht hoch genug"	;

// Trade-Manager
const string STR_INFO_TRADE_ACCEPT						= "Annehmen"			;
const string STR_INFO_TRADE_RESET						= "Ablehnen"			;
const string STR_INFO_TRADE_EXIT						= "Zur�ck"				;

// Menuetext-Konstanten	(max 60	Zeichen)
const string MENU_TEXT_NEEDS_APPLY		= "Zum aktivieren RETURN dr�cken!";
const string MENU_TEXT_NEEDS_RESTART	= "Einige Einstellungen werden erst nach einem Neustart aktiv";


// ****************
// B_Kapitelwechsel
// ****************

const string KapWechsel_1			= "Kapitel 1"					;
const string KapWechsel_1_Text		= "Die Bedrohung"				;
const string KapWechsel_2			= "Kapitel 2"					;
const string KapWechsel_2_Text		= "R�ckkehr in die Kolonie"		;
const string KapWechsel_3			= "Kapitel 3"					;
const string KapWechsel_3_Text		= "Das Auge Innos"				;
const string KapWechsel_4			= "Kapitel 4"					;
const string KapWechsel_4_Text		= "Drachenjagd"					;
const string KapWechsel_5			= "Kapitel 5"					;
const string KapWechsel_5_Text		= "Aufbruch"		;
const string KapWechsel_6			= "Kapitel 6"					;
const string KapWechsel_6_Text		= "Die Hallen von Irdorath"		;

//-----Written Texte----------
// *********************
//      Constants
//    Phoenix V0.67
// *********************


// *************************************************************
// PrintScreen Fonts
// *************************************************************

const string FONT_Screen					= "FONT_OLD_20_WHITE.TGA";
const string FONT_ScreenSmall				= "FONT_OLD_10_WHITE.TGA";
const string FONT_Book						= "FONT_10_BOOK.TGA";
const string FONT_BookHeadline				= "FONT_20_BOOK.TGA";


// ****************************
// Spellkosten f�r ALLE SCrolls
// ****************************
const int SPL_Cost_Scroll = 5;


// MH: 19.11.01 Gildennamen ge�ndert --> �nderungen in Text.d (Character-Screen Gildenbezeichnungen) und Species.d (Gildenanh�ngige Bewegungswerte wie z.B Kletterh�he)
// MH: 19.11.01 Talente hinzugef�gt
// MH: 15.12.01 Neue Spells hinzugef�gt
// MH: 15.12.01 Neue Player Talente hinzugef�gt

//
//	NPC ATTRIBUTES
//

const int ATR_HITPOINTS				=  0;	// Lebenspunkte
const int ATR_HITPOINTS_MAX			=  1;	// Max. Lebenspunkte
const int ATR_MANA					=  2;	// Mana Mana
const int ATR_MANA_MAX				=  3;	// Mana Max

const int ATR_STRENGTH				=  4;	// St�rke
const int ATR_DEXTERITY				=  5;	// Geschick
const int ATR_REGENERATEHP			=  6;	// Regenerierung von HP alle x sekunden
const int ATR_REGENERATEMANA		=  7;   // Regenerierung von Mana alle x sekunden

const int ATR_INDEX_MAX				=  8;

//
//	NPC FLAGS
//
CONST INT NPC_FLAG_FRIEND								=  1 << 0				;	// wird nicht benutzt (wird �ber aivar geregelt)
CONST INT NPC_FLAG_IMMORTAL								=  1 << 1				;	// Unverwundbar
CONST INT NPC_FLAG_GHOST								=  1 << 2				;	// Halb-Transparenter NPC (Gothic.ini [INTERNAL] 'GhostAlpha')

//
//	FIGHT MODES
//
CONST INT FMODE_NONE									=  0					;
CONST INT FMODE_FIST									=  1					;
CONST INT FMODE_MELEE									=  2					;
CONST INT FMODE_FAR										=  5					;
CONST INT FMODE_MAGIC									=  7					;

//
//	WALK MODES
//
CONST INT NPC_RUN										=  0					;
CONST INT NPC_WALK										=  1					;
CONST INT NPC_SNEAK										=  2					;
CONST INT NPC_RUN_WEAPON								=  0 + 128				;
CONST INT NPC_WALK_WEAPON								=  1 + 128				;
CONST INT NPC_SNEAK_WEAPON								=  2 + 128				;

//
//	ARMOR FLAGS
//
CONST INT WEAR_TORSO									=  1					;		//	Oberkoerper	( Brustpanzer )
CONST INT WEAR_HEAD										=  2					;		//	Kopf		( Helm )
CONST INT WEAR_EFFECT									=  16					;		

//
//	INVENTORY CATEGORIES
//
CONST INT INV_WEAPON									=  1					;
CONST INT INV_ARMOR										=  2					;
CONST INT INV_RUNE										=  3					;
CONST INT INV_MAGIC										=  4					;
CONST INT INV_FOOD										=  5					;
CONST INT INV_POTION									=  6					;
CONST INT INV_DOC										=  7					;
CONST INT INV_MISC										=  8					;
CONST INT INV_CAT_MAX									=  9					;

//
//	INVENTORY CAPACITIES		// --- werden vom Programm ignoriert - INV ist unendlich gro�! ---
//
CONST INT INV_MAX_WEAPONS								=    6					;
CONST INT INV_MAX_ARMORS 								=    2					;
CONST INT INV_MAX_RUNES									= 1000					;		//	virtually infinite
CONST INT INV_MAX_FOOD									=   15					;
CONST INT INV_MAX_DOCS									= 1000					;		//	virtually infinite
CONST INT INV_MAX_POTIONS								= 1000					;		//	virtually infinite
CONST INT INV_MAX_MAGIC									= 1000					;		//	virtually infinite
CONST INT INV_MAX_MISC									= 1000					;

//
//	ITEM TEXTS
//
CONST INT ITM_TEXT_MAX									=  6					;

////////////////////////////////////////////////////////////////////////////////
//
//	ITEM FLAGS
//

// categories (mainflag)
const int ITEM_KAT_NONE		= 1 <<  0;  // Sonstiges
const int ITEM_KAT_NF		= 1 <<  1;  // Nahkampfwaffen
const int ITEM_KAT_FF		= 1 <<  2;  // Fernkampfwaffen
const int ITEM_KAT_MUN		= 1 <<  3;  // Munition (MULTI)
const int ITEM_KAT_ARMOR	= 1 <<  4;  // Ruestungen
const int ITEM_KAT_FOOD		= 1 <<  5;  // Nahrungsmittel (MULTI)
const int ITEM_KAT_DOCS		= 1 <<  6;  // Dokumente
const int ITEM_KAT_POTIONS	= 1 <<  7;  // Traenke
const int ITEM_KAT_LIGHT	= 1 <<  8;  // Lichtquellen
const int ITEM_KAT_RUNE		= 1 <<  9;  // Runen/Scrolls
const int ITEM_KAT_MAGIC	= 1 << 31;  // Ringe/Amulette/Guertel
const int ITEM_KAT_KEYS		= ITEM_KAT_NONE;
// weapon type (flags)
const int ITEM_DAG			= 1 << 13;  // (OBSOLETE!)
const int ITEM_SWD			= 1 << 14;  // Schwert
const int ITEM_AXE			= 1 << 15;  // Axt
const int ITEM_2HD_SWD		= 1 << 16;  // Zweihaender
const int ITEM_2HD_AXE		= 1 << 17;  // Streitaxt
const int ITEM_SHIELD		= 1 << 18;  // (OBSOLETE!)
const int ITEM_BOW			= 1 << 19;  // Bogen
const int ITEM_CROSSBOW		= 1 << 20;  // Armbrust
// magic type (flags)
const int ITEM_RING			= 1 << 11;  // Ring
const int ITEM_AMULET		= 1 << 22;  // Amulett
const int ITEM_BELT			= 1 << 24;  // Guertel
// attributes (flags)
const int ITEM_DROPPED 		= 1 << 10;  // (INTERNAL!)
const int ITEM_MISSION 		= 1 << 12;  // Missionsgegenstand
const int ITEM_MULTI		= 1 << 21;  // Stapelbar
const int ITEM_NFOCUS		= 1 << 23;  // (INTERNAL!)
const int ITEM_CREATEAMMO	= 1 << 25;  // Erzeugt Munition selbst (magisch)
const int ITEM_NSPLIT		= 1 << 26;  // Kein Split-Item (Waffe als Interact-Item!)
const int ITEM_DRINK		= 1 << 27;  // (OBSOLETE!)
const int ITEM_TORCH		= 1 << 28;  // Fackel
const int ITEM_THROW		= 1 << 29;  // (OBSOLETE!)
const int ITEM_ACTIVE		= 1 << 30;  // (INTERNAL!)

//
//	DAMAGE TYPES v2.0
//
CONST INT DAM_INVALID									= 0						;       //	  0 - 0x00 - nur der Vollstandigkeit und Transparenz wegen hier definiert ( _NICHT_ verwenden )
CONST INT DAM_BARRIER									= 1						;  		//	  1 - 0x01 - nur der Vollstandigkeit und Transparenz wegen hier definiert ( _NICHT_ verwenden )
CONST INT DAM_BLUNT										= DAM_BARRIER	<< 1	;  		//	  2 - 0x02 - blunt ist das bit links von barrier
CONST INT DAM_EDGE										= DAM_BLUNT		<< 1	;		//	  4 - 0x04 - edge 	ist das bit links von blunt
CONST INT DAM_FIRE										= DAM_EDGE		<< 1	;  		//	  8 - 0x08 - fire 	ist das bit links von edge
CONST INT DAM_FLY										= DAM_FIRE		<< 1	;		//	 16 - 0x10 - fly 	ist das bit links von fire
CONST INT DAM_MAGIC										= DAM_FLY		<< 1	;  		//	 32 - 0x20 - magic	ist das bit links von fly
CONST INT DAM_POINT										= DAM_MAGIC		<< 1	;  		//	 64 - 0x40 - point	ist das bit links von magic
CONST INT DAM_FALL										= DAM_POINT		<< 1	;  		//	128 - 0x80 - nur der Vollstandigkeit und Transparenz wegen hier definiert ( _NICHT_ verwenden )

//
//	DAMAGE TYPE ARRAY INDICES	( !!! DAM_XXX = 1 << DAM_INDEX_XXX !!! )
//
CONST INT DAM_INDEX_BARRIER								= 0						;  		//				 nur der Vollstandigkeit und Transparenz wegen hier definiert ( _NICHT_ verwenden )
CONST INT DAM_INDEX_BLUNT								= DAM_INDEX_BARRIER + 1	;
CONST INT DAM_INDEX_EDGE								= DAM_INDEX_BLUNT	+ 1	;
CONST INT DAM_INDEX_FIRE								= DAM_INDEX_EDGE	+ 1	;
CONST INT DAM_INDEX_FLY									= DAM_INDEX_FIRE	+ 1	;
CONST INT DAM_INDEX_MAGIC								= DAM_INDEX_FLY		+ 1	;
CONST INT DAM_INDEX_POINT								= DAM_INDEX_MAGIC	+ 1	;
CONST INT DAM_INDEX_FALL								= DAM_INDEX_POINT	+ 1	;  		//				 nur der Vollstandigkeit und Transparenz wegen hier definiert ( _NICHT_ verwenden )
CONST INT DAM_INDEX_MAX									= DAM_INDEX_FALL	+ 1 ;

//
//	OTHER DAMAGE CONSTANTS
//
CONST INT NPC_ATTACK_FINISH_DISTANCE					= 180		;
CONST INT NPC_BURN_TICKS_PER_DAMAGE_POINT				= 1000		; //Default 1000
CONST INT NPC_BURN_DAMAGE_POINTS_PER_INTERVALL			= 50		; //Default 10
CONST INT DAM_CRITICAL_MULTIPLIER						= 2			; //Obsolet, da Treffer-%-CHance CriticalHit ersetzt hat

CONST INT BLOOD_SIZE_DIVISOR							= 1000		;
CONST INT BLOOD_DAMAGE_MAX								= 200	    ;

CONST INT DAMAGE_FLY_CM_MAX								= 2000  	;
CONST INT DAMAGE_FLY_CM_MIN	                            = 300   	;
const INT DAMAGE_FLY_CM_PER_POINT						= 5			;

const int NPC_DAM_DIVE_TIME								= 100		;

const int IMMUNE										= -1 		;

// ------ Wie weit werden Npcs im Kampf voneinander weggeschoben -------
// ------ Faktor zu W-Distanz (BASE + Waffe, bzw. BASE + FIST) ------
const float NPC_COLLISION_CORRECTION_SCALER				= 0.75;		//Default = 0.75


//
//	PROTECTION TYPES v2.0
//
CONST INT PROT_BARRIER									= DAM_INDEX_BARRIER		;
CONST INT PROT_BLUNT									= DAM_INDEX_BLUNT		;
CONST INT PROT_EDGE										= DAM_INDEX_EDGE		;
CONST INT PROT_FIRE										= DAM_INDEX_FIRE		;
CONST INT PROT_FLY										= DAM_INDEX_FLY			;
CONST INT PROT_MAGIC									= DAM_INDEX_MAGIC		;
CONST INT PROT_POINT									= DAM_INDEX_POINT		;
CONST INT PROT_FALL										= DAM_INDEX_FALL		;
CONST INT PROT_INDEX_MAX								= DAM_INDEX_MAX			;

//
//	PERCEPTIONS	( ACTIVE )
//
CONST INT PERC_ASSESSPLAYER								=	1					;
CONST INT PERC_ASSESSENEMY								=	2					;
CONST INT PERC_ASSESSFIGHTER							=	3					;
CONST INT PERC_ASSESSBODY								=	4					;
CONST INT PERC_ASSESSITEM								=	5					;

//
//	SENSES
//
CONST INT SENSE_SEE										= 1 << 0				;
CONST INT SENSE_HEAR									= 1 << 1				;
CONST INT SENSE_SMELL									= 1 << 2				;

//
//	PERCEPTIONS	( PASSIVE )
//
CONST INT PERC_ASSESSMURDER								=	6					;
CONST INT PERC_ASSESSDEFEAT								=	7					;
CONST INT PERC_ASSESSDAMAGE								=	8					;
CONST INT PERC_ASSESSOTHERSDAMAGE						=	9					;
CONST INT PERC_ASSESSTHREAT								=  10					;
CONST INT PERC_ASSESSREMOVEWEAPON						=  11					;
CONST INT PERC_OBSERVEINTRUDER							=  12					;
CONST INT PERC_ASSESSFIGHTSOUND							=  13					;
CONST INT PERC_ASSESSQUIETSOUND							=  14					;
CONST INT PERC_ASSESSWARN								=  15					;
CONST INT PERC_CATCHTHIEF								=  16					;
CONST INT PERC_ASSESSTHEFT								=  17					;
CONST INT PERC_ASSESSCALL								=  18					;
CONST INT PERC_ASSESSTALK								=  19					;
CONST INT PERC_ASSESSGIVENITEM							=  20					;
CONST INT PERC_ASSESSFAKEGUILD							=  21					; //wird gesendet, sobald der SC sich verwandelt
CONST INT PERC_MOVEMOB									=  22					;
CONST INT PERC_MOVENPC									=  23					;
CONST INT PERC_DRAWWEAPON								=  24					;
CONST INT PERC_OBSERVESUSPECT							=  25					;
CONST INT PERC_NPCCOMMAND								=  26					;
CONST INT PERC_ASSESSMAGIC								=  27					;
CONST INT PERC_ASSESSSTOPMAGIC							=  28					;
CONST INT PERC_ASSESSCASTER								=  29					; //wird beim 1. investierten Manapunkt gesendet
CONST INT PERC_ASSESSSURPRISE							=  30					; //wird beim Zur�ckverwandeln gesendet
CONST INT PERC_ASSESSENTERROOM							=  31					;
CONST INT PERC_ASSESSUSEMOB								=  32					;

//
//	NEWS SPREAD MODE
//
CONST INT NEWS_DONT_SPREAD								= 0						;
const INT NEWS_SPREAD_NPC_FRIENDLY_TOWARDS_VICTIM		= 1						;
CONST INT NEWS_SPREAD_NPC_FRIENDLY_TOWARDS_WITNESS		= 2						;
CONST INT NEWS_SPREAD_NPC_FRIENDLY_TOWARDS_OFFENDER		= 3						;
CONST INT NEWS_SPREAD_NPC_SAME_GUILD_VICTIM				= 4						;

//
//	NEWS CONSTANTS
//
CONST INT IMPORTANT										= 1						;

//
//	INFO STATUS
//
CONST INT INF_TELL										= 0						;
CONST INT INF_UNKNOWN									= 2						;

//
//	MISSION STATUS
//
const INT LOG_RUNNING									= 1						;		//	Mission l�uft gerade
CONST INT LOG_SUCCESS									= 2						;		//	Mission erfolgreich beendet
CONST INT LOG_FAILED									= 3						;		//	Mission wurde abgebrochen
CONST INT LOG_OBSOLETE									= 4						;		//	Mission ist hinfaellig

//
//	ATTITUDES
//
CONST INT ATT_FRIENDLY									= 3						;
CONST INT ATT_NEUTRAL									= 2						;
CONST INT ATT_ANGRY										= 1						;
CONST INT ATT_HOSTILE									= 0						;


// ******************
// 		Gilden
// ******************

const int GIL_NONE						= 0		;	// (keine)
const int GIL_HUMAN						= 1		;	// Special Guild -> To set Constants for ALL Human Guilds --> wird verwendet in Species.d
const int GIL_PAL						= 1		;	// Paladin
const int GIL_MIL						= 2		;	// Miliz
const int GIL_VLK						= 3		;	// B�rger
const int GIL_KDF						= 4		;	// Magier
const int GIL_NOV						= 5		;	// Magier Novize
const int GIL_DJG						= 6		;	// Drachenj�ger
const int GIL_SLD						= 7		;	// S�ldner
const int GIL_BAU						= 8		;	// Bauer
const int GIL_BDT						= 9		;	// Bandit
const int GIL_STRF						= 10	; 	// Prisoner, Str�fling
const int GIL_DMT						= 11	;	// Dementoren
const int GIL_OUT						= 12	; 	// Outlander (z.B. kleine Bauernh�fe)

const int GIL_PIR						= 13	;	//Pirat
const int GIL_KDW						= 14	;	//KDW
const int GIL_EMPTY_D					= 15	;	// NICHT VERWENDEN!
//-----------------------------------------------
const int GIL_PUBLIC					= 15	; 	// f�r �ffentliche Portalr�ume
//-----------------------------------------------

const int GIL_SEPERATOR_HUM				= 16	;

const int GIL_MEATBUG					= 17	;
const int GIL_SHEEP						= 18	;
const int GIL_GOBBO						= 19	; 	// Green Goblin / Black Goblin
const int GIL_GOBBO_SKELETON			= 20	;
const int GIL_SUMMONED_GOBBO_SKELETON 	= 21	;
const int GIL_SCAVENGER					= 22	; 	// (bei Bedarf) Scavenger / Evil Scavenger /OrcBiter
const int GIL_GIANT_RAT					= 23	;
const int GIL_GIANT_BUG					= 24	;
const int GIL_BLOODFLY					= 25	;
const int GIL_WARAN						= 26	; 	// Waren / Feuerwaran
const int GIL_WOLF						= 27	; 	// Wolf / Warg
const int GIL_SUMMONED_WOLF				= 28	;
const int GIL_MINECRAWLER				= 29	; 	// Minecrawler / Minecrawler Warrior
const int GIL_LURKER					= 30	;
const int GIL_SKELETON					= 31	;
const int GIL_SUMMONED_SKELETON			= 32	;
const int GIL_SKELETON_MAGE				= 33	;
const int GIL_ZOMBIE					= 34	;
const int GIL_SNAPPER					= 35	; 	// Snapper / Dragon Snapper /Razor
const int GIL_SHADOWBEAST				= 36	;	//Shadowbeast / Bloodhound
const int GIL_SHADOWBEAST_SKELETON		= 37	;
const int GIL_HARPY						= 38	;
const int GIL_STONEGOLEM				= 39 	;
const int GIL_FIREGOLEM					= 40	;
const int GIL_ICEGOLEM					= 41	;
const int GIL_SUMMONED_GOLEM			= 42	;
const int GIL_DEMON						= 43	;
const int GIL_SUMMONED_DEMON			= 44	;
const int GIL_TROLL						= 45 	; 	// Troll / Schwarzer Troll
const int GIL_SWAMPSHARK				= 46	; 	// (bei Bedarf)
const int GIL_DRAGON					= 47	; 	// Feuerdrache / Eisdrache / Felsdrache / Sumpfdrache / Untoter Drache
const int GIL_MOLERAT					= 48	; 	// Molerat

const int GIL_ALLIGATOR					= 49	;
const int GIL_SWAMPGOLEM				= 50	;
const int GIL_Stoneguardian				= 51	;
const int GIL_Gargoyle					= 52	;
const int GIL_Empty_A					= 53	;
const int GIL_SummonedGuardian			= 54	;
const int GIL_SummonedZombie			= 55	;
const int GIL_EMPTY_B					= 56	;
const int GIL_EMPTY_C					= 57	;

const int GIL_SEPERATOR_ORC				= 58	;	// (ehem. 37)

const int GIL_ORC						= 59	;	// Ork-Krieger / Ork-Shamane / Ork-Elite
const int GIL_FRIENDLY_ORC				= 60	;	// Ork-Sklave / Ur-Shak
const int GIL_UNDEADORC					= 61	;
const int GIL_DRACONIAN					= 62	;

const int GIL_EMPTY_X					= 63	;
const int GIL_EMPTY_Y					= 64	;
const int GIL_EMPTY_Z					= 65	;

const int GIL_MAX						= 66	;	// (ehem. 42)



//
//	GUILDS DESCRIPTION
//
CLASS C_GILVALUES
{
	VAR INT		WATER_DEPTH_KNEE						[GIL_MAX]				;
	VAR INT		WATER_DEPTH_CHEST						[GIL_MAX]				;
	VAR INT		JUMPUP_HEIGHT							[GIL_MAX]				;		//	DEFAULT = 200;
//	VAR INT		JUMPUP_FORCE							[GIL_MAX]				;
	VAR INT		SWIM_TIME								[GIL_MAX]				;
	VAR INT		DIVE_TIME								[GIL_MAX]				;
	VAR INT		STEP_HEIGHT								[GIL_MAX]				;
	VAR INT		JUMPLOW_HEIGHT							[GIL_MAX]				;
	VAR INT		JUMPMID_HEIGHT							[GIL_MAX]				;
	VAR INT		SLIDE_ANGLE								[GIL_MAX]				;
	VAR INT		SLIDE_ANGLE2							[GIL_MAX]				;
	VAR INT		DISABLE_AUTOROLL						[GIL_MAX]				;		//	DEFAULT = 0					;  0 = Autoroll  enabled	/ 1 = Autoroll  disabled
	VAR INT		SURFACE_ALIGN							[GIL_MAX]				;		//	DEFAULT = 0					;  0 = Alignment disabled	/ 1 = Alignment enabled
	VAR INT		CLIMB_HEADING_ANGLE						[GIL_MAX]				;
	VAR INT		CLIMB_HORIZ_ANGLE						[GIL_MAX]				;
	VAR INT		CLIMB_GROUND_ANGLE						[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_BASE						[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_FIST						[GIL_MAX]				;
	var int 	FIGHT_RANGE_G							[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_1HS							[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_1HA							[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_2HS							[GIL_MAX]				;
	VAR INT		FIGHT_RANGE_2HA							[GIL_MAX]				;
	VAR INT		FALLDOWN_HEIGHT							[GIL_MAX]				;		//									Wie tief Fallen ohne Schaden ?
	VAR INT		FALLDOWN_DAMAGE							[GIL_MAX]				;		//									Schaden f�r jeden weiteren angefangenen Meter.
	VAR INT		BLOOD_DISABLED							[GIL_MAX]				;		//	DEFAULT = 0					;	Blut ganz ausschalten (z.B. bei Sekletten) ?
	VAR INT		BLOOD_MAX_DISTANCE						[GIL_MAX]				;		//	DEFAULT = 1000				;	Wie weit spritzt das Blut (in cm) ?
	VAR INT		BLOOD_AMOUNT							[GIL_MAX]				;		//	DEFAULT = 10				;	Wie viel Blut ?
	VAR INT		BLOOD_FLOW								[GIL_MAX]				;		//	DEFAULT = 0					;	Soll es sich langsam ausbreiten ?
	VAR STRING  BLOOD_EMITTER							[GIL_MAX]				;		//	DEFAULT = "PFX_BLOOD"		;	Welcher Partikel-Emitter ?
	VAR STRING  BLOOD_TEXTURE							[GIL_MAX]				;		//	DEFAULT = "ZBLOODSPLAT2.TGA";	Welche Textur ?
	VAR INT 	TURN_SPEED								[GIL_MAX]				;		//	DEFAULT = 150				;
};

//
//	SOUND TYPES
//
CONST INT NPC_SOUND_DROPTAKE							= 1						;
CONST INT NPC_SOUND_SPEAK								= 3						;
CONST INT NPC_SOUND_STEPS								= 4						;
CONST INT NPC_SOUND_THROWCOLL							= 5						;
CONST INT NPC_SOUND_DRAWWEAPON							= 6						;
CONST INT NPC_SOUND_SCREAM								= 7						;
CONST INT NPC_SOUND_FIGHT								= 8						;

//
//	MATERIAL TYPES
//
CONST INT MAT_WOOD										= 0						;
CONST INT MAT_STONE										= 1						;
CONST INT MAT_METAL										= 2						;
CONST INT MAT_LEATHER									= 3						;
CONST INT MAT_CLAY										= 4						;
CONST INT MAT_GLAS										= 5						;		// ??

//
//	LOG
//
CONST INT LOG_MISSION									= 0						;
CONST INT LOG_NOTE										= 1						;

//
//	OTHER CONSTANTS
//
const int TIME_INFINITE									= -1000000 / 1000		;
const int NPC_VOICE_VARIATION_MAX						= 10					;

const float		TRADE_VALUE_MULTIPLIER					= 0.15;			// DEFAULT = 0.3			Faktor auf den Wert eines Items, den ein Haendler bezahlt
const string	TRADE_CURRENCY_INSTANCE					= "ITMI_GOLD";	// DEFAULT = "ITMI_GOLD"	Name der Instanz des Waehrungs-Items


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Kategorie-Konstanten
//

const int SPELL_GOOD	= 0;
const int SPELL_NEUTRAL	= 1;
const int SPELL_BAD		= 2;


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Steuerungs-Konstanten
//

const int SPL_DONTINVEST 		= 0;		// Es k�nnen keine weiteren Manapunkte investiert werden. Erst durch CTRL loslassen geht der Spell ab
const int SPL_RECEIVEINVEST		= 1;		// Wirkung durchgef�hrt, es k�nnen weitere Invest kommen, zB.bei Heal nach jedem P�ppel
const int SPL_SENDCAST			= 2;		// Starte den Zauber-Effekt (wie CTRL loslassen), automatischer Abbruch
const int SPL_SENDSTOP			= 3;		// Beende Zauber ohne Effekt
const int SPL_NEXTLEVEL			= 4;		// setze den Spruch auf den n�chsten Level
const int SPL_STATUS_CANINVEST_NO_MANADEC=8;
const int SPL_FORCEINVEST		 = 1 << 16;	// zieht auf jeden Fall einen Manapunkt ab, egal ob timePerMana abgelaufen ist, oder nicht (sinnvoll f�r Investierzauber, die zumindest einen Manapunkt abziehen sollen, obwohl timePerMana noch nicht abgelaufen ist.


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Target-Konstanten
//

const int TARGET_COLLECT_NONE 					= 0;	// target will be set by effect (range, azi, elev)
const int TARGET_COLLECT_CASTER					= 1;	// target is the caster
const int TARGET_COLLECT_FOCUS 					= 2;	// target is the focus vob
const int TARGET_COLLECT_ALL 					= 3;	// all targets in range will be assembled
const int TARGET_COLLECT_FOCUS_FALLBACK_NONE	= 4;	// target is the focus vob, if the focus vob is not valid, the trajectory will be set by the effect
const int TARGET_COLLECT_FOCUS_FALLBACK_CASTER	= 5;	// target is the focus vob, if the focus vob is not valid, the target is the caster
const int TARGET_COLLECT_ALL_FALLBACK_NONE		= 6;	// all targets in range will be assembled, if there are no valid targets, the trajectory will be set by the effect
const int TARGET_COLLECT_ALL_FALLBACK_CASTER	= 7;	// all targets in range will be assembled, if there are no valid targets, the target is the caster

const int TARGET_TYPE_ALL		= 1;
const int TARGET_TYPE_ITEMS		= 2;
const int TARGET_TYPE_NPCS		= 4;
const int TARGET_TYPE_ORCS		= 8;
const int TARGET_TYPE_HUMANS	= 16;
const int TARGET_TYPE_UNDEAD	= 32;


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: ID-Konstanten
//

// Paladin-Runen
const int SPL_PalLight				= 0;
const int SPL_PalLightHeal			= 1;
const int SPL_PalHolyBolt			= 2;
const int SPL_PalMediumHeal			= 3;
const int SPL_PalRepelEvil			= 4;
const int SPL_PalFullHeal			= 5;
const int SPL_PalDestroyEvil		= 6;

// Teleport-Runen
const int SPL_PalTeleportSecret		= 7;
const int SPL_TeleportSeaport		= 8;
const int SPL_TeleportMonastery		= 9;
const int SPL_TeleportFarm			= 10;
const int SPL_TeleportXardas		= 11;
const int SPL_TeleportPassNW		= 12;
const int SPL_TeleportPassOW		= 13;
const int SPL_TeleportOC			= 14;
const int SPL_TeleportOWDemonTower 	= 15;
const int SPL_TeleportTaverne		= 16;
const int SPL_Teleport_3			= 17;

// Kreis 1
const int SPL_Light 				= 18;
const int SPL_Firebolt				= 19;

// Kreis 2
const int SPL_Icebolt				= 20;

// Kreis 1
const int SPL_LightHeal				= 21;		// SPL_Heal Instant!
const int SPL_SummonGoblinSkeleton	= 22;

// Kreis 2
const int SPL_InstantFireball		= 23;

// Kreis 1
const int SPL_Zap					= 24; 		// ###UNCONSCIOUS###

// Kreis 2
const int SPL_SummonWolf			= 25;
const int SPL_WindFist				= 26;		// ###UNCONSCIOUS###
const int SPL_Sleep					= 27;

// Kreis 3
const int SPL_MediumHeal			= 28;
const int SPL_LightningFlash		= 29;
const int SPL_ChargeFireball		= 30;
const int SPL_SummonSkeleton		= 31;
const int SPL_Fear					= 32;
const int SPL_IceCube				= 33;

// Kreis 4
const int SPL_ChargeZap				= 34;
const int SPL_SummonGolem			= 35;
const int SPL_DestroyUndead			= 36;
const int SPL_Pyrokinesis			= 37;

// Kreis 5
const int SPL_Firestorm				= 38;
const int SPL_IceWave				= 39;
const int SPL_SummonDemon			= 40;
const int SPL_FullHeal				= 41;

// Kreis 6
const int SPL_Firerain				= 42;
const int SPL_BreathOfDeath			= 43;
const int SPL_MassDeath				= 44;
const int SPL_ArmyOfDarkness		= 45;
const int SPL_Shrink				= 46;

// Scrolls
const int SPL_TrfSheep				= 47;
const int SPL_TrfScavenger			= 48;
const int SPL_TrfGiantRat			= 49;
const int SPL_TrfGiantBug			= 50;
const int SPL_TrfWolf				= 51;
const int SPL_TrfWaran				= 52;
const int SPL_TrfSnapper			= 53;
const int SPL_TrfWarg				= 54;
const int SPL_TrfFireWaran			= 55;
const int SPL_TrfLurker				= 56;
const int SPL_TrfShadowbeast		= 57;
const int SPL_TrfDragonSnapper		= 58;
const int SPL_Charm					= 59;	// MAX_SPELL (Gothic)

// Kreis 5
const int SPL_MasterOfDisaster		= 60;

// ???
const int SPL_Deathbolt				= 61;
const int SPL_Deathball				= 62;
const int SPL_ConcussionBolt		= 63;
const int SPL_Reserved_64			= 64;	// SPL_E
const int SPL_Reserved_65		    = 65;	// SPL_F
const int SPL_Reserved_66	        = 66;	// SPL_G
const int SPL_Reserved_67	        = 67;	// SPL_H
const int SPL_Reserved_68			= 68;	// MAX_SPELL (Gothic2)
const int SPL_Reserved_69			= 69;

// Magick (Wasser)
const int SPL_Thunderstorm			= 70;
const int SPL_Whirlwind				= 71;
const int SPL_WaterFist				= 72;
const int SPL_IceLance				= 73;
const int SPL_Inflate				= 74;
const int SPL_Geyser				= 75;
const int SPL_Waterwall				= 76;
const int SPL_Reserved_77			= 77;
const int SPL_Reserved_78			= 78;
const int SPL_Reserved_79			= 79;

// Magick (Maya)
const int SPL_Plague				= 80;
const int SPL_Swarm					= 81;
const int SPL_GreenTentacle			= 82;
const int SPL_Earthquake			= 83;
const int SPL_SummonGuardian		= 84;
const int SPL_Energyball			= 85;
const int SPL_SuckEnergy			= 86;
const int SPL_Skull					= 87;
const int SPL_SummonZombie			= 88;
const int SPL_SummonMud				= 89;

// ...
const int SPL_Reserved_90			= 90;
const int SPL_Reserved_91			= 91;
const int SPL_Reserved_92			= 92;
const int SPL_Reserved_93			= 93;
const int SPL_Reserved_94			= 94;
const int SPL_Reserved_95			= 95;
const int SPL_Reserved_96			= 96;
const int SPL_Reserved_97			= 97;
const int SPL_Reserved_98			= 98;
const int SPL_Reserved_99			= 99;

const int SPL_SummonSonja			= 100;
const int SPL_TeleportSonja			= 101;
const int SPL_TeleportRoteLaterne   = 102;
const int SPL_SummonDragon          = 103;

const int MAX_SPELL					= 104;   // 59 (Gothic), 68 (Gothic2), 100 (G2Addon), 104 (Sonja)


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Fx-/Spell-Klassennamen (Array)
//

const string spellFxInstanceNames[MAX_SPELL] =
{
	// Paladin-Runen
	"PalLight",				// 0	SPL_PalLight
	"PalHeal",  			// 1	SPL_PalLightHeal
	"PalHolyBolt",  		// 2	SPL_PalHolyBolt
	"PalHeal",  			// 3	SPL_PalMediumHeal
	"PalRepelEvil",			// 4	SPL_PalRepelEvil
	"PalHeal",  			// 5	SPL_PalFullHeal
	"PalDestroyEvil",  		// 6	SPL_PalDestroyEvil

	// Teleport-Runen
	"Teleport",  			// 7	SPL_PalTeleportSecret
	"Teleport",  			// 8	SPL_TeleportSeaport
	"Teleport",  			// 9	SPL_TeleportMonastery
	"Teleport",  			// 10	SPL_TeleportFarm
	"Teleport",  			// 11	SPL_TeleportXardas
	"Teleport",  			// 12	SPL_TeleportPassNW
	"Teleport",  			// 13	SPL_TeleportPassOW
	"Teleport",  			// 14	SPL_TeleportOC
	"Teleport",  			// 15	SPL_TeleportOWDemonTower
	"Teleport",  			// 16	SPL_TeleportTaverne
	"Teleport",  			// 17	SPL_Teleport_3

	// Kreis 1
	"Light",				// 18	SPL_Light
	"Firebolt",				// 19	SPL_Firebolt

	// Kreis 2
	"Icebolt",				// 20	SPL_Icebolt

	// Kreis 1
	"Heal",  				// 21	SPL_LightHeal
	"SummonGoblinSkeleton",	// 22	SPL_SummonGoblinSkeleton

	// Kreis 2
	"InstantFireball",  	// 23	SPL_InstantFireball

	// Kreis 1
	"Zap",					// 24	SPL_Zap

	// Kreis 2
	"SummonWolf",  			// 25	SPL_SummonWolf
	"WindFist",  			// 26	SPL_WindFist
	"Sleep",  				// 27	SPL_Sleep

	// Kreis 3
	"Heal",  				// 28	SPL_MediumHeal
	"LightningFlash",		// 29	SPL_LightningFlash
	"ChargeFireball",  		// 30	SPL_ChargeFireball
	"SummonSkeleton",  		// 31	SPL_SummonSkeleton
	"Fear",  				// 32	SPL_Fear
	"Icecube",  			// 33	SPL_IceCube

	// Kreis 4
	"ChargeZap",  			// 34	SPL_ChargeZap
	"SummonGolem",  		// 53	SPL_SummonGolem
	"DestroyUndead",  		// 36	SPL_DestroyUndead
	"Pyrokinesis",  		// 37	SPL_Pyrokinesis

	// Kreis 5
	"Firestorm", 			// 38	SPL_Firestorm
	"Icewave",  			// 39	SPL_IceWave
	"SummonDemon",  		// 40	SPL_SummonDemon
	"Heal",  				// 41	SPL_FullHeal

	// Kreis 6
	"Firerain",  			// 42	SPL_Firerain
	"BreathOfDeath",  		// 43	SPL_BreathOfDeath
	"MassDeath",  			// 44	SPL_MassDeath
	"ArmyOfDarkness", 		// 45	SPL_ArmyOfDarkness
	"Shrink",  				// 46	SPL_Shrink

	// Scrolls
	"Transform",  			// 47	SPL_TrfSheep
	"Transform",  			// 48	SPL_TrfScavenger
	"Transform",  			// 49	SPL_TrfGiantRat
	"Transform",  			// 50	SPL_TrfGiantBug
	"Transform",  			// 51	SPL_TrfWolf
	"Transform",  			// 52	SPL_TrfWaran
	"Transform",  			// 53	SPL_TrfSnapper
	"Transform",  			// 54	SPL_TrfWarg
	"Transform",  			// 55	SPL_TrfFireWaran
	"Transform",  			// 56	SPL_TrfLurker
	"Transform",  			// 57	SPL_TrfShadowbeast
	"Transform",  			// 58	SPL_TrfDragonSnapper
	"Charm",				// 59	SPL_Charm

	// Kreis 5
	"MasterOfDisaster", 	// 60	SPL_MasterOfDisaster

	// ???
	"Deathbolt",  			// 61	SPL_Deathbolt
	"Deathball", 			// 62	SPL_Deathball
	"Concussionbolt", 		// 63	SPL_Concussionbolt
	"Light",  				// 64	SPL_Reserved_64
	"Light",  				// 65	SPL_Reserved_65
	"Light",  				// 66	SPL_Reserved_66
	"Light",				// 67	SPL_Reserved_67
	"Light",				// 68	SPL_Reserved_68
	"Light",				// 69	SPL_Reserved_69

	// Magick (Wasser)
    "Thunderstorm",			// 70	SPL_Thunderstorm
	"Whirlwind",			// 71	SPL_Whirlwind
	"Waterfist",			// 72	SPL_WaterFist
	"IceLance",				// 73	SPL_IceLance
	"Sleep",				// 74	SPL_Inflate
	"Geyser",				// 75	SPL_Geyser
	"Firerain",				// 76	SPL_Waterwall
	"Light",				// 77	SPL_Reserved_77
	"Light",				// 78	SPL_Reserved_78
	"Light",				// 79	SPL_Reserved_79

	// Magick (Maya)
	"Fear",					// 80	SPL_Plague
	"Swarm",				// 81	SPL_Swarm
	"Greententacle",		// 82	SPL_GreenTentacle
	"Firerain",				// 83	SPL_Earthquake
	"SummonGuardian",		// 84	SPL_SummonGuardian
	"Energyball",			// 85	SPL_Energyball
	"SuckEnergy",			// 86	SPL_SuckEnergy
	"Skull",				// 87	SPL_Skull
	"SummonZombie",			// 88	SPL_SummonZombie
	"SummonMud",			// 89	SPL_SummonMud

	// ...
	"Light",				// 90	SPL_Reserved_90
	"Light",				// 91	SPL_Reserved_91
	"Light",				// 92	SPL_Reserved_92
	"Light",				// 93	SPL_Reserved_93
	"Light",				// 94	SPL_Reserved_94
	"Light",				// 95	SPL_Reserved_95
	"Light",				// 96	SPL_Reserved_96
	"Light",				// 97	SPL_Reserved_97
	"Light",				// 98	SPL_Reserved_98
	"Light",				// 99	SPL_Reserved_99

	// Sonja
	"SummonSonja",			// 100	SPL_SummonSonja
	"Teleport",				// 101	SPL_TeleportSonja
	"Teleport",				// 102	SPL_TeleportRoteLaterne
	"SummonDragon"			// 103	SPL_SummonDragon
};


////////////////////////////////////////////////////////////////////////////////
//
//	Spells: Animationsk�rzel (Array)
//

const string spellFxAniLetters[MAX_SPELL] =
{
	// Paladin-Runen
	"SLE",					// 0	 SPL_PalLight
	"HEA",  				// 1	 SPL_PalLightHeal
	"FBT",  				// 2	 SPL_PalHolyBolt
	"HEA",  				// 3	 SPL_PalMediumHeal
	"FBT",					// 4	 SPL_PalRepelEvil
	"HEA",  				// 5	 SPL_PalFullHeal
	"FIB",  				// 6	 SPL_PalDestroyEvil

	// Teleport-Runen
	"HEA",  				// 7	SPL_PalTeleportSecret
	"HEA",  				// 8	SPL_TeleportSeaport
	"HEA",  				// 9	SPL_TeleportMonastery
	"HEA",  				// 10	SPL_TeleportFarm
	"HEA",  				// 11	SPL_TeleportXardas
	"HEA",  				// 12	SPL_TeleportPassNW
	"HEA",  				// 13	SPL_TeleportPassOW
	"HEA",  				// 14	SPL_TeleportOC
	"HEA",  				// 15	SPL_TeleportOWDemonTower
	"HEA",  				// 16	SPL_TeleportTaverne
	"HEA",  				// 17	SPL_Teleport_3

	// Kreis 1
	"SLE",					// 18	SPL_Light
	"FBT",					// 19	SPL_Firebolt

	// Kreis 2
	"FBT",					// 20	SPL_Icebolt

	// Kreis 1
	"HEA",  				// 21	SPL_LightHeal
	"SUM",  				// 22	SPL_SummonGoblinSkeleton

	// Kreis 2
	"FBT",  				// 23	SPL_InstantFireball

	// Kreis 1
	"FBT",					// 24	SPL_Zap

	// Kreis 2
	"SUM",  				// 25	SPL_SummonWolf
	"WND",  				// 26	SPL_WindFist
	"SLE",  				// 27	SPL_Sleep

	// Kreis 3
	"HEA",  				// 28	SPL_MediumHeal
	"WND",  				// 29	SPL_LightningFlash
	"FIB",  				// 30	SPL_ChargeFireball
	"SUM",  				// 31	SPL_SummonSkeleton
	"FEA",  				// 32	SPL_Fear
	"FRZ",  				// 33	SPL_IceCube
	"FIB",  				// 34	SPL_ChargeZap

	// Kreis 4
	"SUM",  				// 35	SPL_SummonGolem
	"FIB",  				// 36	SPL_DestroyUndead
	"FIB",  				// 37	SPL_Pyrokinesis

	// Kreis 5
	"FIB",  				// 38	SPL_Firestorm
	"FEA",  				// 39	SPL_IceWave
	"SUM",  				// 40	SPL_SummonDemon
	"HEA",  				// 41	SPL_FullHeal

	// Kreis 6
	"FEA",  				// 42	SPL_Firerain
	"FIB",  				// 43	SPL_BreathOfDeath
	"MSD",  				// 44	SPL_MassDeath
	"SUM",  				// 45	SPL_ArmyOfDarkness
	"SLE",  				// 46	SPL_Shrink

	// Scrolls
	"TRF",  				// 47	SPL_TrfSheep
	"TRF",  				// 48	SPL_TrfScavenger
	"TRF",  				// 49	SPL_TrfGiantRat
	"TRF",  				// 50	SPL_TrfGiantBug
	"TRF",  				// 51	SPL_TrfWolf
	"TRF",  				// 52	SPL_TrfWaran
	"TRF",  				// 53	SPL_TrfSnapper
	"TRF",  				// 54	SPL_TrfWarg
	"TRF",  				// 55	SPL_TrfFireWaran
	"TRF",  				// 56	SPL_TrfLurker
	"TRF",  				// 57	SPL_TrfShadowbeast
	"TRF",  				// 58	SPL_TrfDragonSnapper
	"FIB",					// 59	SPL_Charm

	// Kreis 5
	"FIB",  				// 60	SPL_MasterOfDisaster

	// ???
	"FBT",  				// 61	SPL_Deathbolt
	"FBT",  				// 62	SPL_Deathball
	"FBT",  				// 63	SPL_Concussionbolt
	"XXX",  				// 64	SPL_Reserved_64
	"XXX",  				// 65	SPL_Reserved_65
	"XXX",  				// 66	SPL_Reserved_66
	"XXX",					// 67	SPL_Reserved_67
 	"XXX",					// 68	SPL_Reserved_68
	"XXX",					// 69	SPL_Reserved_69

	// Magick (Wasser)
	"STM",  				// 70	SPL_Thunderstorm
	"WHI",  				// 71	SPL_Whirlwind		
	"WND",  				// 72	SPL_WaterFist
	"FBT",  				// 73	SPL_IceLance
	"SLE",  				// 74	SPL_Inflate			
	"WND",  				// 75	SPL_Geyser			
	"FEA",  				// 76	SPL_Waterwall
	"XXX",					// 77	SPL_Reserved_77
	"XXX",					// 78	SPL_Reserved_78
	"XXX",					// 79	SPL_Reserved_79

	// Magick (Maya)
	"FBT",  				// 80	SPL_Plague
	"FBT",  				// 81	SPL_Swarm			
	"FRZ",  				// 82	SPL_GreenTentacle
	"FEA",  				// 83	SPL_Earthquake
	"SUM",  				// 84	SPL_SummonGuardian
	"WND",  				// 85	SPL_Energyball
	"WND",  				// 86	SPL_SuckEnergy
	"WND",					// 87	SPL_Skull
	"SUM",					// 88	SPL_SummonZombie	
	"SUM",					// 89	SPL_SummonMud

	// ...
	"XXX",  				// 90	SPL_Reserved_90
	"XXX",  				// 91	SPL_Reserved_91
	"XXX",  				// 92	SPL_Reserved_92
	"XXX",  				// 93	SPL_Reserved_93
	"XXX",  				// 94	SPL_Reserved_94
	"XXX",  				// 95	SPL_Reserved_95
	"XXX",  				// 96	SPL_Reserved_96
	"XXX",					// 97	SPL_Reserved_97
	"XXX",					// 98	SPL_Reserved_98
	"XXX",					// 99	SPL_Reserved_99

	// Sonja
	"SUM",  				// 100	SPL_SummonSonja Sonja herbeirufen
	"HEA",  				// 101	SPL_TeleportSonja Zu Sonja teleportieren
	"HEA",  				// 102	SPL_TeleportRoteLaterne Zu Sonja teleportieren
	"SUM"  				    // 103	SPL_SummonDragon Sonja herbeirufen
};


// *******
// Talente
// *******

const int NPC_TALENT_UNKNOWN			= 0;

// Skilled Talents
const int NPC_TALENT_1H					= 1;
const int NPC_TALENT_2H					= 2;
const int NPC_TALENT_BOW				= 3;
const int NPC_TALENT_CROSSBOW			= 4;

const int NPC_TALENT_PICKLOCK			= 5;	//wird jetzt per DEX geregelt
//const int NPC_TALENT_PICKPOCKET		= 6;	//altes Pickpocket aus Gothic 1 - NICHT benutzen! Bleibt als Relikt im Code

// Magiekreis
const int NPC_TALENT_MAGE				= 7;

// Special-Talents
const int NPC_TALENT_SNEAK				= 8;
const int NPC_TALENT_REGENERATE			= 9;	//??? was ist davon drin?
const int NPC_TALENT_FIREMASTER			= 10;	//??? was ist davon drin?
const int NPC_TALENT_ACROBAT			= 11;	//--> Anis �ndern!

// NEW Talents //werden komplett auf Scriptebene umgesetzt - Programm braucht sie nur f�r Ausgabe im Characterscreen
const int NPC_TALENT_PICKPOCKET			= 12;
const int NPC_TALENT_SMITH				= 13;
const int NPC_TALENT_RUNES				= 14;
const int NPC_TALENT_ALCHEMY			= 15;
const int NPC_TALENT_TAKEANIMALTROPHY	= 16;

const int NPC_TALENT_FOREIGNLANGUAGE	= 17;
const int NPC_TALENT_WISPDETECTOR		= 18;
const int NPC_TALENT_C					= 19;
const int NPC_TALENT_D					= 20;
const int NPC_TALENT_E					= 21;

// Sonja
const int NPC_TALENT_WOMANIZER		    = 19;
const int NPC_TALENT_PIMP		        = 20;

const int NPC_TALENT_MAX				= 22;	//ehem. 12


// *************
// Runen-Talente
// *************

var int PLAYER_TALENT_RUNES[MAX_SPELL];				//Die SPL_ Konstanten werden hierf�r als Kennung verwendet

// *************
// ForeignLanguage-TalentStufen
// *************

const int LANGUAGE_1 		= 0;
const int LANGUAGE_2 		= 1;
const int LANGUAGE_3 		= 2;

const int MAX_LANGUAGE 		= 3;

var int PLAYER_TALENT_FOREIGNLANGUAGE[MAX_LANGUAGE];

// *************
// WispDetector-Talente
// *************

const int WISPSKILL_NF	 			= 0;
const int WISPSKILL_FF	 			= 1;
const int WISPSKILL_NONE 			= 2;
const int WISPSKILL_RUNE 			= 3;
const int WISPSKILL_MAGIC    		= 4;
const int WISPSKILL_FOOD 			= 5;
const int WISPSKILL_POTIONS   		= 6;

const int MAX_WISPSKILL 			= 7;

var int PLAYER_TALENT_WISPDETECTOR [MAX_WISPSKILL];

VAR int WispSearching;
const int WispSearch_Follow 	= 1;
const int WispSearch_ALL		= 2;
const int WispSearch_POTIONS	= 3;
const int WispSearch_MAGIC		= 4;
const int WispSearch_FOOD		= 5;
const int WispSearch_NF			= 6;
const int WispSearch_FF			= 7;
const int WispSearch_NONE		= 8;
const int WispSearch_RUNE		= 9;

// ****************
// Alchemie-Talente
// ****************

const int POTION_Health_01	  			= 0;
const int POTION_Health_02  			= 1;
const int POTION_Health_03  			= 2;
const int POTION_Mana_01  				= 3;
const int POTION_Mana_02  				= 4;
const int POTION_Mana_03 	 			= 5;
const int POTION_Speed  				= 6;
const int POTION_Perm_STR  				= 7;
const int POTION_Perm_DEX  				= 8;
const int POTION_Perm_Mana  			= 9;
const int POTION_Perm_Health			= 10;
const int POTION_MegaDrink				= 11;
const int CHARGE_Innoseye				= 12;
const int POTION_Mana_04				= 13;
const int POTION_Health_04				= 14;

const int MAX_POTION					= 15;

var int PLAYER_TALENT_ALCHEMY[MAX_POTION];


// ***************
// Schmied-Talente
// ***************

const int WEAPON_Common					= 0;

const int WEAPON_1H_Special_01			= 1;
const int WEAPON_2H_Special_01			= 2;
const int WEAPON_1H_Special_02			= 3;
const int WEAPON_2H_Special_02			= 4;
const int WEAPON_1H_Special_03			= 5;
const int WEAPON_2H_Special_03			= 6;
const int WEAPON_1H_Special_04			= 7;
const int WEAPON_2H_Special_04			= 8;

const int WEAPON_1H_Harad_01			= 9;	
const int WEAPON_1H_Harad_02			= 10;
const int WEAPON_1H_Harad_03			= 11;
const int WEAPON_1H_Harad_04			= 12;

const int MAX_WEAPONS 					= 13;

var int PLAYER_TALENT_SMITH[MAX_WEAPONS];


// ********************
// AnimalTrophy-Talente
// ********************

const int TROPHY_Teeth					= 0;
const int TROPHY_Claws					= 1;
const int TROPHY_Fur					= 2;
const int TROPHY_Heart					= 3;
const int TROPHY_ShadowHorn 			= 4;
const int TROPHY_FireTongue				= 5;
const int TROPHY_BFWing					= 6;
const int TROPHY_BFSting				= 7;
const int TROPHY_Mandibles				= 8;
const int TROPHY_CrawlerPlate			= 9;
const int TROPHY_DrgSnapperHorn			= 10;
const int TROPHY_DragonScale			= 11;
const int TROPHY_DragonBlood			= 12;
const int TROPHY_ReptileSkin			= 13;

const int MAX_TROPHIES					= 14;

var int PLAYER_TALENT_TAKEANIMALTROPHY[MAX_TROPHIES];


// ****************************************
// Font-Konstanten der Engine (ausgelagert)
// ****************************************

const string TEXT_FONT_20 			= "Font_old_20_white.tga";
const string TEXT_FONT_10 			= "Font_old_10_white.tga";
const string TEXT_FONT_DEFAULT 		= "Font_old_10_white.tga";
const string TEXT_FONT_Inventory 	= "Font_old_10_white.tga";


// ****************************************
// wie lange bklleibt ein TExt (OU) stehen,
// wenn kein wav da ist (msec/character)
// ****************************************

const float VIEW_TIME_PER_CHAR		= 550;

// ****************************************
//	LevelZen-Abfrage im B_Kapitelwechsel
// ****************************************

const int NEWWORLD_ZEN 					= 1;
const int OLDWORLD_ZEN 					= 2;
const int DRAGONISLAND_ZEN				= 3;
const int ADDONWORLD_ZEN				= 4;

const int SONJAWORLD_ZEN				= 5;


// ****************************************
//	Kamera f�r Inventory-Items
// ****************************************

const int INVCAM_ENTF_RING_STANDARD 	= 400;
const int INVCAM_ENTF_AMULETTE_STANDARD = 150;
const int INVCAM_ENTF_MISC_STANDARD 	= 200;
const int INVCAM_ENTF_MISC2_STANDARD 	= 250;
const int INVCAM_ENTF_MISC3_STANDARD 	= 500;
const int INVCAM_ENTF_MISC4_STANDARD 	= 650;
const int INVCAM_ENTF_MISC5_STANDARD 	= 850;
const int INVCAM_X_RING_STANDARD 		= 25;
const int INVCAM_Z_RING_STANDARD 		= 45;

/*
const int INVCAM_ENTF_MISC_STANDARD 	= 150;
const int INVCAM_X_MISC_STANDARD 		= 0;
const int INVCAM_Y_MISC_STANDARD 		= 0;
const int INVCAM_Z_MISC_STANDARD 		= 0;
*/



























// ********************************
// Anmeldung der MenuItem-Instanzen
// ********************************

instance MENU_STATUS (C_MENU_DEF) 
{
	// Gilde, Level, XP und Magiekreis
	
	items[0]	= "MENU_ITEM_STATUS_HEADING";
	// ---------------------------------------------
	items[1]	= "MENU_ITEM_PLAYERGUILD";
	items[2]	= "MENU_ITEM_LEVEL_TITLE";
	items[3]	= "MENU_ITEM_LEVEL";
	// ---------------------------------------------
	items[4]	= "MENU_ITEM_TALENT_7_TITLE"; 		//Magie
	items[5]	= "MENU_ITEM_TALENT_7_CIRCLE";		//Kreis
	items[6]	= "MENU_ITEM_TALENT_7_SKILL";
	// ---------------------------------------------
	items[7]	= "MENU_ITEM_EXP_TITLE";
	items[8]	= "MENU_ITEM_EXP";
	// ---------------------------------------------
	items[9]	= "MENU_ITEM_LEVEL_NEXT_TITLE";
	items[10]	= "MENU_ITEM_LEVEL_NEXT";
	// ---------------------------------------------
	items[11]	= "MENU_ITEM_LEARN_TITLE";
	items[12]	= "MENU_ITEM_LEARN";
	
	// ------ Attribute ------
	items[13]	= "MENU_ITEM_ATTRIBUTE_HEADING";
	// --------------------------------------------			   
	items[14]	= "MENU_ITEM_ATTRIBUTE_1_TITLE";
	items[15]	= "MENU_ITEM_ATTRIBUTE_2_TITLE";
	items[16]	= "MENU_ITEM_ATTRIBUTE_3_TITLE";
	items[17]	= "MENU_ITEM_ATTRIBUTE_4_TITLE";
	// ---------------------------------------------
	items[18]	= "MENU_ITEM_ATTRIBUTE_1";
	items[19]	= "MENU_ITEM_ATTRIBUTE_2";
	items[20]	= "MENU_ITEM_ATTRIBUTE_3";
	items[21]	= "MENU_ITEM_ATTRIBUTE_4";


	// R�stungswerte
	
	items[22]	= "MENU_ITEM_ARMOR_HEADING";
	// ---------------------------------------------
	items[23]	= "MENU_ITEM_ARMOR_1_TITLE";
	items[24]	= "MENU_ITEM_ARMOR_2_TITLE";
	items[25]	= "MENU_ITEM_ARMOR_3_TITLE";
	items[26]	= "MENU_ITEM_ARMOR_4_TITLE";
	// --------------------------------------------
	items[27]	= "MENU_ITEM_ARMOR_1";
	items[28]	= "MENU_ITEM_ARMOR_2";
	items[29]	= "MENU_ITEM_ARMOR_3";
	items[30]	= "MENU_ITEM_ARMOR_4";
	
	
	// TALENTE
	
	items[31]	= "MENU_ITEM_TALENTS_HEADING";
	// --- 1h ------------------------------------------
	items[32]	= "MENU_ITEM_TALENT_1_TITLE";
	items[33]	= "MENU_ITEM_TALENT_1_SKILL";
	items[34]	= "MENU_ITEM_TALENT_1";
	// --- 2h -----------------------------------------
	items[35]	= "MENU_ITEM_TALENT_2_TITLE";
	items[36]	= "MENU_ITEM_TALENT_2_SKILL";
	items[37]	= "MENU_ITEM_TALENT_2";
	// --- Bow ------------------------------------------
	items[38]	= "MENU_ITEM_TALENT_3_TITLE";
	items[39]	= "MENU_ITEM_TALENT_3_SKILL";
	items[40]	= "MENU_ITEM_TALENT_3";
	// --- Crossbow ------------------------------------------
	items[41]	= "MENU_ITEM_TALENT_4_TITLE";
	items[42]	= "MENU_ITEM_TALENT_4_SKILL";
	items[43]	= "MENU_ITEM_TALENT_4";

	// --- Sneak ------------------------------------------
	items[44]	= "MENU_ITEM_TALENT_8_TITLE";
	items[45]	= "MENU_ITEM_TALENT_8_SKILL";
	// --- Picklock ---------------------------------------
	items[46]	= "MENU_ITEM_TALENT_5_TITLE";
	items[47]	= "MENU_ITEM_TALENT_5_SKILL";
	// --- Pickpocket ------------------------------------------
	items[48]	= "MENU_ITEM_TALENT_12_TITLE";
	items[49]	= "MENU_ITEM_TALENT_12_SKILL";
	// --- Runes ---------------------------------------
	items[50]	= "MENU_ITEM_TALENT_14_TITLE";
	items[51]	= "MENU_ITEM_TALENT_14_SKILL";
	// --- Alchemy ------------------------------------------
	items[52]	= "MENU_ITEM_TALENT_15_TITLE";
	items[53]	= "MENU_ITEM_TALENT_15_SKILL";
	// --- Smith ------------------------------------------
	items[54]	= "MENU_ITEM_TALENT_13_TITLE";
	items[55]	= "MENU_ITEM_TALENT_13_SKILL";
	// --- TakeAnimalTrophy ------------------------------------------
	items[56]	= "MENU_ITEM_TALENT_16_TITLE";
	items[57]	= "MENU_ITEM_TALENT_16_SKILL";

	// --- Aufreisser ------------------------------------------
	items[58]	= "MENU_ITEM_TALENT_19_TITLE";
	items[59]	= "MENU_ITEM_TALENT_19_SKILL";
	items[60]	= "MENU_ITEM_TALENT_19";

	// --- Zuh�lter ------------------------------------------
	items[61]	= "MENU_ITEM_TALENT_20_TITLE";
	items[63]	= "MENU_ITEM_TALENT_20_CIRCLE";		//Kreis
	items[62]	= "MENU_ITEM_TALENT_20_SKILL";

	// ------ Eigenschaften ------
		
	dimx		= 8192;
	dimy		= 8192;
	flags		= flags | MENU_OVERTOP|MENU_NOANI;	
	backPic		= STAT_BACK_PIC;
};


// **********************
// Koordinaten Konstanten
// **********************

// ------ 1. Spalte ------
const int STAT_A_X1 =  500; //Titel
const int STAT_A_X2 = 2300; //Werte
const int STAT_A_X3 = 3000; //hintere Werte (Level _0_)
const int STAT_A_X4 = 3400;	//Ende der A-Spalte (zum zentrieren der Headings)

// ------ 2. Spalte ------
const int STAT_B_X1 = 3800; //Titel
const int STAT_B_X2 = 6000; //Talent-Bezeichnung
const int STAT_B_X3 = 7200; //%-Werte
const int STAT_B_X4 = 7700; //Ende der B-Spalte (zum zentrieren der Headings)

// ----- Zeilen / Blockanfang ------
// 1. Spalte
const int STAT_PLYHEAD_Y	= 1000;
const int STAT_PLY_Y 		= 1450; //Gilde / Punkteblock (1000 + 300 Fonth�he + 150 Abstand)

const int STAT_ATRHEAD_Y  	= 3250; 
const int STAT_ATR_Y 		= 3700; //Attributsblock

const int STAT_ARMHEAD_Y	= 5200;
const int STAT_ARM_Y 		= 5650; //Armorblock

// 2. Spalte
const int STAT_TALHEAD_Y  	= 1000;
const int STAT_TAL_Y  		= 1450; //2. Spalte - Talentblock

// ----- Zeilengr�sse ------
const int STAT_DY =  300;


// ******************
// Menuitem Instanzen
// ******************

// --------------- 
// Charakterprofil
// ---------------
instance MENU_ITEM_STATUS_HEADING(C_MENU_ITEM_DEF)
{
	text[0]	 	= "CHARAKTERPROFIL";
	posx		= STAT_A_X1;				posy = STAT_PLYHEAD_Y;	
	dimx 		= STAT_A_X4 - STAT_A_X1;	dimy = STAT_DY;
	fontName	= STAT_FONT_DEFAULT;
	flags		= (flags & ~IT_SELECTABLE)|IT_TXT_CENTER;
};

// ------ Gildenlos		Level 0 ------
instance MENU_ITEM_PLAYERGUILD(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_PLY_Y+STAT_DY*0;
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

instance MENU_ITEM_LEVEL_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_PLY_Y + STAT_DY*0;
	text[0]		= "Stufe";	
	fontName	= STAT_FONT_DEFAULT;		
	flags		= flags & ~IT_SELECTABLE; //Selectable wird mit &! rausgeworfen - alle andern Flags bleiben, wie sie sind
};

instance MENU_ITEM_LEVEL(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X3;				posy = STAT_PLY_Y + STAT_DY*0;	
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Magie 	Kreis 1	------ //Talent 7
instance MENU_ITEM_TALENT_7_TITLE(C_MENU_ITEM_DEF) 
{ 
	posx 		= STAT_A_X1;				posy = STAT_PLY_Y + STAT_DY*1;	
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE; 
};

instance MENU_ITEM_TALENT_7_CIRCLE(C_MENU_ITEM_DEF) 
{
	posx 		= STAT_A_X2;				posy = STAT_PLY_Y + STAT_DY*1;	
	text[0]		= "Kreis"; 
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE; 
};
instance MENU_ITEM_TALENT_7_SKILL(C_MENU_ITEM_DEF)  
{ 
	posx 		= STAT_A_X3;				posy = STAT_PLY_Y + STAT_DY*1;
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE; 
};

// ------ Erfahrung		16000 ------
instance MENU_ITEM_EXP_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_PLY_Y + STAT_DY*2;	
	text[0]		= "Erfahrung"; 
	fontName 	= STAT_FONT_DEFAULT;	
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_EXP(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_PLY_Y + STAT_DY*2;	
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Next Level XP 	20000 ------
instance MENU_ITEM_LEVEL_NEXT_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_PLY_Y + STAT_DY*3;	
	text[0]		= "N�chste Stufe";
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_LEVEL_NEXT(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_PLY_Y + STAT_DY*3;	
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Lernpunkte	1 ------
instance MENU_ITEM_LEARN_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_PLY_Y + STAT_DY*4;	
	text[0]		= "Lernpunkte";	
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

instance MENU_ITEM_LEARN(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_PLY_Y + STAT_DY*4;	
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};


// --------- 
// Attribute
// ---------

INSTANCE MENU_ITEM_ATTRIBUTE_HEADING(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_ATRHEAD_Y;
	dimx 		= STAT_A_X4 - STAT_A_X1;	dimy = STAT_DY;
	text[0]		= "ATTRIBUTE";	
	fontName	= STAT_FONT_DEFAULT;
	flags		= (flags & ~IT_SELECTABLE)|IT_TXT_CENTER;
};

// ------ St�rke ------
INSTANCE MENU_ITEM_ATTRIBUTE_1_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_ATR_Y + STAT_DY*0;
	text[0]		= "St�rke";
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ATTRIBUTE_1(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_ATR_Y + STAT_DY*0;
	fontName	= STAT_FONT_DEFAULT;	
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Geschick -------
INSTANCE MENU_ITEM_ATTRIBUTE_2_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_ATR_Y + STAT_DY*1;
	text[0]		= "Geschick";
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ATTRIBUTE_2(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_ATR_Y + STAT_DY*1;
	fontName	= STAT_FONT_DEFAULT;	
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Mana ------
INSTANCE MENU_ITEM_ATTRIBUTE_3_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_ATR_Y + STAT_DY*2;
	text[0]		= "Mana";
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ATTRIBUTE_3(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_ATR_Y + STAT_DY*2;
	fontName	= STAT_FONT_DEFAULT;	
	flags		= flags & ~IT_SELECTABLE;
};

// ------ Lebensenergie ------
INSTANCE MENU_ITEM_ATTRIBUTE_4_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1;				posy = STAT_ATR_Y + STAT_DY*3;
	text[0]		= "Lebensenergie";
	fontName	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ATTRIBUTE_4(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X2;				posy = STAT_ATR_Y + STAT_DY*3;
	fontName	= STAT_FONT_DEFAULT;	
	flags		= flags & ~IT_SELECTABLE;
};


// --------------
// R�stungsschutz
// --------------

INSTANCE MENU_ITEM_ARMOR_HEADING(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1; 				posy = STAT_ARMHEAD_Y;
	dimx 		= STAT_A_X4 - STAT_A_X1;	dimy = STAT_DY;
	text[0]		= "R�STUNGSSCHUTZ";
	fontName	= STAT_FONT_DEFAULT;
	flags		= (flags & ~IT_SELECTABLE)|IT_TXT_CENTER;
};

// ------ Waffen ------ (nur Edge wird angezeigt)
INSTANCE MENU_ITEM_ARMOR_1_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1; 				posy = STAT_ARM_Y + STAT_DY*0;
	text[0]		= "vor Waffen";
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ARMOR_1(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X3; 				posy = STAT_ARM_Y + STAT_DY*0;	
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

// ------ Point ------
instance MENU_ITEM_ARMOR_2_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1; 				posy = STAT_ARM_Y + STAT_DY*1;	
	text[0]		= "vor Geschossen";
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ARMOR_2(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X3; 				posy = STAT_ARM_Y + STAT_DY*1;	
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

// ------ Fire ------
INSTANCE MENU_ITEM_ARMOR_3_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1; 				posy = STAT_ARM_Y + STAT_DY*2;
	text[0]		= "vor Drachenfeuer";
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ARMOR_3(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X3; 				posy = STAT_ARM_Y + STAT_DY*2;
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

// ------ Magic ------
INSTANCE MENU_ITEM_ARMOR_4_TITLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X1; 				posy = STAT_ARM_Y + STAT_DY*3;
	text[0]		= "vor Magie";
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};

INSTANCE MENU_ITEM_ARMOR_4(C_MENU_ITEM_DEF)
{
	posx 		= STAT_A_X3; 				posy = STAT_ARM_Y + STAT_DY*3;
	fontName 	= STAT_FONT_DEFAULT;
	flags 		= flags & ~IT_SELECTABLE;
};


// -------
// Talente
// -------

INSTANCE MENU_ITEM_TALENTS_HEADING(C_MENU_ITEM_DEF)
{

	posx		= STAT_B_X1; 				posy = STAT_TALHEAD_Y;
	dimx 		= STAT_B_X4 - STAT_B_X1;	dimy = STAT_DY;
	text[0]		= "TALENTE";
	fontName	= STAT_FONT_DEFAULT;	
	flags		= (flags & ~IT_SELECTABLE)|IT_TXT_CENTER;
};

// ------ 1h ------ // Talent 1
INSTANCE MENU_ITEM_TALENT_1_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  0*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_1_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  0*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_1(C_MENU_ITEM_DEF) 	   { posx = STAT_B_X3;posy = STAT_TAL_Y +  0*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ 2h ------ // Talent 2
INSTANCE MENU_ITEM_TALENT_2_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  1*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_2_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  1*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_2(C_MENU_ITEM_DEF) 	   { posx = STAT_B_X3;posy = STAT_TAL_Y +  1*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ----- Bow ----- // Talent 3
INSTANCE MENU_ITEM_TALENT_3_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  2*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_3_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  2*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_3(C_MENU_ITEM_DEF)       { posx = STAT_B_X3;posy = STAT_TAL_Y +  2*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Crossbow // Talent 4
INSTANCE MENU_ITEM_TALENT_4_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  3*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_4_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  3*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_4(C_MENU_ITEM_DEF)       { posx = STAT_B_X3;posy = STAT_TAL_Y +  3*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// LEERZEILE

// ------ Sneak ------Talent 8
INSTANCE MENU_ITEM_TALENT_8_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y +  4*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_8_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y +  4*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Picklock ------ // Talent 5
INSTANCE MENU_ITEM_TALENT_5_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  5*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_5_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  5*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Pickpocket (NEW) ------ // Talent 12
INSTANCE MENU_ITEM_TALENT_12_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 6*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_12_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 6*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Runes ------ // Talent 14
INSTANCE MENU_ITEM_TALENT_14_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 7*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_14_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 7*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Alchemy ------ // Talent 15
INSTANCE MENU_ITEM_TALENT_15_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 8*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_15_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 8*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Smith ------ // Talent 13
INSTANCE MENU_ITEM_TALENT_13_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 9*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_13_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 9*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ TakeAnimalTrophy ------ // Talent 16
INSTANCE MENU_ITEM_TALENT_16_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 10*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_16_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 10*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Aufreisser ------ // Talent 19
INSTANCE MENU_ITEM_TALENT_19_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 11*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_19_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 11*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_19(C_MENU_ITEM_DEF) 	   { posx = STAT_B_X3;posy = STAT_TAL_Y +  11*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// ------ Zuh�lter ------ // Talent 20
INSTANCE MENU_ITEM_TALENT_20_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 12*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_20_CIRCLE(C_MENU_ITEM_DEF)
{
	posx 		= STAT_B_X2;				posy = STAT_TAL_Y + 12*STAT_DY;
	text[0]		= "Kreis";
	fontName 	= STAT_FONT_DEFAULT;
	flags		= flags & ~IT_SELECTABLE;
};

instance MENU_ITEM_TALENT_20_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X3;posy = STAT_TAL_Y + 12*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };







/*

// Talent 6
INSTANCE MENU_ITEM_TALENT_6_TITLE(C_MENU_ITEM_DEF) { posx = STAT_B_X1;posy = STAT_TAL_Y +  8*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_6_SKILL(C_MENU_ITEM_DEF) { posx = STAT_B_X2;posy = STAT_TAL_Y +  8*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
INSTANCE MENU_ITEM_TALENT_6(C_MENU_ITEM_DEF)       { posx = STAT_B_X3;posy = STAT_TAL_Y +  8*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };


// Spezial


// Talent 9
INSTANCE MENU_ITEM_TALENT_9_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y +  16*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_9_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y +  16*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// Talent 10
INSTANCE MENU_ITEM_TALENT_10_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 17*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_10_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 17*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// Talent 11
INSTANCE MENU_ITEM_TALENT_11_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 18*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_11_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 18*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

// Talent 12
INSTANCE MENU_ITEM_TALENT_12_TITLE(C_MENU_ITEM_DEF)  { posx = STAT_B_X1;posy = STAT_TAL_Y + 19*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };
instance MENU_ITEM_TALENT_12_SKILL(C_MENU_ITEM_DEF)  { posx = STAT_B_X2;posy = STAT_TAL_Y + 19*STAT_DY;	fontName = STAT_FONT_DEFAULT;flags=flags & ~IT_SELECTABLE; };

*/


//////////////////////////////////////
//
// 	Visual Effects
//	Instance-Definitions
//
//////////////////////////////////////

// visual effects config instance
// WICHTIG:
// die Parameter der Keys ver�ndern die effekte/visuals nur wenn ein Wert ungleich NULL angegeben wird,
// ausser bei INTEGER Variablen. Das heisst wenn ein KEY benutzt wird und ein Parameter den FX/das Visual �ndern
// soll, so muss dieser bei Floats leicht von 0 verschieden sein (z.B. 0.000001).
//
// Parameter der Keys wirken sich immer nur auf den ersten definierten PFX aus, bei Multi-PFX's nicht auf die Childs

INSTANCE STARGATE_SCREENBLEND	(CFx_Base_Proto)
{
	// userstring 0: screenblend loop duration
 	// userstring 1: screenblend color
 	// userstring 2: screenblend in/out duration
 	// userstring 3: screenblend texture
 	// userstring 4: tex ani fps
 	
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "10";
	userString[1]	=	"0 0 0 255";
	userString[2]	=	"3";
	userString[3]	=	"STARGATE_BLEND.TGA";
	visAlphaBlendFunc_S = "ADD";
 	
 	emFXLifeSpan    =	10;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  T H U N D E R S T O R M  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_Thunderstorm(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Thunderstorm_INIT";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";

     	emFXInvestOrigin_S 		= "FX_EarthQuake";  // "spellFX_Thunderstorm_INVESTGLOW";
		};

		INSTANCE spellFX_Thunderstorm_KEY_CAST	(C_ParticleFXEmitKey)
		{
				emCreateFXID		= "spellFX_Thunderstorm_RAIN";
				pfx_ppsIsLoopingChg = 1;
};

INSTANCE spellFX_Thunderstorm_RAIN		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderstorm_Rain";
		emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
		emActionCollDyn_S		= "CREATEONCE";
		//emFXCollDyn_S     		= "spellFX_Thunderstorm_COLLIDEDYNFX";
		emFXCollDynAlign_S		= "COLLISIONNORMAL";
     	emCheckCollision		= 1;
     	LightPresetName 		= "CATACLYSM";
     	//sfxid					= "MFX_Firerain_rain";
     	//sfxisambient			= 1;
     	
     	emFXCreatedOwnTrj 		= 1;
     	
     	emFXCreate_S			= "spellFX_ThunderStorm_Flash";
     	
     	sfxid					= "MFX_Thunderstorm_IceRain";
     	sfxisambient			= 1;
};


INSTANCE spellFX_Thunderstorm_INVESTGLOW	(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderstorm_InvestGlow";
		emTrjOriginNode 		= "BIP01";
		emFXCreatedOwnTrj 		= 1;
		emtrjmode_s 			= "FIXED";
		//lightPresetName 		= "REDAMBIENCE";
		//sfxid					= "MFX_Firerain_INVEST";
		//sfxisambient			= 1;
		emFXCreate_S			= "FX_EarthQuake";
};



/*INSTANCE spellFX_Thunderstorm_Dome	(CFx_Base_Proto)
{
		//visname_S 				= "MFX_Thunderstorm_Dome";
		emtrjmode_s 			= "FIXED";
		
		emTrjOriginNode 		= "BIP01";
		//LightPresetName 		= "CATACLYSM";
		emFXCreatedOwnTrj 		= 1;
     	
     	
};*/

INSTANCE spellFX_Thunderstorm_Flash	(CFx_Base_Proto)
{
		emFXCreatedOwnTrj 		= 1;
		visname_S 				= "MFX_Thunderstorm_Flashes";
		emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	
     	emFXCreate_S			=	"spellFX_ThunderStorm_Screenblend";
     	
     	sfxid					= "MFX_Thunderstorm_Thunder";
     	sfxisambient			= 1;
     	
};


INSTANCE spellFX_ThunderStorm_Screenblend	(CFx_Base_Proto)
{
	// userstring 0: screenblend loop duration
 	// userstring 1: screenblend color
 	// userstring 2: screenblend in/out duration
 	// userstring 3: screenblend texture
 	// userstring 4: tex ani fps
 	
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "10";
	userString[1]	=	"0 0 0 120";
	userString[2]	=	"3";
	visAlphaBlendFunc_S = "BLEND";
 	
 	//userString[3]	=	"simpleglow.tga";
	emFXLifeSpan    =	10;
};

/*INSTANCE spellFX_ThunderStorm_Screenblend	(CFx_Base_Proto)
{
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "0.5";
	userString[1]	=	"255 255 255 255";
	userString[2]	=	"0.25";
	emFXLifeSpan    =	0.5;
	
};
*/

///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S K U L L          XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Skull (CFX_BASE_PROTO)
{
     visname_s = "MFX_SKULL_INIT";
     visalpha = 1;
     //visalphablendfunc_s = "ADD";
     emtrjmode_s = "FIXED";
     emtrjoriginnode = "ZS_RIGHTHAND";
     emtrjtargetrange = 20;
     emtrjnumkeys = 4;
     emtrjnumkeysvar = 1;
     emtrjangleelevvar = 0;
     emtrjangleheadvar = 0;
     emtrjeasefunc_s = "LINEAR";
     emtrjeasevel = 100;
     emtrjdynupdatedelay = 20000;
     emFXCreatedOwnTrj = 1;
     emfxlifespan = -1;
     emselfrotvel_s = "0 0 0";
     secsperdamage = -1;
};

		INSTANCE spellFX_Skull_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 			= 0.001;
		};

		INSTANCE spellFX_Skull_KEY_CAST (C_ParticleFXEmitKey)
		{
				emCreateFXID		=  "spellFX_Skull_Skull";
	 			pfx_ppsIsLoopingChg		= 1;
	 			sfxid					= "MFX_Skull_Cast";
	 			sfxisambient			= 1;
};

		
INSTANCE spellFX_Skull_Skull (CFX_BASE_PROTO)
{
     visname_s = "MFX_SKULL_CAST";
     emtrjmode_s = "TARGET SPLINE RANDOM";
     emtrjoriginnode = "ZS_RIGHTHAND";
     emtrjtargetrange = 20;
     emtrjangleelevvar = 15;
     emtrjangleheadvar = 25;
     emtrjnumkeys		= 2;
     emtrjnumkeysvar	= 1;
     emtrjeasefunc_s = "LINEAR";
     emtrjdynupdatedelay = 0.1;
     emtrjdynupdatetargetonly = 1;
     emactioncolldyn_s = "COLLIDE CREATEONCE"; 	//"COLLIDE CREATEONCE";
//     emactioncollstat_s = "COLLIDE CREATEONCE";
     emfxcollstat_s = "spellFX_Skull_COLLIDEFX";
     emfxcolldyn_s = "spellFX_Skull_SPREAD";
     emfxlifespan = -1;
     emselfrotvel_s = "0 0 0";
     secsperdamage = -1;
     
     emtrjeasevel = 700;	 
	};
	
	INSTANCE spellFX_Skull_Skull_KEY_CAST	(C_ParticleFXEmitKey)
	{
		emCheckCollision 		= 1;
		sfxid				= "MFX_Skull_Fly";
	};
	
	

INSTANCE spellFX_Skull_SPREAD	(CFx_Base_Proto)
{
     	visname_S 				= "MFX_SKULL_SPREAD";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	
     	emActionCollStat_S		= "CREATE CREATEQUAD";
     	emActionCollDyn_S 		= "CREATEONCE";
		emFXCollDyn_S     		= "spellFX_Skull_COLLIDEFX";
		
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emCheckCollision		= 1;
		
		sfxid					= "MFX_FIrestorm_Collide";
		sfxisambient			= 1;
};


instance spellFX_Skull_COLLIDEFX		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Skull_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_Skull_Collide";
		lightPresetname   	= "REDAMBIENCE";
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U C K   E N E R G Y     XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_SuckEnergy	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_SUCKENERGY_INIT";
     	
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "PINGPONG_ONCE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S		= "CREATEONCE";
     	//emFXCollDyn_S	   		= "spellFX_Whirlwind_SENDPERCEPTION";
     	emFXCollDynPerc_S	   	= "spellFX_SuckEnergy_SENDPERCEPTION";
     	
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		
		lightPresetname   		= "REDAMBIENCE";

		emFXInvestOrigin_S		= "spellFX_SuckEnergy_Invest";
		
		};

		INSTANCE spellFX_SuckEnergy_KEY_INIT (C_ParticleFXEmitKey)
		{
			lightrange 				= 0.001;
		};

		INSTANCE spellFX_SuckEnergy_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_SUCKENERGY_CAST";
				emtrjmode_s 			= "TARGET";
				emtrjeasevel 			= 800;
	 			lightrange 				= 100;
	 			emCheckCollision 		= 1;
	 			sfxid					= "MFX_SuckEnergy_Cast";
	 			
		};

		INSTANCE spellFX_SuckEnergy_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
		     	pfx_ppsisloopingchg		= 1;
};


instance spellFX_SuckEnergy_Invest		(CFx_Base_Proto)
{
		visname_S 			= "MFX_SUCKENERGY_INVEST";
		emtrjmode_s 		= "FIXED";
};

INSTANCE spellFX_SuckEnergy_SlowTime(CFx_Base_Proto)
{
	// userstring 0: world  time scaler
	// userstring 1: player time scaler
	emFXTriggerDelay	= 6;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
	emFXLifeSpan    	= 30;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
 	visName_S      		= "morph.fov";
 	userString[0]     	= "0.8";
 	userString[1]     	= "1.0";
 	userString[2]		= "120";
 	userString[3]		= "90";
};


instance spellFX_SuckEnergy_BloodFly (CFx_Base_Proto)
{
	visname_S 			= "MFX_SUCKENERGY_FLYTOPLAYER";

	emtrjeasevel 		= 0.01;
	emtrjmode_s 		= "TARGET LINE";
	emTrjOriginNode 	= "Bip01 Spine2";
	emTrjTargetNode 	= "ZS_RIGHTHAND";
	emtrjdynupdatedelay = 0.01;
};

instance spellFX_SuckEnergy_SENDPERCEPTION(CFx_Base_Proto)
{
		visname_S 			= "MFX_SUCKENERGY_TARGET";
		sendAssessMagic		= 1;
		sfxid				= "MFX_SuckEnergy_Target";
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  E N E R G Y B A L L       XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Energyball	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Energyball_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S		= "COLLIDE CREATEONCE";
     	emFXCollDyn_S	   		= "spellFX_Energyball_TARGET";
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		
		lightPresetname   		= "REDAMBIENCE";

		};

		INSTANCE spellFX_Energyball_KEY_INIT (C_ParticleFXEmitKey)
		{
			lightrange 				= 0.001;
		};

		INSTANCE spellFX_Energyball_KEY_INVEST (C_ParticleFXEmitKey)
		{
			lightrange 				= 100;
		};


		INSTANCE spellFX_Energyball_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_ENERGYBALL_CAST";
				emtrjmode_s 			= "TARGET";
				emtrjeasevel 			= 900;
		     	sfxid					= "MFX_Thunderball_Collide3";
	 			lightrange 				= 100;
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Energyball_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};
instance spellFX_Energyball_TARGET	(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "MFX_ENERGYBALL_TARGET";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	sendAssessMagic		= 1;
	
	sfxid				= "MFX_Lightning_ORIGIN";
	sfxisambient		= 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  I C E L A N C E    XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Icelance	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Icelance_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S		= "COLLIDE CREATEONCE";
     	emFXCollStat_S	   		= "spellFX_Icelance_COLLIDEFX";
     	emFXCollDyn_S	   		= "spellFX_Icelance_COLLIDEFX";
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emFXCreatedOwnTrj		= 0;
	 			
		
		lightPresetname   		= "AURA";

		};

		INSTANCE spellFX_Icelance_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				lightrange = 0.001;
		};

		INSTANCE spellFX_Icelance_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 			= 0.001;
		};

		INSTANCE spellFX_Icelance_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_Icelance_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			lightrange 				= 100;
	 			emCheckCollision 		= 1;
	 			sfxid					= "MFX_Icelance_Cast";
	 			//emCreateFXID			=  "spellFX_InvisibleProjectile";
		};

		INSTANCE spellFX_Icelance_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	visname_S 				= "";
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_Icelance_COLLIDEFX		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Icelance_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FOLLOW TARGET";
		lightPresetname   	= "FIRESMALL";
		sfxid				= "MFX_Icelance_Collide";
};

/*instance spellFX_Icelance_COLLIDEFX		(CFx_Base_Proto)
{
		visname_S 			= "TENTACLE01_MESH.MMS";
		emTrjOriginNode 	= "BIP01";
     	visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};*/

///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  W A T E R F I S T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE SPELLFX_WATERFIST (CFX_BASE_PROTO)
{
     visname_s = "MFX_WATERFIST_INIT";
     visalpha = 1;
     //visalphablendfunc_s = "ADD";
     emtrjmode_s = "FIXED";
     emtrjoriginnode = "ZS_RIGHTHAND";
     emtrjtargetrange = 50;
     emtrjnumkeys = 4;
     emtrjnumkeysvar = 1;
     emtrjangleelevvar = 0;
     emtrjangleheadvar = 0;
     emtrjeasefunc_s = "LINEAR";
     emtrjeasevel = 100;
     emtrjdynupdatedelay = 20000;
     emFXCreatedOwnTrj = 1;
     //emactioncolldyn_s = "COLLIDE CREATEONCE";
     //emactioncollstat_s = "COLLIDE CREATE";
     //emfxcollstat_s = "SPELLFX_WATERFIST_COLLIDEFX";
     //emfxcolldyn_s = "SPELLFX_WATERFIST_COLLIDEDYNFX";
     emfxlifespan = -1;
     emselfrotvel_s = "0 0 0";
     secsperdamage = -1;
};

		INSTANCE spellFX_Waterfist_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				lightrange = 0.001;
		};

		INSTANCE spellFX_Waterfist_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Waterfist_INIT";
				lightrange 			= 0.001;
		};

		INSTANCE spellFX_Waterfist_KEY_CAST (C_ParticleFXEmitKey)
		{
				emCreateFXID		=  "spellfx_waterfist_Abyss";
	 			pfx_ppsIsLoopingChg		= 1;
};

		

instance spellFX_Waterfist_COLLIDEFX		(CFx_Base_Proto)
{
		visname_S 			= "MFX_waterfist_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
		
		sfxid				= "MFX_Waterfist_Collide";
		sfxisambient		= 1;
};

instance spellFX_Waterfist_COLLIDEDYNFX  (CFx_Base_Proto)
{
		visname_S 			= "MFX_waterfist_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
		
		sfxid				= "MFX_Waterfist_Collide";
		sfxisambient		= 1;
};

INSTANCE SPELLFX_WATERFIST_ABYSS (CFX_BASE_PROTO)
{
     visname_s = "MFX_WATERFIST_CAST";
     visalpha = 1;
     visalphablendfunc_s = "ADD";
     emtrjmode_s = "TARGET SPLINE RANDOM";
     emtrjoriginnode = "ZS_RIGHTHAND";
     //emtrjtargetrange = 20;
     emtrjnumkeys = 4;
     emtrjnumkeysvar = 2;
     emtrjangleelevvar = 5;
     emtrjangleheadvar = 10;
     emtrjloopmode_s = "NONE";
     emtrjeasefunc_s = "LINEAR";
     emtrjeasevel = 900;
     emtrjdynupdatedelay = 0.1;
     emtrjdynupdatetargetonly = 1;
     emactioncolldyn_s = "COLLIDE CREATEONCE";
     emactioncollstat_s = "COLLIDE CREATE";
     emfxcollstat_s = "SPELLFX_WATERFIST_COLLIDEFX";
     emfxcolldyn_s = "SPELLFX_WATERFIST_COLLIDEDYNFX";
     emfxlifespan = -1;
     emselfrotvel_s = "0 0 0";
     secsperdamage = -1;
};
		
		INSTANCE spellFX_Waterfist_Abyss_KEY_CAST (C_ParticleFXEmitKey)
		{
				emCheckCollision 		= 1;
				sfxid					= "MFX_Waterfist_Cast";
		};

		INSTANCE spellFX_Waterfist_Abyss_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	visname_S 				= "";
		     	emtrjeasevel 			= 0.000001;
};





///   													XXXXXXXXXXXXXXXXX
///   													XX  S W A R M  XX
///   													XXXXXXXXXXXXXXXXX


INSTANCE spellFX_Swarm	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_SWARM_INIT";
     	
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	
     	emtrjangleelevvar 	= 15;
     	emtrjangleheadvar 	= 25;
     	emtrjnumkeys		= 2;
     	emtrjnumkeysvar		= 1;
     
     	emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S		= "CREATEONCE";
     	emFXCollDynPerc_S	   	= "spellFX_Whirlwind_SENDPERCEPTION";
     	
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		
		};

		INSTANCE spellFX_Swarm_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_SWARM_CAST";
     	
				emtrjmode_s 			= "TARGET";
				emtrjeasevel 			= 500;
	 			emCheckCollision 		= 1;
	 			sfxid					= "MFX_Swarm_Cast";
		};

		INSTANCE spellFX_Swarm_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
		     	pfx_ppsisloopingchg		= 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  G R E E N T E N T A C L E  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Greententacle	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_GREENTENTACLE_INIT";
     	
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	
     	};

		INSTANCE spellFX_Greententacle_KEY_CAST (C_ParticleFXEmitKey)
		{
				
				emCreateFXID			= "spellFX_Greententacle_Bridge";
				
				emtrjeasevel 			= 0.000001;
		     	pfx_ppsisloopingchg		= 1;
		     	
				
				emtrjmode_s 			= "TARGET SPLINE RANDOM";
				emtrjeasevel 			= 500;
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Greententacle_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	
};

INSTANCE spellFX_Greententacle_Bridge (CFX_BASE_PROTO)
{
     visname_S 		= "MFX_GREENTENTACLE_CAST";
     visalpha		= 1;
     visalphablendfunc_s = "ADD";
     emtrjmode_s = "TARGET SPLINE RANDOM";
     emtrjoriginnode = "ZS_RIGHTHAND";
     //emtrjtargetrange = 20;
     emtrjnumkeys = 4;
     emtrjnumkeysvar = 2;
     emtrjangleelevvar = 5;
     emtrjangleheadvar = 10;
     emtrjloopmode_s = "NONE";
     emtrjeasefunc_s = "LINEAR";
     emtrjeasevel = 900;
     emtrjdynupdatedelay = 0.1;
     emtrjdynupdatetargetonly = 1;
     emactioncolldyn_s = "COLLIDE CREATEONCE";
     emactioncollstat_s = "COLLIDE";
     emfxcolldynPerc_s = "SPELLFX_Greententacle_Target";
     emfxlifespan = -1;
     emselfrotvel_s = "0 0 0";
     secsperdamage = -1;
};
		
		INSTANCE spellFX_Greententacle_Bridge_KEY_CAST (C_ParticleFXEmitKey)
		{
				emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Greententacle_Bridge_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	visname_S 				= "";
		     	emtrjeasevel 			= 0.000001;
};


instance SpellFX_Greententacle_TARGET(CFx_Base_Proto)
{
		emTrjOriginNode 	= "BIP01";
     	visname_S 			= "MFX_Greententacle_Target";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_Greententacle_Grow";
		sendAssessMagic		= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  G E Y S E R      XX
///   													XXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Geyser (CFx_Base_Proto)
{

     	visname_S 				= "MFX_GEYSER_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S		= "COLLIDE CREATEONCE";
     	emFXCollDyn_S	   		= "spellFX_Geyser_FOUNTAIN";
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		

		lightPresetname   		= "AURA";

		};

		INSTANCE spellFX_Geyser_KEY_INIT (C_ParticleFXEmitKey)
		{
			lightrange 				= 0.001;
		};

		INSTANCE spellFX_Geyser_KEY_INVEST (C_ParticleFXEmitKey)
		{
			lightrange 				= 100;
			emCreateFXID			= "spellFX_Geyser_Rumble";
				
		};


		INSTANCE spellFX_Geyser_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_GEYSER_CAST";
				emtrjmode_s 			= "TARGET";
				emtrjeasevel 			= 1000;
		     	lightrange 				= 100;
	 			emCheckCollision 		= 1;
	 			sfxid					= "MFX_Geyser_Rumble";
				sfxisambient			= 1;
		};

		INSTANCE spellFX_Geyser_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_Geyser_FOUNTAIN	(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "MFX_GEYSER_FOUNTAIN";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	//sendAssessMagic		= 1;

	sfxid				= "MFX_Geyser_Fountain";
	sfxisambient		= 1;
};

instance spellFX_Geyser_RUMBLE	(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	
	sfxid				= "MFX_Geyser_Rumble";
	sfxisambient		= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  W H I R L W I N D    XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXX





INSTANCE spellFX_Whirlwind	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_WHIRLWIND_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		//emFXCollStat_S	   		= "spellFX_Whirlwind_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Whirlwind_TARGET";
		emFXCollDynPerc_S     	= "spellFX_Whirlwind_SENDPERCEPTION";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		

		emFXInvestOrigin_S		= "spellFX_Whirlwind_Invest";
		//visAlpha				= 0;

		};

		INSTANCE spellFX_Whirlwind_KEY_OPEN(C_ParticleFXEmitKey)
		{
				Lightrange				= 0.01;
		};

		INSTANCE spellFX_Whirlwind_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_WHIRLWIND_INIT";
				Lightrange				= 0.01;
				scaleDuration			= 0.5;
		};
		
		INSTANCE spellFX_Whirlwind_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_WHIRLWIND_GROW";
				//emCreateFXID			= "spellFX_Whirlwind_Invest";
				Lightrange				= 0.01;
				pfx_visAlphaStart		= 100;
		};


		INSTANCE spellFX_Whirlwind_KEY_CAST (C_ParticleFXEmitKey)
		{
				pfx_visAlphaStart		= 150;
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 400.;
	 			emCheckCollision		= 1;
	 			Lightrange				= 100;
	 			sfxid					= "MFX_Windfist_Cast";
				sfxisambient			= 1;

		};

		INSTANCE spellFX_Whirlwind_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
		     	pfx_ppsIsLoopingChg		= 1;
				//emCheckCollision		= 0;
};

instance spellFX_Whirlwind_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ICESPELL_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_ICECUBE_COLLIDE";
};

instance spellFX_Whirlwind_Invest		(CFx_Base_Proto)
{
		//visname_S 			= "MFX_WHIRLWIND_ORIGIN";
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_WHIRLWIND_INVEST";
		sfxisambient		= 1;
};


instance spellFX_Whirlwind_Sound		(CFx_Base_Proto)
{
		visname_S 			= "";
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_WHIRLWIND_INVEST";
		sfxisambient		= 1;
};


// HUMAN oder VOB ist gefangen in einer WindHose

instance spellFX_Whirlwind_TARGET(CFx_Base_Proto)
{
		emTrjOriginNode 	= "BIP01";
     	visname_S 			= "MFX_Whirlwind_Target";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		//sendAssessMagic		= 1;
		sfxid				= "MFX_Whirlwind_Target";
		sfxisambient		= 1;
};

instance spellFX_Whirlwind_SENDPERCEPTION(CFx_Base_Proto)
{
		visname_S 			= "";
		sendAssessMagic		= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  I N V O C A T I O N  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_INCOVATION_RED (CFx_Base_Proto)
{
		visname_S 			= "INVOCATION_RED";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		lightpresetname		= "REDAMBIENCE";
    	sfxid				= "SFX_Circle";
     	sfxisambient		= 1;
};

INSTANCE spellFX_INCOVATION_GREEN (CFx_Base_Proto)
{
		visname_S 			= "INVOCATION_GREEN";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		lightpresetname		= "POISON";
    	sfxid				= "SFX_Circle";
     	sfxisambient		= 1;
};

INSTANCE spellFX_INCOVATION_BLUE (CFx_Base_Proto)
{
		visname_S 			= "INVOCATION_BLUE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		lightpresetname		= "REDAMBIENCE";
    	sfxid				= "SFX_Circle";
     	sfxisambient		= 1;
};

INSTANCE spellFX_INCOVATION_VIOLET (CFx_Base_Proto)
{
		visname_S 			= "INVOCATION_VIOLET";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		lightpresetname		= "CATACLYSM";
    	sfxid				= "SFX_Circle";
     	sfxisambient		= 1;
};

INSTANCE spellFX_INCOVATION_WHITE (CFx_Base_Proto)
{
		visname_S 			= "INVOCATION_WHITE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		lightpresetname		= "WHITEBLEND";
    	sfxid				= "SFX_Circle";
     	sfxisambient		= 1;
};
///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  L I G H T S T A R  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_LIGHTSTAR_VIOLET (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_VIOLET";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};

INSTANCE spellFX_LIGHTSTAR_WHITE (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_WHITE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};

INSTANCE spellFX_LIGHTSTAR_BLUE (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_BLUE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};
INSTANCE spellFX_LIGHTSTAR_RED (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_RED";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};
INSTANCE spellFX_LIGHTSTAR_GREEN (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_GREEN";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};
INSTANCE spellFX_LIGHTSTAR_ORANGE (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_ORANGE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX Innosauge anlegen   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_Innoseye	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Innoseye";
		emTrjOriginNode 	= "BIP01";
		visAlpha			= 1;
	   // emFXCreate_S	 	= "spellFX_PalHeal_START";
		emtrjmode_s 		= "FIXED";
		LightPresetname		= "REDAMBIENCE";
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX Schreine helen	   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_HealShrine	(CFx_Base_Proto)
{
		visname_S 			= "MFX_HealShrine";
		emTrjOriginNode 	= "BIP01";
		visAlpha			= 1;
	   // emFXCreate_S	 	= "spellFX_PalHeal_START";
		emtrjmode_s 		= "FIXED";
		LightPresetname		= "WHITEBLEND";
};

///   													XXXXXXXXXXXXXXXXX
///   													XX RingRitual  XX
///   													XXXXXXXXXXXXXXXXX
instance spellFX_RingRitual1	(CFx_Base_Proto) //ADDON
{
     	visname_S 				= "MFX_Firestorm_SPREAD_SMALL";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "CREATE CREATEQUAD";
     	//emActionCollDyn_S 		= "CREATEONCE";
		//emFXCollStat_S	   	= "spellFX_Firestorm_COLLIDE";		// [Edenfeld] Wenn einkommentiert, erzeugt sehr viele VFX -> nicht sichtbar/Performance Probs.
		emFXCollDyn_S     		= "spellFX_ChargeFireball_COLLIDEDYNFX";
		//emFXCollDynPerc_S     	= "vob_magicburn";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emCheckCollision		= 1;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "40 40";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		emFXCreate_S			= "spellFX_Firestorm_COLLIDE";

		sfxid					= "MFX_FIrestorm_Collide";
		sfxisambient			= 1;
		};

		INSTANCE spellFX_RingRitual1_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 				= 0.001;
		};

		INSTANCE spellFX_RingRitual1_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange 				= 150;
		};
		
instance spellFX_RingRitual2	(CFx_Base_Proto) //ADDON
{
		visname_S 			= "MFX_RINGRITUAL2";
		emTrjOriginNode 	= "BIP01";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		//lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_LIGHTSTAR_RingRitual (CFx_Base_Proto)
{
		visname_S 			= "LIGHTSTAR_ORANGE";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
    	sfxid				= "MFX_Firerain_Invest";
		sfxisambient		= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXX
///   													XX ItemAusbuddeln  XX
///   													XXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_ItemAusbuddeln	(CFx_Base_Proto)
{
		visname_S 			= "";
		visAlpha			= 1;
		emtrjmode_s 		= "FOLLOW TARGET";
     	emtrjeasevel 		= 0.;
     	emTrjOriginNode 	= "BIP01 Head";
		emtrjloopmode_s 	= "NONE";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.4;
		emTrjTargetRange	= 1.2;
		emTrjTargetElev 	= 89;
		lightPresetname 	= "JUSTWHITE";

		};

		INSTANCE spellFX_ItemAusbuddeln_KEY_OPEN (C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_ItemAusbuddeln_KEY_INIT(C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_ItemAusbuddeln_KEY_CAST 	(C_ParticleFXEmitKey)
		{
				visName_S		= "MFX_Light_ORIGIN";
				lightRange		= 1000;
				sfxid			= "MFX_Light_CAST";
				sfxisambient	= 1;
				emtrjeasevel 	= 1400.;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX BeliarsWeapon  Upgrate  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_BeliarsWeapon_Upgrate  (CFx_Base_Proto)
{
		visname_S			= "MFX_ArmyOfDarkness_Origin";
		lightPresetName 	= "JUSTWHITE";
		emtrjmode_s 		= "FIXED";
     	emTrjOriginNode 	= "BIP01";
};
///   													XXXXXXXXXXXXXXXXXXXXX
///   													XX MayaGhost	  XX
///   													XXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Maya_Ghost (CFx_Base_Proto)
{
		visname_S			= "CS_FOKUS1";
		lightPresetName 	= "JUSTWHITE";
		emtrjmode_s 		= "FIXED";
     	emTrjOriginNode 	= "BIP01";
};
///   													XXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX Beliars BlitzinArsch	  XXd
///   													XXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_BELIARSRAGE	(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "MFX_BELIARSRAGE_FLASH";
	visAlpha			= 1;
	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	emFXCreate_S	 	= "spellFX_BELIARSRAGE_target_Cloud";
	lightPresetName 	= "JUSTWHITE";
	sfxid				= "MFX_Barriere_Shoot";
	sfxisambient		= 1;
};
instance spellFX_BELIARSRAGE_target_Cloud (CFx_Base_Proto)
{
	visname_S 			= "MFX_BELIARSRAGE_TARGET";
	visAlpha			= 1;
	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "ZS_RIGHTHAND";
	emtrjdynupdatedelay = 0.01;
};
instance spellFX_BELIARSRAGE_COLLIDE		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_Collide1";
		visAlpha				= 1;
		emTrjOriginNode			= "ZS_RIGHTHAND";
		emtrjmode_s 			= "FIXED";
		lightPresetname   		= "FIRESMALL";
		sfxid					= "MFX_BeliarWeap";
		sfxisambient			= 1;
};


///   													XXXXXXXXXXXXXXXXX
///   													XX  L I G H T  XX
///   													XXXXXXXXXXXXXXXXX

// [EDENFELD] Die spellFX_Light_ACTIVE Instanz muss als Child mit eigener Trajectory an die Haupt spellFX_Light Instanz
// geh�ngt werden, und darf erst beim Casten ein Visual bekommen.
// nur so kann getestet werden, ob ein etwaiges gecastetes Licht noch aktiv ist. Vorher wurde die spellFX_Light_ACTIVE
// Instanz �ber die emCreateFXID Variable getriggert. Die so erzeugten Effekte haben dann aber keinen Bezug mehr zum Licht Spell.





INSTANCE spellFX_Light(CFx_Base_Proto)
{
		visname_S 			= "MFX_Light_INIT";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emFXCreate_S 		= "spellFX_Light_ACTIVE";
		emFXCreatedOwnTrj 	= 1;

		};

		INSTANCE spellFX_Light_KEY_CAST (C_ParticleFXEmitKey)
		{
				pfx_ppsIsLoopingChg = 1;


};


INSTANCE spellFX_Light_ACTIVE	(CFx_Base_Proto)
{
		visname_S 			= "";
		visAlpha			= 1;
		emtrjmode_s 		= "FOLLOW TARGET";
     	emtrjeasevel 		= 0.;
     	emTrjOriginNode 	= "BIP01 Head";
		emtrjloopmode_s 	= "HALT";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.4;
		emTrjTargetRange	= 1.2;
		emTrjTargetElev 	= 89;
		lightPresetname 	= "JUSTWHITE";
		
		};

		INSTANCE spellFX_Light_ACTIVE_KEY_OPEN (C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_Light_ACTIVE_KEY_INIT(C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_Light_ACTIVE_KEY_CAST 	(C_ParticleFXEmitKey)
		{
				visName_S		= "MFX_Light_ORIGIN";
				lightRange		= 1000;
				sfxid			= "MFX_Light_CAST";
				sfxisambient	= 1;
				emtrjeasevel 	= 1400.;
				
};



///   													XXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  P A L  L I G H T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_PalLight(CFx_Base_Proto)
{
		visname_S 			= "MFX_PalLight_INIT";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emFXCreate_S 		= "spellFX_PalLight_ACTIVE";
		emFXCreatedOwnTrj 	= 1;

		};

		INSTANCE spellFX_PalLight_KEY_CAST (C_ParticleFXEmitKey)
		{
				pfx_ppsIsLoopingChg = 1;


};


INSTANCE spellFX_PalLight_ACTIVE	(CFx_Base_Proto)
{
		visname_S 			= "";
		visAlpha			= 1;
		emtrjmode_s 		= "FOLLOW TARGET";
     	emtrjeasevel 		= 0.;
     	emTrjOriginNode 	= "BIP01 Head";
		emtrjloopmode_s 	= "HALT";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.4;
		emTrjTargetRange	= 1.2;
		emTrjTargetElev 	= 89;
		lightPresetname 	= "AURA";

		};

		INSTANCE spellFX_PalLight_ACTIVE_KEY_OPEN (C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_PalLight_ACTIVE_KEY_INIT(C_ParticleFXEmitKey)
		{
			lightRange 		= 0.01;
		};

		INSTANCE spellFX_PalLight_ACTIVE_KEY_CAST 	(C_ParticleFXEmitKey)
		{
				visName_S		= "MFX_PalLight_ORIGIN";
				lightRange		= 1000;
				sfxid			= "MFX_Light_CAST";
				sfxisambient	= 1;
				emtrjeasevel 	= 1400.;
};


///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E B O L T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Firebolt	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Firebolt_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollStat_S		= "COLLIDE CREATE CREATEQUAD";
     	emActionCollDyn_S		= "COLLIDE CREATEONCE";
     	emFXCollStat_S	   		= "spellFX_Firebolt_COLLIDEFX";
     	emFXCollDyn_S	   		= "spellFX_Firebolt_COLLIDEDYNFX";
     	emFXCollDynPerc_S	   	= "VOB_MAGICBURN";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		lightPresetname   		= "FIRESMALL";

		// quadmark
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "40 40";
		userString[2]			= "MUL";


		};

		INSTANCE spellFX_Firebolt_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				lightrange = 0.001;
		};

		INSTANCE spellFX_Firebolt_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Firebolt_INIT";
				lightrange 			= 0.001;
		};

		INSTANCE spellFX_Firebolt_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "mfx_firebolt_cast";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "Torch_Enlight";
	 			lightrange 				= 100;
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Firebolt_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	visname_S 				= "";
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
	 			sfxid		  			= "TORCH_ENLIGHT";
};

instance spellFX_Firebolt_COLLIDEFX		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Firebolt_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};

instance spellFX_Firebolt_COLLIDEDYNFX  (CFx_Base_Proto)
{
		visname_S 			= "MFX_Firebolt_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};


///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E B A L L  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX     CHARGE		 XX
///   													XXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_ChargeFireball(CFx_Base_Proto)
{

     	visname_S 				= "MFX_ChargeFB_CAST";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_ChargeFireball_COLLIDE";
		emFXCollDyn_S     		= "spellFX_ChargeFireball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "vob_magicburn";
		emFXCollStatAlign_S		= "COLLISIONNORMAL";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 30.000;

		lightPresetname   		= "FIRESMALL";

		};

		INSTANCE spellFX_ChargeFireball_KEY_OPEN (C_ParticleFXEmitKey)
		{
				lightrange		= 0.01;
		};


		INSTANCE spellFX_ChargeFireball_KEY_INIT (C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_ChargeFB_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_ChargeFireball_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
				emCreateFXID	= "spellFX_ChargeFireball_InVEST_BLAST1";
				visname_s		= "MFX_ChargeFB_CAST_L2";
				lightrange		= 150;
				sfxid			= "MFX_Fireball_invest1";
				sfxisambient	= 1;
		}								;
		INSTANCE spellFX_ChargeFireball_KEY_INVEST_2 (C_ParticleFXEmitKey)
		{
				emCreateFXID	= "spellFX_ChargeFireball_InVEST_BLAST2";
				visname_s		= "MFX_ChargeFB_CAST_L3";
				sfxid			= "MFX_Fireball_invest2";
				sfxisambient	= 1;
		};
		INSTANCE spellFX_ChargeFireball_KEY_INVEST_3 (C_ParticleFXEmitKey)
		{
				emCreateFXID	= "spellFX_ChargeFireball_InVEST_BLAST3";
				visname_s		= "MFX_ChargeFB_CAST_L4";
				sfxid			= "MFX_Fireball_invest3";
				sfxisambient	= 1;
		};
		INSTANCE spellFX_ChargeFireball_KEY_INVEST_4 (C_ParticleFXEmitKey)
		{
				emCreateFXID	= "spellFX_ChargeFireball_InVEST_BLAST4";
				visname_s		= "MFX_ChargeFB_CAST_L5";
				sfxid			= "MFX_Fireball_invest4";
				sfxisambient	= 1;
		};
		INSTANCE spellFX_ChargeFireBall_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange				= 100;
				//pfx_ppsIsLoopingChg 	= 1;
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Fireball_Cast";
	 			sfxisambient			= 1;
	 			emCheckCollision 		= 1;
		};
		INSTANCE spellFX_ChargeFireBall_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_ChargeFireball_InVEST_BLAST1		(CFx_Base_Proto)
{
		visname_S 		= "MFX_ChargeFB_INVESTBLAST";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest1";
		sfxisambient	= 1;
		visAlpha 		= 0.3;
};

instance spellFX_ChargeFireball_InVEST_BLAST2	(CFx_Base_Proto)
{
		visname_S 		= "MFX_ChargeFB_INVESTBLAST";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest2";
		sfxisambient	= 1;
		visAlpha 		= 0.5;
};

instance spellFX_ChargeFireball_InVEST_BLAST3		(CFx_Base_Proto)
{
		visname_S 		= "MFX_ChargeFB_INVESTBLAST";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest3";
		sfxisambient	= 1;
		visAlpha 		= 0.8;
};

instance spellFX_ChargeFireball_InVEST_BLAST4		(CFx_Base_Proto)
{
		visname_S 		= "MFX_ChargeFB_INVESTBLAST";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest4";
		sfxisambient	= 1;
		visAlpha 		= 1;
};

// KOLLISION MIT STATISCHER WELT:  KEINE PERCEPTION

instance spellFX_ChargeFireball_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ChargeFB_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode		= "BIP01";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_ChargeFireball_COLLIDE_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide";		sfxid	= "MFX_Fireball_Collide1";		};
INSTANCE spellFX_ChargeFireball_COLLIDE_KEY_INVEST_2	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide";		sfxid	= "MFX_Fireball_Collide2";		};
INSTANCE spellFX_ChargeFireball_COLLIDE_KEY_INVEST_3	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide";		sfxid	= "MFX_Fireball_Collide3";		};
INSTANCE spellFX_ChargeFireball_COLLIDE_KEY_INVEST_4	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide";		sfxid	= "MFX_Fireball_Collide4";		};

instance spellFX_ChargeFireball_COLLIDEDYNFX (CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emTrjOriginNode		= "BIP01";
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_ChargeFireball_COLLIDEDYNFX_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};
INSTANCE spellFX_ChargeFireball_COLLIDEDYNFX_KEY_INVEST_2	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide2";		sfxid	= "MFX_Fireball_Collide2";		};
INSTANCE spellFX_ChargeFireball_COLLIDEDYNFX_KEY_INVEST_3	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide3";		sfxid	= "MFX_Fireball_Collide3";		};
INSTANCE spellFX_ChargeFireball_COLLIDEDYNFX_KEY_INVEST_4	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide4";		sfxid	= "MFX_Fireball_Collide4";		};

///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E B A L L  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX     INSTANT		 XX
///   													XXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_InstantFireball(CFx_Base_Proto)
{
     	visname_S 				= "MFX_Fireball_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_InstantFireball_COLLIDE";
		emFXCollDyn_S     		= "spellFX_InstantFireball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "VOB_MAGICBURN";
		emFXCollStatAlign_S		= "COLLISIONNORMAL";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay	= 20000;
		//emTrjDynUpdateDelay		= 0.4;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		};

		INSTANCE spellFX_InstantFireball_KEY_OPEN (C_ParticleFXEmitKey)
		{
				lightrange		= 0.01;
		};


		INSTANCE spellFX_InstantFireball_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Fireball_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_InstantFireBall_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange				= 100;
				visname_S 				= "MFX_IFB_PFXTRAIL";
				emtrjmode_s 			= "TARGET";
		     	emSelfRotVel_S			= "100 100 100";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Fireball_Cast";
	 			sfxisambient			= 1;
	 			emCreateFXID			= "spellFX_InstantFireball_FIRECLOUD";
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_InstantFireBall_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_InstantFireball_FIRECLOUD		(CFx_Base_Proto)
{
		emtrjeasevel 	= 1400.;
		visname_S 		= "MFX_IFB_CAST";
		visAlpha		= 1;
		emtrjmode_s 	= "TARGET";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
		emTrjDynUpdateDelay	= 20000;
     	emCheckCollision 		= 2;					// [EDENFELD, neu] 2: Coll, aber keinen Schaden abziehen (n�tig, da dieser FX nicht als Child eingef�gt wurde, sondern komplett
     													// unabh�ngig mit Coll in die Welt gesetzt wurde. Der Schaden wird aber schon von spellFX_InstantFireball berechnet.)
		emActionCollDyn_S 		= "COLLIDE";
		emActionCollStat_S 		= "COLLIDE";
		};

		INSTANCE spellFX_InstantFireBall_FIRECLOUD_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};

// KOLLISION MIT STATISCHER WELT:  KEINE PERCEPTION

instance spellFX_InstantFireball_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode		= "BIP01";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_InstantFireball_COLLIDE_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};

// KOLLISION MIT DYNAMISCHER WELT:  WOHL PERCEPTION

instance spellFX_InstantFireball_COLLIDEDYNFX	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emTrjOriginNode		= "BIP01";
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_InstantFireball_COLLIDEDYNFX_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};


///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E S T O R M  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Firestorm	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_FireStorm_Init";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Firestorm_SPREAD";
		emFXCollDyn_S     		= "spellFX_Firestorm_SPREAD";
		emFXCollDynPerc_S     	= "vob_magicburn";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emFXInvestORIGIN_S 		= "spellFX_Firestorm_INVESTSOUND";

		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";

		lightPresetname   		= "FIRESMALL";
		};

		INSTANCE spellFX_Firestorm_KEY_OPEN(C_ParticleFXEmitKey)
		{
				lightrange			= 0.01;
		};

		INSTANCE spellFX_Firestorm_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange			= 0.01;
		};

		INSTANCE spellFX_Firestorm_KEY_INVEST_1	(C_ParticleFXEmitKey)	{	lightrange	= 100;	emCreateFXID	= "spellFX_Firestorm_INVESTBLAST1";	};
		INSTANCE spellFX_Firestorm_KEY_INVEST_2	(C_ParticleFXEmitKey)	{	lightrange	= 150;	emCreateFXID	= "spellFX_Firestorm_INVESTBLAST2";	};
		INSTANCE spellFX_Firestorm_KEY_INVEST_3	(C_ParticleFXEmitKey)	{	lightrange	= 200;	emCreateFXID	= "spellFX_Firestorm_INVESTBLAST3";	};
		INSTANCE spellFX_Firestorm_KEY_INVEST_4	(C_ParticleFXEmitKey)	{	lightrange	= 250;	emCreateFXID	= "spellFX_Firestorm_INVESTBLAST4";	};

		INSTANCE spellFX_Firestorm_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_Firestorm_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Firestorm_Cast";
	 			sfxisambient			= 1;
				emCheckCollision 		= 1;
				lightrange				= 100;
		};

		INSTANCE spellFX_Firestorm_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};


INSTANCE spellFX_FireStorm_INVESTSOUND	(CFX_Base_Proto)
{
		visname_s		= "simpleglow.tga";
		visalpha		= 0.01;
		sfxid			= "MFX_Firestorm_Invest";
		sfxisambient	= 1;
};


INSTANCE spellFX_FireStorm_INVESTBLAST1	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST1";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest1";
		sfxisambient	= 1;
};

INSTANCE spellFX_FireStorm_INVESTBLAST2	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST2";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest2";
		sfxisambient	= 1;
};

INSTANCE spellFX_FireStorm_INVESTBLAST3	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST3";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest3";
		sfxisambient	= 1;
};

INSTANCE spellFX_FireStorm_INVESTBLAST4	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST4";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest4";
		sfxisambient	= 1;
};


INSTANCE spellFX_Firestorm_SPREAD	(CFx_Base_Proto)
{
     	visname_S 				= "MFX_Firestorm_SPREAD_SMALL";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "CREATE CREATEQUAD";
     	emActionCollDyn_S 		= "CREATEONCE";
		//emFXCollStat_S	   	= "spellFX_Firestorm_COLLIDE";		// [Edenfeld] Wenn einkommentiert, erzeugt sehr viele VFX -> nicht sichtbar/Performance Probs.
		emFXCollDyn_S     		= "spellFX_ChargeFireball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "vob_magicburn";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emCheckCollision		= 1;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "40 40";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		emFXCreate_S			= "spellFX_Firestorm_COLLIDE";

		sfxid					= "MFX_FIrestorm_Collide";
		sfxisambient			= 1;
		};

		INSTANCE spellFX_Firestorm_SPREAD_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 				= 0.001;
		};

		INSTANCE spellFX_Firestorm_SPREAD_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange 				= 150;
};



instance spellFX_Firestorm_COLLIDE		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Fireball_Collide3";
		visAlpha				= 1;
		emtrjmode_s 			= "FIXED";
		sfxid					= "MFX_Fireball_Collide3";
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  P Y R O K I N E S I S  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Pyrokinesis (CFx_Base_Proto)
{

     	visname_S 				= "MFX_FireStorm_Init";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Pyrokinesis_SPREAD";
		emFXCollDyn_S     		= "spellFX_Pyrokinesis_SPREAD";
		emFXCollDynPerc_S     	= "vob_magicburn";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emFXInvestORIGIN_S 		= "spellFX_Pyrokinesis_INVESTSOUND";

		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";

		lightPresetname   		= "FIRESMALL";
		};

		INSTANCE spellFX_Pyrokinesis_KEY_OPEN(C_ParticleFXEmitKey)
		{
				lightrange			= 0.01;
		};

		INSTANCE spellFX_Pyrokinesis_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange			= 0.01;
		};

		INSTANCE spellFX_Pyrokinesis_KEY_INVEST_1	(C_ParticleFXEmitKey)	{	lightrange	= 100;	emCreateFXID	= "spellFX_Pyrokinesis_INVESTBLAST1";	};
		INSTANCE spellFX_Pyrokinesis_KEY_INVEST_2	(C_ParticleFXEmitKey)	{	lightrange	= 150;	emCreateFXID	= "spellFX_Pyrokinesis_INVESTBLAST2";	};
		INSTANCE spellFX_Pyrokinesis_KEY_INVEST_3	(C_ParticleFXEmitKey)	{	lightrange	= 200;	emCreateFXID	= "spellFX_Pyrokinesis_INVESTBLAST3";	};
		INSTANCE spellFX_Pyrokinesis_KEY_INVEST_4	(C_ParticleFXEmitKey)	{	lightrange	= 250;	emCreateFXID	= "spellFX_Pyrokinesis_INVESTBLAST4";	};

		INSTANCE spellFX_Pyrokinesis_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_Firestorm_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Firestorm_Cast";
	 			sfxisambient			= 1;
				emCheckCollision 		= 1;
				lightrange				= 150;
		};

		INSTANCE spellFX_Pyrokinesis_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};


INSTANCE spellFX_Pyrokinesis_INVESTSOUND	(CFX_Base_Proto)
{
		visname_s		= "simpleglow.tga";
		visalpha		= 0.01;
		sfxid			= "MFX_Firestorm_Invest";
		sfxisambient	= 1;
};


INSTANCE spellFX_Pyrokinesis_INVESTBLAST1	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST1";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest1";
		sfxisambient	= 1;
};

INSTANCE spellFX_Pyrokinesis_INVESTBLAST2	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST2";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest2";
		sfxisambient	= 1;
};

INSTANCE spellFX_Pyrokinesis_INVESTBLAST3	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST3";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest3";
		sfxisambient	= 1;
};

INSTANCE spellFX_Pyrokinesis_INVESTBLAST4	(CFX_Base_Proto)
{
		visname_S 		= "MFX_Firestorm_INVESTBLAST4";
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Fireball_invest4";
		sfxisambient	= 1;
};


INSTANCE spellFX_Pyrokinesis_SPREAD	(CFx_Base_Proto)
{
     	visname_S 				= "MFX_Firestorm_SPREAD";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "CREATE CREATEQUAD";
     	emActionCollDyn_S 		= "CREATEONCE";
		//emFXCollStat_S	   	= "spellFX_Firestorm_COLLIDE";		// [Edenfeld] Wenn einkommentiert, erzeugt sehr viele VFX -> nicht sichtbar/Performance Probs.
		emFXCollDyn_S     		= "spellFX_ChargeFireball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "vob_magicburn";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		emCheckCollision		= 1;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "40 40";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		emFXCreate_S			= "spellFX_Firestorm_COLLIDE";

		sfxid					= "MFX_FIrestorm_Collide";
		sfxisambient			= 1;
		};

		INSTANCE spellFX_Pyrokinesis_SPREAD_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 				= 0.001;
		};

		INSTANCE spellFX_Pyrokinesis_SPREAD_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange 				= 150;
};



///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E R A I N  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_FireRain(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Firerain_INIT";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";

     	emFXInvestOrigin_S 		= "spellFX_FireRAin_INVESTGLOW";
		};

		INSTANCE spellFX_FireRain_KEY_CAST	(C_ParticleFXEmitKey)
		{
				emCreateFXID		= "spellFX_FireRain_RAIN";
				pfx_ppsIsLoopingChg = 1;
};

INSTANCE spellFX_FireRain_RAIN		(CFx_Base_Proto)
{
		visname_S 				= "MFX_FireRain_Rain";
		emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
		emActionCollDyn_S		= "CREATEONCE";
		emFXCollDyn_S     		= "spellFX_ChargeFireball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "vob_magicburn";
     	emFXCollDynAlign_S		= "COLLISIONNORMAL";
     	emCheckCollision		= 1;
     	LightPresetName 		= "CATACLYSM";
     	sfxid					= "MFX_Firerain_rain";
     	sfxisambient			= 1;
};


INSTANCE spellFX_FireRain_SUB(CFx_Base_Proto)		// vorr�bergehend, bis er hardcodiert nicht mehr gesucht wird
{
     	visname_S 				= "";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "BIP01 HEAD";
};


INSTANCE spellFX_FireRain_INVESTGLOW	(CFx_Base_Proto)
{
		visname_S 				= "MFX_FireRain_INVESTGLOW";
		emTrjOriginNode 		= "BIP01";
		emFXCreatedOwnTrj 		= 1;
		emtrjmode_s 			= "FIXED";
		lightPresetName 		= "REDAMBIENCE";
		sfxid					= "MFX_Firerain_INVEST";
		sfxisambient			= 1;
		emFXCreate_S			= "FX_EarthQuake";
};



///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  T E L E P O R T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_Teleport(CFx_Base_Proto)
{
		visname_S 			= "MFX_Teleport_INIT";
		//visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";

		emFXInvestOrigin_S 	= "spellFX_Teleport_ORIGIN";
		lightpresetname		= "AURA";

		};

		instance spellFX_Teleport_KEY_OPEN(C_ParticleFXEmitKey)
		{
			lightrange 		= 0.1;
		};

		instance spellFX_Teleport_KEY_INIT		(C_ParticleFXEmitKey)
		{
			lightrange 		= 0.1;
		};

		instance spellFX_Teleport_KEY_INVEST_1	(C_ParticleFXEmitKey)
		{
			lightrange		= 100;
		};

		instance spellFX_Teleport_KEY_CAST 	(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_Teleport_CAST";
			pfx_ppsIsLoopingChg = 1;
			lightrange 			= 200;
		};

instance spellFX_Teleport_ORIGIN	(CFx_Base_Proto)
{
		visname_S 			= "MFX_TELEPORT_INVEST";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		emFXCreate_S		= "spellFX_Teleport_Ring";
		sfxid				= "MFX_teleport_invest";
		sfxisambient		= 1;
};

instance spellFX_Teleport_RING	(CFx_Base_Proto)
{
		visname_S 			= "MFX_TELEPORT_RING";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
};

instance spellFX_Teleport_CAST	(CFx_Base_Proto)
{
		visname_S 			= "MFX_TELEPORT_CAST";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		sfxid				= "MFX_teleport_Cast";
		sfxisambient		= 1;

		emtrjmode_s 		= "FIXED";
};

///   													XXXXXXXXXXXXXXXXXXXXXX
///   													XX  P A L  H E A L  XX
///   													XXXXXXXXXXXXXXXXXXXXXX

instance spellFX_PalHeal(CFx_Base_Proto)
{
		visname_S 			= "MFX_Heal_INIT";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		//emFXInvestOrigin_S 	= "spellFX_PalHeal_ORIGIN";			// in gothic 2 sind die heal zauber instant spells, daher gibts keine investphase

		};

		instance spellFX_PalHeal_KEY_CAST 	(C_ParticleFXEmitKey)
		{
			pfx_ppsisloopingChg = 1;
			emCreateFXID		= "spellFX_Heal_ORIGIN";
};

instance spellFX_PalHeal_START		(CFx_Base_Proto)			// HEAL START wird im 1. Invest-Key getriggert. S�ule aus dem Boden.
{
		visname_S 			= "MFX_Heal_Start";
		sfxID			  	= "MFX_Heal_CAST";
		sfxisambient		= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01 R FOOT";
};

instance spellFX_PalHeal_ORIGIN	(CFx_Base_Proto)		// HEAL ORIGIN wird automatisch �ber emFXInvestOrigin_S getriggert. Aura um den Spieler
{
		visname_S 			= "MFX_Heal_HEAVENLIGHT";
		emTrjOriginNode 	= "BIP01";
		visAlpha			= 1;
	    emFXCreate_S	 	= "spellFX_PalHeal_START";
		emtrjmode_s 		= "FIXED";
		LightPresetname		= "AURA";
		};

		INSTANCE spellFX_PalHeal_ORIGIN_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 				= 0.001;
		};

		INSTANCE spellFX_PalHeal_ORIGIN_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange 				= 150;
};



///   													XXXXXXXXXXXXXXX
///   													XX  H E A L  XX
///   													XXXXXXXXXXXXXXX

instance spellFX_Heal(CFx_Base_Proto)
{
		visname_S 			= "MFX_Heal_INIT";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";

		};

		instance spellFX_Heal_KEY_INVEST_1	(C_ParticleFXEmitKey)
		{
			visname_S		= "MFX_HEAL_CAST";
			emCreateFXID	= "spellFX_Heal_LEFTHAND";
		};

		instance spellFX_Heal_KEY_CAST	 	(C_ParticleFXEmitKey)
		{
			// Noki: wieder aktiviert, da er an der Hand bliebt
			pfx_ppsisloopingChg = 1;
			emCreateFXID		= "spellFX_Heal_ORIGIN";
};

instance spellFX_Heal_ORIGIN	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Heal_HEAVENLIGHT";
		emTrjOriginNode 	= "BIP01";
		visAlpha			= 1;
	    emtrjmode_s 		= "FIXED";
	    sfxid				= "MFX_HEAL_CAST";
	    sfxisambient		= 1;
};

instance spellFX_Heal_LEFTHAND	(CFx_Base_Proto)
{
		visname_S 			= "MFX_HEAL_CAST";
		emTrjOriginNode 	= "ZS_LEFTHAND";
		visAlpha			= 1;
	    emtrjmode_s 		= "FIXED";
	    LightPresetname		= "AURA";
		};

		INSTANCE spellFX_Heal_LEFTHAND_KEY_INIT (C_ParticleFXEmitKey)
		{
				lightrange 				= 0.001;
		};

		INSTANCE spellFX_Heal_LEFTHAND_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange 				= 150;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  T R A N S F O R M   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Transform	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Transform_INIT";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjmode_s 		= "fixed";
		emtrjloopmode_s 	= "NONE";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 5000;
		};

		instance spellFX_transform_KEY_INVEST_0		(C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_Transform_ORIGIN";
				emCreateFXID		= "spellFX_Transform_ORIGIN";
		};

		instance spellFX_transform_KEY_INVEST_1		(C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_Transform_ORIGIN";
				emCreateFXID		= "spellFX_Transform_ORIGIN";
		};

		instance spellFX_transform_KEY_CAST			(C_ParticleFXEmitKey)
		{
				pfx_ppsisloopingChg = 1;
				emCreateFXID		= "spellFX_Transform_BLEND";
};


instance spellFX_Transform_ORIGIN	(CFx_Base_Proto)
{
		visname_S 				= "MFX_Transform_ORIGIN";
		emtrjoriginnode 		= "BIP01";
		emtrjmode_s 			= "FIXED";
		emtrjdynupdatedelay 	= 0;
		emselfrotvel_s 			= "0 0 50";
};

instance spellFX_Transform_BLEND	(CFx_Base_Proto)
{
		visname_S 				= "MFX_Transform_BLEND";
		emtrjmode_s 			= "FIXED";
		emtrjoriginnode 		= "ZS_RIGHTHAND";
		emtrjdynupdatedelay 	= 0;
		sfxid					= "MFX_Transform_Cast";
		sfxisambient			= 1;

};


///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  L I G H T N I N G  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Lightning	(CFx_Base_Proto)
{
		visName_S 			= "MFX_Lightning_Origin";
		visSize_S 			= "40 40";
		visAlphaBlendFunc_S = "ADD";
		visTexAniFPS 		= 17;
		visTexAniIsLooping 	= 1;

		emtrjmode_s 		= "FIXED";
		emtrjNumKeys    	= 4;
		emtrjnumkeysvar 	= 1;
		emtrjangleelevvar 	= 20.;
		emtrjangleheadvar 	= 20.;
		emtrjloopmode_s 	= "PINGPONG";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.05;
		emselfrotvel_s 		= "0 0 50";
		emTrjTargetRange	= 20;
		emTrjTargetElev 	= 0;
		emTrjKeyDistVar		= 2;
		emTrjEaseVel		= 150;
		};

		INSTANCE spellFX_Lightning_KEY_INIT			(C_ParticleFXEmitKey)
		{
				visName_S 			= "MFX_Lightning_Origin";
		};

		INSTANCE spellFX_Lightning_KEY_INVEST_1		(C_ParticleFXEmitKey)
		{
				visName_S 			= "Lightning_Single.ltn";
				emtrjmode_s 		= "TARGET LINE RANDOM";
				emtrjeasevel 			= 3000.;
		};

		INSTANCE spellFX_Lightning_KEY_CAST			(C_ParticleFXEmitKey)
		{

};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX 			Lightning Flash		   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

///   													XXXXXXXXXXXXXXXXXXXXXXX
///   													XX  F I R E B O L T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_LightningFlash (CFx_Base_Proto)
{

     	visname_S 				= "MFX_Lightning_Origin";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";

     	emActionCollDyn_S		= "COLLIDE CREATEONCE";
     	emFXCollDyn_S	   		= "spellFX_LightningFlash_HEAVENSRAGE";
     	emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		lightPresetname   		= "AURA";

		};

		INSTANCE spellFX_LightningFlash_KEY_INIT (C_ParticleFXEmitKey)
		{
			lightrange 				= 0.001;
		};

		INSTANCE spellFX_LightningFlash_KEY_INVEST (C_ParticleFXEmitKey)
		{
			lightrange 				= 100;
		};


		INSTANCE spellFX_LightningFlash_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_HEAVENSRAGE_CAST";
				emtrjmode_s 			= "TARGET";
				emtrjeasevel 			= 2000;
		     	sfxid					= "MFX_Thunderball_Collide3";
	 			lightrange 				= 100;
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_LightningFlash_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};
instance spellFX_LightningFlash_HEAVENSRAGE	(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "MFX_HEAVENSRAGE_FLASH";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	sendAssessMagic		= 1;
	emFXCreate_S	 	= "spellFX_LightningFlash_target_CLOUD";

	sfxid				= "MFX_Lightning_ORIGIN";
	sfxisambient		= 1;
};

instance spellFX_LightningFlash_target_Cloud (CFx_Base_Proto)
{
	visname_S 			= "MFX_HEAVENSRAGE_TARGET";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	emtrjdynupdatedelay = 0.01;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX 	OLD Lightning Flash	OLD 	   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/*
INSTANCE spellFX_LightningFlash	(CFx_Base_Proto)
{
		visName_S 			= "MFX_Lightning_Origin";
		visSize_S 			= "140";
		visAlphaBlendFunc_S = "ADD";
		visTexAniFPS 		= 5;
		visTexAniIsLooping 	= 1;

		emtrjmode_s 		= "FIXED";
		emtrjNumKeys    	= 1; //4
		emtrjnumkeysvar 	= 1;
		emtrjangleelevvar 	= 20.;
		emtrjangleheadvar 	= 20.;
		//emtrjloopmode_s 	= "COLLIDE";
		emTrjOriginNode 	= "ZS_RIGHTHAND";

		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.01;
		emFXInvestTarget_S 	= "spellFX_LightningFlash_target";
		emselfrotvel_s 		= "0 0 250";
		emTrjTargetRange	= 20;
		emTrjTargetElev 	= 0;
		userString[0]		= "1";
		};

		INSTANCE spellFX_LightningFlash_KEY_INIT			(C_ParticleFXEmitKey)
		{
				//visName_S 			= "lightning_origin_a0.tga";
		};

		INSTANCE spellFX_LightningFlash_KEY_INVEST_1		(C_ParticleFXEmitKey)
		{

		};

		INSTANCE spellFX_LightningFlash_KEY_CAST			(C_ParticleFXEmitKey)
		{

};

instance spellFX_LightningFlash_target(CFx_Base_Proto)  //FLASH
{
	visname_S 			= "MFX_HEAVENSRAGE_FLASH";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	lightPresetname 	= "AURA";
	sendAssessMagic		= 1;
	emFXCreate_S	 	= "spellFX_LightningFlash_target_CLOUD";

	sfxid				= "MFX_Lightning_ORIGIN";
	sfxisambient		= 1;
};

instance spellFX_LightningFlash_target_Cloud (CFx_Base_Proto)
{
	visname_S 			= "MFX_HEAVENSRAGE_TARGET";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	emtrjdynupdatedelay = 0.01;
	//emFXCreate_S	 	= "spellFX_LightningFlash_target_GROUND";

};

/*instance spellFX_LightningFlash_target_GROUND (CFx_Base_Proto)
{
	visname_S 			= "MFX_HEAVENSRAGE_GROUND";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	emtrjdynupdatedelay = 0.01;
	emFXCreate_S	 	= "spellFX_LightningFlash_target_cloud";

	sfxid				= "MFX_Lightning_Target";
	sfxisambient		= 1;
};*/

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX 			Z A P				   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Zap	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Icebolt_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Zap_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Zap_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		//visAlpha				= 0;

		};

		INSTANCE spellFX_Zap_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Icebolt_INIT";
				scaleDuration		= 0.5;
		};

		INSTANCE spellFX_Zap_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_HEAVENSRAGE_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 2000.;
	 			sfxid					= "MFX_Thunderball_Collide3";
	 			emCheckCollision		= 1;
				//emCreateFXID 			= "FX_CAST2";
		};

		INSTANCE spellFX_Zap_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
	 			emCheckCollision		= 0;
};

instance spellFX_Zap_COLLIDE	(CFx_Base_Proto)
{
		visname_S 		= "MFX_Icebolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};

instance spellFX_Zap_COLLIDEDYNFX		(CFx_Base_Proto)
{
		visname_S 		= "MFX_Thunderbolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
		SendAssessMagic	= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  H O L Y 	  B O L T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_PalHolyBolt	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_PalHolyBolt_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_PalHolyBolt_COLLIDE";
		emFXCollDyn_S     		= "spellFX_PalHolyBolt_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		//visAlpha				= 0;

		};

		INSTANCE spellFX_PalHolyBolt_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_PalHolyBolt_INIT";
				scaleDuration		= 0.5;
		};

		INSTANCE spellFX_PalHolyBolt_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_PalHolyBolt_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1600.;
	 			sfxid					= "MFX_Thunderbolt_Cast";
	 			emCheckCollision		= 1;
				//emCreateFXID 			= "FX_CAST2";
		};

		INSTANCE spellFX_PalHolyBolt_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
	 			emCheckCollision		= 0;
};

instance spellFX_PalHolyBolt_COLLIDE		(CFx_Base_Proto)
{
		visname_S 		= "MFX_PalHolyBolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};

instance spellFX_PalHolyBolt_COLLIDEDYNFX		(CFx_Base_Proto)
{
		visname_S 		= "MFX_PalHolyBolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  T H U N D E R B O L T  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Icebolt	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Icebolt_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Icebolt_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Icebolt_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		//visAlpha				= 0;

		};

		INSTANCE spellFX_Icebolt_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Icebolt_INIT";
				scaleDuration		= 0.5;
		};

		INSTANCE spellFX_Icebolt_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_Icebolt_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "mfx_thunderbolt_cast";
	 			emCheckCollision		= 1;
				//emCreateFXID 			= "FX_CAST2";
		};

		INSTANCE spellFX_Icebolt_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
	 			emCheckCollision		= 0;
};

instance spellFX_Icebolt_COLLIDE	(CFx_Base_Proto)
{
		visname_S 		= "MFX_Icebolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};

instance spellFX_Icebolt_COLLIDEDYNFX		(CFx_Base_Proto)
{
		visname_S 		= "MFX_Thunderbolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
		SendAssessMagic	= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  C H A R G E Z A P      XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_chargezap	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Thunderball_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_chargezap_COLLIDE";
		emFXCollDyn_S     		= "spellFX_chargezap_COLLIDE";
		emFXCollDynPerc_S     	= "spellFX_Thunderspell_SENDPERCEPTION";
		emFXCollStatAlign_S		= "COLLISIONNORMAL";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";
		lightPresetname   		= "AURA";

		};

		INSTANCE spellFX_chargezap_KEY_OPEN(C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_chargezap_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_chargezap_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INVEST";
				emCreateFXID	= "spellFX_chargezap_InVEST_BLAST1";
				lightrange		= 50;
				sfxid			= "MFX_Thunderball_invest1";
				sfxisambient	= 1;
		}								;
		INSTANCE spellFX_chargezap_KEY_INVEST_2 (C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INVEST_L2";
				emCreateFXID	= "spellFX_chargezap_InVEST_BLAST2";
				sfxid			= "MFX_Thunderball_invest2";
				sfxisambient	= 1;
		};
		INSTANCE spellFX_chargezap_KEY_INVEST_3 (C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INVEST_L3";
				emCreateFXID	= "spellFX_chargezap_InVEST_BLAST3";
				sfxid			= "MFX_Thunderball_invest3";
				sfxisambient	= 1;
		};
		INSTANCE spellFX_chargezap_KEY_INVEST_4 (C_ParticleFXEmitKey)
		{
				visname_S 		= "MFX_Thunderball_INVEST_L4";
				emCreateFXID	= "spellFX_chargezap_InVEST_BLAST4";
				sfxid			= "MFX_Thunderball_invest4";
				sfxisambient	= 1;
		};


		INSTANCE spellFX_chargezap_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange		= 100;
				visname_S 		= "MFX_Thunderball_CAST";
				emtrjmode_s 	= "TARGET";
		     	emtrjeasevel 	= 1400.;
	 			sfxid			= "MFX_Thunderball_Cast";
	 			sfxisambient	= 1;
	 			emCheckCollision= 1;
		};

		INSTANCE spellFX_chargezap_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s= "0 0.0002 0";
		     	emtrjeasevel 	= 0.000001;
};

instance spellFX_chargezap_InVEST_BLAST1		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_INVEST_BLAST";
		visAlpha				= 1;
		emtrjmode_s 			= "FIXED";
		//lightPresetname 		= "WHITEBLEND";
		sfxid					= "MFX_Thunderball_invest1";
		sfxisambient			= 1;
		visAlpha 				= 0.3;
};

instance spellFX_chargezap_InVEST_BLAST2	(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_INVEST_BLAST";
		visAlpha				= 1;
		emtrjmode_s 			= "FIXED";
		//lightPresetname 		= "WHITEBLEND";
		sfxid					= "MFX_Thunderball_invest2";
		sfxisambient			= 1;
		visAlpha 				= 0.5;
};

instance spellFX_chargezap_InVEST_BLAST3		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_INVEST_BLAST";
		visAlpha				= 1;
		emtrjmode_s 			= "FIXED";
		//lightPresetname 		= "WHITEBLEND";
		sfxid					= "MFX_Thunderball_invest3";
		sfxisambient			= 1;
		visAlpha 				= 0.8;
};

instance spellFX_chargezap_InVEST_BLAST4		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_INVEST_BLAST";
		visAlpha				= 1;
		emtrjmode_s 			= "FIXED";
		//lightPresetname 		= "WHITEBLEND";
		sfxid					= "MFX_Thunderball_invest4";
		sfxisambient			= 1;
		visAlpha 				= 1;
};

// KOLLISION MIT STATISCHER WELT:  KEINE PERCEPTION

instance spellFX_chargezap_COLLIDE		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Thunderball_Collide1";
		visAlpha				= 1;
		emTrjOriginNode			= "BIP01";
		emtrjmode_s 			= "FIXED";
		lightPresetname   		= "FIRESMALL";

};

INSTANCE spellFX_chargezap_COLLIDE_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Thunderball_Collide1";		sfxid	= "MFX_Thunderball_Collide1";		};
INSTANCE spellFX_chargezap_COLLIDE_KEY_INVEST_2	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Thunderball_Collide2";		sfxid	= "MFX_Thunderball_Collide2";		};
INSTANCE spellFX_chargezap_COLLIDE_KEY_INVEST_3	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Thunderball_Collide3";		sfxid	= "MFX_Thunderball_Collide3";		};
INSTANCE spellFX_chargezap_COLLIDE_KEY_INVEST_4	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Thunderball_Collide4";		sfxid	= "MFX_Thunderball_Collide4";		};


///   													XXXXXXXXXXXXXXXXXXXXX
///   													XX  I C E C U B E  XX
///   													XXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_IceCube	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_Icecube_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_IceCube_COLLIDE";
		//emFXCollDyn_S     		= "spellFX_Icespell_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "spellFX_Icespell_SENDPERCEPTION";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		emFXInvestOrigin_S		= "spellFX_Icespell_Invest";
		//visAlpha				= 0;

		lightPresetname   		= "AURA";
		};

		INSTANCE spellFX_IceCube_KEY_OPEN(C_ParticleFXEmitKey)
		{
				Lightrange				= 0.01;
		};

		INSTANCE spellFX_IceCube_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_Icecube_INIT";
				Lightrange				= 0.01;
				scaleDuration			= 0.5;
		};

		INSTANCE spellFX_IceCube_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_ICECUBE_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1000.;
	 			emCheckCollision		= 1;
	 			sfxid					= "MFX_Icecube_cast";
	 			sfxisambient			= 1;
				//emCreateFXID 			= "FX_CAST2";
				Lightrange				= 100;
		};

		INSTANCE spellFX_IceCube_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
	 			//emCheckCollision		= 0;
};

instance spellFX_IceCube_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ICESPELL_Collide";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_ICECUBE_COLLIDE";
};

instance spellFX_Icespell_Invest		(CFx_Base_Proto)
{
		visname_S 			= "";
		emtrjmode_s 		= "FIXED";
		sfxid				= "MFX_ICECUBE_INVEST";
		sfxisambient		= 1;
};




///   													XXXXXXXXXXXXXXXXXXXXX
///   													XX  I C E W A V E  XX
///   													XXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Icewave(CFx_Base_Proto)
{

     	visname_S 			= "MFX_IceCUBE_INIT";
     	emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
     	emtrjloopmode_s 	= "NONE";

     	emFXInvestOrigin_S	= "spellFX_Icespell_Invest";
     	};

		INSTANCE spellFX_Icewave_KEY_INIT(C_ParticleFXEmitKey)
		{
				visname_S 	= "MFX_IceCUBE_INIT";
		};

		INSTANCE spellFX_Icewave_KEY_CAST(C_ParticleFXEmitKey)
		{
				emCreateFXID		= "spellFX_Icewave_WAVE";
				pfx_ppsIsLoopingChg = 1;
				sfxid				= "MFX_Icewave_Cast";
				sfxisambient		= 1;
};

INSTANCE spellFX_Icewave_WAVE	(CFx_Base_Proto)
{
		visname_S 				= "MFX_Icewave_WAVE";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
		emActionCollDyn_S		= "CREATEONCE";
     	//emFXCollDyn_S			= "spellFX_IceSpell_COLLIDEDYNFX";
     	emFXCollDynPerc_S     	= "spellFX_Icespell_SENDPERCEPTION";
     	emFXCollDynAlign_S		= "COLLISIONNORMAL";
     	emCheckCollision		= 1;
     	LightPresetName			= "WHITEBLEND";
};


INSTANCE spellFX_IceWave_WAVE_KEY_OPEN		(C_ParticleFXEmitKey)
{
		LightRange			= 0.01;
};

INSTANCE spellFX_IceWave_WAVE_KEY_INIT		(C_ParticleFXEmitKey)
{
		LightRange			= 0.01;
};


INSTANCE spellFX_IceWave_WAVE_KEY_CAST		(C_ParticleFXEmitKey)
{
		LightRange			= 100;
};



INSTANCE spellFX_Icewave_SUB(CFx_Base_Proto)		// vorr�bergehend, bis er hardcodiert nicht mehr gesucht wird
{
     	visname_S 				= "";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "BIP01 HEAD";
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    G O L E M         XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonCreature_ORIGIN (CFx_Base_Proto)
{
		visname_S 				= "MFX_ArmyOfDarkness_Origin";
		emtrjmode_s 			= "FIXED";
		emtrjoriginnode 		= "BIP01";
		emtrjdynupdatedelay 	= 0;
		sfxid					= "MFX_Transform_Cast";
		sfxisambient			= 1;
		emFXCreate_S 			= 	"FX_EarthQuake";

};

instance spellFX_SummonCreature_LEFTHAND	(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT2";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "Bip01 L Hand";

};

instance spellFX_SummonGolem		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonGolem_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGolem_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGolem_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonGolem_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    S K E L E T O N   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonSkeleton		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonSkeleton_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonSkeleton_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonSkeleton_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonSkeleton_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    G O B L I N S K   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonGoblinSkeleton		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonGoblinSkeleton_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGoblinSkeleton_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGoblinSkeleton_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonGoblinSkeleton_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};



///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    W O L F           XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonWolf (CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonWolf_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonWolf_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonWolf_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonWolf_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};



///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    D E M O N         XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonDemon	(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonDemon_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonDemon_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonDemon_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonDemon_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    G U A R D I A N   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonGuardian	(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonGuardian_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGuardian_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonGuardian_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonGuardian_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    Z O M B I E       XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonZombie	(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonZombie_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonZombie_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonZombie_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonZombie_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  S U M M O N    M U D       XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_SummonMud	(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonMud_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonMud_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonMud_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonMud_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  A R M Y   O F   D A R K N E S S  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_ArmyOfDarkness		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_ArmyOfDarkness_KEY_OPEN(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_ArmyOfDarkness_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_ArmyOfDarkness_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"spellFX_SummonCreature_LEFTHAND";
		};
		instance spellFX_ArmyOfDarkness_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonCreature_ORIGIN";
			pfx_ppsisloopingchg = 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  M A S S D E A T H  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_MassDeath(CFx_Base_Proto)
{

     	visname_S 				= "MFX_MassDeath_INIT";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjloopmode_s 		= "NONE";
		emFXCreatedOwnTrj 		= 0;

		};

		INSTANCE spellFX_MassDeath_KEY_INIT(C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_MassDeath_INIT";
		};

		INSTANCE spellFX_MassDeath_KEY_INVEST_1	(C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_MASSDEATH_RIGHTHAND";
				emCreateFXID		= "spellFX_MassDeath_LEFTHAND";
		};


		INSTANCE spellFX_MassDeath_KEY_CAST(C_ParticleFXEmitKey)
		{
				emCreateFXID		= "spellFX_MassDeath_EXPLOSION";
				pfx_ppsIsLoopingChg = 1;
};


instance spellFX_Massdeath_EXPLOSION	(CFx_Base_Proto)
{
		visname_S 			= "MFX_MASSDEATH_EXPLOSION";

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "Bip01 L Hand";
		emFXCreate_S		=  "spellFX_MassDeath_GROUND";

};


INSTANCE spellFX_MassDeath_GROUND		(CFx_Base_Proto)
{
		visname_S 				= "MFX_MassDeath_CAST";
		emTrjOriginNode 		= "BIP01 R Foot";
		emActionCollDyn_S		= "CREATEONCE";
     	emFXCollDyn_S			= "spellFX_MassDeath_COLLIDEDYNFX";
     	emFXCollDynAlign_S		= "COLLISIONNORMAL";
     	emCheckCollision		= 1;
     	LightPresetName			= "REDAMBIENCE";
     	sfxid					= "MFX_Massdeath_Cast";
		sfxisambient			= 1;
};

instance spellFX_Massdeath_LEFTHAND	(CFx_Base_Proto)
{
		visname_S 			= "MFX_MASSDEATH_LEFTHAND";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "Bip01 L Hand";

		emFXCreate_S		= "FX_EARTHQUAKE";

};

INSTANCE spellFX_MassDeath_SUB			(CFx_Base_Proto)		// vorr�bergehend, bis er hardcodiert nicht mehr gesucht wird
{
     	visname_S 				= "";
     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "BIP01 HEAD";
};


INSTANCE spellFX_MassDeath_COLLIDEDYNFX		(CFx_Base_Proto)
{
		visname_S 				= "MFX_Massdeath_TARGET";
		emTrjOriginNode 		= "BIP01";
		emFXCreatedOwnTrj 		= 1;
		emtrjmode_s 			= "FIXED";
		sfxid					= "MFX_MassdeatH_Target";
};

///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  D E S T R O Y   U N D E A D  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_DestroyUndead(CFx_Base_Proto)
{

     	visname_S 				= "MFX_DestroyUndead_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Destroyundead_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Destroyundead_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		};

		INSTANCE spellFX_DestroyUndead_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_DestroyUndead_INIT";
		};

		INSTANCE spellFX_DestroyUndead_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_DestroyUndead_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 800.;
	 			sfxid					= "MFX_DestroyUndead_Cast";
	 			sfxisambient			= 1;
				//emCreateFXID 			= "FX_CAST2";
				emCheckCollision 		= 1;
};


INSTANCE spellFX_Destroyundead_COLLIDE		(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_DESTROYUNDEAD_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};

INSTANCE spellFX_Destroyundead_COLLIDEDYNFX	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_DESTROYUNDEAD_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX     R E P E L    E V I L		 XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_PalRepelEvil(CFx_Base_Proto)
{

     	visname_S 				= "MFX_REPELEVIL_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_PalRepelEvil_COLLIDE";
		emFXCollDyn_S     		= "spellFX_PalRepelEvil_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		};

		INSTANCE spellFX_PalRepelEvil_KEY_INIT (C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_DestroyUndead_INIT";
		};

		INSTANCE spellFX_PalRepelEvil_KEY_CAST (C_ParticleFXEmitKey)
		{
				//visname_S 				= "MFX_RepelEvil_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 800.;
	 			sfxid					= "MFX_DestroyUndead_Cast";
	 			emCreateFXID			= "spellFX_RepelEvil_TRAIL";
	 			sfxisambient			= 1;
				emCheckCollision 		= 1;
		};

		INSTANCE spellFX_PalRepelEvil_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
			emtrjeasevel = 0.0001;

};

instance spellFX_REPELEVIL_TRAIL		(CFx_Base_Proto)
{
		emtrjeasevel 	= 800.;
		visname_S 		= "MFX_REPELEVIL_TRAIL";
		visAlpha		= 1;
		emtrjmode_s 	= "TARGET";
		emCheckCollision 		= 1;
		emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S 		= "COLLIDE";
		};

		INSTANCE spellFX_REPELEVIL_TRAIL_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};


INSTANCE spellFX_PalRepelEvil_COLLIDE		(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_RepelEvil_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};

INSTANCE spellFX_PalRepelEvil_COLLIDEDYNFX(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_RepelEvil_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX     M A S T E R   O F  D I S A S T E R   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_MasterOfDisaster	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_MasterOfDisaster_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_MasterOfDisaster_COLLIDE";
		emFXCollDyn_S     		= "spellFX_MasterOfDisaster_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		};

		INSTANCE spellFX_MasterOfDisaster_KEY_INIT (C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_DestroyUndead_INIT";
		};

		INSTANCE spellFX_MasterOfDisaster_KEY_CAST (C_ParticleFXEmitKey)
		{
				//visname_S 				= "MFX_RepelEvil_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 2500.;
	 			sfxid					= "MFX_DestroyUndead_Cast";
	 			sfxisambient			= 1;
				emCheckCollision 		= 1;
};

instance spellFX_MasterOfDisaster_TRAIL		(CFx_Base_Proto)
{
		emtrjeasevel 	= 800.;
		visname_S 		= "MFX_MasterOfDisaster_TRAIL";
		visAlpha		= 1;
		emtrjmode_s 	= "TARGET";
		emCheckCollision 		= 1;
		emActionCollStat_S		= "COLLIDE";
     	emActionCollDyn_S 		= "COLLIDE";
		};

		INSTANCE spellFX_MasterOfDisaster_TRAIL_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};


INSTANCE spellFX_MasterOfDisaster_COLLIDE		(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_MasterOfDisaster_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};

INSTANCE spellFX_MasterOfDisaster_COLLIDEDYNFX(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_MasterOfDisaster_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};



///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  D E S T R O Y   E V I L		 XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_PalDestroyEvil(CFx_Base_Proto)
{

     	visname_S 				= "MFX_DestroyUndead_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_PalDestroyEvil_COLLIDE";
		emFXCollDyn_S     		= "spellFX_PalDestroyEvil_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;
		};

		INSTANCE spellFX_PalDestroyEvil_KEY_INIT (C_ParticleFXEmitKey)
		{
				//visname_S 			= "MFX_DestroyUndead_INIT";
		};

		INSTANCE spellFX_PalDestroyEvil_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_DestroyUndead_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 800.;
	 			sfxid					= "MFX_DestroyUndead_Cast";
	 			sfxisambient			= 1;
				//emCreateFXID 			= "FX_CAST2";
				emCheckCollision 		= 1;
};


INSTANCE spellFX_PalDestroyEvil_COLLIDE		(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_DESTROYUNDEAD_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};

INSTANCE spellFX_PalDestroyEvil_COLLIDEDYNFX(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01";
	visname_S 			= "MFX_DESTROYUNDEAD_COLLIDE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "AURA";
	sfxid				= "MFX_DESTROYUNDEAD_COLLIDE";
	sfxisambient		= 1;
};

///   													XXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  W I N D F I S T   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_WindFist(CFx_Base_Proto)
{
		visname_S 			= "MFX_WINDFIST_INIT";
		vissize_s			= "1 1";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emtrjnumkeys 		= 7;
		emtrjnumkeysvar 	= 3;
		emtrjangleelevvar 	= 5.;
		emtrjangleheadvar 	= 20.;
		emtrjloopmode_s 	= "NONE";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 200000;
		emTrjTargetRange	= 100;
		emTrjTargetElev 	= 1;
		emActionCollDyn_S 	= "CREATEONCE";
		emFXCollDyn_S	   	= "spellFX_Windfist_COLLIDEDYNFX";	//Sendet perception
		emFXInvestOrigin_S	= "spellFX_Windfist_Invest";


		};

		INSTANCE spellFX_WINDFIST_KEY_INIT (C_ParticleFXEmitKey)
		{
				emCheckCollision	= 0;
		};

		// INSTANCE spellFX_Windfist_KEY_INVEST_1	(C_ParticleFXEmitKey)	{	emCreateFXID	= "spellFX_Windfist_INVESTBLAST";	};
		// INSTANCE spellFX_Windfist_KEY_INVEST_2	(C_ParticleFXEmitKey)	{	emCreateFXID	= "spellFX_Windfist_INVESTBLAST";	};
		// INSTANCE spellFX_Windfist_KEY_INVEST_3	(C_ParticleFXEmitKey)	{	emCreateFXID	= "spellFX_Windfist_INVESTBLAST";	};
		// INSTANCE spellFX_Windfist_KEY_INVEST_4	(C_ParticleFXEmitKey)	{	emCreateFXID	= "spellFX_Windfist_INVESTBLAST";	};


		INSTANCE spellFX_WINDFIST_KEY_CAST	 (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_WINDFIST_COLLISIONDUMMY";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 2500.;
	 			emCheckCollision		= 1;
				emCreateFXID			= "spellFX_WINDFIST_CAST";
};


INSTANCE spellFX_Windfist_Invest (CFx_Base_Proto)
{
		visname_S			= "MFX_WINDFIST_INVEST";
		sfxid				= "MFX_WINDFIST_INVEST";
		sfxisambient		= 1;
};

INSTANCE spellFX_Windfist_INVESTBLAST	(CFX_Base_Proto)
{
		visname_S			= "MFX_WINDFIST_INVEST_BLAST";
		sfxid				= "MFX_WINDFIST_INVESBLAST";
		sfxisambient		= 1;
};


INSTANCE spellFX_Windfist_Cast (CFx_Base_Proto)
{
		visname_S			= "MFX_WINDFIST_Cast";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		sfxid				= "MFX_Windfist_Cast";
		sfxisambient		= 1;
};


INSTANCE spellFX_Windfist_COLLIDEDYNFX (CFx_Base_Proto)	//Sendet perception
{
		visname_S			= "MFX_WINDFIST_COLLIDE";
		sendAssessMagic	= 1;
};





///   													XXXXXXXXXXXXXXXXX
///   													XX  S L E E P  XX
///   													XXXXXXXXXXXXXXXXX


INSTANCE spellFX_Sleep	(CFx_Base_Proto)
{
		visname_S 			= "MFX_SLEEP_INIT";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjmode_s 		= "fixed";
		emtrjloopmode_s 	= "NONE";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.;

		//emFXInvestOrigin_S 	= "spellFX_Sleep_ORIGIN";
		//emFXInvestTarget_S 	= "spellFX_Sleep_TARGET";

		};

		INSTANCE spellFX_Sleep_KEY_INIT	(C_ParticleFXEmitKey)
		{
				visname_S				= "MFX_SLEEP_INIT";
		};

		INSTANCE spellFX_Sleep_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_SLEEP_ORIGIN";
				//emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
		     	sfxid					= "MFX_Sleep_Cast";

				//emCreateFXID 			= "FX_CAST2";
};



instance spellFX_Sleep_ORIGIN	(CFx_Base_Proto)
{
		visname_S 		= "MFX_SLEEP_ORIGIN";
		emtrjmode_s 		= "FIXED";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjdynupdatedelay 	= 0;
};

instance spellFX_Sleep_TARGET	(CFx_Base_Proto)
{
		lightPresetname 	= "AURA";
		visname_S 		= "MFX_SLEEP_TARGET";
		emtrjmode_s 		= "FIXED";
		emtrjoriginnode 	= "BIP01";
		emtrjdynupdatedelay 	= 0;

		//sendAssessMagic	= 1;
};

///   													XXXXXXXXXXXXXXXXX
///   													XX  C H A R M  XX
///   													XXXXXXXXXXXXXXXXX



INSTANCE spellFX_Charm (CFx_Base_Proto)
{
		visname_S 			= "MFX_CHARM_INIT";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjmode_s 		= "fixed";
		emtrjloopmode_s 	= "NONE";
		emtrjeasefunc_s 	= "LINEAR";
		emtrjdynupdatedelay = 0.;

		//emFXInvestOrigin_S 	= "spellFX_Sleep_ORIGIN";
		emFXInvestTarget_S 	= "spellFX_Charm_TARGET";

		};

		INSTANCE spellFX_CHARM_KEY_INIT	(C_ParticleFXEmitKey)
		{
				visname_S				= "MFX_CHARM_INIT";
		};

		INSTANCE spellFX_CHARM_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_CHARM_ORIGIN";
				//emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1400.;
		     	sfxid					= "MFX_Sleep_Cast";

				//emCreateFXID 			= "FX_CAST2";
};



instance spellFX_CHARM_ORIGIN	(CFx_Base_Proto)
{
		visname_S 		= "MFX_CHARM_ORIGIN";
		emtrjmode_s 		= "FIXED";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjdynupdatedelay 	= 0;
};

instance spellFX_CHARM_TARGET	(CFx_Base_Proto)
{
		lightPresetname 	= "AURA";
		visname_S 		= "MFX_CHARM_TARGET";
		emtrjmode_s 		= "FIXED";
		emtrjoriginnode 	= "BIP01";
		emtrjdynupdatedelay 	= 0;

		//sendAssessMagic	= 1;
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  P Y R O K I N E S I S  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX


/*
INSTANCE spellFX_Pyrokinesis(CFx_Base_Proto)
{
		visname_S 			= "MFX_Firestorm_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emtrjtargetnode 	= "BIP01 HEAD";
		emtrjnumkeys 		= 1;
		emtrjnumkeysvar 	= 1;
		emtrjangleelevvar 	= 15.;
		emtrjangleheadvar 	= 0.;
		emtrjdynupdatedelay 	= 0.;
		emFXInvestTarget_S 	= "spellFX_Pyrokinesis_target";
		emTrjTargetRange	= 0;
		emTrjTargetElev 	= 0;
		};

		INSTANCE spellFX_Pyrokinesis_KEY_CAST (C_ParticleFXEmitKey)
		{
				pfx_ppsIsLoopingChg = 1;
				emCreateFXID 	= "spellFX_Pyrokinesis_BRIDGE";
};

INSTANCE spellFX_Pyrokinesis_TARGET(CFx_Base_Proto)
{
	visname_S 			= "MFX_Pyrokinesis_TARGET";

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01 HEAD";
	lightPresetname 	= "FIRESMALL";
	emTrjTargetRange	= 0;
	emTrjTargetElev 	= 0;
	sendAssessMagic		= 1;
	emtrjdynupdatedelay = 0.01;

	sfxid				= "MFX_Pyrokinesis_target";
	sfxisambient		= 1;
};

instance spellFX_Pyrokinesis_BRIDGE	(CFx_Base_Proto)
{
		visname_S 		= "MFX_PYROKINESIS_BRIDGE";
		emtrjmode_s 		= "FIXED";
		emtrjoriginnode 	= "ZS_RIGHTHAND";
		emtrjdynupdatedelay 	= 0;
};


*/


///   													XXXXXXXXXXXXXXX
///   													XX  F E A R  XX
///   													XXXXXXXXXXXXXXX


INSTANCE spellFX_Fear(CFx_Base_Proto)
{
		visname_S 			= "MFX_FEAR_INIT";
		emtrjmode_s 		= "FIXED";
		emtrjeasefunc_s 	= "linear";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emtrjdynupdatedelay = 10000;
		};

		INSTANCE spellFX_Fear_KEY_OPEN (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 	= 0.;
		};

		INSTANCE spellFX_Fear_KEY_INVEST_1	(C_ParticleFXEmitKey)
		{
				//emCreateFXID	= "spellFX_Fear_WINGS2";
		};

		INSTANCE spellFX_Fear_KEY_CAST		(C_ParticleFXEmitKey)
		{
		     	emCreateFXID	= "spellFX_Fear_GROUND";
		     	pfx_ppsIsLoopingChg		= 1;
};


INSTANCE spellFX_Fear_WINGS		(CFx_Base_Proto)
{
		visname_S 			= "MFX_FEAR_WINGS";


		emtrjmode_s 		= "FIXED";
		emtrjeasefunc_s 	= "linear";
		emTrjOriginNode 	= "BIP01";
		emtrjdynupdatedelay = 10000;
		//emFXCreatedOwnTrj 	= 0;

		emFXCreate_S		=  "FX_Earthquake";

};

INSTANCE spellFX_Fear_WINGS2		(CFx_Base_Proto)
{
		visname_S 			= "MFX_FEAR_WINGS2";

		emtrjmode_s 		= "FIXED";
		emtrjeasefunc_s 	= "linear";
		emTrjOriginNode 	= "BIP01";
		emtrjdynupdatedelay = 10000;

		emFXCreate_S		=  "spellFX_Fear_GROUND";

};

INSTANCE spellFX_Fear_GROUND	(CFx_Base_Proto)
{
		visname_S 			= "MFX_FEAR_ORIGIN";

		emtrjmode_s 		= "FIXED";
		emtrjeasefunc_s 	= "linear";
		emTrjOriginNode 	= "BIP01";
		emtrjdynupdatedelay = 10000;

		sfxid				= "MFX_FEAR_CAST";
		sfxisambient		= 1;


};

INSTANCE spellFX_FEAR_SENDPERCEPTION	(CFx_Base_Proto)	//Sendet perception
{
		visname_S			= "";
		sfxid				= "HAMMER";
		sendassessmagic		= 1;
};



///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  B R E A T H   O F   D E A T H  XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

instance spellFX_BreathOfDeath		(CFx_Base_Proto)
{
		visname_S 				= "MFX_BreathOfDeath_INIT";
		visAlpha				= 1;

		emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollDyn_S 		= "CREATEONCE";
		emFXCollDyn_S	   		= "spellFX_BreathOfDeath_Target";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 30.000;

		};

		INSTANCE spellFX_BreathOfDeath_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
				//emCreateFXID		= "SpellFX_BreathOfDeath_Invest";
		};


		INSTANCE spellFX_BreathOfDeath_KEY_CAST	 (C_ParticleFXEmitKey)
		{
				pfx_ppsisloopingchg		= 1;
				emCreateFXID			= "spellFX_BreathOfDeath_CAST";
};


INSTANCE spellFX_BreathOfDeath_Invest (CFx_Base_Proto)
{
		visname_S			= "MFX_BREATHOFDEATH_INVEST";
		sfxid				= "MFX_BREATHOFDEATH_INVEST";
		sfxisambient		= 1;
};


INSTANCE spellFX_BreathOfDeath_Cast (CFx_Base_Proto)
{
		visname_S				= "MFX_BreathOfDeath_Cast";

		emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01";

     	/*emTrjNumKeys			= 8;
		emTrjNumKeysVar			= 3;

		emTrjAngleElevVar		= 30;
		emTrjAngleHeadVar		= 30;*/

     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollDyn_S 		= "CREATEONCE";
		emFXCollDyn_S	   		= "spellFX_BreathOfDeath_Target";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 30.000;

		sfxid				= "MFX_BreathOfDeath_Cast";
		sfxisambient		= 1;

		};

		INSTANCE spellFX_BreathOfDeath_Cast_KEY_CAST	 (C_ParticleFXEmitKey)
		{
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 800.;
	 			emCheckCollision		= 1;
};


INSTANCE spellFX_BreathOfDeath_Target (CFx_Base_Proto)
{
		visname_S			= "MFX_BREATHOFDEATH_COLLIDE";
		sfxid				= "MFX_BREATHOFDEATH_TARGET";
		sfxisambient		= 1;
};


///   													XXXXXXXXXXXXXXXXXXXX
///   													XX  S H R I N K   XX
///   													XXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Shrink(CFx_Base_Proto)
{
		visname_S 			= "MFX_SHRINK_INIT";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		emtrjtargetnode 	= "BIP01";
		emtrjnumkeys 		= 5;
		emtrjnumkeysvar 	= 1;
		emtrjangleelevvar 	= 15.;
		emtrjangleheadvar 	= 0.;
		emtrjeasefunc_s 	= "LINEAR";
		emtrjloopmode_s		= "HALT";
		emtrjdynupdatedelay = 0.;
		emTrjTargetRange	= 0;
		emTrjTargetElev 	= 0;
		lightpresetname		= "AURA";
		emFXInvestOrigin_S	= "spellFX_SHRINK_ORIGIN";

		};


		INSTANCE spellFX_Shrink_KEY_OPEN(C_ParticleFXEmitKey)
		{
				emtrjeasevel		= 0.01;
				LightRange			= 0.01;
		};

		INSTANCE spellFX_Shrink_KEY_INIT	(C_ParticleFXEmitKey)
		{
				emtrjeasevel		= 0.01;
				LightRange			= 0.01;
		};

		INSTANCE spellFX_Shrink_KEY_CAST	(C_ParticleFXEmitKey)
		{
				emtrjmode_s 		= "TARGET LINE";
				visname_S 			= "MFX_SHRINK_TARGET";
				emtrjeasevel		= 6000;
				LightRange			= 100;
				sfxid				= "MFX_SHRINK_CAST";
				sfxisambient		= 1;

};

INSTANCE spellFX_Shrink_Origin (CFx_Base_Proto)
{
		emFXCreatedOwnTrj 	= 0;
		visname_S			= "";
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "BIP01";
		sfxid				= "MFX_SHRINK_INVEST";
		sfxisambient		= 1;
};

//   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  	Concussionbolt	   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

INSTANCE spellFX_Concussionbolt	(CFx_Base_Proto)
{

     	visname_S 				= "MFX_PalHolyBolt_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATE";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Concussionbolt_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Concussionbolt_COLLIDEDYNFX";
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay		= 20000;

		//visAlpha				= 0;

		};

		INSTANCE spellFX_Concussionbolt_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_PalHolyBolt_INIT";
				scaleDuration		= 0.5;
		};

		INSTANCE spellFX_Concussionbolt_KEY_CAST (C_ParticleFXEmitKey)
		{
				visname_S 				= "MFX_PalHolyBolt_CAST";
				emtrjmode_s 			= "TARGET";
		     	emtrjeasevel 			= 1600.;
	 			sfxid					= "MFX_PalHolyBolt_Cast";
	 			emCheckCollision		= 1;
				//emCreateFXID 			= "FX_CAST2";
		};

		INSTANCE spellFX_Concussionbolt_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
	 			emCheckCollision		= 0;
};

instance spellFX_Concussionbolt_COLLIDE		(CFx_Base_Proto)
{
		visname_S 		= "MFX_PalHolyBolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};

instance spellFX_Concussionbolt_COLLIDEDYNFX		(CFx_Base_Proto)
{
		visname_S 		= "MFX_PalHolyBolt_Collide";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "Torch_Enlight";
};
//   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  	Deathbolt	   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX



INSTANCE spellFX_Deathbolt(CFx_Base_Proto)
{
     	visname_S 				= "MFX_Fireball_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Deathbolt_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Deathbolt_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "VOB_MAGICBURN";
		emFXCollStatAlign_S		= "COLLISIONNORMAL";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay	= 20000;
		//emTrjDynUpdateDelay		= 0.4;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		};

		INSTANCE spellFX_Deathbolt_KEY_OPEN (C_ParticleFXEmitKey)
		{
				lightrange		= 0.01;
		};


		INSTANCE spellFX_Deathbolt_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Fireball_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_Deathbolt_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange				= 100;
				visname_S 				= "MFX_IFB_PFXTRAIL";
				emtrjmode_s 			= "TARGET";
		     	emSelfRotVel_S			= "100 100 100";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Fireball_Cast";
	 			sfxisambient			= 1;
	 			emCreateFXID			= "spellFX_InstantFireball_FIRECLOUD";
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Deathbolt_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_Deathbolt_FIRECLOUD		(CFx_Base_Proto)
{
		emtrjeasevel 	= 1400.;
		visname_S 		= "MFX_IFB_CAST";
		visAlpha		= 1;
		emtrjmode_s 	= "TARGET";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
		emTrjDynUpdateDelay	= 20000;
     	emCheckCollision 		= 2;					// [EDENFELD, neu] 2: Coll, aber keinen Schaden abziehen (n�tig, da dieser FX nicht als Child eingef�gt wurde, sondern komplett
     													// unabh�ngig mit Coll in die Welt gesetzt wurde. Der Schaden wird aber schon von spellFX_InstantFireball berechnet.)
		emActionCollDyn_S 		= "COLLIDE";
		emActionCollStat_S 		= "COLLIDE";
		};

		INSTANCE spellFX_Deathbolt_FIRECLOUD_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};

// KOLLISION MIT STATISCHER WELT:  KEINE PERCEPTION

instance spellFX_Deathbolt_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode		= "BIP01";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_Deathbolt_COLLIDE_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};

// KOLLISION MIT DYNAMISCHER WELT:  WOHL PERCEPTION

instance spellFX_Deathbolt_COLLIDEDYNFX	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emTrjOriginNode		= "BIP01";
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_Deathbolt_COLLIDEDYNFX_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};


//   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  	Deathball	   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXX


INSTANCE spellFX_Deathball(CFx_Base_Proto)
{
     	visname_S 				= "MFX_Fireball_INIT";

     	emtrjmode_s 			= "FIXED";
		emTrjOriginNode 		= "ZS_RIGHTHAND";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
     	emActionCollStat_S		= "COLLIDE CREATEONCE CREATEQUAD";
     	emActionCollDyn_S 		= "COLLIDE CREATEONCE";
		emFXCollStat_S	   		= "spellFX_Deathball_COLLIDE";
		emFXCollDyn_S     		= "spellFX_Deathball_COLLIDEDYNFX";
		emFXCollDynPerc_S     	= "VOB_MAGICBURN";
		emFXCollStatAlign_S		= "COLLISIONNORMAL";
		emFXCreatedOwnTrj 		= 0;
		emTrjTargetRange	 	= 20;
		emTrjTargetElev 		= 0;
		emTrjDynUpdateDelay	= 20000;
		//emTrjDynUpdateDelay		= 0.4;
		userString[0]			= "fireballquadmark.tga";
		userString[1]			= "100 100";
		userString[2]			= "MUL";
		lightPresetname   		= "FIRESMALL";

		};

		INSTANCE spellFX_Deathball_KEY_OPEN (C_ParticleFXEmitKey)
		{
				lightrange		= 0.01;
		};


		INSTANCE spellFX_Deathball_KEY_INIT (C_ParticleFXEmitKey)
		{
				visname_S 			= "MFX_Fireball_INIT";
				lightrange		= 0.01;
		};

		INSTANCE spellFX_Deathball_KEY_CAST (C_ParticleFXEmitKey)
		{
				lightrange				= 200;
				visname_S 				= "MFX_IFB_PFXTRAIL";
				emtrjmode_s 			= "TARGET";
		     	emSelfRotVel_S			= "100 100 100";
		     	emtrjeasevel 			= 1400.;
	 			sfxid					= "MFX_Fireball_Cast";
	 			sfxisambient			= 1;
	 			emCreateFXID			= "spellFX_InstantFireball_FIRECLOUD";
	 			emCheckCollision 		= 1;
		};

		INSTANCE spellFX_Deathball_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	pfx_flygravity_s		= "0 0.0002 0";
		     	emtrjeasevel 			= 0.000001;
};

instance spellFX_Deathball_FIRECLOUD		(CFx_Base_Proto)
{
		emtrjeasevel 	= 1400.;
		visname_S 		= "MFX_IFB_CAST";
		visAlpha		= 1;
		emtrjmode_s 	= "TARGET";
     	emtrjtargetnode 		= "BIP01 FIRE";
     	emtrjloopmode_s 		= "NONE";
     	emtrjeasefunc_s 		= "LINEAR";
		emTrjDynUpdateDelay	= 20000;
     	emCheckCollision 		= 2;					// [EDENFELD, neu] 2: Coll, aber keinen Schaden abziehen (n�tig, da dieser FX nicht als Child eingef�gt wurde, sondern komplett
     													// unabh�ngig mit Coll in die Welt gesetzt wurde. Der Schaden wird aber schon von spellFX_InstantFireball berechnet.)
		emActionCollDyn_S 		= "COLLIDE";
		emActionCollStat_S 		= "COLLIDE";
		};

		INSTANCE spellFX_Deathball_FIRECLOUD_KEY_COLLIDE (C_ParticleFXEmitKey)
		{
		     	emtrjeasevel 			= 0.000001;
};

// KOLLISION MIT STATISCHER WELT:  KEINE PERCEPTION

instance spellFX_Deathball_COLLIDE		(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		emTrjOriginNode		= "BIP01";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_Deathball_COLLIDE_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};

// KOLLISION MIT DYNAMISCHER WELT:  WOHL PERCEPTION

instance spellFX_Deathball_COLLIDEDYNFX	(CFx_Base_Proto)
{
		visname_S 			= "MFX_Fireball_Collide1";
		visAlpha			= 1;
		emTrjOriginNode		= "BIP01";
		emtrjmode_s 		= "FIXED";
		lightPresetname   	= "FIRESMALL";
};

INSTANCE spellFX_Deathball_COLLIDEDYNFX_KEY_INVEST_1	(C_ParticleFXEmitKey)  {	visname_S 	= "MFX_Fireball_Collide1";		sfxid	= "MFX_Fireball_Collide1";		};





///   													XXXXXXXXXXXXXXXXXXXX
///   													XXXXXXXXXXXXXXXXXXXX
///   													XX  G L O B A L   XX
///   													XXXXXXXXXXXXXXXXXXXX
///   													XXXXXXXXXXXXXXXXXXXX



// HUMAN oder VOB brennt nach Feuerschaden (-> diese Instanz wird auf einem NSC/Monster gestartet, wenn er mit einem Feuerschaden Visual/Spell getroffen wird

INSTANCE VOB_BURN			(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 FIRE";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD1";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "FIRESMALL";
	sfxid				= "MFX_Firespell_Humanburn";
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD1	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R UPPERARM";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD2";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD2	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L UPPERARM";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD3";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD3	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L HAND";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD4";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD4	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R HAND";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD5";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD5	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L FOOT";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "VOB_BURN_CHILD6";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_BURN_CHILD6	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R FOOT";
	visname_S 			= "MFX_Firespell_HUMANBURN";
	emFXCreate_S 		= "spellFX_Firespell_HUMANSMOKE";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};


// HUMAN oder VOB brennt nach Magie-schaden (-> diese Instanz wird auf einem NSC/Monster gestartet, wenn er mit einem Feuerschaden Visual/Spell getroffen wird

INSTANCE VOB_MAGICBURN			(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 FIRE";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD1";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	lightpresetname		= "FIRESMALL";
	sfxid				= "MFX_Firespell_Humanburn";
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD1	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R UPPERARM";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD2";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD2	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L UPPERARM";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD3";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD3	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L HAND";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD4";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD4	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R HAND";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD5";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD5	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 L FOOT";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "VOB_MAGICBURN_CHILD6";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	//emAdjustShpToOrigin = 1;
};

INSTANCE VOB_MAGICBURN_CHILD6	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 R FOOT";
	visname_S 			= "MFX_MagicFire_HUMANBURN";
	emFXCreate_S 		= "spellFX_MagicFire_HUMANSMOKE";
	emFXCreatedOwnTrj 	= 1;
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	sendAssessMagic		= 1;
	//emAdjustShpToOrigin = 1;
};



INSTANCE spellFX_MagicFire_HUMANSMOKE	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 FIRE";
	visname_S 			= "MFX_MagicFire_HUMANSMOKE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	emAdjustShpToOrigin = 1;
};


INSTANCE spellFX_Firespell_HUMANSMOKE	(CFx_Base_Proto)
{
	emTrjOriginNode 	= "BIP01 FIRE";
	visname_S 			= "MFX_Firespell_HUMANSMOKE";
	emtrjmode_s 		= "FIXED";
	emtrjdynupdatedelay = 0.;
	emAdjustShpToOrigin = 1;
};


// HUMAN oder VOB ist elektrisiert von ThunderSpell

instance spellFX_Lightning_TARGET			(CFx_Base_Proto)
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 Head";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sfxid			= "MFX_Lightning_Target";
		emfxcreate_s	= "spellFX_Thunderspell_TARGET_CHILD1";
};

instance spellFX_Thunderspell_SENDPERCEPTION			(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 Head";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		sendAssessMagic	= 1;
		sfxid			= "MFX_Lightning_Target";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD1";
		emFXCreatedOwnTrj 	= 1;
};


instance spellFX_Thunderspell_SENDPERCEPTION_CHILD1		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 R UPPERARM";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD2";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD2		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 L UPPERARM";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD3";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD3		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 L HAND";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD4";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD4		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 R HAND";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD5";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD5		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 L FOOT";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD6";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD6		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 R FOOT";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD7";
		emFXCreatedOwnTrj 	= 1;
};
instance spellFX_Thunderspell_TARGET_CHILD7		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 L THIGH";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD8";
		emFXCreatedOwnTrj 	= 1;
};
instance spellFX_Thunderspell_TARGET_CHILD8		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 R THIGH";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD9";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD9		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 L CALF";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD10";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD10		(CFx_Base_Proto)			// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01 R CALF";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emfxcreate_s	= "spellFX_Thunderspell_SENDPERCEPTION_CHILD11";
		emFXCreatedOwnTrj 	= 1;
};

instance spellFX_Thunderspell_TARGET_CHILD11		(CFx_Base_Proto)		// geh�rt zu FX-Kette. DO NOT DELETE
{
		visname_S 		= "MFX_Thunderball_Target";
		emTrjOriginNode = "BIP01";
		visAlpha		= 1;
		emtrjmode_s 	= "FIXED";
		emFXCreatedOwnTrj 	= 1;
};



// HUMAN oder VOB ist eingefroren von IceSpell


instance spellFX_IceSpell_SENDPERCEPTION(CFx_Base_Proto)
{
		visname_S 			= "MFX_IceSpell_Target";
		visAlpha			= 1;
		emtrjmode_s 		= "FIXED";
		sendAssessMagic		= 1;
		emAdjustShpToOrigin = 1;
		sfxid				= "MFX_Icecube_Target";

};

// Earth Quake FX

INSTANCE FX_EarthQuake(CFx_Base_Proto)
{
	visName_S 		= 	"earthquake.eqk";
	userString[0]	= 	"1000";
	userString[1]	=	"5";
	userString[2]	=	"5 5 5";
	sfxid			= 	"MFX_EarthQuake";
	sfxIsAmbient	=	1;
};

// Various FX

INSTANCE CONTROL_LEAVERANGEFX(CFx_Base_Proto)
{
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "1";
	userString[1]	=	"0 100 0 100";
	userString[2]	=	"0.5";
};

INSTANCE CONTROL_CASTBLEND(CFx_Base_Proto)
{
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "0.5";
	userString[1]	=	"255 255 255 255";
	userString[2]	=	"0.5";
	emFXLifeSpan    =	0.6;
};

INSTANCE TRANSFORM_CASTBLEND(CFx_Base_Proto)
{
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "0.5";
	userString[1]	=	"255 0 0 255";
	userString[2]	=	"0.5";
	emFXLifeSpan    =	0.6;
};

INSTANCE TRANSFORM_NOPLACEFX(CFx_Base_Proto)
{
	visName_S 		= 	"screenblend.scx";
	userString[0]	=   "1";
	userString[1]	=	"255 0 0 100";
	userString[2]	=	"1.5";
	emFXLifeSpan    =	0.6;
};


INSTANCE DEMENTOR_FX(CFx_Base_Proto)
{
 	// userstring 0: screenblend loop duration
 	// userstring 1: screenblend color
 	// userstring 2: screenblend in/out duration
 	// userstring 3: screenblend texture
 	// userstring 4: tex ani fps
 	visName_S      		= "screenblend.scx";
	emfxcreate_s		= "FOV_MORPH1";
 	userString[0]     	= "100000000000";
 	userString[1]     	= "0 0 0 100";
 	userString[2]     	= "0.5";
 	userString[3]     	= "ScreenFX_Dem_a0";
 	userString[4]     	= "8";
 	visAlphaBlendFunc_S = "BLEND";
 	sfxid      			= "Dementhor_Talk";
 	sfxisambient     	= 1;
};

INSTANCE FOV_MORPH1(CFx_Base_Proto)
{
 	// userstring 0: fov morph amplitude scaler
 	// userstring 1: fov morph speed scaler
 	// userString 2: fov base x (leave empty for default)
 	// userString 3: fov base y (leave empty for default)

 	visName_S      		= "morph.fov";
 	userString[0]     	= "1.0";
 	userString[1]     	= "1.0";
 	userString[2]		= "90";
 	userString[3]		= "67";
};


INSTANCE FOV_MORPH2(CFx_Base_Proto)
{
 	// userstring 0: fov morph amplitude scaler
 	// userstring 1: fov morph speed scaler
 	// userString 2: fov base x (leave empty for default)
 	// userString 3: fov base y (leave empty for default)

 	visName_S      		= "morph.fov";
 	userString[0]     	= "0.8";
 	userString[1]     	= "1.0";
 	userString[2]		= "120";
 	userString[3]		= "90";
};


INSTANCE SLOW_MOTION(CFx_Base_Proto)
{
	// userstring 0: world  time scaler
	// userstring 1: player time scaler

 	visName_S      		= "time.slw";
 	userString[0]     	= "0.5";
 	userString[1]     	= "1.0";
 	emFxCreate_s		= "FOV_MORPH2";
	emFXLifeSpan    	= 15;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
	emFXTriggerDelay	= 3;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
};


INSTANCE FOCUS_HIGHLIGHT(CFx_Base_Proto)
{
	visname_S 			= "FOCUS_HIGHLIGHT.TGA";
	visSize_S			= "100 100";
	emAdjustShpToOrigin = 1;

	emtrjmode_s 		= "FIXED";
	emTrjOriginNode 	= "BIP01";
	emTrjTargetRange	= 0;
	emTrjTargetElev 	= 0;
};


INSTANCE SLOW_TIME(CFx_Base_Proto)
{
	// userstring 0: world  time scaler
	// userstring 1: player time scaler
 	visName_S      		= "time.slw";
 	userString[0]     	= "0.5";
 	userString[1]     	= "0.5";
	emFXLifeSpan    	= 30;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
	emFXTriggerDelay	= 6;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
	emFXCreate_S		= "SLOW_TIME_CHILD";
	emTrjOriginNode 	= "BIP01";
};


INSTANCE SLOW_TIME_CHILD(CFx_Base_Proto)
{
	// userstring 0: world  time scaler
	// userstring 1: player time scaler
 	visName_S      		= "SMOKE_JOINT_SLOW_TIME";
	emFXTriggerDelay	= 6;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
 	sfxid      			= "MFX_Telekinesis_StartInvest";
 	sfxisambient     	= 1;
	emFXCreate_S		= "SLOW_TIME_CHILD2";
};


INSTANCE SLOW_TIME_CHILD2(CFx_Base_Proto)
{
	// userstring 0: world  time scaler
	// userstring 1: player time scaler
	emFXTriggerDelay	= 6;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
	emFXLifeSpan    	= 30;						// achtung, zeitdauer ist hier skaliert mit dem time scaler
 	visName_S      		= "morph.fov";
 	userString[0]     	= "0.8";
 	userString[1]     	= "1.0";
 	userString[2]		= "120";
 	userString[3]		= "90";
};


// Used by PlayVideoEx(..., TRUE, ...);

INSTANCE BLACK_SCREEN(CFx_Base_Proto)
{
 	// userstring 0: screenblend loop duration
 	// userstring 1: screenblend color
 	// userstring 2: screenblend in/out duration
 	// userstring 3: screenblend texture
 	// userstring 4: tex ani fps
 	visName_S      		= "screenblend.scx";
 	userString[0]     	= "100000000000";
 	userString[1]     	= "0 0 0 255";
 	userString[2]     	= "0";
 	visAlphaBlendFunc_S = "BLEND";
	emFXLifeSpan    	= 2;						// Dauer is Sekunden (�ber timer skaliert)
};


// Used by Sleepabit (im Moment deaktiviert)

INSTANCE SLEEP_BLEND(CFx_Base_Proto)
{
 	// userstring 0: screenblend loop duration
 	// userstring 1: screenblend color
 	// userstring 2: screenblend in/out duration
 	// userstring 3: screenblend texture
 	// userstring 4: tex ani fps
 	visName_S      		= "screenblend.scx";
 	userString[0]     	= "100000000000";
 	userString[1]     	= "0 0 0 255";
 	userString[2]     	= "0";
 	visAlphaBlendFunc_S = "BLEND";
	emFXLifeSpan    	= 2;						// Dauer is Sekunden (�ber timer skaliert)
};


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
///
///		Modell/Item-Effekte (Addon)
///
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


INSTANCE SPELLFX_FIREARMOR (CFX_BASE_PROTO)
{
     visname_s				= "FIRE_MODEL_KAIRO";
     visalpha				= 1;
     visalphablendfunc_s	= "ADD";
     emtrjmode_s			= "FIXED";
     emtrjoriginnode		= "=";
     emtrjtargetrange		= 10;
     emtrjnumkeys			= 10;
     emtrjloopmode_s		= "NONE";
     emtrjeasefunc_s		= "LINEAR";
     emtrjdynupdatedelay	= 2000000;
     emfxlifespan			= -1;
     emselfrotvel_s			= "0 0 0";
     lightpresetname		= "FIRESMALL";//Joly: nicht FIRE
     secsperdamage			= -1;
     emAdjustShpToOrigin	= 1;
     
     emFXCreate_S			= "SPELLFX_FIREARMOR_SMOKE";
     
};

INSTANCE SPELLFX_FIREARMOR_KEY_CAST (C_PARTICLEFXEMITKEY)
{
     lightrange				= 500;
};


INSTANCE SPELLFX_FIREARMOR_SMOKE (CFX_BASE_PROTO)
{
     visname_s				= "SMOKE_MODEL_KAIRO";
     visalpha				= 1;
     visalphablendfunc_s	= "ADD";
     emtrjmode_s			= "FIXED";
     emtrjoriginnode		= "=";
     emtrjtargetrange		= 10;
     emtrjnumkeys			= 10;
     emtrjloopmode_s		= "NONE";
     emtrjeasefunc_s		= "LINEAR";
     emtrjdynupdatedelay	= 2000000;
     emfxlifespan			= -1;
     emselfrotvel_s			= "0 0 0";
     lightpresetname		= "FIRESMALL";//Joly: nicht FIRE
     secsperdamage			= -1;
     emAdjustShpToOrigin	= 1;
};

INSTANCE SPELLFX_FIREARMOR_SMOKE_KEY_CAST (C_PARTICLEFXEMITKEY)
{
     lightrange				= 500;
};

////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_FIRESWORD (CFX_BASE_PROTO)
{
	visname_S 				= "FIRE_SWORD";
	visAlpha				= 1;
	emtrjmode_s				= "FIXED";
	lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};
INSTANCE SPELLFX_FIRESWORDBLACK (CFX_BASE_PROTO)
{
	visname_S 				= "FIRE_SWORDBLACK";
	visAlpha				= 1;
	emtrjmode_s				= "FIXED";
	//lightPresetname			= "JUSTWHITE";
	emAdjustShpToOrigin		= 1;
};
INSTANCE SPELLFX_FIRESWORDBLACK_KEY_CAST (C_PARTICLEFXEMITKEY)
{
     lightrange				= 200;
};

INSTANCE SPELLFX_FIRESWORD_ATTACK (CFX_BASE_PROTO)
{
	visname_S				= "FIRE_SWORD_ATTACK";
	emTrjOriginNode			= "ZS_RIGHTHAND";
	visAlpha				= 1;
	emtrjmode_s				= "FIXED";
	emAdjustShpToOrigin 	= 1;
};

INSTANCE SPELLFX_FIRESWORD_HIT (CFX_BASE_PROTO)
{
	visname_S				= "FIRE_SWORD_HIT";
	emTrjOriginNode			= "ZS_RIGHTHAND";
	visAlpha				= 1;
	emtrjmode_s				= "FIXED";
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_FIRESWORD_KEY_CAST (C_ParticleFxEmitKey)
{
	lightrange				= 500;
};

// Wegstecken
INSTANCE SPELLFX_FIRESWORD_KEY_INVEST_1 (C_ParticleFxEmitKey)	
{
	visname_S				= "FIRE_SWORD";
	lightrange				= 100;
	pfx_ppsValue			= 100;
};

// Ziehen
INSTANCE SPELLFX_FIRESWORD_KEY_INVEST_2 (C_PARTICLEFXEMITKEY)	
{
	visname_S				= "FIRE_SWORD";
	lightrange				= 300;
	pfx_ppsValue			= 150;
};

// Schlagen
INSTANCE SPELLFX_FIRESWORD_KEY_INVEST_3 (C_PARTICLEFXEMITKEY)	
{
	emCreateFXID			= "SPELLFX_FIRESWORD_ATTACK";
	lightrange				= 400;
};

// Treffer
INSTANCE SPELLFX_FIRESWORD_KEY_INVEST_4 (C_PARTICLEFXEMITKEY)	
{
	emCreateFXID			= "SPELLFX_FIRESWORD_HIT";
	lightrange				= 600;
	pfx_ppsValue			= 300;
};

// Ende
INSTANCE SPELLFX_FIRESWORD_KEY_INVEST_5 (C_PARTICLEFXEMITKEY)	
{
	visname_S				= "FIRE_SWORD";
	lightrange				= 100;
	pfx_ppsValue			= 150;
};

//***************************************************************************


INSTANCE SPELLFX_MAGESTAFF1 (CFX_BASE_PROTO)
{
	visname_S 			= "MAGESTAFF1";
	visAlpha			= 1;
	emtrjmode_s			= "FIXED";
	//Joly:lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_MAGESTAFF2 (CFX_BASE_PROTO)
{
	visname_S 			= "MAGESTAFF2";
	visAlpha			= 1;
	emtrjmode_s			= "FIXED";
	//Joly:lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_MAGESTAFF3 (CFX_BASE_PROTO)
{
	visname_S 			= "MAGESTAFF3";
	visAlpha			= 1;
	emtrjmode_s			= "FIXED";
	//Joly:lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_MAGESTAFF4 (CFX_BASE_PROTO)
{
	visname_S 			= "MAGESTAFF4";
	visAlpha			= 1;
	emtrjmode_s			= "FIXED";
	//Joly:lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_MAGESTAFF5 (CFX_BASE_PROTO)
{
	visname_S 			= "MAGESTAFF5";
	visAlpha			= 1;
	emtrjmode_s			= "FIXED";
	//Joly:lightPresetname			= "FIRESMALL";
	emAdjustShpToOrigin		= 1;
};




////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_BOW (CFX_BASE_PROTO)
{
	visname_s			= "MAGIC_BOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_FIREBOW (CFX_BASE_PROTO)
{
	visname_s			= "FIRE_BOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};


INSTANCE SPELLFX_ARROW (CFX_BASE_PROTO)
{
	visname_s			= "MAGIC_ARROW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
	lightpresetname			= "AURA";
};

// NSC wird anvisiert
INSTANCE SPELLFX_ARROW_KEY_INVEST_1 (C_ParticleFxEmitKey)	
{
	lightrange			= 100;
};

// Pfeil schiesst los
INSTANCE SPELLFX_ARROW_KEY_INVEST_2 (C_PARTICLEFXEMITKEY)	
{
	lightrange			= 300;
};

// Pfeil kollidiert
INSTANCE SPELLFX_ARROW_KEY_INVEST_3 (C_PARTICLEFXEMITKEY)	
{
	lightrange			= 400;
};



INSTANCE SPELLFX_FIREARROW (CFX_BASE_PROTO)
{
	visname_s			= "FIRE_ARROW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
	lightpresetname			= "FIRESMALL";
};


// NSC wird anvisiert
INSTANCE SPELLFX_FIREARROW_KEY_INVEST_1 (C_ParticleFxEmitKey)	
{
	lightrange			= 100;
};

// Pfeil schiesst los
INSTANCE SPELLFX_FIREARROW_KEY_INVEST_2 (C_PARTICLEFXEMITKEY)	
{
	lightrange			= 300;
};

// Pfeil kollidiert
INSTANCE SPELLFX_FIREARROW_KEY_INVEST_3 (C_PARTICLEFXEMITKEY)	
{
	lightrange			= 400;
};




////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_CROSSBOW (CFX_BASE_PROTO)
{
	visname_s			= "MAGIC_CROSSBOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_BOLT (CFX_BASE_PROTO)
{
	visname_s			= "MAGIC_BOLT";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
	lightpresetname			= "AURA";
};

INSTANCE SPELLFX_BOLT_KEY_CAST (C_PARTICLEFXEMITKEY)
{
	lightrange				= 200;
};

////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_ITEMGLIMMER (CFX_BASE_PROTO)
{
	visname_s			= "ITEM_GLIMMER";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};


////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_MANAPOTION (CFX_BASE_PROTO)
{
	visname_s			= "MANA_POTION";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_HEALTHPOTION (CFX_BASE_PROTO)
{
	visname_s			= "HEALTH_POTION";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_YELLOWPOTION (CFX_BASE_PROTO)
{
	visname_s			= "YELLOW_POTION";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};

////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_WEAKGLIMMER (CFX_BASE_PROTO)
{
	visname_s			= "WEAK_GLIMMER";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_WEAKGLIMMER_RED (CFX_BASE_PROTO)
{
	visname_s			= "WEAK_GLIMMER_RED";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_WEAKGLIMMER_BLUE (CFX_BASE_PROTO)
{
	visname_s			= "WEAK_GLIMMER_BLUE";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_WEAKGLIMMER_YELLOW (CFX_BASE_PROTO)
{
	visname_s			= "WEAK_GLIMMER_YELLOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};

INSTANCE SPELLFX_ITEMSTARS (CFX_BASE_PROTO)
{
	visname_s			= "ITEM_STARS";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 0.1;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
INSTANCE SPELLFX_ITEMSTARS_RED (CFX_BASE_PROTO)
{
	visname_s			= "ITEM_STARS_RED";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 0.1;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
INSTANCE SPELLFX_ITEMSTARS_BLUE (CFX_BASE_PROTO)
{
	visname_s			= "ITEM_STARS_BLUE";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 0.1;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};
INSTANCE SPELLFX_ITEMSTARS_YELLOW (CFX_BASE_PROTO)
{
	visname_s			= "ITEM_STARS_YELLOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 0.1;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	emAdjustShpToOrigin		= 1;
};


////////////////////////////////////////////////////////////////////////////////

INSTANCE SPELLFX_GLOW (CFX_BASE_PROTO)
{
	visname_s			= "GOLD_GLOW";
	visalpha			= 1;
	visalphablendfunc_s		= "ADD";
	emtrjmode_s			= "FIXED";
	emtrjloopmode_s			= "NONE";
	emtrjeasefunc_s			= "LINEAR";
	emtrjdynupdatedelay		= 2000000;
	emfxlifespan			= -1;
	emselfrotvel_s			= "0 0 0";
	secsperdamage			= -1;
	lightpresetname			= "JUSTWHITE";
};

INSTANCE SPELLFX_GLOW_KEY_CAST (C_PARTICLEFXEMITKEY)
{
	lightrange				= 100;
};


INSTANCE SPELLFX_UNDEAD_DRAGON(CFX_BASE_PROTO)
{
     visname_s			= "UNDEAD_DRAGON";
     visalpha			= 1;
     visalphablendfunc_s	= "ADD";
     emtrjmode_s		= "FIXED";
     emtrjoriginnode		= "=";
     emtrjtargetrange		= 10;
     emtrjnumkeys		= 10;
     emtrjloopmode_s		= "NONE";
     emtrjeasefunc_s		= "LINEAR";
     emtrjdynupdatedelay	= 2000000;
     emfxlifespan		= -1;
     emselfrotvel_s		= "0 0 0";
     lightpresetname		= "AURA";//Joly: nicht FIRE
     secsperdamage		= -1;
     emAdjustShpToOrigin	= 1;
     emFXCreate_S		= "SPELLFX_DRAGONEYE_LEFT";
     emFXCreatedOwnTrj		= 1;				// alle children dieses fx haben eine eigene flugbahn!!!
          
};

INSTANCE SPELLFX_DRAGONEYE_LEFT(CFX_BASE_PROTO)
{
     visname_s			= "DRAGON_EYE_LEFT";
     visalpha			= 1;
     visalphablendfunc_s	= "ADD";
     emtrjmode_s		= "FIXED";
     emtrjoriginnode		= "BIP01 HEAD";
     emtrjtargetrange		= 10;
     emtrjnumkeys		= 10;
     emtrjloopmode_s		= "NONE";
     emtrjeasefunc_s		= "LINEAR";
     emtrjdynupdatedelay	= 2000000;
     emfxlifespan		= -1;
     emselfrotvel_s		= "0 0 0";
     secsperdamage		= -1;
     emAdjustShpToOrigin	= 1;
     emFXCreate_S		= "SPELLFX_DRAGONEYE_RIGHT";
     emFXCreatedOwnTrj		= 1;				// alle children dieses fx haben eine eigene flugbahn!!!
};

INSTANCE SPELLFX_DRAGONEYE_RIGHT(CFX_BASE_PROTO)
{
     visname_s			= "DRAGON_EYE_RIGHT";
     visalpha			= 1;
     visalphablendfunc_s	= "ADD";
     emtrjmode_s		= "FIXED";
     emtrjoriginnode		= "BIP01 HEAD";
     emtrjtargetrange		= 10;
     emtrjnumkeys		= 10;
     emtrjloopmode_s		= "NONE";
     emtrjeasefunc_s		= "LINEAR";
     emtrjdynupdatedelay	= 2000000;
     emfxlifespan		= -1;
     emselfrotvel_s		= "0 0 0";
     secsperdamage		= -1;
     emAdjustShpToOrigin	= 1;
     emFXCreatedOwnTrj		= 1;				// alle children dieses fx haben eine eigene flugbahn!!!
};



INSTANCE SPELLFX_UNDEAD_DRAGON_KEY_CAST (C_PARTICLEFXEMITKEY)
{
     lightrange				= 500;
};






////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


INSTANCE SPELLFX_WATERFIST_CAST(CFx_Base)
{
};


///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///   													XX  I N V I S I B L E   P R O J E C T I L E   XX
///   													XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


instance spellFX_InvisibleProjectile		(CFx_Base_Proto)
{
	emtrjeasevel 		= 1400.;
	visname_S 		= "MFX_INVISIBLEPROJECTILE";
	visAlpha		= 1;
	emtrjmode_s 		= "TARGET";
     	emtrjtargetnode 	= "BIP01 FIRE";
     	emtrjloopmode_s 	= "NONE";
     	emtrjeasefunc_s 	= "LINEAR";
	emTrjDynUpdateDelay	= 20000;
     	emCheckCollision 	= 2;					// [EDENFELD, neu] 2: Coll, aber keinen Schaden abziehen (n�tig, da dieser FX nicht als Child eingef�gt wurde, sondern komplett
     													// unabh�ngig mit Coll in die Welt gesetzt wurde. Der Schaden wird aber schon von spellFX_InstantFireball berechnet.)
	emActionCollDyn_S 	= "COLLIDE";
	emActionCollStat_S 	= "COLLIDE";
	};

	INSTANCE spellFX_InvisibleProjectile_KEY_COLLIDE (C_ParticleFXEmitKey)
	{
	     	emtrjeasevel 			= 0.000001;
};

// Sonja

instance spellFX_SummonSonja		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonSonja_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonSonja_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonSonja_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonSonja_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonSonja_ORIGIN";
			pfx_ppsisloopingchg = 1;
};

instance spellFX_SummonDragon		(CFx_Base_Proto)
{
		visname_S 			= "MFX_ArmyOfDarkness_INIT";
		visAlpha			= 1;

		emtrjmode_s 		= "FIXED";
		emTrjOriginNode 	= "ZS_RIGHTHAND";
		LightPresetname 	= "REDAMBIENCE";

		};

		instance spellFX_SummonDragon_KEY_OPEN	(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonDragon_KEY_INIT		(C_ParticleFXEmitKey)
		{
				LightRange = 0.01;
		};

		instance spellFX_SummonDragon_KEY_INVEST_1 (C_ParticleFXEmitKey)
		{
			LightRange = 200;
			emCreateFXID = 	"FX_EarthQuake";
		};
		instance spellFX_SummonDragon_KEY_CAST		(C_ParticleFXEmitKey)
		{
			emCreateFXID		= "spellFX_SummonDragon_ORIGIN";
			pfx_ppsisloopingchg = 1;
};
