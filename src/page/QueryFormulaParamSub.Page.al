page 51102 "Query Formula Param Sub TPE"
{
    ApplicationArea = All;
    Caption = 'Parameters';
    PageType = ListPart;
    SourceTable = "Query Formula Parameter TPE";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Query Formula Code"; Rec."Query Formula Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
                field("Test Value"; Rec."Test Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("GetFilters")
            {
                ApplicationArea = All;
                Caption = 'Get Filters';
                Image = Filter;
                ToolTip = 'Get Filters';
                trigger OnAction()
                begin
                    Message(Rec.GetFilters());
                end;
            }
        }
    }

    procedure SetFilter(pQueryFormulaCode: Code[20])
    begin
        Rec.Reset();
        Rec.SetRange("Query Formula Code", pQueryFormulaCode);
        CurrPage.Update();
    end;
}
