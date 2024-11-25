function updateSimulation(fig)
    % Get current parameter values
    energy = fig.UserData.energy.Value;
    angle = fig.UserData.angle.Value;
    sourceDistance = fig.UserData.source.Value;
    detectorDistance = fig.UserData.detector.Value;
    
    % Generate phantom
    phantom = generate2DPhantom(100);
    
    % Calculate projection
    projection = simulateXRay(phantom, energy, angle, sourceDistance, detectorDistance);
    
    % Display results
    displayResults(fig, phantom, projection);
end

function phantom = generate2DPhantom(size)
    % Create empty phantom
    phantom = zeros(size);
    
    % Create circular background
    center = size/2;
    radius = size/4;
    [X, Y] = meshgrid(1:size, 1:size);
    circle = (X - center).^2 + (Y - center).^2 <= radius^2;
    phantom(circle) = 0.5; % Background tissue
    
    % Add denser region
    smallRadius = radius/2;
    denseCircle = (X - center).^2 + (Y - center).^2 <= smallRadius^2;
    phantom(denseCircle) = 1; % Dense tissue
end

function projection = simulateXRay(phantom, energy, angle, sourceDistance, detectorDistance)
    % Adjust attenuation coefficients based on energy
    muAir = 0.01 * (20/energy);
    muTissue = 0.5 * (20/energy);
    muDense = 1.0 * (20/energy);
    
    % Create attenuation map
    attMap = phantom;
    attMap(phantom == 0) = muAir;
    attMap(phantom == 0.5) = muTissue;
    attMap(phantom == 1) = muDense;
    
    % Rotate phantom if needed
    if angle ~= 0
        attMap = imrotate(attMap, angle, 'bilinear', 'crop');
    end
    
    % Apply Beer-Lambert law
    I0 = 1; % Initial intensity
    projection = I0 * exp(-sum(attMap, 3));
    
    % Apply geometric magnification
    mag = (sourceDistance + detectorDistance) / sourceDistance;
    projection = imresize(projection, mag);
end

function displayResults(fig, phantom, projection)
    % Get axes handles
    ax1 = fig.UserData.ax1;
    ax2 = fig.UserData.ax2;
    ax3 = fig.UserData.ax3;
    
    % Display phantom
    imshow(phantom, [], 'Parent', ax1);
    colormap(ax1, 'gray');
    colorbar(ax1);
    
    % Display projection
    imshow(projection, [], 'Parent', ax2);
    colormap(ax2, 'gray');
    colorbar(ax2);
    
    % Display intensity profile
    centerLine = projection(ceil(end/2), :);
    plot(ax3, centerLine);
    xlabel(ax3, 'Position');
    ylabel(ax3, 'Intensity');
end