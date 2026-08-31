pageextension 50102 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Location Code")
        {
            field("Receiving No. Series"; Rec."Receiving No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("Status")
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = all;
            }

            field("Purchase Req. No."; Rec."Purchase Req. No.")
            {
                ApplicationArea = all;
            }

            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = all;
            }
            // field("No. Polisi"; Rec."No. Polisi")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Surat Jalan"; Rec."No. Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Shipment Method Code")
        {
            // field("Shipping Date"; Rec."Shipping Date")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Surat Jalan"; Rec."No. Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Polisi"; Rec."No. Polisi")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Payment Method Code")
        {
            field("Payment Date"; Rec."Payment Date")
            {
                ApplicationArea = All;
            }
            field("Payment Date Description"; Rec."Payment Date Description")
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter(Warehouse)
        {
            // action("Print Rekap PR Consignment")
            // {
            //     ApplicationArea = All;
            //     Image = Print;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     PromotedIsBig = TRUE;

            //     trigger OnAction()
            //     var
            //         lRecPurchHeader: Record "Purchase Header";
            //         lRecPurchLine: Record "Purchase Line";
            //     begin
            //         Rec.TestField(Rec."No.");
            //         lRecPurchLine.RESET;
            //         lRecPurchLine.SETRANGE("Document Type", Rec."Document Type");
            //         lRecPurchLine.SETRANGE("Document No.", Rec."No.");
            //         lRecPurchLine.SETRANGE("PR Type", lRecPurchLine."PR Type"::Consignment);
            //         IF NOT lRecPurchLine.FINDFIRST THEN ERROR('This purchase order doesnt have PR Line consignment in it, cannot print');
            //         lRecPurchHeader.RESET;
            //         lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");

            //     end;
            // }
            // action("Print Rekap Pembelian Barang")
            // {
            //     ApplicationArea = All;
            //     Image = Print;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     PromotedIsBig = TRUE;

            //     trigger OnAction()
            //     var
            //         lRecPurchHeader: Record "Purchase Header";
            //         lRecPurchLine: Record "Purchase Line";
            //     begin
            //         Rec.TestField(Rec."No.");
            //         lRecPurchHeader.RESET;
            //         lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");

            //     end;
            // }

            group("Document Tracking")
            {
                Image = OrderTracking;

                action("Material Request")
                {
                    ApplicationArea = all;
                    Caption = 'Material Request Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    var
                        mr: Record "Material Req. Line";
                    begin
                        // Cek apakah field MR sudah terisi
                        Rec.TestField("Material Req. No.");

                        mr.SetRange("Material Req. No.", Rec."Material Req. No.");
                        page.run(PAGE::"Material Request Lines", mr);
                    end;
                }

                action("Purchase Request")
                {
                    ApplicationArea = all;
                    Caption = 'Purchase Request Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    var
                        pr: Record "PR Material Line";
                    begin
                        // Cek apakah field PR sudah terisi
                        Rec.TestField("Purchase Req. No.");

                        pr.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                        page.run(PAGE::"PR Material Lines", pr);
                    end;
                }

                action("RFQ DOC")
                {
                    ApplicationArea = all;
                    Caption = 'RFQ Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    var
                        rfq: Record "RFQ Line";
                    begin
                        // Cek apakah field RFQ sudah terisi
                        Rec.TestField("RFQ No.");

                        rfq.SetRange("RFQ No.", Rec."RFQ No.");
                        page.run(PAGE::"RFQ Request Lines", rfq);
                    end;
                }

                action("Vensel DOC")
                {
                    ApplicationArea = all;
                    Caption = 'Vendor selection Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    var
                        venselLine: Record "RFQ Line";
                    begin
                        // Sesuai mapping Anda sebelumnya, Vensel Doc memfilter berdasar PR No
                        Rec.TestField("Purchase Req. No.");

                        venselLine.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                        page.run(PAGE::"vensel Request Lines", venselLine);
                    end;
                }
            }
        }
        addlast(processing)
        {

        }
    }
    trigger OnAfterGetRecord()
    var
        lRecVensel: Record "Vensel Header";
        lRecRFQLineDetail: Record "RFQ Line Details";
        IsModified: Boolean;
    begin
        IsModified := false;


        if (Rec."RFQ No." = '') or (Rec."Purchase Req. No." = '') or (Rec."Material Req. No." = '') then begin


            if lRecVensel.Get(Rec."Your Reference") then begin

                if Rec."RFQ No." = '' then begin
                    Rec."RFQ No." := lRecVensel."RFQ No.";
                    IsModified := true;
                end;


                if lRecVensel."RFQ No." <> '' then begin
                    lRecRFQLineDetail.Reset();
                    lRecRFQLineDetail.SetRange("RFQ No.", lRecVensel."RFQ No."); // Filter ke nomor RFQ yang sama


                    if lRecRFQLineDetail.FindFirst() then begin

                        if Rec."Purchase Req. No." = '' then begin
                            Rec."Purchase Req. No." := lRecRFQLineDetail."Purchase Req. No.";
                            IsModified := true;
                        end;

                        if Rec."Material Req. No." = '' then begin
                            Rec."Material Req. No." := lRecRFQLineDetail."Material Req. No.";
                            IsModified := true;
                        end;
                    end;
                end;
            end;


            if IsModified then
                Rec.Modify(false);
        end;
    end;
}


