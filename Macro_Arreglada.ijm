//Macro with several ERRORs Fixed (indicated)

//Get directories
dirImages=getDirectory("Choose the Directory containing the images");
dirFinal=getDirectory("Choose the Directory to move the image");
dirTables=getDirectory("Choose the Directory to save the tables");

//Ask the user about saving or not ROIs
saveRois=getBoolean("Do you want to save your ROIs?");

//  *** ERROR ON LINE 12 (boolean expression needed) ***
//if (saveRois=true) dirRois=getDirectory("Choose the Directory to save ROIs");
if (saveRois==true) dirRois=getDirectory("Choose the Directory to save the ROIs");

// Read Images
Files=getFileList(dirImages);
print("List of Images to analyze");
Array.print(Files);

//  **** ERROR ON LINE 21 (something should be changed to make it work) ***
//for (i=0; i==Files.length; i++){
for (i=0; i<Files.length; i++){
	//imagepath is the address in your computer of the image to be opened (composed by the address of the Folder selected by the user + the name of the file)
	imagepath=dirImages+Files[i];
	
	//Open images of the Array Files
	
//  **** ERROR ON LINE 29 (a string operator missing) ***
	//run("Bio-Formats Importer", "open=["+ imagepath  "] color_mode=Grayscale open_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats Importer", "open=["+ imagepath + "] color_mode=Grayscale open_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//call to the function to analyze the images
	work();
	
	//Rois Management
	if (saveRois==true) {
		//call to the function to save ROIs
		roiSave(dirRois, Files[i]);
	}
	else{
		//Eliminate ROIs
		roiManager("reset");
// *** ERROR ON ELSE EXPRESSION (something needed to close it) ***
	}
	//call to the function to save Results Table with the name of the image (Files[i]) in the folder selected by the user (dirTables)
	resultsSave(dirTables, Files[i]);

	//move the original image from one folder (dirImages) to another (dirFinal) with its original name (Files[i])
	imagepath2=dirFinal+Files[i];
	File.rename(imagepath, imagepath2);
	
	print("");
	print ("File "+ Files[i]);
	print("moved from folder "+dirImages);
	print("to folder "+dirFinal);
	
	//Close images
	run("Close All");
}

//Functions


//This function may be modified change the type of analysis
function work(){
	//Open a window and gives time to the user to do whatever he/she wants
	waitForUser("Draw ROIs and add to the ROI Manager with t");
	
	//count the number of Rois (not used indeed here, but quite useful)
	roisnumber=roiManager("count");

	//Open Channels Tool
	run("Channels Tool...");

	//Open Threshold Tool
	run("Threshold...");

	//Give the opportunity to select a channel and set the Threshold for quantification
	waitForUser ("Select the channel where you want to measure and set the Threshold");
	
	//deselect ROIs to be able to measure all at once
	roiManager("deselect");

	//Set the Measurement area fraction
	run("Set Measurements...", "area_fraction redirect=None decimal=2");
	
	//Mesure all selected ROIs or all ROIs if no ROI is selected
	roiManager("Measure");	 
}


//Function to Save ROIs
function roiSave(roipath, roiname){
	//deselect ROIs to be able to save all in a zip file
	roiManager("deselect");

	//Save ROIs
	roiManager("save", roipath+roiname+".zip");

	//Eliminate ROIs from the Roi Manager
	roiManager("reset");

	print("");
	print("ROIs saved as "+ roiname+".zip");
	print("in the folder "+roipath);
}

//Function to Save Results
function resultsSave(tabpath, tabname){
	//Select the table "Results"
	selectWindow("Results");

	//Save the selected Table as a xls file with the name tabname=Files[i]+.xls and in the folder tabpath=dirTables
	saveAs("Results", tabpath+tabname+".xls");

	//Close the selected table
	run("Close");

	print("");
	print("Results table saved as "+tabname+".xls");
	print("in the folder "+tabpath);
}
