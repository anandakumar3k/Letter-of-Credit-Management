tableextension 99921 "LC Sales Header" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(99921; "LC No."; Code[20])
        {
            TableRelation = "LC Detail"."No." WHERE("Transaction Type" = CONST(Sale), "Issued To/Received From" = FIELD("Bill-to Customer No."), Closed = CONST(false), Released = CONST(true));
        }
    }
}