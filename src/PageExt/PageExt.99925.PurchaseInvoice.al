pageextension 99925 "LC Purchase Invoice" extends "Purchase Invoice"
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