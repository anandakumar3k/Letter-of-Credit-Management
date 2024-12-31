page 99923 "LC Amended List"
{
    Caption = 'LC Amended List';
    CardPageID = "LC Amended Details";
    Editable = false;
    PageType = List;
    SourceTable = "LC Amended Details";
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
                    ApplicationArea = all;
                }
                field("LC No."; Rec."LC No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = all;
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                    ApplicationArea = all;
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                    ApplicationArea = all;
                }
                field("Date of Issue"; Rec."Date of Issue")
                {
                    ApplicationArea = all;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                }
                field("Type of LC"; Rec."Type of LC")
                {
                    ApplicationArea = all;
                }
                field("Type of Credit Limit"; Rec."Type of Credit Limit")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field("LC Value"; Rec."LC Value")
                {
                    ApplicationArea = all;
                }
                field("Value Utilised"; Rec."Value Utilised")
                {
                    ApplicationArea = all;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = all;
                }
                field("LC Amended Date"; Rec."LC Amended Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

