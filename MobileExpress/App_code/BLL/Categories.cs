﻿using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Categories
	{
		public int CatId { get; set; }
		public string CatName { get; set; }
		public DateTime DateAdd { get; set; }
		public bool Status { get; set; }

		public void Save()
		{
			CategoriesDAL.Save(this);
		}
		// אחזור כל המשתמשים
		public static List<Categories> GetAll()
		{
			return CategoriesDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Categories GetById(int Id)
		{
			return CategoriesDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return CategoriesDAL.DeleteById(Id);
		}

	}
}