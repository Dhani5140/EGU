// page 50166 "RFQ Vendor Subform"
// {
//     PageType = ListPart;
//     SourceTable = "RFQ Vendor List";
//     InsertAllowed = TRUE;
//     DelayedInsert = TRUE;
//     PopulateAllFields = TRUE;
//     RefreshOnActivate = TRUE;
//     Permissions = TableData "RFQ Vendor List" = rmid, tabledata RFQ_Vendor_ = rmid;


//     layout
//     {
//         area(content)
//         {
//             // group("Vendor Management")
//             // {
//             repeater(General)
//             {
//                 field("Entry No. RFQ Vendor"; Rec."Entry No. RFQ Vendor")
//                 {
//                     ApplicationArea = All;
//                     Editable = FALSE;
//                     Visible = FALSE;
//                 }
//                 field(Remarks; Rec.Remarks)
//                 {
//                     ApplicationArea = All;
//                     Editable = gBolEditable;
//                     Visible = FALSE;
//                 }
//                 field("Vendor No."; Rec."Vendor No.")
//                 {
//                     ApplicationArea = All;

//                     trigger OnValidate()
//                     begin
//                         IF Rec."Vendor No." <> '' THEN
//                             gBolEditable := TRUE
//                         ELSE
//                             gBolEditable := FALSE;
//                         CurrPage.Update;
//                     end;
//                 }
//                 field("Vendor Name"; Rec."Vendor Name")
//                 {
//                     ApplicationArea = All;
//                     Editable = FALSE;
//                 }
//                 field(email; Rec.email)
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Check Win"; Rec."Check Win")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Win';

//                     Editable = true;
//                     trigger OnValidate()
//                     begin
//                         CurrPage.UPDATE();
//                     end;
//                 }
//                 field("Payment Terms Code"; Rec."Payment Terms Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = gBolEditable;
//                 }
//                 field("Payment Terms Name"; Rec."Payment Terms Name")
//                 {
//                     ApplicationArea = All;
//                     Editable = FALSE;
//                 }
//                 field("Expected Receipt Date"; Rec."Expected Receipt Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = true;
//                 }
//                 // field("Ship-to Code"; Rec."Ship-to Code")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 field("Ship-to Name"; Rec."Ship-to Name")
//                 {
//                     ApplicationArea = All;
//                     Editable = gBolEditable;
//                 }
//                 field("Shipping Date"; Rec."Shipping Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = gBolEditable;
//                 }
//                 field("Shipment Method Code"; Rec."Shipment Method Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = gBolEditable;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = all;
//                     Editable = true;
//                 }
//                 field("Shipment Method Name"; Rec."Shipment Method Name")
//                 {
//                     ApplicationArea = All;
//                     Editable = FALSE;
//                 }
//                 field("Total Quote Amount"; Rec."Total Quote Amount")
//                 {
//                     ApplicationArea = All;
//                     Editable = FALSE;
//                     trigger OnDrillDown()
//                     var
//                         lRecRFQLineDet: Record "RFQ Line Details";
//                         lPageListRFQDet: Page "List RFQ Line Details";
//                     begin
//                         Rec.TestField("Entry No. RFQ Vendor");
//                         lRecRFQLineDet.RESET;
//                         lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", Rec."RFQ No.");
//                         lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Vendor", Rec."Entry No. RFQ Vendor");
//                         IF lRecRFQLineDet.FINDSET THEN BEGIN
//                             CLEAR(lPageListRFQDet);
//                             lPageListRFQDet.EDITABLE(FALSE);
//                             lPageListRFQDet.SetTableView(lRecRFQLineDet);
//                             lPageListRFQDet.SetRecord(lRecRFQLineDet);
//                             lPageListRFQDet.RUNMODAL();
//                         END;
//                         CurrPage.UPDATE;
//                     end;
//                 }
//             }
//         }
//     }
//     actions
//     {

//         area(Processing)
//         {
//             action(sendd)

//             {
//                 // ApplicationArea = Basic, Suite;
//                 // Caption = 'Send Email';
//                 // Visible = true;
//                 // Ellipsis = true;
//                 // Image = SendToMultiple;
//                 // ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

//                 // trigger OnAction()
//                 // // var
//                 // //     PurchaseHeader: Record "RFQ Vendor List";
//                 // // begin
//                 // //     if rec.Status = Rec.Status::"Send To Vendor" then begin
//                 // //         PurchaseHeader := Rec;
//                 // //         CurrPage.SetSelectionFilter(PurchaseHeader);
//                 // //         PurchaseHeader.SendRecords();
//                 // //     end else begin
//                 // //         Error('Error to print report because RFQ Status is not Send To Vendor');
//                 // //     end;
//                 // var
//                 //     PurchaseHeader: Record "RFQ Vendor List";
//                 //     rfq: Codeunit "RFQ Function";
//                 // begin
//                 //     CurrPage.SetSelectionFilter(PurchaseHeader);
//                 //     if PurchaseHeader.FindSet() then
//                 //         repeat
//                 //             Message('DEBUG: Vendor=%1, Status=%2, Email=%3, RFQ No=%4, EntryNo=%5',
//                 //                     PurchaseHeader."Vendor No.",
//                 //                     PurchaseHeader.Status,
//                 //                     PurchaseHeader.email,
//                 //                     PurchaseHeader."RFQ No.",
//                 //                     PurchaseHeader."Entry No. RFQ Vendor");  // <<< TAMBAH INI

//                 //             if PurchaseHeader.Status = PurchaseHeader.Status::"Send To Vendor" then begin
//                 //                 rfq.SendEMailWithAttachment(PurchaseHeader.email, PurchaseHeader."RFQ No.", PurchaseHeader."Entry No. RFQ Vendor");
//                 //             end else
//                 //                 Error('Status vendor %1 bukan Send To Vendor. Value: %2', PurchaseHeader."Vendor No.", PurchaseHeader.Status);
//                 //         until PurchaseHeader.Next() = 0;
//                 // end;

//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Send Email';
//                 Visible = true;
//                 Ellipsis = true;
//                 Image = SendToMultiple;

//                 trigger OnAction()
//                 var
//                     PurchaseHeader: Record "RFQ Vendor List";
//                     rfq: Codeunit "RFQ Function";
//                 begin
//                     CurrPage.SetSelectionFilter(PurchaseHeader);
//                     IF PurchaseHeader.FindSet() THEN
//                         REPEAT
//                             // WAJIB: Hitung FlowField dulu sebelum dibaca
//                             PurchaseHeader.CalcFields(Status);

//                             // Debug sementara - hapus setelah confirmed working
//                             Message('DEBUG: Vendor=%1, Status=%2, Email=%3',
//                                 PurchaseHeader."Vendor No.",
//                                 PurchaseHeader.Status,
//                                 PurchaseHeader.email);

//                             // Validasi email tidak kosong
//                             IF PurchaseHeader.email = '' THEN
//                                 ERROR('Vendor %1 belum memiliki email. Isi email vendor terlebih dahulu.',
//                                       PurchaseHeader."Vendor No.");

//                             // Validasi status
//                             IF PurchaseHeader.Status <> PurchaseHeader.Status::"Send To Vendor" THEN
//                                 ERROR('RFQ harus berstatus Send To Vendor. Status saat ini: %1',
//                                       PurchaseHeader.Status);

//                             // Kirim email
//                             rfq.SendEMailWithAttachment(
//                                 PurchaseHeader.email,
//                                 PurchaseHeader."RFQ No.",
//                                 PurchaseHeader."Entry No. RFQ Vendor"
//                             );
//                         UNTIL PurchaseHeader.Next() = 0;
//                 end;


//             }
//             // action("Print")
//             // {
//             //     ApplicationArea = All;
//             //     Image = Print;
//             //     Promoted = True;
//             //     PromotedCategory = Process;


//             //     trigger OnAction()
//             //     var
//             //         lRec: Record "RFQ Header";
//             //         QREC: Record "RFQ Vendor List";
//             //     begin

//             //         if
//             //         lRec.Status = lRec.Status::"Send To Vendor" then begin
//             //             lRec.SetRange(lRec."RFQ No.", Rec."RFQ No.");
//             //             Report.Run(Report::RFQ_Printour, true, false, lRec);
//             //         end else begin
//             //             Error('Error to print report because RFQ Status is not');
//             //         end;


//             //     end;
//             // }
//         }
//     }
//     trigger OnOpenPage()
//     begin
//         IF Rec."Status RFQ" = Rec."Status RFQ"::Closed THEN BEGIN
//             gBolEditable := FALSE;
//             editable2 := true;
//         END
//         ELSE BEGIN
//             IF Rec."Vendor No." <> '' THEN
//                 gBolEditable := TRUE

//             ELSE
//                 gBolEditable := FALSE;
//         END;
//     end;

//     trigger OnAfterGetRecord()
//     begin
//         IF Rec."Status RFQ" = Rec."Status RFQ"::Closed THEN BEGIN
//             gBolEditable := FALSE;
//             editable2 := true;
//         END
//         ELSE BEGIN
//             IF Rec."Vendor No." <> '' THEN
//                 gBolEditable := TRUE
//             ELSE
//                 gBolEditable := FALSE;
//         END;
//     end;

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         lRecRFQHeader: Record "RFQ Header";
//     begin
//         lRecRFQHeader.RESET;
//         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
//         IF lRecRFQHeader.FINDFIRST THEN
//             lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
//         Rec.checkCountLine();
//     end;

//     trigger OnModifyRecord(): Boolean
//     var
//         lRecRFQHeader: Record "RFQ Header";
//     begin
//         lRecRFQHeader.RESET;
//         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
//         IF lRecRFQHeader.FINDFIRST THEN
//             lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::"Send To Vendor");
//     end;


//     trigger OnDeleteRecord(): Boolean
//     var
//         lRecRFQHeader: Record "RFQ Header";
//     begin
//         lRecRFQHeader.RESET;
//         lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
//         IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
//     end;

//     var
//         gBolEditable: Boolean;
//         editable2: Boolean;
// }

page 50166 "RFQ Vendor Subform"
{
    PageType = ListPart;
    SourceTable = "RFQ Vendor List";
    InsertAllowed = TRUE;
    PopulateAllFields = TRUE;
    RefreshOnActivate = TRUE;
    Permissions = TableData "RFQ Vendor List" = rmid, tabledata RFQ_Vendor_ = rmid;


    layout
    {
        area(content)
        {
            // group("Vendor Management")
            // {
            repeater(General)
            {
                field("Entry No. RFQ Vendor"; Rec."Entry No. RFQ Vendor")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    Visible = FALSE;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    Visible = FALSE;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF Rec."Vendor No." <> '' THEN
                            gBolEditable := TRUE
                        ELSE
                            gBolEditable := FALSE;
                        CurrPage.Update;
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(email; Rec.email)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Check Win"; Rec."Check Win")
                {
                    ApplicationArea = All;
                    Caption = 'Win';

                    Editable = true;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Payment Terms Name"; Rec."Payment Terms Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                // field("Ship-to Code"; Rec."Ship-to Code")
                // {
                //     ApplicationArea = All;
                // }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Shipping Date"; Rec."Shipping Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Shipment Method Name"; Rec."Shipment Method Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Total Quote Amount"; Rec."Total Quote Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    trigger OnDrillDown()
                    var
                        lRecRFQLineDet: Record "RFQ Line Details";
                        lPageListRFQDet: Page "List RFQ Line Details";
                    begin
                        Rec.TestField("Entry No. RFQ Vendor");
                        lRecRFQLineDet.RESET;
                        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", Rec."RFQ No.");
                        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Vendor", Rec."Entry No. RFQ Vendor");
                        IF lRecRFQLineDet.FINDSET THEN BEGIN
                            CLEAR(lPageListRFQDet);
                            lPageListRFQDet.EDITABLE(FALSE);
                            lPageListRFQDet.SetTableView(lRecRFQLineDet);
                            lPageListRFQDet.SetRecord(lRecRFQLineDet);
                            lPageListRFQDet.RUNMODAL();
                        END;
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }
    actions
    {

        area(Processing)
        {
            action(sendd)

            {
                // ApplicationArea = Basic, Suite;
                // Caption = 'Send Email';
                // Visible = true;
                // Ellipsis = true;
                // Image = SendToMultiple;
                // ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                // trigger OnAction()
                // // var
                // //     PurchaseHeader: Record "RFQ Vendor List";
                // // begin
                // //     if rec.Status = Rec.Status::"Send To Vendor" then begin
                // //         PurchaseHeader := Rec;
                // //         CurrPage.SetSelectionFilter(PurchaseHeader);
                // //         PurchaseHeader.SendRecords();
                // //     end else begin
                // //         Error('Error to print report because RFQ Status is not Send To Vendor');
                // //     end;
                // var
                //     PurchaseHeader: Record "RFQ Vendor List";
                //     rfq: Codeunit "RFQ Function";
                // begin
                //     CurrPage.SetSelectionFilter(PurchaseHeader);
                //     if PurchaseHeader.FindSet() then
                //         repeat
                //             Message('DEBUG: Vendor=%1, Status=%2, Email=%3, RFQ No=%4, EntryNo=%5',
                //                     PurchaseHeader."Vendor No.",
                //                     PurchaseHeader.Status,
                //                     PurchaseHeader.email,
                //                     PurchaseHeader."RFQ No.",
                //                     PurchaseHeader."Entry No. RFQ Vendor");  // <<< TAMBAH INI

                //             if PurchaseHeader.Status = PurchaseHeader.Status::"Send To Vendor" then begin
                //                 rfq.SendEMailWithAttachment(PurchaseHeader.email, PurchaseHeader."RFQ No.", PurchaseHeader."Entry No. RFQ Vendor");
                //             end else
                //                 Error('Status vendor %1 bukan Send To Vendor. Value: %2', PurchaseHeader."Vendor No.", PurchaseHeader.Status);
                //         until PurchaseHeader.Next() = 0;
                // end;

                ApplicationArea = Basic, Suite;
                Caption = 'Send Email';
                Visible = true;
                Ellipsis = true;
                Image = SendToMultiple;

                trigger OnAction()
                var
                    PurchaseHeader: Record "RFQ Vendor List";
                    rfq: Codeunit "RFQ Function";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    IF PurchaseHeader.FindSet() THEN
                        REPEAT
                            // WAJIB: Hitung FlowField dulu sebelum dibaca
                            PurchaseHeader.CalcFields(Status);

                            // Debug sementara - hapus setelah confirmed working
                            Message('DEBUG: Vendor=%1, Status=%2, Email=%3',
                                PurchaseHeader."Vendor No.",
                                PurchaseHeader.Status,
                                PurchaseHeader.email);

                            // Validasi email tidak kosong
                            IF PurchaseHeader.email = '' THEN
                                ERROR('Vendor %1 belum memiliki email. Isi email vendor terlebih dahulu.',
                                      PurchaseHeader."Vendor No.");

                            // Validasi status
                            IF PurchaseHeader.Status <> PurchaseHeader.Status::"Send To Vendor" THEN
                                ERROR('RFQ harus berstatus Send To Vendor. Status saat ini: %1',
                                      PurchaseHeader.Status);

                            // Kirim email
                            rfq.SendEMailWithAttachment(
                                PurchaseHeader.email,
                                PurchaseHeader."RFQ No.",
                                PurchaseHeader."Entry No. RFQ Vendor"
                            );
                        UNTIL PurchaseHeader.Next() = 0;
                end;


            }
            // action("Print")
            // {
            //     ApplicationArea = All;
            //     Image = Print;
            //     Promoted = True;
            //     PromotedCategory = Process;


            //     trigger OnAction()
            //     var
            //         lRec: Record "RFQ Header";
            //         QREC: Record "RFQ Vendor List";
            //     begin

            //         if
            //         lRec.Status = lRec.Status::"Send To Vendor" then begin
            //             lRec.SetRange(lRec."RFQ No.", Rec."RFQ No.");
            //             Report.Run(Report::RFQ_Printour, true, false, lRec);
            //         end else begin
            //             Error('Error to print report because RFQ Status is not');
            //         end;


            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    begin
        IF Rec."Status RFQ" = Rec."Status RFQ"::Closed THEN BEGIN
            gBolEditable := FALSE;
            editable2 := true;
        END
        ELSE BEGIN
            IF Rec."Vendor No." <> '' THEN
                gBolEditable := TRUE

            ELSE
                gBolEditable := FALSE;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."Status RFQ" = Rec."Status RFQ"::Closed THEN BEGIN
            gBolEditable := FALSE;
            editable2 := true;
        END
        ELSE BEGIN
            IF Rec."Vendor No." <> '' THEN
                gBolEditable := TRUE
            ELSE
                gBolEditable := FALSE;
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        lRecRFQHeader: Record "RFQ Header";
    begin
        lRecRFQHeader.RESET;
        lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
        IF lRecRFQHeader.FINDFIRST THEN
            lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
        Rec.checkCountLine();
    end;

    trigger OnModifyRecord(): Boolean
    var
        lRecRFQHeader: Record "RFQ Header";
    begin
        lRecRFQHeader.RESET;
        lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
        IF lRecRFQHeader.FINDFIRST THEN
            // Sebelumnya hanya "Send To Vendor". Diperlebar supaya user bisa
            // langsung Release -> isi harga -> Create PO tanpa wajib Send To Vendor.
            IF NOT (lRecRFQHeader.Status IN [lRecRFQHeader.Status::Open,
                                             lRecRFQHeader.Status::Released,
                                             lRecRFQHeader.Status::"Send To Vendor"]) THEN
                ERROR('Status must be Open, Released, or Send To Vendor to edit vendor line. Current status: %1', lRecRFQHeader.Status);
    end;


    trigger OnDeleteRecord(): Boolean
    var
        lRecRFQHeader: Record "RFQ Header";
    begin
        lRecRFQHeader.RESET;
        lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", Rec."RFQ No.");
        IF lRecRFQHeader.FINDFIRST THEN lRecRFQHeader.TestField(lRecRFQHeader.Status, lRecRFQHeader.Status::Open);
    end;

    var
        gBolEditable: Boolean;
        editable2: Boolean;
}

