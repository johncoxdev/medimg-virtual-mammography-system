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
    
    % Define the horizontal alignment start positions
    start_x = 50; % Initial horizontal position
    start_y = 600; % Vertical position for the controls
    control_width = 150; % Width of the text boxes and sliders
    spacing = 10; % Spacing between controls
    height = 30; % Height of the controls

    % Add sliders for X and Y width
uicontrol(f, 'Style', 'text', 'Position', [start_x, start_y - 3 * (height + spacing), control_width, height], 'String', 'Width X');
width_x_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + control_width + spacing, start_y - 3 * (height + spacing), control_width, height], ...
                          'Min', 0.5, 'Max', 2, 'Value', 1, ...
                          'Callback', @(~, ~) update_visualization());

uicontrol(f, 'Style', 'text', 'Position', [start_x + 2 * (control_width + spacing), start_y - 3 * (height + spacing), control_width, height], 'String', 'Width Y');
width_y_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + 3 * (control_width + spacing), start_y - 3 * (height + spacing), control_width, height], ...
                          'Min', 0.5, 'Max', 2, 'Value', 1, ...
                          'Callback', @(~, ~) update_visualization());
    

    % Input Boxes (Number of Tumors and Tumor Size) - Placed on top
    uicontrol(f, 'Style', 'text', 'Position', [start_x, start_y, control_width, height], 'String', 'Num Tumors');
    num_tumors_input = uicontrol(f, 'Style', 'edit', 'Position', [start_x + control_width + spacing, start_y, control_width, height], ...
                                  'String', '1', 'Callback', @(~, ~) update_visualization());
    
    uicontrol(f, 'Style', 'text', 'Position', [start_x + 2 * (control_width + spacing), start_y, control_width, height], 'String', 'Tumor Size');
    tumor_size_input = uicontrol(f, 'Style', 'edit', 'Position', [start_x + 3 * (control_width + spacing), start_y, control_width, height], ...
                                  'String', '5', 'Callback', @(~, ~) update_visualization());

    % Sliders (First Row)
    uicontrol(f, 'Style', 'text', 'Position', [start_x, start_y - height - spacing, control_width, height], 'String', 'Source Distance');
    distance_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + control_width + spacing, start_y - height - spacing, control_width, height], ...
                                'Min', 0.5, 'Max', 2, 'Value', 2, ...
                                'Callback', @(~, ~) update_visualization());

    uicontrol(f, 'Style', 'text', 'Position', [start_x + 2 * (control_width + spacing), start_y - height - spacing, control_width, height], 'String', 'Distance from Film');
    film_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + 3 * (control_width + spacing), start_y - height - spacing, control_width, height], ...
                            'Min', 0, 'Max', 100, 'Value', 50, ...
                            'Callback', @(~, ~) update_visualization());

    % Contrast Display
uicontrol(f, 'Style', 'text', 'Position', [start_x + 6 * (control_width + spacing), start_y - height - spacing, control_width, height], ...
          'String', 'Contrast:');
contrast_text = uicontrol(f, 'Style', 'text', 'Position', [start_x + 7 * (control_width + spacing), start_y - height - spacing, control_width, height], ...
                          'String', 'N/A');


    uicontrol(f, 'Style', 'text', 'Position', [start_x + 4 * (control_width + spacing), start_y - height - spacing, control_width, height], 'String', 'Beam Energy (keV)');
    energy_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + 5 * (control_width + spacing), start_y - height - spacing, control_width, height], ...
                              'Min', 20, 'Max', 50, 'Value', 20, ...
                              'Callback', @(~, ~) update_visualization());

    % Sliders (Second Row)
    uicontrol(f, 'Style', 'text', 'Position', [start_x, start_y - 2 * (height + spacing), control_width, height], 'String', 'X-Ray 2D Rotation');
    rotation_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + control_width + spacing, start_y - 2 * (height + spacing), control_width, height], ...
                                'Min', 0, 'Max', 360, 'Value', 0, ...
                                'Callback', @(~, ~) update_visualization());

    uicontrol(f, 'Style', 'text', 'Position', [start_x + 2 * (control_width + spacing), start_y - 2 * (height + spacing), control_width, height], 'String', 'X-Ray 3D Rotation');
    angle_slider = uicontrol(f, 'Style', 'slider', 'Position', [start_x + 3 * (control_width + spacing), start_y - 2 * (height + spacing), control_width, height], ...
                             'Min', 0, 'Max', 180, 'Value', 0, ...
                             'Callback', @(~, ~) update_visualization());


    

    % Axes to display 3D Phantom and 2D Projection
    ax3d = axes(f, 'Position', [0.05, 0.1, 0.4, 0.6]); % For 3D phantom
    ax2d = axes(f, 'Position', [0.35, 0.1, 0.4, 0.6]); % For 2D projection
    ax4d = axes(f, 'Position', [0.75, 0.5, 0.2, 0.3]); % For 1D profile
    ax5d = axes(f, 'Position', [0.75, 0.1, 0.2, 0.3]); % For 1D profile 2
    
    % Base phantom size
    base_size = 100;
    
    % Predefined tumor locations (up to 5)
    fixed_tumor_locations = [
        50, 50, 50;  % Tumor 1
        30, 70, 30;  % Tumor 2
        70, 30, 70;  % Tumor 3
        40, 40, 40;  % Tumor 4
        30, 50, 30   % Tumor 5
    ];
    
function update_visualization()
    % Get the slider values
    angle = angle_slider.Value;  % 3D rotation angle
    scale_factor = distance_slider.Value; % Scale factor for perceived distance
    energy = energy_slider.Value; % X-ray beam energy in keV
    rotation_angle_2d = rotation_slider.Value; % 2D rotation angle
    
    % Get the user input values for number of tumors and tumor size
    num_tumors = str2double(num_tumors_input.String);  % Convert string to number
    tumor_size = str2double(tumor_size_input.String);  % Convert string to number
    
    % Get film position (as a percentage of the phantom size)
    film_position = film_slider.Value / 100 * base_size; % Scale film position to the phantom size
    
    % Define a maximum size for the film (e.g., 80% of phantom size)
    max_film_size = 0.8 * base_size;  % You can change this to whatever maximum size you prefer
    % Define a minimum size for the film (e.g., 10% of phantom size)
    min_film_size = 0.1 * base_size;  % Minimum size for the film
    
    % Cap the film size to the maximum and minimum values
    film_position = min(max(film_position, min_film_size), max_film_size);  % Ensure the film size is within the allowed range
    
    % Ensure that the number of tumors is between 1 and 5
    num_tumors = min(max(num_tumors, 1), 5); % Limit to between 1 and 5
    
    % Use the predefined tumor locations, limit to 'num_tumors'
    tumor_centers = fixed_tumor_locations(1:num_tumors, :);
    tumor_sizes = repmat(tumor_size, num_tumors, 1);
    
    % Calculate attenuation coefficients based on energy
    mu_values = calculate_attenuation(energy); 
    
    % Get the width scaling factors
    scale_x = width_x_slider.Value;
    scale_y = width_y_slider.Value;

    % Generate the phantom with tumors and adjusted widths
    phantom = generate_3d_phantom(base_size, num_tumors, tumor_sizes, tumor_centers, scale_x, scale_y);
    
    % Simulate the X-ray projection (3D rotation)
    projection_3d = simulate_xray(phantom, mu_values, angle);
    
    % Scale the projection size
    scaled_projection = imresize(projection_3d, 1 / scale_factor, 'nearest');
    
    % Add padding to create the black space
    original_size = size(projection_3d, 1);
    scaled_size = size(scaled_projection, 1);
    padding_size = max(0, round((original_size - scaled_size) / 2));
    padded_projection = padarray(scaled_projection, [padding_size, padding_size], 0, 'both');
    
    % Ensure the padded projection matches the original display size
    padded_projection = imresize(padded_projection, [original_size, original_size], 'nearest');
    
    % Apply 2D rotation (around the Z-axis)
    rotation_matrix_2d = [cosd(rotation_angle_2d), -sind(rotation_angle_2d); sind(rotation_angle_2d), cosd(rotation_angle_2d)];
    rotated_projection_2d = imrotate(padded_projection, rotation_angle_2d, 'bilinear', 'crop');

    % Calculate the attenuation values for the first tumor and breast tissue
tumor_value = mu_values(3); % Attenuation for tumor
breast_value = mu_values(2); % Attenuation for breast tissue

% Compute the contrast
contrast = (tumor_value - breast_value) / breast_value;

% Update the contrast display
contrast_text.String = sprintf('%.2f', contrast);

    
    % Extract a horizontal profile from the middle of the image
profile_row = round(size(rotated_projection_2d, 1) / 2);  % Row in the middle
horizontal_profile = rotated_projection_2d(profile_row, :);  % Extract the pixel values along that row

% Extract a vertical profile from the middle of the image
profile_col = round(size(rotated_projection_2d, 2) / 2);  % Column in the middle
vertical_profile = rotated_projection_2d(:, profile_col);  % Extract the pixel values along that column


% Assuming 'f' is the figure handle and 'ax4d' is the existing axes
% Plot horizontal profile in the first axes (ax4d)
axes(ax4d);  % Switch to ax4d
plot(horizontal_profile);
xlabel('Pixel Index');
ylabel('Intensity');
title('1D Profile of 2D Phantom (Horizontal Slice)');
grid on;

axes(ax5d);  % Switch to ax4d
plot(vertical_profile);
xlabel('Pixel Index');
ylabel('Intensity');
title('1D Profile of 2D Phantom (Vertical Slice)');
grid on;





    
    % Update 3D visualization
    axes(ax3d);
    cla(ax3d);
    slice(ax3d, phantom, size(phantom, 2) / 2, size(phantom, 1) / 2, size(phantom, 3) / 2);
    colormap(ax3d, 'gray');
    caxis(ax3d, [0 max(phantom(:))]); % Adjust color intensity
    title(ax3d, sprintf('3D Phantom (Distance Factor: %.2f)', scale_factor));
    axis(ax3d, 'equal');
    
    % Update 2D projection visualization (with 2D rotation)
    axes(ax2d);
    cla(ax2d);
    
    % Step 1: Create a blank RGB canvas (background)
    canvas = zeros(original_size, original_size, 3);  % RGB canvas
    
    % Step 2: Insert film with white color
    film_color = [3, 3, 3];  % White color
    film_size = round(film_position);
    film_start = round((size(canvas, 1) - film_size) / 2);
    canvas(film_start:film_start+film_size-1, film_start:film_start+film_size-1, :) = repmat(reshape(film_color, 1, 1, 3), film_size, film_size);  % Fill with color
    
    % Step 3: Overlay the rotated phantom (projection) on top of the film
    canvas(:, :, 1) = canvas(:, :, 1) + rotated_projection_2d;  % Red channel (overlay)
    canvas(:, :, 2) = canvas(:, :, 2) + rotated_projection_2d;  % Green channel (overlay)
    canvas(:, :, 3) = canvas(:, :, 3) + rotated_projection_2d;  % Blue channel (overlay)
    
    % Normalize the canvas for better visualization
    normalized_canvas = canvas / max(canvas(:));
    
    % Display the final result
    imshow(normalized_canvas, [], 'Parent', ax2d);
    colormap(ax2d, 'gray');
    caxis(ax2d, [0 1]); % Adjust color intensity dynamically
    title(ax2d, sprintf('Projection (Angle: %.0f°, Energy: %.1f keV, 2D Rotation: %.1f°)', angle, energy, rotation_angle_2d));
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
function phantom = generate_3d_phantom(size, num_tumors, tumor_sizes, tumor_centers, scale_x, scale_y)
    [x, y, z] = meshgrid(1:size, 1:size, 1:size);
    
    % Apply scaling in the x and y dimensions
    x_scaled = (x - size / 2) / scale_x + size / 2;
    y_scaled = (y - size / 2) / scale_y + size / 2;

    phantom = zeros(size, size, size);
    
    % Add the breast tissue
    center = size / 2;
    breast_radius = size / 3;
    distance = sqrt((x_scaled - center).^2 + (y_scaled - center).^2 + (z - center).^2);
    phantom(distance <= breast_radius) = 1; % Breast tissue

    % Add tumors
    for i = 1:num_tumors
        tumor_center = tumor_centers(i, :);
        tumor_distance = sqrt((x_scaled - tumor_center(1)).^2 + (y_scaled - tumor_center(2)).^2 + (z - tumor_center(3)).^2);
        phantom(tumor_distance <= tumor_sizes(i)) = 2; % Tumor
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



