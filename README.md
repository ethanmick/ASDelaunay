# ASDelaunay #

There are a few [other](https://github.com/czgarrett/delaunay-ios) libaries which have tackled the Voronoi and Delaunay problem in Objective-C, but neither have implemented all the features which I required.



Picture 1, picture 2, picture 3 of the graphs.

## Features ##

* ARC compatible
* XCode 4.4 or newer for autosynthesized properties.
* Generates Voronoi and Delaunay edges
* Built into a .framework to easily use in projects.


Things Missing in this port:
 * Colors have been removed.


## Installation ##

1. download framework from somewhere I host...?

2. or show instructiosn for setting up github thing.


## Use ##

example on how to use it.

Example on making it run in a background thread, because it's a long task.

I've done my best to keep the interfaces the same, so if you have used the original library, this library should work in the same way. Class names have been given the *AS* prefix, and method names have been Apple-ized; but the functionality remains the same.

## Testing ##
I wish I could test the project more than it has been. It order to get the library working I spent time examining the output from the original as3delaunay library, seeing where my output differed, and correcting the mistakes. I wish the original library had unit tests that I could have simply ported over.  
But that is not the case. As such, this project only has a few tests which go through and ensure the code works for a small number of points, and then again for a large number of points. These points and numbers have been tested with the original library to ensure that this version is correct as well.  
Perhaps one day, if I so wish to torture myself with the pains of lookinat at more ActionScript code, I'll write some unit tests.

GO AND TEST THIS MORE BITCH
