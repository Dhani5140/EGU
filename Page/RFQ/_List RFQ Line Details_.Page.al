page 50129 "List RFQ Line Details"
{
    Caption = 'List RFQ Vendor Details';
    PageType = List;
    SourceTable = "RFQ Line Details";
    UsageCategory = Lists;
    Editable = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Subtotal Amount"; Rec."Subtotal Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
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
                // field("Check Win"; Rec."Check Win")
                // {
                //     ApplicationArea = All;
                //     Editable = FALSE;
                // }
            }
        }
    }
    var
        grecVendor: Record Vendor;
        gtxtName: Text[150];

    trigger OnAfterGetRecord()
    begin
        gtxtName := '';
        IF grecVendor.GET(Rec."Vendor No.") then begin
            gtxtName := grecVendor.Name;
        end
    end;
}
