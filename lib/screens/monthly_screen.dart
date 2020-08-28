import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class MonthlyScreen extends StatefulWidget {
  @override
  _MonthlyScreenState createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {

   void initState() {
    setMonth();
    readFitData();
    super.initState();
  }

  List months = [
    'Janu',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'august',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];


  var current_mon;
  var current_mon_num;//8
  var next_month;

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


  _previousMonth() {
   if(current_mon_num == 0){
     return;
   }
    //var subtracter = current_mon_num - 1;
    var previousMonth = (months[current_mon_num - 1]);
    setState(() {
      current_mon = previousMonth;
      current_mon_num = current_mon_num - 1;
    });
    print(current_mon_num);
  }

  _nextMonth() {
    if(current_mon_num == 11){
      return;
    }
    var adder = current_mon_num + 1;
    var next_month = (months[adder]);//sep
    setState(() {
      current_mon = next_month;
      print(current_mon);
      current_mon_num = adder;
    });
  }

  setMonth() {
    var now = new DateTime.now();
    current_mon_num = now.month; //8
    
    var subtracter = current_mon_num - 1;//7
    var presentMonth= (months[subtracter]);//aug
    setState(() {
      current_mon = presentMonth;
      current_mon_num = subtracter;
    });
    print(current_mon);
    print(current_mon_num);
    DateTime lastDayOfMonth = new DateTime( now.month);
    print(lastDayOfMonth);

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
           dateFrom: DateTime.utc(DateTime.july),
          dateTo: DateTime.utc(DateTime.august),
        );
        final stepsList = await FitKit.read(
          DataType.STEP_COUNT,
         dateFrom: DateTime.utc(DateTime.july),
          dateTo: DateTime.utc(DateTime.august),
        );
        final distanceList = await FitKit.read(
          DataType.DISTANCE,
          dateFrom: DateTime.utc(DateTime.july),
          dateTo: DateTime.utc(DateTime.august),
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
                      setState(() {
                        _previousMonth();
                      });
                    }),
                Text(current_mon),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        _nextMonth();
                      });
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
      ]))
    ]));
  }
}
