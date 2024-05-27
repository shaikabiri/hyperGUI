server <- function(input, output, session) {

  range01 <- function(x) {
    (x - min(x)) / (max(x) - min(x))
  }

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
      "saveformat",
      "savewave",
      "DWC",
      "LC",
      "DOS",
      'Scale1',
      'Scale2')
  for (item in toggle_list) {
    shinyjs::disable(item)
  }


  observeEvent(input$shapeRefFile,{
    shapePaths <<- input$shapeRefFile
    file.copy(shapePaths$datapath, paste0("", shapePaths$name))
    shpRows <- which(grepl(".shp",shapePaths$name))
    shapes <<- list()
    p <- 1
    for (i in shpRows){
      shapes[[p]] <<- vect(shapePaths$name[i])
      p <- p + 1
    }
  })

  observeEvent(input$hyperRefFile,{
    hyperPaths <<- input$hyperRefFile
    dat <- read.table(hyperPaths$datapath[1],skip = 2,header = FALSE)
    refHdr <<- dat$V1
    refSPC <<- matrix(nrow = nrow(dat),ncol=(nrow(hyperPaths)))
    for (i in 1:nrow(hyperPaths))
    {
      dat <- read.table(hyperPaths$datapath[i],skip = 2,header = FALSE)
      spec <- dat$V2
      refSPC[,i] <<- as.vector(spec)
    }
  })



  observeEvent(input$hypeType,{
    if (input$hypeType == "aer"){
      shinyjs::hide("file2")
      shinyjs::hide("file3")
      shinyjs::show("hyperRefFile")
      shinyjs::show("shapeRefFile")
      shinyjs::hide("DWC")
      shinyjs::show("LC")

      updateSelectInput(
        session = session,
        inputId = "saveformat",
        choices = c("Raster" = "rast")
      )

    } else if (input$hypeType == "lab")
    {
      shinyjs::show("file2")
      shinyjs::show("file3")
      shinyjs::show("DWC")
      shinyjs::hide("LC")
      shinyjs::hide("hyperRefFile")
      shinyjs::hide("shapeRefFile")

      updateSelectInput(
        session = session,
        inputId = "saveformat",
        choices = c("MATLAB" = "mat", "R" = "r", "Python Numpy" = "numpy"),selected = "mat")
    }
  })

  output$current <- renderText("Load an image")

  source("save_file.R", local = TRUE)
  source("DOS.R", local = TRUE)
  observeEvent(input$file2 , {

    paths <- parsed_path(input$file2)

    hdrpath <- as.character(paths[2])
    imgpath <- as.character(paths[1])

    hdrdark <- readLines(con = hdrpath)
    hdrdark <- header_reader(hdrdark)
    hdrdarkspare <<- hdrdark
    datadark <-
      caTools::read.ENVI(filename = imgpath, headerfile = hdrpath)
    darkmat <<- datadark
    darkmat <<-colMeans(darkmat, dims = 1)
  })

  observeEvent(input$file3 , {

    paths <- parsed_path(input$file3)

    hdrpath <- as.character(paths[2])
    imgpath <- as.character(paths[1])

    hdrwhite <- readLines(con = hdrpath)
    hdrwhite <- header_reader(hdrwhite)
    hdrwhitespare <<- hdrwhite
    datahdrwhite <-
      caTools::read.ENVI(filename = imgpath, headerfile = hdrpath)
    whitemat <<-
      datahdrwhite
    whitemat <<-colMeans(whitemat, dims = 1)

  })

  observeEvent(input$DWC, {
    dataminusdark <- sweep(saveMat , 2:3, darkmat)
    whiteminusdark <- whitemat - darkmat
    saveMat <<- sweep(dataminusdark,2:3,whiteminusdark,FUN = '/')
  })

  observeEvent(input$Scale1, {
    ldim = dim(saveMat)
    dim(saveMat) <- c(ldim[1]*ldim[2],ldim[3])

    for (i in 1:length(hdrspare$wavelength)) {
      saveMat[,i] <- (saveMat[,i] - min(saveMat[,i])) / (max(saveMat[,i]) - min(saveMat[,i]))
    }
    dim(saveMat) <- c(ldim[1],ldim[2],ldim[3])
    saveMat <<- saveMat
    })

  observeEvent(input$Scale2, {
    ldim = dim(saveMat)
    dim(saveMat) <- c(ldim[1]*ldim[2],ldim[3])
    print(hdrspare$width*hdrspare$height)
    for (i in 1:(hdrspare$width*hdrspare$height)) {
      saveMat[i,] <- (saveMat[i,] - min(saveMat[i,])) / (max(saveMat[i,]) - min(saveMat[i,]))
    }
    dim(saveMat) <- c(ldim[1],ldim[2],ldim[3])
    saveMat <<- saveMat
  })


  observeEvent(input$file1 , {
    shinyjs::show("hyperPlot")

    range01 <- function(x) {
      (x - min(x)) / (max(x) - min(x))
    }


      shinyjs::show("hyperPlot")
      paths <- parsed_path(input$file1)
      pathRaw <- input$file1
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

      sliders <- c("slider", "chan1", "chan2", "chan3","spectralslider","pcaslider")
      for (item in sliders)
      {
        updateSliderTextInput(
          session = session,
          inputId = item,
          choices = hdr$wavelength,
        )
      }


      if (input$hypeType=="lab"){
      data <-
        caTools::read.ENVI(imgpath,headerfile = hdrpath)
      sparedata <<- data
      saveData <<- data
      saveMat <<- data
      } else if (input$hypeType=="aer"){
        file.copy(pathRaw$datapath, paste0("", pathRaw$name))
        rst <<- terra::rast(pathRaw$name[grep("hdr",pathRaw$name,ignore.case = T,invert = T)])
        saveMat <<- as.matrix(rst)
        dim(saveMat) <<- dim(rst)
      }


      # vec <- (apply(saveMat, 3, FUN = min))
      # darkmat <<- t(matrix(vec,nrow=length(vec),ncol=hdr$width))
      # vec <- (apply(saveMat, 3, FUN = max))
      # whitemat <<- t(matrix(vec,nrow=length(vec),ncol=hdr$width))
      # saveMat <<- sweep(sweep(saveMat , 1:2, darkmat),1:2,whitemat-darkmat,FUN = '/')
      # data1 <<- data$spc[, which(hdr$wavelength == input$slider)]
      # data1 <<- pracma::Reshape(data1, hdr$height, hdr$width)
      # plot(raster::as.raster(range01(t(data1))))


        if (input$hypeType=="lab"){
          output$hyperPlot <- renderPlot({
            plot(raster::as.raster(range01(t(saveMat[, ,which(hdr$wavelength == input$slider)])
            )))})
        } else if (input$hypeType=="aer"){
          output$hyperPlot <- renderPlot({
            terra::plot(rst,y=which(hdr$wavelength == input$slider))
            })
        }





    output$current <- renderText(input$slider)
    # output$info <- renderText({
    #   paste0("x=",
    #          input$plot_click$coords_css$xmin,
    #          "\ny=",
    #          input$plot_click$ymin)
    # })

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
      shinyjs::hide("pcainfo")
      shinyjs::hide("pcaslider")
      shinyjs::hide("calcPCA")
      shinyjs::hide("pcasave")
      shinyjs::hide("varPCA")
      shinyjs::hide("PCAplot")
      shinyjs::hide("renderBtn")
      if (input$hypeType=="lab"){
        output$hyperPlot <- renderPlot({
          plot(raster::as.raster(range01(t(saveMat[, ,which(hdr$wavelength == input$slider)])
          )))})
      } else if (input$hypeType=="aer"){
        output$hyperPlot <- renderPlot({
          terra::plot(rst,y=which(hdr$wavelength == input$slider))
        })
      }

    } else if (input$displaysel == "rgb") {

      shinyjs::hide("dispoptfp")
      shinyjs::show("dispoptrgb")
      shinyjs::hide("pcainfo")
      shinyjs::hide("pcaslider")
      shinyjs::hide("calcPCA")
      shinyjs::hide("pcasave")
      shinyjs::hide("varPCA")
      shinyjs::hide("PCAplot")
      shinyjs::show("renderBtn")
    } else if (input$displaysel == "pca") {
      range01 <- function(x) {
        (x - min(x)) / (max(x) - min(x))
      }
      shinyjs::show("pcainfo")
      shinyjs::hide("dispoptfp")
      shinyjs::hide("dispoptrgb")
      shinyjs::show("pcaslider")
      shinyjs::show("calcPCA")
      shinyjs::show("pcasave")
      shinyjs::show("varPCA")
      shinyjs::show("PCAplot")
      shinyjs::hide("renderBtn")
    }
  })

  observeEvent(input$renderBtn,{
    if (input$hypeType=="lab"){
      output$hyperPlot <-
        renderPlot(plot(raster::as.raster(range01(
          abind::abind(t(saveMat[, , which(hdrspare$wavelength == input$chan1)]), t(saveMat[, , which(hdrspare$wavelength == input$chan2)]), t(saveMat[, , which(hdrspare$wavelength == input$chan3)]), along = 3)
        ))))
    } else if (input$hypeType=="aer"){
      mat3 <<- abind::abind(saveMat[, , which(hdrspare$wavelength == input$chan1)], saveMat[, , which(hdrspare$wavelength == input$chan2)], saveMat[, , which(hdrspare$wavelength == input$chan3)], along = 3)
      rst3 <<- subset(rst, c(1,2,3))
      mat3 <<- range01(mat3)
      rst3[] <<- mat3
      output$hyperPlot <- renderPlot({
        terra::plot(rst,1,legend=F)
        terra::plotRGB(rst3,scale=1,add=T,stretch="lin")
      })
    }
  })



  observeEvent(input$calcPCA, {
    range01 <- function(x) {
      (x - min(x)) / (max(x) - min(x))
    }
    saveMat2d <<- saveMat[,,which(hdrspare$wavelength == input$pcaslider[1]):which(hdrspare$wavelength == input$pcaslider[2])]
    dim(saveMat2d) <- c(dim(saveMat2d)[1]*dim(saveMat2d)[2] , dim(saveMat2d)[3])
    if (dim(saveMat2d)[1]>dim(saveMat2d)[2])
    {
      pca_anal <<- princomp(saveMat2d)
      cumulPCAvar <<- cumsum(pca_anal$sdev^2 / sum(pca_anal$sdev^2))
      if (max(which(cumulPCAvar<=0.10))!=-Inf)
      {
        pcaSaveMat <<- pca_anal$score[,1:max(which(cumulPCAvar<=as.numeric(input$varPCA)))]
        pcaSaveMat <<- array(pcaSaveMat,c(dim(saveMat)[1],dim(saveMat)[2],max(which(cumulPCAvar<=0.999999))))
      } else {
        pcaSaveMat <<- pca_anal$score[,1]
        pcaSaveMat <<- array(pcaSaveMat,c(dim(saveMat)[1],dim(saveMat)[2],1))
      }
      pcaMat <- pca_anal$scores[, 1:3]
      pcaRGB <-
        array(pcaMat, dim = c(dim(saveMat)[1], dim(saveMat)[2], 3))

      if (input$hypeType=="lab"){
      pcaRGB1 <- t(pcaRGB[, , 1])
      pcaRGB2 <- t(pcaRGB[, , 2])
      pcaRGB3 <- t(pcaRGB[, , 3])
      pcaRGB <- abind::abind(pcaRGB1, pcaRGB2, pcaRGB3, along = 3)
      pcaRGB <- range01(pcaRGB)
      output$hyperPlot <-
        renderPlot(plot(raster::as.raster(pcaRGB)))
      } else if (input$hypeType=="aer") {

        pcaRGB <- range01(pcaRGB)
        rstPCA <<- subset(rst,c(1,2,3))
        rstPCA[] <<- pcaRGB

        output$hyperPlot <- renderPlot({terra::plot(rst,1,legend=F)
          terra::plotRGB(rstPCA,scale=1,add=T,stretch="lin")})
      }
    }
    else {
      output$pcainfo <- renderText(paste("Units cannot be smaller than the number of wavelengths"))
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

      if (input$hypeType == "lab"){
      if (xmin<=0|xmax<=0|ymin<=0|ymax<=0|xmin>dim(saveMat)[1]|xmax>dim(saveMat)[1]|ymin>dim(saveMat)[2]|ymax>dim(saveMat)[2]|abs(ymax-ymin)<1|abs(xmax-xmin)<1)
      {
        runjs(paste("const element = document.getElementById('hyper_brush", plot_num,"');",
                    "element.remove();",
                    "const element2 = document.getElementById('hyperPlot_brush');",
                    "element2.remove();"
                    ,sep = ""))

        return()}


      spec <-
        apply(saveMat[xmin:xmax,(dim(saveMat)[2]-ymax):(dim(saveMat)[2]-ymin),which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], 3, mean)
      if (plot_num == 1) {
        current_hyper_plot <<-
          ggplot() + geom_line(
            aes(x = hdrspare$wavelength[which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          ) + theme_classic(base_size = 30) + xlab("Wavelength (nm)") + ylab("Reflectance")
        output$specPlot <- renderPlot(current_hyper_plot,height = 500,width = 550)

      }
      else {
        current_hyper_plot <<-
          current_hyper_plot + geom_line(
            aes(x = hdrspare$wavelength[which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          )
        output$specPlot <- renderPlot(current_hyper_plot,height = 500,width = 550)
      }
      plot_num <<- plot_num + 1
      print(plot_num)
    } else if (input$hypeType == "aer"){
      rstext <- ext(rst)
      if (xmin<rstext[1]|xmax<rstext[1]|ymin<rstext[3]|ymax<rstext[3]|xmin>rstext[2]|xmax>rstext[2]|ymin>rstext[4]|ymax>rstext[4]|abs(ymax-ymin)<1|abs(xmax-xmin)<1)
        {
        runjs(paste("const element = document.getElementById('hyper_brush", plot_num,"');",
                    "element.remove();",
                    "const element2 = document.getElementById('hyperPlot_brush');",
                    "element2.remove();"
                    ,sep = ""))

        return()}
      temp <- crop(rst,c(xmin,xmax,ymin,ymax))
      temp1 <- terra::as.matrix(temp)
      dim(temp1) <- dim(temp)
      remove(temp)
      spec <- apply(temp1[,,which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], 3, mean)
      if (plot_num == 1) {
        current_hyper_plot <<-
          ggplot() + geom_line(
            aes(x = hdrspare$wavelength[which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          ) + theme_classic(base_size = 30) + xlab("Wavelength (nm)") + ylab("Reflectance")
        output$specPlot <- renderPlot(current_hyper_plot,height = 500,width = 550)

      }
      else {
        current_hyper_plot <<-
          current_hyper_plot + geom_line(
            aes(x = hdrspare$wavelength[which(hdrspare$wavelength == input$spectralslider[1]):which(hdrspare$wavelength == input$spectralslider[2])], y = spec),
            color = rgb(graph_col[1], graph_col[2], graph_col[3], maxColorValue = 255)
          )
        output$specPlot <- renderPlot(current_hyper_plot,height = 500,width = 550)
      }
      plot_num <<- plot_num + 1
      print(plot_num)
    }

}



    else if (input$clickerMode == "Crop"){
      xmin <- ceiling(input$plot_click$xmin)
      xmax <- ceiling(input$plot_click$xmax)
      ymin <- ceiling(input$plot_click$ymin)
      ymax <- ceiling(input$plot_click$ymax)
      if (input$hypeType == "lab"){
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
      }} else if (input$hypeType == "aer"){
        rstext <- ext(rst)
        if (xmin<rstext[1]|xmax<rstext[1]|ymin<rstext[3]|ymax<rstext[3]|xmin>rstext[2]|xmax>rstext[2]|ymin>rstext[4]|ymax>rstext[4]|abs(ymax-ymin)<1|abs(xmax-xmin)<1){
          return()
        } else {
        rst <<- crop(rst,c(xmin,xmax,ymin,ymax))
        saveMat <<- as.matrix(rst)
        dim(saveMat) <<- dim(rst)
        }
      }
    }
  }
  )

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

  observeEvent(input$varPCA,{
    if (exists("cumulPCAvar")){
    if (max(which(cumulPCAvar<=0.10))!=-Inf)
    {
     pcaSaveMat <<- pca_anal$score[,1:max(which(cumulPCAvar<=as.numeric(input$varPCA)))]
     pcaSaveMat <<- array(pcaSaveMat,c(dim(saveMat)[1],dim(saveMat)[2],max(which(cumulPCAvar<=0.999999))))
    } else {
      pcaSaveMat <<- pca_anal$score[,1]
      pcaSaveMat <<- array(pcaSaveMat,c(dim(saveMat)[1],dim(saveMat)[2],dim(pcaSaveMat)[2]))
    }
  } })

  observeEvent(input$PCAplot,{
    pcaVarvar <<- pca_anal$sdev^2 / sum(pca_anal$sdev^2)
    output$specPlot <- renderPlot((ggplot() + geom_line(aes(y=log(pcaVarvar),x=1:length(pcaVarvar))) +
                                     geom_point(aes(y=log(pcaVarvar),x=1:length(pcaVarvar)),size=4)+
                                     xlab("No. of component") +
                                     ylab("log(Proportion of variance explained)")+
                                     theme_classic(base_size = 30)),height = 500,width = 550)
  })

  observeEvent(input$DOS,{
    saveMat <<- DOS(saveMat)
    if (input$hypeType == "aer"){
      rst[] <<- saveMat
    }
  })

  observeEvent(input$LC,{
    extractedSPC <- lapply(shapes,terra::extract,x=rst)
    meansSPC <- sapply(extractedSPC ,FUN = function(x) {apply(x,MARGIN=2,FUN=median)})
    meansSPC <- meansSPC[-1,]
    commonWave <- which(hdrspare$wavelength%in%refHdr)
    meansSPC <- meansSPC[commonWave,]

    sliders <- c("slider", "chan1", "chan2", "chan3","spectralslider","pcaslider")

    for (item in sliders)
    {
      updateSliderTextInput(
        session = session,
        inputId = item,
        choices = hdrspare$wavelength[commonWave]
      )
    }

    hdrspare$wavelength <<- hdrspare$wavelength[commonWave]

    rst <<- subset(rst,commonWave)
    saveMat <<- saveMat[,,commonWave]
    R2 <<- vector(length = dim(saveMat)[3])
    for (i in 1:nrow(meansSPC))
    {
      reg <- lm(refSPC[i,]~meansSPC[i,]+0)
      R2[i] <<- summary(reg)$adj.r.squared
      saveMat[,,i] <<- saveMat[,,i]*reg$coefficients[1]
      print(i)
      gc()
    }
    #
    rst[] <<- saveMat
    R2plot <- ggplot() + geom_col(aes(x=hdrspare$wavelength,y=R2)) + theme_classic(base_size = 30) + xlab("Wavelength (nm)") + ylab(quote(R**2))

    output$specPlot <- renderPlot(R2plot,height = 500,width = 550)

  })




}
