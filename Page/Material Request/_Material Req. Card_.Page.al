page 50102 "Material Req. Card"
{
    ApplicationArea = All;
    Caption = 'Request Order';
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval Request,Action Approval';
    PageType = Card;

    SourceTable = "Material Req. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = ALL;
                    Editable = true;
                    Caption = 'No';

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

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = ALL;
                    Editable = FALSE;
                }
                field("Mapping COA Code"; Rec."Mapping COA Code")
                {

                    ApplicationArea = all;
                    Editable = Edit;
                    ShowMandatory = false;
                    Visible = false;

                }
                field("Requester Name"; Rec."Requester Name")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    ShowMandatory = false;
                }
                field("Requester Department"; Rec."Requester Department")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = Edit;
                    ShowMandatory = false;
                }
                // field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,3';
                //     Editable = Edit;
                //     ShowMandatory = false;
                // }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    ShowMandatory = TRUE;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,5';
                    Editable = Edit;
                    ShowMandatory = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                }
                field("Unit Group"; Rec."Unit Group")
                {
                    ApplicationArea = ALL;
                    Editable = FALSE;
                    Visible = false;
                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    MultiLine = TRUE;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                    Editable = Edit;
                    ShowMandatory = true;
                    Visible = TOActive;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = All;
                    Editable = Edit;
                    ShowMandatory = true;
                    Visible = TOActive;
                }

            }

            part("Material Req. Subform"; "Material Req. Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Material Req. No." = field("Material Req. No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"Material Req. Header"),
                             "No." = FIELD("Material Req. No.");

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
                    var
                        lrecMRLine: Record "Material Req. Line";
                        lCUApproval_MR: Codeunit "Material Req. Approval";
                    begin
                        Rec.TestField("Status", Rec."Status"::Open);
                        gCUMRFunct.checkMandatoryFields(Rec);
                        // Rec."Status" := Rec."Status"::"Pending Approval";
                        IF lCUApproval_MR.CheckWorkflowEnabled(Rec) THEN
                            lCUApproval_MR.OnSendforApproval_MR(Rec)
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
                    var
                        lCUApproval_MR: Codeunit "Material Req. Approval";
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        lCUApproval_MR.OnCancelforApproval_MR(Rec);
                    end;
                }
                action("Approved")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = Approve;
                    Visible = FALSE;

                    trigger OnAction()
                    var
                        lrecUserSetup: Record "User Setup";
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
                        lRecApprovalEntryShow.SETRANGE(lRecApprovalEntryShow."Table ID", database::"Material Req. Header");
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

                    trigger OnAction()
                    begin
                        // Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        //Rec.CalcFields("Over Budget");
                        // IF rec."Over Budget" AND (Rec."Over Budget Approved" = FALSE) then begin
                        //     ERROR('Please Request Approval first because there is line over budget.');
                        // end;   
                        IF Rec.Status IN [Rec.Status::Open] = FALSE THEN ERROR('Status must be open to Release');
                        IF NOT gCUApproval_MR.IsEnabled_Custom(Rec) THEN BEGIN
                            gCUMRFunct.checkMandatoryFields(Rec);
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
                        lCUMRFunct: Codeunit "Material Req. Function";
                    begin
                        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                            ERROR('Please Cancel Send Approval to reopen');
                        END;
                        lCUMRFunct.checkMRLinehasPR(Rec."Material Req. No.", 'reopen');
                        // Rec.TestField("Status", Rec."Status"::Released);
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
                    lRec: Record "Material Req. Header";
                begin
                    Rec.TestField(Rec."Material Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Material Req. No.", Rec."Material Req. No.");
                    Report.Run(Report::"Material Request", TRUE, FALSE, lRec);
                end;
            }
            action("Create Purchase Request")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CreateDocument;

                trigger OnAction()
                begin
                    CurrPage.UPDATE();
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase request');
                    gCUPRFunct.createPRHeader_MR(Rec);
                end;
            }
            // action("Create Transfer Order")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Image = TransferOrder;
            //     Visible = TOActive;

            //     trigger OnAction()
            //     begin
            //         CurrPage.UPDATE();
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN
            //             ERROR('Status must be released or process to create transfer order');
            //         gCUMRFunct.createTransferOrder_MR(Rec);
            //     end;
            // }
            action("Create Invt. Shipment")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CreateDocument;

                trigger OnAction()
                begin
                    CurrPage.UPDATE();
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create inventory shipment');
                    // gCUMRFunct.checkInventoryLine(Rec);
                    gCUMRFunct.createInvDocHeader_MR(Rec);
                end;
            }
            action("Suggest Replenishment")
            {
                ApplicationArea = All;
                Caption = 'Get Min/Max Replenishment';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculatePlan;
                ToolTip = 'Otomatis menyarankan kuantitas order berdasarkan batas minimal/maksimal di gudang.';

                trigger OnAction()
                begin
                    CurrPage.UPDATE(TRUE); // Simpan header dulu (Location Code)

                    // Validasi: Cuma bisa dipakai saat status RO masih Open
                    IF Rec.Status <> Rec.Status::Open THEN
                        ERROR('Fungsi ini hanya bisa digunakan saat status dokumen Open.');

                    gCUMRFunct.SuggestMinMaxItems(Rec);
                end;
            }
            // action("Create Invt. Shipment Purch. Rcpt.")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Image = CreateDocument;

            //     trigger OnAction()
            //     begin
            //         CurrPage.UPDATE();
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create inventory shipment');
            //         gCUMRFunct.createInvDocHeader_PurchRcpt(Rec);
            //     end;
            // }
            // action("Create Item Journal")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Image = CreateDocument;
            //     trigger OnAction()
            //     begin
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN
            //             ERROR('Status must be released or process to create purchase request');
            //         gCUMRFunct.createItemJournalLine_MR(Rec);
            //     end;
            // }
        }
        area(Navigation)
        {
            group("Document Tracking")
            {
                Image = OrderTracking;

                // action(InvtShip)
                // {
                //     ApplicationArea = all;
                //     Caption = 'Inventory Shipment';
                //     Image = OrderTracking;
                //     trigger OnAction()
                //     var
                //         invt: Record "Invt. Shipment Line";
                //     begin
                //         invt.SetRange("Material Req. No.", rec."Material Req. No.");
                //         page.run(page::InvtNewShipment, invt);
                //     end;
                // }

                // action("Purchase Request")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Purchase Request Document';
                //     Image = OrderTracking;
                //     trigger OnAction()
                //     VAR
                //         mr: Record "PR Material Line";

                //     begin
                //         mr.SetRange("Material Req. No.", Rec."Material Req. No.");
                //         page.run(PAGE::"PR Material Lines", mr);
                //     end;
                // }
                // action("RFQ DOC")
                // {
                //     ApplicationArea = all;
                //     Caption = 'RFQ Document';
                //     Image = Document;
                //     trigger OnAction()
                //     VAR
                //         mr: Record "RFQ Line";
                //     begin
                //         mr.SetRange("Material Req. No.", rec."Material Req. No.");
                //         page.run(PAGE::"RFQ Request Lines", mr);
                //     end;
                // }
                // action("Vensel DOC")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Vendor selection Document';
                //     Image = Document;
                //     trigger OnAction()
                //     VAR
                //         mr: Record "RFQ Line";
                //     begin
                //         mr.SetRange("Material Req. No.", rec."Material Req. No.");
                //         page.run(PAGE::"vensel Request Lines", mr);
                //     end;
                // }
                // action("Purchase Order")
                // {
                //     ApplicationArea = all;
                //     Caption = 'PO Document';
                //     Image = Document;
                //     trigger OnAction()
                //     VAR
                //         mr: Record "Purchase Line";
                //     begin
                //         mr.SetRange("Material Req. No.", rec."Material Req. No.");
                //         page.run(PAGE::"Purchase Lines", mr);
                //     end;
                // }

            }
        }

    }
    trigger OnOpenPage()
    begin
        IF MIISetup.GET() THEN
            TOActive := MIISetup."Enable TO from RO"
        ELSE
            Edit := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            Edit := TRUE;
        END
        ELSE BEGIN
            Edit := FALSE;
        END;
    end;
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;

    local procedure Cek()
    begin
        rec."No." := rec."Material Req. No.";
    end;

    var
        InventorySetup: Record "Inventory Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        gCUMRFunct: Codeunit "Material Req. Function";
        gCUPRFunct: Codeunit "PR Material Function";
        gCUApproval_MR: Codeunit "Material Req. Approval";
        Edit: Boolean;
        MIISetup: Record "MII Setup";
        TOActive: Boolean;
}
