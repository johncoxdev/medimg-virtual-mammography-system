% Main function must be first and match the filename
function xraySimulator
    % Create the main figure
    fig = uifigure('Name', 'X-Ray Simulator', 'Position', [100 100 800 600]);
    
    % Create grid layout
    grid = uigridlayout(fig, [2 2]);
    grid.RowHeight = {'1x', '1x'};
    grid.ColumnWidth = {'1x', '1x'};
    
    % Create UI components
    create_controls(fig, grid);
    
    % Create display axes
    ax1 = uiaxes(grid);
    ax1.Layout.Row = 1;
    ax1.Layout.Column = 1;
    title(ax1, 'Original Phantom');
    
    ax2 = uiaxes(grid);
    ax2.Layout.Row = 1;
    ax2.Layout.Column = 2;
    title(ax2, 'X-Ray Projection');
    
    ax3 = uiaxes(grid);
    ax3.Layout.Row = 2;
    ax3.Layout.Column = [1 2];
    title(ax3, 'Intensity Profile');
    
    % Store axes handles
    fig.UserData.ax1 = ax1;
    fig.UserData.ax2 = ax2;
    fig.UserData.ax3 = ax3;
    
    % Generate initial phantom and display
    updateSimulation(fig);
end