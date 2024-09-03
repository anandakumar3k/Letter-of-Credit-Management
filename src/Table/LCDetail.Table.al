table 99923 "LC Detail"
{
    Caption = 'LC Detail';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "LC Detail List";
    LookupPageID = "LC Detail List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    LCSetup.GET;
                    NoSeries.TestManual(LCSetup."Detail Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;

            trigger OnValidate()
            begin
                IF "Transaction Type" <> xRec."Transaction Type" THEN BEGIN
                    "Issued To/Received From" := '';
                    "Issuing Bank" := '';
                    "LC Value" := 0;
                END;
            end;
        }
        field(4; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            TableRelation = IF ("Transaction Type" = CONST(Sale)) Customer
            ELSE IF ("Transaction Type" = CONST(Purchase)) Vendor;

            trigger OnValidate()
            begin
                IF "Issued To/Received From" <> xRec."Issued To/Received From" THEN BEGIN
                    "Issuing Bank" := '';
                    "LC Value" := 0;
                END;
            end;
        }
        field(5; "Issuing Bank"; Code[20])
        {
            Caption = 'Issuing Bank';

            trigger OnLookup()
            begin
                CLEAR(Bankform);
                CLEAR(CustBankform);
                IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                    CustBank.SETRANGE("Customer No.", "Issued To/Received From");
                    CustBankform.LOOKUPMODE(TRUE);
                    CustBankform.SETTABLEVIEW(CustBank);
                    IF CustBankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        CustBankform.GETRECORD(CustBank);
                        IF NOT Released THEN
                            "Issuing Bank" := CustBank.Code;
                    END;
                END;
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    Bankform.LOOKUPMODE(TRUE);
                    Bankform.SETTABLEVIEW(Bank);
                    IF Bankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        Bankform.GETRECORD(Bank);
                        IF NOT Released THEN
                            "Issuing Bank" := Bank."No.";
                    END;
                END;
                VALIDATE("Issuing Bank");
            end;

            trigger OnValidate()
            begin
                IF "Issuing Bank" <> xRec."Issuing Bank" THEN
                    "LC Value" := 0;
            end;
        }
        field(6; "Date of Issue"; Date)
        {
            Caption = 'Date of Issue';

            trigger OnValidate()
            begin
                IF "Expiry Date" <> 0D THEN
                    IF "Date of Issue" > "Expiry Date" THEN
                        ERROR(Text13703);
            end;
        }
        field(7; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            begin
                IF "Date of Issue" <> 0D THEN
                    IF "Date of Issue" > "Expiry Date" THEN
                        ERROR(Text13700);
            end;
        }
        field(8; "Type of LC"; Option)
        {
            Caption = 'Type of LC';
            OptionCaption = 'Inland,Foreign';
            OptionMembers = Inland,Foreign;

            trigger OnValidate()
            begin
                IF "Type of LC" = "Type of LC"::Inland THEN BEGIN
                    "Currency Code" := '';
                    "Exchange Rate" := 0;
                END;
                VALIDATE("LC Value");
            end;
        }
        field(9; "Type of Credit Limit"; Option)
        {
            Caption = 'Type of Credit Limit';
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;

            trigger OnValidate()
            begin
                IF "Type of Credit Limit" = "Type of Credit Limit"::Fixed THEN
                    "Revolving Cr. Limit Types" := "Revolving Cr. Limit Types"::" ";
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = IF ("Type of LC" = CONST(Foreign)) Currency.Code;

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    CurrExchRate.SETRANGE("Currency Code", "Currency Code");
                    CurrExchRate.SETRANGE("Starting Date", 0D, "Date of Issue");
                    CurrExchRate.FINDLAST;
                    "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
                END;
                VALIDATE("LC Value");
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(12; "LC Value"; Decimal)
        {
            Caption = 'LC Value';

            trigger OnValidate()
            var
                Currency: Record 4;
                TotalAmount: Decimal;
            begin
                CLEAR(TotalAmount);
                IF "Currency Code" <> '' THEN BEGIN
                    Currency.GET("Currency Code");
                    "LC Value LCY" := ROUND("LC Value" * "Exchange Rate", Currency."Amount Rounding Precision");
                END ELSE
                    "LC Value LCY" := "LC Value";
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    BankCrLimit.SETRANGE("Bank No.", "Issuing Bank");
                    BankCrLimit.SETFILTER("From Date", '<= %1', "Date of Issue");
                    BankCrLimit.SETFILTER("To Date", '>=%1', "Date of Issue");
                    IF BankCrLimit.FINDLAST THEN BEGIN
                        LCDetails.RESET;
                        LCDetails.SETRANGE("Transaction Type", "Transaction Type");
                        LCDetails.SETRANGE("Issuing Bank", BankCrLimit."Bank No.");
                        IF BankCrLimit."To Date" <> 0D THEN
                            LCDetails.SETFILTER("Date of Issue", '%1..%2', BankCrLimit."From Date", BankCrLimit."To Date")
                        ELSE
                            LCDetails.SETFILTER("Date of Issue", '>=%1', BankCrLimit."From Date");
                        LCDetails.SETFILTER("No.", '<>%1', "No.");
                        IF LCDetails.FIND('-') THEN
                            REPEAT
                                IF LCDetails."Latest Amended Value" = 0 THEN
                                    TotalAmount := TotalAmount + LCDetails."LC Value LCY"
                                ELSE
                                    TotalAmount := TotalAmount + LCDetails."Latest Amended Value";
                            UNTIL LCDetails.NEXT = 0;
                        IF TotalAmount + "LC Value LCY" > BankCrLimit.Amount THEN
                            ERROR(Text13704);
                    END ELSE
                        IF "LC Value" <> 0 THEN
                            ERROR(Text13705);
                END;
                CALCFIELDS("Value Utilised");
                "Remaining Amount" := "LC Value LCY" - "Value Utilised";
                "Latest Amended Value" := "LC Value LCY";
            end;
        }
        field(13; "Value Utilised"; Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE("LC No." = FIELD("No.")));
            Caption = 'Value Utilised';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
        }
        field(15; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(16; Released; Boolean)
        {
            Caption = 'Released';
            Editable = false;
        }
        field(17; "Revolving Cr. Limit Types"; Option)
        {
            Caption = 'Revolving Cr. Limit Types';
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(18; "Latest Amended Value"; Decimal)
        {
            Caption = 'Latest Amended Value';
            Editable = false;
        }
        field(21; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';

            trigger OnValidate()
            begin
                VALIDATE("LC Value");
            end;
        }
        field(22; "LC Value LCY"; Decimal)
        {
            Caption = 'LC Value LCY';
            Editable = false;
        }
        field(23; "Receiving Bank"; Code[20])
        {
            Caption = 'Receiving Bank';

            trigger OnLookup()
            begin
                CLEAR(Bankform);
                CLEAR(VendBankForm);
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    VendBank.SETRANGE("Vendor No.", "Issued To/Received From");
                    VendBankForm.LOOKUPMODE(TRUE);
                    VendBankForm.SETTABLEVIEW(VendBank);
                    IF VendBankForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        VendBankForm.GETRECORD(VendBank);
                        IF NOT Released THEN
                            "Receiving Bank" := VendBank.Code;
                    END;
                END;
                IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                    Bankform.LOOKUPMODE(TRUE);
                    Bankform.SETTABLEVIEW(Bank);
                    IF Bankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        Bankform.GETRECORD(Bank);
                        IF NOT Released THEN
                            "Receiving Bank" := Bank."No.";
                    END;
                END;
                VALIDATE("Receiving Bank");
            end;
        }
        field(24; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(25; "Renewed Amount"; Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE("LC No." = FIELD("No."),
                                                               Renewed = CONST(true)));
            Caption = 'Renewed Amount';
            Editable = false;
            FieldClass = FlowField;
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
        field(50003; "LC Margin Money"; Decimal)
        {
            Description = '**PWPL1.00**311017**001**AST';

            trigger OnValidate()
            begin
                //AST ++
                IF ("LC Margin Money" > "LC Value") THEN
                    ERROR('"LC Margin Amount" should not be greater than "LC Value"');
                //AST --
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Date of Issue", "Issuing Bank", "Transaction Type")
        {
            SumIndexFields = "LC Value", "Latest Amended Value", "LC Value LCY";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Released THEN
            ERROR(Text13702);
        LCTerms.LOCKTABLE;
        LCTerms.SETRANGE("LC No.", "No.");
        LCTerms.DELETEALL;

        LCAmendments.LOCKTABLE;
        LCAmendments.SETRANGE("LC No.", "No.");
        LCAmendments.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            LCSetup.GET;
            LCSetup.TESTFIELD("Detail Nos.");
            // NoSeriesMgt.InitSeries(LCSetup."Detail Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "No. Series" := LCSetup."Detail Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
        "Date of Issue" := WORKDATE;
    end;

    trigger OnModify()
    begin
        IF Closed THEN
            ERROR(Text13701);
    end;

    var
        LCSetup: Record "LC Setup";
        LCDetails: Record "LC Detail";
        CustBank: Record 287;
        Bank: Record 270;
        BankCrLimit: Record "LC Bank Limit Details";
        LCTerms: Record "LC Terms";
        LCAmendments: Record "LC Amended Details";
        CustBankform: Page 424;
        Bankform: Page 371;
        NoSeries: Codeunit "No. Series";
        VendBank: Record 288;
        VendBankForm: Page 426;
        CurrExchRate: Record 330;
        Text13700: Label 'Expiry Date cannot be before Issue Date.';
        Text13701: Label 'You cannot modify.';
        Text13702: Label 'You cannot delete.';
        Text13703: Label 'Issue Date cannot be after Expiry Date.';
        Text13704: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text13705: Label 'Bank''''s credit limit is zero.';


    procedure AssistEdit(OldLCDetails: Record "LC Detail"): Boolean
    begin
        LCSetup.GET;
        LCSetup.TESTFIELD("Detail Nos.");

        if NoSeries.LookupRelatedNoSeries(LCSetup."Detail Nos.", OldLCDetails."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}

