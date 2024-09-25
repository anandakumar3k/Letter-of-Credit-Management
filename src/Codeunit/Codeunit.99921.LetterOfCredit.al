codeunit 99921 "Letter of Credit"
{

    var
        LCTerms: Record "LC Terms";
        LCADetails: Record "LC Amended Details";
        LCADetails1: Record "LC Amended Details";
        LCAmendedDetails: Page "LC Amended Details";
        Text13700: Label 'Do you want to Release?';
        Text13701: Label 'The LC has been Released.';
        Text13702: Label 'The LC is already Released.';
        Text13703: Label 'Do you want to Amend this Document ?';
        Text13704: Label 'Without releasing the previous amendment you cannot Amend again.';
        Text13705: Label 'You cannot Amended without releasing the document.';
        Text13706: Label 'Cannot Amend LC %1. Status is closed.';
        Text13707: Label 'The LC has been closed.';
        Text13708: Label 'The LC is already closed.';
        Text13709: Label 'Do you want to close LC ?';
        Text13710: Label 'The LC Amendment has been Released.';
        Text13711: Label 'The LC Amendment is already Released.';
        Text13712: Label 'Do you want to Release Amendment?';

    procedure LCRelease(LCDetail: Record "LC Detail")
    begin
        IF CONFIRM(Text13700) THEN
            IF NOT LCDetail.Released THEN BEGIN
                LCDetail.TESTFIELD("LC Value");
                LCDetail.TESTFIELD("LC No.");
                LCDetail.TESTFIELD("Expiry Date");
                LCDetail.VALIDATE("LC Value");
                IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                    LCDetail.TESTFIELD("Currency Code");
                IF LCDetail."Type of Credit Limit" = LCDetail."Type of Credit Limit"::Revolving THEN
                    LCDetail.TESTFIELD("Revolving Cr. Limit Types");
                LCDetail.Released := TRUE;
                LCDetail.MODIFY;
                LCTerms.SETRANGE("LC No.", LCDetail."No.");
                IF LCTerms.FINDFIRST THEN BEGIN
                    LCTerms.Released := TRUE;
                    LCTerms.MODIFY;
                END;
                MESSAGE(Text13701);
            END ELSE
                MESSAGE(Text13702)
        ELSE
            EXIT;
    end;

    procedure LCAmendments(LCDetail: Record "LC Detail")
    begin
        IF LCDetail.Released THEN BEGIN
            CLEAR(LCAmendedDetails);
            IF LCDetail.Closed THEN
                ERROR(Text13706, LCDetail."LC No.");
            IF CONFIRM(Text13703) THEN BEGIN
                LCADetails.SETRANGE("LC No.", LCDetail."No.");
                IF NOT LCADetails.FIND('-') THEN BEGIN
                    LCADetails1.INIT;
                    LCADetails1."No." := '';
                    LCADetails1."LC No." := LCDetail."No.";
                    LCADetails1.INSERT(TRUE);
                    LCADetails1.Description := LCDetail.Description;
                    LCADetails1."Transaction Type" := LCDetail."Transaction Type";
                    LCADetails1."Issued To/Received From" := LCDetail."Issued To/Received From";
                    LCADetails1."Issuing Bank" := LCDetail."Issuing Bank";
                    LCADetails1."Date of Issue" := LCDetail."Date of Issue";
                    LCADetails1."Expiry Date" := LCDetail."Expiry Date";
                    LCADetails1."Type of LC" := LCDetail."Type of LC";
                    LCADetails1."Type of Credit Limit" := LCDetail."Type of Credit Limit";
                    LCADetails1."Revolving Cr. Limit Types" := LCDetail."Revolving Cr. Limit Types";
                    LCADetails1."Currency Code" := LCDetail."Currency Code";
                    LCADetails1."Previous LC Value" := LCDetail."LC Value";
                    LCADetails1."Previous Expiry Date" := LCDetail."Expiry Date";
                    LCADetails1."LC Value" := LCDetail."LC Value";
                    LCADetails1."Exchange Rate" := LCDetail."Exchange Rate";
                    LCADetails1."LC Value LCY" := LCDetail."LC Value LCY";
                    LCADetails1."LC Amended Date" := WORKDATE;
                    LCADetails1."Bank LC No." := LCDetail."LC No.";
                    LCADetails1."Receiving Bank" := LCDetail."Receiving Bank";
                    LCADetails1.MODIFY;
                    COMMIT;
                END ELSE BEGIN
                    LCADetails.FIND('+');
                    IF NOT LCADetails.Released THEN
                        ERROR(Text13704);
                    LCADetails1.INIT;
                    LCADetails1."No." := '';
                    LCADetails1."LC No." := LCADetails."LC No.";
                    LCADetails1.INSERT(TRUE);
                    LCADetails1.Description := LCADetails.Description;
                    LCADetails1."Transaction Type" := LCADetails."Transaction Type";
                    LCADetails1."Issued To/Received From" := LCADetails."Issued To/Received From";
                    LCADetails1."Issuing Bank" := LCADetails."Issuing Bank";
                    LCADetails1."Date of Issue" := LCADetails."Date of Issue";
                    LCADetails1."Expiry Date" := LCADetails."Expiry Date";
                    LCADetails1."Type of Credit Limit" := LCADetails."Type of Credit Limit";
                    LCADetails1."Type of LC" := LCADetails."Type of LC";
                    LCADetails1."Currency Code" := LCADetails."Currency Code";
                    LCADetails1."LC Value" := LCADetails."LC Value";
                    LCADetails1."Previous LC Value" := LCADetails."LC Value";
                    LCADetails1."Previous Expiry Date" := LCADetails."Expiry Date";
                    LCADetails1."Exchange Rate" := LCADetails."Exchange Rate";
                    LCADetails1."LC Value LCY" := LCADetails."LC Value LCY";
                    LCADetails1."LC Amended Date" := WORKDATE;
                    LCADetails1."Bank LC No." := LCDetail."LC No.";
                    LCADetails1."Receiving Bank" := LCADetails."Receiving Bank";
                    LCADetails1.MODIFY;
                    COMMIT;
                END;
                LCAmendedDetails.SETTABLEVIEW(LCADetails1);
                LCAmendedDetails.SETRECORD(LCADetails1);
                LCAmendedDetails.LOOKUPMODE(TRUE);
                IF LCAmendedDetails.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    LCAmendedDetails.GETRECORD(LCADetails1);
                    CLEAR(LCAmendedDetails);
                END;
            END ELSE
                EXIT;
        END ELSE
            MESSAGE(Text13705);
    end;

    procedure LCClose(LCDetail: Record "LC Detail")
    begin
        IF CONFIRM(Text13709) THEN
            IF NOT LCDetail.Closed THEN BEGIN
                LCDetail.TESTFIELD(Released);
                LCDetail.Closed := TRUE;
                LCDetail.MODIFY;
                LCADetails.SETRANGE("LC No.", LCDetail."No.");
                IF LCADetails.FIND('-') THEN
                    REPEAT
                        LCADetails.Closed := TRUE;
                        LCADetails.MODIFY;
                    UNTIL LCADetails.NEXT = 0;
                LCTerms.SETRANGE("LC No.", LCDetail."No.");
                IF LCTerms.FINDFIRST THEN BEGIN
                    LCTerms.Released := TRUE;
                    LCTerms.MODIFY;
                END;
                MESSAGE(Text13707);
            END ELSE
                MESSAGE(Text13708)
        ELSE
            EXIT;
    end;

    procedure LCAmendmentRelease(LCAmendments: Record "LC Amended Details")
    begin
        IF CONFIRM(Text13712) THEN
            IF NOT LCAmendments.Released THEN BEGIN
                LCAmendments.TESTFIELD("Bank Amended No.");
                LCAmendments.VALIDATE("LC Value");
                LCAmendments.Released := TRUE;
                LCAmendments.MODIFY;
                MESSAGE(Text13710);
            END ELSE
                MESSAGE(Text13711)
        ELSE
            EXIT;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", OnBeforeDrillDown, '', false, false)]
    local procedure "Document Attachment Factbox_OnBeforeDrillDown"(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        LCTerms: Record "LC Terms";
    begin
        case DocumentAttachment."Table ID" of
            Database::"LC Terms":
                begin
                    RecRef.Open(Database::"LC Terms");
                    if LCTerms.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(LCTerms);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasNumberFieldPrimaryKey, '', false, false)]
    local procedure "Document Attachment Mgmt_OnAfterTableHasNumberFieldPrimaryKey"(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        case TableNo of
            Database::"LC Terms":
                begin
                    FieldNo := 1;
                    Result := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromPurchHeader, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterCopyGenJnlLineFromPurchHeader"(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."LC No." := PurchaseHeader."LC No.";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromSalesHeader, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterCopyGenJnlLineFromSalesHeader"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."LC No." := SalesHeader."LC No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterGLFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterGLFinishPosting"(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
        InsertIntoLCRegister(GenJnlLine);
    end;


    local procedure InsertIntoLCRegister(GenJnlLine: Record "Gen. Journal Line")
    var
        LCRegister: Record "LC Register";
        LineNo: Integer;
    begin
        if GenJnlLine."LC No." = '' then
            exit;

        LCRegister.SETRANGE("LC No.", GenJnlLine."LC No.");
        IF LCRegister.FINDLAST THEN
            LineNo := LCRegister."Line No.";

        LCRegister.INIT;
        LCRegister."LC No." := GenJnlLine."LC No.";
        LCRegister."Document No." := GenJnlLine."Document No.";
        LCRegister."Posting Date" := GenJnlLine."Posting Date";
        LCRegister."Line No." := LineNo + 10000;
        LCRegister.INSERT;
    end;
}