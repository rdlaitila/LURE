# Lua User Interface Rendering Engine

LURE is a ambitious project to provide a HTML/CSS based rendering engine primarily targeting the Love2d game engine. LURE *does not* intend to impliment a fully standards compliant web browser. In so far as practicality permits, LURE aims to impliment documented and undocumented portions of HTML/Browser specs that support the parsing and rendering of HTML to a graphical subsystem.

# Status

LURE is currently under development and cannot yet produce rendered content. Much of the DOM and associated subsystems are still under heavy design and development. A prior naive implimentation was written many years ago and for reference purposes is found in the __legacy__ folders of many of the project's sub-directories, which was capable of rendering some very primitive DOM elements and text.

# Motivation

I started LURE some many years ago as a curiosity in parsing HTML. The final goal was to use XML/HTML markup to build ingame UI for my game projects. Since then it has become a project in building a closer approximation of a proper HTML/CSS parser and renderer. 

There are many quiet periods of development, but I always return to this project because the complexity of parsing and rendering HTML/CSS has always facinated me and I regard HTML/CSS as the most advanced and flexable UI framework to-date, even with its many warts and peculiarities.

If I could modify a historical quote to sum up my motivations on this project:

> We choose to [build a html/css rendering engine in pure lua] and do the other things, not because they are easy, but because they are hard; because that goal will serve to organize and measure the best of our energies and skills, because that challenge is one that we are willing to accept, one we are unwilling to postpone, and one we intend to win ...

― John F. Kennedy

# Goals

* To provide an easy to use UI library for the Love2d Game Engine using only HTML/CSS and lua script
* To showcase an approximation of web browser parser and renderer technologies and standards in pure lua.
* To eventually be able to pass ACID1 tests (phew!! what a goal)
* To eventually allow rendering with other lua graphics subsystems (not just Love2d!)

# Remarks

Building any type of HTML parser/renderer is a time consuming, character building experience. I have found that the vast majority of the DOM is well documented for reference, and building a naive HTML parser and DOM implimentation is not that critically difficult.

What I have found incredibly difficult is mating any DOM implimentation with a sufficiently advanced renderer that can efficiently and logically render the results of parsing and building HTML/CSS, and do so in a way that is predictable, supports future expantions into new functionality, and is easy to understand and modify.

The rendering aspect of HTML/CSS and the DOM is highly undocumented. Any resources around the web only give you a high level concept of what a real web browser might do for rendering, and the details are shroud in decades old web browser code and implimentations (Firefox Gecko, Webkit etc). Thus many assumtions must be made on how to actually render your DOM implimentation, for which I expect this project to make many misteps along the way to its ultimate goal.

For anyone willing to contribute, I say "coder beware". Here be dragons and be prepared to conduct some of the hardest Software Engineering outside of AI and naming things.