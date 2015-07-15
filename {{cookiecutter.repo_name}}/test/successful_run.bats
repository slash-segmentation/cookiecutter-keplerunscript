#!/usr/bin/env bats


# 
# Load the helper functions in test_helper.bash 
# Note the .bash suffix is omitted intentionally
# 
load test_helper

#
# Test to run is denoted with at symbol test like below
# the string after is the test name and will be displayed
# when the test is run
#
# This test is as the test name states a check when everythin
# is peachy.
#
@test "Test workflow where everything succeeds." {

  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  # Run kepler.sh
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -exampleText "hello world" -CWS_outputdir $THE_TMP -maxRetry 1 -sleepCmd /bin/true $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # will only see this if kepler fails
  echoArray "${lines[@]}"
  

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  # Will be output if anything below fails
  cat "$THE_TMP/$README_TXT"

  # Verify we did not get a WORKFLOW.FAILED.txt file
  [ ! -e "$THE_TMP/$WORKFLOW_FAILED_TXT" ]

  # Verify we got a README.txt
  [ -s "$THE_TMP/$README_TXT" ]

  # Check read me header
  run cat "$THE_TMP/$README_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "{{cookiecutter.project_name}}" ]
  [ "${lines[1]}" == "Job Name: jname" ]
  [ "${lines[2]}" == "User: joe" ]
  [ "${lines[3]}" == "Workflow Job Id: 123" ]

  # Check we got hello world output
  run egrep "^hello world" "$THE_TMP/$README_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "hello world" ]
  
  # Check we got a workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]
  
  # Check we got done phase
  run egrep "^phase=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "phase=Done" ]

  # Check we got correct phase help
  run egrep "^phase.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "phase.help=Job has finished running" ]

  # Check phase list is correct
  run egrep "^phase.list=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "phase.list=Start,Done" ]

  # Check phase list help is correct
  run egrep "^phase.list.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "phase.list.help=Denotes the various steps or phases in running the workflow" ]

  # Check estimated disk space is correct
  run egrep "^estimated.total.diskspace=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.total.diskspace=0" ]

  # Check estimated disk space help is correct
  run egrep "^estimated.total.diskspace.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.total.diskspace.help=Estimate of disk space consumed in bytes" ]


  # Check disk space is correct
  run egrep "^diskspace.consumed=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "diskspace.consumed=0" ]

  # Check disk space help is correct
  run egrep "^diskspace.consumed.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "diskspace.consumed.help=Disk space in bytes" ]

  # Check estimated walltime
  run egrep "^estimated.walltime.seconds=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.walltime.seconds=0" ]

  # Check estimated walltime help
  run egrep "^estimated.walltime.seconds.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.walltime.seconds.help=Estimated wall time the workflow will take to run" ]

  # Check estimated total cpu
  run egrep "^estimated.total.cpu.seconds=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.total.cpu.seconds=0" ]

  # Check estimated walltime help
  run egrep "^estimated.total.cpu.seconds.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "estimated.total.cpu.seconds.help=Estimated total cpu time workflow will consume" ]


  # Check cpu per cluster
  run egrep "^cpu.seconds.consumed.per.cluster.list=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "cpu.seconds.consumed.per.cluster.list=unknown:0" ]

  # Check estimated walltime help
  run egrep "^cpu.seconds.consumed.per.cluster.list.help=" "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "cpu.seconds.consumed.per.cluster.list.help=Cpu consumed by cluster" ]

}
 
