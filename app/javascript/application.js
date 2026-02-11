import "./note_colors"
import "./note_card"
// import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import {controllers} from "./controllers";

const application = Application.start()

window.SUPABASE_URL = "<%= ENV['SUPABASE_URL'] %>";
window.SUPABASE_ANON_KEY = "<%= ENV['SUPABASE_ANON_KEY'] %>";

// Loading controllers
Object.entries(controllers).forEach(([name, controller]) => {
    application.register(name, controller)
})

/** Toast Fade Animation **/
document.addEventListener("DOMContentLoaded", () => {
    const toasts = document.querySelectorAll("#toast-container div[role='alert']");
    toasts.forEach(toast => {
        setTimeout(() => {
            toast.classList.remove("opacity-100");
            toast.classList.add("opacity-0");
            setTimeout(() => toast.remove(), 500);
        }, 3000);

        const closeBtn = toast.querySelector("button[aria-label='Close']");
        if (closeBtn) {
            closeBtn.addEventListener("click", () => toast.remove());
        }
    });
});
