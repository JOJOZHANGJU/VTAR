% function get_acousticResponse(Category, Type);
%
% to get acoustic response of vocal tract based on input of
% area function.
% 

function get_acousticResponse(Category, Type);
global VT ;

% constants
ORAL_MODE = 2 ;
NASAL_MODE = 3 ;
ORALNASAL_MODE = 4 ;
FRICATIVE_MODE = 5 ;

SINGLECHANNEL = 1 ;
TWOCHANNELS   = 2 ;
GLOTTIS       = 2 ;
LIPS          = 2 ;
NOSTRIL1      = 3 ;
NOSTRIL2      = 4 ;


tic ;
% Maximum frequency, frequency step, 
% and simulation step
% Fupper = 6000 ;
% df = 1 ;
% deltaL = 0.3 ; 
Fupper = VT.Fupper ;
df = VT.df ;
deltaL = VT.deltaL ; 


% radiation on/off
switch lower(VT.Radiation_Load)
    case 'on'
        VT.Property.Radiation = 1 ; 
    case 'off'
        VT.Property.Radiation = 0 ; 
end


% to be used as a template for non arbitrary type
if (Category ~= 8)
    for i = 1:5 
        Tube_transformed(i).IndexOfBranch = [ -1 ] ;
        Tube_transformed(i).typeOfModule  = [ 1 ] ;
        Tube_transformed(i).typeOfStartofTube = [ 1 ] ;
        Tube_transformed(i).typeOfEndofTube   = [ 1 ] ;
        Tube_transformed(i).numOfSections = [ 0 ] ;
        Tube_transformed(i).secLen = zeros(1, 200) ;
        Tube_transformed(i).secArea = zeros(1, 200) ;
        Tube_transformed(i).numOfSections1 = [ 0 ] ;  % for channel 2 in case that typeOfModule == TWOCHANNELS 
        Tube_transformed(i).secLen1 = zeros(1, 200) ;
        Tube_transformed(i).secArea1 = zeros(1, 200) ;
        Tube_transformed(i).nextBranches = zeros(1, 10) ;
        Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;  % location of side branch
        Tube_transformed(i).nextBranchesLocEnd =  zeros(1, 10) ; % location of side branch is at the end , if nextBranchesLocEnd=1, then neglect nextBranchesLoc
        Tube_transformed(i).nextBranchesLocChannel =  ones(1, 10) ; % for the case that typeOfModule == TWOCHANNELS
    end
end

switch Category
    
    case 2  % 'Vowel'
        Geometry = VT.Vowel.Geometry ;
        Tube_transformed(1).IndexOfBranch = 1 ;
        Tube_transformed(1).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(1).typeOfStartofTube = GLOTTIS ;
        Tube_transformed(1).typeOfEndofTube   = LIPS ;
        Tube_transformed(1).numOfSections = length(Geometry.DL) ;
        Tube_transformed(1).secLen = Geometry.DL ;
        Tube_transformed(1).secArea = Geometry.Area ;
        Tube_transformed(1).nextBranches = zeros(1, 10) ;
        Tube_transformed(1).nextBranchesLoc =  zeros(1, 10) ;
        Tube_transformed(1).nextBranchesLocEnd =  zeros(1, 10) ;
        Tube_transformed(1).nextBranchesLocChannel =  ones(1, 10) ;
        
        [f, AR] = arbitray_model(Fupper, df, deltaL, ORAL_MODE, Tube_transformed, VT.Property) ;
        
    case 3  % 'Consonant'
        
        Geometry = VT.Consonant.Geometry ;
        
        % constriciton location can not be at the glottis or out of range 
        if(sum(Geometry.DL) <= 0)
            if ishandle(h)  % exist('h')  % in case h is deleted 
                delete(h) ;
            end
            errordlg('Data incomplete', 'Error', 'modal'); 
            return ; 
        elseif ((Geometry.ConstrictionLocation > sum(Geometry.DL)) | Geometry.ConstrictionLocation<0 )
            if ishandle(h)  % exist('h')  % in case h is deleted 
                delete(h) ;
            end
            errordlg( 'Constriction Location is 0 or larger than the length of vocal tract', 'Error', 'modal'); return ; 
            return ; 
        end
        
        % for the case that the constriction location is not defined in the
        % interface. the location with mini. area is calculated and used as
        % constriction location
        if isnan(Geometry.ConstrictionLocation) | Geometry.ConstrictionLocation==0 
            [ tempMin tempInd ]= min(Geometry.Area);
            Geometry.ConstrictionLocation = sum(Geometry.DL(1:tempInd)) - 0.5*Geometry.DL(tempInd) ;
            tempH = warndlg( ['Constriction Location is 0 or not specified. The location with minimum area will be considered as noise souce, which is ' num2str(Geometry.ConstrictionLocation) '(cm)'], 'modal'); 
            uiwait(tempH) ; 
        end
        
        % case 1, constriction at the end
        if abs(Geometry.ConstrictionLocation - sum(Geometry.DL)) < eps 
            Tube_transformed(1).IndexOfBranch = 1 ;
            Tube_transformed(1).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(1).typeOfStartofTube = GLOTTIS ;
            Tube_transformed(1).typeOfEndofTube   = LIPS ;
            Tube_transformed(1).numOfSections = length(Geometry.DL) ;
            Tube_transformed(1).secLen = Geometry.DL(end:-1:1) ;  % for fricative model 
            Tube_transformed(1).secArea = Geometry.Area(end:-1:1) ;
            Tube_transformed(1).nextBranches = zeros(1, 10) ;
            Tube_transformed(1).nextBranchesLoc =  zeros(1, 10) ;
            Tube_transformed(1).nextBranchesLocEnd =  zeros(1, 10) ;
            Tube_transformed(1).nextBranchesLocChannel =  ones(1, 10) ;  
            
            % case 2, in the middle 
        else
            [ backDL, backArea, frontDL, frontArea] = divideTwo(Geometry.DL, Geometry.Area, Geometry.ConstrictionLocation )
            Tube_transformed(1).IndexOfBranch = 1 ;
            Tube_transformed(1).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(1).typeOfStartofTube = GLOTTIS ;
            Tube_transformed(1).typeOfEndofTube   = 1 ;
            Tube_transformed(1).numOfSections = length(backDL) ;
            Tube_transformed(1).secLen = backDL(end:-1:1) ;  % for fricative model 
            Tube_transformed(1).secArea = backArea(end:-1:1) ;
            Tube_transformed(1).nextBranches(1) = 2 ;
            Tube_transformed(1).nextBranchesLocEnd(1) =  1 ;
            
            Tube_transformed(2).IndexOfBranch = 2 ;
            Tube_transformed(2).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(2).typeOfStartofTube = 1 ;
            Tube_transformed(2).typeOfEndofTube   = LIPS ;
            Tube_transformed(2).numOfSections = length(frontDL) ;
            Tube_transformed(2).secLen = frontDL ;  % for fricative model 
            Tube_transformed(2).secArea = frontArea ;
        end
        [f, AR] = arbitray_model(Fupper, df, deltaL, FRICATIVE_MODE, Tube_transformed, VT.Property) ;
        
    case 4  % 'Nasal'
        Geometry = VT.Nasal.Geometry ;
        
        % Pharynx
        i = 1 ; 
        Tube_transformed(i).IndexOfBranch = 1 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = GLOTTIS ;
        Tube_transformed(i).typeOfEndofTube   = 0 ;
        Tube_transformed(i).numOfSections = length(Geometry.PharynxDL) ;
        Tube_transformed(i).secLen  = Geometry.PharynxDL ;
        Tube_transformed(i).secArea = Geometry.PharynxArea ;
        Tube_transformed(i).nextBranches(1:2) = [2 3] ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        Tube_transformed(i).nextBranchesLocEnd(1:2) = 1 ;
        
        % Oral
        i = 2 ; 
        Tube_transformed(i).IndexOfBranch = 2 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = LIPS ;
        Tube_transformed(i).numOfSections = length(Geometry.OralDL) ;
        Tube_transformed(i).secLen  = Geometry.OralDL ;
        Tube_transformed(i).secArea = Geometry.OralArea ;
        %Tube_transformed(i).nextBranches(1) = 2 ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        
        % NasalBack
        i = 3 ;
        Tube_transformed(i).IndexOfBranch = 3 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = 0 ;
        Tube_transformed(i).numOfSections = length(Geometry.NasalBackDL) ;
        Tube_transformed(i).secLen  = Geometry.NasalBackDL ;
        Tube_transformed(i).secArea = Geometry.NasalBackArea ;
        if(Geometry.TwoNostril==1)
            Tube_transformed(i).nextBranches(1:2) = [4 5] ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            Tube_transformed(i).nextBranchesLocEnd(1:2) = 1 ;
        else
            Tube_transformed(i).nextBranches(1) = 4 ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        % Nostril1
        i = 4 ;
        Tube_transformed(i).IndexOfBranch = 4 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = NOSTRIL1 ;
        Tube_transformed(i).numOfSections = length(Geometry.NostrilDL1) ;
        Tube_transformed(i).secLen  = Geometry.NostrilDL1 ;
        Tube_transformed(i).secArea = Geometry.NostrilArea1 ;
        % Tube_transformed(i).nextBranches(1) = 2 ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        
        % Nostril2
        i = 5 ;
        if(Geometry.TwoNostril==1)
            Tube_transformed(i).IndexOfBranch = 5 ;
            Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(i).typeOfStartofTube = 0 ;
            Tube_transformed(i).typeOfEndofTube   = NOSTRIL2 ;
            Tube_transformed(i).numOfSections = length(Geometry.NostrilDL2) ;
            Tube_transformed(i).secLen  = Geometry.NostrilDL2 ;
            Tube_transformed(i).secArea = Geometry.NostrilArea2 ;
            %Tube_transformed(i).nextBranches(1) = 2 ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        [f, AR] = arbitray_model(Fupper, df, deltaL, NASAL_MODE, Tube_transformed, VT.Property) ;
        
        
    case 5  % '/r/'
        Geometry = VT.Rhotic.Geometry ;
        %         switch(Type)
        %             case 1
        %             case 2  % need to change type 1 to do calculation
        %                 % [ backDL, backArea, frontDL, frontArea] = divideTwo(tempDL, tempArea, Location ) 
        % %                 [Geometry.BackDL, Geometry.BackArea,Geometry.FrontDL,Geometry.FrontArea]  = ...
        % %                     divideTwo(Geometry.MainDL,Geometry.MainArea,Geometry.SublingualLocation) ;
        %                 
        %                 [Geometry.BackDL, Geometry.BackArea,Geometry.FrontDL,Geometry.FrontArea]  = ...
        %                     divideTwo(Geometry.MainDL,Geometry.MainArea,Geometry.SublingualLocation, Geometry.SublingualOn) ;
        %                 
        %             otherwise
        %                 errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
        %         end
        %         
        %         [Geometry.BackDL,  Geometry.BackArea]  = divide(Geometry.BackDL,  Geometry.BackArea, deltaL) ;
        %         [Geometry.FrontDL, Geometry.FrontArea] = divide(Geometry.FrontDL, Geometry.FrontArea, deltaL) ;
        %         [Geometry.SublingualDL, Geometry.SublingualArea]  = divide(Geometry.SublingualDL, Geometry.SublingualArea, deltaL) ;
        %         
        %         %  [f,AR] = rhotic(Fupper, df, Geometry, VT.Property );
        %         [f,AR] = rhotic_c(Fupper,df, Geometry, VT.Property );
        
        
        switch(Type)
            case 1
                % back cavity
                i = 1 ;
                Tube_transformed(i).IndexOfBranch = 1 ;
                Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
                Tube_transformed(i).typeOfStartofTube = GLOTTIS ;
                Tube_transformed(i).typeOfEndofTube   = 0 ;
                Tube_transformed(i).numOfSections = length(Geometry.BackDL) ;
                Tube_transformed(i).secLen = Geometry.BackDL ;
                Tube_transformed(i).secArea = Geometry.BackArea ;
                Tube_transformed(i).nextBranches(1) = 2 ;
                %            Tube_transformed(i).nextBranches(1) = Geometry.SublingualLocation ;
                Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
                
                % front cavity
                i = 2 ;   
                Tube_transformed(i).IndexOfBranch = 2 ;
                Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
                Tube_transformed(i).typeOfStartofTube = 0 ;
                Tube_transformed(i).typeOfEndofTube   = LIPS ;
                Tube_transformed(i).numOfSections = length(Geometry.FrontDL) ;
                Tube_transformed(i).secLen = Geometry.FrontDL ;
                Tube_transformed(i).secArea = Geometry.FrontArea ;
                %            Tube_transformed(i).nextBranches(1) = 2 ;
                %            Tube_transformed(i).nextBranches(1) = Geometry.SublingualLocation ;
                %           Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
                
                % sublingual cavity
                
                if(Geometry.SublingualOn == 1)
                    Tube_transformed(1).nextBranches(2) = 3 ;
                    Tube_transformed(1).nextBranchesLocEnd(2) = 1 ;
                    
                    i = 3 ;
                    Tube_transformed(i).IndexOfBranch = 3 ;
                    Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
                    Tube_transformed(i).typeOfStartofTube = 0 ;
                    Tube_transformed(i).typeOfEndofTube   = 0 ;
                    Tube_transformed(i).numOfSections = length(Geometry.SublingualDL) ;
                    Tube_transformed(i).secLen = Geometry.SublingualDL ;
                    Tube_transformed(i).secArea = Geometry.SublingualArea ;
                end
                
            case 2  % need to change type 1 to do calculation
                % [ backDL, backArea, frontDL, frontArea] = divideTwo(tempDL, tempArea, Location ) 
                %                 [Geometry.BackDL, Geometry.BackArea,Geometry.FrontDL,Geometry.FrontArea]  = ...
                %                     divideTwo(Geometry.MainDL,Geometry.MainArea,Geometry.SublingualLocation) ;
                
                %                [Geometry.BackDL, Geometry.BackArea,Geometry.FrontDL,Geometry.FrontArea]  = ...
                %                    divideTwo(Geometry.MainDL,Geometry.MainArea,Geometry.SublingualLocation, Geometry.SublingualOn) ;
                
                % main cavity
                Tube_transformed(1).IndexOfBranch = 1 ;
                Tube_transformed(1).typeOfModule  = SINGLECHANNEL ;
                Tube_transformed(1).typeOfStartofTube = GLOTTIS ;
                Tube_transformed(1).typeOfEndofTube   = LIPS ;
                Tube_transformed(1).numOfSections = length(Geometry.MainDL) ;
                Tube_transformed(1).secLen = Geometry.MainDL ;
                Tube_transformed(1).secArea = Geometry.MainArea ;
                
                % sublingual cavity
                if(Geometry.SublingualOn == 1)
                    Tube_transformed(1).nextBranches(1) = 2 ;
                    Tube_transformed(1).nextBranchesLoc(1) = Geometry.SublingualLocation ;
                    
                    Tube_transformed(2).IndexOfBranch = 2 ;
                    Tube_transformed(2).typeOfModule  = SINGLECHANNEL ;
                    Tube_transformed(2).typeOfStartofTube = 0 ;
                    Tube_transformed(2).typeOfEndofTube   = 0 ;
                    Tube_transformed(2).numOfSections = length(Geometry.SublingualDL) ;
                    Tube_transformed(2).secLen = Geometry.SublingualDL ;
                    Tube_transformed(2).secArea = Geometry.SublingualArea ;
                    
                end
                % Tube_transformed(1).nextBranches = zeros(1, 10) ;
                % Tube_transformed(1).nextBranchesLoc =  zeros(1, 10) ;
                % Tube_transformed(1).nextBranchesLocEnd =  zeros(1, 10) ;
                % Tube_transformed(1).nextBranchesLocChannel =  ones(1, 10) ;
                
            otherwise
                errordlg('/r/ model type error, no titles chosen for plots !!!', 'Error!!! ', 'modal') ; %, return ; 
        end
        [f, AR] = arbitray_model(Fupper, df, deltaL, ORAL_MODE, Tube_transformed, VT.Property) ;
        
        
    case 6  % '/l/'
        Geometry = VT.Lateral.Geometry ;
        %         [Geometry.BackDL  ,    Geometry.BackArea]  = divide(Geometry.BackDL  ,    Geometry.BackArea, deltaL) ;
        %         [Geometry.FrontDL ,    Geometry.FrontArea] = divide(Geometry.FrontDL ,    Geometry.FrontArea, deltaL) ;
        %         [Geometry.LateralDL1,  Geometry.LateralArea1] = divide(Geometry.LateralDL1,  Geometry.LateralArea1, deltaL) ;
        %         [Geometry.LateralDL ,  Geometry.LateralArea]  = divide(Geometry.LateralDL ,  Geometry.LateralArea, deltaL) ;
        %         [Geometry.LateralDL2,  Geometry.LateralArea2]  = divide(Geometry.LateralDL2,  Geometry.LateralArea2, deltaL) ;
        %         [Geometry.SupralingualDL, Geometry.SupralingualArea]   = divide(Geometry.SupralingualDL, Geometry.SupralingualArea, deltaL) ;
        %         
        %         %      [f,AR] = lateral_new(Fupper,df, VT.Lateral.Geometry) ; %, VT.Property );
        %         [f,AR] = lateral_c(Fupper,df, Geometry, VT.Property );
        
        % Back
        i = 1 ; 
        Tube_transformed(i).IndexOfBranch = 1 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = GLOTTIS ;
        Tube_transformed(i).typeOfEndofTube   = 0 ;
        Tube_transformed(i).numOfSections = length(Geometry.BackDL) ;
        Tube_transformed(i).secLen  = Geometry.BackDL ;
        Tube_transformed(i).secArea = Geometry.BackArea ;
        if (Geometry.SupralingualOn == 1)
            Tube_transformed(i).nextBranches(1:2) = [2 4] ;
            Tube_transformed(i).nextBranchesLocEnd(1:2) = 1 ;
        else
            Tube_transformed(i).nextBranches(1) = 2 ;
            Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        % Lateral
        i = 2 ; 
        Tube_transformed(i).IndexOfBranch = 2 ;
        if (Geometry.LateralOn == 1)
            Tube_transformed(i).typeOfModule  = TWOCHANNELS ;
            Tube_transformed(i).typeOfStartofTube = 0 ;
            Tube_transformed(i).typeOfEndofTube   = 0 ;
            Tube_transformed(i).numOfSections = length(Geometry.LateralDL1) ;
            Tube_transformed(i).secLen  = Geometry.LateralDL1 ;
            Tube_transformed(i).secArea = Geometry.LateralArea1 ;
            Tube_transformed(i).numOfSections1 = length(Geometry.LateralDL2) ;
            Tube_transformed(i).secLen1  = Geometry.LateralDL2 ;
            Tube_transformed(i).secArea1 = Geometry.LateralArea2 ;
        else
            Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(i).typeOfStartofTube = 0 ;
            Tube_transformed(i).typeOfEndofTube   = 0 ;
            Tube_transformed(i).numOfSections = length(Geometry.LateralDL1) ;
            Tube_transformed(i).secLen  = Geometry.LateralDL1 ;
            Tube_transformed(i).secArea = Geometry.LateralArea1 ;
        end
        Tube_transformed(i).nextBranches(1) = 3 ;
        Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        
        % Front
        i = 3 ;
        Tube_transformed(i).IndexOfBranch = 3 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = LIPS ;
        Tube_transformed(i).numOfSections = length(Geometry.FrontDL) ;
        Tube_transformed(i).secLen  = Geometry.FrontDL ;
        Tube_transformed(i).secArea = Geometry.FrontArea ;
        
        % Supralingual
        i = 4 ;
        if (Geometry.SupralingualOn == 1)
            Tube_transformed(i).IndexOfBranch = 4 ;
            Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(i).typeOfStartofTube = 0 ;
            Tube_transformed(i).typeOfEndofTube   = 0 ;
            Tube_transformed(i).numOfSections = length(Geometry.SupralingualDL) ;
            Tube_transformed(i).secLen  = Geometry.SupralingualDL ;
            Tube_transformed(i).secArea = Geometry.SupralingualArea ;
            % Tube_transformed(i).nextBranches(1) = 2 ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        [f, AR] = arbitray_model(Fupper, df, deltaL, ORAL_MODE, Tube_transformed, VT.Property) ;
        
        
    case 7  % 'Nasalized vowel'
        Geometry = VT.NasalVowel.Geometry ;
        
        % Pharynx
        i = 1 ; 
        Tube_transformed(i).IndexOfBranch = 1 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = GLOTTIS ;
        Tube_transformed(i).typeOfEndofTube   = 0 ;
        Tube_transformed(i).numOfSections = length(Geometry.PharynxDL) ;
        Tube_transformed(i).secLen  = Geometry.PharynxDL ;
        Tube_transformed(i).secArea = Geometry.PharynxArea ;
        Tube_transformed(i).nextBranches(1:2) = [2 3] ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        Tube_transformed(i).nextBranchesLocEnd(1:2) = 1 ;
        
        % Oral
        i = 2 ; 
        Tube_transformed(i).IndexOfBranch = 2 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = LIPS ;
        Tube_transformed(i).numOfSections = length(Geometry.OralDL) ;
        Tube_transformed(i).secLen  = Geometry.OralDL ;
        Tube_transformed(i).secArea = Geometry.OralArea ;
        %Tube_transformed(i).nextBranches(1) = 2 ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        
        % NasalBack
        i = 3 ;
        Tube_transformed(i).IndexOfBranch = 3 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = 0 ;
        Tube_transformed(i).numOfSections = length(Geometry.NasalBackDL) ;
        Tube_transformed(i).secLen  = Geometry.NasalBackDL ;
        Tube_transformed(i).secArea = Geometry.NasalBackArea ;
        if(Geometry.TwoNostril==1)
            Tube_transformed(i).nextBranches(1:2) = [4 5] ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            Tube_transformed(i).nextBranchesLocEnd(1:2) = 1 ;
        else
            Tube_transformed(i).nextBranches(1) = 4 ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        % Nostril1
        i = 4 ;
        Tube_transformed(i).IndexOfBranch = 4 ;
        Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
        Tube_transformed(i).typeOfStartofTube = 0 ;
        Tube_transformed(i).typeOfEndofTube   = NOSTRIL1 ;
        Tube_transformed(i).numOfSections = length(Geometry.NostrilDL1) ;
        Tube_transformed(i).secLen  = Geometry.NostrilDL1 ;
        Tube_transformed(i).secArea = Geometry.NostrilArea1 ;
        % Tube_transformed(i).nextBranches(1) = 2 ;
        % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
        % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        
        % Nostril2
        i = 5 ;
        if(Geometry.TwoNostril==1)
            Tube_transformed(i).IndexOfBranch = 5 ;
            Tube_transformed(i).typeOfModule  = SINGLECHANNEL ;
            Tube_transformed(i).typeOfStartofTube = 0 ;
            Tube_transformed(i).typeOfEndofTube   = NOSTRIL2 ;
            Tube_transformed(i).numOfSections = length(Geometry.NostrilDL2) ;
            Tube_transformed(i).secLen  = Geometry.NostrilDL2 ;
            Tube_transformed(i).secArea = Geometry.NostrilArea2 ;
            %Tube_transformed(i).nextBranches(1) = 2 ;
            % Tube_transformed(i).nextBranchesLoc =  zeros(1, 10) ;
            % Tube_transformed(i).nextBranchesLocEnd(1) = 1 ;
        end
        
        [f, AR] = arbitray_model(Fupper, df, deltaL, ORALNASAL_MODE, Tube_transformed, VT.Property) ;
        
        
    case 8  % 'Nasals with sinus'
        % to avoid the problem that this function will run ahead of the
        % callback in edit area of aribrary model, which means area
        % function will update later than the callback of calculating
        % acoustic response,  I will try to fix it later on in other way.
        % Callback_EditArea(8, 1, 'arbitrary', 0) ;  % this problem does
        % not exist any more , why ???  -- Fixed already , Aug.3 2004
        
        [f, AR] = arbitray_model(Fupper, df, deltaL, VT.Arbitrary.Geometry.Mode, VT.Arbitrary.Geometry.Tube, VT.Property) ;
    otherwise
        f = 1 ; % just in case that there is no category selected .
        AR = 1 ;
        disp('Unknown method. happened in  get_acousticResponse()');
end

% checkformat updates some information of tubes
% VT.model = Tube_transformed ;
% if(Category==8) 
%     VT.model = VT.Arbitrary.Geometry.Tube ; 
% end


toc ;
% update plots display on screen
%------------------------------------
VT.f = f ;
VT.AR = 20*log10(abs(AR)); 
VT.AR_sync = AR ; % for speech syntehsis
Calculate_formant(VT.handles) ;
RePlot(VT.handles) ;  % just for formant display
%         VT.AR = 20*log10(abs(AR));


% check VT.AR to see if the calculation is right 
%------------------------------------------------
Ymin = min(AR) ; Ymax = max(AR);

if(isnan(Ymin) | isinf(Ymin) | isnan(Ymax) | isinf(Ymax))
    errordlg('NaN or Inf appears in the calculation, Check your input please !!!', 'Error!!! ', 'modal') ; %, return ; 
end

% update the plots
%-------------------
ud = get(VT.handles.vtar,'userdata');
filtview('plots', ud.prefs.plots) ;
return ;




function RePlot(handles)
global VT 

Display_formant(handles.F1, VT.Formant(1) );
Display_formant(handles.F2, VT.Formant(2) );
Display_formant(handles.F3, VT.Formant(3) );
Display_formant(handles.F4, VT.Formant(4) );
Display_formant(handles.F5, VT.Formant(5) );

Display_formant(handles.F1_amp, VT.Formant_amp(1), '%10.2f' );
Display_formant(handles.F2_amp, VT.Formant_amp(2), '%10.2f'  );
Display_formant(handles.F3_amp, VT.Formant_amp(3), '%10.2f'  );
Display_formant(handles.F4_amp, VT.Formant_amp(4), '%10.2f'  );
Display_formant(handles.F5_amp, VT.Formant_amp(5), '%10.2f'  );

Display_formant(handles.F1_bw, VT.Formant_bw(1) );
Display_formant(handles.F2_bw, VT.Formant_bw(2) );
Display_formant(handles.F3_bw, VT.Formant_bw(3) );
Display_formant(handles.F4_bw, VT.Formant_bw(4) );
Display_formant(handles.F5_bw, VT.Formant_bw(5) );


% display on matlab command window also
disp(' ') ;
disp('---------------------------------- ') ;
disp('      Result of calculation ') ;
disp('---------------------------------- ') ;

disp('Formant      frequency(Hz)     amplitude(dB)     bandwith(Hz)') ;
for i = 1: 5 
    if(VT.Formant(i)~=0)
        disp([ 'F' num2str(i) '            '  num2str(VT.Formant(i), '%-10d')   '            '  num2str(VT.Formant_amp(i), '%10.2f') '            '  num2str(VT.Formant_bw(i))]) ;
    end
end




% before calculation, check:
% 1. duplicate tube of glottis
% 2. mode match
% 3. loop exist and  check if tube length is zero, (only one tube in the
% tree to connect lips , nostril1, nostril2)
% 4. adjust the location information for matching the c program 
%-----------------------------------------------------------------
function [f, AR] = arbitray_model(Fupper, df, deltaL, mode, currentTube_Calc1, Property)
global VT ;

global currentTube_Calc

global loopTest_Calc  % for check loop exist staring from glottis
global endLips  endNostril1  endNostril2  % for check the duplicate tubes with lips, nostrils, used in plotNode() in this file

f = 6000 ;
AR = 0 ;
endLips = 0 ;  % for test if lips exist in tube configuration
endNostril1 = 0 ; % for test if Nostril1 exist in tube configuration
endNostril2 = 0 ;

% constants
ORAL_MODE = 2 ;
NASAL_MODE = 3 ;
ORALNASAL_MODE = 4 ;
FRICATIVE_MODE = 5 ;

TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;
END = 99900000  ;
CHANNEL_1 =  20000000 ; 
CHANNEL_2 =  40000000 ;

currentTube_Calc  = [] ;
currentTube_Calc  = currentTube_Calc1 ;
root = 0 ;

% find the first tube staring from glottis ;
% find the root of tree
maxnumTubes = length(currentTube_Calc) ;
loopTest_Calc = ones(1, maxnumTubes ) ; 

% check if there is a side branch  , not used now

for i = 1: maxnumTubes
    
    if(currentTube_Calc(i).typeOfStartofTube == GLOTTIS) 
        if(root~=0) 
            errordlg(['Just one tube can start from glottis: ' 'branch ' num2str(root) ' or   branch ' num2str(i) ], 'error', 'modal') ;   
            VT.validGeometry = 0 ; 
            return ;
        else
            root = i ;  
            if(currentTube_Calc(i).secArea(1)<=0)
                errordlg(['The tube starting from glottis can not have zero area at the beginning : branch ' num2str(root) ], 'error', 'modal') ;   
                VT.validGeometry = 0 ; 
                return ;
            end
        end
    end
end

% check if any tube starts from GLOTTIS
if (root == 0)
    errordlg(['NO tube is defined to start from GLOTTIS '], 'error', 'modal') ;    
    return ;
end

% c program will do this sorting 
%---------------------------------
% bubble sorting the children branches
% for i = 1: VT.maxnumTubes
%     currentTube_Calc(i)=  bubbleSorting(currentTube_Calc(i)) ; 
% end

% check if format is ok, otherwise, return 
if (~checkFormat(root))
    VT.validGeometry = 0 ; 
    return ; 
end

VT.model = currentTube_Calc ;
% these two variables are for concatenating small tubes into one tube 
% with subsections, 
VT.tempDL = [] ; 
VT.tempArea = [] ; 

if (checkSidebranch(root)>=1)
    VT.sideBranch = 1; 
else
    VT.sideBranch = 0; 
end

% check if mode match
if( mode == ORAL_MODE )
    if(endLips==0)
        errordlg('Please specified a tube with end at Lips', 'error', 'modal') ;
        VT.validGeometry = 0 ; 
        return ;
    end
elseif( mode  == NASAL_MODE )
    if(endNostril1==0 & endNostril2==0)
        errordlg('Please specified a tube with end at Nostril(s)', 'error', 'modal') ;
        VT.validGeometry = 0 ; 
        return ;
    end
elseif( mode  == ORALNASAL_MODE )
    if(endLips==0)
        errordlg('Please specified a tube with end at Lips', 'error', 'modal') ;
        VT.validGeometry = 0 ; 
        return ;
    end
    if(endNostril1==0 & endNostril2==0)
        errordlg('Please specified a tube with end at Nostril(s)', 'error', 'modal') ;
        VT.validGeometry = 0 ; 
        return ;
    end
end    

% adjust the location information
% subdivide the length of area function to get good accuracy of calculation
currentTube_Calc = modifyAreafunctionArbitrary(root, currentTube_Calc, deltaL) ;


% recall the mex function to calculate the acoustic response
h = waitbar(0,'Calculating  ..., please wait', 'WindowStyle', 'modal');
[f, AR] = vtar_calc_mex(Fupper, df, mode , root, currentTube_Calc, Property) ;
if ishandle(h)  % exist('h')  % in case h is deleted 
    delete(h) ;
end

return ;


function [ backDL1, backArea1, frontDL1, frontArea1] = divideTwo_(tempDL, tempArea, Location ) 

% initialization in case of wrong data input
backDL = 1 ;
backArea = 1 ;
frontDL = 1 ;
frontArea = 1 ;

Out_of_range = 1 ;
i = 1 ;
for i = 1:length(tempDL)
    if( sum(tempDL(1:i))>= Location ) 
        Out_of_range = 0 ;
        break 
    end
end

%if (i ==length(tempDL))
if (Out_of_range == 1) 
    errordlg('Error in data input, location is out of range','Error', 'modal'); return ;
end

if( sum(tempDL(1:i))== Location ) 
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    frontDL = tempDL(i+1:end) ;
    frontArea = tempArea(i+1:end) ;
else
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    if i==1
        backDL(i) = Location ;
    else
        backDL(i) = Location - sum(tempDL(1:i-1))   ;
    end
    
    frontDL = tempDL(i:end) ;
    frontArea = tempArea(i:end) ;
    if i==1
        frontDL(1) = tempDL(1) -  Location ;
    else
        frontDL(1) = sum(tempDL(1:i)) - Location     ;
    end
end
if(length(frontDL)==0 | length(backDL)==0)
    errordlg('one cavity has length 0  and area 0 ', 'Error', 'modal') ;
    if(length(frontDL)==0)
        frontDL = 0 ;
        frontArea = 0 ;
    elseif(length(backDL)==0)
        backDL = 0 ;
        backArea = 0 ;
    end
end


backDL1 = backDL ;
backArea1 = backArea ; 
frontDL1 = frontDL ;
frontArea1 = frontArea ;
return ;



function [ backDL, backArea, frontDL, frontArea] = divideTwo(tempDL, tempArea, Location, varargin ) 

% initialization in case of wrong data input
backDL = 1 ;
backArea = 1 ;
frontDL = 1 ;
frontArea = 1 ;

if(nargin == 4)  % sublingual on or off
    sublingual_on = varargin {1} ;
    if (sublingual_on == 0) % no sublingual
        backDL = tempDL(1)/2 ;
        backArea = tempArea(1) ;
        frontDL = tempDL ; 
        frontDL(1) = tempDL(1)/2 ;
        frontArea = tempArea ;
        return ;
    end
end

Out_of_range = 1 ;
i = 1 ;
for i = 1:length(tempDL)
    if( sum(tempDL(1:i))>= Location ) 
        Out_of_range = 0 ;
        break 
    end
end

%if (i ==length(tempDL))
if (Out_of_range == 1) 
    errordlg('Error in data input, location is out of range','Error', 'modal'); return ;
end

if( sum(tempDL(1:i))== Location ) 
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    frontDL = tempDL(i+1:end) ;
    frontArea = tempArea(i+1:end) ;
else
    backDL = tempDL(1:i) ;
    backArea = tempArea(1:i) ;
    if i==1
        backDL(i) = Location ;
    else
        backDL(i) = Location - sum(tempDL(1:i-1))   ;
    end
    
    frontDL = tempDL(i:end) ;
    frontArea = tempArea(i:end) ;
    if i==1
        frontDL(1) = tempDL(1) -  Location ;
    else
        frontDL(1) = sum(tempDL(1:i)) - Location     ;
    end
end
if(length(frontDL)==0 | length(backDL)==0)
    errordlg('one cavity has length 0  and area 0 ', 'Error', 'modal') ;
    if(length(frontDL)==0)
        frontDL = 0 ;
        frontArea = 0 ;
    elseif(length(backDL)==0)
        backDL = 0 ;
        backArea = 0 ;
    end
end
return ;


%-----------------------------------------------------------------------
%  display information of formant
%
function Display_formant(h, data, varargin)

if( ~isnumeric(data))
    errordlg('Error for formant information','Error', 'modal'); return ;
end
if data == 0
    set(h, 'String',  ' ');
elseif (isnan(data))
    set(h, 'String',  ' *** ');
else
    %set(h, 'String', data );
    if nargin == 3
        set(h, 'String', num2str(data, varargin{1}) );
    else
        set(h, 'String', num2str(data) );
    end
end
return ;


% latest version of divide with the maximum number of tube subsections
function [DL1, Area1] = divide( DL, Area, Delta_L)
EPS = 1E-16 ;
Area1  = [] ;
DL1 = [] ;  
max_sections = 400 ; % new variable added 
for i = 1: length(DL) 
    if(DL(i) <= Delta_L)
        DL1 = [DL1 DL(i) ] ;
        Area1  = [Area1  Area(i)] ;
    else
        %       if(ceil(DL(i)/Delta_L) < 100)
        if(ceil(DL(i)/Delta_L) < max_sections)  % updated by xinhui , 03/27/2005
            
            Temp_Length = Delta_L*ones(1,round(DL(i)/Delta_L)) ;  %round
            Temp_Area   = Area(i)*ones(1,round(DL(i)/Delta_L)) ; %round
            
            if(abs(sum(Temp_Length)-DL(i))>EPS)
                if(sum(Temp_Length)>DL(i))
                    Temp_Length(end) = Delta_L -(sum(Temp_Length)-DL(i))  ;    
                else
                    Temp_Length(end+1) = DL(i) - sum(Temp_Length) ;
                    Temp_Area(end+1)   = Area(i) ;         
                end
            end
            
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
        else  % if length is too large, the maximum number of section is 100 ;
            %             Temp_Length = DL(i)/100*ones(1,100) ;
            %             Temp_Area   = Area(i)*ones(1,100) ; 
            Temp_Length = DL(i)/max_sections*ones(1,max_sections) ;
            Temp_Area   = Area(i)*ones(1,max_sections) ; 
            
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
            h = warndlg('Please be aware that large length of section will reduce the accuracy of modelling', 'warning', 'modal') ;
        end
    end
end 

% old version of divide, 
function [DL1, Area1] = divide_old( DL, Area, Delta_L)
EPS = 1E-16 ;
Area1  = [] ;
DL1 = [] ;  
max_sections = 350 ;
for i = 1: length(DL) 
    if(DL(i) <= Delta_L)
        DL1 = [DL1 DL(i) ] ;
        Area1  = [Area1  Area(i)] ;
    else
        %       if(ceil(DL(i)/Delta_L) < 100)
        if(ceil(DL(i)/Delta_L) < 350)  % updated by xinhui , 03/27/2005
            
            Temp_Length = Delta_L*ones(1,round(DL(i)/Delta_L)) ;  %round
            Temp_Area   = Area(i)*ones(1,round(DL(i)/Delta_L)) ; %round
            
            if(abs(sum(Temp_Length)-DL(i))>EPS)
                if(sum(Temp_Length)>DL(i))
                    Temp_Length(end) = Delta_L -(sum(Temp_Length)-DL(i))  ;    
                else
                    Temp_Length(end+1) = DL(i) - sum(Temp_Length) ;
                    Temp_Area(end+1)   = Area(i) ;         
                end
            end
            
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
        else  % if length is too large, the maximum number of section is 100 ;
            Temp_Length = DL(i)/100*ones(1,100) ;
            Temp_Area   = Area(i)*ones(1,100) ; 
            DL1 = [DL1 Temp_Length ] ;
            Area1  = [Area1 Temp_Area] ;
            h = warndlg('Please be aware that large length of section will reduce the accuracy of modelling', 'warning', 'modal') ;
        end
    end
end 


function [DL1, Area1] = divide_( DL, Area, Delta_L)

Area1  = [] ;
DL1 = [] ;  
for i = 1: length(DL) 
    if(DL(i) <= Delta_L)
        DL1 = [DL1 DL(i) ] ;
        Area1  = [Area1  Area(i)] ;
    else
        Temp_Length = Delta_L*ones(1,ceil(DL(i)/Delta_L)) ;  %round
        if(sum(Temp_Length)> DL(i))
            Temp_Length(end) = Delta_L -(sum(Temp_Length)-DL(i))  ;    
        end
        
        Temp_Area   = Area(i)*ones(1,ceil(DL(i)/Delta_L)) ; %round
        DL1 = [DL1 Temp_Length ] ;
        Area1  = [Area1 Temp_Area] ;
    end
end 


return ;


% 3. loop exist and  check if tube length is zero, (one one tube in the
% tree to connect lips , nostril1, nostril2)
% 4. adjust the location information for matching the c program 
% 5. 

function Output = checkFormat(root)
Output = 1 ;
%
global currentTube_Calc ; 
global loopTest_Calc 
global endLips  endNostril1  endNostril2  % for check the duplicate tubes with lips, nostrils, used in plotNode() in this file

% constants
TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;

END = 99900000  ;
CHANNEL_1 =  20000000 ; 
CHANNEL_2 =  40000000 ;


% loop test
if (loopTest_Calc(root) == 1) % first vist 
    loopTest_Calc(root) = 0 ;
else 
    errordlg(['Connection loop exist at branch ' num2str(root)], 'error', 'modal') ;
    Output = 0 ;
    return ;
end

% check if duplicate tubes with LIPS, Nostirl .....
if(currentTube_Calc(root).typeOfEndofTube == LIPS) 
    if(endLips~=0) 
        errordlg(['Just one tube can end at lips: ' 'branch ' num2str(endLips) ' or   branch ' num2str(root) ], 'error', 'modal') ;    
        Output = 0 ;
        return ;
    else
        endLips = root ;     
    end
end
if(currentTube_Calc(root).typeOfEndofTube == NOSTRIL1) 
    if(endNostril1~=0) 
        errordlg(['Just one tube can end at NOSTRIL 1: ' 'branch ' num2str(endNostril1) ' or   branch ' num2str(root) ], 'error', 'modal') ;    
        Output = 0 ;
        return ;
    else
        endNostril1 = root ;     
    end
end
if(currentTube_Calc(root).typeOfEndofTube == NOSTRIL2) 
    if(endNostril2~=0) 
        errordlg(['Just one tube can end at NOSTRIL 2: ' 'branch ' num2str(endNostril2) ' or   branch ' num2str(root) ], 'error', 'modal') ;    
        Output = 0 ;
        return ;
    else
        endNostril2 = root ;     
    end
end  


if(currentTube_Calc(root).typeOfEndofTube == LIPS | currentTube_Calc(root).typeOfEndofTube == NOSTRIL1| currentTube_Calc(root).typeOfEndofTube == NOSTRIL2) 
    temp = find (currentTube_Calc(root).nextBranches ~= 0) ;% should have no children
    if (~isempty(temp))
        ind = find(currentTube_Calc(root).nextBranchesLocEnd(temp) == 1);
        if (~isempty(ind))
            errordlg(['Tube with the lips or nostrils should have no further connection to additional tubes : branch ' num2str(root)], 'error', 'modal') ;    
            Output = 0 ;
            return ;
        end
    end
end


%     VT.Arbitrary.Geometry.Tube(i).typeOfModule  = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfStartofTube = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).typeOfEndofTube   = [ 1 ] ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).numOfSections1 = [ 0 ] ;
%     VT.Arbitrary.Geometry.Tube(i).secLen1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).secArea1 = zeros(1, 200) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranches = zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLoc =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocEnd =  zeros(1, 10) ;
%     VT.Arbitrary.Geometry.Tube(i).nextBranchesLocChannel =  ones(1, 10) ;

% check if tube length is zero for some section and if data is available (numOfSections==0)
if(currentTube_Calc(root).numOfSections<=0 | (currentTube_Calc(root).typeOfModule==TWOCHANNELS & currentTube_Calc(root).numOfSections1<=0))
    errordlg(['Area function data missing at tube:  ' num2str(root)], 'error', 'modal') ;    
    Output = 0 ;
    return ;    
else % check if length data has zero, or negative area 
    
    % no negative or zero length value
    numOfSections = currentTube_Calc(root).numOfSections ;
    ind = find( currentTube_Calc(root).secLen(1:numOfSections)<=0) ;
    if(~isempty(ind))
        errordlg(['Negatvie or zero of length at some section for tube:  ' num2str(root)], 'error', 'modal') ;    
        Output = 0 ;
        return ;    
    end
    
    % no negative area value
    ind =  find( currentTube_Calc(root).secArea(1:numOfSections)<0) ;
    if (~isempty(ind))
        errordlg(['negative area at some section for tube:  ' num2str(root)], 'error', 'modal') ;    
        Output = 0 ;
        return ;    
    end
    
    if(currentTube_Calc(root).typeOfModule==TWOCHANNELS)
        numOfSections1 = currentTube_Calc(root).numOfSections1 ;
        ind = find( currentTube_Calc(root).secLen1(1:numOfSections1)<=0) ;
        if(~isempty(ind))
            errordlg(['Negatvie or zero of length at some section for tube:  ' num2str(root)], 'error', 'modal') ;    
            Output = 0 ;
            return ;    
        end
        
        % check if any area data is zero in two channels case , which is
        % forbidden in this program 
        ind1 =  find( currentTube_Calc(root).secArea1(1:numOfSections1)<=0) ;
        ind2 =  find( currentTube_Calc(root).secArea(1:numOfSections)<=0) ;
        if (~isempty(ind1) | ~isempty(ind2))
            errordlg(['Twochannels module can not have negative or zero of area at some section for tube:  ' num2str(root)], 'error', 'modal') ;    
            Output = 0 ;
            return ;    
        end
    end
end

% calculate the length of tube and see its branches location
Width = sum(currentTube_Calc(root).secLen( 1:currentTube_Calc(root).numOfSections)) ;
if((currentTube_Calc(root).typeOfModule==TWOCHANNELS))
    Width1 = sum(currentTube_Calc(root).secLen1( 1:currentTube_Calc(root).numOfSections1)) ;
end

% update length and area here , also numOfSections

% ALSO UPDATE THE LOCATION INFORMATION FOR CALCULATION
% check for each children branch 
for i = 1: length(currentTube_Calc(root).nextBranches)
    if(currentTube_Calc(root).nextBranches(i) ~= 0)  % one branch
        % check its location
        if ( currentTube_Calc(root).nextBranchesLocEnd(i)== 1 ) % at the end
            currentTube_Calc(root).nextBranchesLoc(i)= END ;
        else
            if((currentTube_Calc(root).typeOfModule~=TWOCHANNELS))  % single channel
                if(currentTube_Calc(root).nextBranchesLoc(i) <= 0 | currentTube_Calc(root).nextBranchesLoc(i)>Width)
                    Output = 0 ;
                elseif(currentTube_Calc(root).nextBranchesLoc(i)== Width)
                    currentTube_Calc(root).nextBranchesLoc(i)= END ;
                end
            else % double channels
                if(currentTube_Calc(root).nextBranchesLocChannel(i) == 1) % channel1
                    if(currentTube_Calc(root).nextBranchesLoc(i) <= 0 | currentTube_Calc(root).nextBranchesLoc(i)>Width)
                        Output = 0 ;
                    else
                        if(currentTube_Calc(root).nextBranchesLoc(i)== Width)
                            currentTube_Calc(root).nextBranchesLoc(i)= END ;
                        else
                            currentTube_Calc(root).nextBranchesLoc(i) =  currentTube_Calc(root).nextBranchesLoc(i) + CHANNEL_1 ; 
                        end
                    end
                elseif(currentTube_Calc(root).nextBranchesLocChannel(i) == 2) % channel2
                    if(currentTube_Calc(root).nextBranchesLoc(i) <= 0 | currentTube_Calc(root).nextBranchesLoc(i)>Width1)
                        Output = 0 ;
                    else
                        if(currentTube_Calc(root).nextBranchesLoc(i)== Width1)
                            currentTube_Calc(root).nextBranchesLoc(i)= END ;
                        else
                            currentTube_Calc(root).nextBranchesLoc(i) =  currentTube_Calc(root).nextBranchesLoc(i) + CHANNEL_2 ; 
                        end
                    end
                end
            end
        end
        if (Output == 0)
            errordlg(['Wrong location specified of branch ' num2str(currentTube_Calc(root).nextBranches(i)) ' on branch ' num2str(root) '-- location can not be zero or larger than the length of tube' ], 'error', 'modal') ;    
            return ;
        end
        
        Output  = Output * checkFormat (currentTube_Calc(root).nextBranches(i)) ;
        if Output==0  % if one brach is not valid , then terminate the recursive
            return 
        end
    end
end

return 

% to get smaller sections to ensure the accuracy of calculation
function Output = modifyAreafunctionArbitrary(root, Tube, dL) 
global VT ;
TWOCHANNELS = 2 ;

% subdivide the tube to get better accurary in simulation result 
[secLen secArea] = divide(Tube(root).secLen(( 1:Tube(root).numOfSections)) ,Tube(root).secArea(( 1:Tube(root).numOfSections)) , dL) ;
Tube(root).secLen  = secLen  ; 
Tube(root).secArea = secArea ; 
Tube(root).numOfSections = length(secLen) ;
if((Tube(root).typeOfModule==TWOCHANNELS))
    [secLen secArea] = divide(Tube(root).secLen1(( 1:Tube(root).numOfSections1)) ,Tube(root).secArea1(( 1:Tube(root).numOfSections1)) , dL ) ;
    Tube(root).secLen1  = secLen  ; 
    Tube(root).secArea1 = secArea ; 
    Tube(root).numOfSections1 = length(secLen) ;
end

for i = 1: length(Tube(root).nextBranches)
    if(Tube(root).nextBranches(i) ~= 0)  % one branch
        Tube = modifyAreafunctionArbitrary(Tube(root).nextBranches(i), Tube, dL) ;       
    end
end

Output = Tube ;
return ;



function Output = checkSidebranch(root)
global VT ; 
global currentTube_Calc ; 

TWOCHANNELS = 2 ;
Output = 0 ;
% if(~exist(VT.tempDL))
%     VT.tempDL = [] ; 
%     VT.tempArea = [] ; 
% end
%
VT.tempDL = [VT.tempDL(:); currentTube_Calc(root).secLen(:) ] ; 
VT.tempArea = [VT.tempArea(:); currentTube_Calc(root).secArea(:)] ; 

% two channels also are regarded as side branch
if((currentTube_Calc(root).typeOfModule==TWOCHANNELS))  % single channel
    Output = 1 ; 
    return ;
end

% look if there are branches
temp =  (currentTube_Calc(root).nextBranches) ;
ind = find(temp~=0) ; 
if(length(ind)>1)
    Output = 1 ; 
    return ;
elseif(length(ind)==0)
    return ; 
end

% for one branch case
if(currentTube_Calc(root).nextBranchesLocEnd(ind(1))== 1 )
    
    Output = Output + checkSidebranch (currentTube_Calc(root).nextBranches(ind(1))) ;
else
    Output = 1 ; 
end

return ; 