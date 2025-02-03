window.addEventListener("message", (event) => {
    const data = event.data;

    if (data.action === "showUI") {
        document.getElementById("charging-ui").classList.remove("hidden");
    } else if (data.action === "hideUI") {
        document.getElementById("charging-ui").classList.add("hidden");
    } else if (data.action === "updateProgress") {
        document.getElementById("progress").style.width = data.progress + "%";
        document.getElementById("progress-text").innerText = data.progress + "%";
    }
});