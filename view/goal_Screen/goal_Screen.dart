import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/model_view/set_goal_provider.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';

// ignore: must_be_immutable
class GoalScreen extends StatelessWidget {
  // List<Goals> goals = [
  //   Goals(userGoals: "Deep Sleep", goalDescriptions: "Get a quality Sleep", img: "assets/icons/1.5.png"),
  //   Goals(userGoals: "Overcome Stress", goalDescriptions: "Manage stress & Anxiety", img: "assets/icons/1.4.png"),
  //   Goals(userGoals: "Feel Nature", goalDescriptions: "Hear diverse nature sounds", img: "assets/icons/1.3.png"),
  //   Goals(userGoals: "Improve Performance", goalDescriptions: "Get a better start", img: "assets/icons/1.2.png"),
  //   Goals(userGoals: "Boost Concentration", goalDescriptions: "Improve focus", img: "assets/icons/1.1.png"),
  // ];

  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        surfaceTintColor: Colors.transparent,
        title: RichText(
          text: TextSpan(
            text: "Select your ",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                text: "Goal",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500, color: Color(0xFFFAD051)),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Consumer<SetGoalProvider>(
            builder: (context, goalProvider,_) {
              return goalProvider.pageID == 2 ?Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteName.homeScreen, (_) => false);
                  },
                  child: 
                  
                  Text(
                    "skip",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ) : SizedBox();
            }
          ),
      
        ],
        leading: GestureDetector(

          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Expanded(
                child: Consumer<SetGoalProvider>(
                  builder: (context,setGoalProvider,child) {
                    return ListView.builder(
                      itemCount: setGoalProvider.goals.length,
                      itemBuilder: (context, index) {
                        // Access GoalProvider state directly without Consumer
                        // bool isSelected = setGoalProvider.goalsList[index] ;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint("\nPressed index: $index\n");
                                // Use context.read to trigger action without listening
                                // context.read<SetGoalProvider>().onSelect(index: index);
                                setGoalProvider.toggleGoalSelection(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.r),
                                  border: Border.all(
                                    color: setGoalProvider.isSelected(index) ? Color(0xFFFAD051) : Theme.of(context).colorScheme.onSecondary.withOpacity(0.08),
                                  ),
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16, top: 24, bottom: 10),
                                  child: ListTile(
                                    title: Text(
                                      setGoalProvider.goals[index].userGoals ?? " ",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.sp),
                                    ),
                                    subtitle: Text(
                                      setGoalProvider.goals[index].goalDescriptions ?? " ",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.w300),
                                    ),
                                    trailing: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Image.asset(setGoalProvider.goals[index].img, height: 49.h, width: 48.w),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        );
                      },
                    );
                  }
                ),
              ),
              SizedBox(height: 20.h),
              Consumer<SetGoalProvider>(
                builder: (context, setGoalProvider, child) {
                  // Convert goalsList to a list of selected titles
                  List<String> selectedTitles = [];
                  for (int i = 0; i < setGoalProvider.goals.length; i++) {
                    if (setGoalProvider.isSelected(i)) {
                      selectedTitles.add(setGoalProvider.goals[i].userGoals!);
                    }
                  }
                  return setGoalProvider.isSetGoalInProgress ? Center(child: CircularProgressIndicator(),) :  Mybutton(
                    text: "Continue",
                    color: Theme.of(context).colorScheme.primary,
                    ontap: () {
                      debugPrint("Selected Goals: $selectedTitles");
                      setGoalProvider.setGoal(selectedGoals: selectedTitles);
                      Navigator.pushNamedAndRemoveUntil(context, RouteName.homeScreen, (_) => false);
                    },
                  );
                },
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}