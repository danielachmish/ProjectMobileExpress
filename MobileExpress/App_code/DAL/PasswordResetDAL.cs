using Data;
using System;
using System.Data;

namespace DAL
{
    public class PasswordResetServiceDAL
    {
        public enum UserType
        {
            Admin,
            Technician,
            Customer
        }

        public class UserInfo
        {
            public UserType Type { get; set; }
            public int UserId { get; set; }
            public string Email { get; set; }
        }

        //public static UserInfo FindUserByEmail(string email)
        //{
        //    if (string.IsNullOrEmpty(email))
        //        throw new ArgumentNullException(nameof(email));

        //    using (var db = new DbContext())
        //    {
        //        try
        //        {
        //            // בדיקה במנהלים
        //            string adminSql = "SELECT AdminId, Email FROM T_Administrators WHERE Email = @Email";
        //            var parameters = DbContext.CreateParameters(new { Email = email });
        //            var adminResult = db.Execute(adminSql, parameters);

        //            if (adminResult.Rows.Count > 0)
        //            {
        //                return new UserInfo
        //                {
        //                    Type = UserType.Admin,
        //                    UserId = Convert.ToInt32(adminResult.Rows[0]["AdminId"]),
        //                    Email = email
        //                };
        //            }

        //            // בדיקה בטכנאים
        //            string techSql = "SELECT TecId, Email FROM T_Technicians WHERE Email = @Email";
        //            var techResult = db.Execute(techSql, parameters);

        //            if (techResult.Rows.Count > 0)
        //            {
        //                return new UserInfo
        //                {
        //                    Type = UserType.Technician,
        //                    UserId = Convert.ToInt32(techResult.Rows[0]["TecId"]),
        //                    Email = email
        //                };
        //            }

        //            // בדיקה בלקוחות
        //            string customerSql = "SELECT CusId, Email FROM T_Customers WHERE Email = @Email";
        //            var customerResult = db.Execute(customerSql, parameters);

        //            if (customerResult.Rows.Count > 0)
        //            {
        //                return new UserInfo
        //                {
        //                    Type = UserType.Customer,
        //                    UserId = Convert.ToInt32(customerResult.Rows[0]["CusId"]),
        //                    Email = email
        //                };
        //            }

        //            return null;
        //        }
        //        catch (Exception ex)
        //        {
        //            System.Diagnostics.Debug.WriteLine($"שגיאה בחיפוש משתמש: {ex.Message}");
        //            throw new Exception("אירעה שגיאה בחיפוש המשתמש");
        //        }
        //    }
        //}

        public static UserInfo FindUserByEmail(string email)
        {
            if (string.IsNullOrEmpty(email))
                throw new ArgumentNullException(nameof(email));

            using (var db = new DbContext())
            {
                try
                {
                    // בדיקה בלקוחות
                    string customerSql = "SELECT CusId, Email FROM T_Customers WHERE Email = @Email";
                    var parameters = DbContext.CreateParameters(new { Email = email });
                    var customerResult = db.Execute(customerSql, parameters);

                    System.Diagnostics.Debug.WriteLine($"[DEBUG] Customer search SQL: {customerSql}");
                    System.Diagnostics.Debug.WriteLine($"[DEBUG] Customer search email param: {email}");
                    System.Diagnostics.Debug.WriteLine($"[DEBUG] Customer search results count: {customerResult.Rows.Count}");

                    if (customerResult.Rows.Count > 0)
                    {
                        var cusId = customerResult.Rows[0]["CusId"];
                        System.Diagnostics.Debug.WriteLine($"[DEBUG] Found customer with CusId: {cusId}");

                        return new UserInfo
                        {
                            Type = UserType.Customer,
                            UserId = Convert.ToInt32(cusId),
                            Email = email
                        };
                    }

                    // אם לא נמצא כלקוח, בדוק כטכנאי
                    string techSql = "SELECT TecId, Email FROM T_Technicians WHERE Email = @Email";
                    var techResult = db.Execute(techSql, parameters);

                    if (techResult.Rows.Count > 0)
                    {
                        return new UserInfo
                        {
                            Type = UserType.Technician,
                            UserId = Convert.ToInt32(techResult.Rows[0]["TecId"]),
                            Email = email
                        };
                    }

                    // בדיקה במנהלים אם לא נמצא כטכנאי
                    string adminSql = "SELECT AdminId, Email FROM T_Administrators WHERE Email = @Email";
                    var adminResult = db.Execute(adminSql, parameters);

                    if (adminResult.Rows.Count > 0)
                    {
                        return new UserInfo
                        {
                            Type = UserType.Admin,
                            UserId = Convert.ToInt32(adminResult.Rows[0]["AdminId"]),
                            Email = email
                        };
                    }

                    return null;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"[ERROR] Error in FindUserByEmail: {ex.Message}");
                    System.Diagnostics.Debug.WriteLine($"[ERROR] Stack trace: {ex.StackTrace}");
                    throw new Exception("אירעה שגיאה בחיפוש המשתמש");
                }
            }
        }


        //public static void UpdatePassword(UserInfo user, string hashedPassword)
        //{
        //    if (user == null)
        //        throw new ArgumentNullException(nameof(user));
        //    if (string.IsNullOrEmpty(hashedPassword))
        //        throw new ArgumentNullException(nameof(hashedPassword));

        //    string sql = GetUpdatePasswordSql(user.Type);

        //    using (var db = new DbContext())
        //    {
        //        try
        //        {
        //            var parameters = DbContext.CreateParameters(new
        //            {
        //                Pass = hashedPassword,
        //                UserId = user.UserId
        //            });

        //            int rowsAffected = db.ExecuteNonQuery(sql, parameters);
        //            if (rowsAffected == 0)
        //            {
        //                throw new Exception("לא נמצא משתמש לעדכון");
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון סיסמה: {ex.Message}");
        //            throw new Exception("אירעה שגיאה בעדכון הסיסמה");
        //        }
        //    }
        //}
        public static void UpdatePassword(UserInfo user, string hashedPassword)
        {
            if (user == null)
                throw new ArgumentNullException(nameof(user));
            if (string.IsNullOrEmpty(hashedPassword))
                throw new ArgumentNullException(nameof(hashedPassword));

            string sql = GetUpdatePasswordSql(user.Type);
            System.Diagnostics.Debug.WriteLine($"[DEBUG] UpdatePassword SQL: {sql}");
            System.Diagnostics.Debug.WriteLine($"[DEBUG] User type: {user.Type}");
            System.Diagnostics.Debug.WriteLine($"[DEBUG] User ID: {user.UserId}");

            using (var db = new DbContext())
            {
                try
                {
                    var parameters = DbContext.CreateParameters(new
                    {
                        Pass = hashedPassword,
                        UserId = user.UserId
                    });

                    int rowsAffected = db.ExecuteNonQuery(sql, parameters);
                    System.Diagnostics.Debug.WriteLine($"[DEBUG] Rows affected by update: {rowsAffected}");

                    if (rowsAffected == 0)
                    {
                        throw new Exception("לא נמצא משתמש לעדכון");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"[ERROR] Error in UpdatePassword: {ex.Message}");
                    System.Diagnostics.Debug.WriteLine($"[ERROR] Stack trace: {ex.StackTrace}");
                    throw new Exception("אירעה שגיאה בעדכון הסיסמה");
                }
            }
        }

        //private static string GetUpdatePasswordSql(UserType userType)
        //{
        //    switch (userType)
        //    {
        //        case UserType.Admin:
        //            return "UPDATE T_Administrators SET Pass = @Pass WHERE AdminId = @UserId";
        //        case UserType.Technician:
        //            return "UPDATE T_Technicians SET Pass = @Pass WHERE TecId = @UserId";
        //        case UserType.Customer:
        //            return "UPDATE T_Customers SET Pass = @Pass WHERE CusId = @UserId";
        //        default:
        //            throw new ArgumentException("סוג משתמש לא חוקי");
        //    }
        //}

        private static string GetUpdatePasswordSql(UserType userType)
        {
            switch (userType)
            {
                case UserType.Admin:
                    return "UPDATE T_Administrators SET Pass = @Pass WHERE AdminId = @UserId";
                case UserType.Technician:
                    return "UPDATE T_Technicians SET Pass = @Pass WHERE TecId = @UserId";
                case UserType.Customer:
                    return "UPDATE T_Customers SET Pass = @Pass WHERE CusId = @UserId";
                default:
                    throw new ArgumentException("סוג משתמש לא חוקי");
            }
        }

        public static void SaveResetCode(string email, string code, DateTime expiryDate)
        {
            if (string.IsNullOrEmpty(email))
                throw new ArgumentNullException(nameof(email));
            if (string.IsNullOrEmpty(code))
                throw new ArgumentNullException(nameof(code));

            using (var db = new DbContext())
            {
                try
                {
                    // מסמן קודים קודמים כמשומשים
                    string updateSql = "UPDATE T_PasswordResets SET IsUsed = 1 WHERE Email = @Email AND IsUsed = 0";
                    var updateParams = DbContext.CreateParameters(new { Email = email });
                    db.ExecuteNonQuery(updateSql, updateParams);

                    // שומר קוד חדש
                    string insertSql = @"INSERT INTO T_PasswordResets (Email, ResetCode, ExpiryDate, IsUsed) 
                                     VALUES (@Email, @ResetCode, @ExpiryDate, 0)";

                    var insertParams = DbContext.CreateParameters(new
                    {
                        Email = email,
                        ResetCode = code,
                        ExpiryDate = expiryDate
                    });

                    db.ExecuteNonQuery(insertSql, insertParams);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת קוד איפוס: {ex.Message}");
                    throw new Exception("אירעה שגיאה בשמירת קוד האיפוס");
                }
            }
        }

        public static bool ValidateResetCode(string email, string code)
        {
            if (string.IsNullOrEmpty(email))
                throw new ArgumentNullException(nameof(email));
            if (string.IsNullOrEmpty(code))
                throw new ArgumentNullException(nameof(code));

            using (var db = new DbContext())
            {
                try
                {
                    var parameters = DbContext.CreateParameters(new
                    {
                        Email = email,
                        ResetCode = code
                    });

                    string validSql = @"SELECT COUNT(*) FROM T_PasswordResets 
                                    WHERE Email = @Email AND ResetCode = @ResetCode 
                                    AND ExpiryDate > GETDATE() AND IsUsed = 0";

                    object result = db.ExecuteScalar(validSql, parameters);
                    int count = Convert.ToInt32(result);

                    if (count == 0)
                    {
                        string expiredSql = @"SELECT COUNT(*) FROM T_PasswordResets 
                                          WHERE Email = @Email AND ResetCode = @ResetCode 
                                          AND ExpiryDate <= GETDATE() AND IsUsed = 0";

                        result = db.ExecuteScalar(expiredSql, parameters);
                        if (Convert.ToInt32(result) > 0)
                        {
                            throw new Exception("קוד האימות פג תוקף. אנא בקש קוד חדש");
                        }
                    }

                    return count > 0;
                }
                catch (Exception ex) when (!(ex.Message.Contains("פג תוקף")))
                {
                    System.Diagnostics.Debug.WriteLine($"שגיאה באימות קוד: {ex.Message}");
                    throw new Exception("אירעה שגיאה באימות הקוד");
                }
            }
        }

        public static void MarkResetCodeAsUsed(string email, string code)
        {
            if (string.IsNullOrEmpty(email))
                throw new ArgumentNullException(nameof(email));
            if (string.IsNullOrEmpty(code))
                throw new ArgumentNullException(nameof(code));

            using (var db = new DbContext())
            {
                try
                {
                    string sql = "UPDATE T_PasswordResets SET IsUsed = 1 WHERE Email = @Email AND ResetCode = @ResetCode";
                    var parameters = DbContext.CreateParameters(new
                    {
                        Email = email,
                        ResetCode = code
                    });

                    int rowsAffected = db.ExecuteNonQuery(sql, parameters);
                    if (rowsAffected == 0)
                    {
                        throw new Exception("לא נמצא קוד איפוס תקף");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"שגיאה בסימון קוד כמשומש: {ex.Message}");
                    throw new Exception("אירעה שגיאה בעדכון הקוד");
                }
            }
        }

        public static void CleanupOldCodes()
        {
            using (var db = new DbContext())
            {
                try
                {
                    string sql = @"DELETE FROM T_PasswordResets 
                                WHERE (ExpiryDate < GETDATE() AND IsUsed = 0) 
                                OR CreatedAt < DATEADD(day, -7, GETDATE())";

                    db.ExecuteNonQuery(sql);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"שגיאה בניקוי קודים ישנים: {ex.Message}");
                }
            }
        }
    }
}