table 99922 "LC Amended Details"
{
    Caption = 'LC Amended Details';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "LC Amended List";
    LookupPageID = "LC Amended List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    LCSetup.GET;
                    NoSeries.TestManual(LCSetup."Amended Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(5; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            TableRelation = IF ("Transaction Type" = CONST(Sale)) Customer
            ELSE IF ("Transaction Type" = CONST(Purchase)) Vendor;
        }
        field(6; "Issuing Bank"; Code[20])
        {
            Caption = 'Issuing Bank';
            TableRelation = "Bank Account";
        }
        field(7; "Date of Issue"; Date)
        {
            Caption = 'Date of Issue';
        }
        field(8; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            begin
                IF "Date of Issue" <> 0D THEN
                    IF "Date of Issue" > "Expiry Date" THEN
                        ERROR(Text003);
                LCDetails.GET("LC No.");
                LCDetails."Expiry Date" := "Expiry Date";
                LCDetails.MODIFY;
            end;
        }
        field(9; "Type of LC"; Option)
        {
            Caption = 'Type of LC';
            OptionCaption = 'Inland,Foreign';
            OptionMembers = Inland,Foreign;
        }
        field(10; "Type of Credit Limit"; Option)
        {
            Caption = 'Type of Credit Limit';
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = IF ("Type of LC" = CONST(Foreign)) Currency;
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(13; "LC Value"; Decimal)
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
                        LCDetails.SETFILTER("No.", '<>%1', "LC No.");
                        IF LCDetails.FIND('-') THEN
                            REPEAT
                                IF LCDetails."Latest Amended Value" = 0 THEN
                                    TotalAmount := TotalAmount + LCDetails."LC Value LCY"
                                ELSE
                                    TotalAmount := TotalAmount + LCDetails."Latest Amended Value";
                            UNTIL LCDetails.NEXT = 0;
                        IF TotalAmount + "LC Value LCY" > BankCrLimit.Amount THEN
                            ERROR(Text004);
                    END ELSE
                        IF "LC Value" <> 0 THEN
                            ERROR(Text005);
                END;

                CALCFIELDS("Value Utilised");
                IF "LC Value LCY" < "Value Utilised" THEN
                    ERROR(Text006);
                "Remaining Amount" := "LC Value LCY" - "Value Utilised";
                LCDetails.GET("LC No.");
                LCDetails."Latest Amended Value" := "LC Value LCY";
                IF "LC Value" <> 0 THEN
                    LCDetails."LC Value" := "LC Value";
                LCDetails."Remaining Amount" := "LC Value LCY" - "Value Utilised";
                LCDetails."LC Value LCY" := "LC Value LCY";
                LCDetails.MODIFY;
            end;
        }
        field(14; "Value Utilised"; Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE("LC No." = FIELD("LC No.")));
            Caption = 'Value Utilised';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
        }
        field(16; "LC Amended Date"; Date)
        {
            Caption = 'LC Amended Date';
        }
        field(17; Released; Boolean)
        {
            Caption = 'Released';
            Editable = false;
        }
        field(18; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(21; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(22; "LC Value LCY"; Decimal)
        {
            Caption = 'LC Value LCY';
            Editable = false;
        }
        field(23; "Receiving Bank"; Code[20])
        {
            Caption = 'Receiving Bank';
        }
        field(24; "Bank LC No."; Code[20])
        {
            Caption = 'Bank LC No.';
        }
        field(25; "Bank Amended No."; Code[20])
        {
            Caption = 'Bank Amended No.';
        }
        field(26; "Revolving Cr. Limit Types"; Option)
        {
            Caption = 'Revolving Cr. Limit Types';
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(27; "Previous LC Value"; Decimal)
        {
            Caption = 'Previous LC Value';
        }
        field(28; "Previous Expiry Date"; Date)
        {
            Caption = 'Previous Expiry Date';
        }
    }

    keys
    {
        key(Key1; "No.", "LC No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Released THEN
            ERROR(Text002);
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            LCSetup.GET;
            LCSetup.TESTFIELD("Amended Nos.");
            //NoSeriesMgt.InitSeries(LCSetup."Amended Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "No. Series" := LCSetup."Amended Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        END;
    end;

    trigger OnModify()
    begin
        IF Closed THEN
            ERROR(Text001);
    end;

    var
        LCSetup: Record "LC Setup";
        LCDetails: Record "LC Detail";
        BankCrLimit: Record "LC Bank Limit Details";
        NoSeries: Codeunit "No. Series";
        Text001: Label 'You cannot modify the Document.';
        Text002: Label 'You cannot delete the document.';
        Text003: Label 'Expiry Date cannot be before Issue Date.';
        Text004: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text005: Label 'Banks credit limit is Zero.';
        Text006: Label 'LC Value cannot be lower than the Value Utilised.';

    procedure AssistEdit(OldLCADetails: Record "LC Amended Details"): Boolean
    begin
        LCSetup.GET;
        LCSetup.TESTFIELD("Amended Nos.");

        if NoSeries.LookupRelatedNoSeries(LCSetup."Amended Nos.", OldLCADetails."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}

