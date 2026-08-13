page 50158 "RFQ Card SH"
{
    ApplicationArea = All;
    PageType = Card;
    Editable = false;
    SourceTable = "RFQ Header";
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval Request,Action Approval';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("RFQ No."; Rec."RFQ No.")
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
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("PR No."; Rec."PR No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    TableRelation = "PR Material Header"."Purchase Req. No." where(Status = filter(Released));
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
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

            part("RFQ Subform"; "RFQ Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "RFQ No." = Field("RFQ No.");
                UpdatePropagation = both;
            }
            part("RFQ Vendor Subform"; "RFQ Vendor Subform")
            {
                Caption = 'Vendor';
                ApplicationArea = All;
                SubPageLink = "RFQ No." = field("RFQ No.");
                UpdatePropagation = Both;
            }
            // part("RFQ Line Details Subform"; "RFQ Line Details Subform")
            // {
            //     Caption = 'Line Details';
            //     ApplicationArea = All;
            //     SubPageLink = "Entry No. RFQ Vendor" = field("Entry No. RFQ Vendor");
            //     Provider = "RFQ Vendor Subform";
            //     UpdatePropagation = Both;
            // }

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
                        gCURFQunct.checkRFQLinehasWinner(Rec."RFQ No.");
                        IF gCUApproval_RFQ.CheckWorkflowEnabled(Rec) THEN
                            gCUApproval_RFQ.OnSendforApproval_RFQ(Rec)
                        ELSE
                            Message('Approval has been sent.');
                        CurrPage.UPDATE();
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = True;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        gCUApproval_RFQ.OnCancelforApproval_RFQ(Rec);
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
                        IF NOT gCUApproval_RFQ.IsEnabled_Custom(Rec) THEN BEGIN
                            Rec.VALIDATE("Status", Rec."Status"::Released);
                            CurrPage.UPDATE();
                            Message('Document has been released');
                        END
                        ELSE BEGIN
                            ERROR('Workflow for this record data type is enabled, cannot manually release');
                        END;
                    end;
                }
                action("Send To Vendor")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = SendTo;

                    trigger OnAction()
                    begin

                        IF Rec.Status IN [Rec.Status::Open] = FALSE THEN ERROR('Status must be open to Release');
                        IF NOT gCUApproval_RFQ.IsEnabled_Custom(Rec) THEN BEGIN
                            Rec.VALIDATE("Status", Rec."Status"::"Send To Vendor");
                            CurrPage.UPDATE();
                            Message('Document has been Send To Vendor');
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
                        IF Rec.Status IN [Rec.Status::Released, Rec.Status::Processed, Rec.Status::"Send To Vendor"] = FALSE THEN ERROR('Status must be released or process to Reopen');
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
                    QREC: Record "RFQ Vendor List";
                begin
                    Rec.TestField(Rec."RFQ No.");
                    lRec.RESET;
                    QREC.SetRange(QREC."RFQ No.", rec."RFQ No.");
                    Report.RUN(report::RFQ_Printour, TRUE, FALSE, lRec);

                end;
            }
            action("Get Purchase Req.")
            {
                Caption = 'Get Purchase Request';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = GetEntries;

                trigger OnAction()
                var
                    lRecPRLinePage: Record "PR Material Line";
                    lRecPRLine: Record "PR Material Line";
                    lPageSelectPR: Page "Select PR Line";
                    lCURFQfunc: Codeunit "RFQ Function";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    //Rec.TestField("Location Code");
                    rec.TestField("PR No.");
                    lRecPRLinePage.RESET;
                    lRecPRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecPRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
                    lRecPRLinePage.SETFILTER(Status, '%1|%2', lRecPRLinePage.Status::Released, lRecPRLinePage.Status::Processed);
                    lRecPRLinePage.SETRANGE("Purchase Req. No.", Rec."PR No.");
                    //lRecPRLinePage.SETRANGE("Location Code", Rec."Location Code");
                    lRecPRLine.SetRange("Purchase Req. No.", rec."PR No.");
                    IF lRecPRLinePage.FIND('-') THEN BEGIN
                        CLEAR(lPageSelectPR);
                        lPageSelectPR.SetTableView(lRecPRLinePage);
                        lPageSelectPR.LookupMode(true);
                        CASE lPageSelectPR.RUNMODAL() OF
                            ACTION::LookupOK:
                                BEGIN
                                    CurrPage.UPDATE();
                                    lRecPRLine.RESET;
                                    lPageSelectPR.SetSelectionFilter(lRecPRLine);
                                    IF lRecPRLine.FIND('-') THEN BEGIN
                                        REPEAT
                                            lCURFQfunc.CreateRFQLine_PR(lRecPRLine, Rec."RFQ No.");
                                        UNTIL lRecPRLine.NEXT = 0;
                                    END;
                                END;
                        end;
                    END
                    ELSE BEGIN
                        ERROR('No Purchase Request Line to be get');
                    END;
                    CurrPage.UPDATE;
                end;
            }
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
                    IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase order');
                    lCURFQFunction.createPOHeader_RFQ(Rec);
                    CurrPage.UPDATE();
                end;
            }
        }
        area(Navigation)
        {
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
            gBolEditable := true;
            Editable2 := true;
        END
        ELSE BEGIN
            gBolEditable := false;
            Editable2 := false;
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
