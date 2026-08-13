page 50167 "RFQ Line Details"
{
    PageType = Card;
    SourceTable = "RFQ Line Details";
    InsertAllowed = FALSE;

    layout
    {
        area(content)
        {
            field(gRFQNo; gRFQNo)
            {
                Caption = 'RFQ No';
                ApplicationArea = All;
                Editable = FALSE;
            }
            field(gRFQLineNo; gRFQLineNo)
            {
                Caption = 'RFQ Line No';
                ApplicationArea = All;
                Editable = FALSE;
            }
            repeater(General)
            {
                field("Entry No. RFQ Vendor"; Rec."Entry No. RFQ Vendor")
                {
                    ApplicationArea = All;
                    Editable = gBolEditableVendorNo;

                    trigger OnValidate()
                    begin
                        IF Rec."Entry No. RFQ Vendor" <> 0 THEN
                            gBolEditable := TRUE
                        ELSE
                            gBolEditable := FALSE;
                        CurrPage.UPDATE;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("PPH 22"; Rec."PPH 22")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                // field(Quantity; Rec.Quantity)
                // {
                //     ApplicationArea = All;
                //     Editable = FALSE;
                // }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                // field("Subtotal Amount"; Rec."Subtotal Amount")
                // {
                //     ApplicationArea = All;
                //     Editable = FALSE;
                // }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }



                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                // field(PBBKB; Rec.PBBKB)
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                // }
                // field("PBBKB Amount"; Rec."PBBKB Amount")
                // {
                //     ApplicationArea = All;
                //     Editable = FALSE;
                // }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                // field("Check Win"; Rec."Check Win")
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;
                // }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add New Line")
            {
                ApplicationArea = All;
                Image = NewItem;
                Promoted = True;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lRec: Record "RFQ Line Details";
                    lRecIns: Record "RFQ Line Details";
                    lRecRFQHeader: Record "RFQ Header";
                    lRecRFQVendor: Record "RFQ Vendor List";
                    CountVendor: Integer;
                begin
                    CLEAR(CountVendor);
                    lRecRFQHeader.RESET;
                    lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
                    IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
                    // lRec.RESET;
                    // lRec.SETRANGE("RFQ No.", gRFQNo);
                    // lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
                    // lRec.SETRANGE("Entry No. RFQ Line", gEntryNoRFQLine);
                    // lRec.SETRANGE("Status RFQ Details", lRec."Status RFQ Details"::Closed);
                    // IF lRec.FINDFIRST THEN BEGIN
                    //     ERROR('This RFQ Line Details already has win vendor, cannot add more line');
                    // END;
                    lRecRFQVendor.RESET;
                    lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", gRFQNo);
                    lRecRFQVendor.SETFILTER(lRecRFQVendor."Vendor No.", '<>%1', '');
                    IF lRecRFQVendor.FIND('-') THEN CountVendor := lRecRFQVendor.COUNT;
                    lRec.RESET;
                    lRec.SETRANGE("RFQ No.", gRFQNo);
                    lRec.SETRANGE("No.", gNo);
                    lRec.SETRANGE(lRec."Entry No. RFQ Vendor", 0);
                    IF lRec.FINDFIRST THEN ERROR('There is an empty line not used, please use that line first');
                    // lRec.RESET;
                    // lRec.SETRANGE("RFQ No.", gRFQNo);
                    // lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
                    // lRec.SETRANGE("Entry No. RFQ Line", gEntryNoRFQLine);
                    // lRec.SETRANGE("Vendor No.", '');
                    // IF lRec.FIND('-') THEN BEGIN
                    //     lRec.DELETEALL;
                    // END;
                    lRec.RESET;
                    lRec.SETRANGE("RFQ No.", gRFQNo);
                    lRec.SETRANGE("No.", gNo);
                    IF lRec.COUNT < CountVendor THEN BEGIN
                        lRecIns.INIT;
                        lRecIns."Entry No." := 0;
                        lRecIns.VALIDATE(Type, gType);
                        lRecIns.VALIDATE("No.", gNo);
                        // lRecIns.VALIDATE(Quantity, gQty);
                        lRecIns.VALIDATE(Quantity, 1);
                        lRecIns."RFQ No." := gRFQNo;
                        lRecIns."RFQ Line No." := gRFQLineNo;
                        lRecIns."Purchase Req. No." := gPRNo;
                        lRecIns."Purchase Req. Line No." := gPRLineNo;
                        lRecIns."Material Req. No." := gMRNo;
                        lRecIns."Material Req. Line No." := gMRLineNo;
                        lRecIns."Entry No. RFQ Line" := gEntryNoRFQLine;
                        lRecIns."Status RFQ Details" := lRecIns."Status RFQ Details"::Open;
                        lRecIns.INSERT(TRUE);
                    END
                    ELSE BEGIN
                        IF CountVendor < 3 THEN
                            ERROR('Only max %1 lines can be added,Please input more vendor in RFQ Vendor List', CountVendor)
                        ELSE
                            ERROR('Only max %1 lines can be added', CountVendor);
                    END;
                    CurrPage.UPDATE;
                end;
            }
            // action("Confirm Win")
            // {
            //     ApplicationArea = All;
            //     Image = Confirm;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     trigger OnAction()
            //     var
            //         lRec: Record "RFQ Line Details";
            //         lRecRFQHeader: Record "RFQ Header";
            //         lRecRFQLine: Record "RFQ Line";
            //         lRecVendor: Record Vendor;
            //     begin
            //         lRecRFQHeader.RESET;
            //         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", gRFQNo);
            //         IF lRecRFQHeader.FINDFIRST THEN
            //             lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
            //         IF CONFIRM(StrSubstNo(TxtConfirmWin, lRec."Vendor Name")) THEN BEGIN
            //             lRec.RESET;
            //             lRec.SETRANGE("RFQ No.", gRFQNo);
            //             lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
            //             lRec.SETRANGE("Check Win", TRUE);
            //             IF lRec.FINDFIRST THEN BEGIN
            //                 lRecVendor.RESET;
            //                 lRecVendor.GET(lRec."Vendor No.");
            //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
            //                 lRec."Check Win" := TRUE;
            //                 lRec.MODIFY(TRUE);
            //                 Message('Check win is confirmed for vendor %1', lRec."Vendor Name");
            //                 lRec.RESET;
            //                 lRec.SETRANGE("RFQ No.", gRFQNo);
            //                 lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
            //                 IF lRec.FIND('-') THEN
            //                     lRec.ModifyAll(lRec."Status RFQ Details", lRec."Status RFQ Details"::Closed);
            //             END ELSE BEGIN
            //                 ERROR('No line has check win in this RFQ Line Details, please check win first');
            //             END;
            //         END;
            //         CurrPage.UPDATE;
            //     end;
            // }
            // action("Cancel Win")
            // {
            //     ApplicationArea = All;
            //     Image = Cancel;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     trigger OnAction()
            //     var
            //         lRec: Record "RFQ Line Details";
            //         lRecRFQHeader: Record "RFQ Header";
            //         lRecRFQLine: Record "RFQ Line";
            //         lRecVendor: Record Vendor;
            //         lCURFQFunction: Codeunit "RFQ Function";
            //     begin
            //         lRecRFQHeader.RESET;
            //         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", gRFQNo);
            //         IF lRecRFQHeader.FINDFIRST THEN
            //             lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
            //         Rec.Testfield(Rec."Status RFQ Details", Rec."Status RFQ Details"::Closed);
            //         lCURFQFunction.checkRFQLinehasPO(gRFQNo, gRFQLineNo);
            //         lRec.RESET;
            //         lRec.SETRANGE("RFQ No.", gRFQNo);
            //         lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
            //         lRec.SETRANGE("Check WIn", TRUE);
            //         IF lRec.FIND('-') THEN BEGIN
            //             lRec."Check Win" := FALSE;
            //             lRec.MODIFY;
            //             Message('Cancel win is confirmed for vendor %1', lRec."Vendor Name");
            //         END ELSE BEGIN
            //             ERROR('No line has status win in this RFQ Line Details')
            //         END;
            //         lRec.RESET;
            //         lRec.SETRANGE("RFQ No.", gRFQNo);
            //         lRec.SETRANGE("RFQ Line No.", gRFQLineNo);
            //         IF lRec.FIND('-') THEN BEGIN
            //             lRec.ModifyAll(lRec."Status RFQ Details", lRec."Status RFQ Details"::Open);
            //         END;
            //         CurrPage.UPDATE;
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.RESET;
        Rec.SETRANGE("RFQ No.", gRFQNo);
        Rec.SETRANGE("No.", gNo);
        IF Rec."Status RFQ Details" = Rec."Status RFQ Details"::Closed THEN BEGIN
            gBolEditable := FALSE;
            gBolEditableVendorNo := FALSE;
        END
        ELSE BEGIN
            IF Rec."Entry No. RFQ Vendor" <> 0 THEN
                gBolEditable := TRUE
            ELSE
                gBolEditable := FALSE;
            gBolEditableVendorNo := TRUE;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."Status RFQ Details" = Rec."Status RFQ Details"::Closed THEN BEGIN
            gBolEditable := FALSE;
            gBolEditableVendorNo := FALSE;
        END
        ELSE BEGIN
            IF Rec."Entry No. RFQ Vendor" <> 0 THEN
                gBolEditable := TRUE
            ELSE
                gBolEditable := FALSE;
            gBolEditableVendorNo := TRUE;
        END;
    end;

    procedure setDocNo(var parEntryNoRFQLine: integer; var ParRFQNo: Code[20]; var ParRFQLineNo: Integer; ParPRNo: Code[20]; ParPRLineNo: integer; ParMRNo: Code[20]; ParMRLineNo: integer; parType: Enum "RFQ Line Type"; parNo: Code[20]; var ParQty: Decimal)
    begin
        gEntryNoRFQLine := parEntryNoRFQLine;
        gRFQNo := ParRFQNo;
        gRFQLineNo := ParRFQLineNo;
        gPRNo := ParPRNo;
        gPRLineNo := ParPRLineNo;
        gMRNo := ParMRNo;
        gMRLineNo := ParMRLineNo;
        gQty := ParQty;
        gNo := parNo;
        gType := parType;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        checkCountLine();
        Rec."Entry No." := 0;
        Rec.Type := gType;
        Rec."No." := gNo;
        Rec.VALIDATE(Quantity, 1);
        Rec."RFQ No." := gRFQNo;
        Rec."RFQ Line No." := gRFQLineNo;
        Rec."Purchase Req. No." := gPRNo;
        Rec."Purchase Req. Line No." := gPRLineNo;
        Rec."Material Req. No." := gMRNo;
        Rec."Material Req. Line No." := gMRLineNo;
        Rec."Entry No. RFQ Line" := gEntryNoRFQLine;
    end;
    // trigger OnDeleteRecord(): Boolean
    // begin
    //     IF Rec."Status RFQ Details" = Rec."Status RFQ Details"::Closed THEN
    //         ERROR('Cannot delete RFQ Line Details for line %1, status evaluation already closed');
    //     CurrPage.UPDATE;
    // end;
    procedure checkCountLine()
    var
        lRec: Record "RFQ Line Details";
    begin
        lRec.RESET;
        lRec.SETRANGE("RFQ No.", gRFQNo);
        lRec.SETRANGE("No.", gNo);
        IF lRec.COUNT >= 3 THEN BEGIN
            ERROR('Only max %1 lines can be added', 3);
        END;
    end;

    var
        gRFQNo, gPRNo, gMRNo, gNo : Code[20];
        gType: Enum "RFQ Line Type";
        gEntryNoRFQLine, gRFQLineNo, gPRLineNo, gMRLineNo : integer;
        gQty: Decimal;
        gBolEditable, gBolEditableVendorNo : Boolean;
        TxtConfirmWin: Label 'Are you sure to confirm vendor %1 to win ?';
        TxtConfirmCancel: Label 'Are you sure to cancel vendor %1 from winning ?';
}
