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
