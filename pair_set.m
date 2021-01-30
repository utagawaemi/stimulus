function imageRT
% スペースキーを押すと凝視点が呈示され、指定した時間後に画像が呈示される。
% HまたはJのキーを押すと、どちらのキーを押したか、その反応時間が記録される。
%----------------------------------------
bgColor = [128 128 128]; %% 背景色
imgRatio = 1; % 画像を拡大縮小して呈示するときの割合。１のときオリジナルのサイズ（小数点OK）
repeatNum = 1;% 繰り返し回数
%---------------------------------
wordTime = 3.0;%%単語の提示時間(プレ)
restTime = 5.0; %休憩時間(プレ)
%wordTime = 5.0;%%単語の提示時間
%restTime = 10.0; %休憩時間
% 凝視点
fixTime = 0.75; %凝視点の提示時間（単位は秒。小数点OK）
fixLength = 40; %凝視点線分の長さ（単位はピクセル。整数）% 凝視点
%凝視点の座標
fixApex = [
  fixLength/2, -fixLength/2, 0, 0;
  0, 0, fixLength/2, -fixLength/2];
fontSize = 30; % 文字サイズ（整数）
%---------------------------------
% 実験参加者名の入力
SubName = input('Name? ', 's'); % 名前をたずねる
if isempty(SubName) % 名前の入力がなかったらプログラムを終了
    return;
end;
% 出力ファイルの上書き確認を行う
SaveFileName=[SubName '.csv']; % 出力ファイル名
if exist(SaveFileName, 'file') % すでに同じ名前のファイルが存在していないかの確認
    resp=input([SaveFileName 'はすでに存在します。上書きをしてよい場合は y を入力してエンターキーを押してください。'], 's');
    if ~strcmp(resp,'y') 
        disp('プログラムを強制終了しました。')
        return
    end
end
% 呼び出しておいたほうがよい関数たち。
AssertOpenGL; 
KbName('UnifyKeyNames');
ListenChar(2); % Matlabに対するキー入力を無効
%myKeyCheck; % 外部ファイル
GetSecs;
WaitSecs(0.1);
%rand('state', sum(100*clock)); % 古いMatlab
rng('shuffle') % 新しいMatlab
HideCursor;
%---------------------------------
try
    screenNumber = max(Screen('Screens'));% 刺激を呈示するディスプレイ（ウィンドウ）の設定
    
    % デバッグ用。ウィンドウでの呈示
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [10 50 1120 800]);
    % 実験用。フルスクリーン
    %[windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor);
  
    ifi = Screen('GetFlipInterval', windowPtr); %1フレームの時間 (inter flame interval)
    [centerPos(1), centerPos(2)] = RectCenter(windowRect); %画面の中央の座標
   

    % 画像を保存しているフォルダ名
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
    imgNum = size(imgFileList, 1); % フォルダ内の画像の枚数
        imgFileList2 = dir([imgFolder2 '*.jpeg']);   
    imgNum = size(imgFileList2, 1); % フォルダ内の画像の枚数      
    %------------------------------
    % フォント設定
    if IsWin
        %Screen('TextFont', windowPtr, 'メイリオ');
        Screen('TextFont', windowPtr, 'Courier New');
    end;
   
    if IsOSX
        % DrawHighQualityUnicodeTextDemoを参照。
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
              
    % 出力ファイルを開く
    Fid = fopen(SaveFileName, 'wt');
    fprintf(Fid, '%s\n', SubName);
    fprintf(Fid, '%s\n', datestr(now, 'yy-mmdd-HH:MM'));
    fprintf(Fid, '%s\n', '');
    fprintf(Fid, 'imgRatio,%f\n', imgRatio);
    fprintf(Fid, 'fixTime,%f\n', fixTime);
    fprintf(Fid, 'fontSize,%d\n', fontSize);
    fprintf(Fid, 'ifi (ms),%f\n', ifi * 1000);
    fprintf(Fid, '%s\n', '');
    tmpStr = 'ファイル名,解答方向, 反応時間(ms),凝視点(ms)';
    fprintf(Fid, '%s\n', tmpStr);
    
    
    trialNum = 0; % 現在の試行数
    
    DrawFormattedText(windowPtr, double('実験を開始します。スペースキーを押してください。'), 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    KbWait([], 3);
    for k = 1: repeatNum % ブロックの繰り返し
        %order = [1:imgNum]; % 刺激を番号順で呈示するとき
        order = randperm(imgNum); % 刺激をランダムで呈示するとき
        
        for i = 1 : imgNum % 1ブロックの試行数はフォルダ内の画像数
            
            % ファイル名の設定
            imgFileName = char(imgFileList(order(i)).name); % 画像のファイル名（フォルダ情報なし）
            imgFileName2 = [imgFolder imgFileName]; % 画像のファイル名（フォルダ情報あり）
                     
            %画像の読み込み
            imdata = imread(imgFileName2, 'jpg');
            %画像サイズの幅（ix）が列の数に相当し、画像サイズの高さ（iy）が行の数の相当。
            [iy, ix, id] = size(imdata);
            % 画像の情報をテクスチャに。
            imagetex = Screen('MakeTexture', windowPtr, imdata);
               
            % 凝視点の呈示
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl1 = Screen('Flip', windowPtr); % vbl1は凝視点を呈示した時間
            % 画像の呈示
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex, [], [centerPos - tmp/2, centerPos + tmp/2]);
            alab_trigger(1, windowPtr, windowRect);
            vbl2 = Screen('Flip', windowPtr, vbl1 + fixTime - ifi / 2); % vbl1からfixTime秒後に刺激画像を画面に呈示
            
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl1 = Screen('Flip', windowPtr, vbl2 + wordTime); 
        end;
    end;
    DrawFormattedText(windowPtr, double('終了'), 'center', 'center', [255 255 255]);
    vbl1 = Screen('Flip', windowPtr, vbl2 + wordTime); 
    
    Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
    vbl2 = Screen('Flip', windowPtr, vbl1 + wordTime);
    
    Screen('DrawLines', windowPtr, fixApex, 4, [0 0 0], centerPos, 0);
    vbl1 = Screen('Flip', windowPtr, vbl2 + restTime);
    
    Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
    vbl1 = Screen('Flip', windowPtr, vbl1 + wordTime);

    %回答フェーズ
    for k = 1: repeatNum % ブロックの繰り返し
        %order = [1:imgNum]; % 刺激を番号順で呈示するとき
        order = randperm(imgNum); % ランダムに呈示するため
        
        for i = 1 : imgNum % 1ブロックの試行数はフォルダ内の画像数
            
            % ファイル名の設定
            imgFileName3 = char(imgFileList2(order(i)).name); % 画像のファイル名（フォルダ情報なし）
            imgFileName4 = [imgFolder2 imgFileName3]; % 画像のファイル名（フォルダ情報あり）
                     
            %画像の読み込み
            imdata2 = imread(imgFileName4, 'jpeg');
            %画像サイズの幅（ix）が列の数に相当し、画像サイズの高さ（iy）が行の数の相当。
            [iy, ix, id] = size(imdata2);
            % 画像の情報をテクスチャに。
            imagetex = Screen('MakeTexture', windowPtr, imdata2);
              
            % 凝視点の呈示
            alab_trigger(9, windowPtr, windowRect);
            Screen('DrawLines', windowPtr, fixApex, 4, [255 255 255], centerPos, 0);
            vbl3 = Screen('Flip', windowPtr); % vbl1は凝視点を呈示した時間
            % 画像の呈示
            tmp = [ix, iy]*imgRatio;
            Screen('DrawTexture', windowPtr, imagetex, [], [centerPos - tmp/2, centerPos + tmp/2]);
            vbl4 = Screen('Flip', windowPtr, vbl3 + fixTime - ifi / 2); % vbl1からfixTime秒後に刺激画像を画面に呈示
            
            % 回答を待つ
            while KbCheck; end; % いずれのキーも押していないことを確認
            while 1 % while 文の中をぐるぐる回ります。
                [ keyIsDown, keyTime, keyCode ] = KbCheck; % キーが押されたか、そのときの時間、どのキーか、の情報を取得する
                %親指は反応時間が遅いけど比較するからok
                %HとJは被験者によって変える
                %解答時間が長すぎる場合は解析の際にカット
                %わからない場合/間違えて解答フェーズに移ってしまった場合はスペースキーを押してもらう
                if keyIsDown
                    if keyCode(KbName('H'))
                        kaito = '正';
                        break;
                    end
                    
                    if keyCode(KbName('J'))
                        kaito = '誤';
                        break;
                    end
                    
                    if keyCode(KbName('Space'))
                        kaito = ' ';
                        %kaito = 3;
                        break;
                    end
                    
                    % キーを離したかどうかの確認
                    while KbCheck; end
                end;
            end;
                        
    % データの記録
    fprintf(Fid, '%s,%s,%f,%f\n', imgFileName3, kaito,(keyTime - vbl4) * 1000, (vbl4 - vbl3) * 1000);
    
    
    trialNum = trialNum + 1;
    Screen('Close'); % テクスチャ情報を破棄
        end;
    end;
    DrawFormattedText(windowPtr, double('実験は終わりです。スペースキーを押してください'), 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    KbWait([], 3);
 
    %終了処理
    fclose(Fid); % ファイルを閉じる。
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
 
catch % 以下はプログラムを中断したときのみ実行される。
    if exist('Fid', 'var') % ファイルを開いていたら閉じる。
        fclose(Fid);
        disp('fclose');
    end;
    
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
end