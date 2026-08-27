page 50105 "PR Material Card"
{
    PageType = Card;
    SourceTable = "PR Material Header";
    Caption = 'Purchase Request Header';
    ApplicationArea = All;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval Request,Action Approval';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then begin
                            CurrPage.UPDATE();
                        end;
                    end;
                }
                // field("Urgent Status"; Rec."Urgent Status")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                //     StyleExpr = gStyleItemNo;

                //     trigger OnValidate()
                //     begin
                //         gStyleItemNo := gCUPRFunct.changeColorStyleUrgent(Rec);
                //         CurrPage.UPDATE;
                //     end;
                // }

                field("PR Type"; Rec."PR Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether this is a New Request or a Replacement PR.';
                    Style = Strong;

                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                // field("Vendor No."; Rec."Vendor No.")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                // }

                // field("Item Category Code"; Rec."Item Category Code")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                //     ShowMandatory = true;
                //     ToolTip = 'Pilih kategori barang untuk dokumen PR ini. Satu PR hanya boleh memuat barang dari satu kategori.';
                // }

                //BPK Penabur Only
                // field("Item Category Code"; Rec."Item Category Code")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                //     ShowMandatory = true;
                //     ToolTip = 'Pilih kategori barang untuk dokumen PR ini. Satu PR hanya boleh memuat barang dari satu kategori.';


                //     trigger OnValidate()
                //     begin

                //         CurrPage.SaveRecord();


                //         CurrPage."PR Material Subform".Page.Update(false);
                //     end;

                // }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Requester Name"; Rec."Requester Name")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = suite;
                    Editable = gBolEditable;
                    ShowMandatory = mandatory;
                    Visible = mandatory;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = suite;
                    Editable = false;
                    ShowMandatory = mandatory;
                    Visible = mandatory;

                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = suite;
                    Editable = gBolEditable;
                    ShowMandatory = mandatory;
                    Visible = mandatory;
                }
                field("Payment Terms Name"; Rec."Payment Terms Name")
                {
                    ApplicationArea = Suite;
                    Editable = FALSE;
                    //ShowMandatory = mandatory;
                    //Visible = mandatory;
                }
                field("MR No."; Rec."MR No.")
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                    TableRelation = "Material Req. Header"."Material Req. No." where(Status = filter(Released | "Partial Receive / Processed On PR"));
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                // field("External Document No."; Rec."External Document No.")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                // }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    MultiLine = TRUE;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }


            }
            group(Dimension)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,2';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,3';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,4';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,5';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,6';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,7';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,8';
                    Editable = gBolEditable;
                }
            }
            part("PR Material Subform"; "PR Material Subform")
            {
                Caption = 'Lines';
                ApplicationArea = suite;
                Editable = true;
                Enabled = true;
                SubPageLink = "Purchase Req. No." = field("Purchase Req. No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"PR Material Header"), "No." = FIELD("Purchase Req. No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Approval Request")
            {
                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = SendApprovalRequest;


                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::Open);
                        gCUPRFunct.MANDATORYPRHEADER(Rec);
                        IF gCUApproval_PR.CheckWorkflowEnabled(Rec) THEN
                            gCUApproval_PR.OnSendforApproval_PRMaterial(Rec)
                        ELSE
                            Message('Approval has been sent.');
                        CurrPage.UPDATE();
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    // Enabled = CanCancelApprovalforRecord OR CanCancelApprovalforFlow;
                    Promoted = True;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        gCUApproval_PR.OnCancelforApproval_PRMaterial(Rec);
                    end;
                }
                action("Approved")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = Approve;
                    Visible = false;



                    trigger OnAction()
                    var
                        lrecUserSetup: Record "User Setup";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        Rec.VALIDATE("Status", Rec."Status"::Released);
                        CurrPage.UPDATE();
                        Message('Document has been approved.');

                    end;


                }
                action("Reject")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = Reject;
                    Visible = FALSE;

                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        Rec."Status" := Rec."Status"::"Open";
                        CurrPage.UPDATE();
                        Message('Document has been rejected.');
                    end;
                }
                action("Approval Entries")
                {
                    ApplicationArea = All;
                    Image = EntriesList;
                    Promoted = True;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        lRecApprovalEntry: Record "Approval Entry";
                        lRecApprovalEntryShow: Record "Approval Entry";
                        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
                        lPageApprovals: Page "Requests to Approve";
                        lPageApprovalEntries: Page "Approval Entries";
                        WorkflowWebhookEntries: Page "Workflow Webhook Entries";
                    begin
                        lRecApprovalEntryShow.RESET;
                        lRecApprovalEntryShow.FILTERGROUP(2);
                        lRecApprovalEntryShow.SETRANGE(lRecApprovalEntryShow."Record ID to Approve", Rec.RECORDID);
                        lRecApprovalEntryShow.SETRANGE(lRecApprovalEntryShow."Table ID", database::"PR Material Header");
                        lRecApprovalEntryShow.FILTERGROUP(0);
                        IF lRecApprovalEntryShow.FIND('-') THEN BEGIN
                            PAGE.RUNMODAL(Page::"Approval Entries", lRecApprovalEntryShow);
                            exit;
                        END
                        ELSE BEGIN
                            ERROR('No approval entries found for this document');
                        END;
                    end;
                }
                action("Release")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = ReleaseDoc;
                    //Visible = mandatory;

                    trigger OnAction()
                    begin
                        // Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        //Rec.CalcFields("Over Budget");
                        // IF rec."Over Budget" AND (Rec."Over Budget Approved" = FALSE) then begin
                        //     ERROR('Please Request Approval first because there is line over budget.');
                        // end;
                        IF Rec.Status IN [Rec.Status::Open] = FALSE THEN ERROR('Status must be open to Release');
                        IF NOT gCUApproval_PR.IsEnabled_Custom(Rec) THEN BEGIN
                            gCUPRFunct.MANDATORYPRHEADER(Rec);
                            Rec.VALIDATE("Status", Rec."Status"::Released);
                            CurrPage.UPDATE();
                            Message('Document has been released');
                        END
                        ELSE BEGIN
                            ERROR('Workflow for this record data type is enabled, cannot manually release');
                        END;
                    end;
                }
                action("Reopen")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        lCUPRFunct: Codeunit "PR Material Function";
                    begin
                        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                            ERROR('Please Cancel Send Approval to reopen');
                        END;
                        lCUPRFunct.checkPRLinehasRFQ(Rec."Purchase Req. No.", 'reopen');
                        IF Rec.Status IN [Rec.Status::Released, Rec.Status::Processed] = FALSE THEN ERROR('Status must be released or process to Reopen');
                        Rec.VALIDATE("Status", Rec."Status"::Open);
                        CurrPage.Update();
                        Message('Document has been reopen.');
                    end;
                }
            }
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "PR Material Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Purchase Req. No.", Rec."Purchase Req. No.");
                    Report.RUN(report::"PR Material Printout", TRUE, FALSE, lRec);

                end;
            }
            action("Get Material Req.")
            {
                Caption = 'Get Material Request';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    lRecMRLinePage: Record "Material Req. Line";
                    lRecMRLine: Record "Material Req. Line";
                    lPageSelectMR: Page "Select MR Line";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    Rec.TestField("Location Code");
                    // Rec.TestField("Shortcut Dimension 2 Code");
                    lRecMRLinePage.RESET;
                    lRecMRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecMRLinePage.SETFILTER("Material Req. No.", Rec."MR No.");
                    lRecMRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
                    lRecMRLinePage.SETFILTER(Status, '%1|%2', lRecMRLinePage.Status::Released, lRecMRLinePage.Status::"Partial Receive / Processed On PR");
                    lRecMRLinePage.SETRANGE(Cancel, FALSE);
                    lRecMRLinePage.SETRANGE("Location Code", Rec."Location Code");
                    //lRecMRLine.SetRange("Material Req. No.", Rec."MR No.");
                    // lRecMRLinePage.SETFILTER("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                    IF lRecMRLinePage.FIND('-') THEN BEGIN
                        CLEAR(lPageSelectMR);
                        lPageSelectMR.SetTableView(lRecMRLinePage);
                        lPageSelectMR.LookupMode(true);
                        CASE lPageSelectMR.RUNMODAL() OF
                            ACTION::LookupOK:
                                BEGIN
                                    CurrPage.UPDATE();
                                    lRecMRLine.RESET;
                                    lPageSelectMR.SetSelectionFilter(lRecMRLine);
                                    IF lRecMRLine.FIND('-') THEN BEGIN
                                        REPEAT
                                            gCUPRFunct.createPRLine_MR(lRecMRLine, Rec."Purchase Req. No.");
                                        UNTIL lRecMRLine.NEXT = 0;
                                    END;
                                END;
                        end;
                    END
                    ELSE BEGIN
                        ERROR('No Material Request Line to be get');
                    END;
                    CurrPage.UPDATE;
                end;
            }
            action("Create Replacement PR")
            {
                ApplicationArea = All;
                Caption = 'Create Replacement PR';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;
                ToolTip = 'Batalkan PR ini dan buat draf PR Replacement baru.';

                trigger OnAction()
                var
                    lCUPRFunct: Codeunit "PR Material Function";
                begin

                    if not (Rec.Status in [Rec.Status::Released, Rec.Status::"Pending Approval", Rec.Status::Closed]) then
                        Error('Hanya PR dengan status Released, Pending Approval, atau Closed yang bisa di-Replace.');

                    if Rec."PR Type" = Rec."PR Type"::Replacement then
                        Error('Dokumen ini sudah merupakan Replacement dan tidak bisa di-Replace lagi.');

                    if Confirm('Apakah Anda yakin ingin membatalkan PR ini dan membuat PR Replacement baru?', false) then
                        lCUPRFunct.CreateReplacementPR(Rec);
                end;
            }
            // action("Create PO")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = CreateDocument;

            //     trigger OnAction()
            //     var
            //         lCURFQFunction: Codeunit "PR Material Function";
            //     begin
            //         CurrPage.UPDATE();
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase order');
            //         lCURFQFunction.createPOHeader_PR(Rec);
            //         CurrPage.UPDATE();
            //     end;
            // }

            action("Create PO1")
            {
                ApplicationArea = All;
                Caption = 'Create PO';
                Visible = mandatory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    lCURFQFunction: Codeunit "PR Material Function";
                begin
                    CurrPage.UPDATE();
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase order');
                    lCURFQFunction.createPOHeader_PRMAT(Rec);
                    CurrPage.UPDATE();
                end;
            }
            action("Create RFQ")
            {
                Caption = 'Create RFQ';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    lCURFQFunct: Codeunit "PR Material Function";
                begin
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create RFQ');
                    CurrPage.UPDATE();
                    lCURFQFunct.createRFQHeader_PR(Rec);
                    CurrPage.UPDATE();
                end;
            }


        }
        area(Navigation)
        {
            group("Document Tracking")
            {
                Caption = 'P&urchase Request';
                Image = Trace;
                action("Material Request")
                {
                    ApplicationArea = all;
                    Caption = 'Material Request Document';
                    Image = Document;
                    trigger OnAction()
                    VAR
                        mr: Record "Material Req. Line";

                    begin
                        mr.SetRange("Material Req. No.", Rec."MR No.");
                        page.run(PAGE::"Material Request Lines", mr);
                    end;
                }
                action("RFQ DOC")
                {
                    ApplicationArea = all;
                    Caption = 'RFQ Document';
                    Image = Document;
                    trigger OnAction()
                    VAR
                        mr: Record "RFQ Line";
                    begin
                        mr.SetRange("Purchase Req. No.", rec."Purchase Req. No.");
                        page.run(PAGE::"RFQ Request Lines", mr);
                    end;
                }
                action("Vensel DOC")
                {
                    ApplicationArea = all;
                    Caption = 'Vendor selection Document';
                    Image = Document;
                    trigger OnAction()
                    VAR
                        mr: Record "RFQ Line";
                    begin
                        mr.SetRange("Purchase Req. No.", rec."Purchase Req. No.");
                        page.run(PAGE::"vensel Request Lines", mr);
                    end;
                }
                action("Purchase Order")
                {
                    ApplicationArea = all;
                    Caption = 'PO Document';
                    Image = Document;
                    trigger OnAction()
                    VAR
                        mr: Record "Purchase Line";
                    begin
                        mr.SetRange("Material Req. No.", rec."Material Req. No.");
                        page.run(PAGE::"Purchase Lines", mr);
                    end;
                }

            }
        }




    }
    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
        END;
        gStyleItemNo := gCUPRFunct.changeColorStyleUrgent(Rec);
    end;
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;
    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin

        setmandatory();
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());


        OnAfterSetControlAppearance();
    end;

    trigger OnInit()
    begin
        setmandatory();
    end;


    [IntegrationEvent(true, false)]
    local procedure OnAfterSetControlAppearance()
    begin
    end;

    local procedure setmandatory()
    var
        miisetup: Record "MII Setup";
    begin
        if miisetup.Get() then begin
            mandatory := miisetup."Vendor PR Mandatory";
        end;

    end;


    var
        grecPurchaseReqLine: Record "PR Material Line";
        gCUApproval_PR: Codeunit "PR Material Approval";
        gCUPRFunct: Codeunit "PR Material Function";
        gStyleItemNo: Text[100];
        gBolEditable: Boolean;
        miisetup: Record "MII Setup";
        mandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;

        VISIBLE: Boolean;

}
