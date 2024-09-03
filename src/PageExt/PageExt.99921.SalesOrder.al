pageextension 99921 "LC Sales Order" extends "Sales Order"
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