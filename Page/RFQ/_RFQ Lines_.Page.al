page 50144 "RFQ Lines"
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

                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    lRecRFQHeader: Record "RFQ Header";
                begin
                    lRecRFQHeader.Get(Rec."RFQ No.");
                    PAGE.Run(PAGE::"RFQ Card", lRecRFQHeader);
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
