codeunit 50110 "MII Subscriber"
{
    Permissions = TableData "Sales Invoice Header" = rm;

    trigger OnRun()
    begin
    end;
    //Table
    // [EventSubscriber(ObjectType::table, database::"RFQ Line", 'OnAfterInsertEvent', '', false, false)]
    // local procedure onAfterInsertRFQLine(var Rec: Record "RFQ Line")
    // var
    //     lCURFQFunct: Codeunit "RFQ Function";
    // begin
    //     lCURFQFunct.insertRFQLineDetailsfromRFQLine(Rec);
    // end;
    [EventSubscriber(ObjectType::table, database::"RFQ Vendor List", 'OnAfterInsertEvent', '', false, false)]
    local procedure onAfterInsertRFQVendor(var Rec: Record "RFQ Vendor List")
    var
        lCURFQFunct: Codeunit "RFQ Function";
    begin
        lCURFQFunct.insertRFQLineDetailsfromRFQVendor(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"RFQ Line", OnBeforeDeleteEvent, '', false, false)]
    local procedure onbeforeDeleteRFQLineDet(var Rec: Record "RFQ Line")
    var
        lCURFQFunct: Codeunit "RFQ Function";
    begin
        Rec.VALIDATE("Winner RFQ Line Details", 0);
        Rec.MODIFY;
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        ItemJnlLine."No. Surat Jalan" := PurchHeader."No. Surat Jalan";
        ItemJnlLine."Tanggal Surat Jalan" := PurchHeader."Tanggal Surat Jalan";
        ItemJnlLine."No. Polisi" := PurchHeader."No. Polisi";
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."Material Req. No." := PurchLine."Material Req. No.";
        ItemJnlLine."Material Req. Line No." := PurchLine."Material Req. Line No.";
        ItemJnlLine."Original Qty PR" := PurchLine."Original Qty PR";
    end;

    // [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]
    // local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    // begin
    //     ItemJnlLine."No. Shipping" := SalesHeader."No. Shipping";
    //     ItemJnlLine."No. Berita Acara" := SalesHeader."No. Berita Acara";
    // end;

    // [EventSubscriber(ObjectType::Table, DATABASE::"Item Journal Line", 'OnAfterValidateShortcutDimCode', '', false, false)]
    // local procedure OnAfterValidateShortcutDimCode(var ItemJournalLine: Record "Item Journal Line"; xItemJournalLine: Record "Item Journal Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    // begin
    //     case FieldNumber OF
    //         3:
    //             ItemJournalLine.VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, ShortcutDimCode));
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    // local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    // begin
    //     GenJournalLine."No. Shipping" := SalesHeader."No. Shipping";
    //     GenJournalLine."No. Berita Acara" := SalesHeader."No. Berita Acara";
    // end;

    // [EventSubscriber(ObjectType::Table, DATABASE::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    // local procedure OnAfterCopyFromTransferHeaderTS(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    // begin
    //     TransferShipmentHeader."Purchase Req. No." := TransferHeader."Purchase Req. No.";
    // end;

    // [EventSubscriber(ObjectType::Table, DATABASE::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    // local procedure OnAfterCopyFromTransferHeaderTR(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    // begin
    //     TransferReceiptHeader."Purchase Req. No." := TransferHeader."Purchase Req. No.";
    // end;
    //Table
    //report
    //PO -> Warehouse Receipt Header


    // [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnPurchaseLineOnAfterGetRecordOnAfterCreateRcptHeader', '', false, false)]
    // local procedure OnPurchaseLineOnAfterGetRecordOnAfterCreateRcptHeader(var PurchaseLine: Record "Purchase Line"; var WarehouseRequest: Record "Warehouse Request"; var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WhseHeaderCreated: Boolean; var OneHeaderCreated: Boolean; var ErrorOccured: Boolean; var LineCreated: Boolean)
    // var
    //     lRecPurchHeader: Record "Purchase Header";
    // begin
    //     lRecPurchHeader.RESET;
    //     lRecPurchHeader.SETRANGE(lRecPurchHeader."Document Type", PurchaseLine."Document Type");
    //     lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", PurchaseLine."Document No.");
    //     IF lRecPurchHeader.FINDFIRST THEN BEGIN
    //         WarehouseReceiptHeader."No. Polisi" := lRecPurchHeader."No. Polisi";
    //         WarehouseReceiptHeader."No. Surat Jalan" := lRecPurchHeader."No. Surat Jalan";
    //         WarehouseReceiptHeader."Tanggal Surat Jalan" := lRecPurchHeader."Tanggal Surat Jalan";
    //         WarehouseReceiptHeader."Shipping Date" := lRecPurchHeader."Shipping Date";
    //         WarehouseReceiptHeader.MODIFY;
    //     END
    // end;
    //PO Line -> Warehouse Receipt Line
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Purchases Warehouse Mgt.", 'OnAfterCreateRcptLineFromPurchLine', '', false, false)]
    // local procedure OnAfterCreateRcptLineFromPurchLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line")
    // var
    //     lRecPurchHeader: Record "Purchase Header";
    // begin
    //     lRecPurchHeader.RESET;
    //     lRecPurchHeader.SETRANGE(lRecPurchHeader."Document Type", PurchaseLine."Document Type");
    //     lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", PurchaseLine."Document No.");
    //     IF lRecPurchHeader.FINDFIRST THEN BEGIN
    //         WarehouseReceiptHeader."No. Polisi" := lRecPurchHeader."No. Polisi";
    //         WarehouseReceiptHeader."No. Surat Jalan" := lRecPurchHeader."No. Surat Jalan";
    //         WarehouseReceiptHeader."Tanggal Surat Jalan" := lRecPurchHeader."Tanggal Surat Jalan";
    //         WarehouseReceiptHeader."Shipping Date" := lRecPurchHeader."Shipping Date";
    //         WarehouseReceiptHeader.MODIFY;
    //     END
    // end;
    //Codeunit 
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    // local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    // begin
    //     TransShptHeader."Original No. from System" := TransShptHeader."No.";
    //     TransShptHeader."No." := TransHeader."No.";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    // local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    // begin
    //     TransferReceiptHeader."Original No. from System" := TransferReceiptHeader."No.";
    //     TransferReceiptHeader."No." := TransferHeader."No.";
    // end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Invt. Doc.-Post Shipment", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var InvtDocumentHeader: Record "Invt. Document Header"; var SuppressCommit: Boolean; var HideProgressWindow: Boolean)
    begin
        IF InvtDocumentHeader."Material Req. No." <> '' THEN BEGIN
            InvtDocumentHeader.TestField("Gen. Bus. Posting Group");
        END;
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptHeaderInsert', '', false, false)]
    // local procedure OnRunOnBeforeInvtShptHeaderInsert(var InvtShptHeader: Record "Invt. Shipment Header"; InvtDocHeader: Record "Invt. Document Header")
    // begin
    //     InvtShptHeader."Material Req. No." := InvtDocHeader."Material Req. No.";
    //     InvtShptHeader."MR Usage Category" := InvtDocHeader."MR Usage Category";
    //     InvtShptHeader."Shortcut Dimension 1 Code" := InvtDocHeader."Shortcut Dimension 1 Code";
    //     InvtShptHeader."Shortcut Dimension 3 Code" := InvtDocHeader."Shortcut Dimension 3 Code";
    //     InvtShptHeader."Shortcut Dimension 5 Code" := InvtDocHeader."Shortcut Dimension 5 Code";
    //     InvtShptHeader."Unit Group" := InvtDocHeader."Unit Group";
    //     InvtShptHeader.Remarks := InvtDocHeader.Remarks;
    // end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptLineInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtShptLineInsert(var InvtShptLine: Record "Invt. Shipment Line"; InvtDocLine: Record "Invt. Document Line"; var InvtShipmentHeader: Record "Invt. Shipment Header"; InvtDocumentHeader: Record "Invt. Document Header")
    begin
        InvtShptLine."Material Req. No." := InvtDocLine."Material Req. No.";
        InvtShptLine."Material Req. Line No." := InvtDocLine."Material Req. Line No.";
        InvtShptLine."Original Qty MR" := InvtDocLine."Original Qty MR";
        InvtShptLine."Gen. Bus. Posting Group" := InvtDocLine."Gen. Bus. Posting Group";
        InvtShptLine."MR Purch. Receipt" := InvtDocLine."MR Purch. Receipt";
    end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Invt. Doc.-Post Shipment", 'OnPostItemJnlLineOnBeforeTransferInvtDocToItemJnlLine', '', false, false)]
    // local procedure OnPostItemJnlLineOnBeforeTransferInvtDocToItemJnlLine(var InvtDocumentLine: Record "Invt. Document Line"; var ItemJournalLine: Record "Item Journal Line"; InvtShipmentHeader: Record "Invt. Shipment Header"; InvtShipmentLine: Record "Invt. Shipment Line")
    // begin
    //     ItemJournalLine."Material Req. No." := InvtDocumentLine."Material Req. No.";
    //     ItemJournalLine."Material Req. Line No." := InvtDocumentLine."Material Req. Line No.";
    //     ItemJournalLine."Original Qty MR" := InvtDocumentLine."Original Qty MR";
    //     ItemJournalLine.VALIDATE("Unit Group", InvtShipmentHeader."Unit Group");
    //     ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", InvtShipmentHeader."Shortcut Dimension 1 Code");
    //     ItemJournalLine.VALIDATE("MR Usage Category", InvtShipmentHeader."MR Usage Category");
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforePostItemJournalLine', '', false, false)]
    // local procedure UpdateBCDataTOSinItemJournal(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header")
    // begin
    //     ItemJournalLine."Purchase Req. No." := TransferShipmentHeader."Purchase Req. No.";
    //     ItemJournalLine."Reference No." := TransferLine."Reference No.";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Item Jnl.-Post Line", 'OnBeforeRunWithCheck', '', false, false)]
    // local procedure OnBeforeRunWithCheck(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; CalledFromApplicationWorksheet: Boolean; PostponeReservationHandling: Boolean; var IsHandled: Boolean)
    // begin
    //     IF ItemJournalLine."Material Req. No." <> '' THEN BEGIN
    //         ItemJournalLine.TestField("Gen. Bus. Posting Group");
    //     END;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(VAR ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line");
    begin
        ItemLedgerEntry."Source Template Name" := ItemJournalLine."Journal Template Name";
        ItemLedgerEntry."Source Batch Name" := ItemJournalLine."Journal Batch Name";
        ItemLedgerEntry."Material Req. No." := ItemJournalLine."Material Req. No.";
        ItemLedgerEntry."Material Req. Line No." := ItemJournalLine."Material Req. Line No.";
        ItemLedgerEntry."Purchase Req. No." := ItemJournalLine."Purchase Req. No.";
        ItemLedgerEntry."PR Material Line No." := ItemJournalLine."Purchase Req. Line No.";
        ItemLedgerEntry."Original Qty MR" := ItemJournalLine."Original Qty MR";
        ItemLedgerEntry."Original Qty PR" := ItemJournalLine."Original Qty PR";
        ItemLedgerEntry."No. Shipping" := ItemJournalLine."No. Shipping";
        ItemLedgerEntry."No. Berita Acara" := ItemJournalLine."No. Berita Acara";
        ItemLedgerEntry."No. Polisi" := ItemJournalLine."No. Polisi";
        ItemLedgerEntry."No. Surat Jalan" := ItemJournalLine."No. Surat Jalan";
        ItemLedgerEntry."Tanggal Surat Jalan" := ItemJournalLine."Tanggal Surat Jalan";
        ItemLedgerEntry."MR Usage Category" := ItemJournalLine."MR Usage Category";
        ItemLedgerEntry."Reference No." := ItemJournalLine."Reference No.";
        ItemLedgerEntry."Item Journal MR" := ItemJournalLine."Item Journal MR";
        ItemLedgerEntry."Unit Group" := ItemJournalLine."Unit Group";
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    // local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    // begin
    //     GLEntry."No. Shipping" := GenJournalLine."No. Shipping";
    //     GLEntry."No. Berita Acara" := GenJournalLine."No. Berita Acara";
    //     GLEntry."Material Req. No." := GenJournalLine."Material Req. No.";
    //     GLEntry."Material Req. Line No." := GenJournalLine."Material Req. Line No.";
    //     GLEntry."Purchase Req. No." := GenJournalLine."Purchase Req. No.";
    //     GLEntry."Purchase Req. Line No." := GenJournalLine."Purchase Req. Line No.";
    //     GLEntry."Line Counter Auto Journal" := GenJournalLine."Line Counter Auto Journal";
    //     GLEntry."PR Type" := GenJournalLine."PR Type";
    //     GLEntry."MR Usage Category" := GenJournalLine."MR Usage Category";
    //     GLEntry."Unit Group" := GenJournalLine."Unit Group";
    //     GLEntry."Tax No." := GenJournalLine."Tax No.";
    //     GLEntry.BudgetCode := GenJournalLine.BudgetCode;
    //     GLEntry.BudgetName := GenJournalLine.BudgetName;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', false, false)]
    // local procedure OnBeforeInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    // begin
    //     TransShptLine."Reference No." := TransLine."Reference No.";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    // local procedure OnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    // begin
    //     TransRcptLine."Reference No." := TransLine."Reference No.";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    // local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    // var
    //     lRecPurchLine: Record "Purchase Line";
    //     lRecMSISetup: Record "MII Setup";
    //     TotalLineAmount: Decimal;
    //     LineNo: Integer;
    // begin
    //     lRecMSISetup.GET();
    //     lRecMSISetup.TESTFIELD("No. G/L FA");
    //     lRecMSISetup.TestField("FA Journal Template");
    //     lRecMSISetup.TestField("FA Journal Batch");
    //     CLEAR(TotalLineAmount);
    //     PurchaseLine.CalcFields("Fixed Asset PR Qty", "Fixed Asset PR Amount");
    //     IF PurchaseLine."Fixed Asset PR Qty" <> 0 THEN BEGIN
    //         clearGenJournalLine(lRecMSISetup."FA Journal Template", lRecMSISetup."FA Journal Batch", PurchRcptHeader."No.");
    //         createJournalFA(PurchaseLine, PurchRcptHeader);
    //         lRecPurchLine.RESET;
    //         lRecPurchLine.SETRANGE(lRecPurchLine."Document No.", PurchaseLine."Document No.");
    //         lRecPurchLine.SETRANGE(lRecPurchLine."PR Type", lRecPurchLine."PR Type"::Asset);
    //         lRecPurchLine.SETFILTER(lRecPurchLine."Purchase Req. No.", '<>%1', '');
    //         lRecPurchLine.SETRANGE(lRecPurchLine."PR Line Type", lRecPurchLine."PR Line Type"::"Fixed Asset");
    //         lRecPurchLine.SETRANGE(lRecPurchLine.Type, lRecPurchLine.Type::"G/L Account");
    //         lRecPurchLine.SETRANGE(lRecPurchLine."No.", lRecMSISetup."No. G/L FA");
    //         IF lRecPurchLine.FIND('-') THEN BEGIN
    //             REPEAT
    //                 lRecPurchLine.CalcSums("Line Amount");
    //                 TotalLineAmount := lRecPurchLine."Line Amount";
    //             UNTIL lRecPurchLine.NEXT = 0;
    //         END;
    //         IF TotalLineAmount <> 0 THEN createJournalFACounter(PurchRcptHeader, TotalLineAmount);
    //     END;
    // end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        lRecGJL: Record "Gen. Journal Line";
        lRecMSISetup: Record "MII Setup";
    begin
        lRecMSISetup.GET();
        lRecMSISetup.TESTFIELD("No. G/L FA");
        lRecMSISetup.TestField("FA Journal Template");
        lRecMSISetup.TestField("FA Journal Batch");
        //wait autoposting
        lRecGJL.RESET;
        lRecGJL.SETRANGE(lRecGJL."Journal Template Name", lRecMSISetup."FA Journal Template");
        lRecGJL.SETRANGE(lRecGJL."Journal Batch Name", lRecMSISetup."FA Journal Batch");
        lRecGJL.SETRANGE(lRecGJL."Document No.", PurchRcpHdrNo);
        IF lRecGJL.FIND('-') THEN lRecGJL.SendToPosting(Codeunit::"Gen. Jnl.-Post");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", OnAfterPostJournalBatch, '', false, false)]
    local procedure OnAfterPostJournalBatch(var ItemJournalLine: Record "Item Journal Line");
    var
        lRec: Record "Item Ledger Entry";
        lRecILE: Record "Item Ledger Entry";
        lRecItemReg: Record "Item Register";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        lRecILE.RESET;
        lRecILE.SetCurrentKey("Entry No.");
        lRecILE.SETRANGE("Source Template Name", ItemJournalLine."Journal Template Name");
        lRecILE.SETRANGE("Source Batch Name", ItemJournalLine."Journal Batch Name");
        lRecILE.ASCENDING(FALSE);
        IF lRecILE.FINDFIRST THEN BEGIN
            lRec.RESET;
            lRec.SETRANGE("Entry No.", lRecILE."Entry No.");

        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", OnBeforePrintItemRegister, '', false, false)]
    local procedure OnBeforePrintItemRegister(ItemRegister: Record "Item Register"; ItemJournalTemplate: Record "Item Journal Template"; var IsHandled: Boolean)
    var
        lRec: Record "Item Ledger Entry";
        lRecILE: Record "Item Ledger Entry";
        lRecItemReg: Record "Item Register";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        IsHandled := TRUE;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    begin
        ItemJournalLine.TestField("Gen. Bus. Posting Group");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Purchase Receipt Line", OnBeforeOnRun, '', false, false)]
    local procedure OnBeforeOnRunUndoPurchReceipt(var PurchRcptLine: Record "Purch. Rcpt. Line"; var IsHandled: Boolean; var SkipTypeCheck: Boolean; var HideDialog: Boolean)
    begin
        IF (PurchRcptLine."Purchase Req. No." <> '') AND (PurchRcptLine."PR Type" = PurchRcptLine."PR Type"::Asset) THEN ERROR('This line is from purchase request asset, cannot undo');
        // IF PurchRcptLine."Material Req. No." <> '' THEN 
        //     ERROR('This line is from material request, cannot undo');
    end;
    //Codeunit
    //page
    // [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnBeforeActionEvent, 'Release', false, false)]
    // local procedure OnBeforeReleasePO(var Rec: Record "Purchase Header")
    // begin
    //     checkFAPRAssetbeforerelease(Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnBeforeActionEvent, 'SendApprovalRequest', false, false)]
    // local procedure OnBeforeSendApprovalPO(var Rec: Record "Purchase Header")
    // begin
    //     checkFAPRAssetbeforerelease(Rec);
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Item Journal", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPostIJL(var Rec: Record "Item Journal Line")
    var
        lRec: Record "Item Journal Line";
        lRecIJLBatch: Record "Item Journal Batch";
        ItemJournalDocNo: Code[20];
    begin
        CLEAR(ItemJournalDocNo);
        lRec.RESET;
        lRec.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        lRec.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        lRec.SetCurrentKey("Document No.");
        lRec.ASCENDING(TRUE);
        IF lRec.FINDLAST THEN ItemJournalDocNo := lRec."Document No.";
        IF ItemJournalDocNo <> '' THEN BEGIN
            lRec.RESET;
            lRec.SETRANGE("Journal Template Name", Rec."Journal Template Name");
            lRec.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
            IF lRec.FINDFIRST THEN lRec.MODIFYALL("Document No.", ItemJournalDocNo);
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Journal", OnBeforeActionEvent, 'Post and &Print', false, false)]
    local procedure OnBeforeActionEventPostPrintIJL(var Rec: Record "Item Journal Line")
    var
        lRec: Record "Item Journal Line";
        lRecIJLBatch: Record "Item Journal Batch";
        ItemJournalDocNo: Code[20];
    begin
        CLEAR(ItemJournalDocNo);
        lRec.RESET;
        lRec.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        lRec.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        lRec.SetCurrentKey("Document No.");
        lRec.ASCENDING(TRUE);
        IF lRec.FINDLAST THEN ItemJournalDocNo := lRec."Document No.";
        IF ItemJournalDocNo <> '' THEN BEGIN
            lRec.RESET;
            lRec.SETRANGE("Journal Template Name", Rec."Journal Template Name");
            lRec.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
            IF lRec.FINDFIRST THEN lRec.MODIFYALL("Document No.", ItemJournalDocNo);
        END;
    end;
    //page
    // procedure checkFAPRAssetbeforerelease(var parPurchHeader: Record "Purchase Header")
    // var
    //     lRecPurchLine: Record "Purchase Line";
    // begin
    //     gRecMIISetup.GET();
    //     lRecPurchLine.RESET;
    //     lRecPurchLine.SETRANGE(lRecPurchLine."Document No.", parPurchHeader."No.");
    //     lRecPurchLine.SETRANGE(lRecPurchLine."PR Type", lRecPurchLine."PR Type"::Asset);
    //     lRecPurchLine.SETFILTER(lRecPurchLine."Purchase Req. No.", '<>%1', '');
    //     lRecPurchLine.SETRANGE(lRecPurchLine."PR Line Type", lRecPurchLine."PR Line Type"::"Fixed Asset");
    //     lRecPurchLine.SETRANGE(lRecPurchLine.Type, lRecPurchLine.Type::"G/L Account");
    //     lRecPurchLine.SETRANGE(lRecPurchLine."No.", gRecMIISetup."No. G/L FA");
    //     IF lRecPurchLine.FIND('-') THEN BEGIN
    //         REPEAT
    //             lRecPurchLine.CalcFields("Fixed Asset PR Qty", "Fixed Asset PR Amount");
    //             IF lRecPurchLine."Fixed Asset PR Qty" <> lRecPurchLine.Quantity THEN ERROR('"Quantity fixed asset" %1 is different from "Quantity PO" %2 in line %3', lRecPurchLine."Fixed Asset PR Qty", lRecPurchLine."Quantity", lRecPurchLine."Line No.");
    //             IF lRecPurchLine."Fixed Asset PR Amount" <> lRecPurchLine."Line Amount" THEN ERROR('"Amount fixed asset" %1 is different from "Amount PO" %2 in line %3', lRecPurchLine."Fixed Asset PR Amount", lRecPurchLine."Line Amount", lRecPurchLine."Line No.");
    //         UNTIL lRecPurchLine.NEXT = 0;
    //     END;
    // end;

    // procedure createJournalFA(parPurchLine: Record "Purchase Line"; parPurchRcptHeader: Record "Purch. Rcpt. Header")
    // var
    //     lRecGJL: Record "Gen. Journal Line";
    //     lRecFAPR: Record "PR Asset FA List";
    // begin
    //     gRecMIISetup.GET();
    //     gRecSourceCodeSetup.GET();
    //     gRecSourceCodeSetup.TestField(Purchases);
    //     lRecFAPR.RESET;
    //     lRecFAPR.SETRANGE(lRecFAPR."PO No.", parPurchLine."Document No.");
    //     lRecFAPR.SETRANGE(lRecFAPR."PO Line No.", parPurchLine."Line No.");
    //     lRecFAPR.SETRANGE(lRecFAPR."Purchase Req. No.", parPurchLine."Purchase Req. No.");
    //     lRecFAPR.SETRANGE(lRecFAPR."Purchase Req. Line No.", parPurchLine."Purchase Req. Line No.");
    //     lRecFAPR.SETFILTER(lRecFAPR."FA No.", '<>%1', '');
    //     IF lRecFAPR.FIND('-') THEN BEGIN
    //         REPEAT
    //             lRecGJL.INIT;
    //             lRecGJL."Journal Template Name" := gRecMIISetup."FA Journal Template";
    //             lRecGJL."Journal Batch Name" := gRecMIISetup."FA Journal Batch";
    //             lRecGJL."Line No." := getGenJnlLastLineNo(gRecMIISetup."FA Journal Template", gRecMIISetup."FA Journal Batch");
    //             lRecGJL.INSERT(TRUE);
    //             lRecGJL.VALIDATE("Posting Date", parPurchRcptHeader."Posting Date");
    //             lRecGJL."Document No." := parPurchRcptHeader."No.";
    //             lRecGJL.VALIDATE("Account Type", lRecGJL."Account Type"::"Fixed Asset");
    //             lRecGJL.VALIDATE("Account No.", lRecFAPR."FA No.");
    //             lRecGJL.VALIDATE("FA Posting Type", lRecGJL."FA Posting Type"::"Acquisition Cost");
    //             lRecGJL.VALIDATE(Quantity, lRecFAPR."Quantity");
    //             lRecGJL.VALIDATE(Amount, lRecFAPR."Line Amount");
    //             lRecGJL.VALIDATE("Gen. Prod. Posting Group", '');
    //             lRecGJL.VALIDATE("Source Code", gRecSourceCodeSetup.Purchases);
    //             lRecGJL.MODIFY;
    //         UNTIL lRecFAPR.NEXT = 0;
    //     END;
    // end;

    // procedure createJournalFACounter(parPurchRcptHeader: Record "Purch. Rcpt. Header"; parTotalAmount: Decimal)
    // var
    //     lRecGJL: Record "Gen. Journal Line";
    //     lRecFAPR: Record "PR Asset FA List";
    // begin
    //     gRecMIISetup.GET();


    //     gRecSourceCodeSetup.GET();
    //     gRecSourceCodeSetup.TestField(Purchases);
    //     lRecGJL.INIT;
    //     lRecGJL."Journal Template Name" := gRecMIISetup."FA Journal Template";
    //     lRecGJL."Journal Batch Name" := gRecMIISetup."FA Journal Batch";
    //     lRecGJL."Line No." := getGenJnlLastLineNo(gRecMIISetup."FA Journal Template", gRecMIISetup."FA Journal Batch");
    //     lRecGJL.INSERT(TRUE);
    //     lRecGJL.VALIDATE("Posting Date", parPurchRcptHeader."Posting Date");
    //     lRecGJL."Document No." := parPurchRcptHeader."No.";
    //     lRecGJL.VALIDATE("Account Type", lRecGJL."Account Type"::"G/L Account");
    //     lRecGJL.VALIDATE("Account No.", gRecMIISetup."No. G/L FA");
    //     lRecGJL.VALIDATE(Description, parPurchRcptHeader."Posting Description");
    //     lRecGJL.VALIDATE(Quantity, 1);
    //     IF parTotalAmount > 0 THEN parTotalAmount := -parTotalAmount;
    //     lRecGJL.VALIDATE(Amount, parTotalAmount);
    //     lRecGJL.VALIDATE("Gen. Prod. Posting Group", '');
    //     lRecGJL.VALIDATE("Source Code", gRecSourceCodeSetup.Purchases);
    //     lRecGJL."Line Counter Auto Journal" := TRUE;
    //     lRecGJL.MODIFY;
    // end;

    // local procedure getGenJnlLastLineNo(parTemplate: Code[10]; parBatch: Code[10]): Integer
    // var
    //     lRecGenJnl: Record "Gen. Journal Line";
    // begin
    //     lRecGenJnl.RESET;
    //     lRecGenJnl.SETRANGE("Journal Template Name", parTemplate);
    //     lRecGenJnl.SETRANGE("Journal Batch Name", parBatch);
    //     IF lRecGenJnl.FINDLAST THEN
    //         EXIT(lRecGenJnl."Line No." + 10000)
    //     ELSE
    //         EXIT(10000);
    // end;

    local procedure clearGenJournalLine(parTemplate: Code[10]; parBatch: Code[10]; parDocNo: Code[20])
    var
        lRecGenJnl: Record "Gen. Journal Line";
    begin
        lRecGenJnl.RESET;
        lRecGenJnl.SETRANGE("Journal Template Name", parTemplate);
        lRecGenJnl.SETRANGE("Journal Batch Name", parBatch);
        lRecGenJnl.SETFILTER("Document No.", '<>%1', parDocNo);
        IF lRecGenJnl.FIND('-') THEN lRecGenJnl.DELETEALL;
        lRecGenJnl.RESET;
        lRecGenJnl.SETRANGE("Journal Template Name", parTemplate);
        lRecGenJnl.SETRANGE("Journal Batch Name", parBatch);
        lRecGenJnl.SETRANGE("Document No.", parDocNo);
        lRecGenJnl.SETFILTER("Account Type", '<>%1', lRecGenJnl."Account Type"::"Fixed Asset");
        IF lRecGenJnl.FIND('-') THEN lRecGenJnl.DELETEALL;
    end;
    //tax
    // [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterInsertEvent', '', false, false)]
    // local procedure OnAfterValidateEvent(VAR Rec: Record Customer; RunTrigger: Boolean)
    // var
    // begin
    //     Rec."Tax Type" := Rec."Tax Type"::"Tax Document";
    //     rec.Modify();
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Sales Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    // local procedure TableSalesInvHeaderOnAfterInsert(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean);
    // var
    //     lrecSalesTaxDoc: Record "Sales Tax Documents";
    //     lRecNoSeriesLine: record "No. Series Line";
    //     //NoSeriesMgt: Codeunit NoSeriesManagement;
    //     NoSeries: Codeunit "No. Series";
    //     lRecMSISetup: record "MII Setup";
    //     lRecSalesInvHeader: record "Sales Invoice Header";
    // begin
    //     IF (Rec."Tax Type" = Rec."Tax Type"::"Tax Document") AND (Rec."Prepayment Order No." = '') THEN BEGIN
    //         CASE Rec."Tax-Document Post" OF
    //             Rec."Tax-Document Post"::Post:
    //                 BEGIN
    //                     lRecMSISetup.Get();
    //                     lRecMSISetup.TestField("Tax Nos.");
    //                     //Rec."Tax No." := NoSeriesMgt.GetNextNo(lRecMSISetup."Tax Nos.", Rec."Posting Date", true);
    //                     Rec."Tax No." := NoSeries.GetNextNo(lRecMSISetup."Tax Nos.", Rec."Posting Date", true);

    //                     lRecNoSeriesLine.Reset();
    //                     lRecNoSeriesLine.Setfilter("Series Code", 'FP');
    //                     lRecNoSeriesLine.SetRange("Warning No.", Rec."Tax No.");
    //                     if lRecNoSeriesLine.FindFirst() then Message('No. Faktur Pajak hampir habis');

    //                 END;
    //             Rec."Tax-Document Post"::Prompt:
    //                 BEGIN
    //                     IF CONFIRM('Do you want to Generate Tax No. for this document?') THEN BEGIN
    //                         lRecMSISetup.Get();
    //                         lRecMSISetup.TestField("Tax Nos.");
    //                         //Rec."Tax No." := NoSeriesMgt.GetNextNo(lRecMSISetup."Tax Nos.", Rec."Posting Date", true);
    //                         Rec."Tax No." := NoSeries.GetNextNo(lRecMSISetup."Tax Nos.", Rec."Posting Date", true);
    //                     END;

    //                     lRecNoSeriesLine.Reset();
    //                     lRecNoSeriesLine.Setfilter("Series Code", 'FP');
    //                     lRecNoSeriesLine.SetRange("Warning No.", Rec."Tax No.");
    //                     if lRecNoSeriesLine.FindFirst() then Message('No. Faktur Pajak hampir habis');

    //                 END;
    //         END;
    //         lrecSalesTaxDoc.RESET();
    //         IF lrecSalesTaxDoc.GET(lrecSalesTaxDoc."Document Type"::Invoice, Rec."No.") THEN BEGIN
    //         END
    //         ELSE BEGIN
    //             //Message('ketemu transfer');
    //             lrecSalesTaxDoc.INIT();
    //             lrecSalesTaxDoc."Document Type" := lrecSalesTaxDoc."Document Type"::Invoice;
    //             lrecSalesTaxDoc.TRANSFERFIELDS(Rec);
    //             lrecSalesTaxDoc.INSERT();
    //         END;
    //     END;
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Sales Cr.Memo Header", 'OnAfterInsertEvent', '', false, false)]
    // local procedure TableSalesCrMemoHeaderOnAfterInsert(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean);
    // var
    //     lrecSalesTaxDoc: Record "Sales Tax Documents";
    // begin
    //     lrecSalesTaxDoc.RESET();
    //     IF lrecSalesTaxDoc.GET(lrecSalesTaxDoc."Document Type"::"Credit Memo", Rec."No.") THEN BEGIN
    //     END
    //     ELSE BEGIN
    //         lrecSalesTaxDoc.INIT();
    //         lrecSalesTaxDoc."Document Type" := lrecSalesTaxDoc."Document Type"::"Credit Memo";
    //         lrecSalesTaxDoc.TRANSFERFIELDS(Rec);
    //         lrecSalesTaxDoc.INSERT();
    //     END;
    // end;

    procedure TestNoSeries()
    var
        lRecMSISetup: record "MII Setup";
    begin
        lRecMSISetup.Get();
        lRecMSISetup.TestField("Tax Nos.");
    end;

    // procedure GetNoSeriesCode(): Code[20]
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     lRecMSISetup.Get();
    //     exit(lRecMSISetup."Tax Nos.");
    // end;
    // //Purchase Tax
    // [EventSubscriber(ObjectType::Table, database::"Purch. Inv. Header", 'OnAfterInsertEvent', '', false, false)]
    // local procedure TablePurchInvHeaderOnAfterInsert(var Rec: Record "Purch. Inv. Header"; RunTrigger: Boolean);
    // var
    //     lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
    // begin
    //     lrecPurchTaxDoc.RESET();
    //     IF lrecPurchTaxDoc.GET(lrecPurchTaxDoc."Document Type"::Invoice, Rec."No.") THEN BEGIN
    //     END
    //     ELSE BEGIN
    //         lrecPurchTaxDoc.INIT();
    //         lrecPurchTaxDoc."Document Type" := lrecPurchTaxDoc."Document Type"::Invoice;
    //         lrecPurchTaxDoc.TRANSFERFIELDS(Rec);
    //         lrecPurchTaxDoc.INSERT();
    //     END;
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Purch. Cr. Memo Hdr.", 'OnAfterInsertEvent', '', false, false)]
    // local procedure TablePurchCrMemoHeaderOnAfterInsert(var Rec: Record "Purch. Cr. Memo Hdr."; RunTrigger: Boolean);
    // var
    //     lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
    // begin
    //     lrecPurchTaxDoc.RESET();
    //     IF lrecPurchTaxDoc.GET(lrecPurchTaxDoc."Document Type"::"Credit Memo", Rec."No.") THEN BEGIN
    //     END
    //     ELSE BEGIN
    //         lrecPurchTaxDoc.INIT();
    //         lrecPurchTaxDoc."Document Type" := lrecPurchTaxDoc."Document Type"::"Credit Memo";
    //         lrecPurchTaxDoc.TRANSFERFIELDS(Rec);
    //         lrecPurchTaxDoc.INSERT();
    //     END;
    // end;
    // //Purchase Tax
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post Prepayments", 'OnAfterPostPrepayments', '', false, false)]
    // local procedure OnInsertDP(var SalesInvoiceHeader: Record "Sales Invoice Header");
    // var
    //     lrecSalesTaxDoc: Record "Sales Tax Documents";
    //     lRecNoSeriesLine: record "No. Series Line";
    //     //NoSeriesMgt: Codeunit NoSeriesManagement;
    //     NoSeries: Codeunit "No. Series";
    //     lRecMSISetup: record "MII Setup";
    //     lRecSalesInvHeader: record "Sales Invoice Header";
    // begin
    //     IF (SalesInvoiceHeader."Tax Type" = SalesInvoiceHeader."Tax Type"::"Tax Document") AND (SalesInvoiceHeader."Prepayment Order No." <> '') THEN BEGIN
    //         CASE SalesInvoiceHeader."Tax-Document Post" OF
    //             SalesInvoiceHeader."Tax-Document Post"::Post:
    //                 BEGIN
    //                     lRecMSISetup.Get();
    //                     lRecMSISetup.TestField("Tax Nos.");
    //                     //SalesInvoiceHeader."Tax No." := NoSeriesMgt.GetNextNo(lRecMSISetup."Tax Nos.", SalesInvoiceHeader."Posting Date", true);
    //                     SalesInvoiceHeader."Tax No." := NoSeries.GetNextNo(lRecMSISetup."Tax Nos.", SalesInvoiceHeader."Posting Date", true);
    //                     SalesInvoiceHeader.Modify();

    //                     lRecNoSeriesLine.Reset();
    //                     lRecNoSeriesLine.Setfilter("Series Code", 'FP');
    //                     lRecNoSeriesLine.SetRange("Warning No.", SalesInvoiceHeader."Tax No.");
    //                     if lRecNoSeriesLine.FindFirst() then Message('No. Faktur Pajak hampir habis');

    //                 END;
    //             SalesInvoiceHeader."Tax-Document Post"::Prompt:
    //                 BEGIN
    //                     IF CONFIRM('Do you want to Generate Tax No. for this document?') THEN BEGIN
    //                         //SalesInvoiceHeader."Tax No." := fGenerateTaxNo(SalesInvoiceHeader);
    //                         lRecMSISetup.Get();
    //                         lRecMSISetup.TestField("Tax Nos.");
    //                         //SalesInvoiceHeader."Tax No." := NoSeriesMgt.GetNextNo(lRecMSISetup."Tax Nos.", SalesInvoiceHeader."Posting Date", true);
    //                         SalesInvoiceHeader."Tax No." := NoSeries.GetNextNo(lRecMSISetup."Tax Nos.", SalesInvoiceHeader."Posting Date", true);
    //                         SalesInvoiceHeader.Modify();
    //                     END;

    //                     lRecNoSeriesLine.Reset();
    //                     lRecNoSeriesLine.Setfilter("Series Code", 'FP');
    //                     lRecNoSeriesLine.SetRange("Warning No.", SalesInvoiceHeader."Tax No.");
    //                     if lRecNoSeriesLine.FindFirst() then Message('No. Faktur Pajak hampir habis');

    //                 END;
    //         END;
    //     END;
    //     lrecSalesTaxDoc.RESET();
    //     IF lrecSalesTaxDoc.GET(lrecSalesTaxDoc."Document Type"::Invoice, SalesInvoiceHeader."No.") THEN BEGIN
    //     END
    //     ELSE BEGIN
    //         //Message('ketemu transfer');
    //         lrecSalesTaxDoc.INIT();
    //         lrecSalesTaxDoc."Document Type" := lrecSalesTaxDoc."Document Type"::Invoice;
    //         lrecSalesTaxDoc.TRANSFERFIELDS(SalesInvoiceHeader);
    //         lrecSalesTaxDoc.INSERT();
    //     END;
    // end;

    var
        gRecMIISetup: Record "MII Setup";
        gRecSourceCodeSetup: Record "Source Code Setup";
        gCUMSIFunct: Codeunit "MII Function";
    //gCUNoSeriesMgt: Codeunit NoSeriesManagement;
}
