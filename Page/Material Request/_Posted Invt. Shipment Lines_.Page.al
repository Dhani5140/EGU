page 50123 "Posted Invt. Shipment Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "Invt. Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
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
                    lRecInvShipHeader: Record "Invt. Shipment Header";
                begin
                    lRecInvShipHeader.Get(Rec."Document No.");
                    PAGE.Run(PAGE::"Posted Invt. Shipment", lRecInvShipHeader);
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
