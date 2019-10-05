//Code to extract the microglia channel and save it separately for Ilastik processing 

//Get Input directory 
CroppedData=getDirectory("Choose the cropped directory"); 
list=getFileList(CroppedData);

//Open each image and extract the channels 
for (i=0; i<list.length; i++) {
	open(CroppedData+"/"+list[i]); //Open each individual simple segmentation 
	run("Z Project...", "projection=[Standard Deviation]");
	run("Split Channels");

	names= getList("image.titles");
	for(j=0;j<names.length;j++){ 
		
		if(startsWith(names[j],"C2" )) {
					selectWindow(names[j]);
					saveAs("Tiff", CroppedData+"Cd68/"+list[i]);
					print(CroppedData+"Cd68/"+list[i]);
					close();
					}
		if(startsWith(names[j],"C1" )) {
					selectWindow(names[j]);
					saveAs("Tiff", CroppedData+"Microglia/"+list[i]);
					print(CroppedData+"Microglia/"+list[i]);
					close();
		} 

	}
	close();
    close();
    close();
}