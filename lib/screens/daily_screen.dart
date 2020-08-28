import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fit_kit/fit_kit.dart';

//255015965153-ca92kba917qtnb825127fi0ls1tl6egb.apps.googleusercontent.com

class Daily_Screen extends StatefulWidget {
  @override
  _Daily_ScreenState createState() => _Daily_ScreenState();
}

class _Daily_ScreenState extends State<Daily_Screen> {
  var formatterDate = DateFormat('MMM d');
  var selectedDate = DateTime.now();

  int getSteps;
  int getEnergy;
  int getDistance;

  tile_Handler(double height, String type, int number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[100],
        height: height,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Plan'),
              Container(
                  height: 30,
                  child: VerticalDivider(
                    color: Colors.grey,
                  )),
              Text(type),
              Container(
                  height: 30,
                  child: VerticalDivider(
                    color: Colors.grey,
                  )),
              Text(number.toString())
            ],
          ),
        ),
      ),
    );
  }

  _subtractWeek() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
    readFitData();
  }

  _addWeek() {
    if (selectedDate == DateTime.now()) {
      return;
    } 
      setState(() {
        selectedDate = selectedDate.add(Duration(days: 1));
      });
  
    readFitData();
  }

  void initState() {
    readFitData();
    super.initState();
  }

  Future<List<FitData>> readFitData() async {
    List<FitData> data = [];
    try {
      final activityPermission = await Permission.activityRecognition.request();
      final permissions = await FitKit.requestPermissions(DataType.values);

      print(activityPermission);
      print(permissions);

      if (permissions && (activityPermission == PermissionStatus.granted)) {
        // final weight = await FitKit.readLast(DataType.WEIGHT);
        // final height = await FitKit.readLast(DataType.HEIGHT);

        final energyList = await FitKit.read(
          DataType.ENERGY,
          dateFrom: selectedDate.subtract(Duration(
              hours: selectedDate.hour,
              minutes: selectedDate.minute,
              seconds: selectedDate.second)),
          dateTo: selectedDate,
        );
        final stepsList = await FitKit.read(
          DataType.STEP_COUNT,
          dateFrom: selectedDate.subtract(Duration(
              hours: selectedDate.hour,
              minutes: selectedDate.minute,
              seconds: selectedDate.second)),
          dateTo: selectedDate,
        );
        final distanceList = await FitKit.read(
          DataType.DISTANCE,
          dateFrom: selectedDate.subtract(Duration(
              hours: selectedDate.hour,
              minutes: selectedDate.minute,
              seconds: selectedDate.second)),
          dateTo: selectedDate,
        );

        print(getSteps);
        print(stepsList);
        //print(FitData);
        var steps = 0;
        var energy = 0;
        var distance = 0;
        for (var i in stepsList) {
          steps += i.value.round();
        }
        setState(() {
          getSteps = steps;
        });
        for (var i in distanceList) {
          distance += i.value.round();
        }
        setState(() {
          getDistance = distance;
        });
        for (var i in energyList) {
          energy += i.value.round();
        }
        setState(() {
          getEnergy = energy;
        });
        print('steps: $steps');
        print(distance);
        print(energy);
      } else {
        readFitData();
      }
    } on UnsupportedException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Column(children: [
        Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      _subtractWeek();
                    }),
                Text(formatterDate.format(selectedDate)),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      _addWeek();
                    })
              ],
            ),
          ),
        ),
        tile_Handler(
            MediaQuery.of(context).size.height * 0.07, 'Steps', getSteps),
        tile_Handler(
            MediaQuery.of(context).size.height * 0.07, 'Distance', getDistance),
        tile_Handler(
            MediaQuery.of(context).size.height * 0.07, 'Calories', getEnergy),
        tile_Handler(
            MediaQuery.of(context).size.height * 0.07, 'Plank hold', 1234),
        //tile_Handler(MediaQuery.of(context).size.height * 0.07, 'Steps', 1234)
      ]))
    ]));
  }
}
