report 50101 "Material Request"
{
    Caption = 'Material Request';
    DefaultRenderingLayout = "Material Request";
    UsageCategory = Documents;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(MRHeader; "Material Req. Header")
        {
            RequestFilterFields = "Material Req. No.";

            column(CompanyName; gRecCompany.Name)
            {
            }
            column(CompanyPicture; gRecCompany.Picture)
            {
            }
            column(MRNo; "Material Req. No.")
            {
            }
            column(MRDate; "Document Date")
            {
            }
            column(Requester_Department; "Requester Department")
            {
            }
            column(RemarksHeader; Remarks)
            {
            }
            column(MR_Usage_Category; "MR Usage Category")
            {
            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {
            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {
            }
            // column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code")
            // {
            // }
            column(Shortcut_Dimension_5_Code; "Shortcut Dimension 5 Code")
            {
            }
            column(Shortcut_Dimension_6_Code; "Shortcut Dimension 6 Code")
            {
            }
            // column(CreatedBy; Funct.GetFullNameUserIDGUID(MRHeader.SystemCreatedBy))
            // {
            // }
            column(ApprovalName1; ApprovalName1)
            {
            }
            column(ApprovalName2; ApprovalName2)
            {
            }
            column(External_Document_No_; "External Document No.")
            {
            }
            dataitem(MRLine; "Material Req. Line")
            {
                DataItemLink = "Material Req. No." = field("Material Req. No.");

                column(No_; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure; "Unit of Measure")
                {
                }
                column(PartNo; "Part No.")
                {
                }
                column(RemarksLine; Remarks)
                {
                }
                column(gRowNo; gRowNo)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    gRowNo += 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                lRecApprovalEntryMax: Record "Approval Entry";
                lRecApprovalEntry: Record "Approval Entry";
                lRecUser: Record User;
            begin
                lRecApprovalEntryMax.RESET;
                lRecApprovalEntryMax.SETCURRENTKEY("Entry No.");
                lRecApprovalEntryMax.SETRANGE(lRecApprovalEntryMax."Record ID to Approve", MRHeader.RecordId);
                lRecApprovalEntryMax.ASCENDING(TRUE);
                IF lRecApprovalEntryMax.FINDLAST THEN BEGIN
                    lRecApprovalEntry.RESET;
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Document No.", MRHeader."Material Req. No.");
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Record ID to Approve", MRHeader.RecordId);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry.Status, lRecApprovalEntry.Status::Approved);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Sequence No.", 1);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Workflow Step Instance ID", lRecApprovalEntryMax."Workflow Step Instance ID");
                    IF lRecApprovalEntry.FINDLAST THEN BEGIN
                        ApprovalName1 := lRecApprovalEntry."Approver ID" + '-' + FORMAT(lRecApprovalEntry."Last Date-Time Modified", 0, '<Day,2> <Month Text> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>');
                    END;
                    lRecApprovalEntry.RESET;
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Document No.", MRHeader."Material Req. No.");
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Record ID to Approve", MRHeader.RecordId);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry.Status, lRecApprovalEntry.Status::Approved);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Sequence No.", 2);
                    lRecApprovalEntry.SETRANGE(lRecApprovalEntry."Workflow Step Instance ID", lRecApprovalEntryMax."Workflow Step Instance ID");
                    IF lRecApprovalEntry.FINDLAST THEN BEGIN
                        ApprovalName2 := lRecApprovalEntry."Approver ID" + '-' + FORMAT(lRecApprovalEntry."Last Date-Time Modified", 0, '<Day,2> <Month Text> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>');
                    END;
                END;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    rendering
    {
        layout("Material Request")
        {
            Type = RDLC;
            LayoutFile = 'Report/Layout/Material Request.rdl';
        }
    }
    trigger OnInitReport()
    begin
        gRecCompany.GET();
        gRecCompany.CalcFields(Picture);
        gRowNo := 0;
    end;

    trigger OnPostReport()
    begin
    end;

    var
        gRecCompany: Record "Company Information";
        // Funct: Codeunit "MII Function";
        ApprovalName1, ApprovalName2 : Text[100];
        gRowNo: integer;
}
