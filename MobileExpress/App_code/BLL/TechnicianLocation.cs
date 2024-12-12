using DAL;
using System;

namespace BLL
{
    public class TechnicianLocationModel 
    {
        public int LocationId { get; set; }
        public int TechnicianId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public decimal Accuracy { get; set; }
        public DateTime Timestamp { get; set; }

        public void Save()
        {
            TechnicianLocationsDAL.SaveLocation(
                this.TechnicianId,
                this.Latitude,
                this.Longitude,
                this.Accuracy
            );
        }

        public static TechnicianLocationModel GetLastLocation(int technicianId)  // עדכון שם ההחזרה
        {
            return TechnicianLocationsDAL.GetLastLocation(technicianId);
        }
    }
}