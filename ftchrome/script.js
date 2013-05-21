// Test the text of the body element against our regular expression.
if (document.body.innerText) {
  // The regular expression produced a match, so notify the background page.
  console.log('test');
} else {
  // No match was found.
}