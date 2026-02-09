import "./note_colors"
import "./note_card"

/** Toast Fade Animation **/
document.addEventListener("DOMContentLoaded", () => {
    const toasts = document.querySelectorAll("#toast-container div[role='alert']");
    toasts.forEach(toast => {
        setTimeout(() => {
            toast.classList.remove("opacity-100");
            toast.classList.add("opacity-0");
            setTimeout(() => toast.remove(), 500); // fade out then remove
        }, 3000);

        const closeBtn = toast.querySelector("button[aria-label='Close']");
        if (closeBtn) {
            closeBtn.addEventListener("click", () => toast.remove());
        }
    });
});