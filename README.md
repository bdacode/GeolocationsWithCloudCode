# Geolocations

An updated version of our [Geolocations sample app](https://github.com/ParsePlatform/Geolocations) using Cloud Code.

In this sample app, we'll add a [validation](https://www.parse.com/docs/cloud_code_guide#beforesave) to ensure users cannot add more than one check-in post every minute, as well as a [Cloud Function](https://www.parse.com/docs/cloud_code_guide#functions) that allows us to calculate the average check-in location of a user, all in cloud!

You can get the [source code][source] and follow along with our [screencast][tutorial].

How to Run
----------

1. Clone the repository and open the Xcode project.
2. Add your Parse application id and client key in `AppDelegate.m`.
3. Install the Parse command line tool by entering the command `curl -s https://www.parse.com/downloads/cloud_code/installer.sh | sudo /bin/bash` in your terminal (Mac) or command prompt (Windows).
4. From the root directory of the app, enter the command `parse new` in your terminal or command prompt in order to setup the cloud code configuration files.
5. You'll be prompted for your Parse username and password, and you'll also be shown a list of your Parse apps. Choose the one you want to associate with this project (you might want to create a new one).
6. Run `parse deploy`. This will deploy the Cloud Code for this app.

For more information on installing and using Cloud Code and the Parse command line tool check out the [screencast][tutorial] for this app as well as your Cloud Code [documentation](https://www.parse.com/docs/cloud_code_guide).

[tutorial]: https://parse.com/tutorials/getting-started-with-cloud-code
[source]: https://github.com/ParsePlatform/GeolocationsWithCloudCode
