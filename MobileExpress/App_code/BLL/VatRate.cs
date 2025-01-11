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
            var now = DateTime.Now;
            System.Diagnostics.Debug.WriteLine($"Getting VAT rate. Current cached rate: {_currentRate}, Last update: {_lastUpdate}");

            if (!_currentRate.HasValue || now.Subtract(_lastUpdate).TotalMinutes > CACHE_MINUTES || _currentRate.Value <= 0)
            {
                try
                {
                    _currentRate = VatRateDAL.GetCurrentVatRate();
                    _lastUpdate = now;
                    System.Diagnostics.Debug.WriteLine($"Updated VAT rate from DB: {_currentRate}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting VAT rate: {ex.Message}");
                    if (!_currentRate.HasValue)
                    {
                        _currentRate = 0.18m;
                    }
                }
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