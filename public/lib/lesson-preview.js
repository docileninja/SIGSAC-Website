//MUST ALSO INCLUDE /lib/markdown.js for this to work

var description = document.getElementsByClassName("lesson_description")[0];
var anchor = document.getElementsByClassName("video_link")[0];
var image = document.getElementsByClassName("lesson_thumb")[0];

var input = document.getElementById("description");
var videoLink = document.getElementById("video_link");
var imageLink = document.getElementById("image_link");

var showPreview = function () {
    description.innerHTML = markdown.toHTML(input.value);
    anchor.href = videoLink.value;
    image.src = imageLink.value;
};
input.addEventListener("input", showPreview);
input.addEventListener("onpropertychange", showPreview);
videoLink.addEventListener("input", showPreview);
videoLink.addEventListener("onpropertychange", showPreview);
imageLink.addEventListener("input", showPreview);
imageLink.addEventListener("onpropertychange", showPreview);

showPreview();