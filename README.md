iOS7 Backgrounding Tutorial
=========================

This repo contains both the sample service and iOS App to go along with the blog post about the new 
iOS 7 background features.


## iOS App
The iOS app provides a basic UITableView with the "Pull to Refresh" control.  When refreshed, a public service is accessed that will retrieve a random number of articles, including possibly zero results.  The newly retrieved results will have their cells with a light yellow background to distinguish they are new.
