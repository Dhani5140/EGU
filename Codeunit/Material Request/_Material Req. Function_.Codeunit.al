codeunit 50101 "Material Req. Function"
{
    trigger OnRun()
    begin
    end;
    //Check
    procedure checkInventoryLine(MRHeader: Record "Material Req. Header")
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.CalcFields(Inventory);
        lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", MRHeader."Material Req. No.");
        lRecMRLine.SETRANGE(lRecMRLine.Inventory, 0);
        IF lRecMRLine.FINDFIRST THEN ERROR('Inventory in Line %1 is 0, cannot create Inv Shipment', lRecMRLine."Line No.");
    end;

    procedure checkMultipleMR_InvShip(ParMRLine: Record "Material Req. Line"; DocNo: Code[20])
    var
        lRecInvDocLine: Record "Invt. Document Line";
    begin
        lRecInvDocLine.RESET;
        lRecInvDocLine.SETRANGE(lRecInvDocLine."Document No.", DocNo);
        lRecInvDocLine.SETFILTER("Material Req. No.", '<>%1', '');
        lRecInvDocLine.SETFILTER("Material Req. No.", '<>%1', ParMRLine."Material Req. No.");
        IF lRecInvDocLine.FINDFIRST THEN ERROR('Inventory Shipment %1 already has line Material Request %2, cannot input different material request', DocNo, lRecInvDocLine."Material Req. No.");
    end;

    procedure checkMandatoryFields(MRHeader: Record "Material Req. Header")
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        //Tolong di cek kembali
        // MRHeader.Testfield("Location Code");
        // MRHeader.TestField("Shortcut Dimension 1 Code");
        // MRHeader.TestField("Shortcut Dimension 3 Code");
        // MRHeader.TestField("Requester Department");
        // MRHeader.TestField("Requester Name");

        lRecMRLine.RESET;
        lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", MRHeader."Material Req. No.");
        lRecMRLine.SETRANGE(lRecMRLine.Quantity, 0);
        IF lRecMRLine.FINDFIRST THEN ERROR('Qty in Line %1 is still 0, cannot continue', lRecMRLine."Line No.");
    end;

    procedure checkMRLinehasPR(MRNo: Code[20]; msgErr: Text)
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty on PR");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty on PR", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has PR, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty On Inv. Shpt");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty On Inv. Shpt", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has Inventory Shipment, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty On Posted Inv. Shpt");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty On Posted Inv. Shpt", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has Inventory Shipment, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty On Item Journal");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty On Item Journal", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has Item Journal, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty On ILE");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty On ILE", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has ILE, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
    end;

    procedure checkMRLinehasPR_Cancel(MRNo: Code[20]; LineNo: Integer)
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty on PR");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETRANGE("Line No.", LineNo);
        lRecMRLine.SETFILTER("Total Qty on PR", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has PR, cannot cancel', lRecMRLine."Line No.")
        END;
    end;

    procedure checkMRLinehasOutstanding(MRNo: Code[20]): Boolean
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;

    procedure checkMRLineNonPPH22hasOutstanding(MRNo: Code[20]): Boolean
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        lRecMRLine.SETRANGE("PPH 22", FALSE);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;

    procedure checkMRLinePPH22hasOutstanding(MRNo: Code[20]): Boolean
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        lRecMRLine.SETRANGE("PPH 22", TRUE);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;
    // Penambahan Min Max
    procedure SuggestMinMaxItems(var ParMRHeader: Record "Material Req. Header")
    var
        lRecSKU: Record "Stockkeeping Unit";
        lRecMRLine: Record "Material Req. Line";
        NextLineNo: Integer;
        QtyToOrder: Decimal;
        LineAdded: Boolean;
    begin
        ParMRHeader.TestField("Location Code");
        LineAdded := false;

        // 1. Cari Line Number terakhir agar tidak bentrok
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
        IF lRecMRLine.FINDLAST THEN
            NextLineNo := lRecMRLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        // 2. Filter SKU berdasarkan Lokasi (Outlet) yang dipilih di Header
        lRecSKU.RESET;
        lRecSKU.SETRANGE("Location Code", ParMRHeader."Location Code");
        lRecSKU.SETFILTER("Maximum Inventory", '>%1', 0); // Pastikan SKU punya setup Max Inventory

        IF lRecSKU.FINDSET THEN BEGIN
            REPEAT
                // Hitung stok aktual (Real-time Inventory)
                lRecSKU.CALCFIELDS(Inventory);

                // 3. Logika Min/Max: Jika Stok <= Minimal (Reorder Point)
                IF lRecSKU.Inventory <= lRecSKU."Reorder Point" THEN BEGIN
                    QtyToOrder := lRecSKU."Maximum Inventory" - lRecSKU.Inventory;

                    IF QtyToOrder > 0 THEN BEGIN
                        // Validasi agar tidak merekomendasikan Item yang sudah di-input manual di baris
                        lRecMRLine.RESET;
                        lRecMRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
                        lRecMRLine.SETRANGE("Item No.", lRecSKU."Item No.");
                        IF NOT lRecMRLine.FINDFIRST THEN BEGIN

                            // Insert baris baru secara otomatis
                            lRecMRLine.INIT;
                            lRecMRLine."Material Req. No." := ParMRHeader."Material Req. No.";
                            lRecMRLine."Line No." := NextLineNo;
                            lRecMRLine.INSERT(TRUE);

                            lRecMRLine.VALIDATE("Item No.", lRecSKU."Item No.");
                            lRecMRLine.VALIDATE(Quantity, QtyToOrder);
                            lRecMRLine.MODIFY(TRUE);

                            NextLineNo += 10000;
                            LineAdded := true;
                        END;
                    END;
                END;
            UNTIL lRecSKU.NEXT = 0;
        END;

        // 4. Notifikasi ke User Outlet
        IF LineAdded THEN
            MESSAGE('Item yang di bawah batas minimum berhasil ditambahkan ke baris otomatis!')
        ELSE
            MESSAGE('Semua stok item masih aman (di atas batas minimum), atau setup SKU lokasi ini belum dibuat.');
    end;

    procedure checkMRLineNonPPH22hasPurchRcpt(MRNo: Code[20]): Boolean
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Outstanding Qty Invt. Shpt", '>%1', 0);
        lRecMRLine.SETRANGE("PPH 22", FALSE);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            REPEAT
                lRecMRLine.CalcFields("Total Qty On Purch Rcpt");
                IF lRecMRLine."Qty Invt. Shpt Purch. Rcpt" < lRecMRLine."Total Qty On Purch Rcpt" THEN EXIT(TRUE) UNTIL lRecMRLine.NEXT = 0;
        END;
        EXIT(FALSE);
    end;

    procedure refreshOutsMRInvShipBol(parDim1: Code[20]; parUnitGroup: Code[50]; parMRCategory: Code[50])
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETFILTER(Quantity, '>%1', 0);
        lRecMRLine.SETFILTER("Outstanding Qty Invt. Shpt", '>%1', 0);
        lRecMRLine.SETFILTER(Status, '%1|%2', lRecMRLine.Status::Released, lRecMRLine.Status::Processed);
        lRecMRLine.SETRANGE(Cancel, FALSE);
        lRecMRLine.SETRANGE("Shortcut Dimension 1 Code", parDim1);
        lRecMRLine.SETRANGE("Unit Group", parUnitGroup);
        lRecMRLine.SETRANGE("MR Usage Category", parMRCategory);
        IF lRecMRLine.FIND('-') THEN BEGIN
            REPEAT
                lRecMRLine.VALIDATE("Qty Invt. Shpt Purch. Rcpt", lRecMRLine."Qty Invt. Shpt Purch. Rcpt");
                lRecMRLine.MODIFY;
            UNTIL lRecMRLine.NEXT = 0;
        END
    end;
    //Check
    //UpdateOutstanding
    procedure updOutstandingQtyMR(var ParMRLine: Record "Material Req. Line"; fromRecordID: RecordID; QtytoUpd: Decimal)
    var
        lRecMRHeader: Record "Material Req. Header";
        lRecMRLine: Record "Material Req. Line";
        lRecPRLine: Record "PR Material Line";
        lRecTransLine: Record "Transfer Line";
        lRecTransRcptLine: Record "Transfer Receipt Line";
        lRecInvDocLine: Record "Invt. Document Line";
        lRecInvShptLine: Record "Invt. Shipment Line";
        lRecItemJournalLine: Record "Item Journal Line";
        lRecILE: Record "Item Ledger Entry";
        lDecTotalPRQty: Decimal;
        lDecTotalInvDocQty: Decimal;
        lDecTotalItemJournalQty: Decimal;
        lDecOutstandingInvShip: Decimal;
        lDecOutstandingQty: Decimal;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalPRQty);
        CLEAR(lDecTotalInvDocQty);
        CLEAR(lDecOutstandingQty);
        CLEAR(lDecTotalItemJournalQty);
        CLEAR(lDecOutstandingInvShip);
        CASE fromRecordID.TableNo OF
            database::"PR Material Line":
                BEGIN
                    lRecPRLine.RESET;
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecPRLine.FIND('-') THEN BEGIN
                        lRecPRLine.CalcSums(Quantity);
                        lDecTotalPRQty += ABS(lRecPRLine.Quantity);
                    END;
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvDocLine.FIND('-') THEN BEGIN
                        lRecInvDocLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvDocLine.Quantity);
                    END;
                    lRecInvShptLine.RESET;
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvShptLine.FIND('-') THEN BEGIN
                        lRecInvShptLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvShptLine.Quantity);
                    END;
                    lRecItemJournalLine.RESET;
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecItemJournalLine.FIND('-') THEN BEGIN
                        lRecItemJournalLine.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecItemJournalLine.Quantity);
                    END;
                    lRecILE.RESET;
                    lRecILE.SETRANGE(lRecILE."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecILE.SETRANGE(lRecILE."Material Req. Line No.", ParMRLine."Line No.");
                    lRecILE.SETRANGE("Entry Type", lRecILE."Entry Type"::"Negative Adjmt.");
                    lRecILE.SETRANGE("Item Journal MR", TRUE);
                    IF lRecILE.FIND('-') THEN BEGIN
                        lRecILE.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecILE.Quantity);
                    END;
                    lRecPRLine.RESET;
                    lRecPRLine.GET(fromRecordID);
                    lDecTotalPRQty := lDecTotalPRQty - lRecPRLine.Quantity;
                END;
            database::"Invt. Document Line":
                BEGIN
                    lRecPRLine.RESET;
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecPRLine.FIND('-') THEN BEGIN
                        lRecPRLine.CalcSums(Quantity);
                        lDecTotalPRQty += ABS(lRecPRLine.Quantity);
                    END;
                    lRecItemJournalLine.RESET;
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecItemJournalLine.FIND('-') THEN BEGIN
                        lRecItemJournalLine.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecItemJournalLine.Quantity);
                    END;
                    lRecILE.RESET;
                    lRecILE.SETRANGE(lRecILE."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecILE.SETRANGE(lRecILE."Material Req. Line No.", ParMRLine."Line No.");
                    lRecILE.SETRANGE("Entry Type", lRecILE."Entry Type"::"Negative Adjmt.");
                    lRecILE.SETRANGE("Item Journal MR", TRUE);
                    IF lRecILE.FIND('-') THEN BEGIN
                        lRecILE.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecILE.Quantity);
                    END;
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvDocLine.FIND('-') THEN BEGIN
                        lRecInvDocLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvDocLine.Quantity);
                    END;
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.GET(fromRecordID);
                    lDecTotalInvDocQty := lDecTotalInvDocQty - lRecInvDocLine.Quantity;
                    // IF (lDecTotalInvDocQty = 0) OR (QtytoUpd = 0) THEN BEGIN
                    lRecInvShptLine.RESET;
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvShptLine.FIND('-') THEN BEGIN
                        lRecInvShptLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvShptLine.Quantity);
                    END;
                    // END;
                END;
            database::"Item Journal Line":
                BEGIN
                    lRecPRLine.RESET;
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecPRLine.FIND('-') THEN BEGIN
                        lRecPRLine.CalcSums(Quantity);
                        lDecTotalPRQty += ABS(lRecPRLine.Quantity);
                    END;
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvDocLine.FIND('-') THEN BEGIN
                        lRecInvDocLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvDocLine.Quantity);
                    END;
                    lRecInvShptLine.RESET;
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecInvShptLine.FIND('-') THEN BEGIN
                        lRecInvShptLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvShptLine.Quantity);
                    END;
                    lRecItemJournalLine.RESET;
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecItemJournalLine.SETRANGE(lRecItemJournalLine."Material Req. Line No.", ParMRLine."Line No.");
                    IF lRecItemJournalLine.FIND('-') THEN BEGIN
                        lRecItemJournalLine.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecItemJournalLine.Quantity);
                    END;
                    lRecItemJournalLine.RESET;
                    lRecItemJournalLine.GET(fromRecordID);
                    lDecTotalItemJournalQty := lDecTotalItemJournalQty - lRecItemJournalLine.Quantity;
                    // IF (lDecTotalItemJournalQty = 0) OR (QtytoUpd = 0) THEN BEGIN
                    lRecILE.RESET;
                    lRecILE.SETRANGE(lRecILE."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecILE.SETRANGE(lRecILE."Material Req. Line No.", ParMRLine."Line No.");
                    lRecILE.SETRANGE("Entry Type", lRecILE."Entry Type"::"Negative Adjmt.");
                    lRecILE.SETRANGE("Item Journal MR", TRUE);
                    IF lRecILE.FIND('-') THEN BEGIN
                        lRecILE.CalcSums(Quantity);
                        lDecTotalItemJournalQty += ABS(lRecILE.Quantity);
                    END;
                    // END;
                END;
        // database::"Transfer Line":
        //     BEGIN
        //         lRecPRLine.RESET;
        //         lRecPRLine.SETRANGE(lRecPRLine."Material Req. No.", ParMRLine."Material Req. No.");
        //         lRecPRLine.SETRANGE(lRecPRLine."Material Req. Line No.", ParMRLine."Line No.");
        //         IF lRecPRLine.FIND('-') THEN BEGIN
        //             lRecPRLine.CalcSums(Quantity);
        //             lDecTotalPRQty := lRecPRLine.Quantity;
        //         END;
        //         lRecTransLine.RESET;
        //         lRecTransLine.SETRANGE(lRecTransLine."Material Req. No.", ParMRLine."Material Req. No.");
        //         lRecTransLine.SETRANGE(lRecTransLine."Material Req. Line No.", ParMRLine."Line No.");
        //         IF lRecTransLine.FIND('-') THEN BEGIN
        //             lRecTransLine.CalcSums(Quantity);
        //             lDecTotalTOQty := lRecTransLine.Quantity;
        //         END;
        //         lRecTransLine.RESET;
        //         lRecTransLine.GET(fromRecordID);
        //         lDecTotalTOQty := lDecTotalTOQty - lRecTransLine.Quantity;
        //         IF (lDecTotalTOQty = 0) OR (QtytoUpd = 0) THEN BEGIN
        //             lRecTransRcptLine.RESET;
        //             lRecTransRcptLine.SETRANGE(lRecTransRcptLine."Material Req. No.", ParMRLine."Material Req. No.");
        //             lRecTransRcptLine.SETRANGE(lRecTransRcptLine."Material Req. Line No.", ParMRLine."Line No.");
        //             IF lRecTransRcptLine.FIND('-') THEN BEGIN
        //                 lRecTransRcptLine.CalcSums(Quantity);
        //                 lDecTotalTOQty := lRecTransRcptLine.Quantity;
        //             END;
        //         END;
        //     END;
        END;
        lDecTotalPRQty := ABS(lDecTotalPRQty);
        lDecTotalInvDocQty := ABS(lDecTotalInvDocQty);
        lDecTotalItemJournalQty := ABS(lDecTotalItemJournalQty);
        lDecOutstandingQty := ParMRLine.Quantity - lDecTotalPRQty - lDecTotalInvDocQty - lDecTotalItemJournalQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParMRLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParMRLine."Outstanding Quantity" := 0;
        END;
        IF fromRecordID.TableNo IN [Database::"Item Journal Line", Database::"Invt. Document Line"] THEN BEGIN
            lDecOutstandingInvShip := ParMRLine.Quantity - lDecTotalInvDocQty - lDecTotalItemJournalQty - QtytoUpd;
            IF lDecOutstandingInvShip > 0 THEN BEGIN
                ParMRLine."Outstanding Qty Invt. Shpt" := lDecOutstandingInvShip;
            END
            ELSE BEGIN
                ParMRLine."Outstanding Qty Invt. Shpt" := 0;
            END;
        END;
        ParMRLine.MODIFY;
        closedStatus_MR(ParMRLine."Material Req. No.");
        // END;
    end;

    procedure updQtyInvtShipReceipt(var ParMRLine: Record "Material Req. Line"; fromRecordID: RecordID; QtytoUpd: Decimal)
    var
        lRecMRHeader: Record "Material Req. Header";
        lRecMRLine: Record "Material Req. Line";
        lRecInvDocLine: Record "Invt. Document Line";
        lRecInvShptLine: Record "Invt. Shipment Line";
        lDecTotalInvDocQty: Decimal;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalInvDocQty);
        CASE fromRecordID.TableNo OF
            database::"Invt. Document Line":
                BEGIN
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."Material Req. Line No.", ParMRLine."Line No.");
                    lRecInvDocLine.SETRANGE(lRecInvDocLine."MR Purch. Receipt", TRUE);
                    IF lRecInvDocLine.FIND('-') THEN BEGIN
                        lRecInvDocLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvDocLine.Quantity);
                    END;
                    lRecInvDocLine.RESET;
                    lRecInvDocLine.GET(fromRecordID);
                    lDecTotalInvDocQty := lDecTotalInvDocQty - lRecInvDocLine.Quantity;
                    lRecInvShptLine.RESET;
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."Material Req. Line No.", ParMRLine."Line No.");
                    lRecInvShptLine.SETRANGE(lRecInvShptLine."MR Purch. Receipt", TRUE);
                    IF lRecInvShptLine.FIND('-') THEN BEGIN
                        lRecInvShptLine.CalcSums(Quantity);
                        lDecTotalInvDocQty += ABS(lRecInvShptLine.Quantity);
                    END;
                END;
        END;
        lDecTotalInvDocQty := ABS(lDecTotalInvDocQty);
        ParMRLine.VALIDATE("Qty Invt. Shpt Purch. Rcpt", lDecTotalInvDocQty);
        ParMRLine.MODIFY;
        closedStatus_MR(ParMRLine."Material Req. No.");
        // END;
    end;

    procedure closedStatus_MR(MRNo: Code[20])
    var
        lRecMRHeader: Record "Material Req. Header";
        lRecMRLine: Record "Material Req. Line";
        isOutstanding: Boolean;
        isOutstandingInvShip: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        allCancel: Boolean;
        statusInt: integer;
    begin
        isOutstanding := FALSE;
        isOutstandingInvShip := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        allCancel := TRUE;
        statusInt := 0;
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", MRNo);
        IF lRecMRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecMRLine.Cancel = FALSE THEN BEGIN
                    allCancel := FALSE;
                    IF lRecMRLine.Quantity > lRecMRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                    IF lRecMRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
                    IF lRecMRLine."Outstanding Qty Invt. Shpt" > 0 THEN isOutstandingInvShip := TRUE;
                END;
            UNTIL (lRecMRLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
            IF allCancel THEN BEGIN
                statusInt := 4;
            END
            ELSE BEGIN
                IF hasProcess THEN BEGIN
                    IF isOutstanding THEN BEGIN
                        statusInt := 2;
                    END
                    ELSE BEGIN
                        IF isOutstandingInvShip THEN
                            statusInt := 2
                        ELSE
                            statusInt := 3;
                    END;
                END
                ELSE BEGIN
                    statusInt := 1;
                END;
            END;
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        IF statusInt <> 0 THEN BEGIN
            lRecMRHeader.RESET;
            lRecMRHeader.SETRANGE(lRecMRHeader."Material Req. No.", MRNo);
            IF lRecMRHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::Released);
                    2:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::"Partial Receive / Processed On PR");
                    3:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::Closed);
                    4:
                        lRecMRHeader.Validate(Status, lRecMRHeader.Status::Canceled);
                END;
                lRecMRHeader.MODIFY;
            END;
        END;
    end;

    procedure editOutstandingfromResultDoc(MRNo: Code[20]; MRLineNo: Integer; parRecordID: RecordId; QtyUpd: Decimal; Qtybefore: Decimal; isDelete: Boolean)
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETRANGE("Line No.", MRLineNo);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            IF isDelete THEN BEGIN
                updOutstandingQtyMR(lRecMRLine, parRecordID, 0);
            END
            ELSE BEGIN
                IF lRecMRLine."Outstanding Quantity" + (Qtybefore - QtyUpd) < 0 THEN ERROR('You cannot input more than %1', lRecMRLine."Outstanding Quantity" + Qtybefore);
                updOutstandingQtyMR(lRecMRLine, parRecordID, QtyUpd);
            END;
        END;
    end;
    //UpdateOutstanding

    //CreateDoc
    procedure createInvDocHeader_MR(var ParMRHeader: Record "Material Req. Header")
    var
        lRecMRLine: Record "Material Req. Line";
        lRecInvDocHeader: Record "Invt. Document Header";
        lRecNoSeries: Record "No. Series";
    begin
        ParMRHeader.TestField("Location Code");
        // ParMRHeader.TestField("Gen. Prod. Posting Group");
        //ParMRHeader.TestField("Gen Bus. Posting Group");
        gRecMSISetup.GET;
        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParMRHeader."No. Series");
        lRecNoSeries.TESTFIELD("Invt. Shipment Nos.");
        IF checkMRLineNonPPH22hasOutstanding(ParMRHeader."Material Req. No.") THEN BEGIN
            lRecInvDocHeader.INIT;
            lRecInvDocHeader."Document Type" := lRecInvDocHeader."Document Type"::Shipment;
            //lRecInvDocHeader."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Invt. Shipment Nos.", WorkDate(), true);
            lRecInvDocHeader."No." := NOSeries.GetNextNo(lRecNoSeries."Invt. Shipment Nos.", WorkDate(), true);
            lRecInvDocHeader.INSERT(TRUE);
            lRecInvDocHeader.VALIDATE("No. Series", lRecNoSeries."Invt. Shipment Nos.");
            lRecInvDocHeader."Posting Description" := ParMRHeader."Material Req. No.";
            lRecInvDocHeader."External Document No." := ParMRHeader."Material Req. No.";
            lRecInvDocHeader.VALIDATE("Location Code", ParMRHeader."Location Code");
            //IF ParMRHeader."Shortcut Dimension 1 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 1 Code", ParMRHeader."Shortcut Dimension 1 Code");
            //IF ParMRHeader."Shortcut Dimension 2 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 2 Code", ParMRHeader."Shortcut Dimension 2 Code");
            //IF ParMRHeader."Shortcut Dimension 3 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 3 Code", ParMRHeader."Shortcut Dimension 3 Code");
            //lRecInvDocHeader.VALIDATE("Shortcut Dimension 5 Code", ParMRHeader."Shortcut Dimension 5 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(3, ParMRHeader."Shortcut Dimension 3 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(4, ParMRHeader."Shortcut Dimension 4 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(5, ParMRHeader."Shortcut Dimension 5 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(6, ParMRHeader."Shortcut Dimension 6 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(7, ParMRHeader."Shortcut Dimension 7 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(8, ParMRHeader."Shortcut Dimension 8 Code");
            lRecInvDocHeader."Material Req. No." := ParMRHeader."Material Req. No.";
            lRecInvDocHeader.VALIDATE("Unit Group", ParMRHeader."Unit Group");
            lRecInvDocHeader.VALIDATE("MR Usage Category", ParMRHeader."MR Usage Category");
            //lRecInvDocHeader.VALIDATE("Gen. Bus. Posting Group", ParMRHeader."Gen Bus. Posting Group");
            //lRecInvDocHeader.VALIDATE("Gen. Prod. Posting Group", ParMRHeader."Gen. Prod. Posting Group");
            lRecInvDocHeader.VALIDATE(Remarks, ParMRHeader.Remarks);
            lRecInvDocHeader.VALIDATE("Posting No. Series", gCUMSIFunct.getNoSeriesGenProd_Location(ParMRHeader."Gen. Prod. Posting Group", ParMRHeader."Location Code", 1));
            lRecInvDocHeader.MODIFY(TRUE);
            lRecMRLine.RESET;
            lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", ParMRHeader."Material Req. No.");
            lRecMRLine.SETFILTER(lRecMRLine."Outstanding Quantity", '>%1', 0);

            IF lRecMRLine.FIND('-') THEN BEGIN
                REPEAT
                    createInvDocLine_MR(lRecMRLine, lRecInvDocHeader."No.");
                UNTIL lRecMRLine.NEXT = 0;
            END;
            COMMIT;
            Page.RUN(Page::"Invt. Shipment", lRecInvDocHeader);
        END
        ELSE BEGIN
            ERROR('No record to be created to inventory shipment')
        END;
    end;

    procedure createInvDocLine_MR(ParMRLine: Record "Material Req. Line"; DocNo: Code[20])
    var
        lRecInvDocLine: Record "Invt. Document Line";
    begin
        lRecInvDocLine.INIT;
        lRecInvDocLine."Document Type" := lRecInvDocLine."Document Type"::Shipment;
        lRecInvDocLine."Document No." := DocNo;
        lRecInvDocLine."Line No." := getInvDocLastLineNo(DocNo);
        lRecInvDocLine.INSERT(TRUE);
        lRecInvDocLine.VALIDATE("Item No.", ParMRLine."Item No.");
        lRecInvDocLine.VALIDATE(Quantity, ParMRLine."Quantity Delivery");
        lRecInvDocLine.VALIDATE("Unit of Measure Code", ParMRLine."Unit of Measure");
        lRecInvDocLine."Material Req. No." := ParMRLine."Material Req. No.";
        lRecInvDocLine."Material Req. Line No." := ParMRLine."Line No.";
        //IF ParMRLine."Shortcut Dimension 1 Code" <> '' THEN lRecInvDocLine.VALIDATE("Shortcut Dimension 1 Code", ParMRLine."Shortcut Dimension 1 Code");
        //IF ParMRLine."Shortcut Dimension 2 Code" <> '' THEN lRecInvDocLine.VALIDATE("Shortcut Dimension 2 Code", ParMRLine."Shortcut Dimension 2 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(3, ParMRLine."Shortcut Dimension 3 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(4, ParMRLine."Shortcut Dimension 4 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(5, ParMRLine."Shortcut Dimension 5 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(6, ParMRLine."Shortcut Dimension 6 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(7, ParMRLine."Shortcut Dimension 7 Code");
        //lRecInvDocLine.ValidateShortcutDimCode(8, ParMRLine."Shortcut Dimension 8 Code");
        lRecInvDocLine.MODIFY(TRUE);
        updOutstandingQtyMR(ParMRLine, lRecInvDocLine.RecordID, ParMRLine."Outstanding Quantity")
    end;

    procedure createInvDocHeader_PurchRcpt(var ParMRHeader: Record "Material Req. Header")
    var
        lRecMRLine: Record "Material Req. Line";
        lRecInvDocHeader: Record "Invt. Document Header";
        lRecNoSeries: Record "No. Series";
    begin
        ParMRHeader.TestField("Location Code");
        // ParMRHeader.TestField("Gen Bus. Posting Group");
        gRecMSISetup.GET;
        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParMRHeader."No. Series");
        lRecNoSeries.TESTFIELD("Invt. Shipment Nos.");
        IF checkMRLineNonPPH22hasPurchRcpt(ParMRHeader."Material Req. No.") THEN BEGIN
            lRecInvDocHeader.INIT;
            lRecInvDocHeader."Document Type" := lRecInvDocHeader."Document Type"::Shipment;
            //lRecInvDocHeader."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Invt. Shipment Nos.", WorkDate(), true);
            lRecInvDocHeader."No." := NOSeries.GetNextNo(lRecNoSeries."Invt. Shipment Nos.", WorkDate(), true);
            lRecInvDocHeader.INSERT(TRUE);
            lRecInvDocHeader.VALIDATE("No. Series", lRecNoSeries."Invt. Shipment Nos.");
            lRecInvDocHeader."Posting Description" := ParMRHeader."Material Req. No.";
            lRecInvDocHeader."External Document No." := ParMRHeader."Material Req. No.";
            lRecInvDocHeader.VALIDATE("Location Code", ParMRHeader."Location Code");
            IF ParMRHeader."Shortcut Dimension 1 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 1 Code", ParMRHeader."Shortcut Dimension 1 Code");
            IF ParMRHeader."Shortcut Dimension 2 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 2 Code", ParMRHeader."Shortcut Dimension 2 Code");
            //IF ParMRHeader."Shortcut Dimension 3 Code" <> '' THEN lRecInvDocHeader.VALIDATE("Shortcut Dimension 3 Code", ParMRHeader."Shortcut Dimension 3 Code");
            lRecInvDocHeader.VALIDATE("Shortcut Dimension 5 Code", ParMRHeader."Shortcut Dimension 5 Code");
            // lRecInvDocHeader.VALIDATE("Shortcut Dimension 6 Code", ParMRHeader."Shortcut Dimension 6 Code");
            // lRecInvDocHeader.VALIDATE("Shortcut Dimension 7 Code", ParMRHeader."Shortcut Dimension 7 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(3, ParMRHeader."Shortcut Dimension 3 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(4, ParMRHeader."Shortcut Dimension 4 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(5, ParMRHeader."Shortcut Dimension 5 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(6, ParMRHeader."Shortcut Dimension 6 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(7, ParMRHeader."Shortcut Dimension 7 Code");
            //lRecInvDocHeader.ValidateShortcutDimCode(8, ParMRHeader."Shortcut Dimension 8 Code");
            lRecInvDocHeader."Material Req. No." := ParMRHeader."Material Req. No.";
            lRecInvDocHeader.VALIDATE("Unit Group", ParMRHeader."Unit Group");
            lRecInvDocHeader.VALIDATE("MR Usage Category", ParMRHeader."MR Usage Category");
            lRecInvDocHeader.VALIDATE("Gen. Bus. Posting Group", ParMRHeader."Gen Bus. Posting Group");
            lRecInvDocHeader.VALIDATE("Gen. Prod. Posting Group", ParMRHeader."Gen. Prod. Posting Group");
            lRecInvDocHeader.VALIDATE(Remarks, ParMRHeader.Remarks);
            lRecInvDocHeader.VALIDATE("Posting No. Series", gCUMSIFunct.getNoSeriesGenProd_Location(ParMRHeader."Gen. Prod. Posting Group", ParMRHeader."Location Code", 1));
            lRecInvDocHeader.MODIFY(TRUE);
            lRecMRLine.RESET;
            lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", ParMRHeader."Material Req. No.");
            lRecMRLine.SETFILTER(lRecMRLine."Outstanding Qty Invt. Shpt", '>%1', 0);
            IF lRecMRLine.FIND('-') THEN BEGIN
                REPEAT
                    lRecMRLine.CalcFields("Total Qty On Purch Rcpt");
                    IF lRecMRLine."Qty Invt. Shpt Purch. Rcpt" < lRecMRLine."Total Qty On Purch Rcpt" THEN createInvDocLine_PurchRcpt(lRecMRLine, lRecInvDocHeader."No.");
                UNTIL lRecMRLine.NEXT = 0;
            END;
            COMMIT;
            Page.RUN(Page::"Invt. Shipment", lRecInvDocHeader);
        END
        ELSE BEGIN
            ERROR('No record to be created to inventory shipment')
        END;
    end;

    procedure createInvDocLine_PurchRcpt(ParMRLine: Record "Material Req. Line"; DocNo: Code[20])
    var
        lRecInvDocLine: Record "Invt. Document Line";
        QtyInputted: Decimal;
    begin
        CLEAR(QtyInputted);
        ParMRLine.CalcFields("Total Qty On Purch Rcpt");
        IF ParMRLine."Qty Invt. Shpt Purch. Rcpt" < ParMRLine."Total Qty On Purch Rcpt" THEN BEGIN
            QtyInputted := ParMRLine."Total Qty On Purch Rcpt" - ParMRLine."Qty Invt. Shpt Purch. Rcpt";
            lRecInvDocLine.INIT;
            lRecInvDocLine."Document Type" := lRecInvDocLine."Document Type"::Shipment;
            lRecInvDocLine."Document No." := DocNo;
            lRecInvDocLine."Line No." := getInvDocLastLineNo(DocNo);
            lRecInvDocLine.INSERT(TRUE);
            lRecInvDocLine.VALIDATE("Item No.", ParMRLine."Item No.");
            lRecInvDocLine.VALIDATE(Quantity, QtyInputted);
            lRecInvDocLine.VALIDATE("Unit of Measure Code", ParMRLine."Unit of Measure");
            lRecInvDocLine."Material Req. No." := ParMRLine."Material Req. No.";
            lRecInvDocLine."Material Req. Line No." := ParMRLine."Line No.";
            IF ParMRLine."Shortcut Dimension 1 Code" <> '' THEN lRecInvDocLine.VALIDATE("Shortcut Dimension 1 Code", ParMRLine."Shortcut Dimension 1 Code");
            IF ParMRLine."Shortcut Dimension 2 Code" <> '' THEN lRecInvDocLine.VALIDATE("Shortcut Dimension 2 Code", ParMRLine."Shortcut Dimension 2 Code");
            //lRecInvDocLine.ValidateShortcutDimCode(3, ParMRLine."Shortcut Dimension 3 Code");
            lRecInvDocLine.ValidateShortcutDimCode(4, ParMRLine."Shortcut Dimension 4 Code");
            lRecInvDocLine.ValidateShortcutDimCode(5, ParMRLine."Shortcut Dimension 5 Code");
            lRecInvDocLine.ValidateShortcutDimCode(6, ParMRLine."Shortcut Dimension 6 Code");
            lRecInvDocLine.ValidateShortcutDimCode(7, ParMRLine."Shortcut Dimension 7 Code");
            lRecInvDocLine.ValidateShortcutDimCode(8, ParMRLine."Shortcut Dimension 8 Code");
            lRecInvDocLine."MR Purch. Receipt" := TRUE;
            lRecInvDocLine.MODIFY(TRUE);
            QtyInputted := QtyInputted + ParMRLine."Qty Invt. Shpt Purch. Rcpt";
            ParMRLine.VALIDATE("Qty Invt. Shpt Purch. Rcpt", QtyInputted);
            ParMRLine.MODIFY;
            updOutstandingQtyMR(ParMRLine, lRecInvDocLine.RecordID, QtyInputted)
        END
        ELSE BEGIN
            ERROR('Already create %1 from purchase receipt, cannot make more invt. shipment than %2', ParMRLine."Qty Invt. Shpt Purch. Rcpt", ParMRLine."Total Qty On Purch Rcpt");
        END;
    end;

    procedure createItemJournalLine_MR(lRecMRHeader2: Record "Material Req. Header")
    var
        lRecItemJournalLine: Record "Item Journal Line";
        ParMRLine: Record "Material Req. Line";
        lRecMRHeader: Record "Material Req. Header";
    begin
        lRecMRHeader.RESET;
        lRecMRHeader.GET(ParMRLine."Material Req. No.");
        lRecItemJournalLine.INIT;
        lRecItemJournalLine."Journal Template Name" := 'ITEM';
        lRecItemJournalLine."Journal Batch Name" := 'DEFAULT';
        lRecItemJournalLine."Line No." := getItemJournalLastLineNo('ITEM', 'DEFAULT');
        lRecItemJournalLine.INSERT(TRUE);
        // lRecItemJournalLine.VALIDATE("Posting Date", WORKDATE);
        lRecItemJournalLine.VALIDATE("Posting Date", lRecMRHeader."Document Date");
        lRecItemJournalLine."Entry Type" := lRecItemJournalLine."Entry Type"::"Negative Adjmt.";
        lRecItemJournalLine."Document No." := ParMRLine."Material Req. No.";
        lRecItemJournalLine.VALIDATE("Item No.", ParMRLine."Item No.");
        lRecItemJournalLine.VALIDATE(Quantity, ParMRLine."Outstanding Quantity");
        lRecItemJournalLine.VALIDATE("Unit of Measure Code", ParMRLine."Unit of Measure");
        lRecItemJournalLine.VALIDATE("Location Code", ParMRLine."Location Code");
        lRecItemJournalLine."Material Req. No." := ParMRLine."Material Req. No.";
        lRecItemJournalLine."External Document No." := ParMRLine."Material Req. No.";
        lRecItemJournalLine."Material Req. Line No." := ParMRLine."Line No.";
        lRecItemJournalLine."Item Journal MR" := TRUE;
        lRecItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", ParMRLine."Shortcut Dimension 1 Code");
        lRecItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", ParMRLine."Shortcut Dimension 2 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(3, ParMRLine."Shortcut Dimension 3 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(4, ParMRLine."Shortcut Dimension 4 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(5, ParMRLine."Shortcut Dimension 5 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(6, ParMRLine."Shortcut Dimension 6 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(7, ParMRLine."Shortcut Dimension 7 Code");
        // lRecItemJournalLine.ValidateShortcutDimCode(8, ParMRLine."Shortcut Dimension 8 Code");
        lRecItemJournalLine.Validate("Unit Group", ParMRLine."Unit Group");
        lRecItemJournalLine.Validate("MR Usage Category", ParMRLine."MR Usage Category");
        // lRecItemJournalLine."Remarks MR Line":=ParMRLine.Remarks;
        // lRecItemJournalLine.Hourmeter:=ParMRLine.Hourmeter;
        // lRecItemJournalLine.Kilometer:=ParMRLine.Kilometer;
        lRecItemJournalLine.MODIFY(TRUE);
        updOutstandingQtyMR(ParMRLine, lRecItemJournalLine.RecordID, ParMRLine."Outstanding Quantity");
    end;
    // procedure createItemJournalLine_MR(parMRHeader: Record "Material Req. Header")
    // var
    //     lRecMRLine: Record "Material Req. Line";
    //     lRecItemJournalLine: Record "Item Journal Line";
    //     lRecMSISetup: Record "MSI Setup";
    //     LineNo: Integer;
    // begin
    //     lRecMSISetup.GET();
    //     lRecMSISetup.TestField("Item Journal Template MR");
    //     lRecMSISetup.TestField("Item Journal Batch MR");
    //     lRecMSISetup.TestField("Item Journal Document Nos");
    //     IF checkMRLinePPH22hasOutstanding(parMRHeader."Material Req. No.") THEN BEGIN
    //         lRecMRLine.RESET;
    //         lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", parMRHeader."Material Req. No.");
    //         lRecMRLine.SETFILTER(lRecMRLine."Outstanding Quantity", '>%1', 0);
    //         lRecMRLine.SETRANGE(lRecMRLine."PPH 22", TRUE);
    //         IF lRecMRLine.FIND('-') THEN BEGIN
    //             REPEAT
    //                 lRecItemJournalLine.INIT;
    //                 lRecItemJournalLine."Journal Template Name" := lRecMSISetup."Item Journal Template MR";
    //                 lRecItemJournalLine."Journal Batch Name" := lRecMSISetup."Item Journal Batch MR";
    //                 lRecItemJournalLine."Line No." := getItemJournalLastLineNo(lRecMSISetup."Item Journal Template MR", lRecMSISetup."Item Journal Batch MR");
    //                 lRecItemJournalLine.INSERT(TRUE);
    //                 lRecItemJournalLine.VALIDATE("Posting Date", parMRHeader."Document Date");
    //                 lRecItemJournalLine."Entry Type" := lRecItemJournalLine."Entry Type"::"Negative Adjmt.";
    //                 lRecItemJournalLine."Serial No." := gRecMSISetup."Item Journal Document Nos";
    //                 lRecItemJournalLine."Document No." := lRecMRLine."Material Req. No.";
    //                 lRecItemJournalLine.VALIDATE("Item No.", lRecMRLine."Item No.");
    //                 lRecItemJournalLine.VALIDATE(Quantity, lRecMRLine."Outstanding Quantity");
    //                 lRecItemJournalLine.VALIDATE("Unit of Measure Code", lRecMRLine."Unit of Measure");
    //                 lRecItemJournalLine.VALIDATE("Location Code", lRecMRLine."Location Code");
    //                 lRecItemJournalLine."Material Req. No." := lRecMRLine."Material Req. No.";
    //                 lRecItemJournalLine."Material Req. Line No." := lRecMRLine."Line No.";
    //                 lRecItemJournalLine."Item Journal MR" := TRUE;
    //                 lRecItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", lRecMRLine."Shortcut Dimension 1 Code");
    //                 lRecItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", lRecMRLine."Shortcut Dimension 2 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(3, lRecMRLine."Shortcut Dimension 3 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(4, lRecMRLine."Shortcut Dimension 4 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(5, lRecMRLine."Shortcut Dimension 5 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(6, lRecMRLine."Shortcut Dimension 6 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(7, lRecMRLine."Shortcut Dimension 7 Code");
    //                 lRecItemJournalLine.ValidateShortcutDimCode(8, lRecMRLine."Shortcut Dimension 8 Code");
    //                 lRecItemJournalLine.MODIFY(TRUE);
    //                 updOutstandingQtyMR(lRecMRLine, lRecItemJournalLine.RecordID, lRecMRLine."Outstanding Quantity")
    //             UNTIL lRecMRLine.NEXT = 0;
    //         END ELSE BEGIN
    //             ERROR('No record to be created to item journal')
    //         END;
    //         COMMIT;
    //         lRecItemJournalLine.RESET;
    //         lRecItemJournalLine.SETRANGE("Journal Template Name", lRecMSISetup."Item Journal Template MR");
    //         lRecItemJournalLine.SETRANGE("Journal Batch Name", lRecMSISetup."Item Journal Batch MR");
    //         IF lRecItemJournalLine.FINDFIRST THEN
    //             Page.RUNMODAL(Page::"Item Journal", lRecItemJournalLine);
    //     END ELSE BEGIN
    //         ERROR('No record to be created to item journal')
    //     END;
    // end;
    local procedure getInvDocLastLineNo(DocNo: Code[20]): Integer
    var
        lRecInvDocLine: Record "Invt. Document Line";
    begin
        lRecInvDocLine.RESET;
        lRecInvDocLine.SETRANGE("Document No.", DocNo);
        IF lRecInvDocLine.FINDLAST THEN
            EXIT(lRecInvDocLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;
    // // ---> TAMBAHKAN PROCEDURE INI <---
    // procedure createTransferOrder_MR(var ParMRHeader: Record "Material Req. Header")
    // var
    //     TransHeader: Record "Transfer Header";
    //     TransLine: Record "Transfer Line";
    //     MRLine: Record "Material Req. Line";
    //     lRecMIISetup: Record "MII Setup";
    //     LineNo: Integer;
    // begin
    //     // 1. Cek Setup MII (Validasi Ganda)
    //     lRecMIISetup.GET();
    //     IF NOT lRecMIISetup."Enable TO from RO" THEN
    //         ERROR('Fitur Create Transfer Order dari Request Order sedang dinonaktifkan di sistem.');

    //     // 2. Validasi Header
    //     ParMRHeader.TestField("Transfer-from Code");
    //     ParMRHeader.TestField("Location Code");
    //     ParMRHeader.TestField("In-Transit Code");

    //     IF ParMRHeader."Transfer-from Code" = ParMRHeader."Location Code" THEN
    //         ERROR('Lokasi asal dan tujuan tidak boleh sama.');

    //     // 3. Create Transfer Header
    //     TransHeader.INIT;
    //     TransHeader.INSERT(TRUE);

    //     TransHeader.VALIDATE("Transfer-from Code", ParMRHeader."Transfer-from Code");
    //     TransHeader.VALIDATE("Transfer-to Code", ParMRHeader."Location Code");
    //     TransHeader.VALIDATE("In-Transit Code", ParMRHeader."In-Transit Code");
    //     TransHeader."External Document No." := ParMRHeader."Material Req. No.";
    //     TransHeader.MODIFY(TRUE);

    //     // 4. Create Transfer Line
    //     MRLine.RESET;
    //     MRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
    //     MRLine.SETFILTER("Outstanding Quantity", '>%1', 0);

    //     IF MRLine.FIND('-') THEN BEGIN
    //         LineNo := 10000;
    //         REPEAT
    //             TransLine.INIT;
    //             TransLine.VALIDATE("Document No.", TransHeader."No.");
    //             TransLine."Line No." := LineNo;
    //             TransLine.INSERT(TRUE);

    //             TransLine.VALIDATE("Item No.", MRLine."Item No.");
    //             TransLine.VALIDATE(Quantity, MRLine."Outstanding Quantity");
    //             TransLine.MODIFY(TRUE);

    //             MRLine."Transfer Order No." := TransHeader."No.";
    //             MRLine.MODIFY;

    //             LineNo += 10000;
    //         UNTIL MRLine.NEXT = 0;
    //     END ELSE BEGIN
    //         ERROR('Tidak ada baris Material Request dengan Outstanding Quantity > 0.');
    //     END;

    //     // 5. Update Status RO 
    //     closedStatus_MR(ParMRHeader."Material Req. No.");

    //     COMMIT;
    //     MESSAGE('Transfer Order %1 berhasil dibuat.', TransHeader."No.");
    //     PAGE.RUN(PAGE::"Transfer Order", TransHeader);
    // end;

    // procedure createTransferOrder_MR(var ParMRHeader: Record "Material Req. Header")
    // var
    //     TransHeader: Record "Transfer Header";
    //     TransLine: Record "Transfer Line";
    //     MRLine: Record "Material Req. Line";
    //     lRecMIISetup: Record "MII Setup";
    //     LineNo: Integer;
    // begin
    //     // 1. Cek Setup MII (Validasi Ganda)
    //     lRecMIISetup.GET();
    //     IF NOT lRecMIISetup."Enable TO from RO" THEN
    //         ERROR('Fitur Create Transfer Order dari Request Order sedang dinonaktifkan di sistem.');

    //     // 2. Validasi Header
    //     ParMRHeader.TestField("Transfer-from Code");
    //     ParMRHeader.TestField("Location Code");
    //     ParMRHeader.TestField("In-Transit Code");

    //     IF ParMRHeader."Transfer-from Code" = ParMRHeader."Location Code" THEN
    //         ERROR('Lokasi asal dan tujuan tidak boleh sama.');

    //     // 3. Create Transfer Header
    //     TransHeader.INIT;
    //     TransHeader.INSERT(TRUE);

    //     TransHeader.VALIDATE("Transfer-from Code", ParMRHeader."Transfer-from Code");
    //     TransHeader.VALIDATE("Transfer-to Code", ParMRHeader."Location Code");
    //     TransHeader.VALIDATE("In-Transit Code", ParMRHeader."In-Transit Code");
    //     TransHeader."External Document No." := ParMRHeader."Material Req. No.";

    //     // Mapping Material Req. No. ke Transfer Header
    //     TransHeader."Material Req. No." := ParMRHeader."Material Req. No.";

    //     TransHeader.MODIFY(TRUE);

    //     // 4. Create Transfer Line
    //     MRLine.RESET;
    //     MRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
    //     MRLine.SETFILTER("Outstanding Quantity", '>%1', 0);

    //     IF MRLine.FIND('-') THEN BEGIN
    //         LineNo := 10000;
    //         REPEAT
    //             TransLine.INIT;
    //             TransLine.VALIDATE("Document No.", TransHeader."No.");
    //             TransLine."Line No." := LineNo;
    //             TransLine.INSERT(TRUE);

    //             TransLine.VALIDATE("Item No.", MRLine."Item No.");
    //             TransLine.VALIDATE(Quantity, MRLine."Outstanding Quantity");

    //             // Mapping Material Req. No. & Line No. ke Transfer Line
    //             TransLine."Material Req. No." := MRLine."Material Req. No.";
    //             TransLine."Material Req. Line No." := MRLine."Line No.";

    //             TransLine.MODIFY(TRUE);

    //             // Update RO Line agar mencatat TO
    //             MRLine."Transfer Order No." := TransHeader."No.";
    //             MRLine.MODIFY;

    //             LineNo += 10000;
    //         UNTIL MRLine.NEXT = 0;
    //     END ELSE BEGIN
    //         ERROR('Tidak ada baris Material Request dengan Outstanding Quantity > 0.');
    //     END;

    //     // 5. Update Status RO 
    //     closedStatus_MR(ParMRHeader."Material Req. No.");

    //     COMMIT;
    //     MESSAGE('Transfer Order %1 berhasil dibuat.', TransHeader."No.");
    //     PAGE.RUN(PAGE::"Transfer Order", TransHeader);
    // end;

    // procedure createTransferOrder_MR(var ParMRHeader: Record "Material Req. Header")
    // var
    //     TransHeader: Record "Transfer Header";
    //     TransLine: Record "Transfer Line";
    //     MRLine: Record "Material Req. Line";
    //     lRecMIISetup: Record "MII Setup";
    //     lRecItem: Record Item; // Variabel baru untuk cek stok master item
    //     LineNo: Integer;
    // begin
    //     // 1. Cek Setup MII (Validasi Ganda)
    //     lRecMIISetup.GET();
    //     IF NOT lRecMIISetup."Enable TO from RO" THEN
    //         ERROR('Fitur Create Transfer Order dari Request Order sedang dinonaktifkan di sistem.');

    //     // 2. Validasi Header
    //     ParMRHeader.TestField("Transfer-from Code");
    //     ParMRHeader.TestField("Location Code");
    //     ParMRHeader.TestField("In-Transit Code");

    //     IF ParMRHeader."Transfer-from Code" = ParMRHeader."Location Code" THEN
    //         ERROR('Lokasi asal dan tujuan tidak boleh sama.');

    //     // 3. --- VALIDASI INVENTORY WAJIB PR ---
    //     MRLine.RESET;
    //     MRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
    //     MRLine.SETFILTER("Outstanding Quantity", '>%1', 0);

    //     IF MRLine.FINDSET() THEN BEGIN
    //         REPEAT
    //             // Tarik data langsung dari Master Item
    //             IF lRecItem.GET(MRLine."Item No.") THEN BEGIN
    //                 // Filter stok khusus di Gudang Asal (Central Kitchen)
    //                 lRecItem.SETFILTER("Location Filter", ParMRHeader."Transfer-from Code");
    //                 lRecItem.CALCFIELDS(Inventory);

    //                 // Logika: Jika stok 0 (atau minus), tolak TO dan wajibkan buat PR
    //                 IF lRecItem.Inventory <= 0 THEN
    //                     ERROR('Stok untuk Item %1 di Gudang Asal (%2) kosong. Anda WAJIB membuat Purchase Request.', MRLine."Item No.", ParMRHeader."Transfer-from Code");

    //                 // (Opsional) Jika Anda ingin mewajibkan PR ketika stok KURANG dari yang di-request, 
    //                 // buka comment code di bawah ini:
    //                 // IF lRecItem.Inventory < MRLine."Outstanding Quantity" THEN
    //                 //     ERROR('Stok Item %1 di Gudang %2 tidak cukup (Sisa: %3). Anda WAJIB membuat Purchase Request.', MRLine."Item No.", ParMRHeader."Transfer-from Code", lRecItem.Inventory);
    //             END;
    //         UNTIL MRLine.NEXT() = 0;
    //     END ELSE BEGIN
    //         ERROR('Tidak ada baris Material Request dengan Outstanding Quantity > 0.');
    //     END;
    //     // ---------------------------------------

    //     // 4. Create Transfer Header
    //     TransHeader.INIT;
    //     TransHeader.INSERT(TRUE);

    //     TransHeader.VALIDATE("Transfer-from Code", ParMRHeader."Transfer-from Code");
    //     TransHeader.VALIDATE("Transfer-to Code", ParMRHeader."Location Code");
    //     TransHeader.VALIDATE("In-Transit Code", ParMRHeader."In-Transit Code");
    //     TransHeader."External Document No." := ParMRHeader."Material Req. No.";

    //     // Mapping Material Req. No. ke Transfer Header
    //     TransHeader."Material Req. No." := ParMRHeader."Material Req. No.";

    //     TransHeader.MODIFY(TRUE);

    //     // 5. Create Transfer Line
    //     MRLine.RESET; // Reset ulang filter MRLine untuk proses insert
    //     MRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
    //     MRLine.SETFILTER("Outstanding Quantity", '>%1', 0);

    //     IF MRLine.FIND('-') THEN BEGIN
    //         LineNo := 10000;
    //         REPEAT
    //             TransLine.INIT;
    //             TransLine.VALIDATE("Document No.", TransHeader."No.");
    //             TransLine."Line No." := LineNo;
    //             TransLine.INSERT(TRUE);

    //             TransLine.VALIDATE("Item No.", MRLine."Item No.");
    //             TransLine.VALIDATE(Quantity, MRLine."Outstanding Quantity");

    //             // Mapping Material Req. No. & Line No. ke Transfer Line
    //             TransLine."Material Req. No." := MRLine."Material Req. No.";
    //             TransLine."Material Req. Line No." := MRLine."Line No.";

    //             TransLine.MODIFY(TRUE);

    //             // Update RO Line agar mencatat TO
    //             MRLine."Transfer Order No." := TransHeader."No.";
    //             MRLine.MODIFY;

    //             LineNo += 10000;
    //         UNTIL MRLine.NEXT = 0;
    //     END;

    //     // 6. Update Status RO 
    //     closedStatus_MR(ParMRHeader."Material Req. No.");

    //     COMMIT;
    //     MESSAGE('Transfer Order %1 berhasil dibuat.', TransHeader."No.");
    //     PAGE.RUN(PAGE::"Transfer Order", TransHeader);
    // end;

    procedure createTransferOrder_MR(var ParMRHeader: Record "Material Req. Header")
    var
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        MRLine: Record "Material Req. Line";
        lRecMIISetup: Record "MII Setup";
        lRecItem: Record Item;
        LineNo: Integer;
        LineCreated: Integer; // Tambahan: Menghitung baris yang berhasil dibuat
        SkippedItems: Text;   // Tambahan: Menampung item yang di-skip karena 0 stock
    begin
        // 1. Cek Setup MII (Validasi Ganda)
        lRecMIISetup.GET();
        IF NOT lRecMIISetup."Enable TO from RO" THEN
            ERROR('Fitur Create Transfer Order dari Request Order sedang dinonaktifkan di sistem.');

        // 2. Validasi Header
        ParMRHeader.TestField("Transfer-from Code");
        ParMRHeader.TestField("Location Code");
        ParMRHeader.TestField("In-Transit Code");

        IF ParMRHeader."Transfer-from Code" = ParMRHeader."Location Code" THEN
            ERROR('Lokasi asal dan tujuan tidak boleh sama.');

        // 3. Create Transfer Header (Pindahkan ke atas)
        TransHeader.INIT;
        TransHeader.INSERT(TRUE);

        TransHeader.VALIDATE("Transfer-from Code", ParMRHeader."Transfer-from Code");
        TransHeader.VALIDATE("Transfer-to Code", ParMRHeader."Location Code");
        TransHeader.VALIDATE("In-Transit Code", ParMRHeader."In-Transit Code");
        TransHeader."External Document No." := ParMRHeader."Material Req. No.";
        TransHeader."Material Req. No." := ParMRHeader."Material Req. No.";
        TransHeader.MODIFY(TRUE);

        // 4. Create Transfer Line & Filter Stok
        MRLine.RESET;
        MRLine.SETRANGE("Material Req. No.", ParMRHeader."Material Req. No.");
        MRLine.SETFILTER("Outstanding Quantity", '>%1', 0);

        LineCreated := 0;
        SkippedItems := '';

        IF MRLine.FINDSET() THEN BEGIN
            LineNo := 10000;
            REPEAT
                // Tarik data langsung dari Master Item
                IF lRecItem.GET(MRLine."Item No.") THEN BEGIN
                    lRecItem.SETFILTER("Location Filter", ParMRHeader."Transfer-from Code");
                    lRecItem.CALCFIELDS(Inventory);

                    // LOGIKA BARU: Jika stok ADA, buatkan Transfer Line
                    IF lRecItem.Inventory > 0 THEN BEGIN
                        TransLine.INIT;
                        TransLine.VALIDATE("Document No.", TransHeader."No.");
                        TransLine."Line No." := LineNo;
                        TransLine.INSERT(TRUE);

                        TransLine.VALIDATE("Item No.", MRLine."Item No.");

                        // [SIHIR TAMBAHAN] Jika stok < dari permintaan, transfer sesuai stok yang ada saja!
                        IF lRecItem.Inventory < MRLine."Outstanding Quantity" THEN
                            TransLine.VALIDATE(Quantity, lRecItem.Inventory)
                        ELSE
                            TransLine.VALIDATE(Quantity, MRLine."Outstanding Quantity");

                        TransLine."Material Req. No." := MRLine."Material Req. No.";
                        TransLine."Material Req. Line No." := MRLine."Line No.";
                        TransLine.MODIFY(TRUE);

                        // Update RO Line agar mencatat TO
                        MRLine."Transfer Order No." := TransHeader."No.";
                        MRLine.MODIFY;

                        LineNo += 10000;
                        LineCreated += 1; // Tambah counter keberhasilan
                    END ELSE BEGIN
                        // LOGIKA BARU: Jika stok KOSONG, tampung namanya, JANGAN di-Error!
                        IF SkippedItems = '' THEN
                            SkippedItems := MRLine."Item No."
                        ELSE
                            SkippedItems += ', ' + MRLine."Item No.";
                    END;
                END;
            UNTIL MRLine.NEXT() = 0;
        END ELSE BEGIN
            TransHeader.DELETE(TRUE); // Bersihkan sampah header jika tidak ada Line
            ERROR('Tidak ada baris Material Request dengan Outstanding Quantity > 0.');
        END;

        // 5. Validasi Final: Jika semua item ternyata stoknya 0, batalkan TO-nya
        IF LineCreated = 0 THEN BEGIN
            TransHeader.DELETE(TRUE); // Hapus Header yang terlanjur dibuat
            ERROR('Gagal! Semua item yang di-request tidak memiliki stok di Gudang %1. Silakan buat Purchase Request.', ParMRHeader."Transfer-from Code");
        END;

        // 6. Update Status RO 
        closedStatus_MR(ParMRHeader."Material Req. No.");

        COMMIT;

        // 7. Pesan Manis untuk User
        IF SkippedItems <> '' THEN
            MESSAGE('Transfer Order %1 dibuat PARSIAL.\n\nINFO: Item berikut tidak diproses karena stok di Gudang Asal kosong (Wajib PR): %2', TransHeader."No.", SkippedItems)
        ELSE
            MESSAGE('Transfer Order %1 berhasil dibuat full.', TransHeader."No.");

        PAGE.RUN(PAGE::"Transfer Order", TransHeader);
    end;

    local procedure getItemJournalLastLineNo(parTemplate: Code[10]; parBatch: Code[10]): Integer
    var
        lRecItemJournal: Record "Item Journal Line";
    begin
        lRecItemJournal.RESET;
        lRecItemJournal.SETRANGE("Journal Template Name", parTemplate);
        lRecItemJournal.SETRANGE("Journal Batch Name", parBatch);
        IF lRecItemJournal.FINDLAST THEN
            EXIT(lRecItemJournal."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

    procedure getItemJournalDocNo(parTemplate: Code[10]; parBatch: Code[10]): Code[20]
    var
        lRecItemJournal: Record "Item Journal Line";
    begin
        lRecItemJournal.RESET;
        lRecItemJournal.SETRANGE("Journal Template Name", parTemplate);
        lRecItemJournal.SETRANGE("Journal Batch Name", parBatch);
        lRecItemJournal.SETRANGE("Item Journal MR", TRUE);
        IF lRecItemJournal.FINDLAST THEN EXIT(lRecItemJournal."Document No.");
        exit('');
    end;
    //CreateDoc
    var
        gRecMSISetup: Record "MII Setup";
        //gCUNoSeriesMgt: Codeunit NoSeriesManagement;
        NOSeries: Codeunit "No. Series";
        gCUMSIFunct: Codeunit "MII Function";
}
