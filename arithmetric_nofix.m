function imageRT
% �X�y�[�X�L�[�������ƋÎ��_���掦����A�w�肵�����Ԍ�ɉ摜���掦�����B
% F�܂���J�̃L�[�������ƁA�ǂ���̃L�[�����������A���̔������Ԃ��L�^�����B
% 1�u���b�N�̎��s���̓t�H���_���̉摜���ŁArepeatNum���g���ČJ��Ԃ��񐔂��w��\�B
%----------------------------------------
% �w�i�F 
bgColor = [128 128 128]; %RGB�̒l
% �摜���g��k�����Ē掦����Ƃ��̊����B�P�̂Ƃ��I���W�i���̃T�C�Y�i�����_OK�j
imgRatio = 1; 
% �J��Ԃ���
repeatNum = 1;
% �����s���Ƃɋx�e���b�Z�[�W��\�����邩
restNum = 4;
%---------------------------------
% �Î��_
fixTime = 0.75; %�Î��_�̒񎦎��ԁi�P�ʂ͕b�B�����_OK�j
fixLength = 40; %�Î��_�����̒����i�P�ʂ̓s�N�Z���B�����j
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
%rng('shuffle') % �V����Matlab
    
HideCursor;
%---------------------------------
try
    screenNumber = max(Screen('Screens')); %�h����掦����f�B�X�v���C�i�E�B���h�E�j�̐ݒ�
    
    % �f�o�b�O�p�B�E�B���h�E�ł̒掦
    %[windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [10 50 1120 800]);
    % �����p�B�t���X�N���[��
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor);

    ifi = Screen('GetFlipInterval', windowPtr); % �P�t���[���̎��� (inter flame interval)
    [centerPos(1), centerPos(2)] = RectCenter(windowRect); %��ʂ̒����̍��W
   
    % �摜��ۑ����Ă���t�H���_��
    %imgFolder = ['images_example_q' filesep];
    %imgFolder2 = ['images_example_a' filesep];
    % 2��
    imgFolder = ['arithmetric2_1_q' filesep];
    imgFolder2 = ['arithmetric2_1_a' filesep];
    %imgFolder = ['arithmetric2_2_q' filesep];
    %imgFolder2 = ['arithmetric2_2_a' filesep];
    %imgFolder = ['arithmetric2_3_q' filesep];
    %imgFolder2 = ['arithmetric2_3_a' filesep];
    % 3��
    %imgFolder = ['arithmetric3_1_q' filesep];
    %imgFolder2 = ['arithmetric3_1_a' filesep];
    %imgFolder = ['arithmetric3_2_q' filesep];
    %imgFolder2 = ['arithmetric3_2_a' filesep];
    %imgFolder = ['arithmetric3_3_q' filesep];
    %imgFolder2 = ['arithmetric3_3_a' filesep];
    
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
    tmpStr = '�t�@�C����,�𓚕���,��������(ms),�Î��_/����(ms)';
    fprintf(Fid, '%s\n', tmpStr);
    
    trialNum = 0; % ���݂̎��s��
    
    DrawFormattedText(windowPtr, double('�������J�n���܂��B\n\n �����Z�̓������킩������X�y�[�X�������A\n\n ���ɕ\�������񓚂��������ꍇ��H���A�Ԉ���Ă���ꍇ��J�������Ă��������B\n\n �������ł�����X�y�[�X�L�[�������Ă��������B'), 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    KbWait([], 3);
    
    for k = 1: repeatNum % �u���b�N�̌J��Ԃ�
        order = [1:imgNum]; % �h����ԍ����Œ掦����Ƃ�
        %order = randperm(imgNum); % �����_���ɒ掦���邽��
        
        for i = 1 : imgNum % 1�u���b�N�̎��s���̓t�H���_���̉摜��
            
            % �t�@�C�����̐ݒ�
            imgFileName = char(imgFileList(order(i)).name); % �摜�̃t�@�C�����i�t�H���_���Ȃ��j
            imgFileName2 = [imgFolder imgFileName]; % �摜�̃t�@�C�����i�t�H���_��񂠂�j
            imgFileName3 = char(imgFileList2(order(i)).name); % �摜�̃t�@�C�����i�t�H���_���Ȃ��j
            imgFileName4 = [imgFolder2 imgFileName3]; % �摜�̃t�@�C�����i�t�H���_��񂠂�j
            %�摜�̓ǂݍ���
            imdata = imread(imgFileName2, 'jpeg');
            imdata2 = imread(imgFileName4, 'jpeg');
            %�摜�T�C�Y�̕��iix�j����̐��ɑ������A�摜�T�C�Y�̍����iiy�j���s�̐��̑����B
            [iy, ix, id] = size(imdata);
            [iy, ix, id] = size(imdata2);
            % �摜�̏����e�N�X�`���ɁB
            imagetex = Screen('MakeTexture', windowPtr, imdata);
            imagetex2 = Screen('MakeTexture', windowPtr, imdata2);  
            % �Î��_�̒掦
            alab_trigger(5, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl1 = Screen('Flip', windowPtr); % vbl1�͋Î��_��掦��������
            
            % �摜�̒掦
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex, [], [centerPos - tmp/2, centerPos + tmp/2]);
            vbl2 = Screen('Flip', windowPtr, vbl1 + fixTime - ifi / 2); % vbl1����fixTime�b��Ɏh���摜����ʂɒ掦
            % �񓚂�҂�
            while KbCheck; end; % ������̃L�[�������Ă��Ȃ����Ƃ��m�F
            while 1 % while ���̒������邮����܂��B
                [ keyIsDown, keyTime, keyCode ] = KbCheck; % �L�[�������ꂽ���A���̂Ƃ��̎��ԁA�ǂ̃L�[���A�̏����擾����
                %�e�w�͔������Ԃ��x�����ǔ�r���邩��ok
                %H��J�͔팱�҂ɂ���ĕς���
                %�𓚎��Ԃ���������ꍇ�͉�͂̍ۂɃJ�b�g
                %�킩��Ȃ��ꍇ/�ԈႦ�ĉ𓚃t�F�[�Y�Ɉڂ��Ă��܂����ꍇ�̓X�y�[�X�L�[�������Ă��炤
                if keyIsDown
                    if keyCode(KbName('Space'))
                        kaito = '��';
                        break;
                    end
                    % �L�[�𗣂������ǂ����̊m�F
                    while KbCheck; end
                end;
            end;
            
     fprintf(Fid, '%s,%s,%f,%f\n', imgFileName, kaito,(keyTime - vbl2) * 1000, (vbl2 - vbl1) * 1000);   
            
     % �摜�̒掦
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex2, [], [centerPos - tmp/2, centerPos + tmp/2]);
            vbl3 = Screen('Flip', windowPtr); 
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
                        %kaito = 1;
                        break;
                    end
                    
                    if keyCode(KbName('J'))
                        kaito = '��';
                        %kaito = 2;
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
                        
    % �f�[�^�̋L�^�i�P�s�ɂ܂Ƃ߂ď����Ă��悢�j
    %fprintf(Fid, '%d,%d,%s,%d', k, i, imgFileName, kaito);
    %fprintf(Fid, '%s,%s,%f,%f\n,%f\n', imgFileName, imgFileName3,kaito,(keyTime - vbl3) * 1000, (vbl3 - vbl2) * 1000, (vbl2 - vbl1) * 1000);
    fprintf(Fid, '%s,%s,%f,%f\n', imgFileName3, kaito,(keyTime - vbl3) * 1000, (vbl3 - vbl2) * 1000);
    
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