table 50101 "Material Req. Header"
{
    Caption = 'Material Req. Header';
    DataClassification = ToBeClassified;
    // LookupPageID = "Material Req. List";
    // DrillDownPageId = "Material Req. List";

    fields
    {
        field(1; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;

            // trigger OnValidate()
            // var
            //     myInt: Integer;
            // begin
            //     IF "Material Req. No." <> xRec."Material Req. No." THEN BEGIN
            //         grecMSISetup.GET;
            //         // NoSeriesMgt.TestManual(grecMSISetup."Material Req. Nos.");
            //         NoSeries.TestManual(grecMSISetup."Material Req. Nos.");
            //         "No. Series" := '';
            //     end;
            // END;
            trigger OnValidate()
            var
                lRecMSISetup: Record "MII Setup";
            begin
                lRecMSISetup.GET();
                IF "Material Req. No." <> xRec."Material Req. No." THEN BEGIN
                    NoSeries.TestManual(lRecMSISetup."Material Req. Nos.");
                    "No. Series" := '';
                END;
            end;

        }
        field(2; "User ID"; code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; RequesterID; Code[20])
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
        field(4; "Requester Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Material Req. Type"; Enum "Material Req. Type")
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Material Req. Type"));
            end;
        }
        field(7; "Location Code"; Code[20])
        {
            // DataClassification = ToBeClassified;
            // TableRelation = "Location";

            // trigger OnValidate()
            // var
            //     lrecML: Record "Material Req. Line";
            //     LabelConfirm: Label 'This will change "Location Code" in all line, do you want to continue?';
            // begin
            //     lrecML.RESET();
            //     lrecML.SetRange("Material Req. No.", Rec."Material Req. No.");
            //     IF lrecML.FINDFIRST then // IF Confirm(LabelConfirm) THEN BEGIN
            //         updateDocLines(FieldNo("Location Code"));
            //     // END;
            // END;

            DataClassification = ToBeClassified;
            TableRelation = "Location";

            trigger OnValidate()
            var
                lrecML: Record "Material Req. Line";
                RecLocation: Record Location;
                lRecMIISetup: Record "MII Setup";
            begin
                // Auto-fill lokasi pengirim dari Setup Master Location
                IF lRecMIISetup.GET() THEN BEGIN
                    IF lRecMIISetup."Enable TO from RO" THEN BEGIN
                        IF RecLocation.GET("Location Code") THEN BEGIN
                            "Transfer-from Code" := RecLocation."Default Supplying";
                            "In-Transit Code" := RecLocation."Default In-Transit";
                        END;
                    END;
                END;

                // Logika bawaan asli
                lrecML.RESET();
                lrecML.SetRange("Material Req. No.", Rec."Material Req. No.");
                IF lrecML.FINDFIRST then
                    updateDocLines(FieldNo("Location Code"));
            END;
        }
        field(8; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lCUMRFunct: Codeunit "Material Req. Function";
            begin
                Case Status OF // Status::Released:
                               //     lCUMRFunct.checkMandatoryFields(Rec);
                    Status::Open:
                        BEGIN
                            IF xRec.Status <> xRec.Status::Open THEN BEGIN
                                lCUMRFunct.checkMRLinehasPR(Rec."Material Req. No.", 'reopen');
                            END;
                        END;
                End;
            end;
        }
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(10; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 1 Code"));
                VALIDATE("Gen Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 2 Code"));
            end;
        }
        // field(14; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
        //     CaptionClass = '1,2,3';

        //     trigger OnValidate()
        //     begin
        //         UpdateDocLines(FieldNo("Shortcut Dimension 3 Code"));
        //         VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, "Shortcut Dimension 3 Code"));
        //     end;
        // }
        field(15; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 4 Code"));
            end;
        }
        field(16; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 5 Code"));
            end;
        }
        field(17; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 6 Code"));
            end;
        }
        field(18; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 7 Code"));
            end;
        }
        field(19; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 8 Code"));
            end;
        }
        field(20; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Material Req. Line"."Line Amount" where("Material Req. No." = field("Material Req. No.")));
        }
        field(21; "Created By"; code[250])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(22; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(23; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(24; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(25; "Requester Department"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee_Req."Request Dept" where("User Id" = field("User ID"));
        }
        field(26; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;


        }
        field(27; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Unit Group"));
                VALIDATE("Gen Bus. Posting Group", gCUMSIFunct.getGenBusfromMapping("Shortcut Dimension 1 Code", "Unit Group", "MR Usage Category"));
            end;
        }
        field(28; "Gen Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(29; "Gen. Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(30; "Mapping COA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Mapping COA Expense".Code;

            trigger OnValidate()
            begin
                updfromMappingCOA();
            end;
        }
        field(31; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Transfer-from Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer-from Code';
            TableRelation = Location;
        }
        field(33; "In-Transit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
    }
    keys
    {
        key(KEY1; "Material Req. No.")
        {
            Clustered = true;
        }
    }
    var
        grecMSISetup: Record "MII Setup";
        gRecMRHeader: Record "Material Req. Header";
        //sNoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        gCUMSIFunct: Codeunit "MII Function";

    trigger OnInsert()
    begin
        IF "Material Req. No." = '' THEN BEGIN
            grecMSISetup.GET;
            grecMSISetup.TestField("Material Req. Nos.");
            //NoSeriesMgt.InitSeries(grecMSISetup."Material Req. Nos.", xRec."No. Series", 0D, "Material Req. No.", "No. Series");
            NoSeries.AreRelated(grecMSISetup."Material Req. Nos.", xRec."No. Series");

        END;
        "Document Date" := WORKDATE;
        "User ID" := USERID;
        "Created By" := USERID;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := USERID;
        "Last Modified Date" := CurrentDateTime;
        Status := Status::Open;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnDelete()
    var
        lrecMaterialReqLine: Record "Material Req. Line";
    begin
        TestField("Status", "Status"::Open);
        lrecMaterialReqLine.RESET();
        lrecMaterialReqLine.SETRANGE("Material Req. No.", Rec."Material Req. No.");
        IF lrecMaterialReqLine.Find('-') THEN BEGIN
            lrecMaterialReqLine.DELETEALL(TRUE)
        END
    end;

    procedure TestNoSeries(): Boolean
    begin
        grecMSISetup.GET;
        grecMSISetup.TESTFIELD("Material Req. Nos.");
    end;

    procedure GetNoSeriesCode(): Code[10]
    begin
        grecMSISetup.GET;
        EXIT(grecMSISetup."Material Req. Nos.");
    end;

    // procedure AssistEdit(): Boolean
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     lRecMSISetup.GET;
    //     lRecMSISetup.TESTFIELD("Material Req. Nos.");
    //     //IF NoSeriesMgt.SelectSeries(lRecMSISetup."Material Req. Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //     IF NoSeries.LookupRelatedNoSeries(lRecMSISetup."Material Req. Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //         //NoSeriesMgt.SetSeries(Rec."Material Req. No.");
    //         NoSeries.GetNextNo(Rec."Material Req. No.");
    //         EXIT(TRUE);
    //     END;
    // end;

    // procedure AssistEdit(): Boolean
    // var
    //     lRecMSISetup: Record "MII Setup";
    // begin
    //     lRecMSISetup.GET;
    //     lRecMSISetup.TESTFIELD("Material Req. Nos.");
    //     IF NoSeries.LookupRelatedNoSeries(lRecMSISetup."Material Req. Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
    //         // PERBAIKAN: Assign hasil balikan GetNextNo ke field Document No. dan gunakan parameter "No. Series"
    //         Rec."Material Req. No." := NoSeries.GetNextNo(Rec."No. Series");
    //         EXIT(TRUE);
    //     END;
    // end;

    procedure AssistEdit(): Boolean
    var
        lRecMSISetup: Record "MII Setup";
        OldNoSeries: Code[20];
    begin
        lRecMSISetup.Get();
        lRecMSISetup.TestField("Material Req. Nos.");

        OldNoSeries := "No. Series";
        if Noseries.LookupRelatedNoSeries(lRecMSISetup."Material Req. Nos.", OldNoSeries, "No. Series") then begin
            "Material Req. No." := Noseries.GetNextNo("No. Series", WorkDate, true);  // Manual OK
            exit(true);
        end;
    end;

    procedure updfromMappingCOA()
    var
        lRecMappingCOA: Record "Mapping COA Expense";
    begin
        lRecMappingCOA.RESET;
        lRecMappingCOA.SETRANGE(Code, "Mapping COA Code");
        IF lRecMappingCOA.FINDFIRST THEN BEGIN
            Rec.VALIDATE("Shortcut Dimension 1 Code", lRecMappingCOA."Shortcut Dimension 1 Code");
            Rec.VALIDATE("Shortcut Dimension 2 Code", lRecMappingCOA."Shortcut Dimension 2 Code");
            Rec.VALIDATE("Shortcut Dimension 5 Code", lRecMappingCOA."Shortcut Dimension 6 Code");
            //Rec.VALIDATE("Shortcut Dimension 3 Code", lRecMappingCOA."Shortcut Dimension 7 Code");
            Rec.VALIDATE("Gen Bus. Posting Group", lRecMappingCOA."Gen Bus. Posting Group");
            Rec.VALIDATE("Gen. Prod. Posting Group", lRecMappingCOA."Gen Prod. Posting Group");
            Rec.VALIDATE("Unit Group", lRecMappingCOA."Unit Group Dimension");
            Rec.VALIDATE("MR Usage Category", lRecMappingCOA."MR Usage Category");
        END;
    end;

    procedure updateDocLines(FieldRef: Integer)
    var
        lRecMRLine: Record "Material Req. Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
        IF lRecMRLine.FIND('-') THEN BEGIN
            REPEAT
                case FieldRef of
                    FieldNo("Shortcut Dimension 1 Code"):
                        lRecMRLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FieldNo("Shortcut Dimension 2 Code"):
                        lRecMRLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    // FieldNo("Shortcut Dimension 3 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    // FieldNo("Shortcut Dimension 4 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    // FieldNo("Shortcut Dimension 5 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    // FieldNo("Shortcut Dimension 6 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 6 Code", "Shortcut Dimension 6 Code");
                    // FieldNo("Shortcut Dimension 7 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code");
                    // FieldNo("Shortcut Dimension 8 Code"):
                    //     lRecMRLine.VALIDATE("Shortcut Dimension 8 Code", "Shortcut Dimension 8 Code");
                    FieldNo("Material Req. Type"):
                        lRecMRLine.VALIDATE("Material Req. Type", "Material Req. Type");
                    FieldNo("Location Code"):
                        lRecMRLine.VALIDATE("Location Code", "Location Code");
                    FieldNo("Unit Group"):
                        lRecMRLine.VALIDATE("Unit Group", "Unit Group");
                    FieldNo("MR Usage Category"):
                        lRecMRLine.VALIDATE("MR Usage Category", "MR Usage Category");
                end;
                lRecMRLine.MODIFY(TRUE);
            UNTIL lRecMRLine.NEXT = 0;
        END;
    end;
}
