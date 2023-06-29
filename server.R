server <- function(input, output, session) {
  plot_num <- 1
  #a list of items to be toggled on and off
  toggle_list <-
    c("displaysel",
      "disoptfp",
      "up",
      "hyperPlot",
      "down",
      "slider",
      "save",
      "saveformat")
  for (item in toggle_list) {
    shinyjs::disable(item)
  }
  
  output$current <- renderText("Load an image")
  
  source("save_file.R", local = TRUE)
  
  
  observeEvent(input$file1 , {
    shinyjs::show("hyperPlot")
    
    range01 <- function(x) {
      (x - min(x)) / (max(x) - min(x))
    }
    
    
      shinyjs::show("hyperPlot")

        paths <- parsed_path(input$file1)
        hdrpath <- as.character(paths[2])
        imgpath <- as.character(paths[1])

      # else {
      #   hdrpath <- "example.hdr"
      #   imgpath <- "example.sif"
      # }
      
      hdr <- readLines(con = hdrpath)
      hdr <- header_reader(hdr)
      hdrspare <<- hdr
      #enable list of toggle objects
      for (item in toggle_list) {
        shinyjs::enable(item)
      }
      
      sliders <- c("slider", "chan1", "chan2", "chan3")
      for (item in sliders)
      {
        updateSliderTextInput(
          session = session,
          inputId = item,
          choices = hdr$wavelength,
        )
      }
      
      
      data <-
        hyperSpec::read.ENVI.HySpex(file = imgpath, headerfile = hdrpath)
      sparedata <<- data
      saveData <<- data
      saveMat <<-
        array(saveData$spc, dim = c(hdr$height, hdr$width, length(hdr$wavelength)))
      # data1 <<- data$spc[, which(hdr$wavelength == input$slider)]
      # data1 <<- pracma::Reshape(data1, hdr$height, hdr$width)
      # plot(raster::as.raster(range01(t(data1))))
      output$hyperPlot <- renderPlot({
      plot(raster::as.raster(range01(t(saveMat[, ,which(hdr$wavelength == input$slider)])
      )))}
      

    )
    
    output$current <- renderText(input$slider)
    output$info <- renderText({
      paste0("x=",
             input$plot_click$coords_css$xmin,
             "\ny=",
             input$plot_click$ymin)
    })
    
  })
  
  
  
  
  
  observeEvent(input$up, {
    if (as.numeric(input$slider) < max(hdrspare$wavelength)) {
      currentValue <-
        which(as.numeric(hdrspare$wavelength) == input$slider)
      updateSliderTextInput(
        session = session,
        inputId = "slider",
        selected = hdrspare$wavelength[currentValue + 1]
      )
    }
  })
  
  observeEvent(input$down, {
    if (as.numeric(input$slider) > min(hdrspare$wavelength)) {
      currentValue <-
        which(as.numeric(hdrspare$wavelength) == input$slider)
      updateSliderTextInput(
        session = session,
        inputId = "slider",
        selected = hdrspare$wavelength[currentValue - 1]
      )
      
    }
  })
  
  
  observeEvent(input$displaysel, {
    range01 <- function(x) {
      (x - min(x)) / (max(x) - min(x))
    }
    if (input$displaysel == "fp") {
      shinyjs::show("dispoptfp")
      shinyjs::hide("dispoptrgb")
      output$hyperPlot <-
        renderPlot(plot(raster::as.raster(range01(t(saveMat[, ,which(hdrspare$wavelength == input$slider)])
        ))))
      
    } else if (input$displaysel == "rgb") {
  
      shinyjs::hide("dispoptfp")
      shinyjs::show("dispoptrgb")
      output$hyperPlot <-
        renderPlot(plot(raster::as.raster(range01(
          abind::abind(t(saveMat[, , which(hdrspare$wavelength == input$chan1)]), t(saveMat[, , which(hdrspare$wavelength == input$chan2)]), t(saveMat[, , which(hdrspare$wavelength == input$chan3)]), along = 3)
        ))))
      
    } else if (input$displaysel == "pca") {
      range01 <- function(x) {
        (x - min(x)) / (max(x) - min(x))
      }
      
      shinyjs::hide("dispoptfp")
      shinyjs::hide("dispoptrgb")
      saveMat2d <- saveMat
      dim(saveMat2d) <- c(dim(saveMat)[1]*dim(saveMat)[2] , dim(saveMat)[3])
      pca_anal <- princomp(saveMat2d)
      pcaMat <- pca_anal$scores[, 1:3]
      pcaRGB <-
        array(pcaMat, dim = c(dim(saveMat)[1], dim(saveMat)[2], 3))
      print("shite")
      pcaRGB1 <- t(pcaRGB[, , 1])
      pcaRGB2 <- t(pcaRGB[, , 2])
      pcaRGB3 <- t(pcaRGB[, , 3])
      pcaRGB <- abind::abind(pcaRGB1, pcaRGB2, pcaRGB3, along = 3)
      pcaRGB <- range01(pcaRGB)
      output$hyperPlot <-
        renderPlot(plot(raster::as.raster(pcaRGB)))
    }
  })
  
  observeEvent(input$plot_click, {
    if (input$clickerMode == "Plot Signal")
    {
      graph_col <- sample.int(255, 3)
      runjs(
        paste(
          'document.getElementById("hyperPlot_brush").style.backgroundColor = "rgb(',
          graph_col[1],
          ',',
          graph_col[2],
          ',',
          graph_col[3],
          ")",
          '"',
          sep = ""
        )
      )
      runjs(
        paste("const hyper_brush2 = document.createElement('div');
          const element = document.getElementById('hyperPlot');
          const to_be_dup = document.getElementById('hyperPlot_brush');
          element.setAttribute('data-brush-clip','FALSE');
          var color = to_be_dup.style.backgroundColor;
          var opacity = to_be_dup.style.opacity;
          var border = to_be_dup.style.border;
          var width = to_be_dup.style.width;
          var height = to_be_dup.style.height;
          var top = to_be_dup.style.top;
          var left = to_be_dup.style.left;
          var position = to_be_dup.style.position;
          
          hyper_brush2.classList.add('hyplots');
          to_be_dup.classList.add('hyplots');
          
          element.appendChild(hyper_brush2);
          hyper_brush2.setAttribute('id','hyper_brush", plot_num,
              "');
          hyper_brush2.style.backgroundColor = color;
          hyper_brush2.style.opacity = opacity;
          hyper_brush2.style.border = border;
          hyper_brush2.style.width = width;
          hyper_brush2.style.height = height;
          hyper_brush2.style.top = top;
          hyper_brush2.style.left = left;          
          hyper_brush2.style.position = position; 
          ",sep = "")
      )
      
      xmin <- ceiling(input$plot_click$xmin)
      xmax <- ceiling(input$plot_click$xmax) 
      ymin <- ceiling(input$plot_click$ymin)
      ymax <- ceiling(input$plot_click$ymax)
      
      if (xmin<=0|xmax<=0|ymin<=0|ymax<=0|xmin>dim(saveMat)[1]|xmax>dim(saveMat)[1]|ymin>dim(saveMat)[2]|ymax>dim(saveMat)[2]|abs(ymax-ymin)<1|abs(xmax-xmin)<1)
      {
        runjs(paste("const element = document.getElementById('hyper_brush", plot_num,"');",
                    "element.remove();",
                    "const element2 = document.getElementById('hyperPlot_brush');",
                    "element2.remove();"
                    ,sep = ""))
        
        return()}
      
      
      # if (xmin<0){xmin <- 0}
      # if(xmax>dim(saveMat)[1]){xmax <- dim(saveMat)[1]}
      # if (ymin<0){ymin <- 0}
      # if(ymax>dim(saveMat)[2]){ymax <- dim(saveMat)[2]}
      
      spec <-
        apply(saveMat[xmin:xmax, ymin:ymax, ], 3, mean)
      if (plot_num == 1) {
        current_hyper_plot <<-
          ggplot() + geom_line(
            aes(x = hdrspare$wavelength, y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          ) + theme_classic() + xlab("Wavelength (nm)") + ylab("Reflectance")
        output$specPlot <- renderPlot(current_hyper_plot)
      }
      else {
        current_hyper_plot <<-
          current_hyper_plot + geom_line(
            aes(x = hdrspare$wavelength, y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          )
        output$specPlot <- renderPlot(current_hyper_plot)
      }
      plot_num <<- plot_num + 1
      print(plot_num)
    }
    else if (input$clickerMode == "Crop"){
      xmin <- ceiling(input$plot_click$xmin)
      xmax <- ceiling(input$plot_click$xmax) 
      ymin <- ceiling(input$plot_click$ymin)
      ymax <- ceiling(input$plot_click$ymax)
      
      if (xmin<=0|xmax<=0|ymin<=0|ymax<=0|xmin>dim(saveMat)[1]|xmax>dim(saveMat)[1]|ymin>dim(saveMat)[2]|ymax>dim(saveMat)[2]|abs(ymax-ymin)<1|abs(xmax-xmin)<1){
        return()
      } else {
        saveMat <<- saveMat[xmin:xmax,(dim(saveMat)[2]-ymax):(dim(saveMat)[2]-ymin),]
        range01 <- function(x) {
          (x - min(x)) / (max(x) - min(x))
        }
        output$hyperPlot <-
          renderPlot(plot(raster::as.raster(range01(t(saveMat[, , which(hdrspare$wavelength == input$slider)])
          ))))
      }
      
    }
  } )
  
  observeEvent(input$clearplots,{
    runjs("
    const plots = document.querySelectorAll('.hyplots');
    
    plots.forEach(hyplots => {
      hyplots.remove();
    });
    ")
    output$specPlot <- renderPlot(ggplot() + theme_classic() + + xlab("Wavelength (nm)") + ylab("Reflectance"))
    plot_num <<- 1
  })
  
}