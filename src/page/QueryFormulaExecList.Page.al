page 51106 "Query Formula Exec. List TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula Execution List';
    PageType = List;
    SourceTable = "Query Formula Execution TPE";
    SourceTableView = sorting(Code, "Parameter Name");
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                IndentationColumn = Rec."Indentation Level";
                IndentationControls = "Query Formula Code";
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Rec."Line Type" = Rec."Line Type"::Main;
                }
                field("Query Formula Code"; Rec."Query Formula Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Rec."Line Type" = Rec."Line Type"::Main;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = Rec."Line Type" = Rec."Line Type"::Main;
                }
                field("Parameter Name"; Rec."Parameter Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
