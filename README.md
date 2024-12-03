# TrackMe
To test the Project a real Device is required, here a short description of the views. Light Mode is recommended.
## HabitListView
Main View  
All the created Habits are listed.
The bell is used to send a one time Test Notification in 10 seconds.
The plus navigates to HabitView
Tapping the no Habits yet navigates to HabitView
Tapping a habit navigates to DetailView
## HabitView
New Habits can be created, upon saving the modelContext gets updated and the notifications are created.
## DetailView
Some information of the Habit can be seen here, along with the current Streak
It is also navigated to when finishing the Timer, for this reason only a home button is here for Navigation.
## TimerView
Upon receiving a Notification this View is opened, you have the option to Start the Timer or Dismiss it.
## StartTimerView
A Timer counts down, when finished the finish button is unlocked to ensure there is no easy cheating to keep up the streak.
## DismissTimerView
You are asked if you are sure, in order to make the user rethink, reminding later creates another notification in 30 minutes.
