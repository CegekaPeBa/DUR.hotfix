codeunit 50030 "DUR Hotfix"
{
    Permissions = tabledata "Fixed Asset" = rimd,
                tabledata "TFixed Asset" = r;

    trigger OnRun()
    begin
        if Confirm('Hotfix Codeunit ausführen?', false) then begin

            // DataImportFixedAsset();
            DeleteItemRefs();
            //ChangePricelistUoM();
            // if Confirm('AddText ausführen?', false) then
            //     DataImportAddText();
        end;
    end;

    local procedure DataImportFixedAsset()
    var
        FixedAssetOrig: Record "Fixed Asset";
        TFixedAsset: Record "TFixed Asset";
        Counter: BigInteger;
    begin
        FixedAssetOrig.Reset();
        if FixedAssetOrig.FindFirst() then
            repeat
                if TFixedAsset.Get(FixedAssetOrig."No.") then begin
                    FixedAssetOrig."DUR English Description" := TFixedAsset."English Description";
                    FixedAssetOrig."DUR DataStream No." := TFixedAsset."DataStream No.";
                    FixedAssetOrig."DUR Tag No." := TFixedAsset."Tag No.";
                    Counter += 1;
                    FixedAssetOrig.Modify();
                end;

            until FixedAssetOrig.Next() = 0;
        Message('%1 Datensätze wurden aktualisiert!', Counter);
    end;

    local procedure DataImportAddText()
    var
        Item: Record Item;
        AddText: Record "DUR Item AddText";
    begin
        AddText.Reset();
        if AddText.FindFirst() then
            repeat
                if AddText.AddText <> '' then
                    if Item.Get(AddText.ItemNo) then
                        Item.SetAddDescription(AddText.AddText);
            until AddText.Next() = 0;
    end;

    local procedure DeleteItemRefs()
    var
        Item: Record Item;
        ItemRef: Record "Item Reference";
        ItemRef2: Record "Item Reference";
        ItemRef3: Record "Item Reference";
        ItemUMeasure: Record "Item Unit of Measure";
        ItemCount: Integer;
        BehaltenCount: Integer;
        Searchtext: Text[50];
        Del: Boolean;
    begin
        ItemRef.Reset();
        ItemRef.ModifyAll("DUR Delete", '');

        ItemRef.SetFilter("Item No.", 'IH_*');
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Vendor);
        ItemRef.SetFilter("Reference No.", '''''');
        ItemRef.SetFilter(Description, '''''');
        ItemRef.SetFilter("DUR Vendor Item Type No.", '''''');
        ItemRef.ModifyAll("DUR Delete", 'löschen');
        //ItemRef.DeleteAll();

        Item.Reset();
        Item.SetFilter("No.", 'IH_*');
        if Item.FindSet() then
            repeat
                ItemRef2.Reset();
                ItemRef2.SetRange("Item No.", Item."No.");
                ItemRef2.SetFilter("Variant Code", '''''');
                ItemRef2.SetRange("Reference Type", ItemRef."Reference Type"::Vendor);
                ItemRef2.SetFilter("DUR Delete", '''''');
                // ItemCount := ItemRef2.Count();
                if ItemRef2.FindSet() then
                    repeat
                        ItemRef2.Setrange("Reference Type No.", ItemRef2."Reference Type No.");
                        ItemCount := ItemRef2.Count();
                        if ItemCount > 1 then begin
                            ItemRef3.CopyFilters(ItemRef2);
                            // ItemRef3.SetFilter("DUR Delete", '');
                            //ItemRef3.SetFilter("Reference No.", '<>''''');
                            ItemRef3.SetFilter("DUR Vendor Item Type No.", '<>''''');
                            BehaltenCount := ItemRef3.Count();
                            if BehaltenCount > 0 then
                                ItemRef3.ModifyAll("DUR Delete", 'behalten');
                            ItemRef3.SetFilter("DUR Delete", '''''');
                            ItemRef3.SetRange("Reference No.");
                            ItemRef3.SetRange("DUR Vendor Item Type No.");
                            if ItemRef3.FindFirst() then
                                repeat
                                    if BehaltenCount > 0 then begin
                                        ItemRef3."DUR Delete" := 'löschen';
                                        ItemRef3.Modify();
                                    end;
                                until ItemRef3.Next() = 0;
                            if ItemRef3.FindFirst() then
                                repeat
                                    Searchtext := ItemRef3."Reference No.";
                                    if TextContainsChar(Searchtext, '/-#+*%$') then begin
                                        ItemRef3."DUR Delete" := 'behalten';
                                        ItemRef3.Modify();
                                        BehaltenCount += 1;
                                    end;
                                until ItemRef3.Next() = 0;
                            if BehaltenCount > 0 then begin
                                ItemRef3."DUR Delete" := 'löschen';
                                ItemRef3.Modify();
                            end;
                        end else begin
                            ItemRef2."DUR Delete" := 'behalten';
                            ItemRef2.Modify();
                        end;
                        if not ItemUMeasure.Get(ItemRef2."Item No.", ItemRef2."Unit of Measure") then begin
                            ItemRef2."DUR Delete" := 'löschen';
                            ItemRef2.Modify();
                        end;
                        ItemRef2.Setrange("Reference Type No.");
                    until ItemRef2.Next() = 0;
            // if Item.Get(ItemRef."Item No.") then
            //     if Item."Base Unit of Measure" <> ItemRef."Unit of Measure" then
            //         ItemRef.Delete();
            until Item.Next() = 0;
    end;

    local procedure TextContainsChar(SearchText: Text[50]; SearchChars: Text[10]): Boolean
    var
        i: Integer;
        SearchChar: Char;
    begin
        for i := 1 to StrLen(SearchChars) do begin
            SearchChar := SearchChars[i];
            if SearchText.Contains(SearchChar) then
                exit(true);
        end;
        exit(false);
    end;

    local procedure ChangePricelistUoM()
    var
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
    begin
        PurchPrice.Reset();
        PurchPrice.SetFilter("Item No.", 'IH_*');
        if PurchPrice.FindFirst() then
            repeat
                if Item.Get(PurchPrice."Item No.") then
                    if Item."Base Unit of Measure" <> PurchPrice."Unit of Measure Code" then begin
                        PurchPrice."Unit of Measure Code" := Item."Base Unit of Measure";
                        PurchPrice.Modify();
                    end;
            until PurchPrice.Next() = 0;
    end;

    procedure DeleteItemRefTable()
    var
        ItemRef: Record "Item Reference";
        Count: Decimal;
    begin
        If Not Confirm('Item Reference löschen?', false) then
            exit;
        ItemRef.Reset();
        ItemRef.SetFilter("Item No.", 'IH_*');
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Vendor);
        ItemRef.SetRange("DUR Delete", 'löschen');
        Count := ItemRef.Count();
        ItemRef.DeleteAll();
        Message('%1 Datensätze gelöscht!', Count);
    end;

    var
}