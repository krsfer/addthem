#!/bin/zsh

# Function to manage user input
manage_input() {
  local guess=""
  local start_time end_time elapsed_time

  # Record the start time
  start_time=$(date +%s)

  # Sanitize input
  while true; do
    if read -r guess; then
      if [[ -z $guess || $guess == "q" || $guess =~ ^[0-9a-z]+$ ]]; then
        if [[ -z $guess ]]; then
          guess="q"
        fi
        break
      else
        echo -n "Invalid input. Please enter only characters between 0-9, a-z, or space."
      fi
    else
      # No input provided, handle it as an empty string
      break
    fi
  done

  # Record the end time and calculate the elapsed time
  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))

  if [[ -z $guess ]]; then
    guess=""
  fi

  echo "$guess $elapsed_time"
}

# Unit tests for manage_input
# Unit tests for manage_input
test_manage_input() {
  local result

  # Test 1: Check empty input
  result=$(echo "" | manage_input)
  expected=" 0"
  if [[ $result == "$expected" ]]; then
    echo "Test 1 passed: Expected '$expected', got '$result'"
  else
    echo "Test 1 failed: Expected '$expected', got '$result'"
  fi

  # Test 2: Check 'q' input
  result=$(echo "q" | manage_input)
  expected="q 0"
  if [[ $result == "$expected" ]]; then
    echo "Test 2 passed: Expected '$expected', got '$result'"
  else
    echo "Test 2 failed: Expected '$expected', got '$result'"
  fi

  # Test 3: Check valid characters
  result=$(echo "abc123" | manage_input)
  expected="abc123 0"
  if [[ $result == "$expected" ]]; then
    echo "Test 3 passed: Expected '$expected', got '$result'"
  else
    echo "Test 3 failed: Expected '$expected', got '$result'"
  fi

  # Test 4: Check invalid characters
  result=$(echo "!" | manage_input 2>/dev/null)
  expected="Invalid input. Please enter only characters between 0-9, a-z, or space. 0"
  if [[ "$result" == "$expected" ]]; then
    echo "Test 4 passed: Expected"
    echo "$expected"
    echo "got"
    echo "$result"
  else
    echo "Test 4 failed: Expected"
    echo ">""$expected""<"
    echo "got"
    echo ">""$result""<"
  fi
}

# Run the tests
# test_manage_input
# exit

# Initialize variables
count=0
max=10
total_time=0
log_file="log.txt"

# Clear the log file
: > $log_file

# Add table header to log file
{
  echo "+------------+---------------+---------+-----------------+"
  echo "|  Question  |    Numbers    |  Guess  | Elapsed Time(s) |"
  echo "+------------+---------------+---------+-----------------+"
} >> $log_file

while (( count < $max )); do
  echo Question $((count + 1)) / $max

  # Generate random sequence
  length=$((RANDOM % 4 + 3))
  read -r -A nums <<< "$(jot -r $length 1 9 | tr '\n' ' ')"

  # Sort the nums
  read -r -A nums <<< "$(printf "%s\n" "${nums[@]}" | sort -n | tr '\n' ' ')"

  echo "${nums[@]}"

  # Call manage_input function
  read -r guess elapsed_time <<< "$(manage_input)"

  # Handle special cases
  # continue on s
  if [[ $guess == "s" ]]; then
    echo "Skipping current question."
    continue
  fi

  # break on q
  if [[ $guess == "q" || -z $guess ]]; then
    echo "Quitting the session."
    break
  fi

  # break on empty input
  if [[ -z $guess ]]; then
    echo "Quitting the session."
    break
  fi

  total_time=$((total_time + elapsed_time))

  # Calculate the sum
  sum=0
  for n in "${nums[@]}"; do
    sum=$((sum + n))
  done

  # Log the question and elapsed time
  printf "| %10d | %13s | %7s | %15d |\n" $((count + 1)) "${nums[*]}" "$guess" "$elapsed_time" >> $log_file
  echo "+------------+---------------+---------+-----------------+" >> $log_file

  if [[ $guess -eq $sum ]]; then
    echo -e "\033[32;40mCorrect\033[0m"  # Green text on black background
  else
    echo -e "\033[31;40mThe sum is $sum\033[0m"  # Red text on black background
  fi

  count=$((count + 1))
done

# Log total time
echo "Total time for the session: $total_time sec" >> $log_file

# Display the log file
cat $log_file
