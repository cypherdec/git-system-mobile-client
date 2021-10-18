import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit_app/models/chart_data_mode.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressChart extends StatefulWidget {

  final List<ChartData> chartDataList;
  final String trainingGoal;

  ProgressChart(this.chartDataList, this.trainingGoal);

  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  @override
  Widget build(BuildContext context) {
    return  Container(  //set up a container  and add a custom widget
      //    child: SimpleTimeSeriesChart(chartData),
        child: SfCartesianChart(
          zoomPanBehavior: ZoomPanBehavior(
            enableMouseWheelZooming : true,
            enablePinching: true,
            zoomMode: ZoomMode.xy,
            enablePanning: true,
          ),
            plotAreaBackgroundColor: Colors.black,
            primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0.3),
                labelStyle: TextStyle(
                  color: Colors.deepOrange,
                )
            ),
            primaryYAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 0.3),
                labelStyle: TextStyle(
                  color: Colors.deepOrange,
                )
            ),
            title: ChartTitle(
                text: 'Training Goal : ' + widget.trainingGoal,
                textStyle: TextStyle(
                  color: Colors.amber,
                )
            ),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <LineSeries<ChartData, String>>[
              LineSeries<ChartData, String>(
                  color: Colors.amber,
                  animationDuration: 3000,
                  dataSource: widget.chartDataList,  //add data to chart
                  xValueMapper: (ChartData data, _) => data.date,  //map x and y axis
                  yValueMapper: (ChartData data, _) => data.weight,
                  name: 'Progress',
                  dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]
        )
    );
  }
}
