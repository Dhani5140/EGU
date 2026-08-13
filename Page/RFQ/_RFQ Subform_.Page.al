page 50119 "RFQ Subform"
{
    PageType = ListPart;
    SourceTable = "RFQ Line";
    AutoSplitKey = TRUE;
    RefreshOnActivate = TRUE;
    InsertAllowed = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                    Caption = 'Remark PR';
                }
                field("Original Qty PR"; Rec."Original Qty PR")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Qty from PR';

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    caption = 'Quantity RFQ';
                    Editable = true;
                    DecimalPlaces = 0 : 5;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Qty RFQ';
                    Editable = FALSE;
                    DecimalPlaces = 0 : 5;
                }
                // field("Count RFQ Line Details"; Rec."Count RFQ Line Details")
                // {
                //     ApplicationArea = All;
                //     Editable = FALSE;
                //     trigger OnDrillDown()
                //     var
                //         lPageRFQDet: Page "RFQ Line Details";
                //     begin
                //         Rec.TestField("Entry No. RFQ Line");
                //         CLEAR(lPageRFQDet);
                //         lPageRFQDet.setDocNo(Rec."Entry No. RFQ Line", Rec."RFQ No.", Rec."Line No.",
                //                 Rec."Purchase Req. No.", Rec."Purchase Req. Line No.", Rec."Material Req. No.",
                //                 Rec."Material Req. Line No.", Rec.Type, Rec."No.", Rec.Quantity);
                //         lPageRFQDet.RUNMODAL();
                //         CurrPage.UPDATE;
                //     end;
                // }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                // field(PBBKB; Rec.PBBKB)
                // {
                //     ApplicationArea = All;
                //     Editable = gBolEditable;

                //     trigger OnValidate()
                //     begin
                //         CurrPage.UPDATE;
                //     end;
                // }
                field("Qty to PO"; Rec."Qty to PO")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("Winner RFQ Line Details"; Rec."Winner RFQ Line Details")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
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
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Discount Amount"; Rec."Discount Amount")
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
                field("Total Qty On PO"; Rec."Total Qty On PO")
                {
                    ApplicationArea = All;
                    EDITABLE = FALSE;
                    DecimalPlaces = 0 : 5;
                }
                field("Total Amount on PO"; Rec."Total Amount on PO")
                {
                    ApplicationArea = All;
                    EDITABLE = FALSE;
                }
                field("Total Qty On Posted Order"; Rec."Total Qty On Posted Order")
                {
                    ApplicationArea = All;
                    EDITABLE = FALSE;
                    DecimalPlaces = 0 : 5;
                }
                field("Total Amount on Posted Order"; Rec."Total Amount on Posted Order")
                {
                    ApplicationArea = All;
                    EDITABLE = FALSE;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add New Line Additional")
            {
                ApplicationArea = All;
                Image = AddAction;

                trigger OnAction()
                var
                    lRec: Record "RFQ Line";
                    lRecIns: Record "RFQ Line";
                    lRecEmpty: Record "RFQ Line";
                    lRecRFQHeader: Record "RFQ Header";
                    LineNo: integer;
                begin
                    CLEAR(LineNo);
                    lRecRFQHeader.RESET;
                    lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
                    IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
                    lRec.RESET;
                    lRec.SETRANGE(lRec."RFQ No.", Rec."RFQ No.");
                    lRec.SETRANGE(lRec."Parent Line No.", 0);
                    IF lRec.FINDLAST THEN
                        LineNo := lRec."Line No." + 10000
                    ELSE
                        LineNo := 10000;
                    lRecEmpty.RESET;
                    lRecEmpty.SETRANGE(lRecEmpty."RFQ No.", Rec."RFQ No.");
                    lRecEmpty.SETRANGE(lRecEmpty."Purchase Req. No.", '');
                    lRecEmpty.SETRANGE(lRecEmpty."No.", '');
                    IF lRecEmpty.FINDFIRST THEN ERROR('No. in Line No %1 is still empty, please use that line first', lRecEmpty."Line No.");
                    lRecIns.INIT;
                    lRecIns."RFQ No." := Rec."RFQ No.";
                    lRecIns."Line No." := LineNo;
                    lRecIns.INSERT(TRUE);
                    CurrPage.UPDATE;
                end;
            }
            // action("Split Line")
            // {
            //     ApplicationArea = all;
            //     Image = Splitlines;

            //     trigger OnAction()
            //     var
            //         lRecRFQHeader: Record "RFQ Header";
            //         lRecRFQLineIns: Record "RFQ Line";
            //         lCURFQFunct: Codeunit "RFQ Function";
            //     begin
            //         Rec.TestField("Entry No. RFQ Line");
            //         Rec.TestField("Purchase Req. No.");
            //         lRecRFQHeader.RESET;
            //         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
            //         IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
            //         lCURFQFunct.splitRFQLine(Rec);
            //         CurrPage.UPDATE();
            //     end;
            // }
            // action("Show RFQ Line Details")
            // {
            //     ApplicationArea = all;
            //     Image = Document;
            //     trigger OnAction()
            //     var
            //         lPageRFQDet: Page "RFQ Line Details";
            //     begin
            //         Rec.TestField("Entry No. RFQ Line");
            //         CLEAR(lPageRFQDet);
            //         lPageRFQDet.setDocNo(Rec."Entry No. RFQ Line", Rec."RFQ No.", Rec."Line No.",
            //                 Rec."Purchase Req. No.", Rec."Purchase Req. Line No.", Rec."Material Req. No.",
            //                 Rec."Material Req. Line No.", Rec.Type, Rec."No.", Rec.Quantity);
            //         lPageRFQDet.RUNMODAL();
            //         CurrPage.UPDATE;
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.CalcFields(Status);
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
            IF (Rec."Purchase Req. No." <> '') AND (Rec."Purchase Req. Line No." <> 0) THEN BEGIN
                IF Rec."Parent Line No." = 0 THEN
                    gBolEditableOriQtyPR := TRUE
                ELSE
                    gBolEditableOriQtyPR := FALSE;
            END
            ELSE BEGIN
                gBolEditableOriQtyPR := FALSE;
            END;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
            gBolEditableOriQtyPR := FALSE;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Status);
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
            if rec.Status = Rec.Status::"Send To Vendor" then begin
                gSendToVendorEditable := true;
            end;
            IF (Rec."Purchase Req. No." <> '') AND (Rec."Purchase Req. Line No." <> 0) THEN BEGIN
                IF Rec."Parent Line No." = 0 THEN
                    gBolEditableOriQtyPR := TRUE
                ELSE
                    gBolEditableOriQtyPR := FALSE;
            END
            ELSE BEGIN
                gBolEditableOriQtyPR := FALSE;
            END;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
            gBolEditableOriQtyPR := FALSE;
        END;
    end;

    var
        gBolEditable, gBolEditableOriQtyPR, gSendToVendorEditable : Boolean;
}
