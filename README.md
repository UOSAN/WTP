# Willingness To Pay (WTP) task

## Introduction

The Willingness To Pay (WTP) task presents image stimuli of foods that are bid on, in $0.50 increments. At the end of the task, the participant can be rewarded with a food item and the monetary difference in bid for a random food item. This task is used in the Devaluation study.

Originally adapted from [Hutcherson et al. (2012)](https://doi.org/10.1523/JNEUROSCI.6387-11.2012).

- Conditions: pictures of food, where the food is in one of four conditions healthy and liked, healthy and disliked, unhealthy and liked, or unhealthy and disliked.
- Trial structure: Fixation cross (~5s in scanner, ~2s in behavioral), stimulus with text cue asking for a bid (4s), 1-4 rating (up to 2.5s) => 11.5 s/trial in scanner, 9.5 s/trial in behavioral.
- Duration: 16 trials per run in scanner = 184s. 32 trials per run in behavioral = 272s

## How to run the task

1. Launch the PsychoPy Builder.
2. Open the file `WTP.psyexp`.
3. Start the experiment by selecting the Tools -> Run menu item.
4. Fill in the participant number, the session number, and the run number. Sessions 1 and 2 are in-scanner sessions, while sessions 3, 4, and 5 are behavioral sessions. A practice run can be started by setting run_number to 0. The task will start automatically after that.

## Task description

The task starts by displaying instruction text. The instruction text is displayed until the user presses one of the response buttons, in the behavioral version, or the trigger signal is received from the MRI, in the scanner version. The instruction text for the behavioral version is:
```
The task is about to begin.
Get ready!
```
In the scanner version it is:
```
Calibrating scanner.
Please hold very still.
```

Trials are repeated 32 times, in the behavioral version, or 16 times, in the scanner version.

After all the trials are completed, end text is displayed for 4 seconds. The end text is:
```
The task is now complete.
```

At the end of the last run of a session, the participant can be rewarded with a randomly selected food item that they bid on and the monetary difference between the bid and the maximum possible bid.

### Trial structure

1. Display a white fixation cross on a black background for ~2s in the behavioral version or for ~5s in the scanner version. The cross is 48 pixels square.
2. Display image stimulus for 4s.
3. Add a cue of white text on black background centered above the image to the screen. The text is `How much would you pay to eat this food?`. Also display 4 squares evenly spaced in a row, from left to right, centered below the image, containing the text "1", "2", "3", "4" in black on a grey background. Above each box is a label "$0", "$.50", "$1", "$1.50" in white text indicating the value. Display for up to 2.5s, or until the participant responds.

## Configuration
Configuration occurs automatically on the first run of each session. The image ratings from the ImageSelection task are used to determine the conditions of healthy liked, healthy disliked, unhealthy liked, and unhealthy disliked foods, then conditions files, listing which images will be shown in order, are created.

## Developer documentation
Created using Developed with PsychoPy v2020.1.2
