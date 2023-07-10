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
    dimnames(saveMat)[3] <- list(hdrspare$wavelength)
    
    output$save <- downloadHandler(
      filename = function(){
        "dataset.rds"
      },
      content =  function(file) {saveRDS(saveMat, file)}
    )
  } else if (input$saveformat == "numpy"){
    dimnames(saveMat)[3] <- list(hdrspare$wavelength)
    
    output$save <- downloadHandler(
      filename = function(){
        "dataset.npy"
      },
      content =  function(file) {np = import("numpy")
      np$save(file,r_to_py(saveMat))}
    )
  } else if (input$saveformat == "rast"){
    
    output$save <- downloadHandler(
      filename = function(){
        "dataset.tiff"
      },
      content =  function(file) {terra::writeRaster(x = rst, filename = file)}
    )
  }
  
  if (input$saveformat == "mat"){
    output$pcasave <- downloadHandler(
      filename = function(){
        "dataset.mat"
      },
      content =  function(file) {R.matlab::writeMat(file,data = pcaSaveMat)}
    )
  } else if (input$saveformat == "r"){
    output$pcasave <- downloadHandler(
      filename = function(){
        "dataset.rds"
      },
      content =  function(file) {saveRDS(pcaSaveMat, file)}
    )
  } else if (input$saveformat == "numpy"){
    output$pcasave <- downloadHandler(
      filename = function(){
        "dataset.npy"
      },
      content =  function(file) {np = import("numpy")
      np$save(file,r_to_py(pcaSaveMat))}
    )
  }
  
  
}
)


  output$savewave <- downloadHandler(
    filename = function(){
      "wavelengths.csv"
    },
    content =  function(file) {write.csv(hdrspare$wavelength,file)}
  )

  output$pcasave <- downloadHandler(
    filename = function(){
      "pca.csv"
    },
    content =  function(file) {write.csv(pcaSaveMat,file)}
  )