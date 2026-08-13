tableextension 50114 "Invt. Document Line Ext" extends "Invt. Document Line"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                IF xRec."Item No." <> Rec."Item No." THEN BEGIN
                    IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                        ERROR('This line is from Material Request, Cannot change item no');
                    END;
                END;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                    IF "MR Purch. Receipt" THEN ERROR('This line is from MR purchase receipt, cannot change');
                    IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                        gRecMRLine.RESET;
                        gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                        gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                        IF gRecMRLine.FINDFIRST THEN BEGIN
                            IF gRecMRLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecMRLine."Outstanding Quantity" + xRec.Quantity);
                            gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, Quantity);
                        END;
                    END;
                END;
            end;
        }
        field(50000; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "MR Purch. Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    trigger OnDelete()
    begin
        IF (Rec."Material Req. No." <> '') AND (Rec."Material Req. Line No." <> 0) THEN BEGIN
            IF "MR Purch. Receipt" THEN BEGIN
                gRecMRLine.RESET;
                gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                IF gRecMRLine.FINDFIRST THEN BEGIN
                    gCUMRFunct.updQtyInvtShipReceipt(gRecMRLine, Rec.RecordID, 0);
                END;
            END
            ELSE BEGIN
                gRecMRLine.RESET;
                gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                IF gRecMRLine.FINDFIRST THEN BEGIN
                    gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, 0);
                END;
            END;
        END;
    end;

    var
        gRecMRLine: Record "Material Req. Line";
        gCUMRFunct: Codeunit "Material Req. Function";
}
