page 99926 "LC Orders"
{
    Caption = 'LC Orders';
    PageType = List;
    SourceTable = "LC Orders";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("LC No."; Rec."LC No.")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Issued To/Received From"; Rec."Issued To/Received From")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Order Value"; Rec."Order Value")
                {
                }
                field("Received Bank Receipt No."; Rec."Received Bank Receipt No.")
                {
                }
                field(Renewed; Rec.Renewed)
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
    }
}

