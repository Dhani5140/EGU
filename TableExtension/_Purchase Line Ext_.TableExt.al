tableextension 50101 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                IF xRec."Direct Unit Cost" <> Rec."Direct Unit Cost" THEN BEGIN
                    IF "Auto Insert from Line No" <> 0 THEN ERROR('This line is auto create from system, cannot modify');
                    IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
                        CASE "PR Type" OF
                            "PR Type"::Consignment:
                                BEGIN
                                    ERROR('This line is from PR Consignment, cannot modify');
                                END;
                        END;
                    END;
                END;
            end;
        }
        // Add changes to table fields here
        field(50000; "Purchase Req. No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "RFQ No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "RFQ Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Original Qty PR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Entry No. RFQ Line"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Batch No. [PR]"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "PR Type"; Enum "PR Type")
        {
            DataClassification = ToBeClassified;
        }
        // field(50010; "Fixed Asset PR Qty"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = SUM("PR Asset FA List".Quantity where("PO No." = field("Document No."), "PO Line No." = field("Line No."), "Purchase Req. No." = field("Purchase Req. No."), "Purchase Req. Line No." = field("Purchase Req. Line No."), "FA No." = filter(<> '')));
        // }
        // field(50011; "Fixed Asset PR Amount"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = SUM("PR Asset FA List"."Line Amount" where("PO No." = field("Document No."), "PO Line No." = field("Line No."), "Purchase Req. No." = field("Purchase Req. No."), "Purchase Req. Line No." = field("Purchase Req. Line No."), "FA No." = filter(<> '')));
        // }
        field(50012; "PR Line Type"; Enum "PR Asset Line Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "PBBKB"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Auto Insert from Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "BPB No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(50019; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(50020; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(50021; "PR Consignment Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        // field(50022; "WHT Business Posting Group"; Code[20])
        // {
        //     Caption = 'WHT Business Posting Group';
        //     TableRelation = "WHT Posting Setup"."WHT Business Posting Group";

        //     trigger OnValidate()
        //     begin
        //         // Debug untuk melihat nilai Business Posting Group
        //         //Message('Selected WHT Business Posting Group: %1', "WHT Business Posting Group");

        //         // Reset Product Posting Group dan WHT % jika Business Posting Group berubah
        //         if xRec."WHT Business Posting Group" <> Rec."WHT Business Posting Group" then begin
        //             "WHT Product Posting Group" := ''; // Kosongkan Product Posting Group
        //             "WHT %" := 0; // Reset nilai WHT %
        //             "WHT Amount" := 0;
        //         end;
        //     end;
        // }

        // field(50023; "WHT Product Posting Group"; Code[20])
        // {
        //     Caption = 'WHT Product Posting Group';
        //     TableRelation = "WHT Product Posting Group";
        //     trigger OnValidate()
        //     var
        //         WHTPostingSetup: Record "WHT Posting Setup";
        //     begin
        //         // Pastikan Business Posting Group sudah dipilih
        //         // if ("WHT Business Posting Group" = '') then
        //         //     Error('Please select a WHT Business Posting Group first.');

        //         // Validasi kombinasi dengan SetRange
        //         WHTPostingSetup.SetRange("WHT Business Posting Group", "WHT Business Posting Group");
        //         WHTPostingSetup.SetRange("WHT Product Posting Group", "WHT Product Posting Group");

        //         if WHTPostingSetup.FindFirst() then begin
        //             "WHT %" := WHTPostingSetup."WHT %"; // Set nilai WHT %
        //             "WHT Amount" := Round((Rec."Line Amount" * WHTPostingSetup."WHT %") / 100);
        //         end else
        //             Error('Invalid combination of WHT Business Posting Group and WHT Product Posting Group. Check table data.');
        //     end;
        // }
        // field(50025; "WHT %"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'WHT %';
        // }

        // field(50026; "WHT Amount"; Decimal)
        // {

        // }

        field(50102; "GL Budget Name"; Code[20])
        {

        }
        field(50103; "G/L Account No."; Code[20])
        {

        }
        field(50104; "GL Available Budget"; Decimal)
        {

        }
        field(50105; "GL Budgeted Amount"; Decimal)
        {

        }

    }
    trigger OnDelete()
    begin
        IF ("Purchase Req. No." <> '') AND ("Purchase Req. Line No." <> 0) THEN BEGIN
            CASE "PR Type" OF
                "PR Type"::Material:
                    BEGIN
                        IF ("RFQ No." <> '') AND ("RFQ Line No." <> 0) THEN BEGIN
                            gRecRFQLine.RESET;
                            gRecRFQLine.SETRANGE("RFQ No.", "RFQ No.");
                            gRecRFQLine.SETRANGE("Line No.", "RFQ Line No.");
                            IF gRecRFQLine.FINDFIRST THEN BEGIN
                                gCURFQFunct.updOutstandingQtyRFQ(gRecRFQLine, Rec.RecordID, 0, FALSE);
                            END;
                        END;
                    END;
            // "PR Type"::Asset:
            //     BEGIN
            //         gRecMSISetup.GET();
            //         IF (Rec."PR Line Type" = Rec."PR Line Type"::"Fixed Asset") AND ((Rec."Type" = Rec."Type"::"G/L Account") AND (Rec."No." = gRecMSISetup."No. G/L FA")) THEN deletePRFAList();
            //         gRecPRAssetLine.RESET;
            //         gRecPRAssetLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
            //         gRecPRAssetLine.SETRANGE("Line No.", "Purchase Req. Line No.");
            //         IF gRecPRAssetLine.FINDFIRST THEN BEGIN
            //             gCUPRAssetFunct.updOutstandingQtyPR(gRecPRAssetLine, Rec.RecordID, 0, FALSE);
            //         END;
            //     END;
            // "PR Type"::Consignment:
            //     BEGIN
            //         gRecPRConsLine.RESET;
            //         gRecPRConsLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
            //         gRecPRConsLine.SETRANGE("Line No.", "Purchase Req. Line No.");
            //         IF gRecPRConsLine.FINDFIRST THEN BEGIN

            //         END;
            //     END;
            END;
        END;
    end;

    // procedure deletePRFAList();
    // var
    //     lRec: Record "PR Asset FA List";
    // begin
    //     lRec.RESET;
    //     lRec.SETRANGE("PO No.", Rec."Document No.");
    //     lRec.SETRANGE("PO Line No.", Rec."Line No.");
    //     lRec.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
    //     lRec.SETRANGE("Purchase Req. Line No.", Rec."Purchase Req. Line No.");
    //     IF lRec.FIND('-') THEN BEGIN
    //         lRec.DELETEALL(TRUE);
    //     END;
    // end;

    procedure UpdateGLBudgetAmount_PO()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        GLEntry: Record "G/L Entry";
        PurchLine: Record "Purchase Line";
        TotalBudget: Decimal;
        TotalActual: Decimal;
        TotalCommitment: Decimal;
        StartDate: Date;
        EndDate: Date;
    begin
        Rec."GL Budgeted Amount" := 0;
        Rec."GL Available Budget" := 0;

        StartDate := DMY2DATE(1, 1, 2025);
        EndDate := DMY2DATE(31, 12, 2025);

        // Ambil total budget dari G/L Budget Entry
        GLBudgetEntry.SetRange("Budget Name", Rec."GL Budget Name");
        GLBudgetEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
        GLBudgetEntry.SetRange("Date", StartDate, EndDate);
        GLBudgetEntry.CalcSums("Amount");
        TotalBudget := GLBudgetEntry."Amount";
        Rec."GL Budgeted Amount" := TotalBudget;

        // Ambil total actual dari G/L Entry
        GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
        GLEntry.SetRange("Posting Date", StartDate, EndDate);
        TotalActual := 0;
        if GLEntry.FindSet() then
            repeat
                TotalActual += GLEntry."Amount";
            until GLEntry.Next() = 0;

        // Ambil total commitment dari semua PO yang masih open (bukan hanya PO ini)
        TotalCommitment := 0;
        PurchLine.Reset();
        PurchLine.SetRange("GL Budget Name", Rec."GL Budget Name");
        PurchLine.SetRange("G/L Account No.", Rec."G/L Account No.");
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        // Jika ada field status PO, filter hanya PO open/released
        if PurchLine.FindSet() then
            repeat
                TotalCommitment += PurchLine."Amount"; // Ganti dengan field Amount yang sesuai
            until PurchLine.Next() = 0;

        // Hitung Available Budget
        Rec."GL Available Budget" := TotalBudget - TotalActual - TotalCommitment;
    end;



    var
        gRecMSISetup: Record "MII Setup";
        gRecRFQLine: Record "RFQ Line";
        //gRecPRAssetLine: Record "PR Asset Line";
        //gRecPRConsLine: Record "PR Consignment Line";
        gCURFQFunct: Codeunit "RFQ Function";
    //gCUPRAssetFunct: Codeunit "PR Asset Function";

}
