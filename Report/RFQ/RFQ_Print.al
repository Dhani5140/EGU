report 50103 RFQ_Printour
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = test3;

    dataset
    {
        dataitem("RFQ Header"; "RFQ Header")
        {
            RequestFilterFields = "RFQ No.";

            column(RFQ_No_; "RFQ No.") { }
            column(Document_Date; "Document Date") { }
            column(CompanyName; gRecCompany.Name) { }
            column(CompanyPicture; gRecCompany.Picture) { }
            column(CompanyAddress; gRecCompany.Address) { }
            column(CompanyAdd2; gRecCompany."Address 2") { }

            dataitem("RFQ Vendor List"; "RFQ Vendor List")
            {
                DataItemLink = "RFQ No." = field("RFQ No.");

                // FIX: Filter vendor dari luar report
                DataItemTableView = sorting("RFQ No.", "Entry No. RFQ Vendor");

                column(Vendor_Name; "Vendor Name") { }
                column(Vendor_No_; "Vendor No.") { }
                column(ven_add; ven_add) { }
                column(ven_add2; ven_add2) { }
                column(phone; phone) { }
                column(city; city) { }
                column(Shipment_Method_Name; "Shipment Method Name") { }
                column(Payment_Terms_Name; "Payment Terms Name") { }
                column(Shipping_Date; "Shipping Date") { }

                dataitem("RFQ Line"; "RFQ Line")
                {
                    DataItemLink = "RFQ No." = field("RFQ No.");

                    column(No_; "No.") { }
                    column(Description; Description) { }
                    column(Unit_of_Measure; "Unit of Measure") { }
                    column(Quantity; Quantity) { }
                }

                trigger OnAfterGetRecord()
                begin
                    vdr.SetRange("No.", "RFQ Vendor List"."Vendor No.");
                    if vdr.FindFirst() then begin
                        ven_add := vdr.Address;
                        ven_add2 := vdr."Address 2";
                        city := vdr.City;
                        phone := vdr."Phone No.";
                    end;
                end;

                // FIX: Apply filter vendor dari parameter
                trigger OnPreDataItem()
                begin
                    if gVendorNo <> '' then
                        SetRange("Vendor No.", gVendorNo);
                end;
            }
        }
    }

    rendering
    {
        layout(test3)
        {
            Type = RDLC;
            LayoutFile = 'Report/Layout/RFQ_Printout.rdl';
        }
    }

    trigger OnInitReport()
    begin
        gRecCompany.GET();
        gRecCompany.CalcFields(Picture);
        gRowNo := 0;
    end;

    // FIX: Procedure untuk set filter vendor dari luar
    procedure SetVendorFilter(VendorNo: Code[20])
    begin
        gVendorNo := VendorNo;
    end;

    var
        gRecCompany: Record "Company Information";
        gRowNo: Integer;
        gVendorNo: Code[20];  // FIX: Variable filter vendor
        vdr: Record Vendor;
        ven_add: Text[100];
        ven_add2: Text[50];
        city: Text[20];
        phone: Text[20];
}