report 99921 "Close LCS"
{
    Caption = 'Close LCS';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem5891; "LC Detail")
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Closed = CONST(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");
                IF "Expiry Date" > RecDate THEN BEGIN
                    Closed := TRUE;
                    MODIFY;
                END;
            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(Text002);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(RecDate; RecDate)
                    {
                        Caption = 'Date';
                    }
                }
            }
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

    trigger OnPreReport()
    begin
        IF RecDate = 0D THEN
            ERROR(Text001);
    end;

    var
        RecDate: Date;
        Window: Dialog;
        Text001: Label 'Date cannot be empty.';
        Text002: Label 'Processing LC''''s #1########';
}

