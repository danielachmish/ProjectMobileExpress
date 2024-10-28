using DAL;
using ExcelDataReader;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;

namespace BLL
{
    public class City
    {
        public int CityId { get; set; }
        public string CityName { get; set; }

        public void SaveNewCity()
        {
            CityDAL.Save(this);
        }
        public void UpdateCity()
        {
            try
            {
                CityDAL.UpdateCity(this); // העברת האובייקט הנוכחי ל-DAL
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
            if (this.CityId == -1 ) 
            {
                SaveNewCity();
            }
            else
            {
                UpdateCity();
            }
        }

        public static List<City> GetAll()
        {
            return CityDAL.GetAll();
        }

        public static City GetById(int Id)
        {
            return CityDAL.GetById(Id);
        }

        public static int DeleteById(int Id)
        {
            return CityDAL.DeleteById(Id);
        }
    }

    public class ExcelImporter
    {
        public static void ImportCitiesFromExcel(string filePath)
        {
            try
            {
                DataTable excelData = ReadExcelFile(filePath);
                foreach (DataRow row in excelData.Rows)
                {
                    City city = new City
                    {
                        CityName = row["CityName"].ToString()
                    };
                    city.SaveNewCity();
                }
                Console.WriteLine("Cities imported successfully!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error importing cities: {ex.Message}");
            }
        }

        private static DataTable ReadExcelFile(string filePath)
        {
            using (var stream = File.Open(filePath, FileMode.Open, FileAccess.Read))
            {
                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    var result = reader.AsDataSet(new ExcelDataSetConfiguration()
                    {
                        ConfigureDataTable = (_) => new ExcelDataTableConfiguration() { UseHeaderRow = true }
                    });
                    return result.Tables[0];
                }
            }
        }
    }
}

