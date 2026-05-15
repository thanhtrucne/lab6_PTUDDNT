namespace UserManagementAPI.Models
{
    public class LoginModel
    {
        public required string Email { get; set; }
        public required string Password { get; set; }
    }

    public class RegisterModel
    {
        public required string Email { get; set; }
        public required string Password { get; set; }
        public string? FullName { get; set; }
        public string? Role { get; set; } // "Admin" or "User"
    }

    public class UserDTO
    {
        public string? Id { get; set; }
        public string? Email { get; set; }
        public string? FullName { get; set; }
        public List<string>? Roles { get; set; }
    }
}
