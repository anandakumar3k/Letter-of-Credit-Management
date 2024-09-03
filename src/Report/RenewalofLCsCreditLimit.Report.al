report 99925 "Renewal of LC's Credit Limit"
{
    Caption = 'Renewal of LC''s Credit Limit';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("LC Detail"; "LC Detail")
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Closed = CONST(true));
            RequestFilterFields = "No.", "Type of Credit Limit", "Revolving Cr. Limit Types";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");
                IF "Type of Credit Limit" = "Type of Credit Limit"::Revolving THEN BEGIN
                    LCOrders.SETRANGE("LC No.", "No.");
                    IF LCOrders.FIND('-') THEN
                        REPEAT
                            IF "Revolving Cr. Limit Types" = "Revolving Cr. Limit Types"::Manual THEN BEGIN
                                IF NOT LCOrders."Received Bank Receipt No." THEN
                                    CurrReport.SKIP
                                    ;
                                LCOrders.Renewed := TRUE;
                            END;
                            IF "Revolving Cr. Limit Types" = "Revolving Cr. Limit Types"::Automatic THEN
                                LCOrders.Renewed := TRUE;
                            LCOrders.MODIFY;
                        UNTIL LCOrders.NEXT = 0;
                END;
            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN('Processing LC''s #1#########');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            RecDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        RecDate: Date;
        Window: Dialog;
        LCOrders: Record "LC Orders";
}

