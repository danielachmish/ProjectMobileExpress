//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Management;
//using System.Web;


//namespace BLL
//{
//    public class SystemInfoService
//    {
//        public static DeviceSystemInfo GetSystemInfo()
//        {
//            var systemInfo = new DeviceSystemInfo();
//            try
//            {
//				using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_ComputerSystem"))
//                {
//                    foreach (var obj in searcher.Get())
//                    {
//                        systemInfo.DeviceName = obj["Name"]?.ToString();
//                        systemInfo.Model = obj["Model"]?.ToString();
//                        systemInfo.Manufacturer = obj["Manufacturer"]?.ToString();
//                        break;
//                    }
//                }
//                using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Processor"))
//                {
//                    foreach (var obj in searcher.Get())
//                    {
//                        systemInfo.Processor = obj["Name"]?.ToString();
//                        break;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine($"Error getting system info: {ex.Message}");
//                return null;
//            }
//            return systemInfo;
//        }
//    }

//    public class DeviceSystemInfo  // שינוי שם המחלקה
//    {
//        public string DeviceName { get; set; }
//        public string Model { get; set; }
//        public string Manufacturer { get; set; }
//        public string Processor { get; set; }
//    }
//}