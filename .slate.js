// Javascript config for Slate (work in progress)

//Config
slate.config("defaultToCurrentScreen", true);
slate.config("orderScreensLeftToRight", true);
slate.config("nudgePercentOf", "screenSize");
slate.config("resizePercentOf", "screenSize");

var sox = "screenOriginX";
var soy = "screenOriginY";
var ssx = "screenSizeX";
var ssy = "screenSizeY";

// Aliases
var fullScreen = slate.operation("move", {
    "x" : sox,
    "y" : soy,
    "width" : ssx,
    "height" : ssy
});

var leftHalf = slate.operation("push", {
    "direction" : "left",
    "style" : "bar-resize:screenSizeX/2"
});

var rightHalf = slate.operation("push", {
    "direction" : "right",
    "style" : "bar-resize:screenSizeX/2"
});

var topHalf = slate.operation("push", {
    "direction" : "top",
    "style" : "bar-resize:screenSizeY/2"
});

var bottomHalf = slate.operation("push", {
    "direction" : "down",
    "style" : "bar-resize:screenSizeY/2"
});

var bottomLeft = slate.operation("corner", {
    "direction" : "bottom-left",
    "width" : "screenSizeX/2",
    "height" : "screenSizeY/2"
});

var bottomRight = slate.operation("corner", {
    "direction" : "bottom-right",
    "width" : "screenSizeX/2",
    "height" : "screenSizeY/2"
});

var topLeft = slate.operation("corner", {
    "direction" : "top-left",
    "width" : "screenSizeX/2",
    "height" : "screenSizeY/2"
});

var topRight = slate.operation("corner", {
    "direction" : "top-right",
    "width" : "screenSizeX/2",
    "height" : "screenSizeY/2"
});

var throw0 = slate.operation("throw", {
    "screen" : "0"
});

var throw1 = slate.operation("throw", {
    "screen" : "1"
});

var throw2 = slate.operation("throw", {
    "screen" : "2"
});

// Layouts

var twoMonitorLayout = slate.layout("twoMonitors", {
    "_before_" : {},
    "_after_": {},
    "Textual IRC Client" : {
        "operations" : [function(windowObject) {
            windowObject.doOperation(throw0);
            windowObject.doOperation(leftHalf);
        }]
    },
    "Webex Teams" : {
        "operations" : [function(windowObject) {
            windowObject.doOperation(throw0);
            windowObject.doOperation(rightHalf);
        }]
    },
    "iTerm2" : {
        "operations" : [function(windowObject) {
            windowObject.doOperation(throw1);
            windowObject.doOperation(leftHalf);
        }]
    },
    "Firefox" : {
        "operations" : [function(windowObject) {
            windowObject.doOperation(throw1);
            windowObject.doOperation(rightHalf);
        }],
        "repeat" : true
    },
});

var oneMonitorLayout = slate.layout("oneMonitor", {
    "_before_" : {},
    "_after_" : {},
    "Textual IRC Client" : {
        "operations" : [leftHalf]
    },
    "iTerm2" : {
        "operations" : rightHalf
    },
    "Firefox" : {
        "operations" : fullScreen
    },
});



// Main Push Keys

slate.bind("z:cmd;alt", bottomLeft)
slate.bind("x:cmd;alt", bottomHalf)
slate.bind("c:cmd;alt", bottomRight)
slate.bind("a:cmd;alt", leftHalf)
slate.bind("s:cmd;alt", fullScreen)
slate.bind("d:cmd;alt", rightHalf)
slate.bind("q:cmd;alt", topLeft)
slate.bind("w:cmd;alt", topHalf)
slate.bind("e:cmd;alt", topRight)

// Main Throw Keys

//slate.bind("left:cmd;alt;ctrl", throwLeft)
//slate.bind("right:cmd;alt;ctrl", throwright)
slate.bind("1:cmd;alt", throw0)
slate.bind("2:cmd;alt", throw1)
slate.bind("3:cmd;alt", throw2)

//Main Nudge keys
slate.bind("up:cmd", slate.operation("nudge", { "x" : "+0", "y" : "-10" }));
slate.bind("down:cmd", slate.operation("nudge", { "x" : "+0", "y" : "+10" }));
slate.bind("left:cmd", slate.operation("nudge", { "x" : "-10", "y" : "+0" }));
slate.bind("right:cmd", slate.operation("nudge", { "x" : "+10", "y" : "+0" }));

// Layouts Keys
slate.bind("1:cmd;alt;shift", slate.operation("layout", { "name" : oneMonitorLayout }));
slate.bind("2:cmd;alt;shift", slate.operation("layout", { "name" : twoMonitorLayout }));




 
