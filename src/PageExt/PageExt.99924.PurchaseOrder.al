pageextension 99924 "LC Purchase Order" extends "Purchase Order"
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