table 99926 "LC Setup"
{
    Caption = 'LC Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Detail Nos."; Code[10])
        {
            Caption = 'Detail Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Amended Nos."; Code[10])
        {
            Caption = 'Amended Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

