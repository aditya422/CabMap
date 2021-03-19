# CabMap

## About the app.
App constains two screen.  First screen shows the list of cabs available within the coordinate bouds of default location which is Hamburg.  Second screen contains google map view, which show you the cabs available whithin the same coordinate bounds.  As you move the map to another location the cabs available for the new location whill be shown on the map.

## Prerequisites
1. cocoapods
2. Google Map SDK

## Installation
After downloading or cloning this repo, on terminal go to the path of the repo and run following command.
> pod install

## Network calls
The network call were few in this app.  And there was no requirement of uploading or downloading files.  Due to this I've used built in URLSession to make network calls instead of using any third party library.

## Maps
I've used Google maps instead of Apple maps just for a sake of accuracy.


