// page 50133 "List Genrated List"
// {
//     ApplicationArea = all;
//     Caption = 'List Generated Faktur';
//     PageType = List;
//     SourceTable = "Table View Generate Header";
//     UsageCategory = Lists;
//     CardPageId = "Page view Generate";


//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Faktur Pajak ID"; Rec."Faktur Pajak ID")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {

//                 trigger OnAction()
//                 begin

//                 end;
//             }
//         }
//     }
// }