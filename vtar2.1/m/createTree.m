function createTree(File)
global VT ;
global Tube1 Mode ;

% File = 'samp_vowel.txt' ;
% File = 'samp_nasal_special1.txt' ;
% //	char *inFileName = "samp2New.txt", *outFileName = "simulation2.out";
% 	char *inFileName = "samp_lateral.txt", *outFileName = "simulation4.out";
% //	char *inFileName = "samp_vowel.txt", *outFileName = "simulation4.out";
% //	char *inFileName = "samp_nasal_n.txt", *outFileName = "simulation4.out";
% //	char *inFileName = "samp_nasal_special1.txt", *outFileName = "simulation4.out";
% //	char *inFileName = "samp3.txt", *outFileName = "simulation4.out";
 
 
inFilePtr = fopen(File) ;

% initialization of this tree
Mode = 0 ;
for i = 1: VT.maxnumTubes
    Tube1(i).IndexOfBranch = [ -1 ] ;
    Tube1(i).typeOfModule  = [ 1 ] ;
    Tube1(i).typeOfStartofTube = [ 1 ] ;
    Tube1(i).typeOfEndofTube   = [ 1 ] ;
    Tube1(i).numOfSections = [ 0 ] ;
    Tube1(i).secLen = zeros(1, 200) ;
    Tube1(i).secArea = zeros(1, 200) ;
    Tube1(i).numOfSections1 = [ 0 ] ;
    Tube1(i).secLen1 = zeros(1, 200) ;
    Tube1(i).secArea1 = zeros(1, 200) ;
    Tube1(i).nextBranches = zeros(1, 10) ;
    Tube1(i).nextBranchesLoc =  zeros(1, 10) ;
    Tube1(i).nextBranchesLocEnd =  zeros(1, 10) ;
    Tube1(i).nextBranchesLocChannel =  ones(1, 10) ;
    
end

readTree(inFilePtr) ;

if (Mode ~= 0) % successful  to read file properly
    VT.Arbitrary.Geometry.Mode = Mode ;
    VT.Arbitrary.Geometry.Tube  = Tube1 ;
end

fclose(inFilePtr) ;
return ;


function readTree(inFilePtr) ;
global VT ;
global Tube1  ;
global SingleTube Mode

Mode = 1 ;

TWOCHANNELS = 2 ;

% mode
temp = readAndParse(inFilePtr) ;
if ~temp
    return ;
end

for i=1: VT.maxnumTubes
    SingleTube.IndexOfBranch = [ -1 ] ;
    SingleTube.typeOfModule  = [ 1 ] ;
    SingleTube.typeOfStartofTube = [ 1 ] ;
    SingleTube.typeOfEndofTube   = [ 1 ] ;
    SingleTube.numOfSections = [ 0 ] ;
    SingleTube.secLen = zeros(1, 200) ;
    SingleTube.secArea = zeros(1, 200) ;
    SingleTube.numOfSections1 = [ 0 ] ;
    SingleTube.secLen1 = zeros(1, 200) ;
    SingleTube.secArea1 = zeros(1, 200) ;
    SingleTube.nextBranches = zeros(1, 10) ;
%    SingleTube.nextBranchesLoc =  zeros(1, 10) ;
    SingleTube.nextBranchesLoc =  ones(1, 10) ;
    SingleTube.nextBranchesLocEnd =  zeros(1, 10) ;
    SingleTube.nextBranchesLocChannel =  ones(1, 10) ;
    
    
    % read node, first 9 lines
    % if not successful , break out
    for i=1: 9
        % SingleTube.IndexOfBranch = SingleTube.IndexOfBranch ; % for temporary debug use
        if (~readAndParse(inFilePtr))
            Mode = 0 ;
            return ;
        end
    end    
    
    if(SingleTube.typeOfModule == TWOCHANNELS)
        % // move data from sec? to sec?1 
        % for temporary storage
        tempSingleTube.secLen = SingleTube.secLen ;
        tempSingleTube.secArea = SingleTube.secArea ;
        tempSingleTube.numOfSections = SingleTube.numOfSections ;
        
        % // read data for another channels
        for i = 1: 3
            if (~readAndParse(inFilePtr))
                Mode = 0 ;
                return ;
            end
        end   
        SingleTube.secLen1 = SingleTube.secLen ;
        SingleTube.secArea1 = SingleTube.secArea ;
        SingleTube.numOfSections1 = SingleTube.numOfSections ;
        
        % restore data in channel 1
        SingleTube.secLen  = tempSingleTube.secLen   ;
        SingleTube.secArea = tempSingleTube.secArea  ;
        SingleTube.numOfSections = tempSingleTube.numOfSections  ;
    end
    
    % SingleTube
    if (SingleTube.IndexOfBranch ~= -1)
        Tube1(SingleTube.IndexOfBranch) = SingleTube ;
    end
end
return ;




function Output = readAndParse(inFilePtr)
global VT ;
global SingleTube Mode ;

ORAL_MODE = 2 ;
NASAL_MODE = 3 ;
ORALNASAL_MODE = 4 ;

TWOCHANNELS = 2 ;
GLOTTIS = 2 ;
LIPS = 2 ;
NOSTRIL1 = 3 ;
NOSTRIL2 = 4 ;


END = 99900000  ;
CHANNEL_1 =  20000000 ; 
CHANNEL_2 =  40000000 ;

Output = 0 ;

lineString = fgets(inFilePtr) ;
saveLineString = lineString ;
if (isempty(lineString)) % at the end of file  or 
    Output = 1
    return  ;
end

[firsttoken lineString] = strtok(lineString);
if (isempty(firsttoken) | firsttoken(1) == '%')
    Output = readAndParse(inFilePtr) ;
    return ;
    
elseif ((firsttoken(1) == '<') & (firsttoken(end) == '>'))
    
    %// Remove the < and > braces from the token and get commandString
    commandString = firsttoken(2:end-1);
    if (Mode == 1)
        
        if (strcmpi(commandString,'Mode') == 1)
            
            [tempString lineString] = strtok(lineString);
            if (strcmpi(tempString,'Oral') == 1) Mode = ORAL_MODE;
            elseif (strcmpi(tempString,'Nasal') == 1) Mode = NASAL_MODE;
            elseif (strcmpi(tempString,'OralNasal') == 1) Mode = ORALNASAL_MODE;
            end
        else
            
            errordlg('ERROR: <Mode> must be the first definition in the file\n');
            return ; 
        end
        
    elseif (strcmpi(commandString,'indexOfBranch') == 1)
        [tempString lineString] = strtok(lineString);
        if(~isempty(tempString))
            SingleTube.IndexOfBranch = round (str2double(tempString) );
            if (SingleTube.IndexOfBranch <=0 | SingleTube.IndexOfBranch> VT.maxnumTubes)
                errordlg(['ERROR in IndexOfBranch (0< <30): ' saveLineString]);
                return ; 
            end
        else
            errordlg(['ERROR: in the file, \n' saveLineString]);
            return ; 
        end
        
    elseif (strcmpi(commandString,'typeOfStartofTube') == 1)
        
        [tempString lineString] = strtok(lineString);
        if(~isempty(tempString))
            if (strcmpi(tempString,'GLOTTIS') == 1) SingleTube.typeOfStartofTube = GLOTTIS; end
        end
        
        %                 else
        % 					errordlg(['ERROR: in the file, \n' saveLineString]);
        %                 end
        
        
    elseif (strcmpi(commandString,'typeOfEndofTube') == 1)
        
        [tempString lineString] = strtok(lineString);
        if(~isempty(tempString))
            
            if (strcmpi(tempString,'LIPS') == 1) SingleTube.typeOfEndofTube = LIPS;
            elseif (strcmpi(tempString,'NOSTRIL1') == 1) SingleTube.typeOfEndofTube = NOSTRIL1;
            elseif (strcmpi(tempString,'NOSTRIL2') == 1) SingleTube.typeOfEndofTube = NOSTRIL2;
            end
        end
        
        
        
        
    elseif (strcmpi(commandString,'nextBranches') == 1)
        %// reading index of branches  
        for i=1 : VT.maxnumSidebranch
            
            [tempString lineString] = strtok(lineString);
            if (~isempty(tempString))
                SingleTube.nextBranches(i) = str2double(tempString) ;
               SingleTube.nextBranchesLocEnd(i)= 1 ; % assume at end 

            else
                break ;
            end
        end
        
        
        
    elseif (strcmpi(commandString,'nextBranchesLocation') == 1)
        %// reading location of branches 
        for i=1 : VT.maxnumSidebranch
            
            [tempString lineString] = strtok(lineString);
            if (~isempty(tempString))
                
                if(strcmpi(tempString,'CHANNEL1') == 1) 
                    
                    SingleTube.nextBranchesLocChannel(i) = 1;
                    [tempString lineString] = strtok(lineString);
                    if (~isempty(tempString))
                        SingleTube.nextBranchesLoc(i)= str2double(tempString) ; % + CHANNEL_1;
                        SingleTube.nextBranchesLocEnd(i)= 0 ;
                    else
                        errordlg(['ERROR: in the file, \n' saveLineString]);
                        return ; 
                        
                    end
                    
                elseif(strcmpi(tempString,'CHANNEL2') == 1) 
                    
                    SingleTube.nextBranchesLocChannel(i) = 2;
                    [tempString lineString] = strtok(lineString);
                    if (~isempty(tempString))
                        SingleTube.nextBranchesLoc(i)= str2double(tempString) ; %  + CHANNEL_2;
                        SingleTube.nextBranchesLocEnd(i)= 0 ;
                    else
                        errordlg(['ERROR: in the file, \n' saveLineString]);
                        return ; 
                    end
                    
                elseif(strcmpi(tempString,'END') ~= 1)  % // END: default value
                    SingleTube.nextBranchesLoc(i) = str2double(tempString);
                    SingleTube.nextBranchesLocEnd(i)= 0 ;
                else
                    SingleTube.nextBranchesLocEnd(i)= 1 ;
                end
                
            else
                break ;
            end
        end
        
        
    elseif (strcmpi(commandString,'typeOfModule') == 1)
        %  // reading index of branches , not done 
        [tempString lineString] = strtok(lineString);
        if(~isempty(tempString))
            if (strcmpi(tempString,'TWOCHANNELS') == 1) SingleTube.typeOfModule = TWOCHANNELS; end
        end
        
    elseif (strcmpi(commandString,'numOfSections') == 1)
        [tempString lineString] = strtok(lineString);
        if(~isempty(tempString))
                if(isempty(tempString))
                    
                    errordlg( ['ERROR: ' saveLineString]) ;
                    return ; 
                    
                else 
                    SingleTube.numOfSections = str2double(tempString);
                end					 
        end
        
    elseif (strcmpi(commandString,'secLen') == 1)
        
        if (SingleTube.numOfSections == 0) 
            
            errordlg( ['ERROR: Trying to define section lengths before defining the number of sections at line :' saveLineString]) ;
            return ; 
            
        else
            for i = 1: SingleTube.numOfSections
                
                [tempString lineString] = strtok(lineString);
                if(isempty(tempString))
                    
                    errordlg( ['ERROR: ' saveLineString]) ;
                    return ; 
                    
                else 
                    SingleTube.secLen(i) = str2double(tempString);
                end					 
            end
        end
        
    elseif (strcmpi(commandString,'secArea') == 1)
        
        if (SingleTube.numOfSections == 0) 
            
            errordlg( ['ERROR: Trying to define section lengths before defining the number of sections at line %hd\n' saveLineString]) ;
            return ; 
            
        else
            for i = 1: SingleTube.numOfSections
                
                [tempString lineString] = strtok(lineString);
                if(isempty(tempString))
                    
                    errordlg( ['ERROR: ' saveLineString]) ;
                    return ; 
                    
                else 
                    SingleTube.secArea(i) = str2double(tempString);
                end					 
            end
        end
    end
end
Output = 1 ;                
return ;