/**
  Copyright (C) 2012-2019 by Autodesk, Inc.
  All rights reserved.

  HAAS Lathe post processor configuration.

  $Revision: 42715 bb7490cbf7744be0fe016711cd4e85bc17ebe8da $
  $Date: 2020-03-31 06:16:43 $

  FORKID {14D60AD3-4366-49dc-939C-4DB5EA48FF68}
*/

description = "HAAS ST-10Y TLMK VERSION";

var gotYAxis = true;
var yAxisMinimum = toPreciseUnit(gotYAxis ? -50.8 : 0, MM); // specifies the minimum range for the Y-axis
var yAxisMaximum = toPreciseUnit(gotYAxis ? 50.8 : 0, MM); // specifies the maximum range for the Y-axis
var xAxisMinimum = toPreciseUnit(0, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
var gotBAxis = false; // B-axis always requires customization to match the machine specific functions for doing rotations
var gotMultiTurret = false; // specifies if the machine has several turrets

var gotDoorControl = false;

// >>>>> INCLUDED FROM ../common/haas lathe.cps
///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     partEject                  - Manually eject the part
//     usePolarMode               - Force Polar mode for next operation
//
///////////////////////////////////////////////////////////////////////////////

if (!description) {
  description = "HAAS Lathe";
}
vendor = "Haas Automation";
vendorUrl = "https://www.haascnc.com";
legal = "Copyright (C) 2012-2020 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 40783;

if (!longDescription) {
  longDescription = subst("Preconfigured %1 post with support for mill-turn. You can force G112 mode for a specific operation by using Manual NC Action with keyword 'usepolarmode'.", description);
}

extension = "nc";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(120); // reduced sweep due to G112 support
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 470 : 12000;

// user-defined properties
properties = {
  // writeMachine: false, // write machine
  // writeTools: false, // writes the tools
  // writeVersion: false, // include version info
  // preloadTool: false, // preloads next tool on tool change if any
  // showSequenceNumbers: false, // show sequence numbers
  // sequenceNumberStart: 1, // first sequence number
  // sequenceNumberIncrement: 1, // increment for sequence numbers
  stopperToolNumber: 4, // tool that must go at start of program to pick G56
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: true, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  maximumSpindleSpeed: 2500, // specifies the maximum spindle speed
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: true, // specifies that operation notes should be output.
  useCycles: true, // specifies that drilling cycles should be used.
  autoEject: false, // specifies if the part should be automatically ejected at end of program
  g53HomePositionX: 0, // home position for X-axis
  g53HomePositionY: 0, // home position for Y-axis
  g53HomePositionZ: 0, // home position for Z-axis
  g53HomePositionSubZ: 0, // home Position for Z when the operation uses the Secondary Spindle
  g53WorkPositionSub: 0, // home position for secondary spindle
  useTailStock: false, // specifies to use the tailstock or not
  useBarFeeder: false, // specifies to use the bar feeder
  gotChipConveyor: false, // specifies to use a chip conveyor Y/N
  useG112: false, // specifies if the machine has XY polar interpolation (G112) capabilities
  useG61: false, // exact stop mode
  // useM97: false,
  setting102: 1.0, // diameter used by control to calculate feed rates (INCH value)
  rapidRewinds: false, // rewinds the C-axis using G0
  useSSV: false, // outputs M38/39 to enable SSV in turning operations
  optimizeCAxisSelect: false, // optimize output of enable/disable C-axis codes
  //gotSecondarySpindle: false, // specifies if the machine has a secondary spindle
  looping: false, //output program for M97 looping
  numberOfRepeats: 1, //how many times to loop program
  useSimpleThread: false, // outputs a G92 threading cycle, false outputs a G76 (standard) threading cycle
  airCleanChuck: true, // air clean chucks on transfer and eject
  safeStartAllOperations: false, // write optional blocks at the beginning of all operations that include all commands to start program
  
  // CUSTOM PROPERTIES

  // enableVariables: false, // enables use of variables in the program, use G56 for variables
  // useDetailLengthCalculation: false, // enable calculation of detail length for Z-axis
};


  // ORIGINAL PROPERTIES that was cleaned

  // writeVersion: {title:"Write version", description:"Write the version number in the header of the code.", group:0, type:"boolean"},
  // writeMachine: {title:"Write machine", description:"Output the machine settings in the header of the code.", group:0, type:"boolean"},
  // writeTools: {title:"Write tool list", description:"Output a tool list in the header of the code.", type:"boolean"},
  // sequenceNumberStart: {title:"Start sequence number", description:"The number at which to start the sequence numbers.", group:1, type:"integer"},
  // sequenceNumberIncrement: {title:"Sequence number increment", description:"The amount by which the sequence number is incremented by in each block.", group:1, type:"integer"},
  // showSequenceNumbers: {title:"Use sequence numbers", description:"Use sequence numbers for each block of outputted code.", group:1, type:"boolean"},
  // gotSecondarySpindle: {title:"Got secondary spindle", description:"Specifies if the machine has a secondary spindle.", type:"boolean"},
  

// user-defined property definitions
propertyDefinitions = {
  stopperToolNumber: {title: "WCS setup tool",description: "Number of tool that fixes the WCS", type: "integer", range: [1, 12]},
  separateWordsWithSpace: {title:"Separate words with space", description:"Adds spaces between words if 'yes' is selected.", type:"boolean"},
  useRadius: {title:"Radius arcs", description:"If yes is selected, arcs are outputted using radius values rather than IJK.", type:"boolean"},
  maximumSpindleSpeed: {title:"Max spindle speed", description:"Defines the maximum spindle speed allowed by your machines.", type:"integer", range:[0, 999999999]},
  useParametricFeed:  {title:"Parametric feed", description:"Specifies the feed value that should be output using a Q value.", type:"boolean"},
  showNotes: {title:"Show notes", description:"Writes operation notes as comments in the outputted code.", type:"boolean"},
  useCycles: {title:"Use cycles", description:"Specifies if canned drilling cycles should be used.", type:"boolean"},
  autoEject: {title:"Auto eject", description:"Specifies whether the part should automatically eject at the end of a program.", type:"boolean"},
  g53HomePositionX: {title:"G53 home position X", description:"G53 X-axis home position.", type:"number", group: "G53"},
  g53HomePositionY: {title:"G53 home position Y", description:"G53 Y-axis home position.", type:"number", group: "G53"},
  g53HomePositionZ: {title:"G53 home position Z", description:"G53 Z-axis home position.", type:"number", group: "G53"},
  g53HomePositionSubZ: {title:"G53 home position subspindle Z", description:"G53 Z-axis home position when Secondary Spindle is active.", type:"number", group: "G53"},
  g53WorkPositionSub: {title:"G53 subspindle working position", description:"G53 working position for Secondary Spindle when active.", type:"number", group: "G53"},
  useTailStock: {title:"Use tail stock", description:"Enable to use the tail stock.", type:"boolean"},
  useBarFeeder: {title:"Use bar feeder", description:"Enable to use the bar feeder.", type:"boolean"},
  gotChipConveyor: {title:"Use chip conveyor", description:"Specifies whether to use a chip conveyor.", type:"boolean", presentation:"yesno"},
  useG112: {title:"Use polar interpolation", description:"Enables polar interpolation output.", type:"boolean"},
  useG61: {title:"Use exact stop mode", description:"Enables exact stop mode.", type:"boolean"},
  setting102: {title: "Feed rate calculation diameter", description: "Defines the part diameter in inches that the control uses to calculate feed rates.", type: "spatial", range: [0.1, 9999.0]},
  rapidRewinds: {title: "Use G0 for rewinds", description: "Uses G0 moves for rewinding of the C-axis.", type: "boolean"},
  useSSV: {title: "Use SSV", description:"Outputs M38/M39 to enable SSV for turning operations.", type:"boolean"},
  optimizeCAxisSelect: {title:"Optimize C-axis selection", description:"Optimizes the output of enable/disable C-axis codes.", type:"boolean"},
  looping: {title:"Use M97 looping", description:"Output program for M97 looping.", type:"boolean", presentation:"yesno", group:"Looping"},
  numberOfRepeats: {title:"Number of repeats", description:"How many times to loop the program.", type:"integer", range:[0, 99999999], group:"Looping"},
  useSimpleThread: {title:"Use simple threading cycle", description:"Enable to output G92 simple threading cycle, disable to output G76 standard threading cycle.", type:"boolean"},
  airCleanChuck: {title:"Air clean chucks", description:"Enable to use the air blast to clean out the chuck on part transfers and part ejection.", type:"boolean"},
  safeStartAllOperations: {title:"Safe start all operations", description:"Write optional blocks at the beginning of all operations that include all commands to start program.", type:"boolean"},
  
  // CUSTOM PROPERTIES for variables and detail length calculation

  // Variables settings
  // enableVariables: {title:"Enable variables", description:"Enable to use variables in the program. Requires G56 for variables.", type:"boolean", group:6},
  // Detail length settings
  // useDetailLengthCalculation: {title:"Use detail length calculation", description:"Enable to use detail length calculation for Z-axis with G52.", type:"boolean", group:6}
};

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var pFormat = createFormat({prefix:"P", decimals:0});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode & IS SCALING POLAR COORDINATES
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true}); // radius
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var cFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xFormat);
var yOutput = createVariable({prefix:"Y"}, yFormat);
var zOutput = createVariable({prefix:"Z"}, zFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, cFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var pOutput = createVariable({prefix:"P", force:true}, rpmFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I", force:true}, spatialFormat);
var jOutput = createReferenceVariable({prefix:"J", force:true}, spatialFormat);
var kOutput = createReferenceVariable({prefix:"K", force:true}, spatialFormat);

// cycle thread output
var g76IOutput = createVariable({prefix:"I", force:true}, zFormat); // no scaling
var g76KOutput = createVariable({prefix:"K", force:true}, zFormat); // no scaling
var g76DOutput = createVariable({prefix:"D", force:true}, zFormat); // no scaling
var g76AOutput = createVariable({prefix:"A", force:true}, zFormat); // no scaling

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G98-99
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gSynchronizedSpindleModal = createModal({}, gFormat); // G198/G199
var gSpindleModal = createModal({}, gFormat); // G14/G15 SPINDLE MODE
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gPolarModal = createModal({}, gFormat); // G112, G113
var ssvModal = createModal({}, mFormat); // M38, M39
var cAxisEngageModal = createModal({}, mFormat);
var cAxisBrakeModal = createModal({}, mFormat);
var gExactStopModal = createModal({}, gFormat); // modal group for exact stop codes
var tailStockModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 100;
var usePolarCircular = false;
var showSequenceNumbers = true;

var WARNING_WORK_OFFSET = 0;
var WARNING_REPEAT_TAPPING = 1;

var SEQUENCE_NUMBER_INCREMENT = 1;
var SEQUENCE_NUMBER_START = 1;


// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var forcePolarMode;
var bestABCIndex = undefined;
var partCutoff = false;
var ejectRoutine = false;

// used to convert blocks to optional for safeStartAllOperations, might get used outside of onSection
var skipBlock = false;
var operationNeedsSafeStart = false;

var machineState = {
  liveToolIsActive: undefined,
  cAxisIsEngaged: undefined,
  machiningDirection: undefined,
  mainSpindleIsActive: undefined,
  subSpindleIsActive: undefined,
  mainSpindleBrakeIsActive: undefined,
  subSpindleBrakeIsActive: undefined,
  tailstockIsActive: undefined,
  usePolarMode: undefined,
  useXZCMode: undefined,
  axialCenterDrilling: undefined,
  tapping: undefined,
  currentBAxisOrientationTurning: new Vector(0, 0, 0),
  feedPerRevolution: undefined,
  stockTransferIsActive: false
};

/** G/M codes setup */
function getCode(code) {
  switch (code) {
  case "PART_CATCHER_ON":
    return mFormat.format(36);
  case "PART_CATCHER_OFF":
    return mFormat.format(37);
  case "TAILSTOCK_ON":
    machineState.tailstockIsActive = true;
    return mFormat.format(21);
  case "TAILSTOCK_OFF":
    machineState.tailstockIsActive = false;
    return mFormat.format(22);
  case "ENGAGE_C_AXIS":
    machineState.cAxisIsEngaged = true;
    return cAxisEngageModal.format(154);
  case "DISENGAGE_C_AXIS":
    machineState.cAxisIsEngaged = false;
    // C AXIS CUSTOM EDIT
    // return cAxisEngageModal.format(155);  // original
    return;
  case "POLAR_INTERPOLATION_ON":
    return gPolarModal.format(112);
  case "POLAR_INTERPOLATION_OFF":
    return gPolarModal.format(113);
  case "STOP_SPINDLE":
    if (machineState.liveToolIsActive) {
      machineState.liveToolIsActive = false;
      return mFormat.format(135);
    } else if (machineState.mainSpindleIsActive) {
      machineState.mainSpindleIsActive = false;
      return mFormat.format(5);
    } else if (machineState.subSpindleIsActive) {
      machineState.subSpindleIsActive = false;
      return mFormat.format(145);
    } else {
      return undefined;
    }
  case "START_LIVE_TOOL_CW":
    machineState.liveToolIsActive = true;
    return mFormat.format(133);
  case "START_LIVE_TOOL_CCW":
    machineState.liveToolIsActive = true;
    return mFormat.format(134);
  case "START_MAIN_SPINDLE_CW":
    machineState.mainSpindleIsActive = true;
    return mFormat.format(3);
  case "START_MAIN_SPINDLE_CCW":
    machineState.mainSpindleIsActive = true;
    return mFormat.format(4);
  case "START_SUB_SPINDLE_CW":
    machineState.subSpindleIsActive = true;
    return mFormat.format(143);
  case "START_SUB_SPINDLE_CCW":
    machineState.subSpindleIsActive = true;
    return mFormat.format(144);
  case "MAIN_SPINDLE_BRAKE_ON":
    machineState.mainSpindleBrakeIsActive = true;
    return cAxisBrakeModal.format(14);
  case "MAIN_SPINDLE_BRAKE_OFF":
    machineState.mainSpindleBrakeIsActive = false;
    return cAxisBrakeModal.format(15);
  case "SUB_SPINDLE_BRAKE_ON":
    machineState.subSpindleBrakeIsActive = true;
    return cAxisBrakeModal.format(114);
  case "SUB_SPINDLE_BRAKE_OFF":
    machineState.subSpindleBrakeIsActive = false;
    return cAxisBrakeModal.format(115);
  case "FEED_MODE_UNIT_REV":
    machineState.feedPerRevolution = true;
    return gFeedModeModal.format(99);
  case "FEED_MODE_UNIT_MIN":
    machineState.feedPerRevolution = false;
    return gFeedModeModal.format(98);
  case "CONSTANT_SURFACE_SPEED_ON":
    return gSpindleModeModal.format(96);
  case "CONSTANT_SURFACE_SPEED_OFF":
    return gSpindleModeModal.format(97);
  case "MAINSPINDLE_AIR_BLAST_ON":
    return mFormat.format(12);
  case "MAINSPINDLE_AIR_BLAST_OFF":
    return mFormat.format(13);
  case "SUBSPINDLE_AIR_BLAST_ON":
    return mFormat.format(112);
  case "SUBSPINDLE_AIR_BLAST_OFF":
    return mFormat.format(113);
  case "CLAMP_PRIMARY_CHUCK":
    return mFormat.format(10);
  case "UNCLAMP_PRIMARY_CHUCK":
    return mFormat.format(11);
  case "CLAMP_SECONDARY_CHUCK":
    return mFormat.format(110);
  case "UNCLAMP_SECONDARY_CHUCK":
    return mFormat.format(111);
  case "SPINDLE_SYNCHRONIZATION_ON":
    machineState.spindleSynchronizationIsActive = true;
    return gSynchronizedSpindleModal.format(199);
  case "SPINDLE_SYNCHRONIZATION_OFF":
    machineState.spindleSynchronizationIsActive = false;
    return gSynchronizedSpindleModal.format(198);
  case "START_CHIP_TRANSPORT":
    return mFormat.format(31);
  case "STOP_CHIP_TRANSPORT":
    return mFormat.format(33);
  case "OPEN_DOOR":
    return mFormat.format(85);
  case "CLOSE_DOOR":
    return mFormat.format(86);
  case "COOLANT_FLOOD_ON":
    return mFormat.format(8);
  case "COOLANT_FLOOD_OFF":
    return mFormat.format(9);
  case "COOLANT_AIR_ON":
    return mFormat.format(83);
  case "COOLANT_AIR_OFF":
    return mFormat.format(84);
  case "COOLANT_THROUGH_TOOL_ON":
    return mFormat.format(88);
  case "COOLANT_THROUGH_TOOL_OFF":
    return mFormat.format(89);
  case "COOLANT_OFF":
    return mFormat.format(9);
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
}

function isSpindleSpeedDifferent() {
  if (isFirstSection()) {
    return true;
  }
  if (getPreviousSection().getTool().clockwise != tool.clockwise) {
    return true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().surfaceSpeed, tool.surfaceSpeed)) {
      return true;
    }
  } else {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().spindleRPM, spindleSpeed)) {
      return true;
    }
  }
  return false;
}

function isToolInCenterX0() {
  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  return Math.abs(initialPosition.x) < 0.001;
}

function startSpindle(forceRPMMode, initialPosition, rpm) {
  var _skipBlock = skipBlock;
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }

  var useConstantSurfaceSpeed = currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED;
  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
  
  // ORIGINAL CODE G50 S.... befor cutting

  // if (useConstantSurfaceSpeed && !forceRPMMode) {
  //   skipBlock = _skipBlock;
  //   writeBlock(gFormat.format(50), sOutput.format(maximumSpindleSpeed));
  // }

  gSpindleModeModal.reset();
  skipBlock = _skipBlock;

  _spindleSpeed = useConstantSurfaceSpeed ? tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0) : _spindleSpeed;
  
  if (useConstantSurfaceSpeed && forceRPMMode) { // RPM mode is forced until move to initial position
    if (xFormat.getResultingValue(initialPosition.x) == 0) {
      _spindleSpeed = maximumSpindleSpeed;
    } else {
      _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
    }
  }

  // save initial position for check that tool is in center or not
  var initialPosition = getFramePosition(currentSection.getInitialPosition());

   // ORIGINAL CODE MODIFIED
   if (currentSection.getType() == TYPE_MILLING 
    && !machineState.axialCenterDrilling
    || machineState.tapping)  {
    if (isToolInCenterX0()) {
      //taping tool in center
      writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), sOutput.format(_spindleSpeed), mFormat.format(3));
    } else if (!isToolInCenterX0() && machineState.tapping) {
      //taping tool out of center
      // nothing to write G95 cycle
    } else {
      writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), pOutput.format(_spindleSpeed), 
      (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ? getCode("START_LIVE_TOOL_CW") :getCode("START_LIVE_TOOL_CCW")) // check if tool is axial or radial
      );
    }
  // G97 for drilling and live tools
  } else {
    //G97 for turning operations and thread turning with turning tool and turning tool in center
    if (machineState.axialCenterDrilling || hasParameter("operation-strategy") && getParameter("operation-strategy") == "turningThread") {
      writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), sOutput.format(_spindleSpeed), mFormat.format(3));
    } else {
      //G96 for all another
      _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
      writeBlock(getCode("CONSTANT_SURFACE_SPEED_ON"), sOutput.format(_spindleSpeed), mFormat.format(3)); // G96 for turning operations + M3
    }
  }


  // ORIGINAL CODE G97 S... M3/M4


  // switch (currentSection.spindle) {
  // case SPINDLE_PRIMARY: // main spindle
  //   if (machineState.isTurningOperation || machineState.axialCenterDrilling) { // turning main spindle
  //     skipBlock = _skipBlock;
  //     writeBlock(
  //       sOutput.format(_spindleSpeed),
  //       conditional(!machineState.tapping, tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW"))
  //     );
  //   } else { // milling main spindle
  //     skipBlock = _skipBlock;
  //     writeBlock(
  //       (machineState.tapping ? sOutput.format(spindleSpeed) : pOutput.format(_spindleSpeed)),
  //       conditional(!machineState.tapping, tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"))
  //     );
  //   }
  //   break;
  // case SPINDLE_SECONDARY: // sub spindle
  //   if (!properties.gotSecondarySpindle) {
  //     error(localize("Secondary spindle is not available."));
  //     return;
  //   }
  //   if (machineState.isTurningOperation || machineState.axialCenterDrilling) { // turning sub spindle
  //     // use could also swap spindles using G14/G15
  //     gSpindleModeModal.reset();
  //     skipBlock = _skipBlock;
  //     writeBlock(
  //       sOutput.format(_spindleSpeed),
  //       conditional(!machineState.tapping, tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW"))
  //     );
  //   } else { // milling sub spindle
  //     skipBlock = _skipBlock;
  //     writeBlock(pOutput.format(_spindleSpeed), tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
  //   }
  //   break;
  // }



  if (properties.useSSV) {
    if (machineState.isTurningOperation && hasParameter("operation-strategy") && getParameter("operation-strategy") != "turningThread") {
      skipBlock = _skipBlock;
      writeBlock(ssvModal.format(38));
    }
  }
}

// ORIGINAL G53 RETRACT

/** Write retract in XY/Z. */
function writeRetract(section, retractZ) {
  var _skipBlock = skipBlock;
  if (!isFirstSection()) {
    if (gotYAxis) {
      // skipBlock = _skipBlock;
      // writeBlock(gFormat.format(53), gMotionModal.format(0), "Y" + yFormat.format(properties.g53HomePositionY)); // retract
      // yOutput.reset();
    }
    // skipBlock = _skipBlock;
    // writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract
    // xOutput.reset();
    if (retractZ) {
      // skipBlock = _skipBlock;
      // writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format((section.spindle == SPINDLE_SECONDARY) ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract with regard to spindle
      // zOutput.reset();
    }
  }
}

/** Write WCS. */
function writeWCS(section) {
  var workOffset = section.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    workOffset = 1;
  }
  if (workOffset > 0) {
    if (workOffset > 6) {
      var code = workOffset - 6;
      if (code > 99) {
        error(localize("Work offset out of range."));
        return;
      }
      if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        writeBlock(gFormat.format(154), "P" + code);
        currentWorkOffset = workOffset;
      }
    } else {

      // CUSTOM CODE coment check if tool was changed

      // if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        writeBlock(gFormat.format(53 + workOffset)); // G54->G59
        currentWorkOffset = workOffset;
      // }
    }
  }
}

/** Returns the modulus. */
function getModulus(x, y) {
  return Math.sqrt(x * x + y * y);
}

/**
  Returns the C rotation for the given X and Y coordinates.
*/
function getC(x, y) {
  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  return Math.atan2(y, x) * direction;
}

/**
  Returns the C rotation for the given X and Y coordinates in the desired rotary direction.
*/
function getCClosest(x, y, _c, clockwise) {
  if (_c == Number.POSITIVE_INFINITY) {
    _c = 0; // undefined
  }
  if (!xFormat.isSignificant(x) && !yFormat.isSignificant(y)) { // keep C if XY is on center
    return _c;
  }
  var c = getC(x, y);
  if (clockwise != undefined) {
    if (clockwise) {
      while (c < _c) {
        c += Math.PI * 2;
      }
    } else {
      while (c > _c) {
        c -= Math.PI * 2;
      }
    }
  } else {
    min = _c - Math.PI;
    max = _c + Math.PI;
    while (c < min) {
      c += Math.PI * 2;
    }
    while (c > max) {
      c -= Math.PI * 2;
    }
  }
  return c;
}

function getCWithinRange(x, y, _c, clockwise) {
  var c = getCClosest(x, y, _c, clockwise);
  
  var cyclicLimit;
  var cyclic;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the U-axis
    cyclicLimit = machineConfiguration.getAxisU().getRange();
    cyclic = machineConfiguration.getAxisU().isCyclic();
  } else if (Vector.dot(machineConfiguration.getAxisV().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the V-axis
    cyclicLimit = machineConfiguration.getAxisV().getRange();
    cyclic = machineConfiguration.getAxisV().isCyclic();
  } else {
    error(localize("Unsupported rotary axis direction."));
    return 0;
  }
  
  // see if rewind is required
  forceRewind = false;
  if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
    if (!cyclic) {
      forceRewind = true;
    }
    c = getCClosest(x, y, 0); // find closest C to 0
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      var midRange = cyclicLimit[0] + (cyclicLimit[1] - cyclicLimit[0]) / 2;
      c = getCClosest(x, y, midRange); // find closest C to midRange
    }
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      error(localize("Unable to find C-axis position within the defined range."));
      return 0;
    }
  }
  return c;
}

/**
  Returns the desired tolerance for the given section.
*/
function getTolerance() {
  var t = tolerance;
  if (hasParameter("operation:tolerance")) {
    if (t > 0) {
      t = Math.min(t, getParameter("operation:tolerance"));
    } else {
      t = getParameter("operation:tolerance");
    }
  }
  return t;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    skipBlock = false;
    return;
  }
  if (properties.showSequenceNumbers) {
    if (sequenceNumber > 99999) {
      sequenceNumber = properties.sequenceNumberStart;
    }
    if (optionalSection || skipBlock) {
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    if (optionalSection || skipBlock) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
  skipBlock = false;
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (properties.showSequenceNumbers) {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += properties.sequenceNumberIncrement;
    }
  } else {
    writeWords2("/", arguments);
  }
}

function formatComment(text) {
  return "(" + String(text).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function getB(abc, section) {
  if (section.spindle == SPINDLE_PRIMARY) {
    return abc.y;
  } else {
    return Math.PI - abc.y;
  }
}


var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;


function onOpen() {

  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }
  
  if (properties.useG61) {
    gExactStopModal.format(64);
  }
  
  if (true) {
    var bAxisMain = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[-0.001, 90.001], preference:0});
    var cAxisMain = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:false, range:[-8280, 8280], preference:0});

    var bAxisSub = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[-0.001, 180.001], preference:0});
    var cAxisSub = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:false, range:[-8280, 8280], preference:0});

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle =  gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information

  machineConfiguration.setVendor("HAAS");
  machineConfiguration.setModel(description);

  if (!gotYAxis) {
    yOutput.disable();
  }
  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  }

  if (highFeedrate <= 0) {
    error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
    return;
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;
  writeln("%");

  if (programName) {
    var programId;
    try {
      programId = getAsInt(programName);
    } catch (e) {
      error(localize("Program name must be a number."));
      return;
    }
    if (!((programId >= 1) && (programId <= 99999))) {
      error(localize("Program number is out of range."));
      return;
    }
    var oFormat = createFormat({width:5, zeropad:true, decimals:0});
    if (programComment) {
      writeln("O" + oFormat.format(programId) + " (" + filterText(String(programComment).toUpperCase(), permittedCommentChars) + ")");
    } else {
      writeln("O" + oFormat.format(programId));
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }

  // MODIFIED CODE always write tool list

  var zRanges = {};
  if (is3D()) {
    var numberOfSections = getNumberOfSections();
    for (var i = 0; i < numberOfSections; ++i) {
      var section = getSection(i);
      var zRange = section.getGlobalZRange();
      var tool = section.getTool();
      if (zRanges[tool.number]) {
        zRanges[tool.number].expandToRange(zRange);
      } else {
        zRanges[tool.number] = zRange;
      }
    }
  }
    

  var tools = getToolTable();
  if (tools.getNumberOfTools() > 0) {
    for (var i = 0; i < tools.getNumberOfTools(); ++i) {
      var tool = tools.getTool(i);
      var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
      var comment = "T" + toolFormat.format(tool.number * 100 + compensationOffset % 100) + " " +
        (tool.diameter != 0 ? "D=" + spatialFormat.format(tool.diameter) + " " : "") +
        (tool.isTurningTool() ? localize("NR") + "=" + spatialFormat.format(tool.noseRadius) : localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
        (tool.taperAngle > 0 && (tool.taperAngle < Math.PI) ? " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg") : "") +
        (zRanges[tool.number] ? " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum()) : "") +
        " - " + localize(getToolTypeName(tool.type));
      writeComment(comment);
    }
  }
  
  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (spatialFormat.areDifferent(tooli.diameter, toolj.diameter) ||
              spatialFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
              (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }




  // CUSTOM CODE DIMENSIONS, WCS, STOPPER TOOL, SAFE BLOCK
  
  // Получаем размеры заготовки
  var workpiece = getWorkpiece();
  if (!workpiece) {
    error("Workpiece is not defined. Cannot generate code without workpiece information.");
    return;
  }
    
  // Непосредственно используем координаты Z заготовки
  var modelLength = Math.abs(workpiece.upper.z - workpiece.lower.z);
  var modelWidth = Math.abs(workpiece.upper.x - workpiece.lower.x);

  writeln("");

  writeComment("WORKPIECE DIMENSIONS:");
  writeComment("Length: " + xyzFormat.format(modelLength));
  writeComment("Diameter: " + xyzFormat.format(modelWidth));

  // SAFE BLOCK on programm start
  writeln("");
  writeComment("SAFE BLOCK");
  writeln("");

  //CUSTOM CODE G40 , G80 , G99 , G18 - turning plane
  writeBlock(gFormat.format(40), gFormat.format(80), getCode("FEED_MODE_UNIT_REV"), gFormat.format(18));

  // UNITS
  switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20));
      break;
    case MM:
      writeBlock(gUnitModal.format(21));
      break;
    }

  //ORIGINAL CODE SPINDLE SPEED
  writeBlock(gFormat.format(50), sOutput.format(properties.maximumSpindleSpeed));
  sOutput.reset();   
  
  // retract x, z, y  
  writeBlock(
    gFormat.format(28), 
    "U" + xFormat.format(properties.g53HomePositionX), 
    "W" + zFormat.format(properties.g53HomePositionZ), 
    "V" + yFormat.format(properties.g53HomePositionY)
  );

  writeln("");

  // CUSTOM CODE to write stopper tool
  // Get current section
  var currentSection = getSection(0); 

  // CUSTOM CODE to check if WCS is 3 / G56 
  if (currentSection.workOffset == 3) {
    writeComment("Z length = DET. LENGTH + SAFE DIST + CUT TOOL WIDTH ( apc. 10mm )");
    writeComment("Z length: " + xyzFormat.format(modelLength + 1) + " mm");
    writeComment("WCS setup tool: " + properties.stopperToolNumber + " ");
    writeln("");

    // Сохраняем длину заготовки в переменной #100
    writeComment("LOCAL VARIABLES");
    writeln("");
    writeBlock("#100 = " + xyzFormat.format(modelLength)); // Длина заготовки
    writeln("");
    
  }

  // CUSTOM CODE to write stopper tool
  writeComment("STOPPER TOOL");
  writeln("");
  writeBlock("T" + toolFormat.format(properties.stopperToolNumber * 100 + properties.stopperToolNumber % 100));
  writeWCS(currentSection);

  // add workpiece length to WCS only in G56
  if (currentSection.workOffset == 3){
    writeBlock(gFormat.format(52), "Z" + xyzFormat.format(modelLength + 0.5), formatComment("Set WCS using workpiece length + 0.5mm")); // Установка программного ограничения по Z используя длину заготовки
  }
  writeBlock(gFormat.format(0), "Z0."); // Move to Z0
  writeBlock(gFormat.format(0), "X5.", formatComment("stopper tool tip 3 + X from cut off + little gap")); // Move to X ( stopper tool tip 3 + x face gap )
  writeln("");
  writeBlock(mFormat.format(0), formatComment("PULL OUT WORKPIECE")); // PULL OUT WORKPIECE
  writeln("");
  writeBlock(gFormat.format(0), "Z5."); // Move to X0

  // Возвращаем только оси X и Z
  writeBlock(gFormat.format(53), "X" + xFormat.format(properties.g53HomePositionX)); // retract X
  writeBlock(gFormat.format(53), "Z" + zFormat.format(currentSection.spindle == SPINDLE_SECONDARY ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract Z
  writeln("");


  // Probing Surface Inspection
  if (typeof inspectionWriteVariables == "function") {
    inspectionWriteVariables();
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }




  if (properties.useG61) {
    writeBlock(gExactStopModal.format(61));
  }

  // writeBlock("#" + (firstFeedParameter - 1) + "=" + ((currentSection.spindle == SPINDLE_SECONDARY) ? properties.g53HomePositionSubZ : properties.g53HomePositionZ), formatComment("g53HomePositionZ"));

  var usesPrimarySpindle = false;
  var usesSecondarySpindle = false;
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (section.getType() != TYPE_TURNING) {
      continue;
    }
    switch (section.spindle) {
    case SPINDLE_PRIMARY:
      usesPrimarySpindle = true;
      break;
    case SPINDLE_SECONDARY:
      usesSecondarySpindle = true;
      break;
    }
  }

  

  if (properties.gotChipConveyor) {
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  }

  // automatically eject part at end of program
  if (properties.autoEject) {
    ejectRoutine = true;
  }
/*
  if (properties.useM97) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var section = getSection(i);
      writeBlock(mFormat.format(97), pFormat.format(section.getId() + properties.sequenceNumberStart), conditional(section.hasParameter("operation-comment"), "(" + section.getParameter("operation-comment") + ")"));
    }
    writeBlock(mFormat.format(30));
    if (properties.showSequenceNumbers && properties.useM97) {
      error(localize("Properties 'showSequenceNumbers' and 'useM97' cannot be active together at the same time."));
      return;
    }
  }
*/

  // support program looping for bar work
  if (properties.looping) {
    if (properties.numberOfRepeats < 1) {
      error(localize("numberOfRepeats must be greater than 0."));
      return;
    }
    if (sequenceNumber == 1) {
      sequenceNumber++;
    }
    writeln("");
    writeln("");
    writeComment(localize("Local Looping"));
    writeln("");
    writeBlock(mFormat.format(97), "P1", "L" + properties.numberOfRepeats);
    writeBlock(mFormat.format(30));
    writeln("");
    writeln("");
    writeln("N1 (START MAIN PROGRAM)");
  }
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  previousDPMFeed = 0;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

//ORIGINAL CODE feed F
function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F#" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if (movements & (1 << MOVEMENT_HIGH_FEED)) {
      var feedContext = new FeedContext(id, localize("High Feed"), this.highFeedrate);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("#" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  var _skipBlock = false;
  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    if (operationNeedsSafeStart) {
      _skipBlock = true;
    } else {
      return; // no change
    }
  }

  skipBlock = _skipBlock;
  onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  gMotionModal.reset();

  skipBlock = _skipBlock;
  writeBlock(
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(getB(abc, currentSection))),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );

  if (!currentSection.isMultiAxis() && !machineState.usePolarMode && !machineState.useXZCMode && !isToolInCenterX0()) {
    skipBlock = _skipBlock;
    onCommand(COMMAND_LOCK_MULTI_AXIS);
    currentWorkPlaneABC = abc;
  } else {
    forceWorkPlane();
  }
}

function getBestABC(section, which) {
  var W = section.workPlane;
  var abc = machineConfiguration.getABC(W);
  if (which == undefined) { // turning, XZC, Polar modes
    return abc;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    var axis = machineConfiguration.getAxisU(); // C-axis is the U-axis
  } else {
    var axis = machineConfiguration.getAxisV(); // C-axis is the V-axis
  }
  if (axis.isEnabled() && axis.isTable()) {
    var ix = axis.getCoordinate();
    var rotAxis = axis.getAxis();
    if (isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ||
        isSameDirection(machineConfiguration.getDirection(abc), Vector.product(rotAxis, -1))) {
      var direction = isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ? 1 : -1;
      var box = section.getGlobalBoundingBox();
      switch (which) {
      case 1:
        x = box.lower.x + ((box.upper.x - box.lower.x) / 2);
        y = box.lower.y + ((box.upper.y - box.lower.y) / 2);
        break;
      case 2:
        x = box.lower.x;
        y = box.lower.y;
        break;
      case 3:
        x = box.upper.x;
        y = box.lower.y;
        break;
      case 4:
        x = box.upper.x;
        y = box.upper.y;
        break;
      case 5:
        x = box.lower.x;
        y = box.upper.y;
        break;
      default:
        var R = machineConfiguration.getRemainingOrientation(abc, W);
        x = R.right.x;
        y = R.right.y;
        break;
      }
      abc.setCoordinate(ix, getCClosest(x, y, cOutput.getCurrent()));
    }
  }
  // writeComment("Which = " + which + "  Angle = " + abc.z)
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  var abc;
  if (machineState.isTurningOperation && gotBAxis) {
    var both = machineConfiguration.getABCByDirectionBoth(workPlane.forward);
    abc = both[0];
    if (both[0].z != 0) {
      abc = both[1];
    }
  } else {
    abc = getBestABC(section, bestABCIndex);
    if (closestABC) {
      if (currentMachineABC) {
        abc = machineConfiguration.remapToABC(abc, currentMachineABC);
      } else {
        abc = machineConfiguration.getPreferredABC(abc);
      }
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if (machineState.isTurningOperation && gotBAxis) { // remapABC can change the B-axis orientation
    if (abc.z != 0) {
      error(localize("Could not calculate a B-axis turning angle within the range of the machine."));
      return abc;
    }
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  if (!machineState.isTurningOperation) {
    var tcp = false;
    if (tcp) {
      setRotation(W); // TCP mode
    } else {
      var O = machineConfiguration.getOrientation(abc);
      var R = machineConfiguration.getRemainingOrientation(abc, W);
      setRotation(R);
    }
  }

  return abc;
}

function getBAxisOrientationTurning(section) {
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && (toolOrientation != 0)) {
    error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
  }

  var angle = toRad(toolAngle) + toolOrientation;

  var axis = new Vector(0, 1, 0);
  var mappedAngle = (currentSection.spindle == SPINDLE_PRIMARY ? (Math.PI / 2 - angle) : (Math.PI / 2 - angle));
  var mappedWorkplane = new Matrix(axis, mappedAngle);
  var abc = getWorkPlaneMachineABC(section, mappedWorkplane);

  return abc;
}

function setSpindleOrientationTurning(section) {
  var J; // cutter orientation
  var R; // cutting quadrant
  var leftHandTool = (hasParameter("operation:tool_hand") && (getParameter("operation:tool_hand") == "L" || getParameter("operation:tool_holderType") == 0));
  if (hasParameter("operation:machineInside")) {
    if (getParameter("operation:machineInside") == 0) {
      R = currentSection.spindle == SPINDLE_PRIMARY ? 3 : 4;
    } else {
      R = currentSection.spindle == SPINDLE_PRIMARY ? 2 : 1;
    }
  } else {
    if ((hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningFace")) ||
        (hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningPart"))) {
      R = currentSection.spindle == SPINDLE_PRIMARY ? 3 : 4;
    } else {
      error(subst(localize("Failed to identify spindle orientation for operation \"%1\"."), getOperationComment()));
      return;
    }
  }
  if (leftHandTool) {
    J = currentSection.spindle == (SPINDLE_PRIMARY ? 2 : 1);
  } else {
    J = currentSection.spindle == (SPINDLE_PRIMARY ? 1 : 2);
  }
  writeComment("Post processor is not customized, add code for cutter orientation and cutting quadrant here if needed.");
}

var bAxisOrientationTurning = new Vector(0, 0, 0);

function onSection() {
  


  // Detect machine configuration
  machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  if (!gotBAxis) {
    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    machineConfiguration.setSpindleAxis(new Vector(0, 0, 1)); // set the spindle axis depending on B0 orientation
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, 1); // map tip mode

  var previousTapping = machineState.tapping;
  machineState.tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
     (getParameter("operation:cycleType") == "right-tapping") ||
     (getParameter("operation:cycleType") == "left-tapping") ||
     (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  machineState.isTurningOperation = (currentSection.getType() == TYPE_TURNING);
  if (machineState.isTurningOperation && gotBAxis) {
    bAxisOrientationTurning = getBAxisOrientationTurning(currentSection);
  }
  partCutoff = hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningPart");
  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    //ORIGINAL CODE print tool only on tool change T0101 T1
    // (tool.number != getPreviousSection().getTool().number) ||
    // CUSTOM CODE always print tool call
    (tool.number = getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);
  insertToolCall = (machineState.stockTransferIsActive && partCutoff) ? false : insertToolCall; // tool is loaded during stock transfer op

  var retracted = false; // specifies that the tool has been retracted to the safe plane
  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(bAxisOrientationTurning.x, machineState.currentBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(bAxisOrientationTurning.y, machineState.currentBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(bAxisOrientationTurning.z, machineState.currentBAxisOrientationTurning.z));

  operationNeedsSafeStart = properties.safeStartAllOperations && !isFirstSection();

  if (insertToolCall || newSpindle || newWorkOffset || newWorkPlane &&
      (!currentSection.isPatterned() && (!machineState.stockTransferIsActive && !partCutoff))) {
   
    // retract to safe plane
    retracted = true;
    if (!isFirstSection()) {
      if (insertToolCall) {
        onCommand(COMMAND_COOLANT_OFF);
      }
      writeRetract(currentSection, true); // retract in Z also
    }
  }

  var yAxisWasEnabled = !machineState.useXZCMode && !machineState.usePolarMode && machineState.liveToolIsActive;
  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)


  // ORIGINAL CODE check for stop spindle m5, m135, m145 - changed to custom code

  // if (currentSection.getTool().isLiveTool) {
  //   if (!isFirstSection() &&
  //       ((getPreviousSection().getTool().isLiveTool() != currentSection.getTool().isLiveTool()) ||
  //       (previousTapping && insertToolCall))) {
  //     writeBlock(getCode("STOP_SPINDLE"));
  //   }
  // } else {
  //   writeBlock(getCode("STOP_SPINDLE"));
  // }

  /*
  if (properties.useM97 && !isFirstSection()) {
    writeBlock(mFormat.format(99));
  }
*/

  if (properties.useSSV) {
    // ensure SSV is turned off
    writeBlock(ssvModal.format(39));
  }


  // CUSTOM CODE print N1 and so on every section start - for search
  writeBlock("N" + SEQUENCE_NUMBER_START);
  SEQUENCE_NUMBER_START += SEQUENCE_NUMBER_INCREMENT;


  /*
  if (properties.useM97) {
    writeBlock("N" + spatialFormat.format(currentSection.getId() + properties.sequenceNumberStart));
  }
*/

  // Consider part cutoff as stockTransfer operation
  if (!(machineState.stockTransferIsActive && partCutoff)) {
    machineState.stockTransferIsActive = false;
  }
  

  //ORIGINAL CODE OPERATION COMMENT
  
  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (!insertToolCall && operationNeedsSafeStart) {
    skipBlock = true;
    writeRetract(currentSection, true); // retract in Z also
  }

  //ORIGINAL CODE NOTES

  if (properties.showNotes && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  if (insertToolCall || operationNeedsSafeStart) {
    if (insertToolCall) {
      forceWorkPlane();
    }
    if (!properties.optimizeCAxisSelect) {
      cAxisEngageModal.reset();
    }
    retracted = insertToolCall;

    /** Handle multiple turrets. */
    if (gotMultiTurret) {
      var activeTurret = tool.turret;
      if (activeTurret == 0) {
        warning(localize("Turret has not been specified. Using Turret 1 as default."));
        activeTurret = 1; // upper turret as default
      }
      switch (activeTurret) {
      case 1:
        // add specific handling for turret 1
        break;
      case 2:
        // add specific handling for turret 2, normally X-axis is reversed for the lower turret
        //xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:-1}); // inverted diameter mode
        //xOutput = createVariable({prefix:"X"}, xFormat);
        break;
      default:
        error(localize("Turret is not supported."));
      }
    }

    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
    }

    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    if (compensationOffset > 99) {
      error(localize("Compensation offset is out of range."));
      return;
    }


    // ORIGINAL CODE for secondary spindle . delete ?
    // if (properties.gotSecondarySpindle) {
    //   switch (currentSection.spindle) {
    //   case SPINDLE_PRIMARY: // main spindle
    //     skipBlock = !insertToolCall;
    //     writeBlock(gSpindleModal.format(15));
    //     break;
    //   case SPINDLE_SECONDARY: // sub spindle
    //     skipBlock = !insertToolCall;
    //     writeBlock(gSpindleModal.format(14));
    //     break;
    //   }
    // }

    //ORIGINAL CODE safe start tool change

    skipBlock = !insertToolCall;
    writeBlock("T" + toolFormat.format(tool.number * 100 + compensationOffset));
    if (tool.comment) {
      writeComment(tool.comment);
    }

    var showToolZMin = false;
    if (showToolZMin && (currentSection.getType() == TYPE_MILLING)) {
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        var zRange = currentSection.getGlobalZRange();
        var number = tool.number;
        for (var i = currentSection.getId() + 1; i < numberOfSections; ++i) {
          var section = getSection(i);
          if (section.getTool().number != number) {
            break;
          }
          zRange.expandToRange(section.getGlobalZRange());
        }
        writeComment(localize("ZMIN") + "=" + zRange.getMinimum());
      }
    }

    /*
    if (properties.preloadTool) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        var compensationOffset = nextTool.isTurningTool() ? nextTool.compensationOffset : nextTool.lengthOffset;
        if (compensationOffset > 99) {
          error(localize("Compensation offset is out of range."));
          return;
        }
        writeBlock("T" + toolFormat.format(nextTool.number * 100 + compensationOffset));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstTool = section.getTool().number;
        if (tool.number != firstTool.number) {
          var compensationOffset = firstTool.isTurningTool() ? firstTool.compensationOffset : firstTool.lengthOffset;
          if (compensationOffset > 99) {
            error(localize("Compensation offset is out of range."));
            return;
          }
          writeBlock("T" + toolFormat.format(firstTool.number * 100 + compensationOffset));
        }
      }
    }
*/
  }

  if (!machineState.stockTransferIsActive) {
    if (machineState.isTurningOperation || machineState.axialCenterDrilling || isToolInCenterX0()) {
      skipBlock = !insertToolCall  && (machineState.cAxisIsEngaged != undefined);
      // writeBlock(conditional(machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("DISENGAGE_C_AXIS"));
    } else { // milling
      writeBlock(conditional(!machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("ENGAGE_C_AXIS"));
    }
  }

  // command stop for manual tool change, useful for quick change live tools
  if ((insertToolCall || operationNeedsSafeStart) && tool.manualToolChange) {
    skipBlock = !insertToolCall;
    onCommand(COMMAND_STOP);
    writeBlock("(" + "MANUAL TOOL CHANGE TO T" + toolFormat.format(tool.number * 100 + compensationOffset) + ")");
  }

  if (newSpindle) {
    // select spindle if required
  }

  // CUSTOM CODE G98/G99 print only for live tool

  var isToolDrill = tool.type == TOOL_DRILL;

  // Режим подачи (G98/G99) выводим только для живого инструмента
  gFeedModeModal.reset();
  if (currentSection.getType() == TYPE_MILLING) {
    if ((currentSection.feedMode == FEED_PER_REVOLUTION) || machineState.tapping || machineState.axialCenterDrilling || isToolDrill && isToolInCenterX0()) {
      writeBlock(getCode("FEED_MODE_UNIT_REV")); // unit/rev G99
    } else {
      writeBlock(getCode("FEED_MODE_UNIT_MIN")); // unit/min G98
    }
  }
  // Для токарных операций не выводим режим подачи, так как он уже подразумевается

  // Engage tailstock
  if (properties.useTailStock) {
    if (machineState.axialCenterDrilling || (currentSection.spindle == SPINDLE_SECONDARY) ||
       (machineState.liveToolIsActive && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      if (currentSection.tailstock) {
        warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      }
      if (machineState.tailstockIsActive) {
        writeBlock(getCode("TAILSTOCK_OFF"));
      }
    } else {
      writeBlock(currentSection.tailstock ? getCode("TAILSTOCK_ON") : getCode("TAILSTOCK_OFF"));
    }
  }

  // see page 138 in 96-8700an for stock transfer / G199/G198
  var spindleChange = forceSpindleSpeed || newSpindle || isSpindleSpeedDifferent() || (!machineState.liveToolIsActive && !machineState.mainSpindleIsActive && !machineState.subSpindleIsActive);
  if (!machineState.stockTransferIsActive) {
    if (insertToolCall || operationNeedsSafeStart ||
      spindleChange ||
      isFirstSection()) {
      if (machineState.isTurningOperation) {
        if (spindleSpeed > 3000) {
          warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
        }
      } else {
        if (spindleSpeed > 3000) {
          warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
        }
      }
      skipBlock = !insertToolCall && !spindleChange;

      // ORIGINAL CODE prints multiple times G97/G96 line
      startSpindle(true, getFramePosition(currentSection.getInitialPosition()));
    }
  }

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }

  // ORIGINAL CODE unused variable WCS delete?
  // var workOffset = currentSection.workOffset;


  // CUSTOM CODE add G52 Z#100 to every section start
  writeWCS(currentSection);

  if (currentSection.workOffset == 3){
    // print G52 every section start only if WCS is 3
    writeBlock(gMotionModal.format(52),"Z#100");
  }


  if (currentSection.partCatcher) {
    engagePartCatcher(true);
  }

  forceAny();
  gMotionModal.reset();

  gPlaneModal.reset();

  // MODIFIED CODE only print plane if its milling operation G19, G18, G17

  if (currentSection.getType() == TYPE_MILLING && !isToolDrill && !isToolInCenterX0()) {
    writeBlock(gPlaneModal.format(getPlane())); // take plane for milling
  }

  // M15; G0 C0;
  // MULTI AXIS PREPARATION
  
  var abc = new Vector(0, 0, 0);
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation || machineState.axialCenterDrilling || isToolInCenterX0()) {
      if (gotBAxis) {
        // TAG: handle B-axis support for turning operations here
        writeBlock(gMotionModal.format(0), conditional(machineConfiguration.isMachineCoordinate(1), bOutput.format(getB(bAxisOrientationTurning, currentSection))));
        machineState.currentBAxisOrientationTurning = bAxisOrientationTurning;
        //setSpindleOrientationTurning();
      } else {
        setRotation(currentSection.workPlane);
      }
    } else {
      if (currentSection.isMultiAxis()) {
        forceWorkPlane();
        cancelTransformation();
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        abc = currentSection.getInitialToolAxisABC();
      } else {
        if (machineState.useXZCMode) {
          setRotation(currentSection.workPlane); // enables calculation of the C-axis by tool XY-position
          abc = new Vector(0, 0, getCWithinRange(getFramePosition(currentSection.getInitialPosition()).x, getFramePosition(currentSection.getInitialPosition()).y, cOutput.getCurrent()));
        } else {
          abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
        }
      }
      setWorkPlane(abc);
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported by the CNC machine."));
      return;
    }
    setRotation(remaining);
  }



  forceAny();
  if (abc !== undefined) {
    if (!currentSection.isMultiAxis()) {
      cOutput.format(abc.z); // make C current - we do not want to output here
      previousABC.setZ(abc.z);
    }
  }

  if (machineState.cAxisIsEngaged) { // make sure C-axis in engaged
    if (!machineState.usePolarMode && !machineState.useXZCMode && !currentSection.isMultiAxis()) {
      onCommand(COMMAND_LOCK_MULTI_AXIS);
    } else {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    }
  }

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  /*
  if (!retracted) {
    // TAG: need to retract along X or Z
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }
*/
  if ((machineState.useXZCMode || machineState.usePolarMode) && yAxisWasEnabled) {
    if (gotYAxis && yOutput.isEnabled()) {
      writeBlock(gMotionModal.format(0), yOutput.format(0));
    }
  }
  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }
  gMotionModal.reset();
  
  if (properties.useG61) {
    writeBlock(gExactStopModal.format(61));
  }

  if (insertToolCall || retracted || machineState.useXZCMode || (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
    gMotionModal.reset();
    if (machineState.useXZCMode) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      writeBlock(
        gMotionModal.format(0),
        xOutput.format(getModulus(initialPosition.x, initialPosition.y)),
        conditional(gotYAxis, yOutput.format(0)),
        cOutput.format(getCWithinRange(initialPosition.x, initialPosition.y, cOutput.getCurrent()))
      );
      previousABC.setZ(cOutput.getCurrent());
    } else {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
    }
  }


  // /M8
  // set coolant after we have positioned at Z and X
  setCoolant(tool.coolant); 


  // enable SFM spindle speed
  // ORIGINAL CODE prints multiple times G97/ G96
  // if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
  //   startSpindle(false);
  // }

  if (properties.useParametricFeed &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle()) &&
      !machineState.useXZCMode) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }
  
  if (false) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " : " + machineState[key]);
    }
    // writeComment((getMachineConfigurationAsText(machineConfiguration)));
  }


}

//b
function getPlane() {
  if (machineState.isTurningOperation) {
    return undefined; // Don't output plane for turning operations as G18 is default
  }
  
  if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) { // axial
    if (machineState.useXZCMode ||
        (currentSection.hasParameter("operation-strategy") && (currentSection.getParameter("operation-strategy") == "drill"))) {
      return 18;
    } else {
      return 17; // G112 and XY milling only
    }
  } else if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // radial
    return 19; // YZ plane
  } else {
    error(subst(localize("Unsupported machining direction for operation " +  "\"" + "%1" + "\"" + "."), getOperationComment()));
    return undefined;
  }
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var c = 0;
  if (abc) {
    c = abc.z;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    c *= (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    c *= (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI / 2), Math.sin(c + Math.PI / 2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (false) { // DEBUG
      writeComment("toolpath X min: " + xFormat.format(xRange[0]) + ", " + "Limit " + xFormat.format(xAxisMinimum));
      writeComment("X-min within range: " + (xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum)));
      writeComment("toolpath Y min: " + spatialFormat.getResultingValue(yRange[0]) + ", " + "Limit " + yAxisMinimum);
      writeComment("Y-min within range: " + (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum));
      writeComment("toolpath Y max: " + (spatialFormat.getResultingValue(yRange[1]) + ", " + "Limit " + yAxisMaximum));
      writeComment("Y-max within range: " + (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum));
    }

    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if ((spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
          (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    } else { // G17 plane
      if ((xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum)) &&
          (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
          (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    }
  } else {
    if (revision < 40000) {
      warning(localize("Please update to the latest release to allow XY linear interpolation instead of polar interpolation."));
    }
    return false; // for older versions without the getGlobalRange() function
  }
}

var MACHINING_DIRECTION_AXIAL = 0;
var MACHINING_DIRECTION_RADIAL = 1;
var MACHINING_DIRECTION_INDEXING = 2;

function getMachiningDirection(section) {
  var forward = section.isMultiAxis() ? section.getGlobalInitialToolAxis() : section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    machineState.machiningDirection = MACHINING_DIRECTION_AXIAL;
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    machineState.machiningDirection = MACHINING_DIRECTION_RADIAL;
    return MACHINING_DIRECTION_RADIAL;
  } else {
    machineState.machiningDirection = MACHINING_DIRECTION_INDEXING;
    return MACHINING_DIRECTION_INDEXING;
  }
}

function updateMachiningMode(section) {
  machineState.axialCenterDrilling = false; // reset
  machineState.usePolarMode = false; // reset
  machineState.useXZCMode = false; // reset

  if ((section.getType() == TYPE_MILLING) && !section.isMultiAxis()) {
    if (getMachiningDirection(section) == MACHINING_DIRECTION_AXIAL) {
      if (section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "drill")) {
        // drilling axial
        if ((section.getNumberOfCyclePoints() == 1) &&
            !xFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).x) &&
            !yFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).y) &&
            (spatialFormat.format(section.getFinalPosition().x) == 0) &&
            !doesCannedCycleIncludeYAxisMotion()) { // catch drill issue for old versions
          // single hole on XY center
          if (section.getTool().isLiveTool && section.getTool().isLiveTool()) {
            // use live tool
          } else {
            // use main spindle for axialCenterDrilling
            machineState.axialCenterDrilling = true;
          }
        } else {
          // several holes not on XY center, use live tool in XZCMode
          machineState.useXZCMode = true;
        }
      } else { // milling
        fitFlag = false;
        bestABCIndex = undefined;
        for (var i = 0; i < 6; ++i) {
          fitFlag = doesToolpathFitInXYRange(getBestABC(section, i));
          if (fitFlag) {
            bestABCIndex = i;
            break;
          }
        }
        if (fitFlag) {
          if (forcePolarMode) { // polar mode is requested by user
            machineState.usePolarMode = true;
            bestABCIndex = undefined;
          } else {
            // toolpath matches XY ranges, keep false
          }
        } else {
          // toolpath does not match XY ranges, enable interpolation mode
          if (properties.useG112 || forcePolarMode) {
            machineState.usePolarMode = true;
          } else {
            machineState.useXZCMode = true;
          }
        }
      }
    } else if (getMachiningDirection(section) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if (!gotYAxis) {
        if (!section.isMultiAxis() && !doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) && doesCannedCycleIncludeYAxisMotion()) {
          error(subst(localize("Y-axis motion is not possible without a Y-axis for operation \"%1\"."), getOperationComment()));
          return;
        }
      } else {
        if (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane))) {
          error(subst(localize("Toolpath exceeds the maximum ranges for operation \"%1\"."), getOperationComment()));
          return;
        }
      }
      // C-coordinates come from setWorkPlane or is within a multi axis operation, we cannot use the C-axis for non wrapped toolpathes (only multiaxis works, all others have to be into XY range)
    } else {
      // useXZCMode & usePolarMode is only supported for axial machining, keep false
    }
  } else {
    // turning or multi axis, keep false
  }

  if (machineState.axialCenterDrilling || isToolInCenterX0()) {
    cOutput.disable();
  } else {
    cOutput.enable();
  }

  var checksum = 0;
  checksum += machineState.usePolarMode ? 1 : 0;
  checksum += machineState.useXZCMode ? 1 : 0;
  checksum += machineState.axialCenterDrilling ? 1 : 0;
  validate(checksum <= 1, localize("Internal post processor error."));
}

function doesCannedCycleIncludeYAxisMotion() {
  // these cycles have Y axis motions which are not detected by getGlobalRange()
  var hasYMotion = false;
  if (hasParameter("operation:strategy") && (getParameter("operation:strategy") == "drill")) {
    switch (getParameter("operation:cycleType")) {
    case "thread-milling":
    case "bore-milling":
    case "circular-pocket-milling":
      hasYMotion = true; // toolpath includes Y-axis motion
      break;
    case "back-boring":
    case "fine-boring":
      var shift = getParameter("operation:boringShift");
      if (shift != spatialFormat.format(0)) {
        hasYMotion = true; // toolpath includes Y-axis motion
      }
      break;
    default:
      hasYMotion = false; // all other cycles don´t have Y-axis motion
    }
  } else {
    hasYMotion = true;
  }
  return hasYMotion;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

function setPolarMode(activate) {
  if (activate) {
    writeBlock(gMotionModal.format(0), cOutput.format(0)); // set C-axis to 0 to avoid G112 issues
    writeBlock(getCode("POLAR_INTERPOLATION_ON")); // command for polar interpolation

    // ORIGINAL CODE printed multiple times G17/G18/G19 plane
    // writeBlock(gPlaneModal.format(getPlane()));

    validate(gPlaneModal.getCurrent() == 17, localize("Internal post processor error.")); // make sure that G17 is active
    xFormat.setScale(1); // radius mode
    xOutput = createVariable({prefix:"X"}, xFormat);
    yOutput.enable(); // required for G112
  } else {
    writeBlock(getCode("POLAR_INTERPOLATION_OFF"));
    xFormat.setScale(2); // diameter mode
    xOutput = createVariable({prefix:"X"}, xFormat);
    if (!gotYAxis) {
      yOutput.disable();
    }
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 99999999);
  writeBlock(gFormat.format(4), "P" + milliFormat.format(milliseconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

var resetFeed = false;

function getHighfeedrate(radius) {
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    if (toDeg(radius) <= 0) {
      radius = toPreciseUnit(0.1, MM);
    }
    var rpm = spindleSpeed; // rev/min
    if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var O = 2 * Math.PI * radius; // in/rev
      rpm = tool.surfaceSpeed / O; // in/min div in/rev => rev/min
    }
    return highFeedrate / rpm; // in/min div rev/min => in/rev
  }
  return highFeedrate;
}

function onRapid(_x, _y, _z) {
  if (machineState.useXZCMode) {
    var start = getCurrentPosition();
    var dxy = getModulus(_x - start.x, _y - start.y);
    if (true || (dxy < getTolerance())) {
      var x = xOutput.format(getModulus(_x, _y));
      var c = cOutput.format(getCWithinRange(_x, _y, cOutput.getCurrent()));
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      if (forceRewind) {
        rewindTable(start, _z, cOutput.getCurrent(), highFeedrate, false);
      }
      writeBlock(gMotionModal.format(0), x, c, z);
      previousABC.setZ(cOutput.getCurrent());
      forceFeed();
      return;
    }

    onExpandedLinear(_x, _y, _z, highFeedrate);
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    var useG1 = ((x ? 1 : 0) + (y ? 1 : 0) + (z ? 1 : 0)) > 1 && !isCannedCycle;
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (useG1) {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, getFeed(getHighfeedrate(_x)));
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, getFeed(getHighfeedrate(_x)));
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, getFeed(getHighfeedrate(_x)));
        }
      } else {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(0), gFormat.format(41), x, y, z);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(0), gFormat.format(42), x, y, z);
          break;
        default:
          writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
        }
      }
    }
    if (false) {
      // axes are not synchronized
      writeBlock(gMotionModal.format(1), x, y, z, getFeed(getHighfeedrate(_x)));
      resetFeed = false;
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
      forceFeed();
    }
  }
}

/** Calculate the distance of a point to a line segment. */
function pointLineDistance(startPt, endPt, testPt) {
  var delta = Vector.diff(endPt, startPt);
  distance = Math.abs(delta.y * testPt.x - delta.x * testPt.y + endPt.x * startPt.y - endPt.y * startPt.x) /
    Math.sqrt(delta.y * delta.y + delta.x * delta.x); // distance from line to point
  if (distance < 1e-4) { // make sure point is in line segment
    var moveLength = Vector.diff(endPt, startPt).length;
    var startLength = Vector.diff(startPt, testPt).length;
    var endLength = Vector.diff(endPt, testPt).length;
    if ((startLength > moveLength) || (endLength > moveLength)) {
      distance = Math.min(startLength, endLength);
    }
  }
  return distance;
}

/** Refine segment for XC mapping. */
function refineSegmentXC(startX, startC, endX, endC, maximumDistance) {
  var rotary = machineConfiguration.getAxisU(); // C-axis
  var startPt = rotary.getAxisRotation(startC).multiply(new Vector(startX, 0, 0));
  var endPt = rotary.getAxisRotation(endC).multiply(new Vector(endX, 0, 0));

  var testX = startX + (endX - startX) / 2; // interpolate as the machine
  var testC = startC + (endC - startC) / 2;
  var testPt = rotary.getAxisRotation(testC).multiply(new Vector(testX, 0, 0));

  var delta = Vector.diff(endPt, startPt);
  var distf = pointLineDistance(startPt, endPt, testPt);

  if (distf > maximumDistance) {
    return false; // out of tolerance
  } else {
    return true;
  }
}

function rewindTable(startXYZ, currentZ, rewindC, feed, retract) {
  if (!cFormat.areDifferent(rewindC, cOutput.getCurrent())) {
    error(localize("Rewind position not found."));
    return;
  }
  writeComment("Rewind of C-axis, make sure retracting is possible.");
  onCommand(COMMAND_STOP);
  if (retract) {
    writeBlock(gMotionModal.format(1), zOutput.format(currentSection.getInitialPosition().z), getFeed(feed));
  }
  writeBlock(getCode("DISENGAGE_C_AXIS"));
  writeBlock(getCode("ENGAGE_C_AXIS"));
  gMotionModal.reset();
  xOutput.reset();
  startSpindle(false);
  if (retract) {
    var x = getModulus(startXYZ.x, startXYZ.y);
    if (properties.rapidRewinds) {
      writeBlock(gMotionModal.format(1), xOutput.format(x), getFeed(highFeedrate));
      writeBlock(gMotionModal.format(0), cOutput.format(rewindC));
    } else {
      writeBlock(gMotionModal.format(1), xOutput.format(x), cOutput.format(rewindC), getFeed(highFeedrate));
    }
    writeBlock(gMotionModal.format(1), zOutput.format(startXYZ.z), getFeed(feed));
  }
  setCoolant(tool.coolant);
  forceRewind = false;
  writeComment("End of rewind");
}

function onLinear(_x, _y, _z, feed) {
  if (machineState.useXZCMode) {
    if (pendingRadiusCompensation >= 0) {
      error(subst(localize("Radius compensation is not supported for operation \"%1\". You have to use G112 mode for radius compensation."), getOperationComment()));
      return;
    }
    if (maximumCircularSweep > toRad(179)) {
      error(localize("Maximum circular sweep must be below 179 degrees."));
      return;
    }

    var localTolerance = getTolerance() / 4;

    var startXYZ = getCurrentPosition();
    var startX = getModulus(startXYZ.x, startXYZ.y);
    var startZ = startXYZ.z;
    var startC = cOutput.getCurrent();

    var endXYZ = new Vector(_x, _y, _z);
    var endX = getModulus(endXYZ.x, endXYZ.y);
    var endZ = endXYZ.z;
    var endC = getCWithinRange(endXYZ.x, endXYZ.y, startC);

    var currentXYZ = endXYZ; var currentX = endX; var currentZ = endZ; var currentC = endC;
    var centerXYZ = machineConfiguration.getAxisU().getOffset();

    var refined = true;
    var crossingRotary = false;
    forceOptimized = false; // tool tip is provided to DPM calculations
    while (refined) { // stop if we dont refine
      // check if we cross center of rotary axis
      var _start = new Vector(startXYZ.x, startXYZ.y, 0);
      var _current = new Vector(currentXYZ.x, currentXYZ.y, 0);
      var _center = new Vector(centerXYZ.x, centerXYZ.y, 0);
      if ((xFormat.getResultingValue(pointLineDistance(_start, _current, _center)) == 0) &&
          (xFormat.getResultingValue(Vector.diff(_start, _center).length) != 0) &&
          (xFormat.getResultingValue(Vector.diff(_current, _center).length) != 0)) {
        var ratio = Vector.diff(_center, _start).length / Vector.diff(_current, _start).length;
        currentXYZ = centerXYZ;
        currentXYZ.z = startZ + (endZ - startZ) * ratio;
        currentX = getModulus(currentXYZ.x, currentXYZ.y);
        currentZ = currentXYZ.z;
        currentC = startC;
        crossingRotary = true;
      } else { // check if move is out of tolerance
        refined = false;
        while (!refineSegmentXC(startX, startC, currentX, currentC, localTolerance)) { // move is out of tolerance
          refined = true;
          currentXYZ = Vector.lerp(startXYZ, currentXYZ, 0.75);
          currentX = getModulus(currentXYZ.x, currentXYZ.y);
          currentZ = currentXYZ.z;
          currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
          if (Vector.diff(startXYZ, currentXYZ).length < 1e-5) { // back to start point, output error
            if (forceRewind) {
              break;
            } else {
              warning(localize("Linear move cannot be mapped to rotary XZC motion."));
              break;
            }
          }
        }
      }

      currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
      if (forceRewind) {
        var rewindC = getCClosest(startXYZ.x, startXYZ.y, currentC);
        xOutput.reset(); // force X for repositioning
        rewindTable(startXYZ, currentZ, rewindC, feed, true);
        previousABC.setZ(rewindC);
      }
      var x = xOutput.format(currentX);
      var c = cOutput.format(currentC);
      var z = zOutput.format(currentZ);
      var actualFeed = getMultiaxisFeed(currentXYZ.x, currentXYZ.y, currentXYZ.z, 0, 0, currentC, feed);
      if (x || c || z) {
        writeBlock(gMotionModal.format(1), x, c, z, getFeed(actualFeed.frn));
      }
      setCurrentPosition(currentXYZ);
      previousABC.setZ(currentC);
      if (crossingRotary) {
        writeBlock(gMotionModal.format(1), cOutput.format(endC), getFeed(feed)); // rotate at X0 with endC
        previousABC.setZ(endC);
        forceFeed();
      }
      startX = currentX; startZ = currentZ; startC = crossingRotary ? endC : currentC; startXYZ = currentXYZ; // loop start point
      currentX = endX; currentZ = endZ; currentC = endC; currentXYZ = endXYZ; // loop end point
      crossingRotary = false;
    }
    forceOptimized = undefined;
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0 / threadPitch; // per mm for metric
    writeBlock(gMotionModal.format(32), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(1 / threadsPerInch));
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = ((currentSection.feedMode != FEED_PER_REVOLUTION) && machineState.feedPerRevolution) ? feedOutput.format(feed / spindleSpeed) : getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;

      // ORIGINAL CODE printed multiple times G17/G18/G19 plane
      // writeBlock(gPlaneModal.format(getPlane()));

      if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_INDEXING) {
        error(localize("Tool orientation is not supported for radius compensation."));
        return;
      }
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(41), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(42), x, y, z, f);
        break;
      default:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(getB(new Vector(_a, _b, _c), currentSection));
  var c = cOutput.format(_c);
  if (true) {
    // axes are not synchronized
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, getFeed(highFeedrate));
  } else {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
  previousABC.setZ(_c);
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(getB(new Vector(_a, _b, _c), currentSection));
  var c = cOutput.format(_c);
  
  var actualFeed = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed);
  var f = getFeed(actualFeed.frn);

  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
  previousABC.setZ(_c);
}

// Start of multi-axis feedrate logic
/***** Be sure to add 'useInverseTime' to post properties if necessary. *****/
/***** 'inverseTimeOutput' should be defined if Inverse Time feedrates are supported. *****/
/***** 'previousABC' can be added throughout to maintain previous rotary positions. Required for Mill/Turn machines. *****/
/***** 'headOffset' should be defined when a head rotary axis is defined. *****/
/***** The feedrate mode must be included in motion block output (linear, circular, etc.) for Inverse Time feedrate support. *****/
var dpmBPW = 0.1; // ratio of rotary accuracy to linear accuracy for DPM calculations
var inverseTimeUnits = 1.0; // 1.0 = minutes, 60.0 = seconds
var maxInverseTime = 45000; // maximum value to output for Inverse Time feeds
var maxDPM = 99999; // maximum value to output for DPM feeds
var useInverseTimeFeed = false; // use DPM feeds
var previousDPMFeed = 0; // previously output DPM feed
var dpmFeedToler = 0.5; // tolerance to determine when the DPM feed has changed
var previousABC = new Vector(0, 0, 0); // previous ABC position if maintained in post, don't define if not used
var forceOptimized = undefined; // used to override optimized-for-angles points (XZC-mode)

/** Calculate the multi-axis feedrate number. */
function getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed) {
  var f = {frn:0, fmode:0};
  if (feed <= 0) {
    error(localize("Feedrate is less than or equal to 0."));
    return f;
  }

  var length = getMoveLength(_x, _y, _z, _a, _b, _c);

  if (useInverseTimeFeed) { // inverse time
    f.frn = getInverseTime(length.tool, feed);
    f.fmode = 93;
    feedOutput.reset();
  } else { // degrees per minute
    f.frn = getFeedDPM(length, feed);
    f.fmode = 94;
  }
  return f;
}

/** Returns point optimization mode. */
function getOptimizedMode() {
  if (forceOptimized != undefined) {
    return forceOptimized;
  }
  // return (currentSection.getOptimizedTCPMode() != 0); // TAG:doesn't return correct value
  return true; // always return false for non-TCP based heads
}

/** Calculate the DPM feedrate number. */
function getFeedDPM(_moveLength, _feed) {
  if ((_feed == 0) || (_moveLength.tool < 0.0001) || (toDeg(_moveLength.abcLength) < 0.0005)) {
    previousDPMFeed = 0;
    return _feed;
  }
  var moveTime = _moveLength.tool / _feed;
  if (moveTime == 0) {
    previousDPMFeed = 0;
    return _feed;
  }

  var dpmFeed;
  var tcp = !getOptimizedMode() && (forceOptimized == undefined);   // set to false for rotary heads
  if (tcp) { // TCP mode is supported, output feed as FPM
    dpmFeed = _feed;
  } else if (false) { // standard DPM
    dpmFeed = Math.min(toDeg(_moveLength.abcLength) / moveTime, maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else if (false) { // combination FPM/DPM
    var length = Math.sqrt(Math.pow(_moveLength.xyzLength, 2.0) + Math.pow((toDeg(_moveLength.abcLength) * dpmBPW), 2.0));
    dpmFeed = Math.min((length / moveTime), maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else { // machine specific calculation
    var feedRate = _feed / (_moveLength.radius.z / (toPreciseUnit(properties.setting102, IN) / 2.0));
    feedRate = Math.min(feedRate, highFeedrate / 2);
    dpmFeed = Math.min(feedRate, maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  }
  previousDPMFeed = dpmFeed;
  return dpmFeed;
}

/** Calculate the Inverse time feedrate number. */
function getInverseTime(_length, _feed) {
  var inverseTime;
  if (_length < 1.e-6) { // tool doesn't move
    if (typeof maxInverseTime === "number") {
      inverseTime = maxInverseTime;
    } else {
      inverseTime = 999999;
    }
  } else {
    inverseTime = _feed / _length / inverseTimeUnits;
    if (typeof maxInverseTime === "number") {
      if (inverseTime > maxInverseTime) {
        inverseTime = maxInverseTime;
      }
    }
  }
  return inverseTime;
}

/** Calculate radius for each rotary axis. */
function getRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = new Vector(0, 0, 0);
  var startRadius;
  var endRadius;
  var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
  for (var i = 0; i < 3; ++i) {
    if (axis[i].isEnabled()) {
      var startRadius = getRotaryRadius(axis[i], startTool, startABC);
      var endRadius = getRotaryRadius(axis[i], endTool, endABC);
      radii.setCoordinate(axis[i].getCoordinate(), Math.max(startRadius, endRadius));
    }
  }
  return radii;
}

/** Calculate the distance of the tool position to the center of a rotary axis. */
function getRotaryRadius(axis, toolPosition, abc) {
  if (!axis.isEnabled()) {
    return 0;
  }

  var direction = axis.getEffectiveAxis();
  var normal = direction.getNormalized();
  // calculate the rotary center based on head/table
  var center;
  var radius;
  if (axis.isHead()) {
    var pivot;
    if (typeof headOffset === "number") {
      pivot = headOffset;
    } else {
      pivot = tool.getBodyLength();
    }
    if (axis.getCoordinate() == machineConfiguration.getAxisU().getCoordinate()) { // rider
      center = Vector.sum(toolPosition, Vector.product(machineConfiguration.getDirection(abc), pivot));
      center = Vector.sum(center, axis.getOffset());
      radius = Vector.diff(toolPosition, center).length;
    } else { // carrier
      var angle = abc.getCoordinate(machineConfiguration.getAxisU().getCoordinate());
      radius = Math.abs(pivot * Math.sin(angle));
      radius += axis.getOffset().length;
    }
  } else {
    center = axis.getOffset();
    var d1 = toolPosition.x - center.x;
    var d2 = toolPosition.y - center.y;
    var d3 = toolPosition.z - center.z;
    var radius = Math.sqrt(
      Math.pow((d1 * normal.y) - (d2 * normal.x), 2.0) +
      Math.pow((d2 * normal.z) - (d3 * normal.y), 2.0) +
      Math.pow((d3 * normal.x) - (d1 * normal.z), 2.0)
    );
  }
  return radius;
}

/** Calculate the linear distance based on the rotation of a rotary axis. */
function getRadialDistance(radius, startABC, endABC) {
  // calculate length of radial move
  var delta = Math.abs(endABC - startABC);
  if (delta > Math.PI) {
    delta = 2 * Math.PI - delta;
  }
  var radialLength = (2 * Math.PI * radius) * (delta / (2 * Math.PI));
  return radialLength;
}

/** Calculate tooltip, XYZ, and rotary move lengths. */
function getMoveLength(_x, _y, _z, _a, _b, _c) {
  // get starting and ending positions
  var moveLength = {};
  var startTool;
  var endTool;
  var startXYZ;
  var endXYZ;
  var startABC;
  if (typeof previousABC !== "undefined") {
    startABC = new Vector(previousABC.x, previousABC.y, previousABC.z);
  } else {
    startABC = getCurrentDirection();
  }
  var endABC = new Vector(_a, _b, _c);

  if (!getOptimizedMode()) { // calculate XYZ from tool tip
    startTool = getCurrentPosition();
    endTool = new Vector(_x, _y, _z);
    startXYZ = startTool;
    endXYZ = endTool;

    // adjust points for tables
    if (!machineConfiguration.getTableABC(startABC).isZero() || !machineConfiguration.getTableABC(endABC).isZero()) {
      startXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).getTransposed().multiply(startXYZ);
      endXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).getTransposed().multiply(endXYZ);
    }

    // adjust points for heads
    if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isHead()) {
      if (typeof getOptimizedHeads === "function") { // use post processor function to adjust heads
        startXYZ = getOptimizedHeads(startXYZ.x, startXYZ.y, startXYZ.z, startABC.x, startABC.y, startABC.z);
        endXYZ = getOptimizedHeads(endXYZ.x, endXYZ.y, endXYZ.z, endABC.x, endABC.y, endABC.z);
      } else { // guess at head adjustments
        var startDisplacement = machineConfiguration.getDirection(startABC);
        startDisplacement.multiply(headOffset);
        var endDisplacement = machineConfiguration.getDirection(endABC);
        endDisplacement.multiply(headOffset);
        startXYZ = Vector.sum(startTool, startDisplacement);
        endXYZ = Vector.sum(endTool, endDisplacement);
      }
    }
  } else { // calculate tool tip from XYZ, heads are always programmed in TCP mode, so not handled here
    startXYZ = getCurrentPosition();
    endXYZ = new Vector(_x, _y, _z);
    startTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).multiply(startXYZ);
    endTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).multiply(endXYZ);
  }

  // calculate axes movements
  moveLength.xyz = Vector.diff(endXYZ, startXYZ).abs;
  moveLength.xyzLength = moveLength.xyz.length;
  moveLength.abc = Vector.diff(endABC, startABC).abs;
  for (var i = 0; i < 3; ++i) {
    if (moveLength.abc.getCoordinate(i) > Math.PI) {
      moveLength.abc.setCoordinate(i, 2 * Math.PI - moveLength.abc.getCoordinate(i));
    }
  }
  moveLength.abcLength = moveLength.abc.length;

  // calculate radii
  moveLength.radius = getRotaryRadii(startTool, endTool, startABC, endABC);
  
  // calculate the radial portion of the tool tip movement
  var radialLength = Math.sqrt(
    Math.pow(getRadialDistance(moveLength.radius.x, startABC.x, endABC.x), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.y, startABC.y, endABC.y), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.z, startABC.z, endABC.z), 2.0)
  );

  // calculate the tool tip move length
  // tool tip distance is the move distance based on a combination of linear and rotary axes movement
  moveLength.tool = moveLength.xyzLength + radialLength;

  // debug
  if (false) {
    writeComment("DEBUG - tool   = " + moveLength.tool);
    writeComment("DEBUG - xyz    = " + moveLength.xyz);
    var temp = Vector.product(moveLength.abc, 180 / Math.PI);
    writeComment("DEBUG - abc    = " + temp);
    writeComment("DEBUG - radius = " + moveLength.radius);
  }
  return moveLength;
}
// End of multi-axis feedrate logic

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var toler = (machineState.useXZCMode || machineState.usePolarMode) ? getTolerance() / 2 : getTolerance();
  if (machineState.useXZCMode) {
    switch (getCircularPlane()) {
    case PLANE_ZX:
      if (!isSpiral()) {
        var c = getCClosest(x, y, cOutput.getCurrent());
        if (!cFormat.areDifferent(c, cOutput.getCurrent())) {
          validate(getCircularSweep() < Math.PI, localize("Circular sweep exceeds limit."));
          var start = getCurrentPosition();
          // G18 doesnt print because its default
          writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    case PLANE_XY:
      var d2 = center.x * center.x + center.y * center.y;
      if (d2 < 1e-6) { // center is on rotary axis
        var c = getCWithinRange(x, y, cOutput.getCurrent(), !clockwise);
        if (!forceRewind) {
          var actualFeed = getMultiaxisFeed(x, y, z, 0, 0, c, feed);
          writeBlock(gMotionModal.format(1), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), getFeed(actualFeed.frn));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    }
    
    linearize(toler);
    return;
  }

  if (machineState.usePolarMode && !usePolarCircular) {
    linearize(toler);
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(toler);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      // G18 doesnt print because its default
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(toler);
    }
  } else if (!properties.useRadius) {
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) { // avoid G112 issue
      linearize(toler);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      if (!xFormat.isSignificant(start.x) && machineState.usePolarMode) {
        linearize(toler); // avoid G112 issues
        return;
      }
      writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      // G18 doesnt print because its default
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(toler);
    }
  } else { // use radius mode
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) {
      linearize(toler);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      if (!xFormat.isSignificant(start.x) && machineState.usePolarMode) {
        linearize(toler); // avoid G112 issues
        return;
      }
      writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      // G18 doesnt print because its default
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(toler);
    }
  }
}

function onCycle() {
  if ((typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {

    // ORIGINAL CODE for secondary spindle . delete ?
    // if (!properties.gotSecondarySpindle) {
    //   error(localize("Secondary spindle is not available."));
    //   return;
    // }

    writeln("");
    if (hasParameter("operation-comment")) {
      var comment = getParameter("operation-comment");
      if (comment) {
        writeComment(comment);
      }
    }

    if (!machineState.stockTransferIsActive) {
      setCoolant(COOLANT_OFF);
      writeRetract(currentSection, false); // no retract in Z

      // wcs required here
      currentWorkOffset = undefined;
      writeWCS(currentSection);
    
      // preload next cutting tool
      preloadCutoffTool();
    }

    switch (cycleType) {
    case "secondary-spindle-grab":
      if (cycle.usePartCatcher) {
        engagePartCatcher(true);
      }
      writeBlock(getCode("FEED_MODE_UNIT_MIN")); // mm/rev
      if (cycle.stopSpindle) { // no spindle rotation
        writeBlock(getCode("STOP_SPINDLE"));
      } else { // spindle rotation
        writeBlock(sOutput.format(cycle.spindleSpeed), tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW"));
        writeBlock(pOutput.format(cycle.spindleSpeed), tool.clockwise ? getCode("START_SUB_SPINDLE_CCW") : getCode("START_SUB_SPINDLE_CW")); // inverted
      }
      writeBlock(getCode("SPINDLE_SYNCHRONIZATION_ON"), "R" + abcFormat.format(cycle.spindleOrientation), formatComment("SPINDLE SYNCHRONIZATION ON")); // Sync spindles
      if (properties.airCleanChuck) {
        writeBlock(getCode("MAINSPINDLE_AIR_BLAST_ON"), formatComment("MAINSPINDLE AIR BLAST ON"));
        writeBlock(getCode("SUBSPINDLE_AIR_BLAST_ON"), formatComment("SUBSPINDLE AIR BLAST ON"));
      }
      writeBlock(
        getCode(currentSection.spindle == SPINDLE_PRIMARY ? "UNCLAMP_SECONDARY_CHUCK" : "UNCLAMP_PRIMARY_CHUCK"),
        formatComment(currentSection.spindle == SPINDLE_PRIMARY ? "UNCLAMP SECONDARY CHUCK" : "UNCLAMP PRIMARY CHUCK")
      );
      onDwell(cycle.dwell);
      gMotionModal.reset();
      writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(0), "B" + spatialFormat.format(cycle.feedPosition));
      if (properties.airCleanChuck) {
        writeBlock(getCode("MAINSPINDLE_AIR_BLAST_OFF"), formatComment("MAINSPINDLE AIR BLAST OFF"));
        writeBlock(getCode("SUBSPINDLE_AIR_BLAST_OFF"), formatComment("SUBSPINDLE AIR BLAST OFF"));
      }

      onDwell(cycle.dwell);
      writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(1), "B" + spatialFormat.format(cycle.chuckPosition), getFeed(cycle.feedrate));
      writeBlock(
        getCode(currentSection.spindle == SPINDLE_PRIMARY ? "CLAMP_SECONDARY_CHUCK" : "CLAMP_PRIMARY_CHUCK"),
        formatComment(currentSection.spindle == SPINDLE_PRIMARY ? "CLAMP SECONDARY CHUCK" : "CLAMP PRIMARY CHUCK")
      );
      onDwell(cycle.dwell);
      machineState.stockTransferIsActive = true;
      break;
    case "secondary-spindle-return":
      // determine if pull operation, spindle return, or both
      var secondaryPull = false;
      var secondaryHome = false;

      // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
      var feedDis = 0;
      var feedPosition = cycle.feedPosition;
      if (cycle.useMachineFrame == 1) {
        if (hasParameter("operation:feedPlaneHeight_direct")) { // Inventor
          feedDis = getParameter("operation:feedPlaneHeight_direct");
        } else if (hasParameter("operation:feedPlaneHeightDirect")) { // HSMWorks
          feedDis = getParameter("operation:feedPlaneHeightDirect");
        }
        feedPosition = feedDis;
      } else if (hasParameter("operation:feedPlaneHeight_offset")) { // Inventor
        feedDis = getParameter("operation:feedPlaneHeight_offset");
      } else if (hasParameter("operation:feedPlaneHeightOffset")) { // HSMWorks
        feedDis = getParameter("operation:feedPlaneHeightOffset");
      }
      // Transfer part to secondary spindle
      if (cycle.unclampMode != "keep-clamped") {
        secondaryPull = feedDis != 0;
        secondaryHome = true;
      } else {
        // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
        secondaryPull = feedDis != 0;
        secondaryHome = !secondaryPull;
      }

      if (!machineState.stockTransferIsActive) {
        writeBlock(getCode("FEED_MODE_UNIT_REV")); // mm/rev
        if (cycle.stopSpindle) { // no spindle rotation
          writeBlock(getCode("STOP_SPINDLE"));
        } else { // spindle rotation
          writeBlock(sOutput.format(cycle.spindleSpeed), tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW"));
          writeBlock(pOutput.format(cycle.spindleSpeed), tool.clockwise ? getCode("START_SUB_SPINDLE_CCW") : getCode("START_SUB_SPINDLE_CW")); // inverted
        }
        writeBlock(getCode("SPINDLE_SYNCHRONIZATION_ON"), formatComment("SPINDLE SYNCHRONIZATION ON")); // Sync spindles
      }

      if (secondaryPull) {
        writeBlock(getCode("UNCLAMP_PRIMARY_CHUCK"), formatComment("UNCLAMP PRIMARY CHUCK"));
        onDwell(cycle.dwell);
        writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(1), "B" + spatialFormat.format(cycle.feedPosition), getFeed(cycle.feedrate));
      }
      if (secondaryHome) {
        setCoolant(COOLANT_OFF);
        if (cycle.unclampMode == "unclamp-secondary") { // leave part in main spindle
          writeBlock(getCode("CLAMP_PRIMARY_CHUCK"), formatComment("CLAMP PRIMARY CHUCK"));
          onDwell(cycle.dwell);
          writeBlock(getCode("UNCLAMP_SECONDARY_CHUCK"), formatComment("UNCLAMP SECONDARY CHUCK"));
          onDwell(cycle.dwell);
        } else if (cycle.unclampMode == "unclamp-primary") {
          if (!secondaryPull) {
            writeBlock(getCode("UNCLAMP_PRIMARY_CHUCK"), formatComment("UNCLAMP PRIMARY CHUCK"));
            onDwell(cycle.dwell);
          }
        }
        writeBlock(gMotionModal.format(0), gFormat.format(53), "B" + spatialFormat.format(properties.g53WorkPositionSub));
        if (machineState.spindleSynchronizationIsActive) { // spindles are synchronized
          writeBlock(getCode("SPINDLE_SYNCHRONIZATION_OFF"), formatComment("SPINDLE SYNCHRONIZATION OFF")); // disable spindle sync
        }
      } else {
        writeBlock(getCode("CLAMP_PRIMARY_CHUCK"), formatComment("CLAMP PRIMARY CHUCK"));
        onDwell(cycle.dwell);
      }
      machineState.stockTransferIsActive = true;
      break;
    }
  }
}

var saveShowSequenceNumbers = true;
var xyzFormat = createFormat({decimals:(unit == MM ? 4 : 5), forceDecimal:true});
var pathBlockNumber = {start: 0, end: 0};
var isCannedCycle = false;

function onCyclePath() {
  saveShowSequenceNumbers = properties.showSequenceNumbers;
  isCannedCycle = true;
  // buffer all paths and stop feeds being output
  feedOutput.disable();
  properties.showSequenceNumbers = false;
  redirectToBuffer();
  gMotionModal.reset();
  if ((hasParameter("operation:grooving") && getParameter("operation:grooving").toUpperCase() != "OFF")) {
    xOutput.reset();
    zOutput.reset();
  }
}

function onCyclePathEnd() {
  properties.showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  feedOutput.enable();
  var cyclePath = String(getRedirectionBuffer()).split(EOL); // get cycle path from buffer
  closeRedirection();
  for (line in cyclePath) { // remove empty elements
    if (cyclePath[line] == "") {
      cyclePath.splice(line);
    }
  }

  var verticalPasses;
  if (cycle.profileRoughingCycle == 0) {
    verticalPasses = false;
  } else if (cycle.profileRoughingCycle == 1) {
    verticalPasses = true;
  } else {
    error(localize("Unsupported passes type."));
    return;
  }
  // output cycle data
  switch (cycleType) {
  case "turning-canned-rough":
    writeBlock(gFormat.format(verticalPasses ? 72 : 71),
      "P" + (getStartEndSequenceNumber(cyclePath, true)),
      "Q" + (getStartEndSequenceNumber(cyclePath, false)),
      "U" + xFormat.format(cycle.xStockToLeave),
      "W" + xyzFormat.format(cycle.zStockToLeave),
      "D" + xyzFormat.format(cycle.depthOfCut),
      getFeed(cycle.cutfeedrate)
    );
    break;
  default:
    error(localize("Unsupported turning canned cycle."));
  }
  
  for (var i = 0; i < cyclePath.length; ++i) {
    //Original code
    // if (i == 0 || i == (cyclePath.length - 1)) { // write sequence number on first and last line of the cycle path
      // properties.showSequenceNumbers = true;
      // if ((i == 0 && pathBlockNumber.start != sequenceNumber) || (i == (cyclePath.length - 1) && pathBlockNumber.end != sequenceNumber)) {
      //   error(localize("Mismatch of start/end block number in turning canned cycle."));
      //   return;
      // }
    // }

    //Modified code
    if (i == 0) {
      writeBlock("N" + SEQUENCE_NUMBER_START * 10);
    }

    //Original code
    writeBlock(cyclePath[i]); // output cycle path
    // properties.showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state

    //Modified code
    if (i == cyclePath.length - 1) {
      writeBlock("N" + ((SEQUENCE_NUMBER_START * 10) + (SEQUENCE_NUMBER_INCREMENT * 10)));
    }

    //Original code
    isCannedCycle = false;
  }
}

function getStartEndSequenceNumber(cyclePath, start) {
  if (start) {
    //Original code
    // pathBlockNumber.start = sequenceNumber + conditional(saveShowSequenceNumbers, properties.sequenceNumberIncrement);
    //Modified code
    pathBlockNumber.start = SEQUENCE_NUMBER_START * 10;
    return pathBlockNumber.start;
  } else {
    //Original code
    //pathBlockNumber.end = sequenceNumber + properties.sequenceNumberIncrement + conditional(saveShowSequenceNumbers, (cyclePath.length - 1) * properties.sequenceNumberIncrement);
    //Modified code
    pathBlockNumber.end = SEQUENCE_NUMBER_START * 10 + SEQUENCE_NUMBER_INCREMENT * 10;

    return pathBlockNumber.end;
  }
}

function getCommonCycle(x, y, z, r) {
  // forceXYZ(); // force xyz on first drill hole of any cycle
  if (machineState.useXZCMode) {
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(getCWithinRange(x, y, cOutput.getCurrent())),
      zOutput.format(z),
      (r !== undefined) ? ("R" + spatialFormat.format((gPlaneModal.getCurrent() == 19) ? r * 2 : r)) : ""];
  } else {
    return [xOutput.format(x), yOutput.format(y),
      zOutput.format(z),
      (r !== undefined) ? ("R" + spatialFormat.format((gPlaneModal.getCurrent() == 19) ? r * 2 : r)) : ""];
  }
}

function writeCycleClearance() {
  if (true) {
    switch (gPlaneModal.getCurrent()) {
    case 18:
      writeBlock(gMotionModal.format(0), zOutput.format(cycle.clearance));
      break;
    case 19:
      writeBlock(gMotionModal.format(0), xOutput.format(cycle.clearance));
      break;
    default:
      //dont bring error if drilling in G17
      // error(localize("Unsupported drilling orientation."));
      return;
    }
  }
}

var threadStart;
var threadEnd;
function moveToThreadStart(x, y, z) {
  var cuttingAngle = 0;
  if (hasParameter("operation:infeedAngle")) {
    cuttingAngle = getParameter("operation:infeedAngle");
  }
  if (cuttingAngle != 0) {
    var zz;
    if (isFirstCyclePoint()) {
      threadStart = getCurrentPosition();
      threadEnd = new Vector(x, y, z);
    } else {
      var zz = threadStart.z - (Math.abs(threadEnd.x - x) * Math.tan(toRad(cuttingAngle)));
      writeBlock(gMotionModal.format(0), zOutput.format(zz));
      threadStart.setZ(zz);
      threadEnd = new Vector(x, y, z);
    }
  }
}

function onCyclePoint(x, y, z) {

  if (!properties.useCycles || currentSection.isMultiAxis() || getMachiningDirection(currentSection) == MACHINING_DIRECTION_INDEXING) {
    expandCyclePoint(x, y, z);
    return;
  }

  // ORIGINAL CODE printed multiple times G17/G18/G19 plane
  // writeBlock(gPlaneModal.format(getPlane()));

  var gCycleTapping;
  switch (cycleType) {
  case "tapping-with-chip-breaking":
  case "right-tapping":
  case "left-tapping":
  case "tapping":
    if (gPlaneModal.getCurrent() == 19) { // radial
      if (tool.type == TOOL_TAP_LEFT_HAND) {
        gCycleTapping = 196;
      } else {
        gCycleTapping = 195;
      }
    } else { // axial
        if (tool.type == TOOL_TAP_LEFT_HAND ) {
      //check that tool is in center or not and is center drilling or not
        gCycleTapping = machineState.axialCenterDrilling || isToolInCenterX0() ? 184 : 186;
      } else {
        gCycleTapping = machineState.axialCenterDrilling || isToolInCenterX0() ? 84 : 95;
      }
    }
    break;
  }

  switch (cycleType) {
  case "thread-turning":
    if (properties.useSimpleThread ||
          (hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0)) ||
          (hasParameter("operation:infeedMode") && (getParameter("operation:infeedMode") != "constant"))) {
      var i = -cycle.incrementalX; // positive if taper goes down - delta radius
      moveToThreadStart(x, y, z);
      xOutput.reset();
      zOutput.reset();
      writeBlock(
        gMotionModal.format(92),
        xOutput.format(x - cycle.incrementalX),
        yOutput.format(y),
        zOutput.format(z),
        conditional(zFormat.isSignificant(i), g76IOutput.format(i)),
        pitchOutput.format(cycle.pitch)
      );
    } else {
      if (isLastCyclePoint()) {
        // thread height and depth of cut
        var threadHeight = getParameter("operation:threadDepth");
        var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");
        var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 0;
        var cuttingAngle = 59; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
        if (hasParameter("operation:infeedAngle")) {
          cuttingAngle = getParameter("operation:infeedAngle") * 2;
        }
        var i = -cycle.incrementalX; // positive if taper goes down - delta radius
        gCycleModal.reset();
            
        // threading cycle
        writeBlock(
          gCycleModal.format(76),
          xOutput.format(x - cycle.incrementalX),
          zOutput.format(z),
          g76KOutput.format(threadHeight),
          g76DOutput.format(firstDepthOfCut),
          g76AOutput.format(cuttingAngle),
          // "P2" // P1 = Single edge-cutting constant, P2 = Double edge-cutting constant, P3 = Single-depth constant, P4 = Double-depth constant
          pitchOutput.format(cycle.pitch)
        );
      }
    }
    gMotionModal.reset();
    forceFeed();
    return;
  }
  if (true) {
    if (gPlaneModal.getCurrent() == 17) {
      error(localize("Drilling in G17 is not supported."));
      return;
    }
    // repositionToCycleClearance(cycle, x, y, z);
    // return to initial Z which is clearance plane and set absolute mode
    feedOutput.reset();

    var F = (machineState.feedPerRevolution ? cycle.feedrate / spindleSpeed : cycle.feedrate);
    var P = (cycle.dwell == 0) ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "drilling":
      forceXYZ();
      writeCycleClearance();
      writeBlock(
        gCycleModal.format(gPlaneModal.getCurrent() == 19 ? 241 : 81),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F)
      );
      break;
    case "counter-boring":
      writeCycleClearance();
      forceXYZ();
      if (P > 0) {
        writeBlock(
          gCycleModal.format(gPlaneModal.getCurrent() == 19 ? 242 : 82),
          getCommonCycle(x, y, z, cycle.retract),
          "P" + milliFormat.format(P),
          feedOutput.format(F)
        );
      } else {
        writeBlock(
          gCycleModal.format(gPlaneModal.getCurrent() == 19 ? 241 : 81),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
      }
      break;
    case "chip-breaking":
    case "deep-drilling":
      if (cycleType == "chip-breaking" && (cycle.accumulatedDepth < cycle.depth)) {
        expandCyclePoint(x, y, z);
        return;
      } else {
        writeCycleClearance();
        forceXYZ();
        writeBlock(
          gCycleModal.format(gPlaneModal.getCurrent() == 19 ? 243 : 83),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + spatialFormat.format(cycle.incrementalDepth), // lathe prefers single Q peck value, IJK causes error
          // "I" + spatialFormat.format(cycle.incrementalDepth),
          // "J" + spatialFormat.format(cycle.incrementalDepthReduction),
          // "K" + spatialFormat.format(cycle.minimumIncrementalDepth),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
      }
      break;
    case "tapping":
      writeCycleClearance();
      if (gPlaneModal.getCurrent() == 19) {
        xOutput.reset();
        writeBlock(gMotionModal.format(0), zOutput.format(z), yOutput.format(y));
        writeBlock(gMotionModal.format(0), xOutput.format(cycle.retract));
        writeBlock(
          gCycleModal.format(gCycleTapping),
          getCommonCycle(x, y, z, undefined),
          pitchOutput.format(F)
        );
      } else {
        forceXYZ();
        //axial G95 needs S before G95
        writeBlock(sOutput.format(spindleSpeed));
        writeBlock(
          gCycleModal.format(gCycleTapping),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(F)
        );
      }
      forceFeed();
      break;
    case "left-tapping":
      writeCycleClearance();
      xOutput.reset();
      if (gPlaneModal.getCurrent() == 19) {
        writeBlock(gMotionModal.format(0), zOutput.format(z), yOutput.format(y));
        writeBlock(gMotionModal.format(0), xOutput.format(cycle.retract));
      }
      //axial G95 needs S before G95
      writeBlock(sOutput.format(spindleSpeed));
      writeBlock(
        gCycleModal.format(gCycleTapping),
        getCommonCycle(x, y, z, (gPlaneModal.getCurrent() == 19) ? undefined : cycle.retract),
        pitchOutput.format(F)
      );
      forceFeed();
      break;
    case "right-tapping":
      writeCycleClearance();
      xOutput.reset();
      if (gPlaneModal.getCurrent() == 19) {
        writeBlock(gMotionModal.format(0), zOutput.format(z), yOutput.format(y));
        writeBlock(gMotionModal.format(0), xOutput.format(cycle.retract));
      }
      //axial G95 needs S before G95
      writeBlock(sOutput.format(spindleSpeed));
      writeBlock(
        gCycleModal.format(gCycleTapping),
        getCommonCycle(x, y, z, (gPlaneModal.getCurrent() == 19) ? undefined : cycle.retract),
        pitchOutput.format(F)
      );
      forceFeed();
      break;
    case "tapping-with-chip-breaking":
      writeCycleClearance();
      xOutput.reset();
      if (gPlaneModal.getCurrent() == 19) {
        writeBlock(gMotionModal.format(0), zOutput.format(z), yOutput.format(y));
        writeBlock(gMotionModal.format(0), xOutput.format(cycle.retract));
      }
      //axial G95 needs S before G95
      writeBlock(sOutput.format(spindleSpeed));

      // Parameter 57 bit 6, REPT RIG TAP, is set to 1 (On)
      // On Mill software versions12.09 and above, REPT RIG TAP has been moved from the Parameters to Setting 133
      warningOnce(localize("For tapping with chip breaking make sure REPT RIG TAP (Setting 133) is enabled on your Haas."), WARNING_REPEAT_TAPPING);

      var u = cycle.stock;
      var step = cycle.incrementalDepth;
      var first = true;

      while (u > cycle.bottom) {
        if (step < cycle.minimumIncrementalDepth) {
          step = cycle.minimumIncrementalDepth;
        }
        u -= step;
        step -= cycle.incrementalDepthReduction;
        gCycleModal.reset(); // required
        u = Math.max(u, cycle.bottom);
        if (first) {
          first = false;
          writeBlock(
            gCycleModal.format(gCycleTapping),
            getCommonCycle((gPlaneModal.getCurrent() == 19) ? u : x, y, (gPlaneModal.getCurrent() == 19) ? z : u, (gPlaneModal.getCurrent() == 19) ? undefined : cycle.retract),
            pitchOutput.format(F)
          );
        } else {
          writeBlock(
            gCycleModal.format(gCycleTapping),
            conditional(gPlaneModal.getCurrent() == 18, "Z" + spatialFormat.format(u)),
            conditional(gPlaneModal.getCurrent() == 19, "X" + xFormat.format(u)),
            pitchOutput.format(F)
          );
        }
      }
      forceFeed();
      break;
    case "fine-boring":
      expandCyclePoint(x, y, z);
      break;
    case "reaming":
      if (gPlaneModal.getCurrent() == 19) {
        expandCyclePoint(x, y, z);
      } else {
        writeCycleClearance();
        forceXYZ();
        writeBlock(
          gCycleModal.format(85),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
      }
      break;
    case "stop-boring":
      if (P > 0) {
        expandCyclePoint(x, y, z);
      } else {
        writeCycleClearance();
        forceXYZ();
        writeBlock(
          gCycleModal.format((gPlaneModal.getCurrent() == 19) ? 246 : 86),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
      }
      break;
    case "boring":
      if (P > 0) {
        expandCyclePoint(x, y, z);
      } else {
        writeCycleClearance();
        forceXYZ();
        writeBlock(
          gCycleModal.format((gPlaneModal.getCurrent() == 19) ? 245 : 85),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
      }
      break;
    default:
      expandCyclePoint(x, y, z);
    }
    if (!cycleExpanded) {
      writeBlock(gCycleModal.format(80));
      gMotionModal.reset();
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else if (machineState.useXZCMode) {
      var _x = xOutput.format(getModulus(x, y));
      var _c = cOutput.format(getCWithinRange(x, y, cOutput.getCurrent()));
      if (!_x /*&& !_y*/ && !_c) {
        xOutput.reset(); // at least one axis is required
        _x = xOutput.format(getModulus(x, y));
      }
      writeBlock(_x, _c);
    } else {
      var _x = xOutput.format(x);
      var _y = yOutput.format(y);
      var _z = zOutput.format(z);
      if (!_x && !_y && !_z) {
        switch (gPlaneModal.getCurrent()) {
        case 18: // ZX
          xOutput.reset(); // at least one axis is required
          yOutput.reset(); // at least one axis is required
          _x = xOutput.format(x);
          _y = yOutput.format(y);
          break;
        case 19: // YZ
          yOutput.reset(); // at least one axis is required
          zOutput.reset(); // at least one axis is required
          _y = yOutput.format(y);
          _z = zOutput.format(z);
          break;
        }
      }
      writeBlock(_x, _y, _z);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded && !machineState.stockTransferIsActive && (typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {
    switch (cycleType) {
    case "thread-turning":
      forceFeed();
      xOutput.reset();
      zOutput.reset();
      g76IOutput.reset();
      break;
    default:
      writeBlock(gCycleModal.format(80));
      gMotionModal.reset();
    }
  }
}

function onPassThrough(text) {
  writeBlock(text);
}

function onParameter(name, value) {
  if (name == "action") {
    if (String(value).toUpperCase() == "USEPOLARMODE") {
      forcePolarMode = true;
    } else if (String(value).toUpperCase() == "PARTEJECT") {
      ejectRoutine = true;
    }
  }
}

var currentCoolantMode = COOLANT_OFF;

function setCoolant(coolant) {
  var optionalCoolant = false;
  if (coolant == currentCoolantMode) {
    if (operationNeedsSafeStart) {
      optionalCoolant = true;
    } else {
      return; // coolant is already active
    }
  }

  var m = undefined;
  if (coolant == COOLANT_OFF) {
    if (currentCoolantMode == COOLANT_THROUGH_TOOL) {
      skipBlock = optionalCoolant;
      writeBlock(getCode("COOLANT_THROUGH_TOOL_OFF"));
    } else if (currentCoolantMode == COOLANT_AIR) {
      skipBlock = optionalCoolant;
      writeBlock(getCode("COOLANT_AIR_OFF"));
    } else {
      skipBlock = optionalCoolant;
      writeBlock(getCode("COOLANT_OFF"));
    }
    currentCoolantMode = COOLANT_OFF;
    return;
  }

  switch (coolant) {
  case COOLANT_FLOOD:
    m = getCode("COOLANT_FLOOD_ON");
    break;
  case COOLANT_THROUGH_TOOL:
    m = getCode("COOLANT_THROUGH_TOOL_ON");
    break;
  case COOLANT_AIR:
    m = getCode("COOLANT_AIR_ON");
    break;
  default:
    onUnsupportedCoolant(coolant);
    m = getCode("COOLANT_OFF");
  }
  
  //M8 WITH BLOCK DELETE
  if (m) {
    // Добавляем символ / перед командой M8
    if (m == mFormat.format(8)) {
      skipBlock = true;
      writeBlock(m);
    } else {
      skipBlock = optionalCoolant;
      writeBlock(m);
    }
    currentCoolantMode = coolant;
  }
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    break;
  case COMMAND_COOLANT_ON:
    setCoolant(tool.coolant);
    break;
  case COMMAND_START_SPINDLE:
    if (machineState.isTurningOperation || machineState.axialCenterDrilling || isToolInCenterX0()) {
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        writeBlock(tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW"));
      } else {
        writeBlock(tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW"));
      }
    } else {

      // TODO: ADD HERE CHECK FOR RADIAL TOOL
      writeBlock(tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
    }
    break;
  case COMMAND_STOP_SPINDLE:
    if (properties.useSSV) {
      writeBlock(ssvModal.format(39));
    }
    writeBlock(getCode("STOP_SPINDLE"));
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    writeBlock(getCode((currentSection.spindle == SPINDLE_PRIMARY) ? "MAIN_SPINDLE_BRAKE_ON" : "SUB_SPINDLE_BRAKE_ON"));
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    writeBlock(getCode((currentSection.spindle == SPINDLE_PRIMARY) ? "MAIN_SPINDLE_BRAKE_OFF" : "SUB_SPINDLE_BRAKE_OFF"));
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    writeBlock(getCode("START_CHIP_TRANSPORT"));
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    writeBlock(getCode("STOP_CHIP_TRANSPORT"));
    break;
  case COMMAND_OPEN_DOOR:
    if (gotDoorControl) {
      writeBlock(getCode("OPEN_DOOR")); // optional
    }
    break;
  case COMMAND_CLOSE_DOOR:
    if (gotDoorControl) {
      writeBlock(getCode("CLOSE_DOOR")); // optional
    }
    break;
  case COMMAND_BREAK_CONTROL:
    break;
  case COMMAND_TOOL_MEASURE:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    if (!skipBlock) {
      forceSpindleSpeed = true;
      currentCoolantMode = undefined;
    }
    writeBlock(mFormat.format(0));
    break;
  case COMMAND_OPTIONAL_STOP:
    if (!skipBlock) {
      forceSpindleSpeed = true;
      currentCoolantMode = undefined;
    }
    writeBlock(mFormat.format(1));
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_ORIENTATE_SPINDLE:
    if (machineState.isTurningOperation) {
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        writeBlock(mFormat.format(19)); // use P or R to set angle (optional)
      } else {
        writeBlock(mFormat.format(119));
      }
    } else {
      if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        writeBlock(mFormat.format(19)); // use P or R to set angle (optional)
      } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
        writeBlock(mFormat.format(119));
      } else {
        error(localize("Spindle orientation is not supported for live tooling."));
        return;
      }
    }
    break;
  // case COMMAND_CLAMP: // add support for clamping
  // case COMMAND_UNCLAMP: // add support for clamping
  default:
    onUnsupportedCommand(command);
  }
}

/** Preload cutoff tool prior to spindle transfer/cutoff. */
var prePositionCutoffTool = true;
function preloadCutoffTool() {
  if (isLastSection()) {
    return;
  }
  var numberOfSections = getNumberOfSections();
  for (var i = getNextSection().getId(); i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getParameter("operation-strategy") == "turningSecondarySpindleReturn") {
      continue;
    } else if (section.getType() != TYPE_TURNING || section.spindle != SPINDLE_PRIMARY) {
      break;
    } else if (section.getParameter("operation-strategy") == "turningPart") {
      var tool = section.getTool();
      var compensationOffset = tool.compensationOffset;
      writeBlock("T" + toolFormat.format(tool.number * 100 + compensationOffset));
      if (prePositionCutoffTool) {
        var initialPosition = getFramePosition(section.getInitialPosition());
        writeBlock(zOutput.format(initialPosition.z));
      }
      break;
    }
  }
  return;
}

function engagePartCatcher(engage) {
  if (engage) {
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    if (gotYAxis) {
      writeBlock(gFormat.format(53), gMotionModal.format(0), "Y" + yFormat.format(properties.g53HomePositionY)); // retract
      yOutput.reset();
    }
    writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract
    writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format(currentSection.spindle == SPINDLE_SECONDARY ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}

function ejectPart() {
  writeln("");
  writeComment(localize("PART EJECT"));

  gMotionModal.reset();
  //writeBlock(gFormat.format(330)); // retract bar feeder
  //goHome(); // Position all axes to home position

  if (gotYAxis) {
    writeBlock(gFormat.format(53), gMotionModal.format(0), "Y" + yFormat.format(properties.g53HomePositionY)); // retract
    yOutput.reset();
  }
  writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract
  writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format(currentSection.spindle == SPINDLE_SECONDARY ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract
 
  onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  if (!properties.optimizeCaxisSelect) {
    cAxisEngageModal.reset();
  }
  writeBlock(
    getCode("FEED_MODE_UNIT_MIN"),
    gPlaneModal.format(17),
    getCode("DISENGAGE_C_AXIS")
  );
  // setCoolant(COOLANT_THROUGH_TOOL);
  gSpindleModeModal.reset();
  writeBlock(
    getCode("CONSTANT_SURFACE_SPEED_OFF"),
    sOutput.format(50),
    getCode(currentSection.spindle == SPINDLE_SECONDARY ? "START_SUB_SPINDLE_CW" : "START_MAIN_SPINDLE_CW")
  );
  // writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSpindle(true))));
  writeBlock(getCode("PART_CATCHER_ON"));
  writeBlock(getCode(currentSection.spindle == SPINDLE_SECONDARY ? "UNCLAMP_SECONDARY_CHUCK" : "UNCLAMP_PRIMARY_CHUCK"));
  onDwell(1.5);
  // writeBlock(mFormat.format(getCode("CYCLE_PART_EJECTOR")));
  // onDwell(0.5);
  writeBlock(getCode("PART_CATCHER_OFF"));
  onDwell(1.1);
  
  // clean out chips
  if (properties.airCleanChuck) {
    writeBlock(getCode(currentSection.spindle == SPINDLE_SECONDARY ? "SUBSPINDLE_AIR_BLAST_ON" : "MAINSPINDLE_AIR_BLAST_ON"),
      formatComment("AIR BLAST ON"));
    onDwell(2.5);
    writeBlock(getCode(currentSection.spindle == SPINDLE_SECONDARY ? "SUBSPINDLE_AIR_BLAST_OFF" : "MAINSPINDLE_AIR_BLAST_OFF"),
      formatComment("AIR BLAST OFF"));
  }
  writeBlock(getCode("STOP_SPINDLE"));
  setCoolant(COOLANT_OFF);
  writeComment(localize("END OF PART EJECT"));
  writeln("");
}

function onSectionEnd() {

  if (currentSection.partCatcher) {
    engagePartCatcher(false);
  }

  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }

  // CUSTOM CODE STOP SPINDLE M5 , M135 , M145

  if ((currentSection.getType() == TYPE_MILLING && currentSection.feedMode == FEED_PER_MINUTE || machineState.tapping || machineState.axialCenterDrilling) && !isToolInCenterX0()) {
    writeBlock(mFormat.format(135))
  } else if (currentSection.getType() == TYPE_TURNING || isToolInCenterX0()) {  // for turning operations or tool in x0
    writeBlock(mFormat.format(5));
  } else if (machineState.subSpindleIsActive) {
    writeBlock(mFormat.format(145));
  } else {
    writeBlock("undefined tool");
  }

  // ORIGINAL
  // // cancel SFM mode to preserve spindle speed
  // if ((tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) && !machineState.stockTransferIsActive) {
  //   startSpindle(true, getFramePosition(currentSection.getFinalPosition()));
  // }

  if (properties.useG61) {
    writeBlock(gExactStopModal.format(64));
  }

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if ((currentSection.getType() == TYPE_MILLING) &&
      (!hasNextSection() || (hasNextSection() && (getNextSection().getType() != TYPE_MILLING)))) {
    // exit milling mode
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      // +Z
    } else {
      writeBlock(getCode("STOP_SPINDLE"));
    }

    // CUSTOM CODE M155 disangage c-axis
    writeBlock(mFormat.format(155));
  }
  
  if (machineState.cAxisIsEngaged && !properties.optimizeCAxisSelect) {
    writeBlock(getCode("DISENGAGE_C_AXIS")); // used for c-axis encoder reset
    forceWorkPlane(); // needed since re-engage would result in undefined c-axis position
  }
  
  // Проверяем, является ли инструмент живым
  if (currentSection.getType() == TYPE_MILLING) {
    writeBlock(getCode("DISENGAGE_C_AXIS")); // Отключаем C-ось для живого инструмента
  }

  // Отключаем шпиндель
  // writeBlock(getCode("STOP_SPINDLE"));
  // Выключаем СОЖ
  onCommand(COMMAND_COOLANT_OFF);

  // Определяем тип инструмента (живой или токарный)
  var isSectionMilling = currentSection.getType() == TYPE_MILLING;


  // Feed mode switch only for live tool or taping
  gFeedModeModal.reset();
  if (isSectionMilling || machineState.tapping) {
    writeBlock(getCode("FEED_MODE_UNIT_REV")); // unit/rev G99
  }
  

  
  // Возвращаем оси в зависимости от типа инструмента
  if (hasNextSection()) {
    writeln("");
    if (isSectionMilling && !isToolInCenterX0()) {
      // Для active tool возвращаем все оси Y, X, Z
      if (gotYAxis) {
        writeBlock(gFormat.format(53), gMotionModal.format(0), "Y" + yFormat.format(properties.g53HomePositionY)); // retract Y first
      }
      writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract X
      writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format((currentSection.spindle == SPINDLE_SECONDARY) ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract Z
    } else {
      // Для обычного токарного инструмента возвращаем только оси X и Z
      writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract X
      writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format(currentSection.spindle == SPINDLE_SECONDARY ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract Z
    }
    
    // Добавляем опциональную остановку M1 в конце каждой операции
    writeBlock(mFormat.format(1));
  }
  
  // Сбрасываем состояния для следующей операции
  forceAny();
  forcePolarMode = false;
  partCutoff = false;


  writeln("");

}

function onClose() {
  writeln("");

  // Отключаем шпиндель
  // writeBlock(getCode("STOP_SPINDLE"));
  // Выключаем СОЖ
  onCommand(COMMAND_COOLANT_OFF);

  // Режим подачи (G98/G99) выводим только для живого инструмента
  gFeedModeModal.reset();
  if (currentSection.getType() == TYPE_MILLING) { // Только для фрезерных операций (живой инструмент)
    if ((currentSection.feedMode == FEED_PER_REVOLUTION) || machineState.tapping || machineState.axialCenterDrilling) {
      writeBlock(getCode("FEED_MODE_UNIT_MIN")); // unit/min
    } else {
      writeBlock(getCode("FEED_MODE_UNIT_REV")); // unit/rev
    }
  }
  // Для токарных операций не выводим режим подачи, так как он уже подразумевается

  optionalSection = false;


  if (properties.gotChipConveyor) {
    onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  }

  if (getNumberOfSections() > 0) {
    var section = getSection(getNumberOfSections() - 1);
    var isLiveTool = (section.getType() != TYPE_TURNING);
    
    // Финальный возврат в домашнюю позицию выполняется только один раз
    if (isLiveTool) {
      // Для живого инструмента возвращаем все оси Y, X, Z
      if (gotYAxis) {
        writeBlock(gFormat.format(53), gMotionModal.format(0), "Y" + yFormat.format(properties.g53HomePositionY)); // retract Y first
      }
      writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract X
      writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format((section.spindle == SPINDLE_SECONDARY) ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract Z
    } else {
      // Для обычного токарного инструмента возвращаем только оси X и Z
      writeBlock(gFormat.format(53), gMotionModal.format(0), "X" + xFormat.format(properties.g53HomePositionX)); // retract X
      writeBlock(gFormat.format(53), gMotionModal.format(0), "Z" + zFormat.format(section.spindle == SPINDLE_SECONDARY ? properties.g53HomePositionSubZ : properties.g53HomePositionZ)); // retract Z
    }
    
    // Сбрасываем выходы
    xOutput.reset();
    if (gotYAxis) {
      yOutput.reset();
    }
    zOutput.reset();
    
  }

  if (machineState.tailstockIsActive) {
    writeBlock(getCode("TAILSTOCK_OFF"));
  }

  gMotionModal.reset();
  if (!properties.optimizeCAxisSelect) {
    cAxisEngageModal.reset();
  }
  writeBlock(getCode("DISENGAGE_C_AXIS"));

  if (ejectRoutine) {
    ejectPart();
  }

  if (properties.useBarFeeder) {
    writeln("");
    writeComment(localize("Bar feed"));
    writeBlock(gFormat.format(105));
  }

  writeln("");
  onImpliedCommand(COMMAND_END);

  // ORIGINAL
  // onImpliedCommand(COMMAND_STOP_SPINDLE);

  if (properties.looping) {
    writeBlock(mFormat.format(99));
  } else if (true /*!properties.useM97*/) {
    writeBlock(mFormat.format(properties.useBarFeeder ? 99 : 30)); // stop program, spindle stop, coolant off
  } else {
    writeBlock(mFormat.format(99));
  }
  writeln("%");
}
// <<<<< INCLUDED FROM ../common/haas lathe.cps

properties.maximumSpindleSpeed = 2500;

