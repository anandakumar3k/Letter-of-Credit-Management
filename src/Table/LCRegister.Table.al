table 99925 "LC Register"
{
    Caption = 'LC Register';

    fields
    {
        field(1; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }

    keys
    {
        key(Key1; "LC No.", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        NavigateForm: Page 344;

    procedure Navigate()
    begin
        NavigateForm.SetDoc("Posting Date", "Document No.");
        NavigateForm.RUN;
    end;
}

