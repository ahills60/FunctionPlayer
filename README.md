# Function Player for MATLAB
The function player for MATLAB is a basic and rather quickly written application to serve as a proof of concept. It is capable of "playing" a piece of MATLAB code a particular rate and displays the contents to a frame which can contain multiple axes.

The frame updates based on a timer call and the update interval can be adjusted by changing the FPS value. Similarly the interval between frames can also be changed. Using a timer call means a while loop or pause events are not necessary, making the GUI still responsive and functional. 

## Project files
Two files are used for the GUI (`playergui.*`) and the third, `testfunction1.m`, provides a test function and the required syntax to display axes to the figure.

Note that the GUI does not make use of the axes object but instead uses the UIPanel object. This can be used to add child axes and, thus, use subplot within a custom-built GUI.

### Function structure
The function that is called every clock tick or button forward/back press needs to have two input arguments `currentFrame` and `targetHandle`. The first corresponds with the current frame number and the second is the handle to the UIPanel.

To plot to the UI panel object, an axis needs to be defined either through the subplot or the axes function call:

* `axis1 = subplot(1, 2, 1, 'Parent', targetHandle);`
* `axis1 = axes('Parent', targetHandle);`

Then, when calling the plot function, simply pass it the appropriate axis handle, e.g. `plot(axis1, xdata, ydata)`. Setting `xlim` and `ylim` will ensure the axis is fixed and won't scale to a growth (or decline) in data points. 

## Usage
To call a particular function, e.g. `testfunction1.m`, you will need to call:
```matlab
playergui(@testfunction1)
```

## Notes
The GUI may be unresponsive to FPS or step size changes. You may need to press this button more than once for an update to be made.