report 99922 "LC Amendments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/LCAmendments.rdl';
    Caption = 'LC Amendments';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("LC Detail"; "LC Detail")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
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
            column(LC_Detail__Expiry_Date_; FORMAT("Expiry Date"))
            {
            }
            column(LC_Detail__Issued_To_Received_From_; "Issued To/Received From")
            {
            }
            column(LC_Detail__Issuing_Bank_; "Issuing Bank")
            {
            }
            column(LC_Detail__Date_of_Issue_; FORMAT("Date of Issue"))
            {
            }
            column(LC_Detail_Description; Description)
            {
            }
            column(LC_Detail__Transaction_Type_; "Transaction Type")
            {
            }
            column(LC_Detail__LC_No__; "LC No.")
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
            column(LC_Detail__Expiry_Date_Caption; LC_Detail__Expiry_Date_CaptionLbl)
            {
            }
            column(LC_Amended_Details__LC_Amended_Date_Caption; LC_Amended_Details__LC_Amended_Date_CaptionLbl)
            {
            }
            column(LC_Detail__Issued_To_Received_From_Caption; FIELDCAPTION("Issued To/Received From"))
            {
            }
            column(LC_Detail__Issuing_Bank_Caption; FIELDCAPTION("Issuing Bank"))
            {
            }
            column(LC_Detail__Date_of_Issue_Caption; LC_Detail__Date_of_Issue_CaptionLbl)
            {
            }
            column(LC_Amended_Details__Expiry_Date_Caption; LC_Amended_Details__Expiry_Date_CaptionLbl)
            {
            }
            column(LC_Amended_Details__LC_Value_Caption; "LC Amended Details".FIELDCAPTION("LC Value"))
            {
            }
            column(LC_Amended_Details__Previous_LC_Value_Caption; "LC Amended Details".FIELDCAPTION("Previous LC Value"))
            {
            }
            column(LC_Amended_Details_DescriptionCaption; "LC Amended Details".FIELDCAPTION(Description))
            {
            }
            column(LC_Detail_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(LC_Detail__Transaction_Type_Caption; FIELDCAPTION("Transaction Type"))
            {
            }
            column(LC_Amended_Details__Bank_LC_No__Caption; "LC Amended Details".FIELDCAPTION("Bank LC No."))
            {
            }
            column(LC_Detail__LC_No__Caption; FIELDCAPTION("LC No."))
            {
            }
            column(AmendmentsCaption; AmendmentsCaptionLbl)
            {
            }
            dataitem("LC Amended Details"; "LC Amended Details")
            {
                DataItemLink = "LC No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "LC No.")
                                    WHERE(Released = CONST(true));
                column(LC_Amended_Details__Bank_LC_No__; "Bank LC No.")
                {
                }
                column(LC_Amended_Details_Description; Description)
                {
                }
                column(LC_Amended_Details__Previous_LC_Value_; "Previous LC Value")
                {
                }
                column(LC_Amended_Details__LC_Value_; "LC Value")
                {
                }
                column(LC_Amended_Details__Expiry_Date_; FORMAT("Expiry Date"))
                {
                }
                column(LC_Amended_Details__LC_Amended_Date_; FORMAT("LC Amended Date"))
                {
                }
                column(LC_Amended_Details_No_; "No.")
                {
                }
                column(LC_Amended_Details_LC_No_; "LC No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("No.");
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
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        LC_DetailCaptionLbl: Label 'LC Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        LC_Detail__Expiry_Date_CaptionLbl: Label 'Expiry Date';
        LC_Amended_Details__LC_Amended_Date_CaptionLbl: Label 'LC Amended Date';
        LC_Detail__Date_of_Issue_CaptionLbl: Label 'Date of Issue';
        LC_Amended_Details__Expiry_Date_CaptionLbl: Label 'Expiry Date';
        AmendmentsCaptionLbl: Label 'Amendments';
}

