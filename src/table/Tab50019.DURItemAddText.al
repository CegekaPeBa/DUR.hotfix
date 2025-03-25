table 50019 "DUR Item AddText"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
            DataClassification = CustomerContent;

        }
        field(10; AddText; Text[2048])
        {
            Caption = 'AdditionalText';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; ItemNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}