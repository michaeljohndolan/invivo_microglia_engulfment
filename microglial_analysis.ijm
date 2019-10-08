//Code to calculate the average cd68 signal and area for each microglia 
run("Clear Results");

//Get Main directory 
cropped=getDirectory("Choose the cropped directory"); 

//Make a list of all files under analysis 
list=getFileList(cropped+"/Cd68"); 


for (i=0; i<list.length; i++) {

	//Open the microglial Ilastik segmentations and preprocess 
	open(cropped+"Microglia/SimpleSegmentation/"+list[i]);
	rename("microglia");
	run("16-bit");
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Erode");
	run("Dilate");
	run("Fill Holes");
	
	//Produce the ROIs for intensity analysis 
	run("ROI Manager..."); //Start up the ROI manager 
	run("Analyze Particles...", "size=500-Infinity show=Overlay add in_situ");
	close("microglia");

	//Open up the Cd68 channel 
	open(cropped+"Cd68/"+list[i]); 

	//Import the ROIs from the microglia mask to phrhodo channel
	//set measurements and measure intensity (area done separately) 
	run("From ROI Manager");
	run("Set Measurements...", "mean display redirect=None decimal=3"); 
	roiManager("Measure");
	
	//Delete the accumulated ROIs and close the image 
	roiManager("Delete");
	close(list[i]); 
}




