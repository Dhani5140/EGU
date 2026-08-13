page 50136 "RFQ Line Details Subform"
{
    PageType = ListPart;
    SourceTable = "RFQ Line Details";
    AutoSplitKey = true;
    DelayedInsert = true;
    RefreshOnActivate = TRUE;
    InsertAllowed = FALSE;
    Permissions = TableData "RFQ Line Details" = rmid;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No. RFQ Vendor";
                Rec."Entry No. RFQ Vendor")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    Visible = FALSE;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = all;
                    Editable = gsendtovendor;
                }
                field("Payment Terms Name"; Rec."Payment Terms Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(shipmentMet; Rec.shipmentMet)
                {
                    ApplicationArea = all;
                    Editable = gsendtovendor;
                    Caption = 'Shipment Method';
                }
                field("Shipment Method Name"; Rec."Shipment Method Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("PPH 22"; Rec."PPH 22")
                {
                    ApplicationArea = All;
                    Editable = gsendtovendor;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = gsendtovendor;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }

                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    Editable = gsendtovendor;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Delivery Amount"; Rec."Delivery Amount")
                {
                    ApplicationArea = all;
                    Editable = gsendtovendor;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gsendtovendor;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }



                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Remarks RFQ';
                    Editable = gBolEditable;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Editable = gsendtovendor; // Hanya bisa diedit saat negosiasi
                    Caption = 'Expected Receipt Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
    trigger OnOpenPage()
    begin
        // Rec.CalcFields("Status RFQ");
        // IF Rec."Status RFQ" = Rec."Status RFQ"::Open THEN
        //     gBolEditable := true;
        // IF Rec."Status RFQ" = rec."Status RFQ"::"Send To Vendor" then BEGIN
        //     gsendtovendor := TRUE;

        // END
        // ELSE BEGIN
        gBolEditable := FALSE;
        gsendtovendor := false;
    END;


    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Status RFQ");
        IF Rec."Status RFQ" = Rec."Status RFQ"::Open THEN
            gBolEditable := true;
        IF Rec."Status RFQ" = rec."Status RFQ"::"Send To Vendor" then BEGIN
            gsendtovendor := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
            gsendtovendor := false;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Rec.CalcFields("Status RFQ");
        IF Rec."Status RFQ" = Rec."Status RFQ"::Open THEN
            gBolEditable := true;
        IF Rec."Status RFQ" = rec."Status RFQ"::"Send To Vendor" then BEGIN
            gsendtovendor := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
            gsendtovendor := false;
        END;
    END;


    // trigger OnDeleteRecord(): Boolean
    // begin 
    //     gCURFQFunct.resetRFQLineWinner(Rec);
    //     CurrPage.UPDATE;
    // end;
    var
        gBolEditable, gsendtovendor : Boolean;
        gCURFQFunct: Codeunit "RFQ Function";
}
