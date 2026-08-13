namespace RFQ.RFQ_Head;
using Microsoft.Foundation.Attachment;
using RFQ.vendor_List;
using System.Security.User;
page 50114 "RFQ Header"
{
    ApplicationArea = All;
    PageType = Card;
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
                    Editable = Edit;
                }
                // field("Location Code"; Rec."Location Code")
                // {
                //     ApplicationArea = All;
                //     Editable = Editable;
                // }
                field("Purchase Request No."; Rec."Purchase Request No.")
                {
                    ApplicationArea = ALL;
                    Editable = Edit;
                    TableRelation = "PR Material Header"."Purchase Req. No.";
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("External Document No."; Rec."External Document No.")
                // {
                //     ApplicationArea = All;
                //     Editable = Editable;
                // }
                // field(Remarks; Rec.Remarks)
                // {
                //     ApplicationArea = All;
                //     Editable = Editable;
                //     MultiLine = TRUE;
                // }
                // field("Total Amount"; Rec."Total Amount")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
            }

            // part("RFQ Vendor Subform"; "Selction Vendor Subform")
            // {
            //     Caption = 'Vendor';
            //     ApplicationArea = All;
            //     SubPageLink = "RFQ No." = field("RFQ No.");
            //     UpdatePropagation = Both;
            // }

            // part("RFQ Subform"; "RFQ Subform")
            // {
            //     Caption = 'Lines';
            //     ApplicationArea = All;
            //     SubPageLink = "RFQ No." = Field("RFQ No.");
            //     UpdatePropagation = both;
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

                end;
            }
            action("Get Purchase Req.")
            {
                Caption = 'Get Purchase Request';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    lRecPRLinePage: Record "PR Material Line";
                    lRecPRLine: Record "PR Material Line";
                    lPageSelectPR: Page "Select PR Line";
                    lCURFQfunc: Codeunit "RFQ Function";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    Rec.TestField("Purchase Request No.");
                    lRecPRLinePage.RESET;
                    lRecPRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecPRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
                    lRecPRLinePage.SETFILTER(Status, '%1|%2', lRecPRLinePage.Status::Released, lRecPRLinePage.Status::Processed);
                    lRecPRLinePage.SETRANGE("Purchase Req. No.", Rec."Purchase Request No.");
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
            // action("View RFQ Line Details")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Image = Document;

            //     trigger OnAction()
            //     var
            //         lrecRFQLineDetails: Record "RFQ Line Details";
            //     begin
            //         lrecRFQLineDetails.RESET();
            //         lrecRFQLineDetails.SetCurrentKey("Entry No.");
            //         lrecRFQLineDetails.SETRANGE("RFQ No.", Rec."RFQ No.");
            //         lrecRFQLineDetails.Ascending(TRUE);
            //         IF lrecRFQLineDetails.FIND('-') THEN PAGE.RUN(PAGE::"List RFQ Line Details", lrecRFQLineDetails);
            //     end;
            // }
            // action("Create Vendor Selection")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = CreateDocument;

            //     trigger OnAction()
            //     var
            //         lCURFQFunction: Codeunit "RFQ Function";
            //     begin
            //         CurrPage.UPDATE();
            //         IF NOT (Rec.Status IN [Rec.Status::Released, Rec.Status::Processed]) THEN ERROR('Status must be released or process to create purchase order');
            //         lCURFQFunction.createPOHeader_RFQ(Rec);
            //         CurrPage.UPDATE();
            //     end;
            // }
        }
        area(Navigation)
        {
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
        gCURFQunct: Codeunit "RFQ Function";
        gCUApproval_RFQ: Codeunit "RFQ Approval";
        Edit: Boolean;
}
