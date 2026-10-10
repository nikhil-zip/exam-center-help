/** @type {import('tailwindcss').Config} */
export default { content: ['./index.html','./src/**/*.{ts,tsx}'], theme: { extend: { colors: { ink:'#14231f', paper:'#f6f7f2', forest:'#285e49', lime:'#d3f36b', muted:'#6c7974' }, fontFamily:{ sans:['Inter','ui-sans-serif','system-ui'] }, boxShadow:{soft:'0 12px 40px rgba(23,44,36,.08)'} } }, plugins: [] };
