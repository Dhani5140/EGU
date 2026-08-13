table 50104 "PR Material Line"
{
    //Permissions = tabledata "Document Control" = rimd;
    DrillDownPageID = "PR Material Lines";
    LookupPageID = "PR Material Lines";

    fields
    {
        field(1; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        // field(3; "Item No."; Code[20])
        // {
        //     Caption = 'No.';
        //     DataClassification = ToBeClassified;
        //     TableRelation = if ("Type" = filter('Item')) Item where(Blocked = const(false))
        //     else
        //     if ("Type" = filter('Fixed Asset')) "Fixed Asset"
        //     else
        //     if ("Type" = filter('G/L Account')) "G/L Account";

        //     trigger OnValidate()
        //     var
        //         lRecItem: Record Item;
        //         lRecGL: Record "G/L Account";
        //         lRecFA: Record "Fixed Asset";
        //     begin
        //         if "Type" = "Type"::Item then begin
        //             lRecItem.RESET;
        //             lRecItem.SETRANGE(lRecItem."No.", "Item No.");
        //             IF lRecItem.FINDFIRST THEN BEGIN
        //                 "Description" := lrecItem.Description;
        //                 VALIDATE("VAT Prod. Posting Group", lRecItem."VAT Prod. Posting Group");

        //                 VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
        //             END
        //             ELSE BEGIN
        //                 "Description" := '';
        //                 VALIDATE("VAT Prod. Posting Group", '');

        //                 VALIDATE("Direct Unit Cost", 0);
        //             END;
        //         end
        //         else
        //             if "Type" = "Type"::"G/L Account" then begin
        //                 lRecGL.RESET;
        //                 lRecGL.SETRANGE(lRecGL."No.", "Item No.");
        //                 IF lRecGL.FINDFIRST THEN BEGIN
        //                     Rec."Description" := lRecGL.Name;
        //                     VALIDATE("VAT Bus. Posting Group", lRecGL."VAT Bus. Posting Group");
        //                     VALIDATE("VAT Prod. Posting Group", lRecGL."VAT Prod. Posting Group");


        //                 END
        //                 ELSE BEGIN
        //                     VALIDATE("VAT Bus. Posting Group", '');
        //                     VALIDATE("VAT Prod. Posting Group", '');


        //                 END;
        //             end
        //             else
        //                 if "Type" = "Type"::"Fixed Asset" then begin
        //                     lrecFA.Reset();
        //                     if lrecFA.GET("Item No.") then begin
        //                         "Description" := lrecFA.Description;
        //                     end;
        //                 end;
        //         IF "Type" = "Type"::" " then Error('You cannot choose empty');
        //     end;
        // }

        field(3; "Item No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            // Properti TableRelation murni menyaring field fisik "Item Category Code" yang ada di baris ini
            TableRelation = if ("Type" = filter('Item')) Item where("Item Category Code" = field("Item Category Code"), Blocked = const(false))
            else
            if ("Type" = filter('Fixed Asset')) "Fixed Asset"
            else
            if ("Type" = filter('G/L Account')) "G/L Account";

            trigger OnValidate()
            var
                lRecItem: Record Item;
                lRecGL: Record "G/L Account";
                lRecFA: Record "Fixed Asset";
                lRecPRHeader: Record "PR Material Header";
            begin
                if "Type" = "Type"::Item then begin
                    lRecItem.RESET;
                    lRecItem.SETRANGE(lRecItem."No.", "Item No.");
                    IF lRecItem.FINDFIRST THEN BEGIN

                        //UNTUK BPK Penabur
                        // // --- LOGIKA VALIDASI 1 PR = 1 KATEGORI ---
                        // if lRecPRHeader.Get(Rec."Purchase Req. No.") then begin
                        //     lRecPRHeader.TestField("Item Category Code"); // Pastikan user sudah isi Kategori di Header
                        //     if lRecItem."Item Category Code" <> lRecPRHeader."Item Category Code" then
                        //         Error('Barang ini memiliki kategori "%1". Dokumen PR ini dikhususkan untuk kategori "%2".', lRecItem."Item Category Code", lRecPRHeader."Item Category Code");
                        // end;
                        // // -----------------------------------------------

                        "Description" := lrecItem.Description;
                        VALIDATE("Unit of Measure", lrecItem."Base Unit of Measure");

                        // Tarik kategori dari Master Item ke baris PR
                        "Item Category Code" := lRecItem."Item Category Code";

                        // --- LOGIKA BAWAAN ANDA ---
                        VALIDATE("VAT Prod. Posting Group", lRecItem."VAT Prod. Posting Group");
                        VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
                        // ---------------------------------------------------
                    END
                    ELSE BEGIN
                        "Description" := '';
                        VALIDATE("VAT Prod. Posting Group", '');
                        VALIDATE("Direct Unit Cost", 0);
                        "Item Category Code" := ''; // Reset kategori jika item dihapus/kosong
                    END;
                end
                else
                    if "Type" = "Type"::"G/L Account" then begin
                        lRecGL.RESET;
                        lRecGL.SETRANGE(lRecGL."No.", "Item No.");
                        IF lRecGL.FINDFIRST THEN BEGIN
                            Rec."Description" := lRecGL.Name;
                            VALIDATE("VAT Bus. Posting Group", lRecGL."VAT Bus. Posting Group");
                            VALIDATE("VAT Prod. Posting Group", lRecGL."VAT Prod. Posting Group");
                        END
                        ELSE BEGIN
                            VALIDATE("VAT Bus. Posting Group", '');
                            VALIDATE("VAT Prod. Posting Group", '');
                        END;
                    end
                    else
                        if "Type" = "Type"::"Fixed Asset" then begin
                            lrecFA.Reset();
                            if lrecFA.GET("Item No.") then begin
                                "Description" := lrecFA.Description;
                            end;
                        end;

                IF "Type" = "Type"::" " then Error('You cannot choose empty');
            end;
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = FIeld("Item No."));

            trigger OnValidate()
            begin
            end;
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                TestField(Quantity);
                IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                    IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                        gRecMRLine.RESET;
                        gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                        gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                        IF gRecMRLine.FINDFIRST THEN BEGIN
                            IF gRecMRLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN
                                ERROR('You cannot input more than %1', gRecMRLine."Outstanding Quantity" + xRec.Quantity);
                            gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, Quantity);
                        END;
                    END;
                END;
                "Qty to PO" := Quantity;
                "Outstanding Quantity" := Quantity;
                "Line Amount" := Quantity * "Direct Unit Cost";
                // Tambahkan baris berikut agar Total Amount juga ikut update
                "Total Amount" := "Line Amount" + "VAT Amount"; // Atau sesuai formula Anda
                                                                // Panggil UpdateGLBudgetAmount agar budget langsung update
                UpdateGLBudgetAmount();
                // Warning jika budget tidak cukup, tapi tetap bisa lanjut (budget bisa minus)
                if "GL Available Budget" < "Total Amount" then
                    Message('Warning: Available budget is not sufficient for this PR line. Sisa budget: %1, Amount: %2', "GL Available Budget", "Total Amount");
            end;
        }

        field(7; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(8; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Line Amount" := "Quantity" * "Direct Unit Cost";
                "Total Amount" := "Line Amount" + "VAT Amount";
                UpdateGLBudgetAmount();
                if "GL Available Budget" < "Total Amount" then
                    Message('Warning: Available budget is not sufficient for this PR line. Sisa budget: %1, Amount: %2', "GL Available Budget", "Total Amount");
            end;
        }

        field(9; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Created By"; code[150])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(11; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(12; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(13; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(14; "Brand"; code[150])
        {
            Caption = 'Brand';
            DataClassification = ToBeClassified;
        }
        field(15; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Location Code"; code[50])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(17; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = field("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("PR Material Header".Status WHERE("Purchase Req. No." = field("Purchase Req. No.")));
        }
        field(22; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';
        }
        field(23; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
        field(24; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(25; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';
        }
        field(26; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(27; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';
        }
        field(28; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';
        }
        field(29; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';
        }
        field(30; "Total Qty On RFQ"; Decimal)
        {
            Caption = 'Total Qty On RFQ';
            FieldClass = FlowField;
            CalcFormula = SUM("RFQ Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No.")));
        }
        field(31; "Total Qty On PO"; Decimal)
        {
            Caption = 'Total Qty On PO';
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No.")));
        }
        field(32; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                lRecVendor: Record Vendor;
            begin
                lRecVendor.RESET;
                lRecVendor.SETRANGE(lRecVendor."No.", "Vendor No.");
                IF lRecVendor.FINDFIRST THEN BEGIN
                    VALIDATE("VAT Bus. Posting Group", lRecVendor."VAT Bus. Posting Group");

                END
                ELSE BEGIN
                    VALIDATE("VAT Bus. Posting Group", '');

                END;
                IF "Type" = "Type"::Item THEN VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
            end;
        }
        field(43; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
            end;
        }
        field(44; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(45; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(46; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(47; "Type"; Enum "PR Asset Line Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(48; "Qty to PO"; Decimal)
        {
            Caption = 'Qty to PO';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Qty to PO" > "Outstanding Quantity" then Error('Qty to PO cannot input more then %1', "Outstanding Quantity");
            end;
        }
        field(49; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(50; "VAT Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(51; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                VALIDATE("Total Amount", "Line Amount" + "VAT Amount");
                UpdateGLBudgetAmount();
                if "GL Available Budget" < "Total Amount" then
                    Message('Warning: Available budget is not sufficient for this PR line. Sisa budget: %1, Amount: %2', "GL Available Budget", "Total Amount");
            end;
        }

        field(52; "Total Amount"; Decimal)
        {

            DataClassification = ToBeClassified;
        }
        field(53; "Purchase Budget"; Decimal)
        {
            Caption = 'Available Budget';
        }

        field(54; "Purchase Budget2"; CODE[20])
        {
            TableRelation = "Item Budget Name".Name;
        }
        // Di table 80104 "PR Material Line"

        field(55; "Purchase Budget Name"; Code[20])
        {
            TableRelation = "Item Budget Name".Name;
            Caption = 'Budget Name';

            trigger OnValidate()
            begin
                UpdatePurchaseBudgetAmount(); // Panggil fungsi update budget
            end;
        }
        field(56; "Budgeted Quantity"; Decimal)
        {
            Caption = 'Budgeted Quantity';
            DataClassification = ToBeClassified;
            Editable = false; // Non-editable karena dihitung via code
        }
        field(60; "GL Budget Name"; Code[20])
        {
            Caption = 'G/L Budget Name';
            TableRelation = "G/L Budget Name".Name;
            trigger OnValidate()
            begin
                UpdateGLBudgetAmount();
            end;
        }
        field(61; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account"."No.";
            trigger OnValidate()
            begin
                UpdateGLBudgetAmount();
            end;
        }
        field(62; "GL Available Budget"; Decimal)
        {
            Caption = 'Available Budget';
            Editable = false;
        }
        field(63; "GL Budgeted Amount"; Decimal)
        {
            Caption = 'Budgeted Amount';
            Editable = false;
        }
        field(64; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            Editable = false; // Karena ditarik otomatis dari Master Item
        }
        field(65; "Header Item Category"; Code[20])
        {
            Caption = 'Header Item Category';
            FieldClass = FlowField;
            CalcFormula = lookup("PR Material Header"."Item Category Code" where("Purchase Req. No." = field("Purchase Req. No.")));
            Editable = false;
        }








    }
    keys
    {
        key(PK; "Purchase Req. No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    var
        grecFA: Record "Fixed Asset";

    trigger OnInsert()
    var
        lRecPRHeader: Record "PR Material Header";
    begin
        lRecPRHeader.RESET;
        lRecPRHeader.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
        IF lRecPRHeader.FINDFIRST THEN BEGIN
            Rec."Location Code" := lRecPRHeader."Location Code";
            Rec."Shortcut Dimension 1 Code" := lRecPRHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := lRecPRHeader."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension 3 Code" := lRecPRHeader."Shortcut Dimension 3 Code";
            Rec."Shortcut Dimension 4 Code" := lRecPRHeader."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension 5 Code" := lRecPRHeader."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension 6 Code" := lRecPRHeader."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 7 Code" := lRecPRHeader."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension 8 Code" := lRecPRHeader."Shortcut Dimension 8 Code";
            Rec.VALIDATE("Vendor No.", lRecPRHeader."Vendor No");
            Rec.VALIDATE("Document Date", lRecPRHeader."Document Date");
        END;
        "Created By" := UserId;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnDelete()
    var
        lrecMRLine: Record "Material Req. Line";
        lrecPRHeader: Record "PR Material Header";
    begin
        lrecPRHeader.RESET();
        lrecPRHeader.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
        IF lrecPRHeader.FIND('-') then lrecPRHeader.TestField(Status, lrecPRHeader.Status::Open);
        gCUPRFunct.checkPRLinehasRFQ(Rec."Purchase Req. No.", 'delete');
        IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
            gRecMRLine.RESET;
            gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
            gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
            IF gRecMRLine.FINDFIRST THEN BEGIN
                gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, 0);
            END;
        END;
    end;

    procedure calcPPN()
    var
        lRecVATSetup: Record "VAT Posting Setup";
    begin
        lRecVATSetup.RESET;
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
        IF lRecVATSetup.FINDFIRST THEN
            VALIDATE("VAT Amount", "Line Amount" * (lRecVATSetup."VAT %") / 100)
        ELSE
            VALIDATE("VAT Amount", 0);
    end;

    local procedure UpdatePurchaseBudgetAmount()
    var
        ItemBudgetEntry: Record "Item Budget Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalBudget: Decimal;
        TotalBudgetQty: Decimal;
        TotalActual: Decimal;
        StartDate: Date;
        EndDate: Date;
    begin
        Rec."Purchase Budget" := 0;
        Rec."Budgeted Quantity" := 0;

        // // Set periode
        // StartDate := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        // EndDate := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));

        ItemBudgetEntry.SetRange("Budget Name", Rec."Purchase Budget Name");
        ItemBudgetEntry.SetRange("Item No.", Rec."Item No.");
        // ItemBudgetEntry.SetRange("Location Code", Rec."Location Code");
        // ItemBudgetEntry.SetRange("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        // ItemBudgetEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        ItemBudgetEntry.SetRange("Date", StartDate, EndDate);

        if ItemBudgetEntry.FindSet() then begin
            ItemBudgetEntry.CalcSums("Cost Amount", Quantity);
            TotalBudget := ItemBudgetEntry."Cost Amount";
            TotalBudgetQty := ItemBudgetEntry.Quantity;
            Rec."Budgeted Quantity" := TotalBudgetQty; // Assign ke field Normal
        end;

        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        // ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
        // ItemLedgerEntry.SetRange("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        // ItemLedgerEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        ItemLedgerEntry.SetRange("Posting Date", StartDate, EndDate);

        TotalActual := 0;
        if ItemLedgerEntry.FindSet() then
            repeat
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                TotalActual += ItemLedgerEntry."Cost Amount (Actual)";
            until ItemLedgerEntry.Next() = 0;



        Rec."Purchase Budget" := TotalBudget - TotalActual;
    end;

    local procedure UpdateGLBudgetAmount()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        GLEntry: Record "G/L Entry";
        PRLine: Record "PR Material Line";
        TotalBudget: Decimal;
        TotalActual: Decimal;
        TotalCommitment: Decimal;
        StartDate: Date;
        EndDate: Date;
    begin
        Rec."GL Available Budget" := 0;
        Rec."GL Budgeted Amount" := 0;

        StartDate := DMY2DATE(1, 1, 2025);
        EndDate := DMY2DATE(31, 12, 2030);

        // Ambil Budgeted Amount
        GLBudgetEntry.SetRange("Budget Name", Rec."GL Budget Name");
        GLBudgetEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
        GLBudgetEntry.SetRange("Date", StartDate, EndDate);
        GLBudgetEntry.CalcSums("Amount");
        TotalBudget := GLBudgetEntry."Amount";
        Rec."GL Budgeted Amount" := TotalBudget;


        GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
        GLEntry.SetRange("Posting Date", StartDate, EndDate);
        TotalActual := 0;
        if GLEntry.FindSet() then
            repeat
                TotalActual += GLEntry."Amount";
            until GLEntry.Next() = 0;

        TotalCommitment := 0;
        PRLine.Reset();
        PRLine.SetRange("GL Budget Name", Rec."GL Budget Name");
        PRLine.SetRange("G/L Account No.", Rec."G/L Account No.");
        // Filter hanya PR yang statusnya masih open/aktif
        PRLine.SetRange("Status", PRLine.Status::Open);
        if PRLine.FindSet() then
            repeat
                TotalCommitment += PRLine."Total Amount";
            until PRLine.Next() = 0;


        Rec."GL Available Budget" := TotalBudget - TotalActual - TotalCommitment;
    end;

    var
        gRecMRLine: Record "Material Req. Line";
        gRecItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        gCUMRFunct: Codeunit "Material Req. Function";
        gCUPRFunct: Codeunit "PR Material Function";
        gCUMSIFunct: Codeunit "MII Function";
        gdecSisa: Decimal;
}
