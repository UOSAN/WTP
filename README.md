## Willingness To Pay (WTP) task

Code and stimuli for the Willingness To Pay task used in the CHIVES study. 

Originally adapted from Hutcherson et al. (2012).

## Key scripts
**`runMoney.m`**
This script runs the task. You can specify whether the task will be run in the MRI scanner or behaviorally. User inputs include:
- Study name
- Subject ID
- Session Number (0 = practice)
- Session type (MRI or behavioral)

**`runMoney_practice.m`** 
This script runs the practice session. You can specify whether the task will be run in the MRI scanner or behaviorally. User inputs include:
- Study name
- Subject ID
- Session Number (0 = practice)
- Session type (MRI or behavioral)

**`runAuction.m`** 
This script runs the food auction. You'll need to update the `selectfood.m` file with currently available food items. User inputs include:
- Study name
- Subject ID
- Session Number (0 = practice)
- Session type (MRI or behavioral)

## Output
Files are save to the SubjectData directory.

**PTBParams structure** stores psychtoolbox parameters

**Data structure** stores the following data:

- `subjid` = Subject ID
- `ssnid` = Session ID (0 = practice)
- `time` = Date and time log
- `StartTime` = Start time that all events are referenced from
- `Jitter` = cell array with fixation jitters for each trial
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