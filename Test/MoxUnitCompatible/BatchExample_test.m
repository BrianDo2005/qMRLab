function test_suite=BatchExample_test
try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions=localfunctions();
catch % no problem; early Matlab versions can use initTestSuite fine
end
initTestSuite;

function TestSetup
setenv('ISTRAVIS','1') % go faster! Fit only 2 voxels in FitData.m

function test_batch
curdir = pwd;

if exist('/home/travis','dir')
    tmpDir = '/home/travis/build/neuropoly/qMRLab/osfData';
else
    tmpDir = tempdir;
end
mkdir(tmpDir);
cd(tmpDir)

Modellist = list_models';
%***TEMP(May 8th 2018): skip qmt_spgr to shorten TRAVIS test***
IndexC=strfind(Modellist,'qmt_spgr');
Index = find(not(cellfun('isempty', IndexC)));
Modellist(Index) = [];

IndexC=strfind(Modellist,'qmt_bssfp');
Index = find(not(cellfun('isempty', IndexC)));
Modellist(Index) = [];

IndexC=strfind(Modellist,'qmt_sirfse');
Index = find(not(cellfun('isempty', IndexC)));
Modellist(Index) = [];
%***TEMP(May 8th 2018): skip qmt_spgr to shorten TRAVIS test***
for iModel = 1:length(Modellist)
    disp('===============================================================')
    disp(['Testing: ' Modellist{iModel} ' BATCH...'])
    disp('===============================================================')
    
    
    eval(['Model = ' Modellist{iModel}]);
    
    
    
    
    
    
    
    qMRgenBatch(Model,pwd)
    
    
    
    
    % Test if any dataset exist
    isdata = true;
    try
        Model.onlineData_url;
    catch
        isdata = false;
    end
    
    % Run Batch
    if isdata
        starttime = tic;
        eval([Modellist{iModel} '_batch'])
        toc(starttime)
    end
    close all
    cd ..
    
end
cd(curdir)


function TestTeardown
setenv('ISTRAVIS','0')

