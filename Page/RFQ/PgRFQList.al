// namespace PR.RFQ;



// page 60113 RFQList
// {
//     Caption = 'Request For Quotation';
//     ApplicationArea = basic, suite;
//     DataCaptionFields = "No.";
//     CardPageId = RfqHeader;
//     Editable = false;
//     RefreshOnActivate = true;
//     PageType = List;
//     SourceTable = RFQHEADER;
//     UsageCategory = Lists;
//     QueryCategory = 'RFQLine';



//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 field("No."; Rec."No.")
//                 {
//                     ApplicationArea = Suite;
//                 }
//                 field("No.PPB"; Rec."No.PPB")
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Nomor PPB';
//                 }
//                 field(Peuntukan; Rec.Peuntukan)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Peruntukan';
//                 }
//                 field(VendorNo; Rec.VendorNo)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Vendor No';
//                 }
//                 field(vendorname; Rec.vendorname)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Vendor Name';
//                 }
//                 field(PYT; Rec.PYT)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Payment Terms';
//                 }
//                 field(EstimateDelivery; Rec.EstimateDelivery)
//                 {
//                     ApplicationArea = suite;
//                     Caption = 'Estimate Date Delivery';
//                 }

//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = Suite;
//                     Caption = 'Status';
//                 }
//             }
//         }
//     }

//     actions
//     {

//     }
// }

