using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
    public class VatRate
    {
        private static decimal? _currentRate;
        private static DateTime _lastUpdate = DateTime.MinValue;
        private const int CACHE_MINUTES = 60;

        public static decimal GetCurrentRate()
        {
            // בדיקה אם צריך לרענן את המטמון
            if (!_currentRate.HasValue || DateTime.Now.Subtract(_lastUpdate).TotalMinutes > CACHE_MINUTES)
            {
                _currentRate = VatRateDAL.GetCurrentVatRate();
                _lastUpdate = DateTime.Now;
            }
            return _currentRate.Value;
        }

        public static void UpdateRate(decimal newRate)
        {
            VatRateDAL.UpdateVatRate(newRate);
            _currentRate = newRate;
            _lastUpdate = DateTime.Now;
        }
    }
}