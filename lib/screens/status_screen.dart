import 'package:flutter/material.dart';
import 'package:think_ai/screens/daily_screen.dart';
import 'package:think_ai/screens/monthly_screen.dart';
import 'package:think_ai/screens/weekly_screen.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 3, child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: TabBar(
            unselectedLabelColor: Theme.of(context).primaryColor,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).primaryColor
            ),
            tabs: [
              Tab(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1
                  )
                ),
                child: Align(alignment: Alignment.center,
                child: Text('DAILY', ),
                ),
              ),),
              //Tab(text: 'WEEKLY',),
               Tab(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1
                  )
                ),
                child: Align(alignment: Alignment.center,
                child: Text('WEEKLY', ),
                ),
              ),),
              Tab(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1
                  )
                ),
                child: Align(alignment: Alignment.center,
                child: Text('MONTHLY', ),
                ),
              ),),
            ],
          ),
        ),
         body: TabBarView(children: [
           Daily_Screen(),
           WeeklyScreen(),
           MonthlyScreen()
         ]),
      ))
    );
    
  }
}
