pageextension 50101 DURDefaultDimensions extends "Default Dimensions"
{
    layout
    {
        addbefore("Dimension Code")
        {
            field("No."; Rec."No.")
            { }
            field("Table ID"; Rec."Table ID")
            { }
            field("Parent Type"; Rec."Parent Type")
            {
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