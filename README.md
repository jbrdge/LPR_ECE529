# LPR_ECE529
My Final project for DSP ECE 529 at the University of Arizona. On a high level, the project consists of two stages. The first stage, uses image processing techniques to locate license plate characters in an image. The second stage is classification of the characters using neural networks. Intermediate to the two stages, 

#Description
Using a small base set of characters, 
the Matlab code can be utilized to add a variety of filters
to the data and generate a large amount of data. 
There are two separate Matlab code files for filtration.

The python code utilizes keras to generate a neural 
network model for data evaluation.

The final program runs in Matlab. The license plate detection 
identifies the plate location using morphological operators. 
Then, the program uses edge detection to locate characters. 
And finally, it uses the neural network model to identify 
the characters.

#SaveCSV converts set of images indexed by folder into a csv

See paper for details.
