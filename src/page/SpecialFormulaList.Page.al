page 51109 "Special Formula List TPE"
{
    ApplicationArea = All;
    Caption = 'Special Formulas';
    PageType = List;
    SourceTable = "Special Formula TPE";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the special formula.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the special formula.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExecuteSpecialFormula)
            {
                ApplicationArea = All;
                Caption = 'Execute Special Formula';
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the selected special formula and shows the result.';

                trigger OnAction();
                begin
                    Message(this.SpecialFormulaManagement.ExecuteSpecialFormula(Rec."Code"));
                end;
            }
        }
    }

    var
        SpecialFormulaManagement: Codeunit "Special Formula Management TPE";

    trigger OnInit()
    begin
        this.SpecialFormulaManagement.GetSpecialFormulas(Rec);
    end;
}