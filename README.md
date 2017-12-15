## Willingness To Pay (WTP) task

Code and stimuli for the Willingness To Pay task used in the Devaluation study. 

Originally adapted from Hutcherson et al. (2012).

## Key scripts
**`runJitter.m`** 
This script creates a vector with jitter times based on the number of trials per run. It is saved as `WTP/task/input/jitter.m`. The same jitter vector is used in each run. This script only needs to be run once (or until a desired vector is achieved) per study. User inputs include:
- Number of trials in each run

**`runGetStim.m`** 
This script selects images based on subject ratings, randomizes the images within each health (healthy and unhealthy) and liking (liked and disliked) category, splits the images based on the number of runs, and populates the image run folders `foodpics/run1` etc. User inputs include:
- Study name
- Subject ID
- Number of runs 
- Total number of trials per condition (This number must be divisible by the number of runs)
- Image ratings saved as a .csv file with the following format: `WTP/task/input/[StudyName SubjectID]_ratings.csv` e.g. `DEV999_ratings.csv`

**`runWTP.m`**
This script runs the task. You can specify whether the task will be run in the MRI scanner or behaviorally. User inputs include:
- Study name
- Subject ID
- Session Number (0 = practice; 1, unless a longitudinal study)
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
    |-- DEV999                   [StudyName SubjectID] 
        |-- DEV.999.1.mat        [StudyName . SubjectID . Session.mat]
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
- `HealthCond` = Health condition (healthy or unhealthy)
- `LikingCond` = Liking condition (liked or disliked)
- `LikingRating` = Liking rating (collected prior to running the task)
- `Resp` = Bid response
- `RT` = Bid reaction time
- `EndTime` = End time