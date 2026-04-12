page 51108 "Query Formula Exec. Steps TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula Execution Steps';
    PageType = List;
    SourceTable = "Query Formula Exec. Step TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                IndentationColumn = Rec."Indentation Level";
                IndentationControls = "Query Formula Code";
                field("Query Formula Execution Code"; Rec."Query Formula Execution Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Rec."Indentation Level" = 0;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Parent Line No."; Rec."Parent Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Query Formula Code"; Rec."Query Formula Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Rec."Indentation Level" = 0;
                }
                field("Parameter Name"; Rec."Parameter Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value Query"; Rec."Value Query")
                {
                    ApplicationArea = All;
                    Editable = Rec."Indentation Level" > 0;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Editable = Rec."Indentation Level" > 0;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if not Confirm('This will delete all lines on the same level and lower. Are you sure?') then
            exit(false);
        exit(true);
    end;
}