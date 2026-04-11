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
            }
        }
    }
}
