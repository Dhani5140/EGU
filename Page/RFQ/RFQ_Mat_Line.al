page 50151 "RFQ Request Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "RFQ Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = ALL;
                    Visible = true;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Location;
                Caption = 'Show Document';
                Image = View;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Open the document that the selected line exists on.';

                trigger OnAction()
                var
                    lRecPRHeader: Record "RFQ Header";
                    pagemanagement: Codeunit "Page Management";
                begin
                    lRecPRHeader.Get(Rec."RFQ No.");
                    PAGE.Run(PAGE::"RFQ Card SH", lRecPRHeader);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Show Document_Promoted"; "Show Document")
                {
                }
            }
        }
    }
}
