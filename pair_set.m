function imageRT
% �X�y�[�X�L�[�������ƋÎ��_���掦����A�w�肵�����Ԍ�ɉ摜���掦�����B
% H�܂���J�̃L�[�������ƁA�ǂ���̃L�[�����������A���̔������Ԃ��L�^�����B
%----------------------------------------
bgColor = [128 128 128]; %% �w�i�F
imgRatio = 1; % �摜���g��k�����Ē掦����Ƃ��̊����B�P�̂Ƃ��I���W�i���̃T�C�Y�i�����_OK�j
repeatNum = 1;% �J��Ԃ���
%---------------------------------
wordTime = 3.0;%%�P��̒񎦎���(�v��)
restTime = 5.0; %�x�e����(�v��)
%wordTime = 5.0;%%�P��̒񎦎���
%restTime = 10.0; %�x�e����
% �Î��_
fixTime = 0.75; %�Î��_�̒񎦎��ԁi�P�ʂ͕b�B�����_OK�j
fixLength = 40; %�Î��_�����̒����i�P�ʂ̓s�N�Z���B�����j% �Î��_
%�Î��_�̍��W
fixApex = [
  fixLength/2, -fixLength/2, 0, 0;
  0, 0, fixLength/2, -fixLength/2];
fontSize = 30; % �����T�C�Y�i�����j
%---------------------------------
% �����Q���Җ��̓���
SubName = input('Name? ', 's'); % ���O�������˂�
if isempty(SubName) % ���O�̓��͂��Ȃ�������v���O�������I��
    return;
end;
% �o�̓t�@�C���̏㏑���m�F���s��
SaveFileName=[SubName '.csv']; % �o�̓t�@�C����
if exist(SaveFileName, 'file') % ���łɓ������O�̃t�@�C�������݂��Ă��Ȃ����̊m�F
    resp=input([SaveFileName '�͂��łɑ��݂��܂��B�㏑�������Ă悢�ꍇ�� y ����͂��ăG���^�[�L�[�������Ă��������B'], 's');
    if ~strcmp(resp,'y') 
        disp('�v���O�����������I�����܂����B')
        return
    end
end
% �Ăяo���Ă������ق����悢�֐������B
AssertOpenGL; 
KbName('UnifyKeyNames');
ListenChar(2); % Matlab�ɑ΂���L�[���͂𖳌�
%myKeyCheck; % �O���t�@�C��
GetSecs;
WaitSecs(0.1);
%rand('state', sum(100*clock)); % �Â�Matlab
rng('shuffle') % �V����Matlab
HideCursor;
%---------------------------------
try
    screenNumber = max(Screen('Screens'));% �h����掦����f�B�X�v���C�i�E�B���h�E�j�̐ݒ�
    
    % �f�o�b�O�p�B�E�B���h�E�ł̒掦
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [10 50 1120 800]);
    % �����p�B�t���X�N���[��
    %[windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor);
  
    ifi = Screen('GetFlipInterval', windowPtr); %1�t���[���̎��� (inter flame interval)
    [centerPos(1), centerPos(2)] = RectCenter(windowRect); %��ʂ̒����̍��W
   

    % �摜��ۑ����Ă���t�H���_��
    imgFolder = ['image_example_q' filesep];
    imgFolder2 = ['image_example_a' filesep];
    
    %japanese
    %imgFolder = ['japanese1_q' filesep];
    %imgFolder2 = ['japanese1_a' filesep];
    %imgFolder = ['japanese2_a' filesep];
    %imgFolder2 = ['japanese2_a' filesep];
    %imgFolder = ['japanese3_q' filesep];
    %imgFolder2 = ['japanese3_a' filesep];
    %number
    %imgFolder = ['number1_q' filesep]; 
    %imgFolder2 = ['number1_a' filesep];
    %imgFolder = ['number2_q' filesep];
    %imgFolder2 = ['number2_a' filesep]; 
    %imgFolder = ['number3_q' filesep];
    %imgFolder2 = ['number3_a' filesep];

    
        imgFileList = dir([imgFolder '*.jpeg']);   
    imgNum = size(imgFileList, 1); % �t�H���_���̉摜�̖���
        imgFileList2 = dir([imgFolder2 '*.jpeg']);   
    imgNum = size(imgFileList2, 1); % �t�H���_���̉摜�̖���      
    %------------------------------
    % �t�H���g�ݒ�
    if IsWin
        %Screen('TextFont', windowPtr, '���C���I');
        Screen('TextFont', windowPtr, 'Courier New');
    end;
   
    if IsOSX
        % DrawHighQualityUnicodeTextDemo���Q�ƁB
        allFonts = FontInfo('Fonts');
        foundfont = 0;
        for idx = 1:length(allFonts)
            %if strcmpi(allFonts(idx).name, 'Hiragino Mincho Pro W3')
            if strcmpi(allFonts(idx).name, 'Hiragino Sans W2')
                foundfont = 1;
                break;
            end
        end
        if ~foundfont
            error('Could not find wanted japanese font on OS/X !');
        end
        Screen('TextFont', windowPtr, allFonts(idx).number);     
    end;
    %------------------------------
              
    % �o�̓t�@�C�����J��
    Fid = fopen(SaveFileName, 'wt');
    fprintf(Fid, '%s\n', SubName);
    fprintf(Fid, '%s\n', datestr(now, 'yy-mmdd-HH:MM'));
    fprintf(Fid, '%s\n', '');
    fprintf(Fid, 'imgRatio,%f\n', imgRatio);
    fprintf(Fid, 'fixTime,%f\n', fixTime);
    fprintf(Fid, 'fontSize,%d\n', fontSize);
    fprintf(Fid, 'ifi (ms),%f\n', ifi * 1000);
    fprintf(Fid, '%s\n', '');
    tmpStr = '�t�@�C����,�𓚕���, ��������(ms),�Î��_(ms)';
    fprintf(Fid, '%s\n', tmpStr);
    
    
    trialNum = 0; % ���݂̎��s��
    
    DrawFormattedText(windowPtr, double('�������J�n���܂��B�X�y�[�X�L�[�������Ă��������B'), 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    KbWait([], 3);
    for k = 1: repeatNum % �u���b�N�̌J��Ԃ�
        %order = [1:imgNum]; % �h����ԍ����Œ掦����Ƃ�
        order = randperm(imgNum); % �h���������_���Œ掦����Ƃ�
        
        for i = 1 : imgNum % 1�u���b�N�̎��s���̓t�H���_���̉摜��
            
            % �t�@�C�����̐ݒ�
            imgFileName = char(imgFileList(order(i)).name); % �摜�̃t�@�C�����i�t�H���_���Ȃ��j
            imgFileName2 = [imgFolder imgFileName]; % �摜�̃t�@�C�����i�t�H���_��񂠂�j
                     
            %�摜�̓ǂݍ���
            imdata = imread(imgFileName2, 'jpg');
            %�摜�T�C�Y�̕��iix�j����̐��ɑ������A�摜�T�C�Y�̍����iiy�j���s�̐��̑����B
            [iy, ix, id] = size(imdata);
            % �摜�̏����e�N�X�`���ɁB
            imagetex = Screen('MakeTexture', windowPtr, imdata);
               
            % �Î��_�̒掦
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl1 = Screen('Flip', windowPtr); % vbl1�͋Î��_��掦��������
            % �摜�̒掦
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex, [], [centerPos - tmp/2, centerPos + tmp/2]);
            alab_trigger(1, windowPtr, windowRect);
            vbl2 = Screen('Flip', windowPtr, vbl1 + fixTime - ifi / 2); % vbl1����fixTime�b��Ɏh���摜����ʂɒ掦
            
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl1 = Screen('Flip', windowPtr, vbl2 + wordTime); 
        end;
    end;
    DrawFormattedText(windowPtr, double('�I��'), 'center', 'center', [255 255 255]);
    vbl1 = Screen('Flip', windowPtr, vbl2 + wordTime); 
    
    Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
    vbl2 = Screen('Flip', windowPtr, vbl1 + wordTime);
    
    Screen('DrawLines', windowPtr, fixApex, 4, [0 0 0], centerPos, 0);
    vbl1 = Screen('Flip', windowPtr, vbl2 + restTime);
    
    Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
    vbl1 = Screen('Flip', windowPtr, vbl1 + wordTime);

    %�񓚃t�F�[�Y
    for k = 1: repeatNum % �u���b�N�̌J��Ԃ�
        %order = [1:imgNum]; % �h����ԍ����Œ掦����Ƃ�
        order = randperm(imgNum); % �����_���ɒ掦���邽��
        
        for i = 1 : imgNum % 1�u���b�N�̎��s���̓t�H���_���̉摜��
            
            % �t�@�C�����̐ݒ�
            imgFileName3 = char(imgFileList2(order(i)).name); % �摜�̃t�@�C�����i�t�H���_���Ȃ��j
            imgFileName4 = [imgFolder2 imgFileName3]; % �摜�̃t�@�C�����i�t�H���_��񂠂�j
                     
            %�摜�̓ǂݍ���
            imdata2 = imread(imgFileName4, 'jpeg');
            %�摜�T�C�Y�̕��iix�j����̐��ɑ������A�摜�T�C�Y�̍����iiy�j���s�̐��̑����B
            [iy, ix, id] = size(imdata2);
            % �摜�̏����e�N�X�`���ɁB
            imagetex = Screen('MakeTexture', windowPtr, imdata2);
              
            % �Î��_�̒掦
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl3 = Screen('Flip', windowPtr); % vbl1�͋Î��_��掦��������
            % �摜�̒掦
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex, [], [centerPos - tmp/2, centerPos + tmp/2]);
            vbl4 = Screen('Flip', windowPtr, vbl3 + fixTime - ifi / 2); % vbl1����fixTime�b��Ɏh���摜����ʂɒ掦
            
            % �񓚂�҂�
            while KbCheck; end; % ������̃L�[�������Ă��Ȃ����Ƃ��m�F
            while 1 % while ���̒������邮����܂��B
                [ keyIsDown, keyTime, keyCode ] = KbCheck; % �L�[�������ꂽ���A���̂Ƃ��̎��ԁA�ǂ̃L�[���A�̏����擾����
                %�e�w�͔������Ԃ��x�����ǔ�r���邩��ok
                %H��J�͔팱�҂ɂ���ĕς���
                %�𓚎��Ԃ���������ꍇ�͉�͂̍ۂɃJ�b�g
                %�킩��Ȃ��ꍇ/�ԈႦ�ĉ𓚃t�F�[�Y�Ɉڂ��Ă��܂����ꍇ�̓X�y�[�X�L�[�������Ă��炤
                if keyIsDown
                    if keyCode(KbName('H'))
                        kaito = '��';
                        break;
                    end
                    
                    if keyCode(KbName('J'))
                        kaito = '��';
                        break;
                    end
                    
                    if keyCode(KbName('Space'))
                        kaito = ' ';
                        %kaito = 3;
                        break;
                    end
                    
                    % �L�[�𗣂������ǂ����̊m�F
                    while KbCheck; end
                end;
            end;
                        
    % �f�[�^�̋L�^
    fprintf(Fid, '%s,%s,%f,%f\n', imgFileName3, kaito,(keyTime - vbl4) * 1000, (vbl4 - vbl3) * 1000);
    
    
    trialNum = trialNum + 1;
    Screen('Close'); % �e�N�X�`������j��
        end;
    end;
    DrawFormattedText(windowPtr, double('�����͏I���ł��B�X�y�[�X�L�[�������Ă�������'), 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    KbWait([], 3);
 
    %�I������
    fclose(Fid); % �t�@�C�������B
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
 
catch % �ȉ��̓v���O�����𒆒f�����Ƃ��̂ݎ��s�����B
    if exist('Fid', 'var') % �t�@�C�����J���Ă��������B
        fclose(Fid);
        disp('fclose');
    end;
    
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
end