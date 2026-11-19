using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Qaemshahr.Core
{
    public sealed class ParsedQuery
    {
        public List<string> AndTerms { get; set; }
        public List<string> OrTerms { get; set; }
        public List<string> NotTerms { get; set; }

        public ParsedQuery()
        {
            AndTerms = new List<string>();
            OrTerms = new List<string>();
            NotTerms = new List<string>();
        }

        public bool HasBoolean
        {
            get { return AndTerms.Count > 0 || OrTerms.Count > 0 || NotTerms.Count > 0; }
        }
    }

    public static class QueryParser
    {
        public static ParsedQuery Parse(string raw)
        {
            var result = new ParsedQuery();
            if (string.IsNullOrWhiteSpace(raw))
                return result;
            var tokens = Regex.Split(raw.Trim(), @"[,،\s]+");
            var nextOr = false;
            foreach (var token0 in tokens)
            {
                var token = token0.Trim();
                if (token.Length == 0)
                    continue;
                var upper = token.ToUpperInvariant();
                if (upper == "OR" || token == "|")
                {
                    nextOr = true;
                    continue;
                }
                if (token.StartsWith("-") && token.Length > 1)
                {
                    result.NotTerms.Add(token.Substring(1));
                    nextOr = false;
                    continue;
                }
                if (token.StartsWith("|") && token.Length > 1)
                {
                    result.OrTerms.Add(token.Substring(1));
                    nextOr = false;
                    continue;
                }
                if (nextOr)
                {
                    result.OrTerms.Add(token);
                    nextOr = false;
                }
                else
                    result.AndTerms.Add(token);
            }
            return result;
        }
    }
}
