export function showToast(message, type = "notice") {
    let container = document.getElementById("toast-container");

    // Create container if not exists
    if (!container) {
        container = document.createElement("div");
        container.id = "toast-container";
        container.className = "absolute bottom-10 start-1/2 -translate-x-1/2";
        document.body.appendChild(container);
    }

    // Create toast element
    const toast = document.createElement("div");
    toast.className = "max-w-xs w-full p-4 border border-gray-200 rounded-xl shadow-lg flex items-center gap-x-3 justify-between bg-white transition-opacity duration-500 ease-out opacity-100";

    // Icon
    const icon = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    icon.setAttribute("class", "shrink-0 w-4 h-4 " + (type === "notice" ? "text-teal-500" : "text-red-500"));
    // set your path here or leave empty for simplicity
    toast.appendChild(icon);

    // Message
    const msgDiv = document.createElement("div");
    msgDiv.className = "flex-1 text-sm text-gray-900";
    msgDiv.innerText = message;
    toast.appendChild(msgDiv);

    // Close button
    const closeBtn = document.createElement("button");
    closeBtn.type = "button";
    closeBtn.className = "ml-2 flex justify-center items-center w-5 h-5 text-gray-500 hover:text-gray-700 focus:outline-none cursor-pointer";
    closeBtn.innerHTML = `<svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M18 6L6 18"/><path d="M6 6l12 12"/></svg>`;
    closeBtn.onclick = () => toast.remove();
    toast.appendChild(closeBtn);

    container.appendChild(toast);

    // Auto hide after 3s
    setTimeout(() => toast.remove(), 3000);
}