## Willingness To Pay (WTP) task

Code and stimuli for the Willingness To Pay task used in the Duke study. 

Originally adapted from Hutcherson et al. (2012).

## Key scripts
**`runRandomize.m`** 
This script randomizes the images within each health category (healthy and unhealthy), splits the images based on the number of runs, and populates the image run folders `foodpics/run1` etc. User inputs include:
- Run Number = number of runs. The number of images in the healthy and unhealthy food folders must be divisible by this number.

**`runWTP.m`**
This script runs the task. You can specify whether the task will be run in the MRI scanner or behaviorally. User inputs include:
- Study name
- Subject ID
- Session Number (0 = practice)
- Session type (MRI or behavioral)

**`runWTP_practice.m`** 
This script runs the practice session. You can specify whether the task will be run in the MRI scanner or behaviorally. User inputs include:
- Study name
- Subject ID
- Session Number (1, unless a longitudinal study)
- Run Number (0 = practice)
- Session type (MRI or behavioral)

**`runAuction.m`** 
This script runs the food auction. You'll need to update the `selectfood.m` file with currently available food items. User inputs include:
- Study name
- Subject ID
- Session Number (1, unless a longitudinal study)
- Run Number (0 = practice)
- Session type (MRI or behavioral)

## Output
Files are saved to the SubjectData directory. Files are nested in the following manner:
```
|-- SubjectData
    |-- duke999                   [StudyName SubjectID] 
        |-- duke.999.1.mat        [StudyName . SubjectID . Session.mat]
        |-- PTBParams.999.1.mat   [PTBParams . SubjectID . Session.mat]
```
**PTBParams structure** stores psychtoolbox parameters

**Data structure** stores the following data:

- `subjid` = Subject ID
- `ssnid` = Session ID (0 = practice)
- `runid` = Run number
- `time` = Date and time log
- `StartTime` = Start time that all events are referenced from
- `Jitter` = Cell array with fixation jitters for each trial
- `TrialStart` = Start time for each trial
- `ISI` = Fixation duration (Jitter + specified time)
- `FoodOn` = Absolute time when food image was flipped
- `BidOn` = Absolute time when bid was flipped
- `FoodOnset` = Food onset (`FoodOn` - `StartTime`)
- `BidOnset` = Food onset (`BidOn` - `StartTime`)
- `FoodDuration` = Duration of food image
- `BidDuration` = Duration of bid 
- `FoodPic` = Food image file name
- `FoodNum` = Food number from original list
- `Resp` = Bid response
- `RT` = Bid reaction time
- `EndTime` = End time
- `HealthCond` = Health condition (healthy or unhealthy)
