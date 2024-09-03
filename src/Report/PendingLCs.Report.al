report 99924 "Pending LC's"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PendingLCs.rdlc';
    Caption = 'Pending LC''s';

    dataset
    {
        dataitem("LC Detail"; "LC Detail")
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Closed = CONST(false),
                                      Released = CONST(true));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'LC Amendments';
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; '')
            {
            }
            column(USERID; USERID)
            {
            }
            column(LC_Detail__LC_No__; "LC No.")
            {
            }
            column(LC_Detail_Description; Description)
            {
            }
            column(LC_Detail__Transaction_Type_; "Transaction Type")
            {
            }
            column(LC_Detail__Issued_To_Received_From_; "Issued To/Received From")
            {
            }
            column(LC_Detail__LC_Value_; "LC Value")
            {
            }
            column(LC_Detail__Value_Utilised_; "Value Utilised")
            {
            }
            column(LC_Detail__Remaining_Amount_; "Remaining Amount")
            {
            }
            column(LC_Detail__Currency_Code_; "Currency Code")
            {
            }
            column(LC_Detail__Latest_Amended_Value_; "Latest Amended Value")
            {
            }
            column(LC_Detail__Expiry_Date_; FORMAT("Expiry Date"))
            {
            }
            column(LC_Detail_No_; "No.")
            {
            }
            column(LC_DetailCaption; LC_DetailCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(LC_No_Caption; LC_No_CaptionLbl)
            {
            }
            column(LC_Detail_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(LC_Detail__Transaction_Type_Caption; FIELDCAPTION("Transaction Type"))
            {
            }
            column(LC_Detail__Issued_To_Received_From_Caption; FIELDCAPTION("Issued To/Received From"))
            {
            }
            column(LC_Detail__LC_Value_Caption; FIELDCAPTION("LC Value"))
            {
            }
            column(LC_Detail__Remaining_Amount_Caption; FIELDCAPTION("Remaining Amount"))
            {
            }
            column(LC_Detail__Currency_Code_Caption; FIELDCAPTION("Currency Code"))
            {
            }
            column(Value_UtilisedCaption; Value_UtilisedCaptionLbl)
            {
            }
            column(LC_Value_LCYCaption; LC_Value_LCYCaptionLbl)
            {
            }
            column(LC_Detail__Expiry_Date_Caption; LC_Detail__Expiry_Date_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LCOrders.RESET;
                LCOrders.SETRANGE("LC No.", "No.");
                IF LCOrders.FINDFIRST THEN BEGIN
                    LCOrders.CALCSUMS("Order Value");
                    "Remaining Amount" := "LC Value LCY" - LCOrders."Order Value";
                END;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LC_DetailCaptionLbl: Label 'LC Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        LC_No_CaptionLbl: Label 'LC No.';
        Value_UtilisedCaptionLbl: Label 'Value Utilised';
        LC_Value_LCYCaptionLbl: Label 'LC Value LCY';
        LC_Detail__Expiry_Date_CaptionLbl: Label 'Expiry Date';
        LCOrders: Record "LC Orders";
        LastFieldNo: Integer;
}

