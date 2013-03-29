# ASDelaunay #

There are a few [other](https://github.com/czgarrett/delaunay-ios) libaries which have tackled the Voronoi and Delaunay problem in Objective-C, but neither have implemented all the features which I required. So, in an effor to create a fantastic library which met my needs, I transcribed the original [as3delaunay library](http://nodename.github.com/as3delaunay/) into Objective-C and the iOS SDK.

![Few Points](http://f.cl.ly/items/3R1Q0A0K0r21333u3S3i/Screen%20Shot%202013-03-27%20at%2010.53.44%20PM.png)
![More Points](http://f.cl.ly/items/2V0W3w0O2j192r1U0K3a/Screen%20Shot%202013-03-27%20at%2010.53.15%20PM.png)
![Lots of Points](http://f.cl.ly/items/0o301S2w0M3s2a1f2L23/Screen%20Shot%202013-03-27%20at%2010.54.37%20PM.png)
![Big Margins](http://f.cl.ly/items/0P0R3b0c37080p3p2U1g/Screen%20Shot%202013-03-27%20at%2011.11.59%20PM.png)

Black lines are the edges in the Voronoi Graph. Red lines are the edges in the Delaunay Graph. Each random point is a red dot.

## Features ##

* ARC
* XCode 4.4 or newer for autosynthesized properties
* Generates Voronoi and Delaunay edges
* Built into a .framework to easily use in projects
* MIT License

Things missing in this port:
 * Colors have been removed. Colors are up to the caller to figure out, as it should be. This servers as the model only and does not worry abou the view implementation.

### Version History ###

#### 1.0.0 March 29th, 2013 ####
* First Version


### Requirements ###
Requires ARC and Xcode 4.4 or greater for autosynthesized properties.

## Installation ##

There are a few different ways you can go about using this library.

1. The easiest is to download a prebuilt (arm7) framework [here](http://cl.ly/301U1G1M2m0B). Ensure you meet the following dependencies:
 * Core Graphics Framework
 * UIKit Framework
 * Foundation Framework
2. Unzip the framework, and drag it into your project.

Alternatively, you can download the project and get going yourself.
1. `git clone git@github.com:Wayfarer247/ASDelaunay.git`
2. `cd ASDelaunay`
3. Open the XCode project file. Things should be pretty self explainaitory. If you want to build the Framework yourself, choose the ASDelaunay Universal scheme in the top left, and then build. This will place the framework in the ${PROJECT_ROOT}/build folder.

If anybody wants I can setup Cocoa Pods for this.


## Use ##

After adding the Library to your project, using it is pretty straight forward.

```objective-c
///
/// At the top...
///
#import <ASDelaunay/ASDelaunay.h>

///
/// then later...
///

NSMutableArray *randomPoints = [[NSMutableArray alloc] init];

int numSites = [[self.numSitesEntry text] intValue]; //numSitesEntry is a text field to input how many Points to Make

///
/// Don't place points off the screen when we display them, but this is just for displaying purposes
///
xMax = [[UIScreen mainScreen] bounds].size.width;
yMax = [[UIScreen mainScreen] bounds].size.height - 20;

///
/// Build the random points!
///
for (int i = 0; i < numSites; i++) {
    float x = margin + (arc4random() % ((int)xMax - margin*2));
    float y = margin + (arc4random() % ((int)yMax - margin*2));
    ASPoint *point = [[ASPoint alloc] initWithX:x y:y];
    [randomPoints addObject:point];
}

///
/// PlotBounds, here, is just our view, but it could be anything. Negative numbers are fine.
///
ASDelaunay *voronoi = [[ASDelaunay alloc] initWithPoints:randomPoints plotBounds:CGRectMake(0, 0, xMax, yMax)];

///
/// To get the edges
///
for (ASEdge *edge in voronoi.edges) {
    NSLog(@"Voronoi Line: %@", edge.voronoiEdge);
    NSLog(@"Delaunay Line: %@", edge.delaunayLine);
}

```

It's that simple! Keep in mind that the creation of the ASVoronoi object can take a while, especially with a lot of points. You may want to put the creation in a background thread so the UI stays responsive.

I've done my best to keep the interfaces the same between the old library and this ported one. If you have used the original library, this library should work in the same way. Class names have been given the *AS* prefix, and method names have been Apple-ized; but the functionality remains the same.

## Testing ##
I wish I could test the project more than it has been. It order to get the library working I spent time examining the output from the original as3delaunay library, seeing where my output differed, and correcting the mistakes. I wish the original library had unit tests that I could have simply ported over.  
But that is not the case. As such, this project only has a few tests which go through and ensure the code works for a small number of points, and then again for a large number of points. These points and numbers have been tested with the original library to ensure that this version is correct as well.  
Perhaps one day, if I so wish to torture myself with the pains of lookinat at more ActionScript code, I'll write some unit tests.

However, to test correctness, I included some high level acceptances tests. I created 5 JSON files with 100 points in each, and inputted that into the original AS3 library. I then parsed the output back into JSON, and used those two files in the iOS Library. The Unit Tests read in the file for the points, run's through the program, and ensures the output is the same as it is in the JSON output files. As of now, all the tests pass.

However, for very large number of points, I am unsure of the correctness.

## Contributing ##
If you'd like to help, then please do so! I'd love for this Library to be *the* iOS Voronoi Library. In the future, I may do some of the following (which you should help with!)
* Increase the number of tests, and create fully functionaly Unit Tests.
* Test for a massive number of points to ensure correctness.
* Fix bugs that may have been present in the original library.
* Update interfaces and make it more user friendly for new users.
* Power up the performance and make it much more optimized.
* Convert to C.


## License - MIT License ##

Copyright (c) 2013 Ethan Mick

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
