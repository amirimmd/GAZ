using System;
using System.Collections.Generic;

namespace Qaemshahr.Core.Models
{
    public sealed class UserAccount
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string DisplayName { get; set; }
        public bool IsActive { get; set; }
        public bool MustChangePassword { get; set; }
        public HashSet<string> Permissions { get; set; }
        public List<string> RoleCodes { get; set; }
    }

    public sealed class UserSession
    {
        public string SessionId { get; set; }
        public UserAccount User { get; set; }
        public DateTime ExpiresAtUtc { get; set; }
        public DateTime LastActivityUtc { get; set; }
    }
}
