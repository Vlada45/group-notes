const setups = [
    {btnId: 'toggleColorsDesktop', containerId: 'colorCirclesDesktop'},
    {btnId: 'toggleColorsMobile', containerId: 'colorCirclesMobile'}
];

/** Selection Animation **/
setups.forEach(({btnId, containerId}) => {
    const button = document.getElementById(btnId);
    const container = document.getElementById(containerId);

    if (!button || !container) return;

    const icon = button.querySelector('.plus-icon');
    const circles = container.querySelectorAll('.circle');
    let open = false;

    button.addEventListener('click', () => {
        open = !open;

        // rotate icon
        icon.classList.toggle('rotate-45', open);

        // toggle container
        container.classList.toggle('opacity-0', !open);
        container.classList.toggle('max-h-0', !open);

        // stagger circles
        circles.forEach((circle, index) => {
            setTimeout(() => circle.classList.toggle('show', open), index * 80);
        });
    });
});

// Note Cards
const cardsContainer = document.getElementById('cards');

// View Template
const template = document.getElementById('card-template').content;

/** Desktop View - WITH SELECTION **/
document.getElementById('colorCirclesDesktop').addEventListener('click', e => {
    const circle = e.target.closest('.circle');
    if (!circle) return;

    const colorClass = circle.dataset.color;
    // console.log("COLOR CLASS:", colorClass);

    const clone = document.importNode(template, true);
    const card = clone.querySelector('.note-card');

    if (card) {
        card.classList.forEach(cls => {
            if (cls.startsWith("bg-")) card.classList.remove(cls);
        });

        // Add the new class
        card.classList.add(colorClass);
    }
    cardsContainer.appendChild(clone);
});

/** Mobile View - WITHOUT SELECTION **/
document.addEventListener("DOMContentLoaded", () => {
    const toggleButton = document.getElementById("toggleColorsMobile");

    if (!toggleButton || !cardsContainer || !template) return;

    toggleButton.addEventListener("click", () => {
        const clone = document.importNode(template, true);
        const card = clone.querySelector(".note-card");

        if (card) {
            // Already has bg-yellow-400 from template, but you can force class if needed:
            card.classList.forEach(cls => {
                if (cls.startsWith("bg-")) card.classList.remove(cls);
            });
            card.classList.add("bg-yellow-400");
        }

        cardsContainer.appendChild(clone);
    });
});
