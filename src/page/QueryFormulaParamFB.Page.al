page 51103 "Query Formula Param FB TPE"
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
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
