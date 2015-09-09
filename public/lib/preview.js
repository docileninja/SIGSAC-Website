//MUST ALSO INCLUDE /lib/markdown.js for this to work

var input = document.getElementById("input");
var preview = document.getElementById("preview");
var showPreview = function () {
    preview.innerHTML = markdown.toHTML(input.value);
};
input.addEventListener("input", showPreview);
input.addEventListener("onpropertychange", showPreview);
showPreview();