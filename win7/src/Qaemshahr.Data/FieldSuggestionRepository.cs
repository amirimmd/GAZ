using System;
using System.Collections.Generic;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class FieldSuggestionRepository
    {
        readonly AppDatabase _db;

        public FieldSuggestionRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<string> List(string category)
        {
            var list = new List<string>();
            if (string.IsNullOrWhiteSpace(category))
                return list;
            using (var r = _db.Query(
                "SELECT value FROM field_suggestions WHERE category=@c ORDER BY value COLLATE NOCASE",
                Sql.P("@c", category.Trim())))
            {
                while (r.Read())
                {
                    var v = Sql.Str(r["value"]);
                    if (!string.IsNullOrWhiteSpace(v))
                        list.Add(v.Trim());
                }
            }
            return list;
        }

        public void Remember(string category, string value)
        {
            if (!FieldSuggestionKeys.IsSupported(category))
                return;
            var v = (value ?? string.Empty).Trim();
            if (v.Length == 0)
                return;
            var now = Sql.Now();
            _db.Execute(
                "INSERT OR IGNORE INTO field_suggestions (category, value, created_at) VALUES (@c,@v,@n)",
                Sql.P("@c", category.Trim()),
                Sql.P("@v", v),
                Sql.P("@n", now));
        }

        public void Delete(string category, string value)
        {
            if (string.IsNullOrWhiteSpace(category) || string.IsNullOrWhiteSpace(value))
                return;
            _db.Execute(
                "DELETE FROM field_suggestions WHERE category=@c AND lower(value)=lower(@v)",
                Sql.P("@c", category.Trim()),
                Sql.P("@v", value.Trim()));
        }

        public void RememberFromEmployee(Employee e)
        {
            if (e == null)
                return;
            Remember(FieldSuggestionKeys.BirthPlace, e.BirthPlace);
            Remember(FieldSuggestionKeys.CurrentPosition, e.CurrentPosition);
            Remember(FieldSuggestionKeys.PreviousPosition, e.PreviousPosition);
            Remember(FieldSuggestionKeys.DesiredPosition, e.DesiredPosition);
            Remember(FieldSuggestionKeys.EducationLevel, e.EducationLevel);
            Remember(FieldSuggestionKeys.Major, e.Major);
            Remember(FieldSuggestionKeys.University, e.University);
            Remember(FieldSuggestionKeys.SkillName, e.SkillName);
            Remember(FieldSuggestionKeys.SkillLevel, e.SkillLevel);
            Remember(FieldSuggestionKeys.InsuranceType, e.InsuranceType);
            Remember(FieldSuggestionKeys.ServiceCity, e.ServiceCity);
            Remember(FieldSuggestionKeys.VeteranStatus, e.VeteranStatus);
        }

        public void SeedFromEmployeesIfEmpty()
        {
            var any = _db.Scalar("SELECT 1 FROM field_suggestions LIMIT 1");
            if (any != null && any != DBNull.Value)
                return;

            SeedColumn(FieldSuggestionKeys.BirthPlace,
                "SELECT DISTINCT TRIM(birth_place) FROM employees WHERE birth_place IS NOT NULL AND TRIM(birth_place) <> ''");
            SeedColumn(FieldSuggestionKeys.CurrentPosition,
                "SELECT DISTINCT TRIM(current_position) FROM employees WHERE current_position IS NOT NULL AND TRIM(current_position) <> ''");
            SeedColumn(FieldSuggestionKeys.PreviousPosition,
                "SELECT DISTINCT TRIM(previous_position) FROM employees WHERE previous_position IS NOT NULL AND TRIM(previous_position) <> ''");
            SeedColumn(FieldSuggestionKeys.DesiredPosition,
                "SELECT DISTINCT TRIM(desired_position) FROM employees WHERE desired_position IS NOT NULL AND TRIM(desired_position) <> ''");
            SeedColumn(FieldSuggestionKeys.EducationLevel,
                "SELECT DISTINCT TRIM(education_level) FROM employee_educations WHERE education_level IS NOT NULL AND TRIM(education_level) <> ''");
            SeedColumn(FieldSuggestionKeys.Major,
                "SELECT DISTINCT TRIM(major) FROM employee_educations WHERE major IS NOT NULL AND TRIM(major) <> ''");
            SeedColumn(FieldSuggestionKeys.University,
                "SELECT DISTINCT TRIM(university) FROM employee_educations WHERE university IS NOT NULL AND TRIM(university) <> ''");
            SeedColumn(FieldSuggestionKeys.SkillName,
                "SELECT DISTINCT TRIM(skill_name) FROM employee_skills WHERE skill_name IS NOT NULL AND TRIM(skill_name) <> ''");
            SeedColumn(FieldSuggestionKeys.SkillLevel,
                "SELECT DISTINCT TRIM(level) FROM employee_skills WHERE level IS NOT NULL AND TRIM(level) <> ''");
            SeedColumn(FieldSuggestionKeys.InsuranceType,
                "SELECT DISTINCT TRIM(insurance_type) FROM employee_insurances WHERE insurance_type IS NOT NULL AND TRIM(insurance_type) <> ''");
            SeedColumn(FieldSuggestionKeys.ServiceCity,
                "SELECT DISTINCT TRIM(service_city) FROM employees WHERE service_city IS NOT NULL AND TRIM(service_city) <> ''");
            SeedColumn(FieldSuggestionKeys.VeteranStatus,
                "SELECT DISTINCT TRIM(veteran_status) FROM employees WHERE veteran_status IS NOT NULL AND TRIM(veteran_status) <> ''");
        }

        void SeedColumn(string category, string sql)
        {
            using (var r = _db.Query(sql))
            {
                while (r.Read())
                    Remember(category, Sql.Str(r[0]));
            }
        }
    }
}
