tableextension 50100 "DUR Item Reference Ext" extends "Item Reference"
{
    fields
    {
        field(50100; "DUR Delete"; Text[10])
        {
            Caption = 'DUR Delete';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}