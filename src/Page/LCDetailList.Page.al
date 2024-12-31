page 99925 "LC Detail List"
{

    Caption = 'LC Detail List';
    CardPageID = "LC Detail";
    Editable = false;
    PageType = List;
    SourceTable = "LC Detail";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("No."; Rec."No.")
                {
                }
                field("LC No."; Rec."LC No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                }
                field("Date of Issue"; Rec."Date of Issue")
                {
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                }
                field("Type of LC"; Rec."Type of LC")
                {
                }
                field("Type of Credit Limit"; Rec."Type of Credit Limit")
                {
                }
                field("LC Value"; Rec."LC Value")
                {
                }
                field("Latest Amended Value"; Rec."Latest Amended Value")
                {
                }
                field(Closed; Rec.Closed)
                {
                }
                field(Released; Rec.Released)
                {
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

    var
        PInvHeader: Record 122;
        SInvHeader: Record 112;
        SalesInvForm: Page 143;
        PurchaseInvForm: Page 146;
        LetterofCredit: Codeunit "Letter of Credit";
}

