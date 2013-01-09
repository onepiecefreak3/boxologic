#!/usr/bin/env bash
BOXOLOGIC_BIN=boxologic
TEST_DIR=test
KNOWN_GOOD_DIR=$TEST_DIR/known-good-results
START_FINGERPRINT='TOTAL NUMBER OF BOXES'
NUM_LINES_OF_CONTEXT=6

# Check for the binary
if [ ! -e $BOXOLOGIC_BIN ]; then
  echo "Boxologic binary not found. Perhaps you need to make first?"
  exit 1
fi

# Iterate over all test files.  After running boxologic, we grep for the word
# "ITERATIONS" and get the following 7 lines of context for both the test just
# run and its accompanying "known-good" version, then compare the results. We
# do it this way so that the execution time of the program - which is included
# in the result file - is ignored and won't cause a false positive if the
# tests are run on faster or slower machines.
for TEST_FILE in $TEST_DIR/*.txt
do
  KNOWN_GOOD_FILE=$KNOWN_GOOD_DIR/${TEST_FILE#$TEST_DIR/}.out
  printf "Testing %s... " "${TEST_FILE#$TEST_DIR/}"
  ./boxologic -f $TEST_FILE > /dev/null && \
  grep -A$NUM_LINES_OF_CONTEXT "$START_FINGERPRINT" $TEST_FILE.out > A && \
  grep -A$NUM_LINES_OF_CONTEXT "$START_FINGERPRINT" $KNOWN_GOOD_FILE > B && \
  diff A B > /dev/null 2>&1

  # Check the exit status of diff to tell us if the expected and test results
  # are identical, and thus if the test passed or not
  if [ $? -eq 0 ]; then
    STATUS="\033[0;32msame\033[0m."
  else
    STATUS="\033[0;31mdiff\033[0m!"
  fi
  echo -e $STATUS

  if [ -n "$SNAPSHOT" ]; then
      cp $TEST_FILE.out $KNOWN_GOOD_FILE
  fi

  # Cleanup Temp files
  rm -f A B $TEST_DIR/*.out
done

echo "Done."
