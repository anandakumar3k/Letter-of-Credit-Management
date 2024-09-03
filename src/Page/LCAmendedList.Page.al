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
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("LC Value"; Rec."LC Value")
                {
                }
                field("Value Utilised"; Rec."Value Utilised")
                {
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                }
                field("LC Amended Date"; Rec."LC Amended Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

