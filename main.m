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
%% GUI for X-Ray Simulator with Dynamic Projection Scaling
function xray_simulator_gui()
    % Create the figure
    f = figure('Name', 'X-Ray Simulator', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
    
    % Add sliders for parameters
    uicontrol(f, 'Style', 'text', 'Position', [50, 500, 100, 20], 'String', 'X-Ray Angle');
    angle_slider = uicontrol(f, 'Style', 'slider', 'Position', [50, 470, 100, 20], ...
                             'Min', 0, 'Max', 180, 'Value', 0, ...
                             'Callback', @(~, ~) update_visualization());
                         
    uicontrol(f, 'Style', 'text', 'Position', [200, 500, 100, 20], 'String', 'Distance');
    distance_slider = uicontrol(f, 'Style', 'slider', 'Position', [200, 470, 100, 20], ...
                                'Min', 0.5, 'Max', 2, 'Value', 1, ...
                                'Callback', @(~, ~) update_visualization());
    
    % Axes to display 3D Phantom and 2D Projection
    ax3d = axes(f, 'Position', [0.05, 0.1, 0.4, 0.6]); % For 3D phantom
    ax2d = axes(f, 'Position', [0.55, 0.1, 0.4, 0.6]); % For 2D projection
    
    % Base phantom size
    base_size = 100;
    mu_values = [0, 0.5, 1.0];
    
    function update_visualization()
        % Get the slider values
        angle = angle_slider.Value;
        scale_factor = distance_slider.Value; % Scale factor for perceived distance
        
        % Generate the phantom
        phantom = generate_3d_phantom(base_size, false);
        
        % Simulate the X-ray projection
        projection = simulate_xray(phantom, mu_values, angle);
        
        % Scale the projection size
        scaled_projection = imresize(projection, 1 / scale_factor, 'nearest');
        
        % Add padding to create the black space
        padding_size = round((size(projection, 1) - size(scaled_projection, 1)) / 2);
        padded_projection = padarray(scaled_projection, [padding_size, padding_size], 0, 'both');
        
        % Ensure the padded projection matches the original display size
        padded_projection = imresize(padded_projection, [size(projection, 1), size(projection, 2)], 'nearest');
        
        % Update 3D visualization
        axes(ax3d);
        cla(ax3d);
        slice(ax3d, phantom, size(phantom, 2) / 2, size(phantom, 1) / 2, size(phantom, 3) / 2);
        colormap(ax3d, 'gray');
        title(ax3d, sprintf('3D Phantom (Distance Factor: %.2f)', scale_factor));
        axis(ax3d, 'equal');
        
        % Update 2D projection visualization
        axes(ax2d);
        cla(ax2d);
        imshow(padded_projection, [], 'Parent', ax2d);
        colormap(ax2d, 'gray');
        title(ax2d, sprintf('Projection (Angle: %.0f, Distance Factor: %.2fx)', angle, scale_factor));
    end
    
    % Display the initial projection
    update_visualization();
end

%% Helper Functions

% Generate 3D Phantom
function phantom = generate_3d_phantom(size, is_leg)
    [x, y, z] = meshgrid(1:size, 1:size, 1:size);
    phantom = zeros(size, size, size);
    
    center = size / 2;
    if is_leg
        % Leg: Tissue and Tumor Cylinders
        tissue_radius = size / 3;
        bone_radius = size / 6;
        distance = sqrt((x - center).^2 + (y - center).^2);
        phantom(distance <= tissue_radius) = 1; % Tissue
        phantom(distance <= bone_radius) = 2;  % Tumor/Bone
    else
        % Breast: Spherical Tumor
        breast_radius = size / 3;
        tumor_radius = size / 10;
        distance = sqrt((x - center).^2 + (y - center).^2 + (z - center).^2);
        phantom(distance <= breast_radius) = 1; % Breast
        phantom(distance <= tumor_radius) = 2;  % Tumor
    end
end

% Simulate X-Ray Projection
function projection = simulate_xray(phantom, mu_values, angle)
    % Rotate the phantom based on the specified angle
    rotated_phantom = imrotate3(phantom, angle, [0 1 0], 'crop');
    
    % Assign attenuation values based on material type
    attenuation = zeros(size(rotated_phantom));
    for material = 0:2
        attenuation(rotated_phantom == material) = mu_values(material + 1);
    end
    
    % Sum along the Z-axis to simulate the X-ray projection
    projection = sum(attenuation, 3);
end


xray_simulator_gui();

