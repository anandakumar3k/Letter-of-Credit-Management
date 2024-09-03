page 99929 "LC Terms"
{
    Caption = 'LC Terms';
    PageType = List;
    SourceTable = "LC Terms";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(control1)
            {
                field(Date; Rec.Date)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Attachment"; Rec."Attachment")
                {
                    AssistEdit = true;
                    Caption = 'Attachment';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"LC Terms"),
                              "No." = field("LC No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    // actions
    // {
    //     area(processing)
    //     {
    //         group("F&unctions")
    //         {
    //             Caption = 'F&unctions';
    //             Image = "Action";
    //             action("Open Attachment")
    //             {
    //                 Caption = 'Open Attachment';
    //                 Image = EditAttachment;

    //                 trigger OnAction()
    //                 begin
    //                     Rec.OpenAttachment;
    //                 end;
    //             }
    //             action("Create Attachment")
    //             {
    //                 Caption = 'Create Attachment';
    //                 Image = Attach;

    //                 trigger OnAction()
    //                 begin
    //                     Rec.TESTFIELD(Description);

    //                     Rec.CreateAttachment;
    //                 end;
    //             }
    //             action("Import Document")
    //             {
    //                 Caption = 'Import Document';
    //                 Image = Import;

    //                 trigger OnAction()
    //                 begin
    //                     Rec.TESTFIELD(Description);
    //                     Rec.ImportAttachment;
    //                 end;
    //             }
    //             action("Export Attachment")
    //             {
    //                 Caption = 'Export Attachment';
    //                 Image = ExportAttachment;

    //                 trigger OnAction()
    //                 begin
    //                     Rec.ExportAttachment;
    //                 end;
    //             }
    //             action("Remove Attachment")
    //             {
    //                 Caption = 'Remove Attachment';
    //                 Image = CancelAttachment;

    //                 trigger OnAction()
    //                 begin
    //                     Rec.RemoveAttachment(TRUE);
    //                 end;
    //             }
    //         }
    //     }
    // }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Date := WORKDATE;
    end;
}

