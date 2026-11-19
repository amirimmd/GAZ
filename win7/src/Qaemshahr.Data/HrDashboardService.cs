using System.Collections.Generic;

using Qaemshahr.Core;

using Qaemshahr.Core.Models;



namespace Qaemshahr.Data

{

    public sealed class HrDashboardService

    {

        readonly EmployeeRepository _employees;

        readonly DocumentRepository _documents;

        readonly GroupRepository _groups;



        public HrDashboardService(EmployeeRepository employees, DocumentRepository documents, GroupRepository groups)

        {

            _employees = employees;

            _documents = documents;

            _groups = groups;

        }



        public HrDashboardSnapshot Load()

        {

            var people = _employees.Search(null, null, 5000, true) ?? new List<Employee>();

            var sets = FileSets(people, _documents.List());

            var activeIds = new HashSet<string>();

            foreach (var e in people)

            {

                if (e != null && !string.IsNullOrEmpty(e.Id) && HrDashboardAnalytics.IsActive(e))

                    activeIds.Add(e.Id);

            }



            var groupStats = new List<NamedCount>();

            var membersInAnyGroup = new HashSet<string>();

            if (_groups != null)

            {

                var groups = _groups.List(null, null) ?? new List<EmployeeGroup>();

                foreach (var g in groups)

                {

                    if (g == null || string.IsNullOrEmpty(g.Id))

                        continue;

                    var ids = _groups.MemberIds(g.Id) ?? new List<string>();

                    var activeMembers = 0;

                    foreach (var id in ids)

                    {

                        if (string.IsNullOrEmpty(id))

                            continue;

                        membersInAnyGroup.Add(id);

                        if (activeIds.Contains(id))

                            activeMembers++;

                    }

                    groupStats.Add(new NamedCount

                    {

                        Key = g.Id,

                        Label = string.IsNullOrWhiteSpace(g.Name) ? "بدون نام" : g.Name.Trim(),

                        Count = activeMembers

                    });

                }

            }



            return HrDashboardAnalytics.Build(

                people,

                sets.Photos,

                sets.Birth,

                sets.National,

                _employees.MapEducationLevels(),

                _employees.MapSkillNames(),

                groupStats,

                membersInAnyGroup);

        }



        public FileIdSets FileSetsFor(IList<Employee> people)

        {

            return FileSets(people, _documents.List());

        }



        public static FileIdSets FileSets(IList<Employee> people, IList<EmployeeDocument> docs)

        {

            var photos = new HashSet<string>();

            var birth = new HashSet<string>();

            var national = new HashSet<string>();

            if (people != null)

            {

                foreach (var e in people)

                {

                    if (e == null || string.IsNullOrEmpty(e.Id))

                        continue;

                    if (EmployeePhotoStore.Exists(e.PhotoPath))

                        photos.Add(e.Id);

                }

            }

            if (docs != null)

            {

                foreach (var d in docs)

                {

                    if (d == null || string.IsNullOrEmpty(d.EmployeeId))

                        continue;

                    var kind = DocumentKinds.Normalize(d.Category);

                    if (kind == DocumentKinds.Birth)

                        birth.Add(d.EmployeeId);

                    else if (kind == DocumentKinds.National)

                        national.Add(d.EmployeeId);

                }

            }

            return new FileIdSets { Photos = photos, Birth = birth, National = national };

        }



        public sealed class FileIdSets

        {

            public HashSet<string> Photos { get; set; }

            public HashSet<string> Birth { get; set; }

            public HashSet<string> National { get; set; }

        }

    }

}


