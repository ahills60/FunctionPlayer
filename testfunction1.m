function testfunction1(frameNumber, targetHandle)

xdata = 1:frameNumber;
ydata = xdata .^ 2 + randn(1, frameNumber);
ydata2 = -ydata - randn(1, frameNumber);

% Next fix the axes. Don't forget to tell it you want to plot and limit a
% specific axes.
axis1 = subplot(1, 2, 1, 'Parent', targetHandle);
plot(axis1, xdata, ydata)
xlim(axis1, [0, 50])
ylim(axis1, [0, 2500])
% Second axis
axis2 = subplot(1, 2, 2, 'Parent', targetHandle);
plot(axis2, xdata, ydata2)
xlim(axis2, [0, 50])
ylim(axis2, [-2500, 0])
