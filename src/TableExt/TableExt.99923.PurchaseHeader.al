tableextension 99923 "LC Purchase Header" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(99921; "LC No."; Code[20])
        {
            TableRelation = "LC Detail"."No." WHERE("Transaction Type" = CONST(Purchase), "Issued To/Received From" = FIELD("Pay-to Vendor No."), Closed = CONST(false), Released = CONST(true));
        }
    }
}