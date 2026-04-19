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
            group(Steps)
            {
                part(QueryFormulaExecSteps; "Query Formula Exec. Steps TPE")
                {
                    ApplicationArea = All;
                    SubPageLink = "Query Formula Execution Code" = field("Code");
                }
                part(QueryFormulaParameters; "Query Formula Param Sub TPE")
                {
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(SetTargetFilter1)
            {
                ApplicationArea = All;
                Image = SetPriorities;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CurrPage.QueryFormulaParameters.Page.SetFilter('');
                end;
            }
            action(SetTargetFilter2)
            {
                ApplicationArea = All;
                Image = SetPriorities;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CurrPage.QueryFormulaParameters.Page.SetFilter('HIGHSALES');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.QueryFormulaParameters.Page.SetFilter(CurrPage.QueryFormulaExecSteps.Page.GetQueryCode());
    end;

    trigger OnOpenPage()
    begin
        CurrPage.QueryFormulaParameters.Page.SetFilter('');
    end;
}