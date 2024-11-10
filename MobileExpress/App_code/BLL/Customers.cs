using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Customers
	{
		public int CusId { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Addres { get; set; }
		public string Uname { get; set; }
		public string Pass { get; set; }
		public DateTime DateAdd { get; set; }
		public bool Status { get; set; }
		public string History { get; set; }
		public string Nots { get; set; }
		public int CityId { get; set; }
		public string Email { get; set; }
		public string GoogleId { get; set; }


		public void SaveNewCustomers()
		{
			try
			{
				CustomersDAL.SaveNewCustomers(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה לעדכון לקוח קיים
		public void UpdateCustomers()
		{
			try
			{
				CustomersDAL.UpdateCustomers(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה כללית לשמירת לקוח חדש או קיים
		public void Save()
		{
			if (this.CusId == -1)
			{
				SaveNewCustomers();
			}
			else
			{
				UpdateCustomers();
			}
		}

		// אחזור כל המשתמשים
		public static List<Customers> GetAll()
		{
			return CustomersDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Customers GetById(int Id)
		{
			return CustomersDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return CustomersDAL.DeleteById(Id);
		}
		public static Customers GetByEmail(string email)
		{
			return CustomersDAL.GetByEmail(email);
		}
	}
}