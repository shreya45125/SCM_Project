const hamburger = document.querySelector(".hamburger");
const navMenu = document.querySelector(".nav-menu");
const contentArea = document.querySelector(".content-area");

// Slider functionality
let currentSlide = 0;
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.dot');
const slidesContainer = document.querySelector('.slides');

function showSlide(n) {
    currentSlide = (n + slides.length) % slides.length;
    slidesContainer.style.transform = `translateX(-${currentSlide * 100}%)`;
    
    // Update dots
    dots.forEach(dot => dot.classList.remove('active'));
    dots[currentSlide].classList.add('active');
}

// Next/previous controls
document.querySelector('.next').addEventListener('click', () => showSlide(currentSlide + 1));
document.querySelector('.prev').addEventListener('click', () => showSlide(currentSlide - 1));

// Dot controls
dots.forEach((dot, index) => {
    dot.addEventListener('click', () => showSlide(index));
});

// Auto-advance slides every 5 seconds
setInterval(() => showSlide(currentSlide + 1), 5000);

// Original navigation functionality
hamburger.addEventListener("click", () => {
    hamburger.classList.toggle("active");
    navMenu.classList.toggle("active");
});

// Update content and trigger animation
function updateContent(title, content) {
    const mainContent = document.querySelector(".main-content");
    mainContent.style.animation = 'none';
    mainContent.offsetHeight; // Trigger reflow
    mainContent.style.animation = 'slideIn 0.5s ease-out';
    mainContent.innerHTML = `
        <h1>${title}</h1>
        <p>${content}</p>
    `;
}

// Add click event listeners to all nav links
document.querySelectorAll(".nav-link").forEach(link => {
    link.addEventListener("click", (e) => {
        e.preventDefault();
        hamburger.classList.remove("active");
        navMenu.classList.remove("active");
        
        // Update content based on clicked link
        const linkText = e.target.textContent.trim();
        updateContent(linkText, `Content for ${linkText} will be displayed here.`);
    });
}); 