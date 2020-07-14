/************ 
 * Wtp Test *
 ************/

// init psychoJS:
const psychoJS = new PsychoJS({
  debug: true
});

// open window:
psychoJS.openWindow({
  fullscr: true,
  color: new util.Color([(- 1), (- 1), (- 1)]),
  units: 'height',
  waitBlanking: true
});

// store info about the experiment session:
let expName = 'WTP';  // from the Builder filename that created this script
let expInfo = {'participant': '', 'session': '1', 'run_number': ''};

// schedule the experiment:
psychoJS.schedule(psychoJS.gui.DlgFromDict({
  dictionary: expInfo,
  title: expName
}));

const flowScheduler = new Scheduler(psychoJS);
const dialogCancelScheduler = new Scheduler(psychoJS);
psychoJS.scheduleCondition(function() { return (psychoJS.gui.dialogComponent.button === 'OK'); }, flowScheduler, dialogCancelScheduler);

// flowScheduler gets run if the participants presses OK
flowScheduler.add(updateInfo); // add timeStamp
flowScheduler.add(experimentInit);
flowScheduler.add(setupRoutineBegin());
flowScheduler.add(setupRoutineEachFrame());
flowScheduler.add(setupRoutineEnd());
flowScheduler.add(instructionsRoutineBegin());
flowScheduler.add(instructionsRoutineEachFrame());
flowScheduler.add(instructionsRoutineEnd());
const trialsLoopScheduler = new Scheduler(psychoJS);
flowScheduler.add(trialsLoopBegin, trialsLoopScheduler);
flowScheduler.add(trialsLoopScheduler);
flowScheduler.add(trialsLoopEnd);
flowScheduler.add(endRoutineBegin());
flowScheduler.add(endRoutineEachFrame());
flowScheduler.add(endRoutineEnd());
flowScheduler.add(quitPsychoJS, '', true);

// quit if user presses Cancel in dialog box:
dialogCancelScheduler.add(quitPsychoJS, '', false);

// Determine the name of the conditions file based on the participant number and run number
util.addInfoFromUrl(expInfo);
var participant;
var session;
var run_number;
var conditions_file;
var conditions_file_path;

participant = expInfo["participant"];
session = expInfo["session"];
run_number = expInfo["run_number"];

conditions_file = (((("DEV" + participant) + "_") + run_number) + "_conditions.csv");
conditions_file_path = './' + conditions_file;

psychoJS.start({
  expName: expName,
  expInfo: expInfo,
  resources: [
  {name: 'task/BidKeys.bmp', path: './resources/task/BidKeys.bmp'},
  {name: conditions_file, path: conditions_file_path}]
});

// Based on the contents of the conditions file, download only the image resources needed.
function condition_file_download() {
  const resourceValue = psychoJS.serverManager.getResource(conditions_file);
  const workbook = XLSX.read(new Uint8Array(resourceValue), { type: "array" });

  // we consider only the first worksheet:
  if (workbook.SheetNames.length === 0)
  throw 'workbook should contain at least one worksheet';

  const sheetName = workbook.SheetNames[0];
  const worksheet = workbook.Sheets[sheetName];

  // worksheet to array of arrays (the first array contains the fields):
  const sheet = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false });

  const fields = sheet.shift();

  // (*) select conditions:
  const selectedRows = sheet;

  let image_files = []
  for (const element of selectedRows) {
    image_files.push({name: (element[0]), path: (element[0].replace('task/foodpics', './resources'))});
  }

  psychoJS.downloadResources(image_files);
}

var frameDur;
function updateInfo() {
  expInfo['date'] = util.MonotonicClock.getDateStr();  // add a simple timestamp
  expInfo['expName'] = expName;
  expInfo['psychopyVersion'] = '2020.1.2';
  expInfo['OS'] = window.navigator.platform;

  // store frame rate of monitor if we can measure it successfully
  expInfo['frameRate'] = psychoJS.window.getActualFrameRate();
  if (typeof expInfo['frameRate'] !== 'undefined')
    frameDur = 1.0 / Math.round(expInfo['frameRate']);
  else
    frameDur = 1.0 / 60.0; // couldn't get a reliable measure so guess

  // add info from the URL:
  util.addInfoFromUrl(expInfo);
  
  return Scheduler.Event.NEXT;
}


var setupClock;
var instructionsClock;
var start_text_str;
var start_text;
var start_trigger;
var trialClock;
var fixation;
var stimulus_image;
var bid_cue;
var bid_key_image;
var response;
var endClock;
var end_text;
var globalClock;
var routineTimer;
function experimentInit() {
  // Initialize components for Routine "setup"
  setupClock = new util.Clock();
  // Initialize components for Routine "instructions"
  instructionsClock = new util.Clock();
  
  function is_mri_session(session) {
    return ((session === "1") || (session === "2"));
  }
  
  if (is_mri_session(session)) {
      start_text_str = "Calibrating scanner.\nPlease hold very still.";
  } else {
      start_text_str = "The task is about to begin.\nGet ready!";
  }

  condition_file_download();
  
  start_text = new visual.TextStim({
    win: psychoJS.window,
    name: 'start_text',
    text: 'default text',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], height: 0.075,  wrapWidth: undefined, ori: 0,
    color: new util.Color('white'),  opacity: 1,
    depth: -1.0 
  });
  
  start_trigger = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  // Initialize components for Routine "trial"
  trialClock = new util.Clock();
  fixation = new visual.ShapeStim ({
    win: psychoJS.window, name: 'fixation', units : 'pix', 
    vertices: 'cross', size:[48, 48],
    ori: 0, pos: [0, 0],
    lineWidth: 1, lineColor: new util.Color([1, 1, 1]),
    fillColor: new util.Color([1, 1, 1]),
    opacity: 1, depth: 0, interpolate: true,
  });
  
  stimulus_image = new visual.ImageStim({
    win : psychoJS.window,
    name : 'stimulus_image', units : undefined, 
    image : undefined, mask : undefined,
    ori : 0, pos : [0, 0], size : [0.5, 0.5],
    color : new util.Color([1, 1, 1]), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -1.0 
  });
  bid_cue = new visual.TextStim({
    win: psychoJS.window,
    name: 'bid_cue',
    text: 'How much would you pay to eat this food?',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0.4], height: 0.05,  wrapWidth: undefined, ori: 0,
    color: new util.Color('white'),  opacity: 1,
    depth: -2.0 
  });
  
  bid_key_image = new visual.ImageStim({
    win : psychoJS.window,
    name : 'bid_key_image', units : undefined, 
    image : 'task/BidKeys.bmp', mask : undefined,
    ori : 0, pos : [0, (- 0.4)], size : undefined,
    color : new util.Color([1, 1, 1]), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -3.0 
  });
  response = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  // Initialize components for Routine "end"
  endClock = new util.Clock();
  end_text = new visual.TextStim({
    win: psychoJS.window,
    name: 'end_text',
    text: 'The task is now complete.',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], height: 0.075,  wrapWidth: undefined, ori: 0,
    color: new util.Color('white'),  opacity: 1,
    depth: 0.0 
  });
  
  // Create some handy timers
  globalClock = new util.Clock();  // to track the time since experiment started
  routineTimer = new util.CountdownTimer();  // to track time remaining of each (non-slip) routine
  
  return Scheduler.Event.NEXT;
}


var t;
var frameN;
var setupComponents;
function setupRoutineBegin(trials) {
  return function () {
    //------Prepare to start Routine 'setup'-------
    t = 0;
    setupClock.reset(); // clock
    frameN = -1;
    // update component parameters for each repeat
    // keep track of which components have finished
    setupComponents = [];
    
    setupComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
    
    return Scheduler.Event.NEXT;
  };
}


var continueRoutine;
function setupRoutineEachFrame(trials) {
  return function () {
    //------Loop for each frame of Routine 'setup'-------
    let continueRoutine = true; // until we're told otherwise
    // get current time
    t = setupClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    setupComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function setupRoutineEnd(trials) {
  return function () {
    //------Ending Routine 'setup'-------
    setupComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
    // the Routine "setup" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    return Scheduler.Event.NEXT;
  };
}


var _start_trigger_allKeys;
var instructionsComponents;
function instructionsRoutineBegin(trials) {
  return function () {
    //------Prepare to start Routine 'instructions'-------
    t = 0;
    instructionsClock.reset(); // clock
    frameN = -1;
    // update component parameters for each repeat
    start_text.setText(start_text_str);
    start_trigger.keys = undefined;
    start_trigger.rt = undefined;
    _start_trigger_allKeys = [];
    // keep track of which components have finished
    instructionsComponents = [];
    instructionsComponents.push(start_text);
    instructionsComponents.push(start_trigger);
    
    instructionsComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
    
    return Scheduler.Event.NEXT;
  };
}


function instructionsRoutineEachFrame(trials) {
  return function () {
    //------Loop for each frame of Routine 'instructions'-------
    let continueRoutine = true; // until we're told otherwise
    // get current time
    t = instructionsClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *start_text* updates
    if (t >= 0.0 && start_text.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      start_text.tStart = t;  // (not accounting for frame time here)
      start_text.frameNStart = frameN;  // exact frame index
      
      start_text.setAutoDraw(true);
    }

    
    // *start_trigger* updates
    if (t >= 0.0 && start_trigger.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      start_trigger.tStart = t;  // (not accounting for frame time here)
      start_trigger.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { start_trigger.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { start_trigger.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { start_trigger.clearEvents(); });
    }

    if (start_trigger.status === PsychoJS.Status.STARTED) {
      let theseKeys = start_trigger.getKeys({keyList: ['1', '2', '3', '4', 'apostrophe'], waitRelease: false});
      _start_trigger_allKeys = _start_trigger_allKeys.concat(theseKeys);
      if (_start_trigger_allKeys.length > 0) {
        start_trigger.keys = _start_trigger_allKeys[_start_trigger_allKeys.length - 1].name;  // just the last key pressed
        start_trigger.rt = _start_trigger_allKeys[_start_trigger_allKeys.length - 1].rt;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    instructionsComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function instructionsRoutineEnd(trials) {
  return function () {
    //------Ending Routine 'instructions'-------
    instructionsComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
    // the Routine "instructions" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    return Scheduler.Event.NEXT;
  };
}


var trials;
var currentLoop;
function trialsLoopBegin(thisScheduler) {
  // set up handler to look after randomisation of conditions etc
  trials = new TrialHandler({
    psychoJS: psychoJS,
    nReps: 1, method: TrialHandler.Method.SEQUENTIAL,
    extraInfo: expInfo, originPath: undefined,
    trialList: conditions_file,
    seed: undefined, name: 'trials'
  });
  psychoJS.experiment.addLoop(trials); // add the loop to the experiment
  currentLoop = trials;  // we're now the current loop

  // Schedule all the trials in the trialList:
  trials.forEach(function() {
    const snapshot = trials.getSnapshot();

    thisScheduler.add(importConditions(snapshot));
    thisScheduler.add(trialRoutineBegin(snapshot));
    thisScheduler.add(trialRoutineEachFrame(snapshot));
    thisScheduler.add(trialRoutineEnd(snapshot));
    thisScheduler.add(endLoopIteration(thisScheduler, snapshot));
  });

  return Scheduler.Event.NEXT;
}


function trialsLoopEnd() {
  psychoJS.experiment.removeLoop(trials);

  return Scheduler.Event.NEXT;
}


var _response_allKeys;
var trialComponents;
function trialRoutineBegin(trials) {
  return function () {
    //------Prepare to start Routine 'trial'-------
    t = 0;
    trialClock.reset(); // clock
    frameN = -1;
    // update component parameters for each repeat
    stimulus_image.setImage(image_file);
    response.keys = undefined;
    response.rt = undefined;
    _response_allKeys = [];
    // keep track of which components have finished
    trialComponents = [];
    trialComponents.push(fixation);
    trialComponents.push(stimulus_image);
    trialComponents.push(bid_cue);
    trialComponents.push(bid_key_image);
    trialComponents.push(response);
    
    trialComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
    
    return Scheduler.Event.NEXT;
  };
}


var frameRemains;
function trialRoutineEachFrame(trials) {
  return function () {
    //------Loop for each frame of Routine 'trial'-------
    let continueRoutine = true; // until we're told otherwise
    // get current time
    t = trialClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *fixation* updates
    if (t >= 0.0 && fixation.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      fixation.tStart = t;  // (not accounting for frame time here)
      fixation.frameNStart = frameN;  // exact frame index
      
      fixation.setAutoDraw(true);
    }

    frameRemains = 0.0 + jitter_duration - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (fixation.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      fixation.setAutoDraw(false);
    }
    
    // *stimulus_image* updates
    if (t >= jitter_duration && stimulus_image.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      stimulus_image.tStart = t;  // (not accounting for frame time here)
      stimulus_image.frameNStart = frameN;  // exact frame index
      
      stimulus_image.setAutoDraw(true);
    }

    frameRemains = jitter_duration + 6.5 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (stimulus_image.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      stimulus_image.setAutoDraw(false);
    }
    
    // *bid_cue* updates
    if (t >= (jitter_duration + 4) && bid_cue.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      bid_cue.tStart = t;  // (not accounting for frame time here)
      bid_cue.frameNStart = frameN;  // exact frame index
      
      bid_cue.setAutoDraw(true);
    }

    frameRemains = (jitter_duration + 4) + 2.5 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (bid_cue.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      bid_cue.setAutoDraw(false);
    }
    
    // *bid_key_image* updates
    if (t >= (jitter_duration + 4) && bid_key_image.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      bid_key_image.tStart = t;  // (not accounting for frame time here)
      bid_key_image.frameNStart = frameN;  // exact frame index
      
      bid_key_image.setAutoDraw(true);
    }

    frameRemains = (jitter_duration + 4) + 2.5 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (bid_key_image.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      bid_key_image.setAutoDraw(false);
    }
    
    // *response* updates
    if (t >= (jitter_duration + 4) && response.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      response.tStart = t;  // (not accounting for frame time here)
      response.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { response.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { response.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { response.clearEvents(); });
    }

    frameRemains = (jitter_duration + 4) + 2.5 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (response.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      response.status = PsychoJS.Status.FINISHED;
  }

    if (response.status === PsychoJS.Status.STARTED) {
      let theseKeys = response.getKeys({keyList: ['1', '2', '3', '4'], waitRelease: false});
      _response_allKeys = _response_allKeys.concat(theseKeys);
      if (_response_allKeys.length > 0) {
        response.keys = _response_allKeys[_response_allKeys.length - 1].name;  // just the last key pressed
        response.rt = _response_allKeys[_response_allKeys.length - 1].rt;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    trialComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function trialRoutineEnd(trials) {
  return function () {
    //------Ending Routine 'trial'-------
    trialComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
    psychoJS.experiment.addData('response.keys', response.keys);
    if (typeof response.keys !== 'undefined') {  // we had a response
        psychoJS.experiment.addData('response.rt', response.rt);
        routineTimer.reset();
        }
    
    response.stop();
    // the Routine "trial" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    return Scheduler.Event.NEXT;
  };
}


var endComponents;
function endRoutineBegin(trials) {
  return function () {
    //------Prepare to start Routine 'end'-------
    t = 0;
    endClock.reset(); // clock
    frameN = -1;
    routineTimer.add(4.000000);
    // update component parameters for each repeat
    // keep track of which components have finished
    endComponents = [];
    endComponents.push(end_text);
    
    endComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
    
    return Scheduler.Event.NEXT;
  };
}


function endRoutineEachFrame(trials) {
  return function () {
    //------Loop for each frame of Routine 'end'-------
    let continueRoutine = true; // until we're told otherwise
    // get current time
    t = endClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *end_text* updates
    if (t >= 0.0 && end_text.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      end_text.tStart = t;  // (not accounting for frame time here)
      end_text.frameNStart = frameN;  // exact frame index
      
      end_text.setAutoDraw(true);
    }

    frameRemains = 0.0 + 4.0 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (end_text.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      end_text.setAutoDraw(false);
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    endComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
    // refresh the screen if continuing
    if (continueRoutine && routineTimer.getTime() > 0) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function endRoutineEnd(trials) {
  return function () {
    //------Ending Routine 'end'-------
    endComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
    return Scheduler.Event.NEXT;
  };
}


function endLoopIteration(thisScheduler, loop) {
  // ------Prepare for next entry------
  return function () {
    if (typeof loop !== 'undefined') {
      // ------Check if user ended loop early------
      if (loop.finished) {
        // Check for and save orphaned data
        if (psychoJS.experiment.isEntryEmpty()) {
          psychoJS.experiment.nextEntry(loop);
        }
      thisScheduler.stop();
      } else {
        const thisTrial = loop.getCurrentTrial();
        if (typeof thisTrial === 'undefined' || !('isTrials' in thisTrial) || thisTrial.isTrials) {
          psychoJS.experiment.nextEntry(loop);
        }
      }
    return Scheduler.Event.NEXT;
    }
  };
}


function importConditions(trials) {
  return function () {
    psychoJS.importAttributes(trials.getCurrentTrial());
    return Scheduler.Event.NEXT;
    };
}


function quitPsychoJS(message, isCompleted) {
  // Check for and save orphaned data
  if (psychoJS.experiment.isEntryEmpty()) {
    psychoJS.experiment.nextEntry();
  }
  
  
  
  
  
  
  psychoJS.window.close();
  psychoJS.quit({message: message, isCompleted: isCompleted});
  
  return Scheduler.Event.QUIT;
}
