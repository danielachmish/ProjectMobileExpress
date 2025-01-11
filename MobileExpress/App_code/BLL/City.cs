using DAL;
using ExcelDataReader;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

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
        public static ImportResult ImportCitiesFromExcel(string filePath)
        {
            var result = new ImportResult();

            try
            {
                if (!File.Exists(filePath))
                {
                    throw new FileNotFoundException($"Excel file not found at path: {filePath}");
                }

                Console.WriteLine($"Starting import from file: {filePath}");

                DataTable excelData = ReadExcelFile(filePath);

                // Validate excel structure
                if (!excelData.Columns.Contains("CityName"))
                {
                    throw new Exception("Excel file must contain a 'CityName' column");
                }

                int successCount = 0;
                int failureCount = 0;
                var errors = new List<string>();

                foreach (DataRow row in excelData.Rows)
                {
                    try
                    {
                        string cityName = row["CityName"].ToString().Trim();

                        // Basic validation
                        if (string.IsNullOrEmpty(cityName))
                        {
                            errors.Add($"Row {row.Table.Rows.IndexOf(row) + 1}: City name cannot be empty");
                            failureCount++;
                            continue;
                        }

                        // Check for duplicates
                        if (IsCityExists(cityName))
                        {
                            errors.Add($"City '{cityName}' already exists in database");
                            failureCount++;
                            continue;
                        }

                        var city = new City
                        {
                            CityName = cityName
                        };

                        city.SaveNewCity();
                        successCount++;

                        Console.WriteLine($"Successfully imported city: {cityName}");
                    }
                    catch (Exception ex)
                    {
                        string errorMessage = $"Error in row {row.Table.Rows.IndexOf(row) + 1}: {ex.Message}";
                        errors.Add(errorMessage);
                        failureCount++;
                        Console.WriteLine(errorMessage);
                    }
                }

                result.SuccessCount = successCount;
                result.FailureCount = failureCount;
                result.Errors = errors;
                result.IsSuccess = failureCount == 0;

                Console.WriteLine($"Import completed. Successful: {successCount}, Failed: {failureCount}");

                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Critical error during import: {ex.Message}");
                result.IsSuccess = false;
                result.Errors = new List<string> { ex.Message };
                throw;
            }
        }

        private static bool IsCityExists(string cityName)
        {
            var cities = CityDAL.GetAll();
            return cities.Any(c => c.CityName.Equals(cityName, StringComparison.OrdinalIgnoreCase));
        }

        private static DataTable ReadExcelFile(string filePath)
        {
            using (var stream = File.Open(filePath, FileMode.Open, FileAccess.Read))
            {
                // Configure Excel Reader
                var excelConfig = new ExcelDataSetConfiguration
                {
                    ConfigureDataTable = _ => new ExcelDataTableConfiguration
                    {
                        UseHeaderRow = true,
                        FilterRow = rowReader => rowReader.Depth > 0  // Skip empty rows
                    }
                };

                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    var result = reader.AsDataSet(excelConfig);
                    return result.Tables[0];
                }
            }
        }
    }

    public class ImportResult
    {
        public bool IsSuccess { get; set; }
        public int SuccessCount { get; set; }
        public int FailureCount { get; set; }
        public List<string> Errors { get; set; } = new List<string>();
    }
}

