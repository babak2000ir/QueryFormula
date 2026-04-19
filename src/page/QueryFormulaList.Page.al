page 51100 "Query Formula List TPE"
{
    ApplicationArea = All;
    Caption = 'Query Formula List';
    CardPageID = "Query Formula Card TPE";
    PageType = List;
    SourceTable = "Query Formula TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(MyField; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
            part(ParameterFactbox; "Query Formula Param FB TPE")
            {
                ApplicationArea = All;
                Caption = 'Parameters';
                SubPageLink = "Query Formula Code" = field(Code);
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

                trigger OnAction();
                begin

                end;
            }
        }
    }

    procedure SetRecord(Value: Text[250])
    begin
        if Rec.FindFirst() then;
        if Value <> '' then
            if Rec.FindSet() then
                repeat
                    if Rec."Code" = Value then
                        exit;
                until Rec.Next() = 0;
    end;
}