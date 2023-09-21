document.addEventListener("DOMContentLoaded", () => {
    let count = 0;
    let max = 10;
    let total_time = 0;
    const logTable = document.getElementById("logTable");
    const userInput = document.getElementById("userInput");
    const question = document.getElementById("question");

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

    const numbers = generateRandomNumbers();
    console.log(numbers);
    question.innerHTML = numbers.join(" ");

    window.submitGuess = () => {
        const startTime = Date.now();
        const guess = userInput.value.trim();


        if (guess === "q" || guess === "s" || /^[0-9a-z]+$/.test(guess)) {
            const endTime = Date.now();
            const elapsedTime = (endTime - startTime) / 1000;
            total_time += elapsedTime;

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
        const numbers = Array.from({length}, () => Math.floor(Math.random() * 9) + 1);
        return numbers;
    }

    function addLog(question, numbers, guess, elapsedTime, date, sum) {
        const newRow = logTable.insertRow(-1);
        newRow.innerHTML = `<td>${question}</td><td>${numbers.join(" ")}</td><td>${guess}</td><td>${elapsedTime.toFixed(2)}</td><td>${date}</td>`;
        localStorage.setItem('log', logTable.innerHTML);

        if (parseInt(guess) === sum) {
            alert("Correct");
        } else {
            alert(`The sum is ${sum}`);
        }
    }
});
