# siavash_mobile
## Tech test app for Willow

# Install:
1. Make sure you have the latest Xcode 10.2.1 installed.
2. Make sure you have Cocoapods install on your machine as well. Here is how to install Cocoapods: <https://guides.cocoapods.org/using/getting-started.html>
3. Open up terminal and navigate to the path that has the Xcode project that you have fetched from github. enter this command `pod install` and then open the `Willow.xcworkspace` file in Xcode. 
4. Run the project on a simulator or if you know how to sign certificate you can run it on your device as well. 


# Assumptions:
## 3rd Party pods:
1. Since this app uses Reactive approach I am using the related pods form <https://github.com/ReactiveX> 
2. I am also using <https://github.com/SnapKit> since I prefer to handle UI/Autolayout in code
3. I am also using <https://github.com/Nuke> for this project to simply handle the image downloading and caching, I didn't want to spend time and re-invent the wheel for this one. 

## App Assumptions:
1. The UI design is best for iPhone. I would prefer to have a different design for the iPad to get the most out of the bigger realestate.
2. There is no account/authentication
3. There is no saving states/data between App launches.
4. There is no refresh button, however the app refreshes (re-fetch data) if you flick off/on your internet connection
5. There are basic loading indicator and image placeholders, nothing fancy.
6. Errors being handled via dialog view.
7. The filtering is not super smart. for example if you choose `Australia` and `Melbourne` at the same time, we do an `or` so you will see the `Sydney` buildings as well as `Melbourne` since you have `Australia` selected.
8. the buttons on the image are designed considering that you would only have at most 3 of them. ( I would prefer to have them showing under the building image, expanding cell, this way we could put as many buttons as we want. 
9. Unit test is not very comprehensive because of the time constraint, I have only included tests for json mapping and registering the building via the view model, however it shows how easy it is to add tests when you have clean MVVM design. 
10. For the sake of cleaner design, Filter section has its own separate page. This also allows for future enhancement (adding more filters)
11. There is no de-selection to hide `AssetExplorer` once you select a building to see its `AssetExplorer`.
12. I didn't create any dev branch or anything, since it didn't make sense for creating pull request as merging back to the origin because it was just me working on the project.

## App Design/Architect
As you can tell the app has been developed in a reactive way, (MVVM). There is a services file to handle API requests. Each ViewController has its own ViewModel which holds the logic. The ViewController is only responsible for routing the User interaction from the UI to the ViewModel and routing back the data from ViewModel to UI. I am happy to go to more detail regarding this.

Please let me know if you have any questions.

