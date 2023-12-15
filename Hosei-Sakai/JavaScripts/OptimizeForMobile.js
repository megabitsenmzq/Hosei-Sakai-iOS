var meta = document.createElement("meta");
meta.setAttribute("name", "viewport");
meta.setAttribute("content", "width=device-width, initial-scale=1");
document.head.appendChild(meta);

var css = ':root { color-scheme: light dark; } body { font-family: sans-serif !important; }';
var style = document.createElement('style');
style.type = 'text/css';
style.appendChild(document.createTextNode(css));
document.head.appendChild(style);
