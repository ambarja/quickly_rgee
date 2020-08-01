#' Obtaining an available images collection for landsat 1:8 in rgee
#' @author : Antony Barja

# Obtaining available images  ---------------------------------------------

img_available <- function(id, path, row, cloud){
  options(dplyr.summarise.inform = FALSE)
  lista <- list()
  for(i in 1:length(id)){
    images <- ee$ImageCollection(id[i])$
      filter(ee$Filter$eq('WRS_PATH',path))$
      filter(ee$Filter$eq('WRS_ROW',row))$
      filterMetadata('CLOUD_COVER','less_than',cloud)
    
    ee_get_date_ic(images) %>% 
      as_tibble() %>%
      separate(time_start, into = c('anio','mes','dia'), sep = '-') %>%
      group_by(anio, mes, .drop=FALSE) %>%
      summarise(total = as.integer(table(mes))) %>% 
      mutate(type = str_sub(id[i], start = 9, end = 12)) -> images_date
    
    lista[[i]] <- images_date
    lista_end <- do.call(rbind, lapply(lista, function(x) as.data.frame((x))))
  }
  return(lista_end)
}

# Viewing avaible images --------------------------------------------------

plot_available_img <- function(name,img_available){
  
  plot_img <- img_available %>% 
    ggplot(aes(x = anio , y = factor(mes, labels = month.abb))) + 
    geom_raster(aes(fill = type), alpha = 0.7) + 
    geom_point(aes(size = factor(total)),color = 'black') +
    geom_point(shape = 21 , color = 'white', size = 3) + 
    scale_fill_viridis_d('Type', direction = -1, option = 'plasma') +
    theme_minimal()  + 
    theme() + 
    labs(title = paste0('A set of available images of ',name),
         x = '',
         y = '',
         size = 'Total \nimages')
  print(plot_img)
}

# Exporting plot ----------------------------------------------------------

save_available_img <- function(x){
  ggsave(filename = x,
         plot = last_plot(),
         width = 12,
         height = 4) 
}
