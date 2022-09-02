var int Sonja_ItemsGiven_Chapter_1;
var int Sonja_ItemsGiven_Chapter_1_OldWorld;
var int Sonja_ItemsGiven_Chapter_1_AddOnWorld;
var int Sonja_ItemsGiven_Chapter_1_IrdorathWorld;
var int Sonja_ItemsGiven_Chapter_2;
var int Sonja_ItemsGiven_Chapter_2_OldWorld;
var int Sonja_ItemsGiven_Chapter_2_AddOnWorld;
var int Sonja_ItemsGiven_Chapter_2_IrdorathWorld;
var int Sonja_ItemsGiven_Chapter_3;
var int Sonja_ItemsGiven_Chapter_3_OldWorld;
var int Sonja_ItemsGiven_Chapter_3_AddOnWorld;
var int Sonja_ItemsGiven_Chapter_3_IrdorathWorld;
var int Sonja_ItemsGiven_Chapter_4;
var int Sonja_ItemsGiven_Chapter_4_OldWorld;
var int Sonja_ItemsGiven_Chapter_4_AddOnWorld;
var int Sonja_ItemsGiven_Chapter_4_IrdorathWorld;
var int Sonja_ItemsGiven_Chapter_5;
var int Sonja_ItemsGiven_Chapter_5_OldWorld;
var int Sonja_ItemsGiven_Chapter_5_AddOnWorld;
var int Sonja_ItemsGiven_Chapter_5_IrdorathWorld;

FUNC VOID B_GiveTradeInv_Sonja_Chapter_1 (var C_NPC slf)
{
    CreateInvItems (slf, ItMi_Gold, 100);
    CreateInvItems (slf,ItPo_Mana_01 	,10);
    CreateInvItems (slf,ItPo_Health_01	,10);
    CreateInvItems (slf, ItPo_Health_Addon_04,	2);
    CreateInvItems (slf, ItPo_Mana_Addon_04,		2);
    CreateInvItems (slf,ItMi_ApfelTabak	,2); //für Abuyin

    // Useful items
    CreateInvItems (slf,ItMi_Broom			,1);
    CreateInvItems (slf,ItMi_Lute			,1);
    CreateInvItems (slf,ItMi_Brush			,1);
    CreateInvItems (slf,ItMw_2H_Axe_L_01			,1);
    CreateInvItems (slf,ItMw_1h_Bau_Axe			,1);
    CreateInvItems (slf,ItMw_1H_Mace_L_01			,1);
    CreateInvItems (slf,ItMi_Pan			,1);
    CreateInvItems (slf,ItMi_Stomper			,1);
    CreateInvItems (slf,ItMi_Pliers			,1);
    CreateInvItems (slf,ItMi_Scoop			,1);
    CreateInvItems (slf,ItMi_Saw			,1);
    CreateInvItems (slf,ItMi_IECello			,1);
    CreateInvItems (slf,ItMi_IECelloBow			,1);
    CreateInvItems (slf,ItMi_IEDrum			,1);
    CreateInvItems (slf,ItMi_IEDrumScheit			,1);
    CreateInvItems (slf,ItMi_IEDrumStick			,1);
    CreateInvItems (slf,ItMi_IEDudelBlau			,1);
    CreateInvItems (slf,ItMi_IEDudelGelb			,1);
    CreateInvItems (slf,ItMi_IEHarfe			,1);
    CreateInvItems (slf,ItMi_IELaute			,1);

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
};

FUNC VOID B_GiveTradeInv_Sonja_Chapter_2 (var C_NPC slf)
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
};

FUNC VOID B_GiveTradeInv_Sonja_Chapter_3 (var C_NPC slf)
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
};

FUNC VOID B_GiveTradeInv_Sonja_Chapter_4 (var C_NPC slf)
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
};

FUNC VOID B_GiveTradeInv_Sonja_Chapter_5 (var C_NPC slf)
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
};

FUNC VOID B_GiveTradeInv_Sonja (var C_NPC slf)
{
    if (CurrentLevel == OLDWORLD_ZEN)
    {
        if ((Kapitel >= 1)
        && (Sonja_ItemsGiven_Chapter_1_OldWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_1(slf);

            Sonja_ItemsGiven_Chapter_1_OldWorld = TRUE;
        };

        if ((Kapitel >= 2)
        && Sonja_ItemsGiven_Chapter_2_OldWorld == FALSE)
        {
            B_GiveTradeInv_Sonja_Chapter_2(slf);

            Sonja_ItemsGiven_Chapter_2_OldWorld = TRUE;
        };


        if ((Kapitel >= 3)
        && (Sonja_ItemsGiven_Chapter_3_OldWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_3(slf);

            Sonja_ItemsGiven_Chapter_3_OldWorld = TRUE;
        };

        if ((Kapitel >= 4)
        && (Sonja_ItemsGiven_Chapter_4_OldWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_4(slf);

            Sonja_ItemsGiven_Chapter_4_OldWorld = TRUE;
        };

        if ((Kapitel >= 5)
        && (Sonja_ItemsGiven_Chapter_5_OldWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_5(slf);

            Sonja_ItemsGiven_Chapter_5_OldWorld = TRUE;
        };
    }
    else if (CurrentLevel == NEWWORLD_ZEN)
    {
        if ((Kapitel >= 1)
        && (Sonja_ItemsGiven_Chapter_1 == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_1(slf);

            Sonja_ItemsGiven_Chapter_1 = TRUE;
        };

        if ((Kapitel >= 2)
        && Sonja_ItemsGiven_Chapter_2 == FALSE)
        {
            B_GiveTradeInv_Sonja_Chapter_2(slf);

            Sonja_ItemsGiven_Chapter_2 = TRUE;
        };

        if ((Kapitel >= 3)
        && (Sonja_ItemsGiven_Chapter_3 == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_3(slf);

            Sonja_ItemsGiven_Chapter_3 = TRUE;
        };

        if ((Kapitel >= 4)
        && (Sonja_ItemsGiven_Chapter_4 == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_4(slf);

            Sonja_ItemsGiven_Chapter_4 = TRUE;
        };

        if ((Kapitel >= 5)
        && (Sonja_ItemsGiven_Chapter_5 == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_5(slf);

            Sonja_ItemsGiven_Chapter_5 = TRUE;
        };
    }
    else if (CurrentLevel == ADDONWORLD_ZEN)
    {
        if ((Kapitel >= 1)
        && (Sonja_ItemsGiven_Chapter_1_AddOnWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_1(slf);

            Sonja_ItemsGiven_Chapter_1_AddOnWorld = TRUE;
        };

        if ((Kapitel >= 2)
        && Sonja_ItemsGiven_Chapter_2_AddOnWorld == FALSE)
        {
            B_GiveTradeInv_Sonja_Chapter_2(slf);

            Sonja_ItemsGiven_Chapter_2_AddOnWorld = TRUE;
        };

        if ((Kapitel >= 3)
        && (Sonja_ItemsGiven_Chapter_3_AddOnWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_3(slf);

            Sonja_ItemsGiven_Chapter_3_AddOnWorld = TRUE;
        };

        if ((Kapitel >= 4)
        && (Sonja_ItemsGiven_Chapter_4_AddOnWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_4(slf);

            Sonja_ItemsGiven_Chapter_4_AddOnWorld = TRUE;
        };

        if ((Kapitel >= 5)
        && (Sonja_ItemsGiven_Chapter_5_AddOnWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_5(slf);

            Sonja_ItemsGiven_Chapter_5_AddOnWorld = TRUE;
        };
    }
    else if (CurrentLevel == DRAGONISLAND_ZEN)
    {
        if ((Kapitel >= 1)
        && (Sonja_ItemsGiven_Chapter_1_IrdorathWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_1(slf);

            Sonja_ItemsGiven_Chapter_1_IrdorathWorld = TRUE;
        };

        if ((Kapitel >= 2)
        && Sonja_ItemsGiven_Chapter_2_IrdorathWorld == FALSE)
        {
            B_GiveTradeInv_Sonja_Chapter_2(slf);

            Sonja_ItemsGiven_Chapter_2_IrdorathWorld = TRUE;
        };

        if ((Kapitel >= 3)
        && (Sonja_ItemsGiven_Chapter_3_IrdorathWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_3(slf);

            Sonja_ItemsGiven_Chapter_3_IrdorathWorld = TRUE;
        };

        if ((Kapitel >= 4)
        && (Sonja_ItemsGiven_Chapter_4_IrdorathWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_4(slf);

            Sonja_ItemsGiven_Chapter_4_IrdorathWorld = TRUE;
        };

        if ((Kapitel >= 5)
        && (Sonja_ItemsGiven_Chapter_5_IrdorathWorld == FALSE))
        {
            B_GiveTradeInv_Sonja_Chapter_5(slf);

            Sonja_ItemsGiven_Chapter_5_IrdorathWorld = TRUE;
        };
    };
};
