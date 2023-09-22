"use strict";


document.addEventListener("DOMContentLoaded", () => {
    let count = 0;
    let max = 10;
    let total_time = 0;
    const logTable = document.getElementById("logTable");
    const userInput = document.getElementById("userInput");
    const question = document.getElementById("question");

    let startTime = Date.now();


    function displayNumbers() {
        const numbers = generateRandomNumbers();
        console.log(numbers);
        question.innerHTML = numbers.join(" ");
    }
    function getUserInput() {
        return userInput.value.trim();
    }

    // Load from local storage if available
    const savedLog = localStorage.getItem('log');
    if (savedLog) {
        logTable.innerHTML = savedLog;
    }

    userInput.addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
            submitGuess();
        }
    });


    displayNumbers();
    window.submitGuess = () => {
        const guess = userInput.value.trim();


        if (guess === "q" || guess === "s" || /^[0-9a-z]+$/.test(guess)) {
            const endTime = Date.now();
            const elapsedTime = (endTime - startTime) / 1000;
            total_time += elapsedTime;

            console.log("Start time: " + startTime);
            console.log("End time: " + endTime);
            console.log("Elapsed time: " + elapsedTime);
            console.log("Total time: " + total_time);

            let numbers = question.innerHTML.split(" ");
            numbers = numbers.map((val) => parseInt(val));
            console.log(numbers);
            const sum = numbers.reduce((acc, val) => acc + val, 0);

            addLog(count + 1, numbers, guess, elapsedTime, new Date().toISOString(), sum);

            if (guess === "q") {
                // Quit the session
                return;
            }

            if (guess === "s") {
                // Skip the question
                count++;
                return;
            }

            count++;
        } else {
            alert("Invalid input. Enter only characters 0-9, a-z, or space.");
        }
        displayNumbers();
        userInput.value = "";
        startTime = Date.now();
    };

    window.clearLog = () => {
        localStorage.clear();
        logTable.innerHTML = "<tr><th>Question</th><th>Numbers</th><th>Guess</th><th>Elapsed Time(s)</th><th>Date</th></tr>";
    };

    window.newSession = () => {
        count = 0;
        max = 10;
        total_time = 0;
    };

    function generateRandomNumbers() {
        const length = Math.floor(Math.random() * 4) + 3;
        return Array.from({length}, () => Math.floor(Math.random() * 9) + 1);
    }

    function addLog(question, numbers, guess, elapsedTime, date, sum) {
        const newRow = logTable.insertRow(-1);
        newRow.innerHTML = `<td>${question}</td><td>${numbers.join(" ")}</td><td>${guess}</td><td>${elapsedTime.toFixed(2)}</td><td>${date}</td>`;
        localStorage.setItem('log', logTable.innerHTML);

        if (parseInt(guess) === sum) {
            console.log("Correct");
        } else {
            console.log(`The sum is ${sum}`);
        }
    }

    // Start loop ///////////////////////////////////////////////////////////////
    /*setInterval(() => {
        if (count >= max) {
            alert(`You have completed ${max} questions in ${total_time.toFixed(2)} seconds`);
            newSession();
            let nums = generateRandomNumbers();
            question.innerHTML = numbers.join(" ");
        }
    });*/

/*    let correctCount = 0;
    let incorrectCount = 0;
    let totalCount = 0;
    let totalTime = 0;*/

/*
    while (true) {

        // Generate random numbers
        const nums = generateRandomNumbers();

        // Display numbers
        // displayNumbers(nums);

        // Get user input
        const input = getUserInput();

        // Check for quit
        if (input === 'quit') {
            break;
        }

        // Check for skip
        if (input === 'skip') {
            continue;
        }

        // Check if input is valid
        if (isValidInput(input)) {

            // Check if correct
            const isCorrect = checkInput(input, nums);

            if (isCorrect) {
                correctCount++;
            } else {
                incorrectCount++;
            }

            // Update counts
            totalCount++;
            totalTime += getElapsedTime();

        } else {
            displayError();
        }

    }
*/

    // Display results
    // displayResults(correctCount, incorrectCount, totalCount, totalTime);


    // End loop /////////////////////////////////////////////////////////////////


});
