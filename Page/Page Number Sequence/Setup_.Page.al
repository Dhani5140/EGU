page 50120 "MII Setup"
{
    PageType = Card;
    SourceTable = "MII Setup";
    Caption = ' Mapping No.Series';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group("Numbering Series")
            {
                field("Tax Nos."; Rec."Tax Nos.")
                {
                    ApplicationArea = All;
                }
                field("Material Req. Nos."; Rec."Material Req. Nos.")
                {
                    ApplicationArea = all;
                }
                field("PR Material Nos."; Rec."PR Material Nos.")
                {
                    ApplicationArea = All;
                }
                field("PR Asset Nos."; Rec."PR Asset Nos.")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("RFQ Nos."; Rec."RFQ Nos.")
                {
                    ApplicationArea = All;
                }
                field("Vensel Nos"; Rec."Vensel Nos")
                {
                    ApplicationArea = all;
                }
                field("Item Journal Document Nos"; Rec."Item Journal Document Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Journal Document Nos. from MR';
                }
                field("InvShip Nos. from MR"; Rec."InvShip Nos. from MR")
                {
                    ApplicationArea = all;
                }
                field("Purchase Order Nos."; Rec."Purchase Order Nos.")
                {
                    ApplicationArea = All;
                }
                field("MR Consignment Nos."; Rec."MR Consignment Nos.")
                {
                    ApplicationArea = All;
                }
                field("PR Consignment Nos."; Rec."PR Consignment Nos.")
                {
                    ApplicationArea = All;
                }
                field("RFQ Vendor"; Rec."RFQ Vendor")
                {
                    Caption = 'RFQ Max Vendor';
                    ApplicationArea = all;

                }
                field("Vendor PR Mandatory"; Rec."Vendor PR Mandatory")
                {
                    Caption = 'Create PO ON PR';
                    ApplicationArea = all;
                }
                field(Hide; Rec.Hide)
                {
                    Caption = 'Create PO ON RFQ';
                    ApplicationArea = all;
                }
                field("Enable TO from RO"; Rec."Enable TO from RO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Mengaktifkan fitur pembuatan Transfer Order dari Material Request.';
                }


            }
            // group("Default Mapping")
            // {
            //     // field("No. Direct Cost Applied Acc."; Rec."No. Direct Cost Applied Acc.")
            //     // {
            //     //     ApplicationArea = All;
            //     // }
            //     field("No. G/L PPH22"; Rec."No. G/L PPH22")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("No. G/L Journal PR Consignment"; Rec."No. G/L Journal PR Consignment")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("No. G/L Consignment PO"; Rec."No. G/L Consignment PO")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("No. PBBKB"; Rec."No. PBBKB")
            //     {
            //         ApplicationArea = All;
            //     }
            field("No. G/L FA"; Rec."No. G/L FA")
            {
                ApplicationArea = All;
            }
            field("FA Journal Template"; Rec."FA Journal Template")
            {
                ApplicationArea = All;
            }
            field("FA Journal Batch"; Rec."FA Journal Batch")
            {
                ApplicationArea = All;
            }
            //     field("MR Consign. Journal Template"; Rec."MR Consign. Journal Template")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("MR Consign. Journal Batch"; Rec."MR Consign. Journal Batch")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Default Gen. Prod PO"; Rec."Default Gen. Prod PO")
            //     {
            //         ApplicationArea = All;
            //     }
            // }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Refresh Custom Workflow Event/Response")
            {
                ApplicationArea = All;
                Image = Refresh;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                begin
                    refreshCustomWFEventResponse();
                end;
            }
        }
    }
    procedure refreshCustomWFEventResponse()
    var
        WorkflowEvent: Record "Workflow Event";
        WorkflowResponse: Record "Workflow Response";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowEvent.RESET;
        WorkflowEvent.SETFILTER("Function Name", '%1', '*_*');
        IF WorkflowEvent.FIND('-') THEN BEGIN
            WorkflowEvent.DeleteAll(TRUE);
        END;
        WorkflowEvent.RESET;
        WorkflowEvent.SETFILTER("Function Name", '%1|%2|%3', 'RUNWORKFLOWONAPPROVEAPPROVALREQUEST', 'RUNWORKFLOWONDELEGATEAPPROVALREQUEST', 'RUNWORKFLOWONREJECTAPPROVALREQUEST');
        IF WorkflowResponse.FIND('-') THEN BEGIN
            WorkflowEvent.DeleteAll(TRUE);
        END;
        WorkflowResponse.RESET;
        WorkflowResponse.SETFILTER("Function Name", '%1', '*_*');
        IF WorkflowResponse.FIND('-') THEN BEGIN
            WorkflowResponse.DeleteAll(TRUE);
        END;
        WorkflowResponse.RESET;
        WorkflowResponse.SETFILTER("Function Name", '%1|%2|%3|%4|%5|%6', 'SETSTATUSTOPENDINGAPPROVAL', 'CREATEAPPROVALREQUESTS', 'CANCELALLAPPROVALREQUESTS', 'RELEASEDOCUMENT', 'OPENDOCUMENT', 'SENDAPPROVALREQUESTFORAPPROVAL');
        IF WorkflowResponse.FIND('-') THEN BEGIN
            WorkflowResponse.DeleteAll(TRUE);
        END;
        WorkflowSetup.InsertApprovalsTableRelations();
        MESSAGE('Finish Refresh Workflow Custom');
        PAGE.RUN(Page::Workflows);
    end;

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}
