function [output,x,Fs] = surround_5_1(inputfileName,BRIR_file1,BRIR_file2,BRIR_file3,BRIR_file4,BRIR_file5,N,overlapFactor)
        
        % convolving the input signal with the corresponding 5 angles' BRIRs 
        % for the 5.1 surround sound system. These 5 angles are
        % 0°,22.5°~ 45°,90°~ 120°,210°~ 240° and 315°~ 337.5°.
        [z1_left,z1_right,~,~] = convolutionBRIR(inputfileName,BRIR_file1, N, overlapFactor);
        [z2_left,z2_right,~,~] = convolutionBRIR(inputfileName,BRIR_file2, N, overlapFactor);
        [z3_left,z3_right,~,~]= convolutionBRIR(inputfileName,BRIR_file3, N, overlapFactor);
        [z4_left,z4_right,~,~]= convolutionBRIR(inputfileName,BRIR_file4, N, overlapFactor);
        [z5_left,z5_right,x,Fs]= convolutionBRIR(inputfileName,BRIR_file5, N, overlapFactor);
        
        % sum the left and right ears' signals respectively
         output_left = z1_left + z2_left + z3_left + z4_left + z5_left;
         output_right = z1_right + z2_right + z3_right + z4_right + z5_right;
      
    
        % combine the two summed signals(left and right) together to get the 
        % final stereo signal
         output = [output_left,output_right];
        
        % Find the maximum absolute value of the stereo signal
        max_val = max(abs(output(:)));
        
        % Scale the signal so that the maximum absolute value is 1(normalization)
        output = output / max_val;

        % ensure the output signal z and the input signal x have the same maximum 
        % absolute magnitude.
        output = output * max(abs(x));
        

end
