#!/bin/zsh

# Initialize variables
count=0
max=10
total_time=0
log_file="log.txt"

# Clear the log file if it exists
: > $log_file

# Add table header to the log file
{
  echo "+------------+---------------+---------+-----------------+"
  echo "|  Question  |    Numbers    |  Guess  | Elapsed Time(s) |"
  echo "+------------+---------------+---------+-----------------+"
} >> $log_file

while (( count < $max )); do
  echo Question $((count + 1)) / $max

  # Generate a random length between 3 and 6
  length=$((RANDOM % 4 + 3))

  # Generate a random sequence of numbers with that length
  read -r -A nums <<< "$(jot -r $length 1 9 | tr '\n' ' ')"

  # Sort the nums array in ascending order
  read -r -A nums <<< "$(printf "%s\n" "${nums[@]}" | sort -n | tr '\n' ' ')"

  echo "${nums[@]}"

  # Record the start time
  start_time=$(date +%s)

  # Sanitize input
  while true; do
    read -r guess

    if [[ -z $guess || $guess =~ ^[0-9a-z]+$ ]]; then
      break
    else
      echo "Invalid input. Please enter only characters between 0-9 or a-z."
    fi
  done

  # Skip the current question if 's' is entered
  if [[ $guess == "s" ]]; then
    echo "Skipping current question."
    continue
  fi

  if [[ $guess == "q" || -z $guess ]]; then
    break
  fi


  # Record the end time and calculate the elapsed time
  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  total_time=$((total_time + elapsed_time))


  # Calculate the sum of the numbers in the array
  sum=0
  for n in "${nums[@]}"; do
    sum=$((sum + n))
  done

  # Log the question and elapsed time to a file, formatted as a table row
  printf "| %10d | %13s | %7s | %15d |\n" $((count + 1)) "${nums[*]}" "$guess" "$elapsed_time" >> $log_file
  echo "+------------+---------------+---------+-----------------+" >> $log_file

  if [[ $guess -eq $sum ]]; then
    echo -e "\033[32;40mCorrect\033[0m"  # Green text on black background
  else
    echo -e "\033[31;40mThe sum is $sum\033[0m"  # Red text on black background
  fi

  count=$((count + 1))
done

# Log the total time to the file
echo "Total time for the session: $total_time sec" >> $log_file

# Display the log file
cat $log_file
