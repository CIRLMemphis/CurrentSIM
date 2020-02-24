classdef useMyFFTW < coder.fftw.StandaloneFFTW3Interface
     
    methods (Static)
        function th = getNumThreads
            coder.inline('always');
            th = int32(coder.const(1));
        end
                
        function updateBuildInfo(buildInfo, ctx)
            fftwLocation = '/home/cvan/soft/fftw';
            includePath = fullfile(fftwLocation, 'include');
            buildInfo.addIncludePaths(includePath);
            libPath = fullfile(fftwLocation, 'lib');
            buildInfo.addLinkFlags(sprintf('-Wl,-rpath,"%s"',libPath));
            
            %Double
            libName1 = 'libfftw3';
            [~, libExt] = ctx.getStdLibInfo();
            libName1 = [libName1 libExt];
            addLinkObjects(buildInfo, libName1, libPath, 1000, true, true);
        end
    end           
end
