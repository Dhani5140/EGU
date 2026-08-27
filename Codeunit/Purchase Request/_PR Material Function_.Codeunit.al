codeunit 50104 "PR Material Function"
{
    trigger OnRun()
    begin
    end;

    procedure MANDATORYPRHEADER(PRHRADER: Record "PR Material Header")
    var
    BEGIN
        //PRHRADER.TestField("Vendor No");

    END;
    //Check
    procedure checkPRLinehasRFQ(PRNo: Code[20]; msgErr: Text)
    var
        lRecPRLine: Record "PR Material Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.CalcFields("Total Qty on RFQ");
        lRecPRLine.SETRANGE("Purchase Req. No.", PRNo);
        lRecPRLine.SETFILTER("Total Qty on RFQ", '>%1', 0);
        IF lRecPRLine.FINDFIRST THEN BEGIN
            ERROR('Purchase Request Line %1 already has RFQ, cannot %2', lRecPRLine."Line No.", msgErr)
        END;
    end;

    procedure checkPRLinehasOutstanding(PRNo: Code[20]): Boolean
    var
        lRecPRLine: Record "PR Material Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", PRNo);
        lRecPRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        IF lRecPRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;
    //Check
    //UpdateOutsanding
    procedure updOutstandingQtyPR(var ParPRLine: Record "PR Material Line"; fromRecordID: RecordID; QtytoUpd: Decimal)
    var
        lRecPRHeader: Record "PR Material Header";
        lRecPRLine: Record "PR Material Line";
        lRecPurchaseLine: Record "Purchase Line";
        lRecRFQLine: Record "RFQ Line";
        lDecTotalRFQQty: Decimal;
        lDecOutstandingQty: Decimal;
        fromRecRef: RecordRef;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalRFQQty);
        CLEAR(lDecOutstandingQty);
        CLEAR(fromRecRef);
        CASE fromRecordID.TableNo OF
            database::"RFQ Line":
                BEGIN
                    lRecRFQLine.RESET;
                    lRecRFQLine.SETRANGE(lRecRFQLine."Purchase Req. No.", ParPRLine."Purchase Req. No.");
                    lRecRFQLine.SETRANGE(lRecRFQLine."Purchase Req. Line No.", ParPRLine."Line No.");
                    IF lRecRFQLine.FIND('-') THEN BEGIN
                        lRecRFQLine.CalcSums(Quantity);
                        lDecTotalRFQQty := ABS(lRecRFQLine.Quantity);
                    END;
                    lRecRFQLine.RESET;
                    lRecRFQLine.GET(fromRecordID);
                    lDecTotalRFQQty := lDecTotalRFQQty - lRecRFQLine.Quantity;
                END;
        END;
        lDecTotalRFQQty := ABS(lDecTotalRFQQty);
        lDecOutstandingQty := ParPRLine.Quantity - lDecTotalRFQQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParPRLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParPRLine."Outstanding Quantity" := 0;
        END;
        ParPRLine.MODIFY;
        // END;
        closedStatus_PRMaterial(ParPRLine."Purchase Req. No.");
    end;

    procedure closedStatus_PRMaterial(PRNo: Code[20])
    var
        lRecPRHeader: Record "PR Material Header";
        lRecPRLine: Record "PR Material Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        statusInt := 0;
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRNo);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecPRLine.Quantity > lRecPRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecPRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecPRLine.NEXT = 0);
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
            lRecPRHeader.RESET;
            lRecPRHeader.SETRANGE(lRecPRHeader."Purchase Req. No.", PRNo);
            IF lRecPRHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Released);
                    2:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Processed);
                    3:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Closed);
                END;
                lRecPRHeader.MODIFY;
            END;
        END;
    end;
    //UpdateOutsanding
    //Create PO
    procedure createPOHeader_PR(var ParPRHeader: Record "PR Material Header")
    var
        PurchHeaderIns: Record "Purchase Header";
        PurchLineView: Record "Purchase Line";
        lRecPRLine: Record "PR Material Line";
        lRecVendor: Record Vendor;
        BatchNo: Integer;
        lRecNoSeries: Record "No. Series";
        //lRecPurchSetup: Record "Purchases & Payables Setup";
        CurrVendorNo: Code[20];
        StatusInt: Integer;
        currPRNo: Code[20];
        currPRNoAdditionalLine: Code[20];
        OutstandingQty: Decimal;
    begin
        CLEAR(StatusInt);
        //CLEAR(WHTBusVendor);
        CLEAR(currPRNoAdditionalLine);
        gRecMSISetup.GET();

        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParPRHeader."No. Series");
        lRecNoSeries.TESTFIELD("Purchase Order Nos.");
        BatchNo := ParPRHeader."Batch No. [PR]" + 1;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", ParPRHeader."Purchase Req. No.");
        lRecPRLine.SETFILTER("Vendor No.", '<>%1', '');
        lRecPRLine.SETFILTER(Quantity, '>%1', 0);
        lRecPRLine.SetCurrentKey("Vendor No.");
        lRecPRLine.Ascending(TRUE);
        IF lRecPRLine.FIND('-') THEN BEGIN
            repeat
                //lRecPRLine.CalcFields(Quantity);
                IF lRecPRLine.Quantity <= OutstandingQty THEN BEGIN
                    IF CurrVendorNo <> ParPRHeader."Vendor No" THEN BEGIN
                        lRecVendor.RESET;
                        lRecVendor.GET(ParPRHeader."Vendor No");
                        lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
                        PurchHeaderIns.INIT;
                        PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
                        PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
                        // PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
                        PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.", WorkDate(), true);
                        PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
                        PurchHeaderIns.VALIDATE("Buy-from Vendor No.", ParPRHeader."Vendor No");
                        PurchHeaderIns.INSERT(TRUE);
                        //PurchHeaderIns.Validate("Expected Receipt Date", ParPRHeader."Expected Completion Date");
                        // if ParPRHeader."Currency Code" <> '' then
                        //     PurchHeaderIns.Validate("Currency Code", ParPRHeader."Currency Code");
                        PurchHeaderIns."Purchase Req. No." := PurchHeaderIns."Purchase Req. No.";
                        PurchHeaderIns.Modify(True);
                        createPOLine_RFQ(lRecPRLine, PurchHeaderIns."No.", BatchNo);
                    END;
                END ELSE BEGIN
                    createPOLine_RFQ(lRecPRLine, PurchHeaderIns."No.", BatchNo);
                END;
                CurrVendorNo := lRecPRLine."Vendor No.";
            UNTIL lRecPRLine.NEXT = 0;
        END ELSE BEGIN
            ERROR('No PR Material Line to be found for create PO');
        END;

        ParPRHeader.MODIFY;
        COMMIT;
        CLEAR(currPRNo);
        PurchLineView.RESET;
        PurchLineView.SETRANGE(PurchLineView."Purchase Req. No.", ParPRHeader."Purchase Req. No.");
        PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
        PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
        PurchLineView.Ascending(TRUE);
        IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    end;

    // New Replacement PR
    procedure CreateReplacementPR(var OldPRHeader: Record "PR Material Header")
    var
        NewPRHeader: Record "PR Material Header";
        OldPRLine: Record "PR Material Line";
        NewPRLine: Record "PR Material Line";
    begin
        // 1. Validasi: PR Lama harus sudah Released
        if not (OldPRHeader.Status in [OldPRHeader.Status::Released, OldPRHeader.Status::"Pending Approval", OldPRHeader.Status::Closed]) then
            Error('Hanya PR dengan status Released, Pending Approval, atau Closed yang bisa di-Replace.');

        // 2. Buat Header PR Baru
        NewPRHeader.Init();
        NewPRHeader.Insert(true); // Memanggil trigger OnInsert untuk generate No. PR Baru

        // 3. Salin data penting dari Header PR lama
        NewPRHeader.Validate("Location Code", OldPRHeader."Location Code");
        NewPRHeader.Validate("Vendor No", OldPRHeader."Vendor No");
        NewPRHeader.Validate("Shortcut Dimension 1 Code", OldPRHeader."Shortcut Dimension 1 Code");
        NewPRHeader.Validate("Shortcut Dimension 2 Code", OldPRHeader."Shortcut Dimension 2 Code");
        NewPRHeader.Remarks := CopyStr('Replacement untuk PR: ' + OldPRHeader."Purchase Req. No.", 1, 250);

        // 4. Set Flag Replacement & Referensi
        NewPRHeader."PR Type" := NewPRHeader."PR Type"::Replacement;
        NewPRHeader."Replaced PR No." := OldPRHeader."Purchase Req. No.";
        NewPRHeader.Modify(true);

        // 5. Salin Baris (Lines) dari PR Lama ke PR Baru
        OldPRLine.Reset();
        OldPRLine.SetRange("Purchase Req. No.", OldPRHeader."Purchase Req. No.");
        if OldPRLine.FindSet() then begin
            repeat
                NewPRLine.Init();
                NewPRLine.TransferFields(OldPRLine); // Copy semua data line

                // Ganti referensi header ke PR Baru
                NewPRLine."Purchase Req. No." := NewPRHeader."Purchase Req. No.";

                // Reset field kuantitas transaksional (karena ini dokumen draf baru)
                NewPRLine.Quantity := OldPRLine.Quantity;
                NewPRLine."Qty to PO" := OldPRLine.Quantity;
                NewPRLine."Outstanding Quantity" := OldPRLine.Quantity;
                NewPRLine."Total Qty On RFQ" := 0;
                NewPRLine."Total Qty On PO" := 0;

                NewPRLine.Insert(true);
            until OldPRLine.Next() = 0;
        end;

        // 6. Matikan PR Lama (Ubah Status ke Canceled Replacement)
        OldPRHeader.Status := OldPRHeader.Status::"Canceled Replacement";
        OldPRHeader.Modify(true);

        // 7. Buka halaman PR Baru untuk User
        Message('PR Replacement berhasil dibuat dengan No. %1.\nPR lama (%2) telah dibatalkan.', NewPRHeader."Purchase Req. No.", OldPRHeader."Purchase Req. No.");
        Page.Run(Page::"PR Material Card", NewPRHeader);
    end;


    // procedure createPOLine_PR(ParPRLine: Record "PR Material Line"; PONo: Code[20]; BatchNo: Integer)
    // var
    //     PurchLineIns: Record "Purchase Line";
    // begin
    //     PurchLineIns.INIT;
    //     PurchLineIns."Document Type" := PurchLineIns."Document Type"::Order;
    //     PurchLineIns."Document No." := PONo;
    //     PurchLineIns."Line No." := getPOLastLineNo(PONo);
    //     PurchLineIns.INSERT(TRUE);

    //     IF PurchLineIns.Type <> PurchLineIns.Type::" " then BEGIN
    //         PurchLineIns.Validate("No.", ParPRLine."Item No.");
    //         PurchLineIns.Validate(Quantity, ParPRLine."Outstanding Quantity");
    //         PurchLineIns.VALIDATE("Direct Unit Cost", ParPRLine."Direct Unit Cost");
    //     END;
    //     PurchLineIns.Description := ParPRLine.Description;
    //     PurchLineIns.VALIDATE("Unit of Measure", ParPRLine."Unit of Measure");
    //     PurchLineIns.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
    //     PurchLineIns.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
    //     PurchLineIns.Validate("Material Req. No.", ParPRLine."Material Req. No.");
    //     PurchLineIns.Validate("Material Req. Line No.", ParPRLine."Material Req. Line No.");
    //     PurchLineIns.MODIFY(TRUE);
    //     //updOutstandingQtyPR(ParPRLine, PurchLineIns.RecordId, ParPRLine."Outstanding Quantity", FALSE);
    // end;
    //Create PO
    // //Create PO

    // procedure createPOHeader_RFQ(var ParRFQHeader: Record "PR Material Header")
    // var
    //     PurchHeaderIns: Record "Purchase Header";
    //     PurchLineView: Record "Purchase Line";
    //     lRecRFQLine: Record "PR Material Line";
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
    //     lRecRFQLine.SETRANGE("Purchase Req. No.", ParRFQHeader."Purchase Req. No.");
    //     lRecRFQLine.SETFILTER("Vendor No", '<>%1', '');
    //     lRecRFQLine.SETFILTER(Quantity, '>%1', 0);
    //     lRecRFQLine.SetCurrentKey("Vendor No");
    //     lRecRFQLine.Ascending(TRUE);
    //     IF lRecRFQLine.FIND('-') THEN BEGIN
    //         REPEAT
    //             //lRecRFQLine.CalcFields(Quantity);

    //             CLEAR(OutstandingQty);
    //             IF CurrVendorNo <> lRecRFQLine."Vendor No" THEN BEGIN
    //                 lRecVendor.RESET;
    //                 lRecVendor.GET(lRecRFQLine."Vendor No");
    //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
    //                 lRecRFQLine.RESET;
    //                 lRecRFQLine.GET(lRecRFQLine."Purchase Req. No.", lRecRFQLine."Purchase Req. No.");
    //                 PurchHeaderIns.INIT;
    //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
    //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
    //                 PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
    //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecRFQLine."Vendor No");
    //                 PurchHeaderIns.INSERT(TRUE);
    //                 PurchHeaderIns.VALIDATE("Document Date", ParRFQHeader."Document Date");
    //                 PurchHeaderIns.VALIDATE("Location Code", lRecRFQLine."Location Code");
    //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
    //                 PurchHeaderIns.VALIDATE("Payment Terms Code", lRecRFQVendor."Payment Terms Code");
    //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
    //                 PurchHeaderIns.VALIDATE("Shipment Method Code", lRecRFQVendor."Shipment Method Code");
    //                 PurchHeaderIns.VALIDATE("Tanggal Surat Jalan", lRecRFQVendor."Shipping Date");
    //                 PurchHeaderIns."Purchase Req. No." := lRecRFQLine."Purchase Req. No.";
    //                 PurchHeaderIns."Material Req. No." := lRecRFQLine."Material Req. No.";
    //                 PurchHeaderIns.MODIFY(TRUE);
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END
    //             ELSE BEGIN
    //                 createPOLine_RFQ(lRecRFQLine, PurchHeaderIns."No.", BatchNo);
    //             END;
    //             CurrVendorNo := lRecRFQLine."Vendor No";
    //         UNTIL lRecRFQLine.NEXT = 0;
    //     END
    //     ELSE BEGIN
    //         ERROR('No PR Line to be found for create PO');
    //     END;

    //     ParRFQHeader.MODIFY;
    //     COMMIT;
    //     PurchLineView.RESET;
    //     PurchLineView.SETRANGE(PurchLineView."Purchase Req. No.", ParRFQHeader."Purchase Req. No.");
    //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
    //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
    //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    // end;

    procedure createPOLine_RFQ(ParRFQLine: Record "PR Material Line"; PONo: Code[20]; BatchNo: Integer)
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
        // ParRFQLine."Type"::"Charge (Item)":
        //     begin
        //         PurchLineIns.Validate(Type, PurchLineIns.Type::"Charge (Item)");
        //     end;
        end;

        PurchLineIns.Validate("No.", ParRFQLine."Item No.");
        PurchLineIns.Validate(Quantity, ParRFQLine.Quantity);
        // PurchLineIns.VALIDATE("Direct Unit Cost", ParRFQLine."Unit Price");
        //PurchLineIns.VALIDATE("Line Discount %", ParRFQLine."Discount %");
        IF ParRFQLine."Purchase Req. No." <> '' THEN
            PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::Item
        ELSE
            PurchLineIns."PR Line Type" := PurchLineIns."PR Line Type"::" ";
        PurchLineIns.Description := ParRFQLine.Description;
        PurchLineIns.VALIDATE("Unit of Measure", ParRFQLine."Unit of Measure");
        //PurchLineIns.VALIDATE("VAT Bus. Posting Group", ParRFQLine."VAT Bus. Posting Group");
        //PurchLineIns.VALIDATE("VAT Prod. Posting Group", ParRFQLine."VAT Prod. Posting Group");



        PurchLineIns.Validate("Part No.", ParRFQLine."Part No.");
        PurchLineIns.Validate("Purchase Req. No.", ParRFQLine."Purchase Req. No.");
        PurchLineIns.Validate("Purchase Req. Line No.", ParRFQLine."Line No.");
        PurchLineIns.Validate("Material Req. No.", ParRFQLine."Material Req. No.");
        PurchLineIns.Validate("Material Req. Line No.", ParRFQLine."Material Req. Line No.");
        // PurchLineIns.Validate("RFQ No.", ParRFQLine."RFQ No.");
        // PurchLineIns.Validate("RFQ Line No.", ParRFQLine."Line No.");
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
        //PurchLineIns.PBBKB := ParRFQLine.PBBKB;
        PurchLineIns.MODIFY(TRUE);
        //updOutstandingQtyRFQ(ParRFQLine, PurchLineIns.RecordID, ParRFQLine."Qty to PO", TRUE)
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

    //CreateDoc
    procedure createPRHeader_MR(var ParMRHeader: Record "Material Req. Header")
    var
        lRecMRLine: Record "Material Req. Line";
        lRecPRHeader: Record "PR Material Header";
        lRecNoSeries: Record "No. Series";
    begin
        gRecMSISetup.GET;
        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParMRHeader."No. Series");
        lRecNoSeries.TESTFIELD("PR Material Nos.");
        IF gCUMRFunct.checkMRLinehasOutstanding(ParMRHeader."Material Req. No.") THEN BEGIN
            lRecPRHeader.INIT;
            //lRecPRHeader."Purchase Req. No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."PR Material Nos.", WorkDate(), true);
            lRecPRHeader."Purchase Req. No." := NoSeries.GetNextNo(lRecNoSeries."PR Material Nos.", WorkDate(), true);
            lRecPRHeader.INSERT(TRUE);
            lRecPRHeader.VALIDATE("No. Series", lRecNoSeries."PR Material Nos.");
            IF ParMRHeader.RequesterID <> '' THEN lRecPRHeader.VALIDATE(RequesterID, ParMRHeader.RequesterID);
            lRecPRHeader.VALIDATE("Requester Name", ParMRHeader."Requester Name");
            lRecPRHeader.VALIDATE("Request Date", WORKDATE);
            lRecPRHeader.VALIDATE("Location Code", ParMRHeader."Location Code");
            lRecPRHeader."External Document No." := ParMRHeader."Material Req. No.";
            lRecPRHeader.VALIDATE("Shortcut Dimension 1 Code", ParMRHeader."Shortcut Dimension 1 Code");
            lRecPRHeader.VALIDATE("Shortcut Dimension 2 Code", ParMRHeader."Shortcut Dimension 2 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 3 Code", ParMRHeader."Shortcut Dimension 3 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 4 Code", ParMRHeader."Shortcut Dimension 4 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 5 Code", ParMRHeader."Shortcut Dimension 5 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 6 Code", ParMRHeader."Shortcut Dimension 6 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 7 Code", ParMRHeader."Shortcut Dimension 7 Code");
            //lRecPRHeader.VALIDATE("Shortcut Dimension 8 Code", ParMRHeader."Shortcut Dimension 8 Code");
            lRecPRHeader."Material Req. No." := ParMRHeader."Material Req. No.";
            lRecPRHeader.MODIFY(TRUE);
            lRecMRLine.RESET;
            lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", ParMRHeader."Material Req. No.");
            lRecMRLine.SETFILTER(lRecMRLine."Outstanding Quantity", '>%1', 0);
            IF lRecMRLine.FIND('-') THEN BEGIN
                REPEAT
                    createPRLine_MR(lRecMRLine, lRecPRHeader."Purchase Req. No.");
                UNTIL lRecMRLine.NEXT = 0;
            END;
            COMMIT;
            Page.RUN(Page::"PR Material Card", lRecPRHeader);
        END;
    end;

    procedure CreatePRLine_MR(MRLine: Record "Material Req. Line"; DocNo: Code[20])
    var
        lrecPRLine: Record "PR Material Line";
    begin
        lrecPRLine.Init();
        lrecPRLine."Purchase Req. No." := DocNo;
        lrecPRLine."Line No." := getPRLastLineNo(DocNo);
        lrecPRLine.INSERT(TRUE);
        lrecPRLine.Validate(Type, MRLine.Type);
        lrecPRLine.Validate("Item No.", MRLine."Item No.");
        lrecPRLine.Validate(Quantity, MRLine."Outstanding Quantity");
        lrecPRLine.Validate("Original Qty MR", MRLine.Quantity);
        lrecPRLine.Validate("Direct Unit Cost", MRLine."Direct Unit Cost");
        lrecPRLine.Validate("Location Code", MRLine."Location Code");
        lrecPRLine.Validate("Unit of Measure", MRLine."Unit of Measure");
        lrecPRLine.Validate("Part No.", MRLine."Part No.");
        lrecPRLine.Validate("Material Req. No.", MRLine."Material Req. No.");
        lrecPRLine.Validate("Material Req. Line No.", MRLine."Line No.");
        lrecPRLine.VALIDATE("Location Code", MRLine."Location Code");
        lrecPRLine.VALIDATE("Shortcut Dimension 1 Code", MRLine."Shortcut Dimension 1 Code");
        lrecPRLine.VALIDATE("Shortcut Dimension 2 Code", MRLine."Shortcut Dimension 2 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 3 Code", MRLine."Shortcut Dimension 3 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 4 Code", MRLine."Shortcut Dimension 4 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 5 Code", MRLine."Shortcut Dimension 5 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 6 Code", MRLine."Shortcut Dimension 6 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 7 Code", MRLine."Shortcut Dimension 7 Code");
        // lrecPRLine.VALIDATE("Shortcut Dimension 8 Code", MRLine."Shortcut Dimension 8 Code");
        lrecPRLine.MODIFY(TRUE);

    end;

    procedure changeColorStyleUrgent(var parPRHeader: Record "PR Material Header"): Text[50]
    begin
        CASE parPRHeader."Urgent Status" OF
            parPRHeader."Urgent Status"::Low:
                Exit('Favorable');
            parPRHeader."Urgent Status"::Medium:
                Exit('Ambiguous');
            parPRHeader."Urgent Status"::High:
                Exit('Unfavorable');
        END;
        Exit('Standard')
    end;

    local procedure getPRLastLineNo(DocNo: Code[20]): Integer
    var
        lrecPRLine: Record "PR Material Line";
    begin
        lrecPRLine.RESET();
        lrecPRLine.SetRange("Purchase Req. No.", DocNo);
        IF lrecPRLine.FindLast() then
            EXIT(lrecPRLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;
    //CreateDoc


    //NEW
    //UpdateOutsanding
    //Create PO
    // procedure createPOHeader_PRMAT(var ParPRHeader: Record "PR Material Header")
    // var
    //     PurchHeaderIns: Record "Purchase Header";
    //     PurchLineView: Record "Purchase Line";
    //     lRecPRLine: Record "PR Material Line";
    //     lRecVendor: Record Vendor;
    //     lRecPurchSetup: Record "Purchases & Payables Setup";
    //     lRecNoSeries: Record "No. Series";
    //     CurrVendorNo: Code[20];
    //     StatusInt: Integer;
    //     currPRNo: Code[20];
    //     currPRNoAdditionalLine: Code[20];
    //     OutstandingQty: Decimal;
    //     BatchNo: Integer;
    // begin
    //     CLEAR(StatusInt);
    //     CLEAR(currPRNoAdditionalLine);
    //     CLEAR(CurrVendorNo);
    //     ParPRHeader.TestField("Vendor No");
    //     lrecPurchSetup.GET();
    //     gRecMSISetup.GET();
    //     lRecNoSeries.RESET;
    //     lRecNoSeries.GET(ParPRHeader."No. Series");
    //     lRecNoSeries.TESTFIELD("Purchase Order Nos.");
    //     BatchNo := ParPRHeader."Batch No. [PR]" + 1;
    //     lRecPRLine.RESET;
    //     lRecPRLine.SETRANGE("Purchase Req. No.", ParPRHeader."Purchase Req. No.");
    //     lRecPRLine.SETFILTER("Qty to PO", '>%1', 0);
    //     lRecPRLine.SetCurrentKey("Line No.");
    //     lRecPRLine.Ascending(TRUE);
    //     IF lRecPRLine.FIND('-') THEN BEGIN
    //         REPEAT
    //             IF CurrVendorNo <> ParPRHeader."Vendor No" THEN BEGIN
    //                 lRecVendor.RESET;
    //                 lRecVendor.GET(ParPRHeader."Vendor No");
    //                 lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
    //                 PurchHeaderIns.INIT;
    //                 PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
    //                 PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMSISetup."Purchase Order Nos.");
    //                 //PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
    //                 PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.", WorkDate(), true);
    //                 PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
    //                 PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecPRLine."Vendor No.");
    //                 PurchHeaderIns.INSERT(TRUE);
    //                 PurchHeaderIns.VALIDATE("Document Date", ParPRHeader."Request Date");
    //                 PurchHeaderIns.VALIDATE("Location Code", ParPRHeader."Location Code");
    //                 // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
    //                 PurchHeaderIns.VALIDATE("Payment Terms Code", ParPRHeader."Payment Terms Code");
    //                 // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
    //                 PurchHeaderIns."Purchase Req. No." := lRecPRLine."Purchase Req. No.";
    //                 PurchHeaderIns.MODIFY(TRUE);
    //                 createPOLine_PRAsset(lRecPRLine, PurchHeaderIns."No.", BatchNo);
    //             END
    //             ELSE BEGIN
    //                 createPOLine_PRAsset(lRecPRLine, PurchHeaderIns."No.", BatchNo);
    //             END;
    //             CurrVendorNo := ParPRHeader."Vendor No";
    //         UNTIL lRecPRLine.NEXT = 0;
    //     END
    //     ELSE BEGIN
    //         ERROR('No PR  Line to be found for create PO');
    //     END;
    //     ParPRHeader."Batch No. [PR]" := BatchNo;
    //     StatusInt := closedStatus_PRAssetfromCreatePO(ParPRHeader."Purchase Req. No.");
    //     IF statusInt <> 0 THEN BEGIN
    //         Case StatusInt OF
    //             1:
    //                 ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Released);
    //             2:
    //                 ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Processed);
    //             3:
    //                 ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Closed);
    //         END;
    //     END;
    //     ParPRHeader.MODIFY;
    //     COMMIT;
    //     PurchLineView.RESET;
    //     PurchLineView.SETRANGE(PurchLineView."Purchase Req. No.", ParPRHeader."Purchase Req. No.");
    //     PurchLineView.SETRANGE(PurchLineView."RFQ No.", '');
    //     PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
    //     PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
    //     IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    // end;
    procedure createPOHeader_PRMAT(var PRHeader: Record "PR Material Header")
    var
        PRLine: Record "PR Material Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
        CurrentVendor: Code[20];
        POCount: Integer;
    begin
        // 1. Validasi Dokumen Utama
        PRHeader.TestField(Status, PRHeader.Status::Released);
        // PRHeader.TestField("Item Category Code"); // Wajib diisi

        PRLine.Reset();
        PRLine.SetRange("Purchase Req. No.", PRHeader."Purchase Req. No.");
        PRLine.SetFilter("Qty to PO", '>0'); // Hanya proses baris yang punya kuantitas untuk di-PO-kan

        // 2. Wajib SetCurrentKey agar baris terurut berdasarkan Vendor
        PRLine.SetCurrentKey("Purchase Req. No.", "Vendor No.");

        if PRLine.FindSet() then begin
            CurrentVendor := '';
            POCount := 0;

            repeat
                // Pastikan Vendor No. pada baris sudah diisi
                PRLine.TestField("Vendor No.");

                // 3. LOGIKA GROUPING: Jika Vendor baris ini BEDA dengan Vendor baris sebelumnya, Bikin PO Baru
                if CurrentVendor <> PRLine."Vendor No." then begin
                    PurchHeader.Init();
                    PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
                    PurchHeader.Insert(true);

                    PurchHeader.Validate("Buy-from Vendor No.", PRLine."Vendor No.");
                    PurchHeader.Validate("Document Date", WorkDate());
                    PurchHeader."Your Reference" := PRHeader."Purchase Req. No.";
                    PurchHeader.Modify(true);

                    // Update Tracker untuk baris selanjutnya
                    CurrentVendor := PRLine."Vendor No.";
                    LineNo := 10000;
                    POCount += 1;
                end;

                // 4. Insert Baris (Lines) ke PO yang sedang aktif di-looping
                PurchLine.Init();
                PurchLine.Validate("Document Type", PurchHeader."Document Type");
                PurchLine.Validate("Document No.", PurchHeader."No.");
                PurchLine.Validate("Line No.", LineNo);
                PurchLine.Insert(true);

                // Mapping Tipe Barang
                if PRLine.Type = PRLine.Type::Item then
                    PurchLine.Validate(Type, PurchLine.Type::Item)
                else if PRLine.Type = PRLine.Type::"G/L Account" then
                    PurchLine.Validate(Type, PurchLine.Type::"G/L Account");

                PurchLine.Validate("No.", PRLine."Item No.");
                PurchLine.Validate("Location Code", PRLine."Location Code");
                PurchLine.Validate(Quantity, PRLine."Qty to PO");
                PurchLine.Validate("Direct Unit Cost", PRLine."Direct Unit Cost");
                PurchLine.Modify(true);

                // 5. Kurangi sisa Qty yang belum di-PO-kan di PR Line
                PRLine."Total Qty On PO" += PRLine."Qty to PO";
                PRLine."Outstanding Quantity" -= PRLine."Qty to PO";
                PRLine."Qty to PO" := 0;
                PRLine.Modify(true);

                LineNo += 10000;
            until PRLine.Next() = 0;

            Message('Berhasil membuat %1 dokumen Purchase Order. PO telah dikelompokkan berdasarkan Vendor.', POCount);
        end else begin
            Error('Tidak ada baris PR yang siap diproses menjadi PO. Pastikan "Qty to PO" lebih dari 0.');
        end;
    end;

    procedure createPOLine_PRAsset(ParPRLine: Record "PR Material Line"; PONo: Code[20]; BatchNo: Integer)
    var
        PurchLineIns: Record "Purchase Line";
    begin
        PurchLineIns.INIT;
        PurchLineIns."Document Type" := PurchLineIns."Document Type"::Order;
        PurchLineIns."Document No." := PONo;
        PurchLineIns."Line No." := getLastLineNoPO(PONo);
        PurchLineIns.INSERT(TRUE);
        case ParPRLine."Type" OF
            ParPRLine."Type"::" ":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::" ");
                end;
            ParPRLine."Type"::"G/L Account":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::"G/L Account");
                    PurchLineIns.Validate("No.", ParPRLine."Item No.");
                    PurchLineIns.VALIDATE("Gen. Prod. Posting Group", gRecMSISetup."Default Gen. Prod PO");

                end;
            ParPRLine."Type"::Item:
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::Item);
                    PurchLineIns.Validate("No.", ParPRLine."Item No.");

                end;

        end;
        PurchLineIns.Validate("PR Line Type", ParPRLine.Type);
        PurchLineIns.Validate(Quantity, ParPRLine."Qty to PO");
        PurchLineIns.VALIDATE("Direct Unit Cost", ParPRLine."Direct Unit Cost");
        //PurchLineIns.VALIDATE("Line Discount %", ParPRLine."Discount %");
        PurchLineIns.Description := ParPRLine.Description;
        PurchLineIns.VALIDATE("Unit of Measure", ParPRLine."Unit of Measure");
        PurchLineIns.Validate("Part No.", ParPRLine."Part No.");
        PurchLineIns.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
        PurchLineIns.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
        //PurchLineIns.VALIDATE("VAT Prod. Posting Group", ParPRLine."VAT Prod. Posting Group");
        //PurchLineIns.VALIDATE("VAT Bus. Posting Group", ParPRLine."VAT Bus. Posting Group");
        PurchLineIns.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(3, ParPRLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(4, ParPRLine."Shortcut Dimension 4 Code");
        PurchLineIns.ValidateShortcutDimCode(5, ParPRLine."Shortcut Dimension 5 Code");
        PurchLineIns.ValidateShortcutDimCode(6, ParPRLine."Shortcut Dimension 6 Code");
        PurchLineIns.ValidateShortcutDimCode(7, ParPRLine."Shortcut Dimension 7 Code");
        PurchLineIns.ValidateShortcutDimCode(8, ParPRLine."Shortcut Dimension 8 Code");
        PurchLineIns.VALIDATE("Unit Group", ParPRLine."Unit Group");
        //Yang dimatikan karena tidak ada cek lagi nanti
        //PurchLineIns.Validate("GL Budget Name", ParPRLine."GL Budget Name");
        //PurchLineIns.Validate("G/L Account No.", ParPRLine."G/L Account No.");
        //PurchLineIns."GL Budgeted Amount" := ParPRLine."GL Budgeted Amount";
        //PurchLineIns."GL Available Budget" := ParPRLine."GL Available Budget";
        PurchLineIns.VALIDATE("MR Usage Category", ParPRLine."MR Usage Category");
        PurchLineIns."Batch No. [PR]" := BatchNo;
        PurchLineIns."PR Type" := PurchLineIns."PR Type"::Material;
        PurchLineIns.MODIFY(TRUE);
        //PurchLineIns.UpdateGLBudgetAmount_PO();
        updOutstandingQtyPR(ParPRLine, PurchLineIns.RecordID, ParPRLine."Qty to PO", TRUE)
    end;

    //UpdateOutsanding
    procedure updOutstandingQtyPR(var ParPRLine: Record "PR Material Line"; fromRecordID: RecordID; QtytoUpd: Decimal; fromCreatePO: Boolean)
    var
        lRecPRHeader: Record "PR Material Header";
        lRecPRLine: Record "PR Material Line";
        lRecPurchLine: Record "Purchase Line";
        lRecPurchInvLine: Record "Purch. Inv. Line";
        lDecTotalPOQty: Decimal;
        lDecOutstandingQty: Decimal;
        fromRecRef: RecordRef;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalPOQty);
        CLEAR(lDecOutstandingQty);
        CLEAR(fromRecRef);
        CASE fromRecordID.TableNo OF
            database::"Purchase Line":
                BEGIN
                    lRecPurchLine.RESET;
                    lRecPurchLine.SETRANGE(lRecPurchLine."Purchase Req. No.", ParPRLine."Purchase Req. No.");
                    lRecPurchLine.SETRANGE(lRecPurchLine."Purchase Req. Line No.", ParPRLine."Line No.");
                    IF lRecPurchLine.FIND('-') THEN BEGIN
                        lRecPurchLine.CalcSums(Quantity);
                        lDecTotalPOQty += ABS(lRecPurchLine.Quantity);
                    END;
                    lRecPurchLine.RESET;
                    lRecPurchLine.GET(fromRecordID);
                    lDecTotalPOQty := lDecTotalPOQty - lRecPurchLine.Quantity;
                    lRecPurchInvLine.RESET;
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."Purchase Req. No.", ParPRLine."Purchase Req. No.");
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."Purchase Req. Line No.", ParPRLine."Line No.");
                    IF lRecPurchInvLine.FIND('-') THEN BEGIN
                        lRecPurchInvLine.CalcSums(Quantity);
                        lDecTotalPOQty += ABS(lRecPurchInvLine.Quantity);
                    END;
                END;
        END;
        lDecOutstandingQty := ParPRLine.Quantity - lDecTotalPOQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParPRLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParPRLine."Outstanding Quantity" := 0;
        END;
        ParPRLine."Qty to PO" := ParPRLine."Outstanding Quantity";
        ParPRLine.MODIFY;
        IF FromCreatePO = FALSE THEN closedStatus_PRAsset(ParPRLine."Purchase Req. No.");
    end;

    procedure closedStatus_PRAsset(PRNo: Code[20])
    var
        lRecPRHeader: Record "PR Material Header";
        lRecPRLine: Record "PR Material Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRNo);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecPRLine.Quantity > lRecPRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecPRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecPRLine.NEXT = 0);
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
            lRecPRHeader.RESET;
            lRecPRHeader.SETRANGE(lRecPRHeader."Purchase Req. No.", PRNo);
            IF lRecPRHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Released);
                    2:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Processed);
                    3:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Closed);
                END;
                lRecPRHeader.MODIFY;
            END;
        END;
    end;

    procedure closedStatus_PRAssetfromCreatePO(PRNo: Code[20]): Integer
    var
        lRecPRHeader: Record "PR Material Header";
        lRecPRLine: Record "PR Material Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRNo);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecPRLine.Quantity > lRecPRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecPRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecPRLine.NEXT = 0);
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


    procedure createRFQHeader_PR(var ParPRHeader: Record "PR Material Header")
    var
        lRecRFQHeader: Record "RFQ Header";
        lRecPRLine: Record "PR Material Line";
        lCURFQFunct: Codeunit "RFQ Function";
        lIntCount: Integer;
    begin
        ParPRHeader.TestField("Purchase Req. No.");

        // Ambil PR Line yang masih bisa di-RFQ-kan.
        // Vendor No. sengaja TIDAK dicek di sini karena vendor baru ditentukan di RFQ.
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", ParPRHeader."Purchase Req. No.");
        lRecPRLine.SETFILTER(Quantity, '>%1', 0);
        lRecPRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        lRecPRLine.SETFILTER(Status, '%1|%2', lRecPRLine.Status::Released, lRecPRLine.Status::Processed);
        IF NOT lRecPRLine.FINDSET() THEN
            ERROR('Tidak ada PR Line yang bisa dibuatkan RFQ (cek Quantity, Outstanding Quantity, dan Status line).');

        // Buat RFQ Header baru. "RFQ No." di-generate otomatis oleh trigger OnInsert
        // dari No. Series "RFQ Nos." di MII Setup.
        CLEAR(lRecRFQHeader);
        lRecRFQHeader.INIT;
        lRecRFQHeader."RFQ No." := '';
        lRecRFQHeader.INSERT(TRUE);

        lRecRFQHeader.VALIDATE("PR No.", ParPRHeader."Purchase Req. No.");
        IF ParPRHeader."Location Code" <> '' THEN
            lRecRFQHeader.VALIDATE("Location Code", ParPRHeader."Location Code");
        lRecRFQHeader."Material Req. No." := ParPRHeader."MR No.";
        lRecRFQHeader.Remarks := ParPRHeader.Remarks;
        lRecRFQHeader.MODIFY(TRUE);

        // Buat RFQ Line dari tiap PR Line
        CLEAR(lIntCount);
        REPEAT
            lCURFQFunct.CreateRFQLine_PR(lRecPRLine, lRecRFQHeader."RFQ No.");
            lIntCount += 1;
        UNTIL lRecPRLine.NEXT = 0;

        COMMIT;
        MESSAGE('RFQ %1 berhasil dibuat dari %2 (%3 line).',
                lRecRFQHeader."RFQ No.", ParPRHeader."Purchase Req. No.", lIntCount);
        PAGE.RUN(PAGE::"RFQ Card", lRecRFQHeader);
    end;

    local procedure getPOLastLineNo(PONo: Code[20]): Integer
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
        //gCUNoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        gCUMRFunct: Codeunit "Material Req. Function";
}
