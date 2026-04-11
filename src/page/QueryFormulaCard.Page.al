page 51101 "Query Formula Card TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula Card';
    PageType = Card;
    SourceTable = "Query Formula TPE";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
            part(Parameters; "Query Formula Param Sub TPE")
            {
                ApplicationArea = All;
                Caption = 'Parameters';
                SubPageLink = "Query Formula Code" = field(Code);
            }
            group("Table")
            {
                Caption = 'Table';
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }
            }
            part(Filters; "Query Formula Filter Sub TPE")
            {
                ApplicationArea = All;
                Caption = 'Filters';
                SubPageLink = "Query Formula Code" = field(Code);
            }
            group(Result)
            {
                Caption = 'Result';
                field("Query Type"; Rec."Query Type")
                {
                    ApplicationArea = All;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
