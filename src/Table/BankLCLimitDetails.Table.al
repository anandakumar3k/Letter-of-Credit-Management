table 99921 "LC Bank Limit Details"
{
    Caption = 'LC Bank Limit Details';

    fields
    {
        field(1; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            TableRelation = "Bank Account"."No.";
        }
        field(2; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TESTFIELD("From Date");
                TESTFIELD("To Date");
                CALCFIELDS("Amount Utilised", "Amount Utilised Amended");
                IF "Amount Utilised Amended" = 0 THEN
                    "Remaining Amount" := Amount - "Amount Utilised"
                ELSE
                    "Remaining Amount" := Amount - "Amount Utilised Amended";
            end;
        }
        field(5; "Amount Utilised"; Decimal)
        {
            CalcFormula = Sum("LC Detail"."LC Value LCY" WHERE("Issuing Bank" = FIELD("Bank No."),
                                                                "Date of Issue" = FIELD("Date Filter")));
            Caption = 'Amount Utilised';
            FieldClass = FlowField;
        }
        field(6; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(7; "Amount Utilised Amended"; Decimal)
        {
            CalcFormula = Sum("LC Detail"."Latest Amended Value" WHERE("Issuing Bank" = FIELD("Bank No."),
                                                                        "Date of Issue" = FIELD("Date Filter")));
            Caption = 'Amount Utilised Amended';
            FieldClass = FlowField;
        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(9; "To Date"; Date)
        {
            Caption = 'To Date';

            trigger OnValidate()
            begin
                IF "From Date" > "To Date" THEN
                    ERROR('To Date cannot be less than From Date.');
            end;
        }
    }

    keys
    {
        key(Key1; "Bank No.", "From Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

