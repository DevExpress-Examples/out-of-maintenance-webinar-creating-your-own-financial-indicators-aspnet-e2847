<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%@ Register Assembly="DevExpress.Web.v10.2, Version=10.2.0.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.Web.ASPxPopupControl" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v10.2.Web, Version=10.2.0.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.XtraCharts.Web" TagPrefix="dxchartsui" %>
<%@ Register Assembly="DevExpress.XtraCharts.v10.2, Version=10.2.0.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.XtraCharts" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Stock Indicators</title>
</head>
<body>
    <script type="text/javascript"><!--
var min;
var max;
window.onload = function() {
    var series = chart.chart.series[1];
    min = GetMinValue(series);
    max = GetMaxValue(series);
    _aspxAttachEventToDocument("mousemove", OnMouseMove);
}
function CalculateRelativeX(x, clickedElement) {
    var left = _aspxGetAbsoluteX(clickedElement); 
    return Math.abs(x - left);
}
function CalculateRelativeY(y, clickedElement) {
    var top = _aspxGetAbsoluteY(clickedElement);
    return Math.abs(y - top);
}
function GetValueString(value) {
    if (!(value instanceof Date))
        return value.toString();
    var minutes = value.getMinutes();
    return (value.getUTCMonth() + 1) + "/" + value.getUTCDate() + "/" + value.getUTCFullYear();
}
function GetMinValue(series) {
    var currentMin = series.points[0].values[0];
    for (var index = 0; index < series.points.length; index++)
        if (series.points[index].values[0] < currentMin)
            currentMin = series.points[index].values[0];
    return currentMin;
}
function GetMaxValue(series) {
    var currentMax = series.points[0].values[0];
    for (var index = 0; index < series.points.length; index++)
        if (series.points[index].values[0] > currentMax)
            currentMax = series.points[index].values[0];
    return currentMax;
}
function OnMouseMove(evt) {
    var srcElement = _aspxGetEventSource(evt);
    if (chart.GetMainDOMElement() != srcElement)
        return;
    var x = CalculateRelativeX(_aspxGetEventX(evt), srcElement);
    var y = CalculateRelativeY(_aspxGetEventY(evt), srcElement);
    var hitInfo = chart.HitTest(x, y);
    var text = "";
    for (var i = 0; i < hitInfo.length; i++)
        if (hitInfo[i].additionalObject instanceof ASPxClientSeriesPoint && (hitInfo[i].additionalObject.values[0] == min || hitInfo[i].additionalObject.values[0] == max)) {
        text += "Date: " + GetValueString(hitInfo[i].additionalObject.argument);
        if (!hitInfo[i].additionalObject.isEmpty)
            text += "<br>MACD-Histogram: " + hitInfo[i].additionalObject.values[0].toFixed(4);
        break;
    }
    if (text.length > 0) {
        UpdateToolTipText(text);
        ToolTip.ShowAtPos(_aspxGetEventX(evt) + 5, _aspxGetEventY(evt));
    }
    else
        ToolTip.Hide(); 
}
function UpdateToolTipText(text) {
    ToolTip.SetContentHTML("<span style=\"white-space:nowrap\">" + text + "</span>");
}
//--></script>
    <form id="form1" runat="server">
        <div>
            <dxchartsui:WebChartControl ID="WebChartControl1" runat="server" Height="591px" IndicatorsPaletteName="Default"
                ClientInstanceName="chart" Width="797px" DataSourceID="AccessDataSource1" OnBoundDataChanged="WebChartControl1_BoundDataChanged"
                EnableClientSideAPI="True">
                <seriesserializable>
                    <cc1:Series Name="StockData" ArgumentDataMember="Date" ValueDataMembersSerializable="Low;High;Open;Close"
                     ArgumentScaleType="DateTime">
                        <ViewSerializable>
                            <cc1:StockSeriesView LevelLineLength="0.008" Color="Black"></cc1:StockSeriesView>
                        </ViewSerializable>
                        <LabelSerializable>
                            <cc1:StockSeriesLabel Visible="False">
                                <FillStyle>
                                    <OptionsSerializable>
                                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                                    </OptionsSerializable>
                                </FillStyle>
                            </cc1:StockSeriesLabel>
                        </LabelSerializable>
                        <PointOptionsSerializable>
                            <cc1:StockPointOptions>
                                <ValueNumericOptions Format="FixedPoint"></ValueNumericOptions>
                            </cc1:StockPointOptions>
                        </PointOptionsSerializable>
                        <LegendPointOptionsSerializable>
                            <cc1:StockPointOptions>
                                <ValueNumericOptions Format="FixedPoint"></ValueNumericOptions>
                            </cc1:StockPointOptions>
                        </LegendPointOptionsSerializable>
                    </cc1:Series>
                    <cc1:Series Name="MACD-Histogram" ArgumentScaleType="DateTime">
                        <ViewSerializable>
                            <cc1:SideBySideBarSeriesView BarWidth="0.02" PaneName="Pane 1" AxisYName="Secondary AxisY 1" Color="Teal">
                                <FillStyle FillMode="Solid">
                                    <OptionsSerializable>
                                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                                    </OptionsSerializable>
                                </FillStyle>
                            </cc1:SideBySideBarSeriesView>
                        </ViewSerializable>
                        <LabelSerializable>
                            <cc1:SideBySideBarSeriesLabel Visible="False" LineVisible="True">
                                <FillStyle>
                                    <OptionsSerializable>
                                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                                    </OptionsSerializable>
                                </FillStyle>
                            </cc1:SideBySideBarSeriesLabel>
                        </LabelSerializable>
                        <PointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </PointOptionsSerializable>
                        <LegendPointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </LegendPointOptionsSerializable>
                    </cc1:Series>
                    <cc1:Series Name="MACD" ArgumentScaleType="DateTime">
                        <ViewSerializable>
                            <cc1:SplineSeriesView PaneName="Pane 1" AxisYName="Secondary AxisY 1" Color="Black">
                                <LineMarkerOptions Visible="False"></LineMarkerOptions>
                            </cc1:SplineSeriesView>
                        </ViewSerializable>
                        <LabelSerializable>
                            <cc1:PointSeriesLabel Visible="False" LineVisible="True">
                                <FillStyle>
                                    <OptionsSerializable>
                                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                                    </OptionsSerializable>
                                </FillStyle>
                            </cc1:PointSeriesLabel>
                        </LabelSerializable>
                        <PointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </PointOptionsSerializable>
                        <LegendPointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </LegendPointOptionsSerializable>
                    </cc1:Series>
                    <cc1:Series Name="Signal Line" ArgumentScaleType="DateTime">
                        <ViewSerializable>
                            <cc1:SplineSeriesView PaneName="Pane 1" AxisYName="Secondary AxisY 1" Color="Red">
                                <LineMarkerOptions Visible="False"></LineMarkerOptions>
                            </cc1:SplineSeriesView>
                        </ViewSerializable>
                        <LabelSerializable>
                            <cc1:PointSeriesLabel Visible="False" LineVisible="True">
                                <FillStyle>
                                    <OptionsSerializable>
                                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                                    </OptionsSerializable>
                                </FillStyle>
                            </cc1:PointSeriesLabel>
                        </LabelSerializable>
                        <PointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </PointOptionsSerializable>
                        <LegendPointOptionsSerializable>
                            <cc1:PointOptions></cc1:PointOptions>
                        </LegendPointOptionsSerializable>
                    </cc1:Series>
                </seriesserializable>
                <borderoptions visible="False"></borderoptions>
                <diagramserializable>
                    <cc1:XYDiagram>
                        <AxisX Title-Text="Date" VisibleInPanesSerializable="-1;0" Interlaced="True" DateTimeGridAlignment="Month" WorkdaysOnly="True">
                            <Range Auto="False" MinValueSerializable="10/19/2010 00:00:00.000" MaxValueSerializable="01/19/2011 00:00:00.000"
                             SideMarginsEnabled="False"></Range>
                            <GridLines Visible="True"></GridLines>
                            <WorkdaysOptions>
                                <Holidays>
                                    <cc1:KnownDate Date="2011-01-17" Name=""></cc1:KnownDate>
                                    <cc1:KnownDate Date="2010-11-25" Name=""></cc1:KnownDate>
                                    <cc1:KnownDate Date="2010-12-24" Name=""></cc1:KnownDate>
                                </Holidays>
                            </WorkdaysOptions>
                        </AxisX>
                        <AxisY Title-Text="" VisibleInPanesSerializable="-1">
                            <Range AlwaysShowZeroLevel="False" SideMarginsEnabled="True"></Range>
                            <GridLines MinorVisible="True"></GridLines>
                        </AxisY>
                        <SecondaryAxesY>
                            <cc1:SecondaryAxisY AxisID="0" Alignment="Near" VisibleInPanesSerializable="0" Name="Secondary AxisY 1">
                                <Range AlwaysShowZeroLevel="False" SideMarginsEnabled="True"></Range>
                                <GridLines Visible="True" MinorVisible="True"></GridLines>
                            </cc1:SecondaryAxisY>
                        </SecondaryAxesY>
                        <Panes>
                            <cc1:XYDiagramPane PaneID="0" Weight="0.5" Name="Pane 1"></cc1:XYDiagramPane>
                        </Panes>
                    </cc1:XYDiagram>
                </diagramserializable>
                <seriestemplate>
                    <ViewSerializable>
                        <cc1:StockSeriesView></cc1:StockSeriesView>
                    </ViewSerializable>
                    <LabelSerializable>
                        <cc1:StockSeriesLabel Visible="True">
                        <FillStyle>
                            <OptionsSerializable>
                                <cc1:SolidFillOptions></cc1:SolidFillOptions>
                            </OptionsSerializable>
                        </FillStyle>
                        </cc1:StockSeriesLabel>
                    </LabelSerializable>
                    <PointOptionsSerializable>
                        <cc1:StockPointOptions></cc1:StockPointOptions>
                    </PointOptionsSerializable>
                    <LegendPointOptionsSerializable>
                        <cc1:StockPointOptions></cc1:StockPointOptions>
                    </LegendPointOptionsSerializable>
                </seriestemplate>
                <fillstyle>
                    <OptionsSerializable>
                        <cc1:SolidFillOptions></cc1:SolidFillOptions>
                    </OptionsSerializable>
                </fillstyle>
                <titles>
                    <cc1:ChartTitle Text="Dell"></cc1:ChartTitle>
                </titles>
            </dxchartsui:WebChartControl>
            <fillstyle></fillstyle>
            <optionsserializable></optionsserializable>
            <cc1:SOLIDFILLOPTIONS></cc1:SOLIDFILLOPTIONS>
            <pointoptionsserializable></pointoptionsserializable>
            <cc1:STOCKPOINTOPTIONS></cc1:STOCKPOINTOPTIONS>
            <valuenumericoptions format="FixedPoint"></valuenumericoptions>
            <legendpointoptionsserializable></legendpointoptionsserializable>
            <cc1:STOCKPOINTOPTIONS></cc1:STOCKPOINTOPTIONS>
            <fillstyle></fillstyle>
            <optionsserializable></optionsserializable>
            <cc1:SOLIDFILLOPTIONS></cc1:SOLIDFILLOPTIONS>
            <pointoptionsserializable></pointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <legendpointoptionsserializable></legendpointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <linemarkeroptions visible="False"></linemarkeroptions>
            <labelserializable></labelserializable>
            <cc1:POINTSERIESLABEL LineVisible="True" Visible="False"></cc1:POINTSERIESLABEL>
            <fillstyle></fillstyle>
            <optionsserializable></optionsserializable>
            <cc1:SOLIDFILLOPTIONS></cc1:SOLIDFILLOPTIONS>
            <pointoptionsserializable></pointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <legendpointoptionsserializable></legendpointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <linemarkeroptions visible="False"></linemarkeroptions>
            <labelserializable></labelserializable>
            <cc1:POINTSERIESLABEL LineVisible="True" Visible="False"></cc1:POINTSERIESLABEL>
            <fillstyle></fillstyle>
            <optionsserializable></optionsserializable>
            <cc1:SOLIDFILLOPTIONS></cc1:SOLIDFILLOPTIONS>
            <pointoptionsserializable></pointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <legendpointoptionsserializable></legendpointoptionsserializable>
            <cc1:POINTOPTIONS></cc1:POINTOPTIONS>
            <fillstyle></fillstyle>
            <optionsserializable></optionsserializable>
            <cc1:SOLIDFILLOPTIONS></cc1:SOLIDFILLOPTIONS>
            <pointoptionsserializable></pointoptionsserializable>
            <cc1:STOCKPOINTOPTIONS></cc1:STOCKPOINTOPTIONS>
            <legendpointoptionsserializable></legendpointoptionsserializable>
            <cc1:STOCKPOINTOPTIONS></cc1:STOCKPOINTOPTIONS>
            <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/Dell.mdb"
                SelectCommand="SELECT * FROM [Dell] ORDER BY [Date]">
            </asp:AccessDataSource>
        </div>
        <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" ClientInstanceName="ToolTip"
            EnableAnimation="False" Height="1px" ShowHeader="False" Width="1px" CloseAction="None"
            EnableHotTrack="False" PopupHorizontalAlign="Center" PopupVerticalAlign="TopSides">
            <ContentStyle>
                <Paddings Padding="0px" />
            </ContentStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>
</body>
</html>
