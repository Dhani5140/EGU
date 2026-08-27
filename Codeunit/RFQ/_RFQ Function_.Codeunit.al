// codeunit 50193 "RFQ Function"
// {
//     trigger OnRun()
//     begin
//     end;

//     procedure closedStatus_RFQ(RFQNo: Code[20])
//     var
//         lRecRFQHeader: Record "RFQ Header";
//         lRecRFQLine: Record "RFQ Line";
//         isOutstanding: Boolean;
//         hasProcess: Boolean;
//         hasLine: Boolean;
//         statusInt: Integer;
//     begin
//         statusInt := 0;
//         isOutstanding := FALSE;
//         hasLine := FALSE;
//         hasProcess := FALSE;
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQNo);
//         IF lRecRFQLine.FIND('-') THEN BEGIN
//             REPEAT
//                 hasLine := TRUE;
//                 IF lRecRFQLine.Quantity > lRecRFQLine."Outstanding Quantity" THEN hasProcess := TRUE;
//                 IF lRecRFQLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
//             UNTIL (lRecRFQLine.NEXT = 0);
//         END;
//         IF hasLine THEN BEGIN
//             IF hasProcess THEN BEGIN
//                 IF isOutstanding THEN BEGIN
//                     statusInt := 2;
//                 END
//                 ELSE BEGIN
//                     statusInt := 3;
//                 END;
//             END
//             ELSE BEGIN
//                 statusInt := 1;
//             END;
//         END
//         ELSE BEGIN
//             statusInt := 3;
//         END;
//         IF statusInt <> 0 THEN BEGIN
//             lRecRFQHeader.RESET;
//             lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", RFQNo);
//             IF lRecRFQHeader.FINDFIRST THEN BEGIN
//                 Case StatusInt OF
//                     1:
//                         lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Released);
//                     2:
//                         lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Processed);
//                     3:
//                         lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Closed);
//                 END;
//                 lRecRFQHeader.MODIFY;
//             END;
//         END;
//     end;

//     procedure closedStatus_RFQfromcreatePO(RFQNo: Code[20]): Integer
//     var
//         lRecRFQHeader: Record "RFQ Header";
//         lRecRFQLine: Record "RFQ Line";
//         isOutstanding: Boolean;
//         hasProcess: Boolean;
//         hasLine: Boolean;
//         statusInt: Integer;
//     begin
//         statusInt := 0;
//         isOutstanding := FALSE;
//         hasLine := FALSE;
//         hasProcess := FALSE;
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQNo);
//         IF lRecRFQLine.FIND('-') THEN BEGIN
//             REPEAT
//                 hasLine := TRUE;
//                 IF lRecRFQLine.Quantity > lRecRFQLine."Outstanding Quantity" THEN hasProcess := TRUE;
//                 IF lRecRFQLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
//             UNTIL (lRecRFQLine.NEXT = 0);
//         END;
//         IF hasLine THEN BEGIN
//             IF hasProcess THEN BEGIN
//                 IF isOutstanding THEN BEGIN
//                     statusInt := 2;
//                 END
//                 ELSE BEGIN
//                     statusInt := 3;
//                 END;
//             END
//             ELSE BEGIN
//                 statusInt := 1;
//             END;
//         END
//         ELSE BEGIN
//             statusInt := 3;
//         END;
//         exit(statusInt);
//     end;

//     //UpdateOutstanding
//     procedure updOutstandingQtyRFQ(var ParRFQLine: Record "RFQ Line"; fromRecordID: RecordID; QtytoUpd: Decimal; FromCreatePO: Boolean)
//     var
//         lRecRFQHeader: Record "RFQ Header";
//         lRecRFQLine: Record "RFQ Line";
//         lRecPurchLine: Record "Purchase Line";
//         lRecPurchInvLine: Record "Purch. Inv. Line";
//         lDecTotalPOQty: Decimal;
//         lDecOutstandingQty: Decimal;
//         StatusInt: Integer;
//     begin
//         CLEAR(lDecTotalPOQty);
//         CLEAR(lDecOutstandingQty);
//         CASE fromRecordID.TableNo OF
//             database::"Purchase Line":
//                 BEGIN
//                     lRecPurchLine.RESET;
//                     lRecPurchLine.SETRANGE(lRecPurchLine."RFQ No.", ParRFQLine."RFQ No.");
//                     lRecPurchLine.SETRANGE(lRecPurchLine."RFQ Line No.", ParRFQLine."Line No.");
//                     IF lRecPurchLine.FIND('-') THEN BEGIN
//                         lRecPurchLine.CalcSums(Quantity);
//                         lDecTotalPOQty := ABS(lRecPurchLine.Quantity);
//                     END;
//                     lRecPurchLine.RESET;
//                     lRecPurchLine.GET(fromRecordID);
//                     lDecTotalPOQty := lDecTotalPOQty - lRecPurchLine.Quantity;
//                     // IF (lDecTotalPOQty = 0) OR (QtytoUpd = 0) THEN BEGIN
//                     lRecPurchInvLine.RESET;
//                     lRecPurchInvLine.SETRANGE(lRecPurchInvLine."RFQ No.", ParRFQLine."RFQ No.");
//                     lRecPurchInvLine.SETRANGE(lRecPurchInvLine."RFQ Line No.", ParRFQLine."Line No.");
//                     IF lRecPurchInvLine.FIND('-') THEN BEGIN
//                         lRecPurchInvLine.CalcSums(Quantity);
//                         lDecTotalPOQty += ABS(lRecPurchInvLine.Quantity);
//                     END;
//                     // END;
//                 END;
//         END;
//         lDecTotalPOQty := ABS(lDecTotalPOQty);
//         lDecOutstandingQty := ParRFQLine.Quantity - lDecTotalPOQty - QtytoUpd;
//         IF lDecOutstandingQty > 0 THEN BEGIN
//             ParRFQLine."Outstanding Quantity" := lDecOutstandingQty;
//         END
//         ELSE BEGIN
//             ParRFQLine."Outstanding Quantity" := 0;
//         END;
//         ParRFQLine."Qty to PO" := ParRFQLine."Outstanding Quantity";
//         ParRFQLine.MODIFY;
//         closedStatus_RFQ(ParRFQLine."RFQ No.");
//     end;


//     //Check
//     procedure checkRFQLinehasWinner(RFQNo: Code[20])
//     var
//         lRecRFQLine: Record "RFQ Line";
//     begin
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
//         lRecRFQLine.SETRANGE("Vendor No.", '');
//         IF lRecRFQLine.FINDFIRST THEN BEGIN
//             ERROR('RFQ Line %1 still not have vendor winner, cannot proceed', lRecRFQLine."Line No.")
//         END;
//     end;

//     // Tambahkan di dalam codeunit 80103 "RFQ Function"
//     // Letakkan berdekatan dengan procedure check lainnya

//     procedure checkVendorListNotEmpty(RFQNo: Code[20])
//     var
//         lRecRFQVendor: Record "RFQ Vendor List";
//     begin
//         lRecRFQVendor.RESET();
//         lRecRFQVendor.SETRANGE("RFQ No.", RFQNo);
//         IF NOT lRecRFQVendor.FINDFIRST() THEN
//             ERROR('RFQ belum memiliki Vendor. Tambahkan Vendor terlebih dahulu sebelum Release.');
//     end;

//     procedure checkRFQLineNotEmpty(RFQNo: Code[20])
//     var
//         lRecRFQLine: Record "RFQ Line";
//     begin
//         lRecRFQLine.RESET();
//         lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
//         IF NOT lRecRFQLine.FINDFIRST() THEN
//             ERROR('RFQ tidak memiliki Line Item. Tambahkan item terlebih dahulu.');
//     end;

//     procedure checkRFQLinehasPO(RFQNo: Code[20]; RFQLineNo: Integer; msgErr: Text)
//     var
//         lRecRFQLine: Record "RFQ Line";
//     begin
//         lRecRFQLine.RESET;
//         lRecRFQLine.CalcFields("Total Qty on PO");
//         lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
//         IF RFQLineNo <> 0 THEN lRecRFQLine.SETRANGE("Line No.", RFQLineNo);
//         lRecRFQLine.SETFILTER("Total Qty on PO", '>%1', 0);
//         IF lRecRFQLine.FINDFIRST THEN BEGIN
//             ERROR('RFQ Line %1 already has Purchase Order, cannot %2', lRecRFQLine."Line No.", msgErr)
//         END;
//         lRecRFQLine.RESET;
//         lRecRFQLine.CalcFields("Total Qty on Posted Order");
//         lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
//         IF RFQLineNo <> 0 THEN lRecRFQLine.SETRANGE("Line No.", RFQLineNo);
//         lRecRFQLine.SETFILTER("Total Qty on Posted Order", '>%1', 0);
//         IF lRecRFQLine.FINDFIRST THEN BEGIN
//             ERROR('RFQ Line %1 already has Posted Purchase Order, cannot %2', lRecRFQLine."Line No.", msgErr)
//         END;
//     end;

//     procedure insertRFQLineDetailsfromRFQLine(var RFQLine: Record "RFQ Line")
//     var
//         lRecRFQVendor: Record "RFQ Vendor List";
//         WinEntryRFQVendor: Integer;
//     begin
//         CLEAR(WinEntryRFQVendor);
//         lRecRFQVendor.RESET;
//         lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", RFQLine."RFQ No.");
//         IF lRecRFQVendor.FIND('-') THEN BEGIN
//             REPEAT
//                 insertRFQLineDetails(RFQLine, lRecRFQVendor);
//                 IF lRecRFQVendor."Check Win" THEN WinEntryRFQVendor := lRecRFQVendor."Entry No. RFQ Vendor";
//             UNTIL lRecRFQVendor.NEXT = 0;
//         END;
//         IF WinEntryRFQVendor <> 0 THEN BEGIN
//             updWinRFQLine(RFQLine, WinEntryRFQVendor, TRUE);
//         END;
//     end;

//     procedure insertRFQLineDetailsfromRFQVendor(var RFQVendor: Record "RFQ Vendor List")
//     var
//         lRecRFQLine: Record "RFQ Line";
//     begin
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQVendor."RFQ No.");
//         IF lRecRFQLine.FIND('-') THEN BEGIN
//             REPEAT
//                 // insertRFQLineDetails sudah cek duplikat sendiri di dalam
//                 insertRFQLineDetails(lRecRFQLine, RFQVendor);
//             UNTIL lRecRFQLine.NEXT = 0;
//         END
//     end;

//     procedure reinsertRFQLineDetails(var parRFQHeader: Record "RFQ Header")
//     var
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQVendor: Record "RFQ Vendor List";
//     begin
//         lRecRFQVendor.RESET;
//         lRecRFQVendor.SETRANGE("RFQ No.", parRFQHeader."RFQ No.");
//         IF lRecRFQVendor.FIND('-') THEN BEGIN
//             REPEAT
//                 lRecRFQLine.RESET;
//                 lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", lRecRFQVendor."RFQ No.");
//                 IF lRecRFQLine.FIND('-') THEN BEGIN
//                     REPEAT
//                         // insertRFQLineDetails sudah cek duplikat sendiri di dalam
//                         insertRFQLineDetails(lRecRFQLine, lRecRFQVendor);
//                     UNTIL lRecRFQLine.NEXT = 0;
//                 END UNTIL lRecRFQVendor.NEXT = 0;
//         END;
//     end;

//     procedure insertRFQLineDetails(var RFQLine: Record "RFQ Line"; var RFQVendor: Record "RFQ Vendor List")
//     var
//         lRecRFQLineDetails: Record "RFQ Line Details";
//         lRecRFQLineDetailsIns: Record "RFQ Line Details";
//     begin
//         lRecRFQLineDetails.RESET;
//         lRecRFQLineDetails.SETRANGE("RFQ No.", RFQLine."RFQ No.");
//         lRecRFQLineDetails.SETRANGE("No.", RFQLine."No.");
//         lRecRFQLineDetails.SETRANGE("Entry No. RFQ Vendor", RFQVendor."Entry No. RFQ Vendor");
//         IF NOT lRecRFQLineDetails.FINDFIRST THEN BEGIN
//             lRecRFQLineDetailsIns.INIT();
//             lRecRFQLineDetailsIns."Entry No." := 0;
//             lRecRFQLineDetailsIns."RFQ No." := RFQLine."RFQ No.";
//             lRecRFQLineDetailsIns."RFQ Line No." := RFQLine."Line No.";
//             lRecRFQLineDetailsIns.VALIDATE("Vendor No.", RFQVendor."Vendor No.");
//             lRecRFQLineDetailsIns.Type := RFQLine.Type;
//             lRecRFQLineDetailsIns.VALIDATE("No.", RFQLine."No.");
//             lRecRFQLineDetailsIns.VALIDATE(Quantity, 1);
//             lRecRFQLineDetailsIns."Purchase Req. No." := RFQLine."Purchase Req. No.";
//             lRecRFQLineDetailsIns."Purchase Req. Line No." := RFQLine."Purchase Req. Line No.";
//             lRecRFQLineDetailsIns."Material Req. No." := RFQLine."Material Req. No.";
//             lRecRFQLineDetailsIns."Material Req. Line No." := RFQLine."Material Req. Line No.";
//             // lRecRFQLineDetailsIns."Entry No. RFQ Line" := RFQLine."Entry No. RFQ Line";
//             lRecRFQLineDetailsIns."Entry No. RFQ Vendor" := RFQVendor."Entry No. RFQ Vendor";
//             lRecRFQLineDetailsIns.INSERT();
//         END;
//     end;

//     procedure deleteRFQLineDetails(FromRecordID: RecordId)
//     var
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQLineOth: Record "RFQ Line";
//         lRecRFQVendor: Record "RFQ Vendor List";
//         lRecRFQLineDetails: Record "RFQ Line Details";
//     begin
//         CASE FromRecordID.TableNo OF
//             database::"RFQ Line":
//                 BEGIN
//                     lRecRFQLine.RESET;
//                     lRecRFQLine.GET(FromRecordID);
//                     lRecRFQLineOth.RESET;
//                     lRecRFQLineOth.SETRANGE(lRecRFQLineOth."RFQ No.", lRecRFQLine."RFQ No.");
//                     lRecRFQLineOth.SETRANGE(lRecRFQLineOth."No.", lRecRFQLine."No.");
//                     lRecRFQLineOth.SETFILTER(lRecRFQLineOth."Line No.", '<>%1', lRecRFQLine."Line No.");
//                     IF NOT lRecRFQLineOth.FINDFIRST THEN BEGIN
//                         lRecRFQLineDetails.RESET;
//                         lRecRFQLineDetails.SETRANGE("RFQ No.", lRecRFQLine."RFQ No.");
//                         lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
//                         IF lRecRFQLineDetails.FIND('-') THEN lRecRFQLineDetails.DELETEALL(TRUE);
//                     END;
//                 END;
//             database::"RFQ Vendor List":
//                 BEGIN
//                     lRecRFQVendor.RESET;
//                     lRecRFQVendor.GET(FromRecordID);
//                     // reopenStatusLineDetailsfromVendorList(lRecRFQVendor);
//                     lRecRFQLineDetails.RESET;
//                     lRecRFQLineDetails.SETRANGE("RFQ No.", lRecRFQVendor."RFQ No.");
//                     lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", lRecRFQVendor."Entry No. RFQ Vendor");
//                     IF lRecRFQLineDetails.FIND('-') THEN lRecRFQLineDetails.DELETEALL(TRUE);
//                 END;
//         END;
//     end;

//     procedure reopenStatusLineDetailsfromVendorList(var parVendorList: Record "RFQ Vendor List")
//     var
//         lRecRFQLineDet: Record "RFQ Line Details";
//         lRecRFQLineDetUpd: Record "RFQ Line Details";
//     begin
//         lRecRFQLineDet.RESET;
//         lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", parVendorList."RFQ No.");
//         lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Vendor", parVendorList."Entry No. RFQ Vendor");
//         lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Check Win", TRUE);
//         IF lRecRFQLineDet.FIND('-') THEN BEGIN
//             lRecRFQLineDetUpd.RESET;
//             lRecRFQLineDetUpd.SETRANGE(lRecRFQLineDetUpd."RFQ No.", lRecRFQLineDet."RFQ No.");
//             lRecRFQLineDetUpd.SETRANGE(lRecRFQLineDetUpd."Entry No. RFQ Line", lRecRFQLineDet."Entry No. RFQ Line");
//             IF lRecRFQLineDetUpd.FIND('-') THEN BEGIN
//                 lRecRFQLineDetUpd.MODIFYALL("Check Win", FALSE, TRUE);
//             END;
//         END;
//     end;

//     procedure resetRFQLineWinner(var parRFQLineDetails: Record "RFQ Line Details")
//     var
//         lRecRFQLine: Record "RFQ Line";
//     begin
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLineDetails."RFQ No.");
//         lRecRFQLine.SETRANGE(lRecRFQLine."Winner RFQ Line Details", parRFQLineDetails."Entry No.");
//         IF lRecRFQLine.FINDFIRST THEN BEGIN
//             lRecRFQLine.Validate("Winner RFQ Line Details", 0);
//             lRecRFQLine.Modify();
//         END;
//     end;

//     procedure createRFQHeader_PR(var ParPRHeader: Record "PR Material Header")
//     var
//         lRecPRLine: Record "PR Material Line";
//         lRecRFQHeader: Record "RFQ Header";
//         lRecNoSeries: Record "No. Series";
//     begin
//         gRecMSISetup.GET;
//         lRecNoSeries.RESET;
//         lRecNoSeries.GET(ParPRHeader."No. Series");
//         lRecNoSeries.TESTFIELD("RFQ Nos.");
//         IF gCUPRFunct.checkPRLinehasOutstanding(ParPRHeader."Purchase Req. No.") THEN BEGIN
//             lRecRFQHeader.INIT;
//             //lRecRFQHeader."RFQ No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."RFQ Nos.", WorkDate(), true);
//             lRecRFQHeader."RFQ No." := NoSeries.GetNextNo(lRecNoSeries."RFQ Nos.", WorkDate(), true);
//             lRecRFQHeader.INSERT(TRUE);
//             lRecRFQHeader.VALIDATE("No. Series", lRecNoSeries."RFQ Nos.");
//             lRecRFQHeader.VALIDATE("Document Date", WORKDATE);
//             lRecRFQHeader.VALIDATE("Location Code", ParPRHeader."Location Code");
//             lRecRFQHeader."External Document No." := ParPRHeader."Purchase Req. No.";
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 1 Code", ParPRHeader."Shortcut Dimension 1 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 2 Code", ParPRHeader."Shortcut Dimension 2 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 3 Code", ParPRHeader."Shortcut Dimension 3 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 4 Code", ParPRHeader."Shortcut Dimension 4 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 5 Code", ParPRHeader."Shortcut Dimension 5 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 6 Code", ParPRHeader."Shortcut Dimension 6 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 7 Code", ParPRHeader."Shortcut Dimension 7 Code");
//             lRecRFQHeader.VALIDATE("Shortcut Dimension 8 Code", ParPRHeader."Shortcut Dimension 8 Code");
//             lRecRFQHeader."Material Req. No." := ParPRHeader."Material Req. No.";
//             lRecRFQHeader."Purchase Request No." := ParPRHeader."Purchase Req. No.";
//             lRecRFQHeader.MODIFY(TRUE);
//             lRecPRLine.RESET;
//             lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", ParPRHeader."Purchase Req. No.");
//             lRecPRLine.SETFILTER(lRecPRLine."Outstanding Quantity", '>%1', 0);
//             IF lRecPRLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     createRFQLine_PR(lRecPRLine, lRecRFQHeader."RFQ No.");
//                 UNTIL lRecPRLine.NEXT = 0;
//             END;
//             COMMIT;
//             Page.RUN(Page::"RFQ Card", lRecRFQHeader);
//         END;
//     end;

//     // procedure CreateRFQLine_PR(ParPRLine: Record "PR Material Line"; DocNo: Code[20])
//     // var
//     //     lrecRFQLine: Record "RFQ Line";
//     // begin
//     //     lrecRFQLine.Init();
//     //     lrecRFQLine."RFQ No." := DocNo;
//     //     lrecRFQLine."Line No." := getLastLineNoRFQ(DocNo);
//     //     lrecRFQLine.INSERT(TRUE);
//     //     lrecRFQLine.Type := lrecRFQLine.Type::Item;
//     //     lrecRFQLine.Validate("Group Line No.", lrecRFQLine."Line No.");
//     //     lrecRFQLine.Validate("No.", ParPRLine."Item No.");
//     //     lrecRFQLine.Validate("Description", ParPRLine."Description");
//     //     lrecRFQLine.Validate(Quantity, ParPRLine."Outstanding Quantity");
//     //     lrecRFQLine.Validate("Original Qty PR", ParPRLine."Outstanding Quantity");
//     //     lrecRFQLine.Validate("Outstanding Quantity", ParPRLine."Outstanding Quantity");
//     //     lrecRFQLine.Validate("Location Code", ParPRLine."Location Code");
//     //     lrecRFQLine.Validate("Unit of Measure", ParPRLine."Unit of Measure");
//     //     lrecRFQLine.Validate("Part No.", ParPRLine."Part No.");
//     //     lrecRFQLine.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
//     //     lrecRFQLine.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
//     //     lrecRFQLine.Validate("Material Req. No.", ParPRLine."Material Req. No.");
//     //     lrecRFQLine.Validate("Material Req. Line No.", ParPRLine."Material Req. Line No.");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 1 Code", ParPRLine."Shortcut Dimension 1 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 2 Code", ParPRLine."Shortcut Dimension 2 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 4 Code", ParPRLine."Shortcut Dimension 4 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 5 Code", ParPRLine."Shortcut Dimension 5 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 6 Code", ParPRLine."Shortcut Dimension 6 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 7 Code", ParPRLine."Shortcut Dimension 7 Code");
//     //     lrecRFQLine.VALIDATE("Shortcut Dimension 8 Code", ParPRLine."Shortcut Dimension 8 Code");
//     //     lrecRFQLine.VALIDATE(Remarks, ParPRLine.Remarks);
//     //     lrecRFQLine."from PR" := TRUE;
//     //     lrecRFQLine.MODIFY(TRUE);
//     //     insertRFQLineDetailsfromRFQLine(lrecRFQLine);
//     //     gCUPRFunct.updOutstandingQtyPR(ParPRLine, lrecRFQLine.RecordID, ParPRLine."Outstanding Quantity");
//     // end;
//     procedure CreateRFQLine_PR(ParPRLine: Record "PR Material Line"; DocNo: Code[20])
//     var
//         lrecRFQLine: Record "RFQ Line";
//         PRHeader: Record "PR Material Header";
//         RFQVendor: Record "RFQ Vendor List";
//         Vendor: Record Vendor;
//     begin
//         lrecRFQLine.Init();
//         lrecRFQLine."RFQ No." := DocNo;
//         lrecRFQLine."Line No." := getLastLineNoRFQ(DocNo);
//         lrecRFQLine.INSERT(TRUE);

//         lrecRFQLine.Type := lrecRFQLine.Type::Item;
//         lrecRFQLine.Validate("Group Line No.", lrecRFQLine."Line No.");
//         lrecRFQLine.Validate("No.", ParPRLine."Item No.");
//         lrecRFQLine.Validate("Description", ParPRLine."Description");
//         lrecRFQLine.Validate(Quantity, ParPRLine."Outstanding Quantity");
//         lrecRFQLine.Validate("Original Qty PR", ParPRLine."Outstanding Quantity");
//         lrecRFQLine.Validate("Outstanding Quantity", ParPRLine."Outstanding Quantity");
//         lrecRFQLine.Validate("Location Code", ParPRLine."Location Code");
//         lrecRFQLine.Validate("Unit of Measure", ParPRLine."Unit of Measure");
//         lrecRFQLine.Validate("Part No.", ParPRLine."Part No.");
//         lrecRFQLine.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
//         lrecRFQLine.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
//         lrecRFQLine.Validate("Material Req. No.", ParPRLine."Material Req. No.");
//         lrecRFQLine.Validate("Material Req. Line No.", ParPRLine."Material Req. Line No.");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 1 Code", ParPRLine."Shortcut Dimension 1 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 2 Code", ParPRLine."Shortcut Dimension 2 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 4 Code", ParPRLine."Shortcut Dimension 4 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 5 Code", ParPRLine."Shortcut Dimension 5 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 6 Code", ParPRLine."Shortcut Dimension 6 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 7 Code", ParPRLine."Shortcut Dimension 7 Code");
//         lrecRFQLine.VALIDATE("Shortcut Dimension 8 Code", ParPRLine."Shortcut Dimension 8 Code");
//         lrecRFQLine.VALIDATE(Remarks, ParPRLine.Remarks);
//         lrecRFQLine."from PR" := TRUE;
//         lrecRFQLine.MODIFY(TRUE);

//         insertRFQLineDetailsfromRFQLine(lrecRFQLine);
//         gCUPRFunct.updOutstandingQtyPR(ParPRLine, lrecRFQLine.RecordID, ParPRLine."Outstanding Quantity");


//         // if PRHeader.Get(ParPRLine."Purchase Req. No.") then
//         //     if (PRHeader."Vendor No" <> '') and not RFQVendor.Get(DocNo, PRHeader."Vendor No") then begin
//         //         RFQVendor.Init();
//         //         RFQVendor."RFQ No." := DocNo;
//         //         RFQVendor."Vendor No." := PRHeader."Vendor No";
//         //         if Vendor.Get(PRHeader."Vendor No") then
//         //             RFQVendor."Vendor Name" := Vendor.Name;
//         //         RFQVendor.Insert(true);
//         //     end;

//         if PRHeader.Get(ParPRLine."Purchase Req. No.") then
//             if (PRHeader."Vendor No" <> '') then begin

//                 // Gunakan SetRange karena Vendor No. bukan Primary Key ke-2
//                 RFQVendor.Reset();
//                 RFQVendor.SetRange("RFQ No.", DocNo);
//                 RFQVendor.SetRange("Vendor No.", PRHeader."Vendor No");

//                 if not RFQVendor.FindFirst() then begin
//                     RFQVendor.Init();
//                     RFQVendor."RFQ No." := DocNo;
//                     RFQVendor."Vendor No." := PRHeader."Vendor No";
//                     if Vendor.Get(PRHeader."Vendor No") then
//                         RFQVendor."Vendor Name" := Vendor.Name;

//                     // Asumsi: Entry No. RFQ Vendor diset AutoIncrement di tabelnya
//                     RFQVendor.Insert(true);
//                 end;
//             end;

//     end;


//     procedure splitRFQLine(var parRFQLine: Record "RFQ Line");
//     var
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQLineIns: Record "RFQ Line";
//         lDecQty: Decimal;
//     begin
//         CLEAR(lDecQty);
//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
//         lRecRFQLine.SETRANGE(lRecRFQLine."Group Line No.", parRFQLine."Group Line No.");
//         IF lRecRFQLine.FIND('-') THEN BEGIN
//             lRecRFQLine.CalcSums(Quantity);
//             IF lRecRFQLine.Quantity >= parRFQLine."Original Qty PR" THEN ERROR('You cannot split this line because qty already maxed out', parRFQLine."Original Qty PR");
//             lDecQty := parRFQLine."Original Qty PR" - lRecRFQLine.Quantity;
//         END;
//         lRecRFQLineIns.INIT();
//         lRecRFQLineIns.TransferFields(parRFQLine);
//         lRecRFQLineIns."Entry No. RFQ Line" := 0;
//         lRecRFQLineIns."Line No." := getLastLineSplitNoRFQ(parRFQLine."RFQ No.", parRFQLine."Group Line No.");
//         lRecRFQLineIns.INSERT(TRUE);
//         lRecRFQLineIns.VALIDATE(Quantity, lDecQty);
//         lRecRFQLineIns.VALIDATE("Original Qty PR", parRFQLine."Original Qty PR");
//         lRecRFQLineIns."Parent Line No." := parRFQLine."Line No.";
//         lRecRFQLineIns."Shortcut Dimension 1 Code" := parRFQLine."Shortcut Dimension 1 Code";
//         lRecRFQLineIns."Shortcut Dimension 2 Code" := parRFQLine."Shortcut Dimension 2 Code";
//         lRecRFQLineIns."Shortcut Dimension 3 Code" := parRFQLine."Shortcut Dimension 3 Code";
//         lRecRFQLineIns."Shortcut Dimension 4 Code" := parRFQLine."Shortcut Dimension 4 Code";
//         lRecRFQLineIns."Shortcut Dimension 5 Code" := parRFQLine."Shortcut Dimension 5 Code";
//         lRecRFQLineIns."Shortcut Dimension 6 Code" := parRFQLine."Shortcut Dimension 6 Code";
//         lRecRFQLineIns."Shortcut Dimension 7 Code" := parRFQLine."Shortcut Dimension 7 Code";
//         lRecRFQLineIns."Shortcut Dimension 8 Code" := parRFQLine."Shortcut Dimension 8 Code";
//         lRecRFQLineIns."Location Code" := parRFQLine."Location Code";
//         lRecRFQLineIns."MR Usage Category" := parRFQLine."MR Usage Category";
//         lRecRFQLineIns."Unit Group" := parRFQLine."Unit Group";
//         lRecRFQLineIns.MODIFY(TRUE);
//     end;

//     procedure updWinAllRFQLine(var parRFQVendor: Record "RFQ Vendor List"; isChecked: Boolean)
//     var
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQLineDetails: Record "RFQ Line Details";
//     begin
//         iF isChecked THEN BEGIN
//             lRecRFQLine.RESET;
//             lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQVendor."RFQ No.");
//             IF lRecRFQLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     lRecRFQLineDetails.RESET;
//                     lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."RFQ No.", lRecRFQLine."RFQ No.");
//                     lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
//                     lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", parRFQVendor."Entry No. RFQ Vendor");
//                     IF lRecRFQLineDetails.FINDFIRST THEN BEGIN
//                         lRecRFQLine.VALIDATE("Winner RFQ Line Details", lRecRFQLineDetails."Entry No.");
//                         lRecRFQLine.MODIFY(TRUE);
//                     END;
//                 UNTIL lRecRFQLine.NEXT = 0;
//             END;
//         END
//         ELSE BEGIN
//             lRecRFQLine.RESET;
//             lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQVendor."RFQ No.");
//             IF lRecRFQLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     lRecRFQLine.VALIDATE("Winner RFQ Line Details", 0);
//                     lRecRFQLine.MODIFY(TRUE);
//                 UNTIL lRecRFQLine.NEXT = 0;
//             END;
//         END;
//     end;

//     procedure updWinRFQLine(var parRFQLine: Record "RFQ Line"; var parEntryNoRFQVendor: Integer; isChecked: Boolean)
//     var
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQLineDetails: Record "RFQ Line Details";
//     begin
//         iF isChecked THEN BEGIN
//             lRecRFQLine.RESET;
//             lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
//             lRecRFQLine.SETRANGE(lRecRFQLine."Line No.", parRFQLine."Line No.");
//             IF lRecRFQLine.FIND('-') THEN BEGIN
//                 lRecRFQLineDetails.RESET;
//                 lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."RFQ No.", lRecRFQLine."RFQ No.");
//                 lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
//                 lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", parEntryNoRFQVendor);
//                 IF lRecRFQLineDetails.FINDFIRST THEN BEGIN
//                     lRecRFQLine.VALIDATE("Winner RFQ Line Details", lRecRFQLineDetails."Entry No.");
//                     lRecRFQLine.MODIFY(TRUE);
//                 END;
//             END;
//         END
//         ELSE BEGIN
//             lRecRFQLine.RESET;
//             lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
//             lRecRFQLine.SETRANGE(lRecRFQLine."Line No.", parRFQLine."Line No.");
//             IF lRecRFQLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     lRecRFQLine.VALIDATE("Winner RFQ Line Details", 0);
//                     lRecRFQLine.MODIFY(TRUE);
//                 UNTIL lRecRFQLine.NEXT = 0;
//             END;
//         END;
//     end;
//     //Create PO
//     // procedure createPOHeader_RFQ(var ParRFQHeader: Record "RFQ Header")
//     // var
//     //     PurchHeaderIns: Record "Purchase Header";
//     //     PurchLineView: Record "Purchase Line";
//     //     lRecRFQLine: Record "RFQ Line";
//     //     lRecRFQVendor: Record "RFQ Vendor List";
//     //     lRecVendor: Record Vendor;
//     //     lRecNoSeries: Record "No. Series";
//     //     CurrVendorNo: Code[20];
//     //     BatchNo: Integer;
//     //     StatusInt: Integer;
//     //     currPRNo: Code[20];
//     //     currPRNoAdditionalLine: Code[20];
//     //     YourReference: Text[35];
//     //     OutstandingQty: Decimal;
//     //     FACount: Integer;
//     //     isPPH22: Boolean;
//     //     isPBBKB: Boolean;
//     //     WHTBusVendor: Code[20];
//     // begin
//     //     CLEAR(StatusInt);
//     //     CLEAR(WHTBusVendor);
//     //     CLEAR(currPRNoAdditionalLine);
//     //     gRecMSISetup.GET();

//     //     lRecNoSeries.RESET;
//     //     lRecNoSeries.GET(ParRFQHeader."No. Series");
//     //     lRecNoSeries.TESTFIELD("Purchase Order Nos.");
//     //     BatchNo := ParRFQHeader."Batch No. [PR]" + 1;
//     //     lRecRFQLine.RESET;
//     //     lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
//     //     lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
//     //     lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
//     //     lRecRFQLine.SetCurrentKey("Vendor No.");
//     //     lRecRFQLine.Ascending(TRUE);
//     //     IF lRecRFQLine.FIND('-') THEN BEGIN
//     //         REPEAT
//     //             lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

//     //             CLEAR(OutstandingQty);
//     //             IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
//     //                 lRecVendor.RESET;
//     //                 lRecVendor.GET(lRecRFQLine."Vendor No.");
//     //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
//     //                 lRecRFQVendor.RESET;
//     //                 lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");
//     //                 PurchHeaderIns.INIT;
//     //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
//     //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
//     //                 //PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
//     //                 PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
//     //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
//     //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
//     //                 PurchHeaderIns.INSERT(TRUE);
//     //                 PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
//     //                 PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
//     //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
//     //                 PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
//     //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
//     //                 PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
//     //                 PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");
//     //                 PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
//     //                 PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
//     //                 PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
//     //                 PurchHeaderIns.MODIFY(TRUE);
//     //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//     //             END
//     //             ELSE BEGIN
//     //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//     //             END;
//     //             CurrVendorNo := lRecRFQLine."Vendor No.";
//     //         UNTIL lRecRFQLine.NEXT = 0;
//     //     END
//     //     ELSE BEGIN
//     //         ERROR('No RFQ Line to be found for create PO');
//     //     END;


//     //     ParRFQHeader.MODIFY;
//     //     COMMIT;
//     //     PurchLineView.RESET;
//     //     PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
//     //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
//     //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
//     //     ParRFQHeader."Batch No. [PR]" := BatchNo;
//     //     StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
//     //     IF statusInt <> 0 THEN BEGIN
//     //         Case StatusInt OF
//     //             1:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
//     //             2:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
//     //             3:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
//     //         END;
//     //     END;
//     //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
//     // end;

//     procedure createPOHeader_RFQ(var ParRFQHeader: Record "RFQ Header")
//     var
//         PurchHeaderIns: Record "Purchase Header";
//         PurchLineView: Record "Purchase Line";
//         lRecRFQLine: Record "RFQ Line";
//         lRecRFQVendor: Record "RFQ Vendor List";
//         lRecVendor: Record Vendor;
//         lRecNoSeries: Record "No. Series";
//         lRecRFQLineDet: Record "RFQ Line Details"; // <--- TAMBAHAN 1: Deklarasi variabel baru
//         CurrVendorNo: Code[20];
//         BatchNo: Integer;
//         StatusInt: Integer;
//         currPRNo: Code[20];
//         currPRNoAdditionalLine: Code[20];
//         YourReference: Text[35];
//         OutstandingQty: Decimal;
//         FACount: Integer;
//         isPPH22: Boolean;
//         isPBBKB: Boolean;
//         WHTBusVendor: Code[20];
//     begin
//         CLEAR(StatusInt);
//         CLEAR(WHTBusVendor);
//         CLEAR(currPRNoAdditionalLine);
//         gRecMSISetup.GET();

//         lRecNoSeries.RESET;
//         lRecNoSeries.GET(ParRFQHeader."No. Series");
//         lRecNoSeries.TESTFIELD("Purchase Order Nos.");
//         BatchNo := ParRFQHeader."Batch No. [PR]" + 1;

//         lRecRFQLine.RESET;
//         lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
//         lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
//         lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
//         lRecRFQLine.SetCurrentKey("Vendor No.");
//         lRecRFQLine.Ascending(TRUE);

//         IF lRecRFQLine.FIND('-') THEN BEGIN
//             REPEAT
//                 lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

//                 CLEAR(OutstandingQty);
//                 IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
//                     lRecVendor.RESET;
//                     lRecVendor.GET(lRecRFQLine."Vendor No.");
//                     lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");

//                     lRecRFQVendor.RESET;
//                     lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");

//                     PurchHeaderIns.INIT;
//                     PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
//                     PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
//                     PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
//                     PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
//                     PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
//                     PurchHeaderIns.INSERT(TRUE);
//                     PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
//                     PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
//                     PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
//                     PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
//                     PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");

//                     // =======================================================================
//                     // --- TAMBAHAN 2: SUNTIKAN MAUT EXPECTED DATE KE PO HEADER ---
//                     // =======================================================================
//                     lRecRFQLineDet.RESET();
//                     lRecRFQLineDet.SETRANGE("RFQ No.", lRecRFQLine."RFQ No.");
//                     lRecRFQLineDet.SETRANGE("Entry No.", lRecRFQLine."Winner RFQ Line Details");
//                     IF lRecRFQLineDet.FINDFIRST() THEN BEGIN
//                         IF lRecRFQLineDet."Expected Receipt Date" <> 0D THEN
//                             PurchHeaderIns.VALIDATE("Expected Receipt Date", lRecRFQLineDet."Expected Receipt Date");
//                     END;
//                     // =======================================================================

//                     PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
//                     PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
//                     PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
//                     PurchHeaderIns.MODIFY(TRUE);

//                     createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//                 END
//                 ELSE BEGIN
//                     createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//                 END;
//                 CurrVendorNo := lRecRFQLine."Vendor No.";
//             UNTIL lRecRFQLine.NEXT = 0;
//         END
//         ELSE BEGIN
//             ERROR('No RFQ Line to be found for create PO');
//         END;

//         ParRFQHeader.MODIFY;
//         COMMIT;

//         PurchLineView.RESET;
//         PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
//         PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
//         PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
//         ParRFQHeader."Batch No. [PR]" := BatchNo;

//         StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
//         IF statusInt <> 0 THEN BEGIN
//             Case StatusInt OF
//                 1:
//                     ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
//                 2:
//                     ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
//                 3:
//                     ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
//             END;
//         END;
//         IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
//     end;


//     //Create PO-Vensel
//     // procedure createPOHeader_RFQ2(var ParRFQHeader: Record "Vensel Header")
//     // var
//     //     PurchHeaderIns: Record "Purchase Header";
//     //     PurchLineView: Record "Purchase Line";
//     //     lRecRFQLine: Record "RFQ Line";
//     //     lRecRFQVendor: Record "RFQ Vendor List";
//     //     lRecVendor: Record Vendor;
//     //     lRecNoSeries: Record "No. Series";
//     //     CurrVendorNo: Code[20];
//     //     BatchNo: Integer;
//     //     StatusInt: Integer;
//     //     currPRNo: Code[20];
//     //     currPRNoAdditionalLine: Code[20];
//     //     YourReference: Text[35];
//     //     OutstandingQty: Decimal;
//     //     FACount: Integer;
//     //     isPPH22: Boolean;
//     //     isPBBKB: Boolean;
//     //     WHTBusVendor: Code[20];
//     // begin
//     //     CLEAR(StatusInt);
//     //     CLEAR(WHTBusVendor);
//     //     CLEAR(currPRNoAdditionalLine);
//     //     gRecMSISetup.GET();

//     //     lRecNoSeries.RESET;
//     //     lRecNoSeries.GET(ParRFQHeader."No. Series");
//     //     lRecNoSeries.TESTFIELD("Purchase Order Nos.");
//     //     BatchNo := ParRFQHeader."Batch No. [PR]" + 1;
//     //     lRecRFQLine.RESET;
//     //     lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
//     //     lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
//     //     lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
//     //     lRecRFQLine.SetCurrentKey("Vendor No.");
//     //     lRecRFQLine.Ascending(TRUE);
//     //     IF lRecRFQLine.FIND('-') THEN BEGIN
//     //         REPEAT
//     //             lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

//     //             CLEAR(OutstandingQty);
//     //             IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
//     //                 lRecVendor.RESET;
//     //                 lRecVendor.GET(lRecRFQLine."Vendor No.");
//     //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
//     //                 lRecRFQVendor.RESET;
//     //                 lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");
//     //                 PurchHeaderIns.INIT;
//     //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
//     //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
//     //                 // PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
//     //                 PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
//     //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
//     //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
//     //                 PurchHeaderIns.INSERT(TRUE);
//     //                 PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
//     //                 PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
//     //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
//     //                 PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
//     //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
//     //                 PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
//     //                 PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");
//     //                 PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
//     //                 PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
//     //                 PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
//     //                 PurchHeaderIns.MODIFY(TRUE);
//     //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//     //             END
//     //             ELSE BEGIN
//     //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
//     //             END;
//     //             CurrVendorNo := lRecRFQLine."Vendor No.";
//     //         UNTIL lRecRFQLine.NEXT = 0;
//     //     END
//     //     ELSE BEGIN
//     //         ERROR('No RFQ Line to be found for create PO');
//     //     END;

//     //     ParRFQHeader.MODIFY;
//     //     COMMIT;
//     //     PurchLineView.RESET;
//     //     PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
//     //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
//     //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
//     //     ParRFQHeader."Batch No. [PR]" := BatchNo;
//     //     StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
//     //     IF statusInt <> 0 THEN BEGIN
//     //         Case StatusInt OF
//     //             1:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
//     //             2:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
//     //             3:
//     //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
//     //         END;
//     //     END;
//     //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);

//     // end;

//     procedure createPOHeader_RFQ2(var VenselHeader: Record "Vensel Header")
//     var
//         RFQLine: Record "RFQ Line";
//         RFQVendor: Record "RFQ Vendor List";
//         PurchHeader: Record "Purchase Header";
//         PurchLine: Record "Purchase Line";
//         LineNo: Integer;
//         CurrentVendor: Code[20];
//         POCount: Integer;
//     begin
//         // 1. Validasi Status Dokumen Vensel
//         if not (VenselHeader.Status in [VenselHeader.Status::Released, VenselHeader.Status::Processed, VenselHeader.Status::"Send To Vendor"]) then
//             Error('Status must be released or processed to create purchase order');

//         // 2. Filter Baris RFQ yang terhubung dengan dokumen ini dan siap di-PO-kan
//         RFQLine.Reset();
//         RFQLine.SetRange("RFQ No.", VenselHeader."RFQ No.");
//         RFQLine.SetFilter("Qty to PO", '>0');
//         RFQLine.SetFilter("Winner RFQ Line Details", '<>0'); // Pastikan pemenang sudah dipilih

//         // Wajib SetCurrentKey agar proses pembuatan PO terkelompok per Vendor dengan rapi
//         RFQLine.SetCurrentKey("RFQ No.", "Winner RFQ Line Details");

//         if RFQLine.FindSet() then begin
//             CurrentVendor := '';
//             POCount := 0;

//             repeat
//                 // 3. Tarik data Vendor Pemenang dari tabel RFQ Vendor List
//                 if RFQVendor.Get(RFQLine."RFQ No.", RFQLine."Winner RFQ Line Details") then begin
//                     RFQVendor.TestField("Vendor No.");

//                     // 4. LOGIKA GROUPING: Jika Vendor pemenang beda dari baris sebelumnya, Bikin PO Baru
//                     if CurrentVendor <> RFQVendor."Vendor No." then begin
//                         PurchHeader.Init();
//                         PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
//                         PurchHeader.Insert(true); // Generate PO No.

//                         PurchHeader.Validate("Buy-from Vendor No.", RFQVendor."Vendor No.");
//                         PurchHeader.Validate("Document Date", WorkDate());
//                         PurchHeader."Your Reference" := VenselHeader."Vensel No."; // Tracking dari Vensel
//                         PurchHeader.Modify(true);

//                         // Update variabel pelacak untuk baris berikutnya
//                         CurrentVendor := RFQVendor."Vendor No.";
//                         LineNo := 10000;
//                         POCount += 1;
//                     end;

//                     // 5. Masukkan Baris Barang (Lines) ke dalam PO yang sedang aktif
//                     PurchLine.Init();
//                     PurchLine.Validate("Document Type", PurchHeader."Document Type");
//                     PurchLine.Validate("Document No.", PurchHeader."No.");
//                     PurchLine.Validate("Line No.", LineNo);
//                     PurchLine.Insert(true);

//                     // Mapping Tipe Barang
//                     if RFQLine.Type = RFQLine.Type::Item then
//                         PurchLine.Validate(Type, PurchLine.Type::Item)
//                     else if RFQLine.Type = RFQLine.Type::"G/L Account" then
//                         PurchLine.Validate(Type, PurchLine.Type::"G/L Account");

//                     // Transfer Kuantitas & Data Master
//                     PurchLine.Validate("No.", RFQLine."No.");
//                     PurchLine.Validate("Location Code", RFQLine."Location Code");
//                     PurchLine.Validate(Quantity, RFQLine."Qty to PO");

//                     // ====================================================================
//                     // INI DIA KODENYA: Tarik Expected Receipt Date dari Vendor Selection
//                     // ====================================================================
//                     if RFQVendor."Expected Receipt Date" <> 0D then
//                         PurchLine.Validate("Expected Receipt Date", RFQVendor."Expected Receipt Date");
//                     // ====================================================================

//                     PurchLine.Modify(true);

//                     // 6. Update Sisa Kuantitas di RFQ Line (Potong Qty to PO)
//                     RFQLine."Total Qty On PO" += RFQLine."Qty to PO";
//                     RFQLine."Outstanding Quantity" -= RFQLine."Qty to PO";
//                     RFQLine."Qty to PO" := 0;
//                     RFQLine.Modify(true);

//                     LineNo += 10000;
//                 end else begin
//                     Error('Data Vendor Pemenang tidak ditemukan untuk baris RFQ No. %1, Line %2.', RFQLine."RFQ No.", RFQLine."Line No.");
//                 end;
//             until RFQLine.Next() = 0;

//             // 7. Selesaikan Proses
//             Message('Berhasil membuat %1 dokumen Purchase Order dari Vendor Selection %2.', POCount, VenselHeader."Vensel No.");

//         end else begin
//             Error('Tidak ada baris yang siap diproses menjadi PO. Pastikan "Qty to PO" terisi lebih dari 0 dan Pemenang (Winner) sudah dipilih.');
//         end;
//     end;


//     procedure createPOLine_RFQ(ParRFQLine: Record "RFQ Line"; PONo: Code[20]; BatchNo: Integer)
//     var
//         PurchLineIns: Record "Purchase Line";
//     begin
//         PurchLineIns.INIT;
//         PurchLineIns."Document Type" := PurchLineIns."Document Type"::Order;
//         PurchLineIns."Document No." := PONo;
//         PurchLineIns."Line No." := getLastLineNoPO(PONo);
//         PurchLineIns.INSERT(TRUE);
//         case ParRFQLine."Type" OF
//             ParRFQLine."Type"::" ":
//                 begin
//                     PurchLineIns.Validate(Type, PurchLineIns.Type::" ");
//                 end;
//             ParRFQLine."Type"::"G/L Account":
//                 begin
//                     PurchLineIns.Validate(Type, PurchLineIns.Type::"G/L Account");
//                 end;
//             ParRFQLine."Type"::Item:
//                 begin
//                     PurchLineIns.Validate(Type, PurchLineIns.Type::Item);
//                 end;
//             ParRFQLine."Type"::"Charge (Item)":
//                 begin
//                     PurchLineIns.Validate(Type, PurchLineIns.Type::"Charge (Item)");
//                 end;
//         end;
//         PurchLineIns.Validate("No.", ParRFQLine."No.");
//         PurchLineIns.Validate(Quantity, ParRFQLine."Qty to PO");
//         PurchLineIns.VALIDATE("Direct Unit Cost", ParRFQLine."Unit Price");
//         PurchLineIns.VALIDATE("Line Discount %", ParRFQLine."Discount %");
//         IF ParRFQLine."Purchase Req. No." <> '' THEN
//             PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::Item
//         ELSE
//             PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::" ";
//         PurchLineIns.Description := ParRFQLine.Description;
//         PurchLineIns.VALIDATE("Unit of Measure", ParRFQLine."Unit of Measure");
//         PurchLineIns.VALIDATE("VAT Bus. Posting Group", ParRFQLine."VAT Bus. Posting Group");
//         PurchLineIns.VALIDATE("VAT Prod. Posting Group", ParRFQLine."VAT Prod. Posting Group");



//         PurchLineIns.Validate("Part No.", ParRFQLine."Part No.");
//         PurchLineIns.Validate("Purchase Req. No.", ParRFQLine."Purchase Req. No.");
//         PurchLineIns.Validate("Purchase Req. Line No.", ParRFQLine."Purchase Req. Line No.");
//         PurchLineIns.Validate("Material Req. No.", ParRFQLine."Material Req. No.");
//         PurchLineIns.Validate("Material Req. Line No.", ParRFQLine."Material Req. Line No.");
//         PurchLineIns.Validate("RFQ No.", ParRFQLine."RFQ No.");
//         PurchLineIns.Validate("RFQ Line No.", ParRFQLine."Line No.");
//         PurchLineIns.VALIDATE("Shortcut Dimension 3 Code", ParRFQLine."Shortcut Dimension 3 Code");
//         PurchLineIns.ValidateShortcutDimCode(3, ParRFQLine."Shortcut Dimension 3 Code");
//         PurchLineIns.ValidateShortcutDimCode(4, ParRFQLine."Shortcut Dimension 4 Code");
//         PurchLineIns.ValidateShortcutDimCode(5, ParRFQLine."Shortcut Dimension 5 Code");
//         PurchLineIns.ValidateShortcutDimCode(6, ParRFQLine."Shortcut Dimension 6 Code");
//         PurchLineIns.ValidateShortcutDimCode(7, ParRFQLine."Shortcut Dimension 7 Code");
//         PurchLineIns.ValidateShortcutDimCode(8, ParRFQLine."Shortcut Dimension 8 Code");
//         PurchLineIns.VALIDATE("Unit Group", ParRFQLine."Unit Group");
//         PurchLineIns.VALIDATE("MR Usage Category", ParRFQLine."MR Usage Category");
//         PurchLineIns."Batch No. [PR]" := BatchNo;
//         PurchLineIns."PR Type" := PurchLineIns."PR Type"::Material;
//         PurchLineIns."PPH 22" := ParRFQLine."PPH 22";
//         PurchLineIns.PBBKB := ParRFQLine.PBBKB;
//         PurchLineIns.MODIFY(TRUE);
//         updOutstandingQtyRFQ(ParRFQLine, PurchLineIns.RecordID, ParRFQLine."Qty to PO", TRUE)
//     end;




//     //Create PO
//     // procedure SendEMailWithAttachment(EmailAddr: text[1024]; DocNo: code[50])
//     // var
//     //     Email: Codeunit Email;
//     //     EmailMessage: Codeunit "Email Message";
//     //     Cancelled: Boolean;
//     //     MailSent: Boolean;
//     //     Selection: Integer;
//     //     OptionsLbl: Label 'Send,Open Preview';
//     //     ListTo: List of [Text];
//     //     lrecRFQ: Record "RFQ Header";
//     //     TempBlob: Codeunit "Temp Blob";
//     //     InStr: Instream;
//     //     OutStr: OutStream;
//     //     RFQRecRef: RecordRef;
//     // begin
//     //     ListTo.Add(EmailAddr);
//     //     EmailMessage.Create(ListTo, 'This is Request For Quotation', 'This is sample email body', true);
//     //     Cancelled := false;
//     //     TempBlob.CreateOutStream(OutStr);
//     //     lrecRFQ.RESET();
//     //     lrecRFQ.SetFilter("RFQ No.", DocNo);
//     //     if lrecRFQ.FINDSET then begin
//     //         RFQRecRef.GetTable(lrecRFQ);
//     //         // Report.saveas(Report::"RFQ Format", DocNo, ReportFormat::Pdf, OutStr, RFQRecRef);
//     //     end;
//     //     TempBlob.CreateInStream(InStr);
//     //     EmailMessage.Create(EmailAddr, 'Request For Quotation', 'Hi, this is a request for quotation.');
//     //     EmailMessage.AddAttachment('RFQ.pdf', 'PDF', InStr);
//     //     MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
//     // end;

//     // procedure SendEMailWithAttachment(EmailAddr: Text[1024]; DocNo: Code[50]; VendEntryNo: Integer)
//     // var
//     //     Email: Codeunit Email;
//     //     EmailMessage: Codeunit "Email Message";
//     //     TempBlob: Codeunit "Temp Blob";
//     //     InStr: InStream;
//     //     OutStr: OutStream;
//     //     lrecRFQ: Record "RFQ Header";
//     //     RFQRecRef: RecordRef;
//     //     RFQVendor: Record "RFQ Vendor List";
//     //     MailSent: Boolean;
//     // begin
//     //     // Get vendor details untuk nama & filter
//     //     RFQVendor.Reset();
//     //     RFQVendor.SetRange("RFQ No.", DocNo);
//     //     RFQVendor.SetRange("Entry No. RFQ Vendor", VendEntryNo);
//     //     if not RFQVendor.FindFirst() then
//     //         Error('Vendor Entry No. %1 tidak ditemukan untuk RFQ %2.', VendEntryNo, DocNo);

//     //     // Cari RFQ Header
//     //     lrecRFQ.Reset();
//     //     lrecRFQ.SetRange("RFQ No.", DocNo);
//     //     if not lrecRFQ.FindFirst() then
//     //         Error('RFQ No. %1 tidak ditemukan.', DocNo);

//     //     // Generate PDF PER VENDOR (report auto-filter via dataitem link)
//     //     TempBlob.CreateOutStream(OutStr);
//     //     RFQRecRef.GetTable(lrecRFQ);
//     //     Report.SaveAs(Report::RFQ_Printour, '', ReportFormat::Pdf, OutStr, RFQRecRef);

//     //     // Buat email personal
//     //     TempBlob.CreateInStream(InStr);
//     //     EmailMessage.Create(EmailAddr,
//     //         'Request For Quotation - ' + DocNo + ' (' + RFQVendor."Vendor Name" + ')',
//     //         'Bersama ini RFQ untuk Anda terlampir.' +
//     //         '\nMohon konfirmasi penawaran sesuai spesifikasi.' +
//     //         '\n\nTerima kasih.',
//     //         true);
//     //     EmailMessage.AddAttachment('RFQ_' + DocNo + '_' + RFQVendor."Vendor No." + '.pdf', 'application/pdf', InStr);

//     //     // Kirim & validasi
//     //     MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
//     //     if not MailSent then
//     //         Error('Gagal kirim email ke %1.', EmailAddr);
//     //     Message('Email RFQ terkirim ke %1 (%2).', EmailAddr, RFQVendor."Vendor Name");
//     // end;

//     procedure SendEMailWithAttachment(EmailAddr: Text[1024]; DocNo: Code[20]; EntryNoVendor: Integer)
//     var
//         Email: Codeunit Email;
//         EmailMessage: Codeunit "Email Message";
//         TempBlob: Codeunit "Temp Blob";
//         InStr: InStream;
//         OutStr: OutStream;
//         lrecRFQ: Record "RFQ Header";
//         lrecVendor: Record "RFQ Vendor List";
//         RFQReport: Report RFQ_Printour;
//         RFQRecRef: RecordRef;
//         MailSent: Boolean;
//     begin
//         // Validasi RFQ Header
//         if not lrecRFQ.Get(DocNo) then
//             Error('RFQ No. %1 tidak ditemukan.', DocNo);

//         if lrecRFQ.Status <> lrecRFQ.Status::"Send To Vendor" then
//             Error('RFQ harus berstatus Send To Vendor sebelum kirim email.');

//         // Validasi vendor
//         if not lrecVendor.Get(DocNo, EntryNoVendor) then
//             Error('Vendor tidak ditemukan untuk RFQ %1.', DocNo);

//         if EmailAddr = '' then
//             Error('Vendor %1 tidak memiliki email.', lrecVendor."Vendor No.");

//         // Generate PDF khusus untuk vendor ini saja
//         TempBlob.CreateOutStream(OutStr);

//         // Set filter: hanya RFQ ini
//         lrecRFQ.SetRange("RFQ No.", DocNo);

//         // Set filter vendor agar PDF hanya berisi 1 vendor
//         RFQReport.SetVendorFilter(lrecVendor."Vendor No.");
//         RFQReport.SetTableView(lrecRFQ);
//         RFQRecRef.GetTable(lrecRFQ);

//         // FIXED SaveAs: correct order (Text, ReportFormat, var OutStr, RecordRef)
//         RFQReport.SaveAs('', ReportFormat::Pdf, OutStr, RFQRecRef);

//         // Buat email dengan attachment PDF vendor ini
//         TempBlob.CreateInStream(InStr);
//         EmailMessage.Create(
//             EmailAddr,
//             'Request For Quotation - ' + DocNo,
//             'Yth. ' + lrecVendor."Vendor Name" + ',<br><br>' +
//             'Bersama ini kami sampaikan <b>Request For Quotation</b> No. <b>' + DocNo + '</b>.<br>' +
//             'Mohon konfirmasi penawaran harga sesuai dokumen terlampir.<br><br>' +
//             'Terima kasih.',
//             true
//         );
//         EmailMessage.AddAttachment(
//             'RFQ_' + DocNo + '_' + lrecVendor."Vendor No." + '.pdf',
//             'application/pdf',
//             InStr
//         );

//         MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
//         if not MailSent then
//             Error('Email gagal dikirim ke %1.', EmailAddr);

//         Message('Email berhasil dikirim ke %1 untuk vendor %2.',
//                 EmailAddr, lrecVendor."Vendor Name");
//     end;


//     local procedure getLastLineNoRFQ(DocNo: Code[20]): Integer
//     var
//         lrecRFQLine: Record "RFQ Line";
//     begin
//         lrecRFQLine.RESET();
//         lrecRFQLine.SetRange("RFQ No.", DocNo);
//         lrecRFQLine.SETRANGE("Parent Line No.", 0);
//         IF lrecRFQLine.FindLast() then
//             EXIT(lrecRFQLine."Line No." + 10000)
//         ELSE
//             EXIT(10000);
//     end;

//     local procedure getLastLineSplitNoRFQ(DocNo: Code[20]; GroupLineNo: Integer): Integer
//     var
//         lrecRFQLine: Record "RFQ Line";
//     begin
//         lrecRFQLine.RESET();
//         lrecRFQLine.SetRange("RFQ No.", DocNo);
//         lrecRFQLine.SETRANGE("Group Line No.", GroupLineNo);
//         IF lrecRFQLine.FindLast() then
//             EXIT(lrecRFQLine."Line No." + 1)
//         ELSE
//             EXIT(10001);
//     end;

//     local procedure getLastLineNoPO(PONo: Code[20]): Integer
//     var
//         lRecPurchLine: Record "Purchase Line";
//     begin
//         lRecPurchLine.RESET;
//         lRecPurchLine.SETRANGE("Document No.", PONo);
//         IF lRecPurchLine.FINDLAST THEN
//             EXIT(lRecPurchLine."Line No." + 10000)
//         ELSE
//             EXIT(10000);
//     end;

//     var
//         gRecMSISetup: Record "MII Setup";
//         //gCUNoSeriesMgt: Codeunit NoseriesManagement;
//         NoSeries: Codeunit "No. Series";
//         gCUPRFunct: Codeunit "PR Material Function";
// }



codeunit 50193 "RFQ Function"
{
    trigger OnRun()
    begin
    end;

    procedure closedStatus_RFQ(RFQNo: Code[20])
    var
        lRecRFQHeader: Record "RFQ Header";
        lRecRFQLine: Record "RFQ Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        statusInt := 0;
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQNo);
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecRFQLine.Quantity > lRecRFQLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecRFQLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecRFQLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
            IF hasProcess THEN BEGIN
                IF isOutstanding THEN BEGIN
                    statusInt := 2;
                END
                ELSE BEGIN
                    statusInt := 3;
                END;
            END
            ELSE BEGIN
                statusInt := 1;
            END;
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        IF statusInt <> 0 THEN BEGIN
            lRecRFQHeader.RESET;
            lRecRFQHeader.SETRANGE(lRecRFQHeader."RFQ No.", RFQNo);
            IF lRecRFQHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Released);
                    2:
                        lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Processed);
                    3:
                        lRecRFQHeader.VALIDATE(Status, lRecRFQHeader.Status::Closed);
                END;
                lRecRFQHeader.MODIFY;
            END;
        END;
    end;

    procedure closedStatus_RFQfromcreatePO(RFQNo: Code[20]): Integer
    var
        lRecRFQHeader: Record "RFQ Header";
        lRecRFQLine: Record "RFQ Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        statusInt := 0;
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQNo);
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecRFQLine.Quantity > lRecRFQLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecRFQLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecRFQLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
            IF hasProcess THEN BEGIN
                IF isOutstanding THEN BEGIN
                    statusInt := 2;
                END
                ELSE BEGIN
                    statusInt := 3;
                END;
            END
            ELSE BEGIN
                statusInt := 1;
            END;
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        exit(statusInt);
    end;

    //UpdateOutstanding
    procedure updOutstandingQtyRFQ(var ParRFQLine: Record "RFQ Line"; fromRecordID: RecordID; QtytoUpd: Decimal; FromCreatePO: Boolean)
    var
        lRecRFQHeader: Record "RFQ Header";
        lRecRFQLine: Record "RFQ Line";
        lRecPurchLine: Record "Purchase Line";
        lRecPurchInvLine: Record "Purch. Inv. Line";
        lDecTotalPOQty: Decimal;
        lDecOutstandingQty: Decimal;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalPOQty);
        CLEAR(lDecOutstandingQty);
        CASE fromRecordID.TableNo OF
            database::"Purchase Line":
                BEGIN
                    lRecPurchLine.RESET;
                    lRecPurchLine.SETRANGE(lRecPurchLine."RFQ No.", ParRFQLine."RFQ No.");
                    lRecPurchLine.SETRANGE(lRecPurchLine."RFQ Line No.", ParRFQLine."Line No.");
                    IF lRecPurchLine.FIND('-') THEN BEGIN
                        lRecPurchLine.CalcSums(Quantity);
                        lDecTotalPOQty := ABS(lRecPurchLine.Quantity);
                    END;
                    lRecPurchLine.RESET;
                    lRecPurchLine.GET(fromRecordID);
                    lDecTotalPOQty := lDecTotalPOQty - lRecPurchLine.Quantity;
                    // IF (lDecTotalPOQty = 0) OR (QtytoUpd = 0) THEN BEGIN
                    lRecPurchInvLine.RESET;
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."RFQ No.", ParRFQLine."RFQ No.");
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."RFQ Line No.", ParRFQLine."Line No.");
                    IF lRecPurchInvLine.FIND('-') THEN BEGIN
                        lRecPurchInvLine.CalcSums(Quantity);
                        lDecTotalPOQty += ABS(lRecPurchInvLine.Quantity);
                    END;
                    // END;
                END;
        END;
        lDecTotalPOQty := ABS(lDecTotalPOQty);
        lDecOutstandingQty := ParRFQLine.Quantity - lDecTotalPOQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParRFQLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParRFQLine."Outstanding Quantity" := 0;
        END;
        ParRFQLine."Qty to PO" := ParRFQLine."Outstanding Quantity";
        ParRFQLine.MODIFY;
        closedStatus_RFQ(ParRFQLine."RFQ No.");
    end;


    //Check
    procedure checkRFQLinehasWinner(RFQNo: Code[20])
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
        lRecRFQLine.SETRANGE("Vendor No.", '');
        IF lRecRFQLine.FINDFIRST THEN BEGIN
            ERROR('RFQ Line %1 still not have vendor winner, cannot proceed', lRecRFQLine."Line No.")
        END;
    end;

    // Tambahkan di dalam codeunit 80103 "RFQ Function"
    // Letakkan berdekatan dengan procedure check lainnya

    procedure checkVendorListNotEmpty(RFQNo: Code[20])
    var
        lRecRFQVendor: Record "RFQ Vendor List";
    begin
        lRecRFQVendor.RESET();
        lRecRFQVendor.SETRANGE("RFQ No.", RFQNo);
        IF NOT lRecRFQVendor.FINDFIRST() THEN
            ERROR('RFQ belum memiliki Vendor. Tambahkan Vendor terlebih dahulu sebelum Release.');
    end;

    procedure checkRFQLineNotEmpty(RFQNo: Code[20])
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET();
        lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
        IF NOT lRecRFQLine.FINDFIRST() THEN
            ERROR('RFQ tidak memiliki Line Item. Tambahkan item terlebih dahulu.');
    end;

    procedure checkRFQLinehasPO(RFQNo: Code[20]; RFQLineNo: Integer; msgErr: Text)
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.CalcFields("Total Qty on PO");
        lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
        IF RFQLineNo <> 0 THEN lRecRFQLine.SETRANGE("Line No.", RFQLineNo);
        lRecRFQLine.SETFILTER("Total Qty on PO", '>%1', 0);
        IF lRecRFQLine.FINDFIRST THEN BEGIN
            ERROR('RFQ Line %1 already has Purchase Order, cannot %2', lRecRFQLine."Line No.", msgErr)
        END;
        lRecRFQLine.RESET;
        lRecRFQLine.CalcFields("Total Qty on Posted Order");
        lRecRFQLine.SETRANGE("RFQ No.", RFQNo);
        IF RFQLineNo <> 0 THEN lRecRFQLine.SETRANGE("Line No.", RFQLineNo);
        lRecRFQLine.SETFILTER("Total Qty on Posted Order", '>%1', 0);
        IF lRecRFQLine.FINDFIRST THEN BEGIN
            ERROR('RFQ Line %1 already has Posted Purchase Order, cannot %2', lRecRFQLine."Line No.", msgErr)
        END;
    end;

    // procedure insertRFQLineDetailsfromRFQLine(var RFQLine: Record "RFQ Line")
    // var
    //     lRecRFQVendor: Record "RFQ Vendor List";
    //     WinEntryRFQVendor: Integer;
    // begin
    //     CLEAR(WinEntryRFQVendor);
    //     lRecRFQVendor.RESET;
    //     lRecRFQVendor.SETRANGE(lRecRFQVendor."RFQ No.", RFQLine."RFQ No.");
    //     IF lRecRFQVendor.FIND('-') THEN BEGIN
    //         REPEAT
    //             insertRFQLineDetails(RFQLine, lRecRFQVendor);
    //             IF lRecRFQVendor."Check Win" THEN WinEntryRFQVendor := lRecRFQVendor."Entry No. RFQ Vendor";
    //         UNTIL lRecRFQVendor.NEXT = 0;
    //     END;
    //     IF WinEntryRFQVendor <> 0 THEN BEGIN
    //         updWinRFQLine(RFQLine, WinEntryRFQVendor, TRUE);
    //     END;
    // end;

    procedure insertRFQLineDetailsfromRFQLine(var RFQLine: Record "RFQ Line")
    var
        lRecRFQVendor: Record "RFQ Vendor List";
        WinEntryRFQVendor: Integer;
    begin
        CLEAR(WinEntryRFQVendor);
        lRecRFQVendor.RESET;
        lRecRFQVendor.SETRANGE("RFQ No.", RFQLine."RFQ No.");

        IF lRecRFQVendor.FINDSET() THEN BEGIN
            REPEAT
                insertRFQLineDetails(RFQLine, lRecRFQVendor);
                IF lRecRFQVendor."Check Win" THEN
                    WinEntryRFQVendor := lRecRFQVendor."Entry No. RFQ Vendor";
            UNTIL lRecRFQVendor.NEXT() = 0;
        END;

        IF WinEntryRFQVendor <> 0 THEN BEGIN
            updWinRFQLine(RFQLine, WinEntryRFQVendor, TRUE);
        END;
    end;

    procedure insertRFQLineDetailsfromRFQVendor(var RFQVendor: Record "RFQ Vendor List")
    var
        lRecRFQLine: Record "RFQ Line";
        currNo: Code[20];
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", RFQVendor."RFQ No.");
        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                IF currNo <> lRecRFQLine."No." THEN insertRFQLineDetails(lRecRFQLine, RFQVendor);
                currNo := lRecRFQLine."No.";
            UNTIL lRecRFQLine.NEXT = 0;
        END
    end;

    procedure reinsertRFQLineDetails(var parRFQHeader: Record "RFQ Header")
    var
        lRecRFQLine: Record "RFQ Line";
        lRecRFQVendor: Record "RFQ Vendor List";
        currNo: Code[20];
    begin
        lRecRFQVendor.RESET;
        lRecRFQVendor.SETRANGE("RFQ No.", parRFQHeader."RFQ No.");
        IF lRecRFQVendor.FIND('-') THEN BEGIN
            REPEAT
                lRecRFQLine.RESET;
                lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", lRecRFQVendor."RFQ No.");
                IF lRecRFQLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF currNo <> lRecRFQLine."No." THEN insertRFQLineDetails(lRecRFQLine, lRecRFQVendor);
                        currNo := lRecRFQLine."No.";
                    UNTIL lRecRFQLine.NEXT = 0;
                END UNTIL lRecRFQVendor.NEXT = 0;
        END;
    end;

    // procedure insertRFQLineDetails(var RFQLine: Record "RFQ Line"; var RFQVendor: Record "RFQ Vendor List")
    // var
    //     lRecRFQLineDetails: Record "RFQ Line Details";
    //     lRecRFQLineDetailsIns: Record "RFQ Line Details";
    // begin
    //     lRecRFQLineDetails.RESET;
    //     lRecRFQLineDetails.SETRANGE("RFQ No.", RFQLine."RFQ No.");
    //     lRecRFQLineDetails.SETRANGE("No.", RFQLine."No.");
    //     lRecRFQLineDetails.SETRANGE("Entry No. RFQ Vendor", RFQVendor."Entry No. RFQ Vendor");
    //     IF NOT lRecRFQLineDetails.FINDFIRST THEN BEGIN
    //         lRecRFQLineDetailsIns.INIT();
    //         lRecRFQLineDetailsIns."Entry No." := 0;
    //         lRecRFQLineDetailsIns."RFQ No." := RFQLine."RFQ No.";
    //         lRecRFQLineDetailsIns."RFQ Line No." := RFQLine."Line No.";
    //         lRecRFQLineDetailsIns.VALIDATE("Vendor No.", RFQVendor."Vendor No.");
    //         lRecRFQLineDetailsIns.Type := RFQLine.Type;
    //         lRecRFQLineDetailsIns.VALIDATE("No.", RFQLine."No.");
    //         lRecRFQLineDetailsIns.VALIDATE(Quantity, 1);
    //         lRecRFQLineDetailsIns."Purchase Req. No." := RFQLine."Purchase Req. No.";
    //         lRecRFQLineDetailsIns."Purchase Req. Line No." := RFQLine."Purchase Req. Line No.";
    //         lRecRFQLineDetailsIns."Material Req. No." := RFQLine."Material Req. No.";
    //         lRecRFQLineDetailsIns."Material Req. Line No." := RFQLine."Material Req. Line No.";
    //         // lRecRFQLineDetailsIns."Entry No. RFQ Line" := RFQLine."Entry No. RFQ Line";
    //         lRecRFQLineDetailsIns."Entry No. RFQ Vendor" := RFQVendor."Entry No. RFQ Vendor";
    //         lRecRFQLineDetailsIns.INSERT();
    //     END;
    // end;

    procedure insertRFQLineDetails(var RFQLine: Record "RFQ Line"; var RFQVendor: Record "RFQ Vendor List")
    var
        lRecRFQLineDetails: Record "RFQ Line Details";
        lRecRFQLineDetailsIns: Record "RFQ Line Details";
    begin
        lRecRFQLineDetails.RESET;
        lRecRFQLineDetails.SETRANGE("RFQ No.", RFQLine."RFQ No.");
        lRecRFQLineDetails.SETRANGE("RFQ Line No.", RFQLine."Line No.");
        lRecRFQLineDetails.SETRANGE("Entry No. RFQ Vendor", RFQVendor."Entry No. RFQ Vendor");

        IF NOT lRecRFQLineDetails.FINDFIRST() THEN BEGIN
            lRecRFQLineDetailsIns.INIT();
            lRecRFQLineDetailsIns."Entry No." := 0;
            lRecRFQLineDetailsIns."RFQ No." := RFQLine."RFQ No.";
            lRecRFQLineDetailsIns."RFQ Line No." := RFQLine."Line No.";

            lRecRFQLineDetailsIns.VALIDATE("Vendor No.", RFQVendor."Vendor No.");

            lRecRFQLineDetailsIns.INSERT(true);

            lRecRFQLineDetailsIns.Type := RFQLine.Type;
            lRecRFQLineDetailsIns.VALIDATE("No.", RFQLine."No.");
            lRecRFQLineDetailsIns.VALIDATE(Quantity, 1);

            lRecRFQLineDetailsIns."Purchase Req. No." := RFQLine."Purchase Req. No.";
            lRecRFQLineDetailsIns."Purchase Req. Line No." := RFQLine."Purchase Req. Line No.";
            lRecRFQLineDetailsIns."Material Req. No." := RFQLine."Material Req. No.";
            lRecRFQLineDetailsIns."Material Req. Line No." := RFQLine."Material Req. Line No.";
            lRecRFQLineDetailsIns."Entry No. RFQ Vendor" := RFQVendor."Entry No. RFQ Vendor";

            lRecRFQLineDetailsIns.MODIFY(true);
        END;
    end;

    procedure deleteRFQLineDetails(FromRecordID: RecordId)
    var
        lRecRFQLine: Record "RFQ Line";
        lRecRFQLineOth: Record "RFQ Line";
        lRecRFQVendor: Record "RFQ Vendor List";
        lRecRFQLineDetails: Record "RFQ Line Details";
    begin
        CASE FromRecordID.TableNo OF
            database::"RFQ Line":
                BEGIN
                    lRecRFQLine.RESET;
                    lRecRFQLine.GET(FromRecordID);
                    lRecRFQLineOth.RESET;
                    lRecRFQLineOth.SETRANGE(lRecRFQLineOth."RFQ No.", lRecRFQLine."RFQ No.");
                    lRecRFQLineOth.SETRANGE(lRecRFQLineOth."No.", lRecRFQLine."No.");
                    lRecRFQLineOth.SETFILTER(lRecRFQLineOth."Line No.", '<>%1', lRecRFQLine."Line No.");
                    IF NOT lRecRFQLineOth.FINDFIRST THEN BEGIN
                        lRecRFQLineDetails.RESET;
                        lRecRFQLineDetails.SETRANGE("RFQ No.", lRecRFQLine."RFQ No.");
                        lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
                        IF lRecRFQLineDetails.FIND('-') THEN lRecRFQLineDetails.DELETEALL(TRUE);
                    END;
                END;
            database::"RFQ Vendor List":
                BEGIN
                    lRecRFQVendor.RESET;
                    lRecRFQVendor.GET(FromRecordID);
                    // reopenStatusLineDetailsfromVendorList(lRecRFQVendor);
                    lRecRFQLineDetails.RESET;
                    lRecRFQLineDetails.SETRANGE("RFQ No.", lRecRFQVendor."RFQ No.");
                    lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", lRecRFQVendor."Entry No. RFQ Vendor");
                    IF lRecRFQLineDetails.FIND('-') THEN lRecRFQLineDetails.DELETEALL(TRUE);
                END;
        END;
    end;

    procedure reopenStatusLineDetailsfromVendorList(var parVendorList: Record "RFQ Vendor List")
    var
        lRecRFQLineDet: Record "RFQ Line Details";
        lRecRFQLineDetUpd: Record "RFQ Line Details";
    begin
        lRecRFQLineDet.RESET;
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."RFQ No.", parVendorList."RFQ No.");
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Entry No. RFQ Vendor", parVendorList."Entry No. RFQ Vendor");
        lRecRFQLineDet.SETRANGE(lRecRFQLineDet."Check Win", TRUE);
        IF lRecRFQLineDet.FIND('-') THEN BEGIN
            lRecRFQLineDetUpd.RESET;
            lRecRFQLineDetUpd.SETRANGE(lRecRFQLineDetUpd."RFQ No.", lRecRFQLineDet."RFQ No.");
            lRecRFQLineDetUpd.SETRANGE(lRecRFQLineDetUpd."Entry No. RFQ Line", lRecRFQLineDet."Entry No. RFQ Line");
            IF lRecRFQLineDetUpd.FIND('-') THEN BEGIN
                lRecRFQLineDetUpd.MODIFYALL("Check Win", FALSE, TRUE);
            END;
        END;
    end;

    procedure resetRFQLineWinner(var parRFQLineDetails: Record "RFQ Line Details")
    var
        lRecRFQLine: Record "RFQ Line";
    begin
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLineDetails."RFQ No.");
        lRecRFQLine.SETRANGE(lRecRFQLine."Winner RFQ Line Details", parRFQLineDetails."Entry No.");
        IF lRecRFQLine.FINDFIRST THEN BEGIN
            lRecRFQLine.Validate("Winner RFQ Line Details", 0);
            lRecRFQLine.Modify();
        END;
    end;

    procedure createRFQHeader_PR(var ParPRHeader: Record "PR Material Header")
    var
        lRecPRLine: Record "PR Material Line";
        lRecRFQHeader: Record "RFQ Header";
        lRecNoSeries: Record "No. Series";
    begin
        gRecMSISetup.GET;
        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParPRHeader."No. Series");
        lRecNoSeries.TESTFIELD("RFQ Nos.");
        IF gCUPRFunct.checkPRLinehasOutstanding(ParPRHeader."Purchase Req. No.") THEN BEGIN
            lRecRFQHeader.INIT;
            //lRecRFQHeader."RFQ No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."RFQ Nos.", WorkDate(), true);
            lRecRFQHeader."RFQ No." := NoSeries.GetNextNo(lRecNoSeries."RFQ Nos.", WorkDate(), true);
            lRecRFQHeader.INSERT(TRUE);
            lRecRFQHeader.VALIDATE("No. Series", lRecNoSeries."RFQ Nos.");
            lRecRFQHeader.VALIDATE("Document Date", WORKDATE);
            lRecRFQHeader.VALIDATE("Location Code", ParPRHeader."Location Code");
            lRecRFQHeader."External Document No." := ParPRHeader."Purchase Req. No.";
            lRecRFQHeader.VALIDATE("Shortcut Dimension 1 Code", ParPRHeader."Shortcut Dimension 1 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 2 Code", ParPRHeader."Shortcut Dimension 2 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 3 Code", ParPRHeader."Shortcut Dimension 3 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 4 Code", ParPRHeader."Shortcut Dimension 4 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 5 Code", ParPRHeader."Shortcut Dimension 5 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 6 Code", ParPRHeader."Shortcut Dimension 6 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 7 Code", ParPRHeader."Shortcut Dimension 7 Code");
            lRecRFQHeader.VALIDATE("Shortcut Dimension 8 Code", ParPRHeader."Shortcut Dimension 8 Code");
            lRecRFQHeader."Material Req. No." := ParPRHeader."Material Req. No.";
            lRecRFQHeader."Purchase Request No." := ParPRHeader."Purchase Req. No.";
            lRecRFQHeader.MODIFY(TRUE);
            lRecPRLine.RESET;
            lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", ParPRHeader."Purchase Req. No.");
            lRecPRLine.SETFILTER(lRecPRLine."Outstanding Quantity", '>%1', 0);
            IF lRecPRLine.FIND('-') THEN BEGIN
                REPEAT
                    createRFQLine_PR(lRecPRLine, lRecRFQHeader."RFQ No.");
                UNTIL lRecPRLine.NEXT = 0;
            END;
            COMMIT;
            Page.RUN(Page::"RFQ Card", lRecRFQHeader);
        END;
    end;

    // procedure CreateRFQLine_PR(ParPRLine: Record "PR Material Line"; DocNo: Code[20])
    // var
    //     lrecRFQLine: Record "RFQ Line";
    // begin
    //     lrecRFQLine.Init();
    //     lrecRFQLine."RFQ No." := DocNo;
    //     lrecRFQLine."Line No." := getLastLineNoRFQ(DocNo);
    //     lrecRFQLine.INSERT(TRUE);
    //     lrecRFQLine.Type := lrecRFQLine.Type::Item;
    //     lrecRFQLine.Validate("Group Line No.", lrecRFQLine."Line No.");
    //     lrecRFQLine.Validate("No.", ParPRLine."Item No.");
    //     lrecRFQLine.Validate("Description", ParPRLine."Description");
    //     lrecRFQLine.Validate(Quantity, ParPRLine."Outstanding Quantity");
    //     lrecRFQLine.Validate("Original Qty PR", ParPRLine."Outstanding Quantity");
    //     lrecRFQLine.Validate("Outstanding Quantity", ParPRLine."Outstanding Quantity");
    //     lrecRFQLine.Validate("Location Code", ParPRLine."Location Code");
    //     lrecRFQLine.Validate("Unit of Measure", ParPRLine."Unit of Measure");
    //     lrecRFQLine.Validate("Part No.", ParPRLine."Part No.");
    //     lrecRFQLine.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
    //     lrecRFQLine.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
    //     lrecRFQLine.Validate("Material Req. No.", ParPRLine."Material Req. No.");
    //     lrecRFQLine.Validate("Material Req. Line No.", ParPRLine."Material Req. Line No.");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 1 Code", ParPRLine."Shortcut Dimension 1 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 2 Code", ParPRLine."Shortcut Dimension 2 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 4 Code", ParPRLine."Shortcut Dimension 4 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 5 Code", ParPRLine."Shortcut Dimension 5 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 6 Code", ParPRLine."Shortcut Dimension 6 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 7 Code", ParPRLine."Shortcut Dimension 7 Code");
    //     lrecRFQLine.VALIDATE("Shortcut Dimension 8 Code", ParPRLine."Shortcut Dimension 8 Code");
    //     lrecRFQLine.VALIDATE(Remarks, ParPRLine.Remarks);
    //     lrecRFQLine."from PR" := TRUE;
    //     lrecRFQLine.MODIFY(TRUE);
    //     insertRFQLineDetailsfromRFQLine(lrecRFQLine);
    //     gCUPRFunct.updOutstandingQtyPR(ParPRLine, lrecRFQLine.RecordID, ParPRLine."Outstanding Quantity");
    // end;
    procedure CreateRFQLine_PR(ParPRLine: Record "PR Material Line"; DocNo: Code[20])
    var
        lrecRFQLine: Record "RFQ Line";
        PRHeader: Record "PR Material Header";
        RFQVendor: Record "RFQ Vendor List";
        Vendor: Record Vendor;
    begin
        lrecRFQLine.Init();
        lrecRFQLine."RFQ No." := DocNo;
        lrecRFQLine."Line No." := getLastLineNoRFQ(DocNo);
        lrecRFQLine.INSERT(TRUE);

        lrecRFQLine.Type := lrecRFQLine.Type::Item;
        lrecRFQLine.Validate("Group Line No.", lrecRFQLine."Line No.");
        lrecRFQLine.Validate("No.", ParPRLine."Item No.");
        lrecRFQLine.Validate("Description", ParPRLine."Description");
        lrecRFQLine.Validate(Quantity, ParPRLine."Outstanding Quantity");
        lrecRFQLine.Validate("Original Qty PR", ParPRLine."Outstanding Quantity");
        lrecRFQLine.Validate("Outstanding Quantity", ParPRLine."Outstanding Quantity");
        lrecRFQLine.Validate("Location Code", ParPRLine."Location Code");
        lrecRFQLine.Validate("Unit of Measure", ParPRLine."Unit of Measure");
        lrecRFQLine.Validate("Part No.", ParPRLine."Part No.");
        lrecRFQLine.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
        lrecRFQLine.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
        lrecRFQLine.Validate("Material Req. No.", ParPRLine."Material Req. No.");
        lrecRFQLine.Validate("Material Req. Line No.", ParPRLine."Material Req. Line No.");
        lrecRFQLine.VALIDATE("Shortcut Dimension 1 Code", ParPRLine."Shortcut Dimension 1 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 2 Code", ParPRLine."Shortcut Dimension 2 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 4 Code", ParPRLine."Shortcut Dimension 4 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 5 Code", ParPRLine."Shortcut Dimension 5 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 6 Code", ParPRLine."Shortcut Dimension 6 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 7 Code", ParPRLine."Shortcut Dimension 7 Code");
        lrecRFQLine.VALIDATE("Shortcut Dimension 8 Code", ParPRLine."Shortcut Dimension 8 Code");
        lrecRFQLine.VALIDATE(Remarks, ParPRLine.Remarks);
        lrecRFQLine."from PR" := TRUE;
        lrecRFQLine.MODIFY(TRUE);

        insertRFQLineDetailsfromRFQLine(lrecRFQLine);
        gCUPRFunct.updOutstandingQtyPR(ParPRLine, lrecRFQLine.RecordID, ParPRLine."Outstanding Quantity");


        // if PRHeader.Get(ParPRLine."Purchase Req. No.") then
        //     if (PRHeader."Vendor No" <> '') and not RFQVendor.Get(DocNo, PRHeader."Vendor No") then begin
        //         RFQVendor.Init();
        //         RFQVendor."RFQ No." := DocNo;
        //         RFQVendor."Vendor No." := PRHeader."Vendor No";
        //         if Vendor.Get(PRHeader."Vendor No") then
        //             RFQVendor."Vendor Name" := Vendor.Name;
        //         RFQVendor.Insert(true);
        //     end;

        if PRHeader.Get(ParPRLine."Purchase Req. No.") then
            if (PRHeader."Vendor No" <> '') then begin

                // Gunakan SetRange karena Vendor No. bukan Primary Key ke-2
                RFQVendor.Reset();
                RFQVendor.SetRange("RFQ No.", DocNo);
                RFQVendor.SetRange("Vendor No.", PRHeader."Vendor No");

                if not RFQVendor.FindFirst() then begin
                    RFQVendor.Init();
                    RFQVendor."RFQ No." := DocNo;
                    RFQVendor."Vendor No." := PRHeader."Vendor No";
                    if Vendor.Get(PRHeader."Vendor No") then
                        RFQVendor."Vendor Name" := Vendor.Name;

                    // Asumsi: Entry No. RFQ Vendor diset AutoIncrement di tabelnya
                    RFQVendor.Insert(true);
                end;
            end;

    end;


    procedure splitRFQLine(var parRFQLine: Record "RFQ Line");
    var
        lRecRFQLine: Record "RFQ Line";
        lRecRFQLineIns: Record "RFQ Line";
        lDecQty: Decimal;
    begin
        CLEAR(lDecQty);
        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
        lRecRFQLine.SETRANGE(lRecRFQLine."Group Line No.", parRFQLine."Group Line No.");
        IF lRecRFQLine.FIND('-') THEN BEGIN
            lRecRFQLine.CalcSums(Quantity);
            IF lRecRFQLine.Quantity >= parRFQLine."Original Qty PR" THEN ERROR('You cannot split this line because qty already maxed out', parRFQLine."Original Qty PR");
            lDecQty := parRFQLine."Original Qty PR" - lRecRFQLine.Quantity;
        END;
        lRecRFQLineIns.INIT();
        lRecRFQLineIns.TransferFields(parRFQLine);
        lRecRFQLineIns."Entry No. RFQ Line" := 0;
        lRecRFQLineIns."Line No." := getLastLineSplitNoRFQ(parRFQLine."RFQ No.", parRFQLine."Group Line No.");
        lRecRFQLineIns.INSERT(TRUE);
        lRecRFQLineIns.VALIDATE(Quantity, lDecQty);
        lRecRFQLineIns.VALIDATE("Original Qty PR", parRFQLine."Original Qty PR");
        lRecRFQLineIns."Parent Line No." := parRFQLine."Line No.";
        lRecRFQLineIns."Shortcut Dimension 1 Code" := parRFQLine."Shortcut Dimension 1 Code";
        lRecRFQLineIns."Shortcut Dimension 2 Code" := parRFQLine."Shortcut Dimension 2 Code";
        lRecRFQLineIns."Shortcut Dimension 3 Code" := parRFQLine."Shortcut Dimension 3 Code";
        lRecRFQLineIns."Shortcut Dimension 4 Code" := parRFQLine."Shortcut Dimension 4 Code";
        lRecRFQLineIns."Shortcut Dimension 5 Code" := parRFQLine."Shortcut Dimension 5 Code";
        lRecRFQLineIns."Shortcut Dimension 6 Code" := parRFQLine."Shortcut Dimension 6 Code";
        lRecRFQLineIns."Shortcut Dimension 7 Code" := parRFQLine."Shortcut Dimension 7 Code";
        lRecRFQLineIns."Shortcut Dimension 8 Code" := parRFQLine."Shortcut Dimension 8 Code";
        lRecRFQLineIns."Location Code" := parRFQLine."Location Code";
        lRecRFQLineIns."MR Usage Category" := parRFQLine."MR Usage Category";
        lRecRFQLineIns."Unit Group" := parRFQLine."Unit Group";
        lRecRFQLineIns.MODIFY(TRUE);
    end;

    procedure updWinAllRFQLine(var parRFQVendor: Record "RFQ Vendor List"; isChecked: Boolean)
    var
        lRecRFQLine: Record "RFQ Line";
        lRecRFQLineDetails: Record "RFQ Line Details";
    begin
        iF isChecked THEN BEGIN
            lRecRFQLine.RESET;
            lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQVendor."RFQ No.");
            IF lRecRFQLine.FIND('-') THEN BEGIN
                REPEAT
                    lRecRFQLineDetails.RESET;
                    lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."RFQ No.", lRecRFQLine."RFQ No.");
                    lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
                    lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", parRFQVendor."Entry No. RFQ Vendor");
                    IF lRecRFQLineDetails.FINDFIRST THEN BEGIN
                        lRecRFQLine.VALIDATE("Winner RFQ Line Details", lRecRFQLineDetails."Entry No.");
                        lRecRFQLine.MODIFY(TRUE);
                    END;
                UNTIL lRecRFQLine.NEXT = 0;
            END;
        END
        ELSE BEGIN
            lRecRFQLine.RESET;
            lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQVendor."RFQ No.");
            IF lRecRFQLine.FIND('-') THEN BEGIN
                REPEAT
                    lRecRFQLine.VALIDATE("Winner RFQ Line Details", 0);
                    lRecRFQLine.MODIFY(TRUE);
                UNTIL lRecRFQLine.NEXT = 0;
            END;
        END;
    end;

    procedure updWinRFQLine(var parRFQLine: Record "RFQ Line"; var parEntryNoRFQVendor: Integer; isChecked: Boolean)
    var
        lRecRFQLine: Record "RFQ Line";
        lRecRFQLineDetails: Record "RFQ Line Details";
    begin
        iF isChecked THEN BEGIN
            lRecRFQLine.RESET;
            lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
            lRecRFQLine.SETRANGE(lRecRFQLine."Line No.", parRFQLine."Line No.");
            IF lRecRFQLine.FIND('-') THEN BEGIN
                lRecRFQLineDetails.RESET;
                lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."RFQ No.", lRecRFQLine."RFQ No.");
                lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."No.", lRecRFQLine."No.");
                lRecRFQLineDetails.SETRANGE(lRecRFQLineDetails."Entry No. RFQ Vendor", parEntryNoRFQVendor);
                IF lRecRFQLineDetails.FINDFIRST THEN BEGIN
                    lRecRFQLine.VALIDATE("Winner RFQ Line Details", lRecRFQLineDetails."Entry No.");
                    lRecRFQLine.MODIFY(TRUE);
                END;
            END;
        END
        ELSE BEGIN
            lRecRFQLine.RESET;
            lRecRFQLine.SETRANGE(lRecRFQLine."RFQ No.", parRFQLine."RFQ No.");
            lRecRFQLine.SETRANGE(lRecRFQLine."Line No.", parRFQLine."Line No.");
            IF lRecRFQLine.FIND('-') THEN BEGIN
                REPEAT
                    lRecRFQLine.VALIDATE("Winner RFQ Line Details", 0);
                    lRecRFQLine.MODIFY(TRUE);
                UNTIL lRecRFQLine.NEXT = 0;
            END;
        END;
    end;
    //Create PO
    // procedure createPOHeader_RFQ(var ParRFQHeader: Record "RFQ Header")
    // var
    //     PurchHeaderIns: Record "Purchase Header";
    //     PurchLineView: Record "Purchase Line";
    //     lRecRFQLine: Record "RFQ Line";
    //     lRecRFQVendor: Record "RFQ Vendor List";
    //     lRecVendor: Record Vendor;
    //     lRecNoSeries: Record "No. Series";
    //     CurrVendorNo: Code[20];
    //     BatchNo: Integer;
    //     StatusInt: Integer;
    //     currPRNo: Code[20];
    //     currPRNoAdditionalLine: Code[20];
    //     YourReference: Text[35];
    //     OutstandingQty: Decimal;
    //     FACount: Integer;
    //     isPPH22: Boolean;
    //     isPBBKB: Boolean;
    //     WHTBusVendor: Code[20];
    // begin
    //     CLEAR(StatusInt);
    //     CLEAR(WHTBusVendor);
    //     CLEAR(currPRNoAdditionalLine);
    //     gRecMSISetup.GET();

    //     lRecNoSeries.RESET;
    //     lRecNoSeries.GET(ParRFQHeader."No. Series");
    //     lRecNoSeries.TESTFIELD("Purchase Order Nos.");
    //     BatchNo := ParRFQHeader."Batch No. [PR]" + 1;
    //     lRecRFQLine.RESET;
    //     lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
    //     lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
    //     lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
    //     lRecRFQLine.SetCurrentKey("Vendor No.");
    //     lRecRFQLine.Ascending(TRUE);
    //     IF lRecRFQLine.FIND('-') THEN BEGIN
    //         REPEAT
    //             lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

    //             CLEAR(OutstandingQty);
    //             IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
    //                 lRecVendor.RESET;
    //                 lRecVendor.GET(lRecRFQLine."Vendor No.");
    //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
    //                 lRecRFQVendor.RESET;
    //                 lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");
    //                 PurchHeaderIns.INIT;
    //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
    //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
    //                 //PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
    //                 PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
    //                 PurchHeaderIns.INSERT(TRUE);
    //                 PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
    //                 PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
    //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
    //                 PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
    //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
    //                 PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
    //                 PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");
    //                 PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
    //                 PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
    //                 PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
    //                 PurchHeaderIns.MODIFY(TRUE);
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END
    //             ELSE BEGIN
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END;
    //             CurrVendorNo := lRecRFQLine."Vendor No.";
    //         UNTIL lRecRFQLine.NEXT = 0;
    //     END
    //     ELSE BEGIN
    //         ERROR('No RFQ Line to be found for create PO');
    //     END;


    //     ParRFQHeader.MODIFY;
    //     COMMIT;
    //     PurchLineView.RESET;
    //     PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
    //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
    //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
    //     ParRFQHeader."Batch No. [PR]" := BatchNo;
    //     StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
    //     IF statusInt <> 0 THEN BEGIN
    //         Case StatusInt OF
    //             1:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
    //             2:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
    //             3:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
    //         END;
    //     END;
    //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    // end;

    procedure createPOHeader_RFQ(var ParRFQHeader: Record "RFQ Header")
    var
        PurchHeaderIns: Record "Purchase Header";
        PurchLineView: Record "Purchase Line";
        lRecRFQLine: Record "RFQ Line";
        lRecRFQVendor: Record "RFQ Vendor List";
        lRecVendor: Record Vendor;
        lRecNoSeries: Record "No. Series";
        lRecRFQLineDet: Record "RFQ Line Details"; // <--- TAMBAHAN 1: Deklarasi variabel baru
        CurrVendorNo: Code[20];
        BatchNo: Integer;
        StatusInt: Integer;
        currPRNo: Code[20];
        currPRNoAdditionalLine: Code[20];
        YourReference: Text[35];
        OutstandingQty: Decimal;
        FACount: Integer;
        isPPH22: Boolean;
        isPBBKB: Boolean;
        WHTBusVendor: Code[20];
    begin
        CLEAR(StatusInt);
        CLEAR(WHTBusVendor);
        CLEAR(currPRNoAdditionalLine);
        gRecMSISetup.GET();

        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParRFQHeader."No. Series");
        lRecNoSeries.TESTFIELD("Purchase Order Nos.");
        BatchNo := ParRFQHeader."Batch No. [PR]" + 1;

        lRecRFQLine.RESET;
        lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
        lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
        lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
        lRecRFQLine.SetCurrentKey("Vendor No.");
        lRecRFQLine.Ascending(TRUE);

        IF lRecRFQLine.FIND('-') THEN BEGIN
            REPEAT
                lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

                CLEAR(OutstandingQty);
                IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
                    lRecVendor.RESET;
                    lRecVendor.GET(lRecRFQLine."Vendor No.");
                    lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");

                    lRecRFQVendor.RESET;
                    lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");

                    PurchHeaderIns.INIT;
                    PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
                    PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
                    PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
                    PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
                    PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
                    PurchHeaderIns.INSERT(TRUE);
                    PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
                    PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
                    PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
                    PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
                    PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");

                    // =======================================================================
                    // --- TAMBAHAN 2: SUNTIKAN MAUT EXPECTED DATE KE PO HEADER ---
                    // =======================================================================
                    lRecRFQLineDet.RESET();
                    lRecRFQLineDet.SETRANGE("RFQ No.", lRecRFQLine."RFQ No.");
                    lRecRFQLineDet.SETRANGE("Entry No.", lRecRFQLine."Winner RFQ Line Details");
                    IF lRecRFQLineDet.FINDFIRST() THEN BEGIN
                        IF lRecRFQLineDet."Expected Receipt Date" <> 0D THEN
                            PurchHeaderIns.VALIDATE("Expected Receipt Date", lRecRFQLineDet."Expected Receipt Date");
                    END;
                    // =======================================================================

                    PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
                    PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
                    PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
                    PurchHeaderIns.MODIFY(TRUE);

                    createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
                END
                ELSE BEGIN
                    createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
                END;
                CurrVendorNo := lRecRFQLine."Vendor No.";
            UNTIL lRecRFQLine.NEXT = 0;
        END
        ELSE BEGIN
            ERROR('No RFQ Line to be found for create PO');
        END;

        // Selama loop di atas, RFQ Header sudah ikut berubah di database
        // (lewat trigger/subscriber saat PO Line dibuat), sehingga salinan milik
        // page menjadi basi -> MODIFY gagal dengan pesan
        // "some information on the page is not up-to-date".
        // GET ulang untuk menyegarkan record (termasuk timestamp) sebelum MODIFY.
        IF ParRFQHeader.GET(ParRFQHeader."RFQ No.") THEN;
        ParRFQHeader.MODIFY;
        COMMIT;

        PurchLineView.RESET;
        PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
        PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
        PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
        ParRFQHeader."Batch No. [PR]" := BatchNo;

        StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
        IF statusInt <> 0 THEN BEGIN
            Case StatusInt OF
                1:
                    ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
                2:
                    ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
                3:
                    ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
            END;
        END;
        // Perubahan "Batch No. [PR]" dan Status di atas sebelumnya tidak pernah
        // disimpan karena tidak ada MODIFY setelahnya.
        ParRFQHeader.MODIFY;
        IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    end;


    //Create PO-Vensel
    // procedure createPOHeader_RFQ2(var ParRFQHeader: Record "Vensel Header")
    // var
    //     PurchHeaderIns: Record "Purchase Header";
    //     PurchLineView: Record "Purchase Line";
    //     lRecRFQLine: Record "RFQ Line";
    //     lRecRFQVendor: Record "RFQ Vendor List";
    //     lRecVendor: Record Vendor;
    //     lRecNoSeries: Record "No. Series";
    //     CurrVendorNo: Code[20];
    //     BatchNo: Integer;
    //     StatusInt: Integer;
    //     currPRNo: Code[20];
    //     currPRNoAdditionalLine: Code[20];
    //     YourReference: Text[35];
    //     OutstandingQty: Decimal;
    //     FACount: Integer;
    //     isPPH22: Boolean;
    //     isPBBKB: Boolean;
    //     WHTBusVendor: Code[20];
    // begin
    //     CLEAR(StatusInt);
    //     CLEAR(WHTBusVendor);
    //     CLEAR(currPRNoAdditionalLine);
    //     gRecMSISetup.GET();

    //     lRecNoSeries.RESET;
    //     lRecNoSeries.GET(ParRFQHeader."No. Series");
    //     lRecNoSeries.TESTFIELD("Purchase Order Nos.");
    //     BatchNo := ParRFQHeader."Batch No. [PR]" + 1;
    //     lRecRFQLine.RESET;
    //     lRecRFQLine.SETRANGE("RFQ No.", ParRFQHeader."RFQ No.");
    //     lRecRFQLine.SETFILTER("Vendor No.", '<>%1', '');
    //     lRecRFQLine.SETFILTER("Qty to PO", '>%1', 0);
    //     lRecRFQLine.SetCurrentKey("Vendor No.");
    //     lRecRFQLine.Ascending(TRUE);
    //     IF lRecRFQLine.FIND('-') THEN BEGIN
    //         REPEAT
    //             lRecRFQLine.CalcFields("Entry No. RFQ Vendor");

    //             CLEAR(OutstandingQty);
    //             IF CurrVendorNo <> lRecRFQLine."Vendor No." THEN BEGIN
    //                 lRecVendor.RESET;
    //                 lRecVendor.GET(lRecRFQLine."Vendor No.");
    //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
    //                 lRecRFQVendor.RESET;
    //                 lRecRFQVendor.GET(lRecRFQLine."RFQ No.", lRecRFQLine."Entry No. RFQ Vendor");
    //                 PurchHeaderIns.INIT;
    //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
    //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
    //                 // PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
    //                 PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No.");
    //                 PurchHeaderIns.INSERT(TRUE);
    //                 PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
    //                 PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
    //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
    //                 PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
    //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
    //                 PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
    //                 PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");
    //                 PurchHeaderIns."RFQ No." := lRecRFQLine."RFQ No.";
    //                 PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
    //                 PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
    //                 PurchHeaderIns.MODIFY(TRUE);
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END
    //             ELSE BEGIN
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END;
    //             CurrVendorNo := lRecRFQLine."Vendor No.";
    //         UNTIL lRecRFQLine.NEXT = 0;
    //     END
    //     ELSE BEGIN
    //         ERROR('No RFQ Line to be found for create PO');
    //     END;

    //     ParRFQHeader.MODIFY;
    //     COMMIT;
    //     PurchLineView.RESET;
    //     PurchLineView.SETRANGE(PurchLineView."RFQ No.", ParRFQHeader."RFQ No.");
    //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
    //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
    //     ParRFQHeader."Batch No. [PR]" := BatchNo;
    //     StatusInt := closedStatus_RFQfromcreatePO(ParRFQHeader."RFQ No.");
    //     IF statusInt <> 0 THEN BEGIN
    //         Case StatusInt OF
    //             1:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Released);
    //             2:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Processed);
    //             3:
    //                 ParRFQHeader.VALIDATE(Status, ParRFQHeader.Status::Closed);
    //         END;
    //     END;
    //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);

    // end;

    procedure createPOHeader_RFQ2(var VenselHeader: Record "Vensel Header")
    var
        RFQLine: Record "RFQ Line";
        RFQVendor: Record "RFQ Vendor List";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
        CurrentVendor: Code[20];
        POCount: Integer;
    begin
        // 1. Validasi Status Dokumen Vensel
        if not (VenselHeader.Status in [VenselHeader.Status::Released, VenselHeader.Status::Processed, VenselHeader.Status::"Send To Vendor"]) then
            Error('Status must be released or processed to create purchase order');

        // 2. Filter Baris RFQ yang terhubung dengan dokumen ini dan siap di-PO-kan
        RFQLine.Reset();
        RFQLine.SetRange("RFQ No.", VenselHeader."RFQ No.");
        RFQLine.SetFilter("Qty to PO", '>0');
        RFQLine.SetFilter("Winner RFQ Line Details", '<>0'); // Pastikan pemenang sudah dipilih

        // Wajib SetCurrentKey agar proses pembuatan PO terkelompok per Vendor dengan rapi
        RFQLine.SetCurrentKey("RFQ No.", "Winner RFQ Line Details");

        if RFQLine.FindSet() then begin
            CurrentVendor := '';
            POCount := 0;

            repeat
                // 3. Tarik data Vendor Pemenang dari tabel RFQ Vendor List
                if RFQVendor.Get(RFQLine."RFQ No.", RFQLine."Winner RFQ Line Details") then begin
                    RFQVendor.TestField("Vendor No.");

                    // 4. LOGIKA GROUPING: Jika Vendor pemenang beda dari baris sebelumnya, Bikin PO Baru
                    if CurrentVendor <> RFQVendor."Vendor No." then begin
                        PurchHeader.Init();
                        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
                        PurchHeader.Insert(true); // Generate PO No.

                        PurchHeader.Validate("Buy-from Vendor No.", RFQVendor."Vendor No.");
                        PurchHeader.Validate("Document Date", WorkDate());
                        PurchHeader."Your Reference" := VenselHeader."Vensel No."; // Tracking dari Vensel
                        PurchHeader.Modify(true);

                        // Update variabel pelacak untuk baris berikutnya
                        CurrentVendor := RFQVendor."Vendor No.";
                        LineNo := 10000;
                        POCount += 1;
                    end;

                    // 5. Masukkan Baris Barang (Lines) ke dalam PO yang sedang aktif
                    PurchLine.Init();
                    PurchLine.Validate("Document Type", PurchHeader."Document Type");
                    PurchLine.Validate("Document No.", PurchHeader."No.");
                    PurchLine.Validate("Line No.", LineNo);
                    PurchLine.Insert(true);

                    // Mapping Tipe Barang
                    if RFQLine.Type = RFQLine.Type::Item then
                        PurchLine.Validate(Type, PurchLine.Type::Item)
                    else if RFQLine.Type = RFQLine.Type::"G/L Account" then
                        PurchLine.Validate(Type, PurchLine.Type::"G/L Account");

                    // Transfer Kuantitas & Data Master
                    PurchLine.Validate("No.", RFQLine."No.");
                    PurchLine.Validate("Location Code", RFQLine."Location Code");
                    PurchLine.Validate(Quantity, RFQLine."Qty to PO");

                    // ====================================================================
                    // INI DIA KODENYA: Tarik Expected Receipt Date dari Vendor Selection
                    // ====================================================================
                    if RFQVendor."Expected Receipt Date" <> 0D then
                        PurchLine.Validate("Expected Receipt Date", RFQVendor."Expected Receipt Date");
                    // ====================================================================

                    PurchLine.Modify(true);

                    // 6. Update Sisa Kuantitas di RFQ Line (Potong Qty to PO)
                    RFQLine."Total Qty On PO" += RFQLine."Qty to PO";
                    RFQLine."Outstanding Quantity" -= RFQLine."Qty to PO";
                    RFQLine."Qty to PO" := 0;
                    RFQLine.Modify(true);

                    LineNo += 10000;
                end else begin
                    Error('Data Vendor Pemenang tidak ditemukan untuk baris RFQ No. %1, Line %2.', RFQLine."RFQ No.", RFQLine."Line No.");
                end;
            until RFQLine.Next() = 0;

            // 7. Selesaikan Proses
            Message('Berhasil membuat %1 dokumen Purchase Order dari Vendor Selection %2.', POCount, VenselHeader."Vensel No.");

        end else begin
            Error('Tidak ada baris yang siap diproses menjadi PO. Pastikan "Qty to PO" terisi lebih dari 0 dan Pemenang (Winner) sudah dipilih.');
        end;
    end;


    procedure createPOLine_RFQ(ParRFQLine: Record "RFQ Line"; PONo: Code[20]; BatchNo: Integer)
    var
        PurchLineIns: Record "Purchase Line";
    begin
        PurchLineIns.INIT;
        PurchLineIns."Document Type" := PurchLineIns."Document Type"::Order;
        PurchLineIns."Document No." := PONo;
        PurchLineIns."Line No." := getLastLineNoPO(PONo);
        PurchLineIns.INSERT(TRUE);
        case ParRFQLine."Type" OF
            ParRFQLine."Type"::" ":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::" ");
                end;
            ParRFQLine."Type"::"G/L Account":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::"G/L Account");
                end;
            ParRFQLine."Type"::Item:
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::Item);
                end;
            ParRFQLine."Type"::"Charge (Item)":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::"Charge (Item)");
                end;
        end;
        PurchLineIns.Validate("No.", ParRFQLine."No.");
        PurchLineIns.Validate(Quantity, ParRFQLine."Qty to PO");
        PurchLineIns.VALIDATE("Direct Unit Cost", ParRFQLine."Unit Price");
        PurchLineIns.VALIDATE("Line Discount %", ParRFQLine."Discount %");
        IF ParRFQLine."Purchase Req. No." <> '' THEN
            PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::Item
        ELSE
            PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::" ";
        PurchLineIns.Description := ParRFQLine.Description;
        PurchLineIns.VALIDATE("Unit of Measure", ParRFQLine."Unit of Measure");
        PurchLineIns.VALIDATE("VAT Bus. Posting Group", ParRFQLine."VAT Bus. Posting Group");
        PurchLineIns.VALIDATE("VAT Prod. Posting Group", ParRFQLine."VAT Prod. Posting Group");



        PurchLineIns.Validate("Part No.", ParRFQLine."Part No.");
        PurchLineIns.Validate("Purchase Req. No.", ParRFQLine."Purchase Req. No.");
        PurchLineIns.Validate("Purchase Req. Line No.", ParRFQLine."Purchase Req. Line No.");
        PurchLineIns.Validate("Material Req. No.", ParRFQLine."Material Req. No.");
        PurchLineIns.Validate("Material Req. Line No.", ParRFQLine."Material Req. Line No.");
        PurchLineIns.Validate("RFQ No.", ParRFQLine."RFQ No.");
        PurchLineIns.Validate("RFQ Line No.", ParRFQLine."Line No.");
        PurchLineIns.VALIDATE("Shortcut Dimension 3 Code", ParRFQLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(3, ParRFQLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(4, ParRFQLine."Shortcut Dimension 4 Code");
        PurchLineIns.ValidateShortcutDimCode(5, ParRFQLine."Shortcut Dimension 5 Code");
        PurchLineIns.ValidateShortcutDimCode(6, ParRFQLine."Shortcut Dimension 6 Code");
        PurchLineIns.ValidateShortcutDimCode(7, ParRFQLine."Shortcut Dimension 7 Code");
        PurchLineIns.ValidateShortcutDimCode(8, ParRFQLine."Shortcut Dimension 8 Code");
        PurchLineIns.VALIDATE("Unit Group", ParRFQLine."Unit Group");
        PurchLineIns.VALIDATE("MR Usage Category", ParRFQLine."MR Usage Category");
        PurchLineIns."Batch No. [PR]" := BatchNo;
        PurchLineIns."PR Type" := PurchLineIns."PR Type"::Material;
        PurchLineIns."PPH 22" := ParRFQLine."PPH 22";
        PurchLineIns.PBBKB := ParRFQLine.PBBKB;
        PurchLineIns.MODIFY(TRUE);
        updOutstandingQtyRFQ(ParRFQLine, PurchLineIns.RecordID, ParRFQLine."Qty to PO", TRUE)
    end;




    //Create PO
    // procedure SendEMailWithAttachment(EmailAddr: text[1024]; DocNo: code[50])
    // var
    //     Email: Codeunit Email;
    //     EmailMessage: Codeunit "Email Message";
    //     Cancelled: Boolean;
    //     MailSent: Boolean;
    //     Selection: Integer;
    //     OptionsLbl: Label 'Send,Open Preview';
    //     ListTo: List of [Text];
    //     lrecRFQ: Record "RFQ Header";
    //     TempBlob: Codeunit "Temp Blob";
    //     InStr: Instream;
    //     OutStr: OutStream;
    //     RFQRecRef: RecordRef;
    // begin
    //     ListTo.Add(EmailAddr);
    //     EmailMessage.Create(ListTo, 'This is Request For Quotation', 'This is sample email body', true);
    //     Cancelled := false;
    //     TempBlob.CreateOutStream(OutStr);
    //     lrecRFQ.RESET();
    //     lrecRFQ.SetFilter("RFQ No.", DocNo);
    //     if lrecRFQ.FINDSET then begin
    //         RFQRecRef.GetTable(lrecRFQ);
    //         // Report.saveas(Report::"RFQ Format", DocNo, ReportFormat::Pdf, OutStr, RFQRecRef);
    //     end;
    //     TempBlob.CreateInStream(InStr);
    //     EmailMessage.Create(EmailAddr, 'Request For Quotation', 'Hi, this is a request for quotation.');
    //     EmailMessage.AddAttachment('RFQ.pdf', 'PDF', InStr);
    //     MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    // end;

    // procedure SendEMailWithAttachment(EmailAddr: Text[1024]; DocNo: Code[50]; VendEntryNo: Integer)
    // var
    //     Email: Codeunit Email;
    //     EmailMessage: Codeunit "Email Message";
    //     TempBlob: Codeunit "Temp Blob";
    //     InStr: InStream;
    //     OutStr: OutStream;
    //     lrecRFQ: Record "RFQ Header";
    //     RFQRecRef: RecordRef;
    //     RFQVendor: Record "RFQ Vendor List";
    //     MailSent: Boolean;
    // begin
    //     // Get vendor details untuk nama & filter
    //     RFQVendor.Reset();
    //     RFQVendor.SetRange("RFQ No.", DocNo);
    //     RFQVendor.SetRange("Entry No. RFQ Vendor", VendEntryNo);
    //     if not RFQVendor.FindFirst() then
    //         Error('Vendor Entry No. %1 tidak ditemukan untuk RFQ %2.', VendEntryNo, DocNo);

    //     // Cari RFQ Header
    //     lrecRFQ.Reset();
    //     lrecRFQ.SetRange("RFQ No.", DocNo);
    //     if not lrecRFQ.FindFirst() then
    //         Error('RFQ No. %1 tidak ditemukan.', DocNo);

    //     // Generate PDF PER VENDOR (report auto-filter via dataitem link)
    //     TempBlob.CreateOutStream(OutStr);
    //     RFQRecRef.GetTable(lrecRFQ);
    //     Report.SaveAs(Report::RFQ_Printour, '', ReportFormat::Pdf, OutStr, RFQRecRef);

    //     // Buat email personal
    //     TempBlob.CreateInStream(InStr);
    //     EmailMessage.Create(EmailAddr,
    //         'Request For Quotation - ' + DocNo + ' (' + RFQVendor."Vendor Name" + ')',
    //         'Bersama ini RFQ untuk Anda terlampir.' +
    //         '\nMohon konfirmasi penawaran sesuai spesifikasi.' +
    //         '\n\nTerima kasih.',
    //         true);
    //     EmailMessage.AddAttachment('RFQ_' + DocNo + '_' + RFQVendor."Vendor No." + '.pdf', 'application/pdf', InStr);

    //     // Kirim & validasi
    //     MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    //     if not MailSent then
    //         Error('Gagal kirim email ke %1.', EmailAddr);
    //     Message('Email RFQ terkirim ke %1 (%2).', EmailAddr, RFQVendor."Vendor Name");
    // end;

    procedure SendEMailWithAttachment(EmailAddr: Text[1024]; DocNo: Code[20]; EntryNoVendor: Integer)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        lrecRFQ: Record "RFQ Header";
        lrecVendor: Record "RFQ Vendor List";
        RFQReport: Report RFQ_Printour;
        RFQRecRef: RecordRef;
        MailSent: Boolean;
    begin
        // Validasi RFQ Header
        if not lrecRFQ.Get(DocNo) then
            Error('RFQ No. %1 tidak ditemukan.', DocNo);

        if lrecRFQ.Status <> lrecRFQ.Status::"Send To Vendor" then
            Error('RFQ harus berstatus Send To Vendor sebelum kirim email.');

        // Validasi vendor
        if not lrecVendor.Get(DocNo, EntryNoVendor) then
            Error('Vendor tidak ditemukan untuk RFQ %1.', DocNo);

        if EmailAddr = '' then
            Error('Vendor %1 tidak memiliki email.', lrecVendor."Vendor No.");

        // Generate PDF khusus untuk vendor ini saja
        TempBlob.CreateOutStream(OutStr);

        // Set filter: hanya RFQ ini
        lrecRFQ.SetRange("RFQ No.", DocNo);

        // Set filter vendor agar PDF hanya berisi 1 vendor
        RFQReport.SetVendorFilter(lrecVendor."Vendor No.");
        RFQReport.SetTableView(lrecRFQ);
        RFQRecRef.GetTable(lrecRFQ);

        // FIXED SaveAs: correct order (Text, ReportFormat, var OutStr, RecordRef)
        RFQReport.SaveAs('', ReportFormat::Pdf, OutStr, RFQRecRef);

        // Buat email dengan attachment PDF vendor ini
        TempBlob.CreateInStream(InStr);
        EmailMessage.Create(
            EmailAddr,
            'Request For Quotation - ' + DocNo,
            'Yth. ' + lrecVendor."Vendor Name" + ',<br><br>' +
            'Bersama ini kami sampaikan <b>Request For Quotation</b> No. <b>' + DocNo + '</b>.<br>' +
            'Mohon konfirmasi penawaran harga sesuai dokumen terlampir.<br><br>' +
            'Terima kasih.',
            true
        );
        EmailMessage.AddAttachment(
            'RFQ_' + DocNo + '_' + lrecVendor."Vendor No." + '.pdf',
            'application/pdf',
            InStr
        );

        MailSent := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        if not MailSent then
            Error('Email gagal dikirim ke %1.', EmailAddr);

        Message('Email berhasil dikirim ke %1 untuk vendor %2.',
                EmailAddr, lrecVendor."Vendor Name");
    end;


    local procedure getLastLineNoRFQ(DocNo: Code[20]): Integer
    var
        lrecRFQLine: Record "RFQ Line";
    begin
        lrecRFQLine.RESET();
        lrecRFQLine.SetRange("RFQ No.", DocNo);
        lrecRFQLine.SETRANGE("Parent Line No.", 0);
        IF lrecRFQLine.FindLast() then
            EXIT(lrecRFQLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

    local procedure getLastLineSplitNoRFQ(DocNo: Code[20]; GroupLineNo: Integer): Integer
    var
        lrecRFQLine: Record "RFQ Line";
    begin
        lrecRFQLine.RESET();
        lrecRFQLine.SetRange("RFQ No.", DocNo);
        lrecRFQLine.SETRANGE("Group Line No.", GroupLineNo);
        IF lrecRFQLine.FindLast() then
            EXIT(lrecRFQLine."Line No." + 1)
        ELSE
            EXIT(10001);
    end;

    local procedure getLastLineNoPO(PONo: Code[20]): Integer
    var
        lRecPurchLine: Record "Purchase Line";
    begin
        lRecPurchLine.RESET;
        lRecPurchLine.SETRANGE("Document No.", PONo);
        IF lRecPurchLine.FINDLAST THEN
            EXIT(lRecPurchLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

    var
        gRecMSISetup: Record "MII Setup";
        //gCUNoSeriesMgt: Codeunit NoseriesManagement;
        NoSeries: Codeunit "No. Series";
        gCUPRFunct: Codeunit "PR Material Function";
}
