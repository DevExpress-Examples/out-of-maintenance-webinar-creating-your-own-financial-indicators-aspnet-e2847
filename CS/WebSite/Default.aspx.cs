using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI;
using DevExpress.XtraCharts;

public partial class _Default : Page {
    protected void Page_Load(object sender, EventArgs e) {
    }
    protected void WebChartControl1_BoundDataChanged(object sender, EventArgs e) {
        Series stockData = WebChartControl1.Series["StockData"];
        Series macd = WebChartControl1.Series["MACD"];
        Series signalLine = WebChartControl1.Series["Signal Line"];
        Series histogram = WebChartControl1.Series["MACD-Histogram"];
        macd.Points.Clear();
        signalLine.Points.Clear();
        histogram.Points.Clear();
        SeriesPoint[] macdPoints = CalculateDifferenceEMA(CalculateEMA(stockData.Points.ToArray(), 12, 3), CalculateEMA(stockData.Points.ToArray(), 26, 3));
        SeriesPoint[] signalPoints = CalculateEMA(macdPoints, 9, 0);
        SeriesPoint[] histogramPoint = CalculateDifferenceEMA(macdPoints, signalPoints);
        macdPoints = FilterPoints(macdPoints);
        signalPoints = FilterPoints(signalPoints);
        histogramPoint = FilterPoints(histogramPoint);
        macd.Points.AddRange(macdPoints);
        signalLine.Points.AddRange(signalPoints);
        histogram.Points.AddRange(histogramPoint);
    }
    SeriesPoint[] FilterPoints(SeriesPoint[] points) {
        if (points.Length >= 0) {
            DateTime minRange = Convert.ToDateTime(((XYDiagram)WebChartControl1.Diagram).AxisX.Range.MinValue, CultureInfo.InvariantCulture);
            for (int i = points.Length - 1; i >= 0; i--) {
                if (points[i].DateTimeArgument < minRange) {
                    List<SeriesPoint> filteredPoints = new List<SeriesPoint>();
                    for (int j = i + 1; j < points.Length; j++)
                        filteredPoints.Add(points[j]);
                    return filteredPoints.ToArray();
                }
            }
        }
        return points;
    }
    SeriesPoint[] CalculateEMA(SeriesPoint[] list, int daysCount, int valueIndex) {
        List<SeriesPoint> result = new List<SeriesPoint>();
        int valuesCount = list.Length;
        if (valuesCount > 1) {
            int pointsCount = Math.Min(daysCount, valuesCount);
            double ema = 0;
            double multiplier = 1;
            for (int index = 0, divider = 2; index < pointsCount; index++, divider++) {
                multiplier = 2.0 / divider;
                SeriesPoint point = list[index];
                ema += (point.Values[valueIndex] - ema) * multiplier;
                result.Add(new SeriesPoint(point.Argument, ema));
            }
            for (int index = pointsCount; index < valuesCount; index++) {
                SeriesPoint point = list[index];
                ema += (point.Values[valueIndex] - ema) * multiplier;
                result.Add(new SeriesPoint(point.Argument, ema));
            }
        }
        return result.ToArray();
    }

    SeriesPoint[] CalculateDifferenceEMA(SeriesPoint[] list12days, SeriesPoint[] list26days) {
        SeriesPoint[] result = new SeriesPoint[list12days.Length];
        for (int index = 0; index < list12days.Length; index++)
            result[index] = new SeriesPoint(list12days[index].Argument, list12days[index].Values[0] - list26days[index].Values[0]);
        return result;
    }
}
