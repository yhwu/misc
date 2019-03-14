#### Libs ####
libs <- c('tibble', 'ggpmisc', 'matrixStats', 'viridis', 'GGally', 'cowplot', 'data.table', 'methods', 'lubridate', 'ggplot2', 'scales', 'gridExtra', 'knitr', 'kableExtra', 'PerformanceAnalytics', 'gplots')
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


#### facet, annotation table ####
## requires 'tibble', 'ggpmisc'
rtos <- df1[, unique(rto)]
my.tb <- tibble(rto = rtos,
                date = as_date("2017-01-01"), 
                cumpnl = df1[, max(cumpnl), by=c('rto')][rtos, V1, on='rto'],
                tb = lapply(rtos, function(r) as.tibble(as.data.table(format(df_info[rto==r], digits=2, big.mark = ",", justify='right')))) )
ggplot(df1, aes(x=date, y=cumpnl, color=set)) + 
    geom_line(size=1.2) + 
    scale_y_continuous(labels = dollar) +
    facet_wrap(~ rto, scales = "free_y") +
    geom_table(data=my.tb, mapping = aes(date, cumpnl, label = tb), inherit.aes = FALSE, vjust=1, hjust=0, size=1) +
    theme_bw() +
    mytheme

pngfile <- "C:/tmp/pnl.png"
ggsave(filename = pngfile, width = 14, height = 10, units = "in")
print(pngfile)
                            
