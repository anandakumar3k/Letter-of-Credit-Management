page 99928 "LC Setup"
{
    Caption = 'LC Setup';
    PageType = Card;
    SourceTable = "LC Setup";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Detail Nos."; Rec."Detail Nos.")
                {
                }
                field("Amended Nos."; Rec."Amended Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

