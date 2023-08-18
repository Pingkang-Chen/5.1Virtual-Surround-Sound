function [z_left,z_right,x,Fs]= convolutionBRIR(inputfileName,BRIR_file, N, overlapFactor)

% Extract the first N-long segment required for convolution with the 
% subsequent input signal
  [k, Fs] = audioread(BRIR_file, [1, N]); 

% extract the left channel of BRIR
   k_left = k(:,1);

% extract the right channel of BRIR
   k_right = k(:,2);

% apply hann window before all the FFT algorithm, in order to get more 
% realistic results and reduce spectral leakage
  hw = hann(N);   

% get the FFT results of the left channle of BRIR
    K_left = fft(k_left .* hw); 
% get the FFT results of the right kernel of BRIR
   K_right = fft(k_right .* hw);  
   
   % load an input signal
    [x, Fs] = audioread(inputfileName);
 
% downmix the input sigal into a mono signal as well
     if (size(x, 2) > 1)
          
         x = mean(x, 2);
     end
% Break the input signal into subframes and ensure the window size matches 
% the length of the segmented N-long BRIR,using audioFrames()function
   xFrames = audioFrames(x, N, overlapFactor);

% get the FFT result of all windowed subframes, or say,get the FFT result 
% of xFrames by adding each subframe's FFT 
   XFrames = fft(xFrames .* hw);

% convolve the FFT of xFrames with the left and right channel of BRIR 
% respectively to get the frequency domain
   ZFramesleft = K_left .* XFrames; 
   ZFramesright = K_right .* XFrames; 

% get the output signal by using IFFT and real function from its frequency 
% spectrum back to the time domain, which will be the audio samples with 
% all the real results  
   zFramesleft = real(ifft(ZFramesleft));  
   zFramesright = real(ifft(ZFramesright)); 

% apply hann window to the convolved signals
   zFramesleft = zFramesleft .* hw; 
   zFramesright = zFramesright .* hw; 

% use overlap-add method to reconstruct the output signals,using 
% frameAssembler()function
   z_left = frameAssembler(zFramesleft, overlapFactor); 
   z_right = frameAssembler(zFramesright, overlapFactor);

end
































  
 

  






   
   


   
   
 
   

   
  

   





  






    
   

   



   





      
    