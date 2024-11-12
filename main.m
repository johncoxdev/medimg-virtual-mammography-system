%{
    0) Implement a GUI that will be able to change the parameters to
    control data acquisition, view reconstructed images, and perform 
    "simple analysis"
        0.1) Use a 2D-phantom for testing/validation, to make sure that the
        algorithm works. The 3D-phantom will be used for the simulation of
        the breast mammography.
    
    ----------Actual Specifics----------
    1. Create functions/code that can
        1.1) Generate the phantom
        1.2) Adjust the geometric and the acquisition params.
        1.3) Generate a 1D profile of the 2D phantom. and 2D image for the
        3D phatom
    2. Implement the GUI that combines those pieces of code and performs
    the different task
    3. Be able to change the control of your x-ray, this includes, the
    energy of the beam, the x-ray angle, the distance of the film, and the
    source of the phantom.
    4. Generate a profile of the test phantom and verify that your
    algorithms work correctly when:
        4.1) Change the distance between source, film, and phantom
        4.2) Change the __ values of the two structures
        4.3) Change the angle of the x-ray; what is the effect?

    ****Time to work on Human Portion****

    5. Create the phantom in 3D as a 3D matrix
        - Breast Project: will be rounded edge 3d structure with a sphere at
        its center that simulates the bone.
    6. Expand the code that allows to generate 2D images from your 3D
    phantom.
    7. Once you get the rest working, answer the questions
        7.1) What is the contrast of the cancerous lesion relative to the
        rest of the tissue?
        7.2) Can you see clearly the cancer?
        7.3) Now compress the breast by reducing the width of your phantom.
        What is the effect of this? Quantify the effect you may have

    
%}