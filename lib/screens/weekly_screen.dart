import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  @override
  void initState() {
    setDate();
    readFitData();
    super.initState();
  }

  var formatterDate = DateFormat('MMM d');
  var selectedDate = DateTime.now();
  var now = new DateTime.now();
  var today;
  var thisMonday;
  var thisSunday;
  var dayNr;

  setDate() {
    setState(() {
      today = now.weekday;
      dayNr = (today + 6) % 7;
      thisMonday = now.subtract(new Duration(days: (dayNr)));
      thisSunday = thisMonday.add(new Duration(days: 6));
    });
  }

  _subtractWeek() {
    //selectedDate = selectedDate.subtract(Duration(days: 1));
    setState(() {
      thisSunday = thisMonday.subtract(Duration(days: 1));
      thisMonday = thisSunday.subtract(Duration(days: 6));
    });
    readFitData();
  }

  _addWeek() {
    //selectedDate = selectedDate.add(Duration(days: 1));
    setState(() {
      thisMonday = thisSunday.add(Duration(days: 1));
      thisSunday = thisMonday.add(Duration(days: 6));
    });
    readFitData();
  }

  button_handler(
    String label,
  ) {
    return ButtonTheme(
      minWidth: 20.0,
      height: 50,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Colors.indigo)),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }

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

  int getSteps;
  int getEnergy;
  int getDistance;

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
          dateFrom: thisMonday,
          dateTo: thisSunday,
        );
        final stepsList = await FitKit.read(
          DataType.STEP_COUNT,
          dateFrom: thisMonday,
          dateTo: thisSunday,
        );
        final distanceList = await FitKit.read(
          DataType.DISTANCE,
          dateFrom: thisMonday,
          dateTo: thisSunday,
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
        body: Column(
      children: [
        Expanded(
          child: Column(
            children: [
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
                      Text(formatterDate.format(thisMonday) +
                          ' - ' +
                          formatterDate.format(thisSunday)),
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
              tile_Handler(MediaQuery.of(context).size.height * 0.07,
                  'Plank hold', 1234),
              //tile_Handler(MediaQuery.of(context).size.height * 0.07)
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            button_handler(
              'Steps',
            ),
            button_handler('Distance'),
            button_handler('Calories'),
            button_handler('Plank hold')
          ],
        )
      ],
    ));
  }
}
