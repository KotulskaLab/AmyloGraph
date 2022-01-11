function initial_center() {
  graph = document.getElementById('graph');
  if(!graph.hasOwnProperty('htmlwidget_data_init_result')) {
    setTimeout(initial_center, 50); //wait 50 millisecnds then recheck
    return;
  }
  
  network = document.getElementById('graph').htmlwidget_data_init_result.network;
  clientWidth = network.body.container.clientWidth;
  
  function center()  {
    network.moveTo({offset: {x: - 0.3 * clientWidth / 2 - 20, y: 0}})
  }
  setTimeout(center, 100); // waiting is necessary, because otherwise it doesn't work
}

initial_center();
