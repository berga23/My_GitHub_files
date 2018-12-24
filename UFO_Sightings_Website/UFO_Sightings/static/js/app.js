// from data.js
var tableData = data;

var tbody = d3.select("tbody");

var UFO_table = d3.select("#ufo-table");


// YOUR CODE HERE!

// Select the submit button
var submit = d3.select("#filter-btn");

submit.on("click", function() {

  tbody.text("")

  // Prevent the page from refreshing
  d3.event.preventDefault();

  // Select the input element and get the raw HTML node and then creating value for filter
  var datetest = d3.select("#datetime").property("value"); 
  
  // Testing "Console Log" to see if it`s working
  console.log(datetest);

  // Creating Data filtered by date from submit
  filteredData = tableData.filter(person => person.datetime === datetest);
  
  // Testing "Console Log" to see if it`s working
  console.log(filteredData);

  // Appending data in table in HTML - tr and td
  filteredData.forEach(function(UFOSighting) {

    var row = tbody.append("tr");
    Object.entries(UFOSighting).forEach(function([key, value]) {

    var cell = tbody.append("td");
    cell.text(value);
    });
  });
});