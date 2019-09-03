//Read in microglia (IBA-1 stain) and analyze the CD68 stain by intensity. 
//This should be run on 60x microglia z-stacks that have been cropped manually to contain only the cell of interest 


//Clear residual results     
run("Clear Results");

//Get Main directory and make a file list 
maindir=getDirectory("Choose the cropped microglia image directory"); 
list=getFileList(maindir); 

//Select an output directory
output=getDirectory("Choose an output Directory");

//Run analysis loop, opening each tif file:
for (i=0; i<list.length; i++) {
	print(i);
	open(maindir+list[i]);
	run("Select None");
	run("Z Project...", "projection=[Standard Deviation]");
	close(list[i]);
	run("Split Channels");
	
	//Rename the channels to constant nomenclature 
	names=getList("image.titles");
	for (j=0;j<names.length;j++) {
		if(startsWith(names[j],"C1" )) {
		selectWindow(names[j]);
		rename("Cd68");
		}
		if(startsWith(names[j],"C2" )) {
		selectWindow(names[j]); 
		close();
		}
		if(startsWith(names[j],"C3" )) {
		selectWindow(names[j]); 
		rename("Iba1");
		}
		if(startsWith(names[j],"C4" )) {
		selectWindow(names[j]); 
		close();
		}
	}
	//Select the Iba1 stain 
	selectWindow("Iba1");
	run("Subtract Background...", "rolling=30");
	setAutoThreshold("Li dark");  //Tried moments and Isodata but they were too restrictive 
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	run("Create Selection");
	
	//Save these stains to the output directory 
	save(output+"IBA1_MASK_"+list[i]+".tif");

	//Select the outline of the microglia and use it to identify cell in Cd68 image
	selectWindow("Cd68");
	rename(list[i]);
	run("Restore Selection");
	run("Set Measurements...", "area mean min display redirect=None decimal=3");
	run("Measure");	
	close(list[i]);
	close("Iba1");
}

