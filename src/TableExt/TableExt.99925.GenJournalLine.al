tableextension 99925 "LC Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(99921; "LC No."; Code[20])
        {
            TableRelation = "LC Detail"."No." WHERE(Closed = CONST(false), Released = CONST(true));
        }
    }
}