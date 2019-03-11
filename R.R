#### Libs ####
libs <- c('matrixStats', 'viridis', 'GGally', 'cowplot', 'data.table', 'methods', 'lubridate', 'ggplot2', 'scales', 'gridExtra', 'knitr', 'kableExtra', 'PerformanceAnalytics', 'gplots')
null <- suppressMessages(sapply(libs, library, character.only=TRUE))
options(dplyr.width = Inf)
options(stringsAsFactors = FALSE)
options(timeout = 300)
options(width = 160)

mytheme <- theme(legend.position = c(0.4, 0.15),
      legend.text=element_text(size=10, face="bold"),
      axis.text = element_text(size=12, face="bold"),
      axis.title = element_text(size=14, face="bold"),
      # axis.title.y = element_blank(),
      # legend.key = element_rect(colour = "transparent", fill = "transparent"),
      # legend.background=element_blank(),
      strip.text = element_text(size = 12, face="bold"))
    
p1 <- ggplot(df_pnl_daily, aes(x=date, y=cumpnl)) + 
    geom_line() + 
    scale_y_continuous(labels = dollar) +
    annotation_custom(grob=a, xmax=df_pnl_daily[, median(date)], ymin=0.7*df_pnl_daily[, max(cumpnl)]) +
    theme_bw() + 
    mytheme

plot_grid(p1, p2, p3, ncol=1, align="v")
