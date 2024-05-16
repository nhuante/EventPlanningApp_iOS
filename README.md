# Event Planning iOS App

## Natalie Huante & Mason Moore 
## CPSC 357 - iOS Application Development, Spring 2024

### Introduction 
This application was developed in XCode with Swift for the purpose of a final project in the course mentioned above. The motivation behind this project was to create an app that would help people who need to plan an event or a party and want to have multiple types of information gathered in the same place. Our app allows our users to keep track of this information and easily access it. 

Users will be able to track...
* their todo list
  * add and delete items
  * filter which items to view by category
  * go back and add notes to your items (ex: have quotes or brainstormed ideas that are relevant to booking a caterer? put them down in the notes section and come back to it every time you work on that task)
* notes
  * keep track of any and all thoughts that you have about the event you're planning
  * this page serves as a notes app where you can always have your past thoughts with you as you plan your event
  * dont worry about losing that one piece of paper that you wrote down that lady's flowers quote on, just keep it on the app!
* booked vendors
  * keep a separate list of vendors and things you have booked and/or paid for
  * dont get confused with your to-do list and your list of already-done
  * keep notes on the vendors and jot down reminders that relate specifically to that service
* budget
  * keep track of your budget as you continue to plan and book vendors
  * when you add a booked contract/vendor, this page will automatically update with your updated budget
  * update your budget if need be, you aren't locked into the first budget you input
  * see if you are over or under budget and what your current spending total is
  * see your expenses by category and how they relate to your total budget
 
### Team Contributions 
We both worked together on the actual coding of the app for the majority of the development process. Natalie ran most of it on her computer before we decided to upload it to this GitHub. Mason then helped on his computer to add some final functionality and finishing touches to the app. Natalie made the video slides and the README and Mason presented the final app through our video presentation

### Final Links
* Presentation Slides: https://www.canva.com/design/DAGFUpnZTN0/_VNSucc1jrWUspu84xzuVw/edit
* Presentation Video: 


### Resources References
* https://bugfender.com/blog/swiftui-pickers/
* https://developer.apple.com/documentation/swiftui/textfield
* https://developer.apple.com/documentation/swiftui/texteditor
* https://forums.developer.apple.com/forums/thread/666345
* https://www.hackingwithswift.com/quick-start/swiftui/how-to-respond-to-view-lifecycle-events-onappear-and-ondisappear
* https://www.appypie.com/pass-data-between-views-swiftui-how-to
* https://ix76y.medium.com/swiftui-passing-data-between-views-446bc8b4805
* https://stackoverflow.com/questions/63044816/modify-variable-in-swiftui
* https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
* https://www.hackingwithswift.com/forums/swiftui/how-to-update-item-value-after-editing/6559
* a LOT of our old projects and assignments we used to try and piece together some of the functionalities that we had implemented previously. One of the main ones for making all the structures and the lists was the Movies and Cars projects. We also used some like the TabbedView one to make the different pages and some of the others to try to piece together the math used in the budget page
* ChatGPT was used, mainly for helping us debug and piecing together and trying to understand some of the concepts used for the app. One in particular was making sure that all the data and variables were being passed around and updated properly. That was one of our main issues, we were able to edit the data and see it on the screen, but as soon as we hit save, nothing would save. So, we had to go back and really try to digest all of the different things we could label variables like @State, @Binding, @Observable, and so on. The other thing we really used ChatGPT for was debugging. Throughout the development process, we had a lot of random errors thrown at us, and often times google wasn't a great help, so we would use it to try and figure out what was going on and what was causing it. Most of the issues actually turned out to be syntax errors, scope issues, or Swift not liking us trying to give default values to things. 
