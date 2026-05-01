window.onload = async function () {
    const data = JSON.parse(localStorage.getItem("doubtData"));

    if (!data) {
        document.getElementById("answer").innerText = "No question found.";
        return;
    }

    document.getElementById("questionText").innerText = data.question;

    try {
        const response = await fetch("http://127.0.0.1:5000/ai", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                question: data.question
            })
        });

        const result = await response.json();

        document.getElementById("answer").innerText = result.answer || "No answer received.";

    } catch (error) {
        console.error(error);
        document.getElementById("answer").innerText = "Error loading AI answer.";
    }
};