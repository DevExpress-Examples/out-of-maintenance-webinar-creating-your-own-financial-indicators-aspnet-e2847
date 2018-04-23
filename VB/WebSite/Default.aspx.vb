Imports System
Imports System.Collections.Generic
Imports System.Globalization
Imports System.Web.UI
Imports DevExpress.XtraCharts

Partial Public Class _Default
    Inherits Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    End Sub

    Protected Sub WebChartControl1_BoundDataChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim stockData As Series = WebChartControl1.Series("StockData")
        Dim macd As Series = WebChartControl1.Series("MACD")
        Dim signalLine As Series = WebChartControl1.Series("Signal Line")
        Dim histogram As Series = WebChartControl1.Series("MACD-Histogram")

        macd.Points.Clear()
        signalLine.Points.Clear()
        histogram.Points.Clear()

        Dim macdPoints() As SeriesPoint = _
            CalculateDifferenceEMA(CalculateEMA(stockData.Points.ToArray(), 12, 3), _
            CalculateEMA(stockData.Points.ToArray(), 26, 3))
        Dim signalPoints() As SeriesPoint = CalculateEMA(macdPoints, 9, 0)
        Dim histogramPoint() As SeriesPoint = CalculateDifferenceEMA(macdPoints, signalPoints)

        macdPoints = FilterPoints(macdPoints)
        signalPoints = FilterPoints(signalPoints)
        histogramPoint = FilterPoints(histogramPoint)
        macd.Points.AddRange(macdPoints)
        signalLine.Points.AddRange(signalPoints)
        histogram.Points.AddRange(histogramPoint)
    End Sub

    Private Function FilterPoints(ByVal points() As SeriesPoint) As SeriesPoint()
        If points.Length >= 0 Then
            Dim minRange As DateTime = _
                Convert.ToDateTime((CType(WebChartControl1.Diagram, XYDiagram)).AxisX.Range.MinValue, _
                    CultureInfo.InvariantCulture)
            For i As Integer = points.Length - 1 To 0 Step -1
                If points(i).DateTimeArgument < minRange Then
                    Dim filteredPoints As New List(Of SeriesPoint)()
                    For j As Integer = i + 1 To points.Length - 1
                        filteredPoints.Add(points(j))
                    Next j
                    Return filteredPoints.ToArray()
                End If
            Next i
        End If
        Return points
    End Function

    Private Function CalculateEMA(ByVal list() As SeriesPoint, ByVal daysCount As Integer, _
        ByVal valueIndex As Integer) As SeriesPoint()

        Dim result As New List(Of SeriesPoint)()
        Dim valuesCount As Integer = list.Length
        If valuesCount > 1 Then
            Dim pointsCount As Integer = Math.Min(daysCount, valuesCount)
            Dim ema As Double = 0
            Dim multiplier As Double = 1
            Dim index As Integer = 0
            Dim divider As Integer = 2
            Do While index < pointsCount
                multiplier = 2.0 / divider
                Dim point As SeriesPoint = list(index)
                ema += (point.Values(valueIndex) - ema) * multiplier
                result.Add(New SeriesPoint(point.Argument, ema))
                index += 1
                divider += 1
            Loop
            For index2 As Integer = pointsCount To valuesCount - 1
                Dim point As SeriesPoint = list(index2)
                ema += (point.Values(valueIndex) - ema) * multiplier
                result.Add(New SeriesPoint(point.Argument, ema))
            Next index2
        End If
        Return result.ToArray()
    End Function

    Private Function CalculateDifferenceEMA(ByVal list12days() As SeriesPoint, _
    ByVal list26days() As SeriesPoint) As SeriesPoint()
        Dim result(list12days.Length - 1) As SeriesPoint
        For index As Integer = 0 To list12days.Length - 1
            result(index) = New SeriesPoint(list12days(index).Argument, _
                list12days(index).Values(0) - list26days(index).Values(0))
        Next index
        Return result
    End Function
End Class
