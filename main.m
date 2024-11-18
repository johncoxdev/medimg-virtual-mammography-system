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
        4.3) Change the angle o f the x-ray; what is the effect?

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
%% 2D Phantom Generation
function phantom = generate_2d_phantom(size)
    phantom = zeros(size);
    phantom(size/4:3*size/4, size/3:2*size/3) = 1; % Rectangle
    figure;
    imshow(phantom, []);
    title('2D Phantom');
end
%%
function phantom = generate_3d_phantom(size, is_leg)
    [x, y, z] = meshgrid(1:size, 1:size, 1:size);
    phantom = zeros(size, size, size);
    
    center = size / 2;
    if is_leg
        % Leg: Tissue and Bone Cylinders
        tissue_radius = size / 3;
        bone_radius = size / 6;
        distance = sqrt((x - center).^2 + (y - center).^2);
        phantom(distance <= tissue_radius) = 1; % Tissue
        phantom(distance <= bone_radius) = 2;  % Bone
    else
        % Breast: Spherical Tumor
        breast_radius = size / 3;
        tumor_radius = size / 10;
        distance = sqrt((x - center).^2 + (y - center).^2 + (z - center).^2);
        phantom(distance <= breast_radius) = 1; % Breast
        phantom(distance <= tumor_radius) = 2;  % Tumor
    end
    
    figure;
    slice(phantom, size/2, size/2, size/2);
    title('3D Phantom');
    colormap('gray');
end
%% Simulate x-ray
function projection = simulate_xray(phantom, mu_values)
    % phantom: 3D array
    % mu_values: [mu_air, mu_tissue, mu_bone]
    attenuation = zeros(size(phantom));
    
    for material = 0:2
        attenuation(phantom == material) = mu_values(material + 1);
    end
    
    % Summing along the Z-axis for the projection
    projection = sum(attenuation, 3);
    
    figure;
    imshow(projection, []);
    title('X-Ray Projection');
    colormap('gray');
end

%% GUI 
function xray_simulator_gui()
    % Create the figure
    f = figure('Name', 'X-Ray Simulator', 'NumberTitle', 'off', 'Position', [100, 100, 500, 400]);
    
    % Add sliders for parameters
    uicontrol(f, 'Style', 'text', 'Position', [50, 330, 100, 20], 'String', 'X-Ray Angle');
    angle_slider = uicontrol(f, 'Style', 'slider', 'Position', [50, 300, 100, 20], 'Min', 0, 'Max', 180, 'Value', 0);

    uicontrol(f, 'Style', 'text', 'Position', [200, 330, 100, 20], 'String', 'Distance');
    distance_slider = uicontrol(f, 'Style', 'slider', 'Position', [200, 300, 100, 20], 'Min', 10, 'Max', 200, 'Value', 50);

    % Button to update projection
    uicontrol(f, 'Style', 'pushbutton', 'Position', [350, 300, 100, 30], 'String', 'Update Projection', ...
              'Callback', @(~, ~) update_projection(angle_slider.Value, distance_slider.Value));
          
    % Axes to display projection
    ax = axes(f, 'Position', [0.1, 0.1, 0.8, 0.5]);
    
    function update_projection(angle, distance)
        % Update projection based on slider values
        % Example: Regenerate phantom and simulate x-ray
        phantom = generate_3d_phantom(100, false);
        mu_values = [0, 0.5, 1.0];
        projection = simulate_xray(phantom, mu_values); % Call simulation code here
        
        % Display projection
        imshow(projection, 'Parent', ax);
        title(ax, sprintf('Projection (Angle: %.0f, Distance: %.0f)', angle, distance));
    end
end
xray_simulator_gui()