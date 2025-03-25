pageextension 50103 "DUR Item Reference List Ext" extends "Item Reference Entries"
{
    layout
    {
        addbefore("Reference Type")
        {
            field("DUR Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Reference No.")
        {
            field("DUR Delete"; Rec."DUR Delete")
            {
                ApplicationArea = All;
                Caption = 'DUR Delete';
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