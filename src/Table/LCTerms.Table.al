table 99927 "LC Terms"
{
    Caption = 'LC Terms';

    fields
    {
        field(1; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Attachment No."; Integer)
        {
            Caption = 'Attachment No.';
        }
        field(4; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(5; Date; Date)
        {
            Caption = 'Date';
        }
        field(6; Released; Boolean)
        {
            Caption = 'Released';
        }
        field(7; "Attachment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Document Attachment" where("Table ID" = const(Database::"LC Terms"),
                              "No." = field("LC No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "LC No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You have canceled the create process.';
        Text001: Label 'Replace existing attachment?';
        Text002: Label 'You have canceled the import process.';

    // procedure ImportAttachment()
    // var
    //     Attachment: Record 5062;
    //     TempAttachment: Record 5062 temporary;
    //     AttachmentManagement: Codeunit 5052;
    // begin
    //     IF "Attachment No." <> 0 THEN BEGIN
    //         IF Attachment.GET("Attachment No.") THEN
    //             Attachment.TESTFIELD("Read Only", FALSE);
    //         IF NOT CONFIRM(Text001, FALSE) THEN
    //             EXIT;
    //     END;

    //     CLEAR(TempAttachment);
    //     IF TempAttachment.ImportAttachmentFromClientFile('', TRUE, TRUE) THEN BEGIN
    //         IF "Attachment No." = 0 THEN
    //             Attachment.GET(AttachmentManagement.InsertAttachment(0))
    //         ELSE
    //             Attachment.GET("Attachment No.");
    //         TempAttachment."No." := Attachment."No.";
    //         TempAttachment."Storage Pointer" := Attachment."Storage Pointer";
    //         TempAttachment.WizSaveAttachment;
    //         Attachment."Storage Type" := TempAttachment."Storage Type";
    //         Attachment."Storage Pointer" := TempAttachment."Storage Pointer";
    //         Attachment.Attachment := TempAttachment.Attachment;
    //         Attachment."File Extension" := TempAttachment."File Extension";
    //         Attachment.MODIFY;
    //         "Attachment No." := Attachment."No.";
    //         MODIFY;
    //     END ELSE
    //         ERROR(Text002);
    // end;

    // procedure OpenAttachment()
    // var
    //     Attachment: Record 5062;
    // begin
    //     IF "Attachment No." = 0 THEN
    //         EXIT;
    //     Attachment.GET("Attachment No.");
    //     Attachment.OpenAttachment("LC No." + ' ' + Description, FALSE, '');
    // end;

    // procedure CreateAttachment()
    // var
    //     Attachment: Record 5062;
    //     WordManagement: Codeunit 5054;
    //     NewAttachNo: Integer;
    // begin
    //     IF "Attachment No." <> 0 THEN BEGIN
    //         IF Attachment.GET("Attachment No.") THEN
    //             Attachment.TESTFIELD("Read Only", FALSE);
    //         IF NOT CONFIRM(Text001, FALSE) THEN
    //             EXIT;
    //     END;

    //     IF WordManagement.IsWordDocumentExtension('DOC') THEN;

    //     NewAttachNo := WordManagement.CreateWordAttachment("LC No." + ' ' + Description, '');
    //     IF NewAttachNo <> 0 THEN BEGIN
    //         IF "Attachment No." <> 0 THEN
    //             RemoveAttachment(FALSE);
    //         "Attachment No." := NewAttachNo;
    //         MODIFY;
    //     END ELSE
    //         ERROR(Text000);
    // end;

    // procedure ExportAttachment()
    // var
    //     Attachment: Record 5062;
    //     FileName: Text[1024];
    // begin
    //     IF Attachment.GET("Attachment No.") THEN
    //         Attachment.ExportAttachmentToClientFile(FileName);
    // end;

    // procedure RemoveAttachment(Prompt: Boolean)
    // var
    //     Attachment: Record 5062;
    // begin
    //     IF Attachment.GET("Attachment No.") THEN
    //         IF Attachment.RemoveAttachment(Prompt) THEN BEGIN
    //             "Attachment No." := 0;
    //             MODIFY;
    //         END;
    // end;
}