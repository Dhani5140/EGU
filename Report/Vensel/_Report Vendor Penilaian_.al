report 50100 "Simple Vendor Evaluation"
{
    Caption = 'Vendor Delivery Evaluation';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = 'AdvVendorEvaluation.rdl';

    dataset
    {
        // 1. KEPALA UTAMA: VENDOR SELECTION
        dataitem(VenselHeader; "Vensel Header")
        {
            RequestFilterFields = "Vensel No.";

            // FIX 1: Ganti "No." menjadi "Vensel No."
            column(Vensel_No; "Vensel No.") { }
            column(PR_No; "Purchase Request No.") { }
            column(RFQ_No; "RFQ No.") { }

            column(TotalReceipts; TotalReceipts) { }
            column(TotalLate; TotalLate) { }
            column(Score; Score) { }
            column(Grade; Grade) { }

            // 2. ANAK: PURCHASE ORDER (PO)
            // Mencari PO yang field "Your Reference"-nya berisi nomor Vendor Selection ini
            dataitem(POHeader; "Purchase Header")
            {
                // FIX 2: Ganti "No." menjadi "Vensel No."
                DataItemLink = "Your Reference" = field("Vensel No.");
                DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));

                column(PO_No; "No.") { }
                column(Vendor_No; "Buy-from Vendor No.") { }
                column(Vendor_Name; "Buy-from Vendor Name") { }

                // 3. CUCU: PENERIMAAN BARANG (RECEIPT)
                dataitem(PurchRcptLine; "Purch. Rcpt. Line")
                {
                    DataItemLink = "Order No." = field("No.");
                    DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item), Quantity = filter('>0'));

                    column(Receipt_No; "Document No.") { }
                    column(Item_No; "No.") { }
                    column(Description; Description) { }
                    column(Expected_Date; Format("Expected Receipt Date", 0, '<Day,2>-<Month,2>-<Year4>')) { }
                    column(Actual_Date; Format("Posting Date", 0, '<Day,2>-<Month,2>-<Year4>')) { }
                    column(Delay_Days; DelayDays) { }
                    column(Is_Late_Text; IsLateText) { }

                    trigger OnAfterGetRecord()
                    begin
                        if "Expected Receipt Date" = 0D then
                            CurrReport.Skip();

                        if "Posting Date" > "Expected Receipt Date" then begin
                            DelayDays := "Posting Date" - "Expected Receipt Date";
                            IsLateText := 'LATE';
                        end else begin
                            DelayDays := 0;
                            IsLateText := 'ON-TIME';
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                lRecPO: Record "Purchase Header";
                lRecRcpt: Record "Purch. Rcpt. Line";
            begin
                TotalReceipts := 0;
                TotalLate := 0;
                Score := 0;
                Grade := '';

                // Hitung Skor sebelum data di-render ke RDLC
                lRecPO.Reset();
                lRecPO.SetRange("Document Type", lRecPO."Document Type"::Order);

                // FIX 3: Ganti "No." menjadi "Vensel No."
                lRecPO.SetRange("Your Reference", "Vensel No.");

                if lRecPO.FindSet() then begin
                    repeat
                        lRecRcpt.Reset();
                        lRecRcpt.SetRange("Order No.", lRecPO."No.");
                        lRecRcpt.SetRange(Type, lRecRcpt.Type::Item);
                        lRecRcpt.SetFilter("Expected Receipt Date", '<>%1', 0D);
                        lRecRcpt.SetFilter(Quantity, '>0');

                        if lRecRcpt.FindSet() then begin
                            repeat
                                TotalReceipts += 1;
                                if lRecRcpt."Posting Date" > lRecRcpt."Expected Receipt Date" then
                                    TotalLate += 1;
                            until lRecRcpt.Next() = 0;
                        end;
                    until lRecPO.Next() = 0;
                end;

                // Jika Vensel ini belum punya penerimaan sama sekali, jangan ditampilkan
                if TotalReceipts = 0 then
                    CurrReport.Skip();

                Score := 100 - ((TotalLate / TotalReceipts) * 100);

                if Score >= 90 then
                    Grade := 'A (Sangat Baik)'
                else if Score >= 75 then
                    Grade := 'B (Baik)'
                else if Score >= 50 then
                    Grade := 'C (Buruk)'
                else
                    Grade := 'D (Sangat Buruk)';
            end;
        }
    }

    var
        TotalReceipts: Integer;
        TotalLate: Integer;
        Score: Decimal;
        Grade: Text[20];
        DelayDays: Integer;
        IsLateText: Text[10];
}