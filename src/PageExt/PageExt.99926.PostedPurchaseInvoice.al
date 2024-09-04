pageextension 99926 "LC Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}