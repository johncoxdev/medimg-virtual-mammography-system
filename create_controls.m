function create_controls(fig, grid)
    % Create a panel for controls
    panel = uipanel(grid, 'Title', 'Control Panel');
    panel.Layout.Row = 2;
    panel.Layout.Column = 1;
    
    % Create control layout
    controlGrid = uigridlayout(panel, [5 2]);
    
    % Energy control
    uilabel(controlGrid, 'Text', 'X-Ray Energy (keV)');
    energy = uispinner(controlGrid, 'Value', 20, 'Limits', [1 150]);
    energy.ValueChangedFcn = @(~,~) updateSimulation(fig);
    
    % Angle control
    uilabel(controlGrid, 'Text', 'X-Ray Angle (degrees)');
    angle = uispinner(controlGrid, 'Value', 0, 'Limits', [0 360]);
    angle.ValueChangedFcn = @(~,~) updateSimulation(fig);
    
    % Source distance control
    uilabel(controlGrid, 'Text', 'Source Distance (cm)');
    source = uispinner(controlGrid, 'Value', 100, 'Limits', [10 200]);
    source.ValueChangedFcn = @(~,~) updateSimulation(fig);
    
    % Detector distance control
    uilabel(controlGrid, 'Text', 'Detector Distance (cm)');
    detector = uispinner(controlGrid, 'Value', 10, 'Limits', [1 50]);
    detector.ValueChangedFcn = @(~,~) updateSimulation(fig);
    
    % Store control handles
    fig.UserData.energy = energy;
    fig.UserData.angle = angle;
    fig.UserData.source = source;
    fig.UserData.detector = detector;
end