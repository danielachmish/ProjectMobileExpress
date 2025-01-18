using DAL;

using System;
using System.Collections.Generic;

namespace BLL
{
    public class TechnicianAvailability
    {
        public int Id { get; set; }
        public int TechnicianId { get; set; } // מקשר לטבלה T_Technicians
        public int DayOfWeek { get; set; }    // 0=ראשון, 1=שני וכו'
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }

        // פונקציה סטטית לשמירת שעות הפעילות
        public static void SaveAvailability(int technicianId, List<TechnicianAvailability> availabilities)
        {
            try
            {
                // מחיקת שעות פעילות קיימות
                TechnicianAvailabilityDAL.DeleteTechnicianAvailability(technicianId);

                // שמירה מחדש
                TechnicianAvailabilityDAL.SaveTechnicianAvailability(availabilities);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error saving availability: {ex.Message}");
                throw;
            }
        }

        // פונקציה סטטית לשליפת שעות הפעילות
        public static List<TechnicianAvailability> GetAvailability(int technicianId)
        {
            try
            {
                return TechnicianAvailabilityDAL.GetTechnicianAvailability(technicianId);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching availability: {ex.Message}");
                throw;
            }
        }
    }
}
