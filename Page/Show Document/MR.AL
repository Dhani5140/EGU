page 50169 "Material Req. Card sh"
{
    ApplicationArea = All;
    Caption = 'Material Request ';
    Editable = false;
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
                    Editable = Edit;
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
                    ShowMandatory = TRUE;

                }
                field("Requester Name"; Rec."Requester Name")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    ShowMandatory = true;
                }
                field("Requester Department"; Rec."Requester Department")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = Edit;
                    ShowMandatory = TRUE;
                }
                // field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,3';
                //     Editable = Edit;
                //     ShowMandatory = TRUE;
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
                    ShowMandatory = TRUE;
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
                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = ALL;
                    Editable = true;
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
                SubPageLink = "Table ID" = CONST(database::"Material Req. Header"), "No." = FIELD("Material Req. No.");
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
            // action("Create Purchase Request")
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
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase request');
            //         gCUPRFunct.createPRHeader_MR(Rec);
            //     end;
            // }
            // action("Create Invt. Shipment")
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
            //         // gCUMRFunct.checkInventoryLine(Rec);
            //         gCUMRFunct.createInvDocHeader_MR(Rec);
            //     end;
            // }
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
    }
    trigger OnOpenPage()
    begin
        Editable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            Editable := TRUE;
        END
        ELSE BEGIN
            Editable := FALSE;
        END;
    end;
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;
    var
        InventorySetup: Record "Inventory Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        gCUMRFunct: Codeunit "Material Req. Function";
        gCUPRFunct: Codeunit "PR Material Function";
        gCUApproval_MR: Codeunit "Material Req. Approval";
        Edit: Boolean;
}
