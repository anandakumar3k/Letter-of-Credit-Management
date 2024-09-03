pageextension 99922 "LC Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("LC No."; Rec."LC No.")
            {
            }
        }
    }
}