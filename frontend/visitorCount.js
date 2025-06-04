async function updateVisitorCount() {
  try {
    const response = await fetch("https://chinmay-visitor-counter.azurewebsites.net/api/HttpTrigger1");

    if (!response.ok) {
      throw new Error("Network response was not ok");
    }

    const data = await response.json();
    document.getElementById("visitor-count").textContent = data.count;
  } catch (error) {
    console.error("Failed to fetch visitor count:", error);
    document.getElementById("visitor-count").textContent = "No";
  }
}

window.onload = updateVisitorCount;

