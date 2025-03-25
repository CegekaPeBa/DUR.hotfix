// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 DURBaseSetupExt extends "DUR Base Setup"
{
    layout
    {
        // Add changes to page layout here
    }


    actions
    {
        addfirst(Processing)
        {
            action(Hotfix)
            {
                Caption = 'Hotfix ausführen';
                Image = DataEntry;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DURHotfix: codeunit "DUR Hotfix";
                begin
                    DURHotfix.Run();
                end;

            }
        }
    }

}