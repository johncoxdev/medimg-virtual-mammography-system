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
function xray_simulator_gui()
    % Create the figure
    f = figure('Name', 'X-Ray Simulator', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 600]);
    
    % Add sliders and text in a vertical column layout
    
    % X-Ray Angle
    uicontrol(f, 'Style', 'text', 'Position', [50, 550, 100, 20], 'String', 'X-Ray Angle');
    angle_slider = uicontrol(f, 'Style', 'slider', 'Position', [150, 550, 100, 20], ...
                             'Min', 0, 'Max', 180, 'Value', 0, ...
                             'Callback', @(~, ~) update_visualization());
    
    % Distance
    uicontrol(f, 'Style', 'text', 'Position', [50, 500, 100, 20], 'String', 'Distance');
    distance_slider = uicontrol(f, 'Style', 'slider', 'Position', [150, 500, 100, 20], ...
                                'Min', 0.5, 'Max', 2, 'Value', 0.5, ...
                                'Callback', @(~, ~) update_visualization());
    
    % Beam Energy
    uicontrol(f, 'Style', 'text', 'Position', [50, 450, 100, 20], 'String', 'Beam Energy (keV)');
    energy_slider = uicontrol(f, 'Style', 'slider', 'Position', [150, 450, 100, 20], ...
                              'Min', 20, 'Max', 50, 'Value', 30, ...
                              'Callback', @(~, ~) update_visualization());

    % Number of Tumors
    uicontrol(f, 'Style', 'text', 'Position', [50, 400, 100, 20], 'String', 'Num Tumors');
    num_tumors_input = uicontrol(f, 'Style', 'edit', 'Position', [150, 400, 100, 20], ...
                                  'String', '1', 'Callback', @(~, ~) update_visualization());
    
    % Tumor Size
    uicontrol(f, 'Style', 'text', 'Position', [50, 350, 100, 20], 'String', 'Tumor Size');
    tumor_size_input = uicontrol(f, 'Style', 'edit', 'Position', [150, 350, 100, 20], ...
                                  'String', '5', 'Callback', @(~, ~) update_visualization());
    
    % Axes to display 3D Phantom and 2D Projection
    ax3d = axes(f, 'Position', [0.05, 0.1, 0.4, 0.6]); % For 3D phantom
    ax2d = axes(f, 'Position', [0.55, 0.1, 0.4, 0.6]); % For 2D projection
    
    % Base phantom size
    base_size = 100;
    
    % Predefined tumor locations (up to 5)
    fixed_tumor_locations = [
        50, 50, 50;  % Tumor 1
        30, 30, 30;  % Tumor 2
        70, 30, 70;  % Tumor 3
        40, 40, 40;  % Tumor 4
        30, 50, 30   % Tumor 5
    ];
    
    function update_visualization()
        % Get the slider values
        angle = angle_slider.Value;
        scale_factor = distance_slider.Value; % Scale factor for perceived distance
        energy = energy_slider.Value; % X-ray beam energy in keV
        
        % Get the user input values for number of tumors and tumor size
        num_tumors = str2double(num_tumors_input.String);  % Convert string to number
        tumor_size = str2double(tumor_size_input.String);  % Convert string to number
        
        % Ensure that the number of tumors is between 1 and 5
        num_tumors = min(max(num_tumors, 1), 5); % Limit to between 1 and 5
        
        % Use the predefined tumor locations, limit to 'num_tumors'
        tumor_centers = fixed_tumor_locations(1:num_tumors, :);
        tumor_sizes = repmat(tumor_size, num_tumors, 1);
        
        % Calculate attenuation coefficients based on energy
        mu_values = calculate_attenuation(energy); 
        
        % Generate the phantom with tumors
        phantom = generate_3d_phantom(base_size, num_tumors, tumor_sizes, tumor_centers);
        
        % Simulate the X-ray projection
        projection = simulate_xray(phantom, mu_values, angle);
        
        % Scale the projection size
        scaled_projection = imresize(projection, 1 / scale_factor, 'nearest');
        
        % Add padding to create the black space
        original_size = size(projection, 1);
        scaled_size = size(scaled_projection, 1);
        padding_size = max(0, round((original_size - scaled_size) / 2));
        padded_projection = padarray(scaled_projection, [padding_size, padding_size], 0, 'both');
        
        % Ensure the padded projection matches the original display size
        padded_projection = imresize(padded_projection, [original_size, original_size], 'nearest');
        
        % Update 3D visualization
        axes(ax3d);
        cla(ax3d);
        slice(ax3d, phantom, size(phantom, 2) / 2, size(phantom, 1) / 2, size(phantom, 3) / 2);
        colormap(ax3d, 'gray');
        caxis(ax3d, [0 max(phantom(:))]); % Adjust color intensity
        title(ax3d, sprintf('3D Phantom (Distance Factor: %.2f)', scale_factor));
        axis(ax3d, 'equal');
        
        % Update 2D projection visualization
        axes(ax2d);
        cla(ax2d);
        % Normalize projection for better visualization
        normalized_projection = padded_projection / max(padded_projection(:));
        imshow(normalized_projection, [], 'Parent', ax2d);
        colormap(ax2d, 'gray');
        caxis(ax2d, [0 1]); % Adjust color intensity dynamically
        title(ax2d, sprintf('Projection (Angle: %.0f°, Energy: %.1f keV)', angle, energy));
    end
    
    % Display the initial projection
    update_visualization();
end

%% Helper Functions

% Calculate Attenuation Coefficients Based on Energy
function mu_values = calculate_attenuation(energy)
    % Define attenuation values for different materials
    mu_background = 0; % Air or background
    mu_tissue = 0.3 + 0.01 * (50 - energy); % Tissue
    mu_tumor = mu_tissue + 0.15 * (energy - 20) / 10; % Tumor diverges more significantly
    mu_bone = 0.6 + 0.015 * (50 - energy);  % Bone
    
    % Ensure coefficients remain non-negative
    mu_values = max([mu_background, mu_tissue, mu_tumor, mu_bone], 0);
end

% Generate 3D Phantom
function phantom = generate_3d_phantom(size, num_tumors, tumor_sizes, tumor_centers)
    [x, y, z] = meshgrid(1:size, 1:size, 1:size);
    phantom = zeros(size, size, size);
    
    center = size / 2;
    % Add the breast tissue
    breast_radius = size / 3;
    distance = sqrt((x - center).^2 + (y - center).^2 + (z - center).^2);
    phantom(distance <= breast_radius) = 1; % Breast tissue
    
    % Add tumors
    for i = 1:num_tumors
        tumor_center = tumor_centers(i, :);
        tumor_radius = tumor_sizes(i);
        tumor_distance = sqrt((x - tumor_center(1)).^2 + (y - tumor_center(2)).^2 + (z - tumor_center(3)).^2);
        phantom(tumor_distance <= tumor_radius) = 2; % Tumor
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
    
    % Sum along the projection axis
    projection = sum(attenuation, 3);
end

% Run the GUI
xray_simulator_gui();

