#!/usr/bin/env bash
BOXOLOGIC_BIN=boxologic
TEST_DIR=test
KNOWN_GOOD_DIR=$TEST_DIR/known-good-results

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
  printf "Testing %s... " "${TEST_FILE#$TEST_DIR/}"
  ./boxologic -f $TEST_FILE > /dev/null && \
  grep -A7 ITERATIONS $TEST_FILE.out > A && \
  grep -A7 ITERATIONS $KNOWN_GOOD_DIR/${TEST_FILE#$TEST_DIR/}.out > B && \
  diff A B > /dev/null 2>&1
  
  # Check the exit status of diff to tell us if the expected and test results 
  # are identical, and thus if the test passed or not
  if [ $? -eq 0 ]; then
    STATUS="passed."
  else
    STATUS="failed."
  fi
  printf "%s\n" "$STATUS"   
done

# Cleanup Temp files
rm -f A B $TEST_DIR/*.out
echo "Done."