page 99921 "LC Bank Limit Details"
{
    Caption = 'LC Bank Limit Details';
    PageType = List;
    SourceTable = "LC Bank Limit Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("Bank No."; Rec."Bank No.")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Amount Utilised"; Rec."Amount Utilised")
                {
                    DrillDown = false;
                    Editable = false;
                    Visible = false;
                }
                field("Amount Utilised Amended"; Rec."Amount Utilised Amended")
                {
                    Caption = 'Amount Utilised ';
                    DrillDown = false;
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SETFILTER("Date Filter", '%1..%2', Rec."From Date", Rec."To Date");
        Rec.CALCFIELDS("Amount Utilised", "Amount Utilised Amended");
        IF Rec."Amount Utilised Amended" = 0 THEN
            Rec."Remaining Amount" := Rec.Amount - Rec."Amount Utilised"
        ELSE
            Rec."Remaining Amount" := Rec.Amount - Rec."Amount Utilised Amended";
    end;
}

