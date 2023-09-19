#!/bin/zsh

# Initialize variables
count=0
max=10
total_time=0
log_file="log.txt"


# Clear the log file if it exists
: > $log_file

while (( count < $max )); do

  echo Question $((count+1)) / $max

  # Generate a random length between 3 and 6
  length=$((RANDOM % 4 + 3))

  # Generate a random sequence of numbers with that length
  nums=($(jot -r $length 1 9))

  echo ${nums[@]}

  # Record the start time
  start_time=$(date +%s)

  read -r guess

  # Record the end time and calculate the elapsed time
  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  total_time=$((total_time + elapsed_time))

  if [[ $guess == "q" || -z $guess ]]; then
    break
  fi

  # Calculate the sum of the numbers in the array
  sum=0
  for n in ${nums[@]}; do
    sum=$((sum + n))
  done

  # Log the question and elapsed time to a file
  echo "Question $((count+1)): Numbers=${nums[@]}, Guess=$guess, Elapsed Time=$elapsed_time sec" >> $log_file

  if [[ $guess -eq $sum ]]; then
    echo "correct"
  else
    echo "The sum is $sum"
  fi

  count=$((count + 1))
done

# Log the total time to the file
echo "Total time for the session: $total_time sec" >> $log_file

# Display the log file
cat $log_file
