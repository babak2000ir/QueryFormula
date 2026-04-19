page 51113 "Query Formula Exec. Card TPE"
{
    Caption = 'Query Formula Execution Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Query Formula Execution TPE";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
            part(QueryFormulaExecSteps; "Query Formula Exec. Steps TPE")
            {
                ApplicationArea = All;
                SubPageLink = "Query Formula Execution Code" = field("Code");
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin

                end;
            }
        }
    }
}