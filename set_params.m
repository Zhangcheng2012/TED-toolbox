function [PARAMS] = set_params(demo)

% =============== Initialize demo-specific Parameters ===================

switch demo
    
    case 'Agar_phantom_demo'
        PARAMS.title = 'Agar phantom Philips';
        PARAMS.scanner_vendor = 'Philips';
        
        % Acquisition params
        PARAMS.B0 = 3; % [Tesla].
        PARAMS.TE = 12; % 
        PARAMS.N = 128; % Image size is NxN
        PARAMS.NC = 16; % Number of Coils
        PARAMS.NT = 30; % Number of time frames

        % Reconstruction params 
        PARAMS.t_example = 18;         % a time frame for plotting examples (for fully-sampled data)
        PARAMS.t_rec_vec =  [18 20 22] %[16:23]; % vector of time frames for dT reconstruction
        PARAMS.wavWeight =  0.025 ;    % threshold for TED Compressed Sensing Joint sparsity
        PARAMS.TED_num_iters = 220;    % Number of iterations for TED-CS        
        
        % plotting params
        PARAMS.cmin = -30; PARAMS.cmax = 30;    % color limits for temperature plots (in degree Celsius)
        PARAMS.mag_max = 5;                     % upper color limit for magnitude plots
        PARAMS.x1=55;  PARAMS.x2=75;  PARAMS.y1=45;  PARAMS.y2=65; % zoom-in coordinates
 
        % HIFU mask - has 1s inside a block around the heated area, and 0
        % outside. It needs to be defined manually (or set to 1 everywhere)
        PARAMS.HIFU_MASK = zeros(PARAMS.N); 
        PARAMS.HIFU_MASK(55:75,45:65)=1;
        
    case 'Gel_phantom_demo'  % Insightec gel phantom
        PARAMS.title = 'Gel phantom GE';
        PARAMS.scanner_vendor = 'GE';

        % Acquisition params
        PARAMS.B0 = 3; % [Tesla].
        PARAMS.TE = 11.2; 
        PARAMS.N = 256; % Image size is NxN
        PARAMS.NC = 8;  % Number of Coils
        PARAMS.NT = 14; % Number of time frames

        % Reconstruction params 
        PARAMS.t_example = 5;     % a time frame for plotting examples (for fully-sampled data)
        PARAMS.t_rec_vec = 5; % [3 4 5 6 7 8 9 10 11];   % vector of time frames for dT reconstruction
        PARAMS.wavWeight =  20;   % threshold for TED Compressed Sensing Joint sparsity
        PARAMS.TED_num_iters = 220; % Number of iterations for TED-CS
        
        % plotting params
        PARAMS.cmin = -25; PARAMS.cmax = 25;    % color limits for temperature plots (in degree Celsius)
        PARAMS.mag_max = 2500;                  % upper color limit for magnitude plots        
        PARAMS.x1=95; PARAMS.x2=155; PARAMS.y1=120;  PARAMS.y2=146;  % zoom-in coordinates - tight area around the HIFU heated zone.

        % HIFU mask - has 1s inside a block around the heated area, and 0
        % outside. It needs to be defined manually (or set to 1 everywhere)  
        PARAMS.HIFU_MASK = zeros(PARAMS.N);    
        PARAMS.HIFU_MASK(PARAMS.x1:PARAMS.x2,PARAMS.y1:PARAMS.y2) = 1;
        
end

% =========================== General Parameters =========================
PARAMS.alpha = 9.0900e-06;  
PARAMS.gamma = 42.58; 
PARAMS.CONST = -2*pi*PARAMS.B0*PARAMS.gamma*PARAMS.alpha*PARAMS.TE ;%


