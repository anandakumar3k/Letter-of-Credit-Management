page 99922 "LC Amended Details"
{
    Caption = 'LC Amended Details';
    PageType = Card;
    SourceTable = "LC Amended Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("LC No."; Rec."LC No.")
                {
                    Enabled = "LC No.Enable";
                }
                field("Bank LC No."; Rec."Bank LC No.")
                {
                    Enabled = "Bank LC No.Enable";
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                    Enabled = "Issuing BankEnable";
                }
                field("Receiving Bank"; Rec."Receiving Bank")
                {
                    Enabled = "Receiving BankEnable";
                }
                field(Released; Rec.Released)
                {
                }
                field(Closed; Rec.Closed)
                {
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    Editable = "Expiry DateEditable";
                    Enabled = "Expiry DateEnable";
                }
                field("LC Amended Date"; Rec."LC Amended Date")
                {
                    Enabled = "LC Amended DateEnable";
                }
                field("Bank Amended No."; Rec."Bank Amended No.")
                {
                    Enabled = "Bank Amended No.Enable";
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Enabled = "Currency CodeEnable";
                }
                field("LC Value"; Rec."LC Value")
                {
                    Enabled = "LC ValueEnable";

                    trigger OnValidate()
                    begin
                        LCValueOnAfterValidate;
                    end;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    Enabled = "Exchange RateEnable";
                }
                field("LC Value LCY"; Rec."LC Value LCY")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Value Utilised"; Rec."Value Utilised")
                {
                    DrillDown = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("LC &Amendments")
            {
                Caption = 'LC &Amendments';
                Image = EditAdjustments;
                action("LC &Card")
                {
                    Caption = 'LC &Card';
                    Image = EditLines;
                    RunObject = Page "LC Detail List";
                    RunPageLink = "No." = FIELD("LC No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("LC &Release")
                {
                    Caption = 'LC &Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCAmendmentRelease(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
        Rec.CALCFIELDS("Value Utilised");
        Rec."Remaining Amount" := Rec."LC Value LCY" - Rec."Value Utilised";
    end;

    trigger OnInit()
    begin
        "Exchange RateEnable" := TRUE;
        "LC ValueEnable" := TRUE;
        "Bank Amended No.Enable" := TRUE;
        "Expiry DateEnable" := TRUE;
        "LC Amended DateEnable" := TRUE;
        "Currency CodeEnable" := TRUE;
        "Receiving BankEnable" := TRUE;
        "Issuing BankEnable" := TRUE;
        "Bank LC No.Enable" := TRUE;
        "LC No.Enable" := TRUE;
        "Expiry DateEditable" := TRUE;
    end;

    var
        LetterofCredit: Codeunit "Letter of Credit";

        "Expiry DateEditable": Boolean;

        "LC No.Enable": Boolean;
        "Bank LC No.Enable": Boolean;

        "Issuing BankEnable": Boolean;

        "Receiving BankEnable": Boolean;

        "Currency CodeEnable": Boolean;

        "LC Amended DateEnable": Boolean;

        "Expiry DateEnable": Boolean;

        "Bank Amended No.Enable": Boolean;

        "LC ValueEnable": Boolean;

        "Exchange RateEnable": Boolean;


    procedure EnableControls()
    begin
        "LC No.Enable" := FALSE;
        "Bank LC No.Enable" := FALSE;
        "Issuing BankEnable" := FALSE;
        "Receiving BankEnable" := FALSE;
        "Currency CodeEnable" := FALSE;
        "LC Amended DateEnable" := NOT Rec.Released;
        "Expiry DateEnable" := NOT Rec.Released;
        "Bank Amended No.Enable" := NOT Rec.Released;
        IF (Rec."Currency Code" <> '') AND (NOT Rec.Released) THEN
            "Exchange RateEnable" := TRUE
        ELSE
            "Exchange RateEnable" := FALSE;
        "LC ValueEnable" := NOT Rec.Released;
    end;

    local procedure LCValueOnAfterValidate()
    begin
        EnableControls;
    end;
}

