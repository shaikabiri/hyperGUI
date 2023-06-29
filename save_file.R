#helper function for saving files

observeEvent(input$saveformat,{
  if (input$saveformat == "mat"){
    output$save <- downloadHandler(
      filename = function(){
        "dataset.mat"
      },
      content =  function(file) {R.matlab::writeMat(file,data = saveMat)}
    )
  } else if (input$saveformat == "r"){
    output$save <- downloadHandler(
      filename = function(){
        "dataset.rds"
      },
      content =  function(file) {saveRDS(saveData, file)}
    )
  }
}
)