# **MixMatch**

## **Discription**
This apllication uses musixmatch API to show fetch top 10 musics details and then uses another musixmatch API  to fetch lyrics of the current music track using it's track ID. The application also has the feature to bookmark the music track on the local device using sqflite database. In additon the application continously checks for internet connectivity as we are fetching data from API has throwing a internet connectivity message was much needed.

## Requirements
To get the app build following are the requirements:
1. `Flutter` Framework installled with android studio up working properly
2. `Dependencies` as given below:
   - cupertino_icons: ^0.1.2
   - rxdart: ^0.24.1
   - http: ^0.12.2
   - flutter_offline: ^0.3.0
   - animations: ^1.1.2
   - sqflite: ^1.3.2+1
   - path_provider:
   - flutter_spinkit:
  
 | [**MixMatch App in light mode**]()      | [**MixMatch App in dark mode**]()     | 
|------------|-------------| 
|  <img src="light_mode.gif" width="250"> |  <img src="dark_mode.gif" width="250"> |
