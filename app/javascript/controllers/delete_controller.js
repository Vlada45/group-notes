// app/javascript/controllers/delete_controller.js
import { Controller } from "@hotwired/stimulus"

/** Note Deletion Verification Controller **/
export default class extends Controller {
    static values = { message: String }

    connect() {
        // console.log("🗑 DeleteController pripojen")
    }

    confirm(event) {
        event.preventDefault()
        const msg = this.messageValue || "Opravdu chcete poznámku smazat?"
        if (confirm(msg)) {
            // Submit the form manually if confirmed
            this.element.closest("form").requestSubmit()
        } else {
            console.log("Deletion cancelled")
        }
    }
}