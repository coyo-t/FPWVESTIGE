hog = file_hog_load("test2.hog");

mdltest = model_load_cog(hog.get_file("cog model"), true);

sdm(hog.get_file("text file"));

hog.free();
delete hog;

index = 0;
