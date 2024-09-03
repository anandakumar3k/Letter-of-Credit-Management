table 99924 "LC Orders"
{
    // **PWPL1.00**FRD_5.24**101017**001**AST
    // --Created New fields
    // Yes50000LC Calculation TermsOption
    // Yes50001LC Due DaysDateFormula
    // Yes50002LC Due DateDate

    Caption = 'LC Orders';

    fields
    {
        field(1; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            Editable = false;
        }
        field(2; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Editable = false;
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(3; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            Editable = false;
            TableRelation = IF ("Transaction Type"=CONST(Sale)) Customer
                            ELSE IF ("Transaction Type"=CONST(Purchase)) Vendor;
        }
        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(5; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            Editable = false;
        }
        field(6; "Order Value"; Decimal)
        {
            Caption = 'Order Value';
            Editable = false;
        }
        field(8; Renewed; Boolean)
        {
            Caption = 'Renewed';
            Editable = false;
        }
        field(9; "Received Bank Receipt No."; Boolean)
        {
            Caption = 'Received Bank Receipt No.';
        }
        field(50000; "LC Calculation Terms"; Option)
        {
            Description = '**PWPL1.00**FRD_5.24**101017**001**AST';
            OptionCaption = ' ,Manual,On Receipt of Goods,On Vendor Shipment Date';
            OptionMembers = " ",Manual,"On Receipt of Goods","On Vendor Shipment Date";
        }
        field(50001; "LC Due Days"; DateFormula)
        {
            Description = '**PWPL1.00**FRD_5.24**101017**001**AST';
        }
        field(50002; "LC Due Date"; Date)
        {
            Description = '**PWPL1.00**FRD_5.24**101017**001**AST';
        }
    }

    keys
    {
        key(Key1; "LC No.", "Order No.")
        {
            Clustered = true;
        }
        key(Key2; Renewed, "LC No.", "Order No.")
        {
            SumIndexFields = "Order Value";
        }
    }

    fieldgroups
    {
    }
}

