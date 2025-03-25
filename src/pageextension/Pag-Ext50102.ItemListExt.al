pageextension 50102 ItemListExt extends "Item List"
{
    layout
    {
        addafter(InventoryField)
        {
            field(InventoryDUR; Rec.Inventory)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}