#!/bin/zsh

manage_input() {
  local guess=""
  local start_time end_time elapsed_time
  start_time=$(date +%s)

  while true; do
    if read -r guess; then
      if [[ -z $guess || $guess == "q" || $guess =~ ^[0-9a-z]+$ ]]; then
        [[ -z $guess ]] && guess="q"
        break
      else
        echo -n "Invalid input. Enter only characters 0-9, a-z, or space."
      fi
    else
      break
    fi
  done

  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  echo "$guess $elapsed_time"
}


count=0
max=10
total_time=0
log_file="log.txt"

if [[ -f $log_file ]]; then
  count=$(awk '/\| *[0-9]+ */ {gsub(/[| ]+/, "", $2); last=$2} END {print last}' log.txt)

  max=$((count + 10))

  total_time=$(tail -1 $log_file | awk '{print $6}')

  # Remove the last line containing the old "Total time" and store the rest in a temp file
  awk 'NR > 1 {print last} {last=$0}' $log_file > temp_log.txt

  # Move the temp file to overwrite the old log file
  mv temp_log.txt $log_file
else
  {
    echo "+------------+---------------+---------+-----------------+---------------------+"
    echo "|  Question  |    Numbers    |  Guess  | Elapsed Time(s) |        Date         |"
    echo "+------------+---------------+---------+-----------------+---------------------+"
  } >> $log_file

fi


while (( count < $max )); do
  echo "Question $((count + 1)) / $max"

  length=$((RANDOM % 4 + 3))
  read -r -A nums <<< "$(jot -r $length 1 9 | tr '\n' ' ')"

  read -r -A nums <<< "$(printf "%s\n" "${nums[@]}" | sort -n | tr '\n' ' ')"

  echo "${nums[@]}"

  read -r guess elapsed_time <<< "$(manage_input)"

  [[ $guess == "s" ]] && { echo "Skipping current question."; continue; }
  [[ $guess == "q" || -z $guess ]] && { echo "Quitting the session."; break; }

  total_time=$((total_time + elapsed_time))

  sum=0
  for n in "${nums[@]}"; do
    sum=$((sum + n))
  done

  # Get the current date and time
  current_date=$(date +"%Y %m %d %H %M %S")

  printf "| %10d | %13s | %7s | %15d | %19s |\n" $((count + 1)) "${nums[*]}" "$guess" "$elapsed_time" "$current_date" >> $log_file
  echo "+------------+---------------+---------+-----------------+---------------------+" >> $log_file


  [[ $guess -eq $sum ]] && echo -e "\033[32;40mCorrect\033[0m" || echo -e "\033[31;40mThe sum is $sum\033[0m"

  count=$((count + 1))
done

# Remove the last line containing the old "Total time"
# sed -i '$ d' $log_file

# Append the new total time
echo "Total time for all sessions: $total_time sec" >> $log_file

# Display the log file
cat $log_file
