using System.Collections.Generic;

namespace Qaemshahr.Core
{
    public sealed class NamedCount
    {
        public string Key { get; set; }
        public string Label { get; set; }
        public int Count { get; set; }
        public string Light { get; set; }
    }

    public sealed class DashboardActionRow
    {
        public string EmployeeId { get; set; }
        public string Name { get; set; }
        public string Position { get; set; }
        public string Detail { get; set; }
        public string Light { get; set; }
        public string OpenTarget { get; set; }
        public string PhotoPath { get; set; }
    }

    public sealed class HrDashboardSnapshot
    {
        public int Year { get; set; }
        public int Season { get; set; }
        public string SeasonTitleFa { get; set; }

        public int Total { get; set; }
        public int Active { get; set; }
        public int Inactive { get; set; }

        public int Gray { get; set; }
        public int Red { get; set; }
        public int Orange { get; set; }
        public int Yellow { get; set; }
        public int Green { get; set; }

        public int CoveredThisSeason { get; set; }
        public int Incomplete { get; set; }
        public int MissingContact { get; set; }

        public int PhotoCount { get; set; }
        public int BirthDocCount { get; set; }
        public int NationalDocCount { get; set; }

        public int Exemplary { get; set; }
        public int ExtraOrg { get; set; }
        public int StaffCount { get; set; }
        public int WorkerCount { get; set; }
        public int InGroupCount { get; set; }
        public int NotInGroupCount { get; set; }
        public int DocsCompleteCount { get; set; }

        public List<NamedCount> Lights { get; set; }
        public List<NamedCount> PersonTypes { get; set; }
        public List<NamedCount> EmploymentTypes { get; set; }
        public List<NamedCount> GenderBands { get; set; }
        public List<NamedCount> MaritalBands { get; set; }
        public List<NamedCount> AgeBands { get; set; }
        public List<NamedCount> TenureBands { get; set; }
        public List<NamedCount> EducationLevels { get; set; }
        public List<NamedCount> Skills { get; set; }
        public List<NamedCount> HireMonths { get; set; }
        public List<NamedCount> Documents { get; set; }
        public List<NamedCount> Groups { get; set; }

        public List<DashboardActionRow> RiskActions { get; set; }
        public List<DashboardActionRow> ContactActions { get; set; }
        public List<DashboardActionRow> IncompleteActions { get; set; }
        public List<DashboardActionRow> UnevaluatedActions { get; set; }
        public List<DashboardActionRow> ExemplaryPeople { get; set; }
        public List<DashboardActionRow> ExtraOrgPeople { get; set; }

        public double DocsCompletePercent
        {
            get { return Active <= 0 ? 0 : 100.0 * DocsCompleteCount / Active; }
        }

        public HrDashboardSnapshot()
        {
            Lights = new List<NamedCount>();
            PersonTypes = new List<NamedCount>();
            EmploymentTypes = new List<NamedCount>();
            GenderBands = new List<NamedCount>();
            MaritalBands = new List<NamedCount>();
            AgeBands = new List<NamedCount>();
            TenureBands = new List<NamedCount>();
            EducationLevels = new List<NamedCount>();
            Skills = new List<NamedCount>();
            HireMonths = new List<NamedCount>();
            Documents = new List<NamedCount>();
            Groups = new List<NamedCount>();
            RiskActions = new List<DashboardActionRow>();
            ContactActions = new List<DashboardActionRow>();
            IncompleteActions = new List<DashboardActionRow>();
            UnevaluatedActions = new List<DashboardActionRow>();
            ExemplaryPeople = new List<DashboardActionRow>();
            ExtraOrgPeople = new List<DashboardActionRow>();
        }
    }
}
