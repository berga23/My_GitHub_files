function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample

    // Use d3 to select the panel with id of `#sample-metadata`
    
    var panel = d3.select('#sample-metadata');
    
    // Use `.html("") to clear any existing metadata
    
    var panel_cleared = panel.html("");
    
    // Use `Object.entries` to add each key and value pair to the panel
    
    // tags for each key-value in the metadata.

    
    d3.json("/metadata/" + sample).then((sampleNames) => {
        Object.entries(sampleNames).forEach((entry) => {
          panel_cleared
            .append("option")
            .text(entry)
            .property("value", entry);
        });
        });
}

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots
    var url = '/samples/'+ sample;
    d3.json(url).then(function(response) {
        var data = response;
        // @TODO: Build a Bubble Chart using the sample data

        // Creating Trace1 for the Bubble Chart
        var trace1 = {
          x: data.otu_ids,
          y: data.sample_values,
          text: data.otu_labels,
          mode: 'markers',
          marker: {
             color: data.otu_ids,
             size: data.sample_values
          }
        };
        // Creating Variadle to store data
        var trace_data = [trace1];

        // Defining layout  
        var layout = {
          title: 'Marker Size',
          showlegend: false,
          height: 1000,
          width: 1000
        };

        // Rendering to div accessing id "bubble"
        Plotly.newPlot('bubble', trace_data, layout);

        // @TODO: Build a Pie Chart

        // Creating Trace2 for the Pie Chart

        var trace2 = {   
            values: data.sample_values.slice(0, 10),
            labels: data.otu_ids.slice(0, 10),
            hoverinfo: data.otu_labels.slice(0, 10),
            type: "pie"
        };

        // Creating Variadle to store data
        var pie_data = [trace2];

        // Defining layout
        var pie_layout = {
           height: 600,
           width: 600
            };

        // Rendering to div accessing id "pie"
        Plotly.newPlot("pie", pie_data, pie_layout);

    });
}

function init() {
  
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
