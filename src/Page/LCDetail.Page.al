page 99924 "LC Detail"
{
    Caption = 'LC Detail';
    PageType = Card;
    SourceTable = "LC Detail";
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
                field("LC No."; Rec."LC No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Enabled = "Transaction TypeEnable";
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                    Enabled = "Issued To/Received FromEnable";
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                    Enabled = "Issuing BankEnable";

                    trigger OnValidate()
                    begin
                        IssuingBankOnAfterValidate;
                    end;
                }
                field("Receiving Bank"; Rec."Receiving Bank")
                {
                    Enabled = "Receiving BankEnable";

                    trigger OnValidate()
                    begin
                        ReceivingBankOnAfterValidate;
                    end;
                }
                field(Released; Rec.Released)
                {
                }
                field(Closed; Rec.Closed)
                {
                }
                field("Date of Issue"; Rec."Date of Issue")
                {
                    Enabled = "Date of IssueEnable";
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    Enabled = "Expiry DateEnable";
                }
                field("Type of LC"; Rec."Type of LC")
                {
                    Enabled = "Type of LCEnable";

                    trigger OnValidate()
                    begin
                        TypeofLCOnAfterValidate;
                    end;
                }
                field("Type of Credit Limit"; Rec."Type of Credit Limit")
                {
                    Enabled = "Type of Credit LimitEnable";

                    trigger OnValidate()
                    begin
                        TypeofCreditLimitOnAfterValida;
                    end;
                }
                field("Revolving Cr. Limit Types"; Rec."Revolving Cr. Limit Types")
                {
                    Enabled = RevolvingCrLimitTypesEnable;

                    trigger OnValidate()
                    begin
                        RevolvingCrLimitTypesOnAfterVa;
                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Enabled = "Currency CodeEnable";

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    Enabled = "Exchange RateEnable";
                }
                field("LC Value"; Rec."LC Value")
                {
                    Enabled = "LC ValueEnable";
                }
                field("LC Calculation Terms"; Rec."LC Calculation Terms")
                {
                }
                field("LC Due Days"; Rec."LC Due Days")
                {
                }
                field("LC Due Date"; Rec."LC Due Date")
                {
                }
                field("LC Margin Money"; Rec."LC Margin Money")
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
                field("Latest Amended Value"; Rec."Latest Amended Value")
                {
                    Caption = 'LC Value LCY';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&LC Details")
            {
                Caption = '&LC Details';
                Image = ViewDetails;
                action("LC &Register")
                {
                    Caption = 'LC &Register';
                    Image = Register;
                    RunObject = Page "LC Register";
                    RunPageLink = "LC No." = FIELD("No.");
                }
                action("LC &Terms")
                {
                    Caption = 'LC &Terms';
                    Image = Setup;
                    RunObject = Page "LC Terms";
                    RunPageLink = "LC No." = FIELD("No.");
                }
                action(Amendments)
                {
                    Caption = 'Amendments';
                    Image = EditAdjustments;
                    RunObject = Page "LC Amended List";
                    RunPageLink = "LC No." = FIELD("No.");
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "LC Orders";
                    RunPageLink = "Transaction Type" = FIELD("Transaction Type"),
                                  "LC No." = FIELD("No.");
                }
                action("Posted Orders")
                {
                    Caption = 'Posted Orders';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
                            SInvHeader.SETRANGE("LC No.", Rec."No.");
                            SalesInvForm.SETTABLEVIEW(SInvHeader);
                            SalesInvForm.RUN;
                        END;
                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            PInvHeader.SETRANGE("LC No.", Rec."No.");
                            PInvHeader.SETRANGE("Buy-from Vendor No.", Rec."Issued To/Received From");
                            PurchaseInvForm.SETTABLEVIEW(PInvHeader);
                            PurchaseInvForm.RUN;
                        END;
                    end;
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
                        LetterofCredit.LCRelease(Rec);
                    end;
                }
                action("LC &Amendments")
                {
                    Caption = 'LC &Amendments';
                    Image = EditAdjustments;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCAmendments(Rec);
                    end;
                }
                action("Close LC")
                {
                    Caption = 'Close LC';
                    Image = Close;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCClose(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
        Rec.CALCFIELDS("Value Utilised", "Renewed Amount");
        IF Rec."Latest Amended Value" <> 0 THEN
            Rec."Remaining Amount" := Rec."Latest Amended Value" - Rec."Value Utilised" + Rec."Renewed Amount"
        ELSE
            Rec."Remaining Amount" := Rec."LC Value LCY" - Rec."Value Utilised" + Rec."Renewed Amount";
    end;

    trigger OnInit()
    begin
        "Exchange RateEnable" := TRUE;
        "Currency CodeEnable" := TRUE;
        RevolvingCrLimitTypesEnable := TRUE;
        "LC ValueEnable" := TRUE;
        "Type of Credit LimitEnable" := TRUE;
        "Type of LCEnable" := TRUE;
        "Expiry DateEnable" := TRUE;
        "Date of IssueEnable" := TRUE;
        "Receiving BankEnable" := TRUE;
        "Issuing BankEnable" := TRUE;
        "Issued To/Received FromEnable" := TRUE;
        "Transaction TypeEnable" := TRUE;
    end;

    var
        PInvHeader: Record "Purch. Inv. Header";
        SInvHeader: Record "Sales Invoice Header";
        SalesInvForm: Page "Posted Sales Invoices";
        PurchaseInvForm: Page "Posted Purchase Invoices";
        LetterofCredit: Codeunit "Letter of Credit";
        "Transaction TypeEnable": Boolean;
        "Issued To/Received FromEnable": Boolean;
        "Issuing BankEnable": Boolean;
        "Receiving BankEnable": Boolean;
        "Date of IssueEnable": Boolean;
        "Expiry DateEnable": Boolean;
        "Type of LCEnable": Boolean;
        "Type of Credit LimitEnable": Boolean;
        "LC ValueEnable": Boolean;
        RevolvingCrLimitTypesEnable: Boolean;
        "Currency CodeEnable": Boolean;
        "Exchange RateEnable": Boolean;

    procedure EnableControls()
    begin
        "Transaction TypeEnable" := NOT Rec.Released;
        "Issued To/Received FromEnable" := NOT Rec.Released;
        "Issuing BankEnable" := NOT Rec.Released;
        "Receiving BankEnable" := NOT Rec.Released;
        "Date of IssueEnable" := NOT Rec.Released;
        "Expiry DateEnable" := NOT Rec.Released;
        "Type of LCEnable" := NOT Rec.Released;
        "Type of Credit LimitEnable" := NOT Rec.Released;
        IF NOT Rec.Released AND (Rec."Type of Credit Limit" = Rec."Type of Credit Limit"::Revolving) THEN
            RevolvingCrLimitTypesEnable := TRUE
        ELSE
            RevolvingCrLimitTypesEnable := FALSE;

        IF (Rec."Type of LC" = Rec."Type of LC"::Foreign) AND (NOT Rec.Released) THEN BEGIN
            "Currency CodeEnable" := TRUE;
            "Exchange RateEnable" := TRUE;
        END ELSE BEGIN
            "Currency CodeEnable" := FALSE;
            "Exchange RateEnable" := FALSE;
        END;

        IF (Rec."Currency Code" <> '') AND NOT Rec.Released THEN
            "Exchange RateEnable" := TRUE
        ELSE
            "Exchange RateEnable" := FALSE;

        "LC ValueEnable" := NOT Rec.Released;
    end;

    local procedure IssuingBankOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure TypeofLCOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure TypeofCreditLimitOnAfterValida()
    begin
        EnableControls;
    end;

    local procedure RevolvingCrLimitTypesOnAfterVa()
    begin
        EnableControls;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure ReceivingBankOnAfterValidate()
    begin
        EnableControls;
    end;
}

