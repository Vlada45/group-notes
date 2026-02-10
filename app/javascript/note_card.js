/** Show Submit Button after heading is entered **/
import {createClient} from "@supabase/supabase-js";
import {showToast} from "./toast";

document.addEventListener('input', (e) => {
    if (e.target.id === 'card_head') {
        const submitBtn = document.getElementById('submitBtn');
        if (!submitBtn) return;

        if (e.target.value.trim() !== "") {
            submitBtn.classList.remove('hidden');
            submitBtn.classList.add('flex');

        } else {
            submitBtn.classList.add('hidden');
        }
    }
});

/** Edit Form (Edit Btn showing on :hover) **/
document.querySelectorAll(".note-card").forEach(card => {
    const noteId = card.dataset.id;

    // Elements inside this card
    const heading = card.querySelector(`#note_head_${noteId}`);
    const description = card.querySelector(`#note_des_${noteId}`);
    const editBtn = card.querySelector(".edit-btn");
    const submitBtn = card.querySelector(".submit-btn");
    const form = card.querySelector("form");

    if (!editBtn || !submitBtn || !heading || !description) return;

    // Save original values
    heading.dataset.original = heading.value;
    description.dataset.original = description.value;

    let editing = false;

    // START Hover listener - show edit button only if not editing
    card.addEventListener("mouseenter", () => {
        if (!editing) {
            editBtn.classList.remove("hidden");
            editBtn.classList.add("flex");
        }
    });

    // END Hover listener - disappear edit button only if not editing
    card.addEventListener("mouseleave", () => {
        if (!editing) {
            editBtn.classList.remove("flex");
            editBtn.classList.add("hidden");
        }
    });

    // On Edit Btn click allows user to edit Form
    editBtn.addEventListener("click", e => {
        e.stopPropagation();
        editing = true;

        heading.removeAttribute("readonly");
        description.removeAttribute("readonly");
        heading.focus();

        // toggle buttons
        editBtn.classList.add("hidden");
        submitBtn.classList.remove("hidden");
        submitBtn.classList.add("flex");
    });

    // Check for changes in Form
    form.addEventListener("submit", e => {
        const headingChanged = heading.value !== heading.dataset.original;
        const descriptionChanged = description.value !== description.dataset.original;

        if (!headingChanged && !descriptionChanged) {
            e.preventDefault();
            alert("Nebyly provedeny žádné změny");

            // reset edit mode
            heading.setAttribute("readonly", "true");
            description.setAttribute("readonly", "true");
            submitBtn.classList.add("hidden");
            editBtn.classList.remove("hidden");
            submitBtn.classList.remove("flex");
            editing = false;
        }
    });
});


// // Initialize Supabase
// const supabaseUrl = document.body.dataset.supabaseUrl;
// const supabaseKey = document.body.dataset.supabaseKey;
// const supabase = createClient(supabaseUrl, supabaseKey);

/** New Note to Supabase **/
// document.addEventListener("submit", async (e) => {
//     if (!e.target.matches("#new_note_form")) return;
//
//     e.preventDefault();
//     const form = e.target;
//     const heading = form.querySelector("#card_head").value;
//     const description = form.querySelector("#card_des").value;
//
//     console.log("Form submitted!", heading, description);
//
//     // Check required field
//     if (!heading) {
//         showToast("Název poznámky nemůže být prázdný!", "alert");
//         return;
//     }
//
//     try {
//         const response = await fetch("/notes", {
//             method: "POST",
//             headers: {
//                 "Content-Type": "application/json",
//                 "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
//             },
//             body: JSON.stringify({ heading, description })
//         });
//
//         if (!response.ok) {
//             const text = await response.text(); // read HTML in case of 500
//             console.error("Server returned an error:", text);
//             showToast("Nepodařilo se přidat poznámku!", "alert");
//             return;
//         }
//
//         const result = await response.json();
//
//         if (result.success) {
//             showToast("Poznámka byla úspěšně přidána!", "notice");
//             form.reset();
//         } else {
//             showToast(`Chyba: ${result.error}`, "alert");
//         }
//     } catch (err) {
//         showToast("Neočekávaná chyba!", "alert");
//         console.error(err);
//     }
// });
