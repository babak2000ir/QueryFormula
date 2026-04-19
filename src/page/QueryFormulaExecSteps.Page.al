page 51108 "Query Formula Exec. Steps TPE"
{
    AutoSplitKey = true;
    Caption = 'Query Formula Execution Steps';
    PageType = ListPart;
    SourceTable = "Query Formula Exec. Step TPE";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Query Formula Execution Code"; Rec."Query Formula Execution Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Variable Code"; Rec."Variable Code")
                {
                    ApplicationArea = All;
                }
                field("Statement Type"; Rec."Statement Type")
                {
                    ApplicationArea = All;
                }
                field(Statement; Rec.Statement)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure GetQueryCode(): Code[20]
    begin
        if Rec."Statement Type" = Rec."Statement Type"::QueryFormula then
            exit(Rec.Statement)
        else
            exit('');
    end;
}