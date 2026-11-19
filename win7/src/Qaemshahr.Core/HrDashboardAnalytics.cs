using System;
using System.Collections.Generic;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Core
{
    public static class HrDashboardAnalytics
    {
        public const int ActionLimit = 8;

        public static bool IsActive(Employee e)
        {
            return e != null && e.EmploymentStatus != "inactive";
        }

        public static string LightOf(Employee e)
        {
            if (e == null || string.IsNullOrWhiteSpace(e.PerformanceLight))
                return PerformanceLights.Gray;
            return e.PerformanceLight;
        }

        public static bool MissingContact(Employee e)
        {
            return e == null
                || string.IsNullOrWhiteSpace(e.PrimaryPhone)
                || string.IsNullOrWhiteSpace(e.CurrentPosition);
        }

        public static bool IsIncomplete(string employeeId, ISet<string> photos, ISet<string> birth, ISet<string> national)
        {
            if (photos == null || birth == null || national == null || string.IsNullOrEmpty(employeeId))
                return false;
            return !photos.Contains(employeeId) || !birth.Contains(employeeId) || !national.Contains(employeeId);
        }

        public static string MissingFileSummary(string employeeId, ISet<string> photos, ISet<string> birth, ISet<string> national)
        {
            var bits = new List<string>();
            if (photos == null || !photos.Contains(employeeId))
                bits.Add("عکس ۴×۳");
            if (birth == null || !birth.Contains(employeeId))
                bits.Add("شناسنامه");
            if (national == null || !national.Contains(employeeId))
                bits.Add("کارت ملی");
            return string.Join("، ", bits.ToArray());
        }

        public static bool CoveredThisSeason(Employee e, int year, int season)
        {
            return e != null && e.PerformanceYear == year && e.PerformanceSeason == season;
        }

        public static bool MatchesFilter(Employee e, string filter, string value,
            ISet<string> photos, ISet<string> birth, ISet<string> national, int year, int season,
            ISet<string> groupMemberIds = null)
        {
            if (e == null)
                return false;
            switch (filter)
            {
                case DashboardFilter.Active:
                    return IsActive(e);
                case DashboardFilter.Inactive:
                    return !IsActive(e);
                case DashboardFilter.Gray:
                    return IsActive(e) && LightOf(e) == PerformanceLights.Gray;
                case DashboardFilter.Red:
                    return IsActive(e) && LightOf(e) == PerformanceLights.Red;
                case DashboardFilter.Orange:
                    return IsActive(e) && LightOf(e) == PerformanceLights.Orange;
                case DashboardFilter.Yellow:
                    return IsActive(e) && LightOf(e) == PerformanceLights.Yellow;
                case DashboardFilter.Green:
                    return IsActive(e) && LightOf(e) == PerformanceLights.Green;
                case DashboardFilter.Incomplete:
                    return IsActive(e) && IsIncomplete(e.Id, photos, birth, national);
                case DashboardFilter.Contact:
                    return IsActive(e) && MissingContact(e);
                case DashboardFilter.SeasonOpen:
                    return IsActive(e) && !CoveredThisSeason(e, year, season);
                case DashboardFilter.Exemplary:
                    return IsActive(e) && e.PerformanceExemplary;
                case DashboardFilter.ExtraOrg:
                    return IsActive(e) && e.ExtraOrgBadge;
                case DashboardFilter.Type:
                    var type = string.IsNullOrWhiteSpace(e.EmploymentType) ? "" : e.EmploymentType.Trim();
                    var want = value ?? string.Empty;
                    return IsActive(e) && type == want;
                case DashboardFilter.PersonType:
                    return IsActive(e) && string.Equals(
                        HrLookups.PersonTypeFa(e.PersonType), value ?? "", StringComparison.Ordinal);
                case DashboardFilter.PersonStaff:
                    return IsActive(e) && !HrLookups.IsWorker(e.PersonType);
                case DashboardFilter.PersonWorker:
                    return IsActive(e) && HrLookups.IsWorker(e.PersonType);
                case DashboardFilter.MissingPhoto:
                    return IsActive(e) && photos != null && !photos.Contains(e.Id);
                case DashboardFilter.MissingBirth:
                    return IsActive(e) && birth != null && !birth.Contains(e.Id);
                case DashboardFilter.MissingNational:
                    return IsActive(e) && national != null && !national.Contains(e.Id);
                case DashboardFilter.Gender:
                    return IsActive(e) && string.Equals(
                        HrLookups.NormalizeGender(e.Gender) ?? NormLabel(e.Gender),
                        HrLookups.NormalizeGender(value) ?? NormLabel(value),
                        StringComparison.Ordinal);
                case DashboardFilter.Marital:
                    return IsActive(e) && string.Equals(NormLabel(e.MaritalStatus), NormLabel(value), StringComparison.Ordinal);
                case DashboardFilter.Group:
                case DashboardFilter.InGroup:
                    return IsActive(e) && groupMemberIds != null && groupMemberIds.Contains(e.Id);
                case DashboardFilter.NotInGroup:
                    return IsActive(e) && (groupMemberIds == null || !groupMemberIds.Contains(e.Id));
                default:
                    return true;
            }
        }

        public static bool FilterNeedsFiles(string filter)
        {
            return filter == DashboardFilter.Incomplete
                || filter == DashboardFilter.MissingPhoto
                || filter == DashboardFilter.MissingBirth
                || filter == DashboardFilter.MissingNational;
        }

        public static bool FilterNeedsGroupMembers(string filter)
        {
            return filter == DashboardFilter.Group
                || filter == DashboardFilter.InGroup
                || filter == DashboardFilter.NotInGroup;
        }

        static string NormLabel(string value)
        {
            var t = (value ?? "").Trim();
            return t.Length == 0 ? "نامشخص" : t;
        }

        public static HrDashboardSnapshot Build(
            IList<Employee> people,
            ISet<string> photos,
            ISet<string> birth,
            ISet<string> national,
            IDictionary<string, string> education,
            IDictionary<string, string> skills,
            IList<NamedCount> groupStats,
            ISet<string> membersInAnyGroup)
        {
            var snap = new HrDashboardSnapshot();
            snap.Year = PersianDate.CurrentYear();
            snap.Season = EvaluationScoring.CurrentSeason();
            snap.SeasonTitleFa = EvaluationScoring.SeasonFa(snap.Season) + " " + snap.Year;

            if (people == null)
                people = new List<Employee>();
            if (photos == null)
                photos = new HashSet<string>();
            if (birth == null)
                birth = new HashSet<string>();
            if (national == null)
                national = new HashSet<string>();
            if (education == null)
                education = new Dictionary<string, string>();
            if (skills == null)
                skills = new Dictionary<string, string>();
            if (membersInAnyGroup == null)
                membersInAnyGroup = new HashSet<string>();

            snap.Total = people.Count;
            var types = new Dictionary<string, int>(StringComparer.Ordinal);
            var personTypes = new Dictionary<string, int>(StringComparer.Ordinal);
            var genders = new Dictionary<string, int>(StringComparer.Ordinal);
            var maritals = new Dictionary<string, int>(StringComparer.Ordinal);
            var edu = new Dictionary<string, int>(StringComparer.Ordinal);
            var skillMap = new Dictionary<string, int>(StringComparer.Ordinal);
            var age = NewBand("lt30", "کمتر از ۳۰", "30s", "۳۰ تا ۳۹", "40s", "۴۰ تا ۴۹", "50s", "۵۰ تا ۵۹", "60p", "۶۰ و بیشتر", "unk", "نامشخص");
            var tenure = NewBand("lt2", "کمتر از ۲ سال", "2to5", "۲ تا ۵ سال", "5to10", "۵ تا ۱۰ سال", "10to20", "۱۰ تا ۲۰ سال", "20p", "بیش از ۲۰ سال", "unk", "نامشخص");
            var hireKeys = BuildHireKeys(snap.Year, PersianDate.CurrentMonth());
            var hireCounts = new Dictionary<string, int>(StringComparer.Ordinal);
            foreach (var k in hireKeys)
                hireCounts[k.Key] = 0;

            var risk = new List<DashboardActionRow>();
            var contact = new List<DashboardActionRow>();
            var incomplete = new List<DashboardActionRow>();
            var unevaluated = new List<DashboardActionRow>();
            var exemplary = new List<DashboardActionRow>();
            var extra = new List<DashboardActionRow>();

            foreach (var e in people)
            {
                if (e == null)
                    continue;
                var active = IsActive(e);
                if (active)
                    snap.Active++;
                else
                    snap.Inactive++;

                if (!active)
                {
                    CountHire(hireCounts, e);
                    continue;
                }

                var light = LightOf(e);
                if (light == PerformanceLights.Red) snap.Red++;
                else if (light == PerformanceLights.Orange) snap.Orange++;
                else if (light == PerformanceLights.Yellow) snap.Yellow++;
                else if (light == PerformanceLights.Green) snap.Green++;
                else snap.Gray++;

                if (CoveredThisSeason(e, snap.Year, snap.Season))
                    snap.CoveredThisSeason++;
                if (IsIncomplete(e.Id, photos, birth, national))
                {
                    snap.Incomplete++;
                    if (incomplete.Count < ActionLimit)
                        incomplete.Add(Row(e, MissingFileSummary(e.Id, photos, birth, national), light, "file"));
                }
                else
                    snap.DocsCompleteCount++;

                if (MissingContact(e))
                {
                    snap.MissingContact++;
                    if (contact.Count < ActionLimit)
                        contact.Add(Row(e, "تلفن یا سمت ناقص", light, "file"));
                }
                if (photos.Contains(e.Id))
                    snap.PhotoCount++;
                if (birth.Contains(e.Id))
                    snap.BirthDocCount++;
                if (national.Contains(e.Id))
                    snap.NationalDocCount++;

                if (e.PerformanceExemplary)
                {
                    snap.Exemplary++;
                    if (exemplary.Count < 5)
                        exemplary.Add(Row(e, ScoreDetail(e), light, "file"));
                }
                if (e.ExtraOrgBadge)
                {
                    snap.ExtraOrg++;
                    if (extra.Count < 5)
                    {
                        var detail = e.IntroducedOrganizations != null && e.IntroducedOrganizations.Count > 0
                            ? string.Join("، ", e.IntroducedOrganizations)
                            : "معرفی فراسازمانی";
                        extra.Add(Row(e, detail, light, "file"));
                    }
                }

                if (HrLookups.IsWorker(e.PersonType))
                    snap.WorkerCount++;
                else
                    snap.StaffCount++;

                if (!string.IsNullOrEmpty(e.Id) && membersInAnyGroup.Contains(e.Id))
                    snap.InGroupCount++;
                else
                    snap.NotInGroupCount++;

                if (light == PerformanceLights.Red || light == PerformanceLights.Orange)
                    risk.Add(Row(e, ScoreDetail(e), light, "file"));
                if (light == PerformanceLights.Gray && unevaluated.Count < ActionLimit)
                    unevaluated.Add(Row(e, "برگه تأییدشده ندارد", light, "file"));

                Count(types, string.IsNullOrWhiteSpace(e.EmploymentType) ? "" : e.EmploymentType.Trim());
                Count(personTypes, HrLookups.PersonTypeFa(e.PersonType));
                Count(genders, HrLookups.NormalizeGender(e.Gender) ?? NormLabel(e.Gender));
                Count(maritals, NormLabel(e.MaritalStatus));

                string eduLevel = (e.EducationLevel ?? "").Trim();
                if (eduLevel.Length == 0)
                {
                    string mapped;
                    if (education.TryGetValue(e.Id ?? "", out mapped) && !string.IsNullOrWhiteSpace(mapped))
                        eduLevel = mapped.Trim();
                }
                if (eduLevel.Length == 0)
                    eduLevel = "نامشخص";
                Count(edu, eduLevel);

                string skill = (e.SkillName ?? "").Trim();
                if (skill.Length == 0)
                {
                    string mappedSkill;
                    if (skills.TryGetValue(e.Id ?? "", out mappedSkill) && !string.IsNullOrWhiteSpace(mappedSkill))
                        skill = mappedSkill.Trim();
                }
                if (skill.Length > 0)
                    Count(skillMap, skill);

                BandAge(age, PersianDate.CompleteYears(e.BirthDate));
                BandTenure(tenure, PersianDate.CompleteYears(e.EmploymentDate));
                CountHire(hireCounts, e);
            }

            risk.Sort(CompareRisk);
            if (risk.Count > ActionLimit)
                risk = risk.GetRange(0, ActionLimit);

            snap.Lights.Add(LightSlice(PerformanceLights.Green, snap.Green));
            snap.Lights.Add(LightSlice(PerformanceLights.Yellow, snap.Yellow));
            snap.Lights.Add(LightSlice(PerformanceLights.Orange, snap.Orange));
            snap.Lights.Add(LightSlice(PerformanceLights.Red, snap.Red));
            snap.Lights.Add(LightSlice(PerformanceLights.Gray, snap.Gray));

            snap.EmploymentTypes = ToSortedList(types, null);
            snap.PersonTypes = ToSortedList(personTypes, null);
            snap.GenderBands = ToSortedList(genders, null);
            snap.MaritalBands = ToSortedList(maritals, null);
            snap.EducationLevels = ToSortedList(edu, 10);
            snap.Skills = ToSortedList(skillMap, 8);
            snap.AgeBands = age;
            snap.TenureBands = tenure;
            foreach (var k in hireKeys)
            {
                int n;
                hireCounts.TryGetValue(k.Key, out n);
                k.Count = n;
                snap.HireMonths.Add(k);
            }

            snap.Documents.Add(new NamedCount { Key = DashboardFilter.MissingPhoto, Label = "عکس ۴×۳", Count = snap.PhotoCount });
            snap.Documents.Add(new NamedCount { Key = DashboardFilter.MissingBirth, Label = "شناسنامه", Count = snap.BirthDocCount });
            snap.Documents.Add(new NamedCount { Key = DashboardFilter.MissingNational, Label = "کارت ملی", Count = snap.NationalDocCount });

            if (groupStats != null)
            {
                var glist = new List<NamedCount>(groupStats);
                glist.Sort((a, b) =>
                {
                    var c = b.Count.CompareTo(a.Count);
                    return c != 0 ? c : string.Compare(a.Label, b.Label, StringComparison.Ordinal);
                });
                if (glist.Count > 10)
                {
                    var extraG = 0;
                    for (var i = 9; i < glist.Count; i++)
                        extraG += glist[i].Count;
                    glist = glist.GetRange(0, 9);
                    glist.Add(new NamedCount { Key = "other", Label = "سایر گروه‌ها", Count = extraG });
                }
                snap.Groups = glist;
            }

            snap.RiskActions = risk;
            snap.ContactActions = contact;
            snap.IncompleteActions = incomplete;
            snap.UnevaluatedActions = unevaluated;
            snap.ExemplaryPeople = exemplary;
            snap.ExtraOrgPeople = extra;
            return snap;
        }

        static NamedCount LightSlice(string light, int count)
        {
            return new NamedCount
            {
                Key = light,
                Label = PerformanceLights.Fa(light),
                Count = count,
                Light = light
            };
        }

        static DashboardActionRow Row(Employee e, string detail, string light, string target)
        {
            return new DashboardActionRow
            {
                EmployeeId = e.Id,
                Name = e.FullName,
                Position = string.IsNullOrWhiteSpace(e.CurrentPosition) ? "بدون سمت" : e.CurrentPosition,
                Detail = detail,
                Light = light,
                OpenTarget = target,
                PhotoPath = e.PhotoPath
            };
        }

        static string ScoreDetail(Employee e)
        {
            var bits = new List<string>();
            if (e.PerformanceScore != null)
                bits.Add("نمره " + e.PerformanceScore.Value.ToString("0.#"));
            if (!string.IsNullOrWhiteSpace(e.PerformancePeriodFa))
                bits.Add(e.PerformancePeriodFa);
            return bits.Count == 0 ? PerformanceLights.Fa(LightOf(e)) : string.Join(" · ", bits.ToArray());
        }

        static int CompareRisk(DashboardActionRow a, DashboardActionRow b)
        {
            var ra = a.Light == PerformanceLights.Red ? 0 : 1;
            var rb = b.Light == PerformanceLights.Red ? 0 : 1;
            if (ra != rb)
                return ra.CompareTo(rb);
            return string.Compare(a.Name, b.Name, StringComparison.Ordinal);
        }

        static void Count(Dictionary<string, int> map, string key)
        {
            int n;
            map.TryGetValue(key, out n);
            map[key] = n + 1;
        }

        static List<NamedCount> ToSortedList(Dictionary<string, int> map, int? cap)
        {
            var list = new List<NamedCount>();
            foreach (var kv in map)
                list.Add(new NamedCount
                {
                    Key = kv.Key,
                    Label = string.IsNullOrEmpty(kv.Key) ? "نامشخص" : kv.Key,
                    Count = kv.Value
                });
            list.Sort((a, b) =>
            {
                var c = b.Count.CompareTo(a.Count);
                return c != 0 ? c : string.Compare(a.Label, b.Label, StringComparison.Ordinal);
            });
            if (cap != null && list.Count > cap.Value)
            {
                var extra = 0;
                for (var i = cap.Value - 1; i < list.Count; i++)
                    extra += list[i].Count;
                list = list.GetRange(0, cap.Value - 1);
                list.Add(new NamedCount { Key = "other", Label = "سایر", Count = extra });
            }
            return list;
        }

        static List<NamedCount> NewBand(params string[] pairs)
        {
            var list = new List<NamedCount>();
            for (var i = 0; i + 1 < pairs.Length; i += 2)
                list.Add(new NamedCount { Key = pairs[i], Label = pairs[i + 1], Count = 0 });
            return list;
        }

        static void BandAge(List<NamedCount> bands, int? years)
        {
            string key;
            if (years == null) key = "unk";
            else if (years.Value < 30) key = "lt30";
            else if (years.Value < 40) key = "30s";
            else if (years.Value < 50) key = "40s";
            else if (years.Value < 60) key = "50s";
            else key = "60p";
            AddBand(bands, key);
        }

        static void BandTenure(List<NamedCount> bands, int? years)
        {
            string key;
            if (years == null) key = "unk";
            else if (years.Value < 2) key = "lt2";
            else if (years.Value < 5) key = "2to5";
            else if (years.Value < 10) key = "5to10";
            else if (years.Value < 20) key = "10to20";
            else key = "20p";
            AddBand(bands, key);
        }

        static void AddBand(List<NamedCount> bands, string key)
        {
            foreach (var b in bands)
            {
                if (b.Key == key)
                {
                    b.Count++;
                    return;
                }
            }
        }

        static List<NamedCount> BuildHireKeys(int year, int month)
        {
            var list = new List<NamedCount>();
            for (var i = 11; i >= 0; i--)
            {
                var m = month - i;
                var y = year;
                while (m <= 0)
                {
                    m += 12;
                    y--;
                }
                var key = y.ToString("0000") + "/" + m.ToString("00");
                var label = PersianDate.MonthNames[m - 1];
                if (i == 11 || m == 1)
                    label = label + " " + y;
                list.Add(new NamedCount { Key = key, Label = label, Count = 0 });
            }
            return list;
        }

        static void CountHire(Dictionary<string, int> hireCounts, Employee e)
        {
            int y, m;
            if (PersianDate.TryGetYearMonth(e.EmploymentDate, out y, out m))
            {
            }
            else if (e.CreatedAt > 0)
            {
                if (!PersianDate.TryGetYearMonth(PersianDate.FromEpochMs(e.CreatedAt), out y, out m))
                    return;
            }
            else
                return;
            var key = y.ToString("0000") + "/" + m.ToString("00");
            int n;
            if (!hireCounts.TryGetValue(key, out n))
                return;
            hireCounts[key] = n + 1;
        }
    }
}
