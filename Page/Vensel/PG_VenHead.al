page 50159 "Vendor Select Header"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Vensel Header";
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Released,Action Approval';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vensel No."; Rec."Vensel No.")
                {
                    ApplicationArea = All;
                    Editable = true;

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
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                // field("Location Code"; Rec."Location Code")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                // }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Remarks VS';
                    Editable = gBolEditable;
                    MultiLine = TRUE;
                }
                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = all;
                    Caption = 'Material No';
                }
                // field("Total Amount"; Rec."Total Amount")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
            }
            group(Dimension)
            {
                // field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,1';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,2';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,3';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,4';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,5';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,6';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,7';
                //     Editable = gBolEditable;
                // }
                // field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                // {
                //     ApplicationArea = all;
                //     Caption = '1,2,8';
                //     Editable = gBolEditable;
                // }
            }
            part("RFQ Vendor Subform"; "RFQ Vendor Subform")
            {
                Caption = 'Vendor';
                ApplicationArea = All;
                SubPageLink = "RFQ No." = field("RFQ No.");
                UpdatePropagation = Both;
            }
            part("RFQ Line Details Subform"; "RFQ Line Details Subform")
            {
                Caption = 'Line Details';
                ApplicationArea = All;
                SubPageLink = "Entry No. RFQ Vendor" = field("Entry No. RFQ Vendor");
                Provider = "RFQ Vendor Subform";
                UpdatePropagation = Both;
            }
            part("RFQ Subform"; "RFQ Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "RFQ No." = Field("RFQ No.");
                UpdatePropagation = both;
                Visible = false;
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"RFQ Header"), "No." = FIELD("RFQ No.");
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
            group("Released")
            {
                // action("Send Approval Request")
                // {
                //     ApplicationArea = All;
                //     Promoted = True;
                //     PromotedCategory = Category4;
                //     Image = SendApprovalRequest;

                //     trigger OnAction()
                //     begin
                //         Rec.TestField("Status", Rec."Status"::Open);
                //         gCURFQunct.checkRFQLinehasWinner(Rec."RFQ No.");
                //         IF gCUApproval_RFQ.CheckWorkflowEnabled(Rec) THEN
                //             gCUApproval_RFQ.OnSendforApproval_RFQ(Rec)
                //         ELSE
                //             Message('Approval has been sent.');
                //         CurrPage.UPDATE();
                //     end;
                // }
                // action("Cancel Approval Request")
                // {
                //     ApplicationArea = All;
                //     Image = CancelApprovalRequest;
                //     Promoted = True;
                //     PromotedCategory = Category4;

                //     trigger OnAction()
                //     begin
                //         Rec.TestField(Status, Rec.Status::"Pending Approval");
                //         gCUApproval_RFQ.OnCancelforApproval_RFQ(Rec);
                //     end;
                // }
                // action("Approved")
                // {
                //     ApplicationArea = All;
                //     Promoted = True;
                //     PromotedCategory = Category4;
                //     Image = Approve;
                //     Visible = FALSE;

                //     trigger OnAction()
                //     var
                //         lrecUserSetup: Record "User Setup";
                //     begin
                //         Rec.TestField("Status", Rec."Status"::"Pending Approval");
                //         Rec.VALIDATE("Status", Rec."Status"::Released);
                //         CurrPage.UPDATE();
                //         Message('Document has been approved.');
                //     end;
                // }
                // action("Reject")
                // {
                //     ApplicationArea = All;
                //     Promoted = True;
                //     PromotedCategory = Category4;
                //     Image = Reject;
                //     Visible = FALSE;

                //     trigger OnAction()
                //     begin
                //         Rec.TestField("Status", Rec."Status"::"Pending Approval");
                //         Rec."Status" := Rec."Status"::"Open";
                //         CurrPage.UPDATE();
                //         Message('Document has been rejected.');
                //     end;
                // }
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
                        IF NOT gCUApproval_RFQ.IsEnabled_Custom2(Rec) THEN BEGIN
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
                    begin
                        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                            ERROR('Please Cancel Send Approval to reopen');
                        END;
                        gCURFQunct.checkRFQLinehasPO(Rec."RFQ No.", 0, 'reopen');
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
                    lRec: Record "RFQ Header";
                begin
                    Rec.TestField(Rec."RFQ No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."RFQ No.", Rec."RFQ No.");
                    Report.RUN(Report::"RFQ Printout", true, false, lRec)
                end;
            }
            // action("Get Purchase Req.")
            // {
            //     Caption = 'Get Purchase Request';
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = GetEntries;

            //     trigger OnAction()
            //     var
            //         lRecPRLinePage: Record "PR Material Line";
            //         lRecPRLine: Record "PR Material Line";
            //         lPageSelectPR: Page "Select PR Line";
            //         lCURFQfunc: Codeunit "RFQ Function";
            //     begin
            //         Rec.TestField(Status, Rec.Status::Open);
            //         Rec.TestField("Location Code");
            //         lRecPRLinePage.RESET;
            //         lRecPRLinePage.SETFILTER(Quantity, '>%1', 0);
            //         lRecPRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
            //         lRecPRLinePage.SETFILTER(Status, '%1|%2', lRecPRLinePage.Status::Released, lRecPRLinePage.Status::Processed);
            //         lRecPRLinePage.SETRANGE("Location Code", Rec."Location Code");
            //         IF lRecPRLinePage.FIND('-') THEN BEGIN
            //             CLEAR(lPageSelectPR);
            //             lPageSelectPR.SetTableView(lRecPRLinePage);
            //             lPageSelectPR.LookupMode(true);
            //             CASE lPageSelectPR.RUNMODAL() OF
            //                 ACTION::LookupOK:
            //                     BEGIN
            //                         CurrPage.UPDATE();
            //                         lRecPRLine.RESET;
            //                         lPageSelectPR.SetSelectionFilter(lRecPRLine);
            //                         IF lRecPRLine.FIND('-') THEN BEGIN
            //                             REPEAT
            //                                 lCURFQfunc.CreateRFQLine_PR(lRecPRLine, Rec."RFQ No.");
            //                             UNTIL lRecPRLine.NEXT = 0;
            //                         END;
            //                     END;
            //             end;
            //         END
            //         ELSE BEGIN
            //             ERROR('No Purchase Request Line to be get');
            //         END;
            //         CurrPage.UPDATE;
            //     end;
            // }

            // action("Reinsert Line Details")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Image = Recalculate;

            //     trigger OnAction()
            //     var
            //         lCURFQFunction: Codeunit "RFQ Function";
            //     begin
            //         lCURFQFunction.reinsertRFQLineDetails(Rec);
            //         CurrPage.UPDATE();
            //     end;
            // }
            action("View RFQ Line Details")
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Compare Vendor';
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Document;

                trigger OnAction()
                var
                    lrecRFQLineDetails: Record "RFQ Line Details";
                begin
                    lrecRFQLineDetails.RESET();
                    lrecRFQLineDetails.SetCurrentKey("Entry No.");
                    lrecRFQLineDetails.SETRANGE("RFQ No.", Rec."RFQ No.");
                    lrecRFQLineDetails.Ascending(TRUE);
                    IF lrecRFQLineDetails.FIND('-') THEN PAGE.RUN(PAGE::"List RFQ Line Details", lrecRFQLineDetails);
                end;
            }
            action("Open PO Document")
            {
                ApplicationArea = all;
                Promoted = true;
                Caption = 'Open PO Document';
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Document;

                trigger OnAction()
                var
                    PO: Record "Purchase Header";
                begin
                    PO.SetRange("RFQ No.", REC."RFQ No.");
                    PAGE.RUN(50, PO);
                end;
            }
            action("Create PO")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    lCURFQFunction: Codeunit "RFQ Function";
                begin
                    CurrPage.UPDATE();
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed, Rec.Status::"Send To Vendor"]) THEN ERROR('Status must be released or process to create purchase order');
                    lCURFQFunction.createPOHeader_RFQ2(Rec);
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
                        line: Record "RFQ Line";
                    begin
                        line.SetRange("Material Req. No.", mr."Material Req. No.");
                        page.run(PAGE::"Material Request Lines", line);
                    end;
                }
                action("Purchase Request")
                {
                    ApplicationArea = all;
                    Caption = 'Purchase Request Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    VAR
                        mr: Record "PR Material Line";
                    begin
                        mr.SetRange("Purchase Req. No.", Rec."Purchase Request No.");
                        page.run(PAGE::"PR Material Lines", mr);
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
                        mr.SetRange("RFQ No.", rec."RFQ No.");
                        page.run(PAGE::"RFQ Request Lines", mr);
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
                        mr.SetRange("RFQ No.", rec."RFQ No.");
                        page.run(PAGE::"Purchase Lines", mr);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
        Editable2 := true
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
            Editable2 := true;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
            Editable2 := true;
        END;
    end;
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;
    var
        gCURFQunct: Codeunit "RFQ Function";
        gCUApproval_RFQ: Codeunit "RFQ Approval";
        gBolEditable: Boolean;
        Editable2: Boolean;
}