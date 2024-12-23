using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public enum CallStatus
	{
		Open = 0,        // קריאה פתוחה/חדשה
		InProgress = 1,  // בטיפול
		Closed = 2       // סגורה
	}
	public class Readability
	{
		public int ReadId { get; set; }
		public DateTime DateRead { get; set; }
		public string Desc { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Nots { get; set; }
		public int CusId { get; set; }
		public string ModelId { get; set; }
		public bool Status { get; set; }
		public string NameImage { get; set; }
		public string Urgency { get; set; }
		public int SerProdId { get; set; }
		public int? AssignedTechnicianId { get; set; }
		//public bool? IsCallAccepted { get; set; }
		public CallStatus CallStatus { get; set; }
		public string ModelCode { get; set; }

		// מתודה עזר לבדיקת סטטוס
		public bool IsOpen() => CallStatus == CallStatus.Open;
		public bool IsInProgress() => CallStatus == CallStatus.InProgress;
		public bool IsClosed() => CallStatus == CallStatus.Closed;

		// מתודות לעדכון סטטוס
		public void StartTreatment()
		{
			CallStatus = CallStatus.InProgress;
			UpdateReadability();
		}

		public void CloseCall()
		{
			CallStatus = CallStatus.Closed;
			UpdateReadability();
		}

		public void SaveNewRead()
		{
			try
			{
				ReadabilityDAL.Save(this);
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל חדש: {ex.Message}");
				throw;
			}
		}

		public void UpdateReadability()
		{
			try
			{
				ReadabilityDAL.UpdateReadability(this);
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון מנהל: {ex.Message}");
				throw;
			}
		}
		// אחזור כל המשתמשים
		public static List<Readability> GetAll()
		{
			return ReadabilityDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Readability GetById(int Id)
		{
			return ReadabilityDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return ReadabilityDAL.DeleteById(Id);
		}
		// פונקציה חדשה לעדכון הטכנאי המטפל
		public void AssignTechnician(int technicianId)
		{
			AssignedTechnicianId = technicianId;
			UpdateReadability();
		}

		public static List<Readability> GetAllByCustomerId(int cusId)
		{
			return ReadabilityDAL.GetAllByCustomerId(cusId);
		}

	}
	public class ReadabilityStats
	{
		public int TotalCalls { get; set; }
		public int AcceptedCalls { get; set; }
		public int PendingCalls => TotalCalls - AcceptedCalls;
		public double CompletionRate => TotalCalls > 0 ? (AcceptedCalls * 100.0 / TotalCalls) : 0;

		public static ReadabilityStats GetTechnicianStats(int technicianId)
		{
			var (total, accepted) = ReadabilityStatsDAL.GetTechnicianStats(technicianId);
			return new ReadabilityStats
			{
				TotalCalls = total,
				AcceptedCalls = accepted
			};
		}

		
	}
}