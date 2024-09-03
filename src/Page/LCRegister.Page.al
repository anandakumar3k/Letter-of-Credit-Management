page 99927 "LC Register"
{
    Caption = 'LC Register';
    Editable = false;
    PageType = List;
    SourceTable = "LC Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field("LC No."; Rec."LC No.")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }
}

