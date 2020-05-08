

library("rmarkdown")
params
rm(params)
#getwd()
# "C:/Hatfield/scripts/R/Projects/Meso/occupancy/SC_Results_toGit/SC_Mode_2017_Results"
#sc.out.2018<-readRDS('./data/out/SC_fm_results_2018_allSpecies_list_20200407.Rdata')
#str(sc.out.2018)
# setwd("C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear")

#data.year<-'2018'
render.file<-"C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear/rmarkdown/SC_results/model_results_summary_14mods_lureInt_passes.Rmd"
#out.file.path<-"./2017_results_SC/"
# out.file.path<-"C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear/rmarkdown/SC_results/2018_results_SC/20200505_14models_350000iter_passes"
out.file.path<-"C:/Hatfield/scripts/R/Projects/Meso/occupancy/SC_Results_toGit/SC_model_2017"

#meta.in<-'C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear/data/out/SC_results_files_2018/metadata/SC_model_meta_2018.Rdata'
# readRDS(meta.in)
files.loop<-list.files('C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear/data/out/SC_output/fm_models_out/2017', 
                       full.names = T)
files.loop<-files.loop[grepl('Bobcat',files.loop) | grepl('LongTail',files.loop)]

# loop.species<-readRDS(meta.in)
# loop.species<-names(loop.species$all.y.long)
# names(files.loop)<-loop.species


##################################################################################
## run in for each loop
loop.sc.results(render.file = render.file,
                files.loop = files.loop, 
                out.file.path = out.file.path)
##################################################################################

# i=1
for(i in 4:length(files.loop)){
  for(i in 1:3){  
  sp.out<-names(files.loop[i])
  file<-files.loop[[i]]
  file<-paste0('../.',file)
  # file<-file.path(getwd(),file)
  render(render.file,
         output_file=paste0(out.file.path, sp.out,data.year, ".html"),
         params=list(model.results = file,
                     model.year = data.year,
                     model.species = sp.out,
                     model.meta=paste0('../.',meta.in)
                     ))
}


####################################################################################
### do par
#  i = 1
loop.sc.results<-function(render.file = render.file,
                          files.loop = files.loop, 
                          out.file.path = out.file.path){

  library(doSNOW)
  library(foreach)

  nw <- 7  # number of workers
  cl <- makeSOCKcluster(nw)
  registerDoSNOW(cl)
  
  #i=1
  foreach(i = 1:length(files.loop)) %dopar% {
  # foreach(i = 1:3) %dopar% {
    library(rmarkdown)
    in.path<-files.loop[[i]]
    metadata<-readRDS(file.path(in.path,'model.metadata.RDS'))
    data.year<-metadata$data.year
    sp.out<-metadata$species
    #file<-paste0('../.',file)
    # file<-file.path(getwd(),file)
    render(render.file,
           output_file=file.path(out.file.path, paste0(sp.out,data.year, ".html")),
           params=list(model.path = in.path
           ))
  } 
  stopCluster(cl)
  # gc()
}
  



  


## render single file
year.out<-2017
sp.out<-'AmericanBadger'
in.file<-"./data/out/SC_fm_results_2017_AmericanBadger_20200410.Rdata"
in.file<-paste0('../.',in.file)
out.file<-'C:/Hatfield/scripts/R/Projects/Meso/occupancy/MesoResults_Occ_SC_Plots/test.2'
out.file<-file.path(out.file, paste0("results_SC_",year.out,'_', sp.out, "2.html"))
render('C:/Hatfield/scripts/R/Projects/Meso/occupancy/OccEstimatesbyYear/rmarkdown/SC_results/model_results_summary_2017_10models.Rmd',
       output_file=out.file,
       params=list(model.results = in.file,
                   model.year = year.out,
                   model.species = sp.out
       ))
