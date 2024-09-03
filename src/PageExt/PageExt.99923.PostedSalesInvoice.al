pageextension 99923 "LC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = Rec."LC No." <> '';
            }
        }
    }
}