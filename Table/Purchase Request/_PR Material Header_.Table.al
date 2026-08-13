table 50103 "PR Material Header"
{
    Caption = 'PR Material Header';
    DataCaptionFields = "Purchase Req. No.";
    LookupPageID = "PR Material List";
    DrillDownPageId = "PR Material List";

    fields
    {
        field(1; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecMSISetup: Record "MII Setup";
            begin
                lRecMSISetup.GET();
                IF "Purchase Req. No." <> xRec."Purchase Req. No." THEN BEGIN
                    NoSeries.TestManual(lRecMSISetup."PR Material Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "User ID"; code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; RequesterID; Code[20])
        {
            Caption = 'RequesterID';
            DataClassification = ToBeClassified;
            TableRelation = "Employee";

            trigger OnValidate()
            var
                lRecEmployee: Record Employee;
            begin
                lRecEmployee.RESET;
                lRecEmployee.GET("RequesterID");
                "Requester Name" := lRecEmployee.FullName();
            end;
        }
        field(5; "Requester Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7; "Status"; Enum "PR Module Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lCUPRFunct: Codeunit "PR Material Function";
            begin
                Case Status OF // Status::Released:
                               //     "Released Date" := WORKDATE;
                    Status::Open:
                        BEGIN
                            IF xRec.Status <> xRec.Status::Open THEN BEGIN
                                lCUPRFunct.checkPRLinehasRFQ(Rec."Purchase Req. No.", 'reopen');
                            END;
                        END;
                End;
            end;
        }
        field(8; "Created By"; code[250])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(9; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(11; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(12; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("PR Material Line"."Line Amount" where("Purchase Req. No." = field("Purchase Req. No.")));
        }
        field(13; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Location";

            trigger OnValidate()
            var
                lrecPRLine: Record "PR Material Line";
                LabelConfirm: Label 'This will change "Location Code" in all line, do you want to continue?';
            begin
                lrecPRLine.RESET();
                lrecPRLine.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                IF lrecPRLine.FIND('-') then // IF Confirm(LabelConfirm) THEN BEGIN
                    updateDocLines(FieldNo("Location Code"));
                // END;
            END;
        }
        field(14; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 1 Code"));
            end;
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 2 Code"));
            end;
        }
        field(18; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 3 Code"));
            end;
        }
        field(19; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 4 Code"));
            end;
        }
        field(20; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 5 Code"));
            end;
        }
        field(21; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 6 Code"));
            end;
        }
        field(22; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 7 Code"));
            end;
        }
        field(23; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 8 Code"));
            end;
        }
        field(24; "Material Req. No."; Code[35])
        {
            DataClassification = ToBeClassified;
            Editable = FALSE;
        }
        field(25; "Urgent Status"; Enum "PR Urgent Status")
        {
            DataClassification = ToBeClassified;
        }

        field(27; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Document Date"));
            end;
        }
        field(28; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("MR Usage Category"));
            end;
        }
        field(29; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Unit Group"));
            end;
        }
        field(30; "MR No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Material Req. Header"."Material Req. No." where(Status = filter(Released | "Partial Receive / Processed On PR"));
        }
        field(31; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                lrecVendor: Record Vendor;
            begin
                lrecVendor.RESET;
                if lrecVendor.GET("Vendor No") then begin
                    "Vendor Name" := lrecVendor.Name;
                    VALIDATE("Payment Terms Code", lrecVendor."Payment Terms Code");
                end
                else begin
                    "Vendor Name" := '';
                    VALIDATE("Payment Terms Code", '');
                end;
                UpdateDocLines(FieldNo("Vendor No"));
            end;
        }
        field(36; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Batch No. [PR]"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Payment Terms Code"; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lRec: Record "Payment Terms";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, Rec."Payment Terms Code");
                IF lRec.FINDFIRST THEN BEGIN
                    "Payment Terms Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Payment Terms Name" := '';
                END;
            end;
        }
        field(34; "Payment Terms Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; Hide; Boolean)
        {
            Caption = 'PR To PO';

            DataClassification = ToBeClassified;

        }
        field(40; "PR Type"; Enum "PR Type replacement")
        {
            Caption = 'PR Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; "Replaced PR No."; Code[20])
        {
            Caption = 'Replaced PR No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "PR Material Header"."Purchase Req. No.";
        }

        field(50; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                lRecPRLine: Record "PR Material Line";
            begin
                // Cegah perubahan Kategori jika sudah ada baris barang yang diinput
                lRecPRLine.Reset();
                lRecPRLine.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                if not lRecPRLine.IsEmpty then
                    Error('Tidak bisa mengubah Item Category karena sudah ada baris barang. Hapus baris barang terlebih dahulu untuk mengganti Kategori.');
            end;
        }
    }
    keys
    {
        key(PK; "Purchase Req. No.")
        {
            Clustered = true;
        }
    }
    // trigger OnDelete()
    // var
    //     lrecPurchaseReqLine: Record "PR Material Line";
    // begin
    //     TestField("Status", "Status"::Open);
    //     lrecPurchaseReqLine.RESET();
    //     lrecPurchaseReqLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
    //     IF lrecPurchaseReqLine.Find('-') THEN BEGIN
    //         lrecPurchaseReqLine.DELETEALL(TRUE)
    //     END
    // end;

    trigger OnDelete()
    var
        PRLine: Record "PR Material Line";
        NoSeriesLine: Record "No. Series Line";
        Noseries: Codeunit "No. Series";
    begin
        TestField(Status, Status::Open);


        PRLine.SetRange("Purchase Req. No.", "Purchase Req. No.");
        PRLine.DeleteAll(true);


        if Status = Status::Open then begin
            NoSeriesLine.SetRange("Series Code", "No. Series");
            NoSeriesLine.SetRange("Starting Date", WorkDate);
            if NoSeriesLine.FindFirst() then begin

                NoSeriesLine."Last No. Used" := Noseries.GetLastNoUsed("No. Series");

                if NoSeriesLine."Last No. Used" <> '' then
                    NoSeriesLine."Last No. Used" := IncStr(NoSeriesLine."Last No. Used", -1);
                NoSeriesLine.Modify();
            end;
        end;
    end;


    trigger OnInsert()
    var
        lRecMSISetup: Record "MII Setup";
    begin
        if "Purchase Req. No." = '' then begin
            lRecMSISetup.Get();
            lRecMSISetup.TestField("PR Material Nos.");
            "Purchase Req. No." := Noseries.GetNextNo(lRecMSISetup."PR Material Nos.", WorkDate);  // ← Perubahan 27.4
            "No. Series" := lRecMSISetup."PR Material Nos.";
        end;
        "User ID" := USERID;
        "Urgent Status" := "Urgent Status"::High;
        VALIDATE("Document Date", WORKDATE);
        "Request Date" := WORKDATE;
        "Created By" := USERID;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := USERID;
        "Last Modified Date" := CurrentDateTime;
        Status := Status::Open;
        "PR Type" := "PR Type"::"New Request";

    end;

    trigger OnRename()
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
    end;

    // procedure AssistEdit(): Boolean
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     lRecMSISetup.GET;
    //     lRecMSISetup.TESTFIELD("PR Material Nos.");
    //     // IF NoSeriesMgt.SelectSeries(lRecMSISetup."PR Material Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //     //     NoSeriesMgt.SetSeries(Rec."Purchase Req. No.");
    //     IF NoSeries.LookupRelatedNoSeries(lRecMSISetup."PR Material Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //         NoSeries.GetNextNo(Rec."Purchase Req. No.");
    //         EXIT(TRUE);
    //     END;
    // end;

    procedure AssistEdit(): Boolean
    var
        lRecMSISetup: Record "MII Setup";
        OldNoSeries: Code[20];
    begin
        lRecMSISetup.Get();
        lRecMSISetup.TestField("PR Material Nos.");

        OldNoSeries := "No. Series";
        if Noseries.LookupRelatedNoSeries(lRecMSISetup."PR Material Nos.", OldNoSeries, "No. Series") then begin
            "Purchase Req. No." := Noseries.GetNextNo("No. Series", WorkDate, true);  // Manual OK
            exit(true);
        end;
    end;

    procedure visible1(): Boolean
    var
        Miiset: Record "MII Setup";

    begin
        if Miiset.Hide then
            isvisible := false
        else
            isvisible := true;

    end;

    procedure updateDocLines(FieldRef: Integer)
    var
        lRecPRLine: Record "PR Material Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                case FieldRef of
                    FieldNo("Shortcut Dimension 1 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FieldNo("Shortcut Dimension 2 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    FieldNo("Shortcut Dimension 3 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    FieldNo("Shortcut Dimension 4 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    FieldNo("Shortcut Dimension 5 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    FieldNo("Shortcut Dimension 6 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 6 Code", "Shortcut Dimension 6 Code");
                    FieldNo("Shortcut Dimension 7 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code");
                    FieldNo("Shortcut Dimension 8 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 8 Code", "Shortcut Dimension 8 Code");
                    FieldNo("Location Code"):
                        lRecPRLine.VALIDATE("Location Code", "Location Code");
                    FieldNo("Vendor No"):
                        lRecPRLine.VALIDATE("Vendor No.", "Vendor No");
                    FieldNo("Document Date"):
                        lRecPRLine.VALIDATE("Document Date", "Document Date");
                    FieldNo("Unit Group"):
                        lRecPRLine.VALIDATE("Unit Group", "Unit Group");
                    FieldNo("MR Usage Category"):
                        lRecPRLine.VALIDATE("MR Usage Category", "MR Usage Category");
                end;
                lRecPRLine.MODIFY(TRUE);
            UNTIL lRecPRLine.NEXT = 0;
        END;
    end;



    var
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        Noseries: Codeunit "No. Series";
        Text003: Label 'You cannot rename a %1.';

        isvisible: Boolean;
}
