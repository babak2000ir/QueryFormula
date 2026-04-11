page 51105 "Query Formula Param Lookup TPE"
{
    ApplicationArea = All;
    Caption = 'Parameters';
    PageType = List;
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