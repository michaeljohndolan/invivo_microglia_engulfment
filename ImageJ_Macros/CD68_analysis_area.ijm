//Code to calculate the average cd68 signal and area for each microglia 

//Get Main directory 
cropped=getDirectory("Choose the cropped directory"); 

//Make a list of all files under analysis 
list=getFileList(cropped+"/Cd68"); 


for (i=0; i<list.length; i++) {

	//Open the microglial Ilastik segmentations and preprocess 
	print(cropped+"Microglia/SimpleSegmentation/"+list[i]);
	open(cropped+"Microglia/SimpleSegmentation/"+list[i]);
	run("16-bit");
	setThreshold(1, 1);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	run("Fill Holes");
	run("Create Selection");

	//Save the masks 
	saveAs("Tiff", cropped+"Masks/IBA1_MASK"+list[i]);
	rename("microglia");
	close("microglia");

	//Open up the Cd68 channel 
	open(cropped+"Cd68/"+list[i]); 
<<<<<<< HEAD:ImageJ_Macros/CD68_analysis_area.ijm
	//setThreshold(1000, 65534); //(600,12000) was good setting, full range of 16bit is 0 to 65535  
	setAutoThreshold("Moments dark"); //Trialling an autothresholding method
=======
	setThreshold(600, 65534); //(600,12000) was good setting, full range of 16bit is 0 to 65535  
>>>>>>> 448d4385abc517406e4783154b3c55c74eed79b7:CD68_analysis_area.ijm
	run("Create Mask");
	rename(list[i]);

	//Save the CD68  
	saveAs("Tiff", cropped+"Masks/CD68_MASK"+list[i]);
	rename(list[i]);
	
	//Import the ROIs from the microglia mask to phrhodo channel
	//set measurements and measure intensity (area done separately) 
	run("Restore Selection");
	run("Set Measurements...", "area_fraction display redirect=None decimal=3"); 
	run("Measure");	

	//Close the image 
	close(list[i]); 
}
