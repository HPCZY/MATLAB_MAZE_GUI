function MAZEGUI()

close all;
WW = 800;
WH = 600;
PW = 120;
band = 10;

% ����
Fig = figure('Position',[200,200,WW,WH],'Name','GUI','Color','white',...
    'menu','none','NumberTitle','off');
Fig.ResizeFcn = @ResizeWindow; % �������
FigSize = Fig.Position(3:4);
PnlG = uipanel(Fig,'Units','pixels','Position',[band,band,PW,FigSize(2)-2*band]);
PnlGSize = PnlG.Position(3:4);
PnlP = uipanel(Fig,'Units','pixels','Position',[FigSize(1)-band-PW,band,PW,FigSize(2)-2*band]);
PnlPSize = PnlP.Position(3:4);
PnlS = uipanel(Fig,'Units','pixels','Position',[band*2+PnlGSize(1),band,FigSize(1)-4*band-PnlGSize(1)-PnlPSize(1),FigSize(2)-2*band]);
PnlSSize = PnlS.Position(3:4);

BW = 30;
uicontrol(PnlG,'style','text',...
    'String','�ߴ�(��*��)','Fontsize',16,...
    'Units','pixels','Position',[0,PnlGSize(2)-BW-band,PW,BW]);
EtRow = uicontrol(PnlG,'style','edit',...
    'String','40','Fontsize',12,...
    'Units','pixels','Position',[0,PnlGSize(2)-2*BW-2*band,PW,BW]);
EtCol = uicontrol(PnlG,'style','edit',...
    'String','40','Fontsize',12,...
    'Units','pixels','Position',[0,PnlGSize(2)-3*BW-3*band,PW,BW]);
AlgorithmList = {'(������)�������','(������)���Prim','(������)�ݹ�ָ�',...
    '(�ڶ���)�������1','(�ڶ���)�������2','(�ڶ���)�������3','(�ڶ���)���Prim'};
Menu1 = uicontrol(PnlG,'style','popupmenu',...
    'String',AlgorithmList,'Fontsize',16,...
    'Units','pixels','Position',[0,PnlGSize(2)-5*BW-4*band,PW,BW*2]);
RB1 = uicontrol(PnlG,'style','radiobutton',...
    'String','��ʾ����','Fontsize',16,...
    'Units','pixels','Position',[0,PnlGSize(2)-6*BW-5*band,PW,BW]);
BtGenerate = uicontrol(PnlG,'style','pushbutton','String','����','Fontsize',16,...
    'Units','pixels','Position',[0,PnlGSize(2)-8*BW-6*band,PW,BW*2],...
    'Callback',@GenerateMaze);

Axes = axes(PnlS,'Units','normalized','Position',[0,0,1,1]);




Rows = 0;
Cols = 0;
L = 10;
[maze,block] = InitMaze(1,1,L);
showflag = 0;

    function GenerateMaze(~,~)
        Rows = str2double(get(EtRow,'string'));
        Cols = str2double(get(EtCol,'string'));
        showflag = get(RB1,'value');
        
        
        switch get(Menu1,'value')
            case 1 % '�������'
                [maze,block] = InitMaze(Rows,Cols,L);
                GenerateAlgorithm1()
                ShowMaze(maze,block,Axes)
            case 2 % '���Prim'
                [maze,block] = InitMaze(Rows,Cols,L);
                GenerateAlgorithm2()
                ShowMaze(maze,block,Axes)
            case 3 % '�ݹ�ָ�'
                [maze,block] = InitMaze(Rows,Cols,L);
                GenerateAlgorithm3()
                ShowMaze(maze,block,Axes)
            case 4 % '(�ڶ�)�������1'
                maze = zeros(Rows,Cols);
                GenerateAlgorithm4()
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
                case 5 % '(�ڶ�)�������2'
                maze = zeros(Rows,Cols);
                GenerateAlgorithm5()
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
                case 6 % '(�ڶ�)�������3'
                maze = zeros(Rows,Cols);
                GenerateAlgorithm6()
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
            case 7 % '(�ڶ�)���Prim'
                maze = zeros(Rows,Cols);
                GenerateAlgorithm7()
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
        end
        
    end

    function GenerateAlgorithm1(~,~)
        % ״̬
        r = randi(Rows);
        c = randi(Cols);
        queue = [r,c];
        
        while 1
            maze.state(r,c) = 1;
            % �ܱ�
            list = '';
            if r > 1 && maze.state(r-1,c)==0
                list = [list,'U'];
            end
            if c > 1 && maze.state(r,c-1)==0
                list = [list,'L'];
            end
            if r < Rows && maze.state(r+1,c)==0
                list = [list,'D'];
            end
            if c < Cols && maze.state(r,c+1)==0
                list = [list,'R'];
            end
            
            if ~isempty(list)
                % ��
                queue = [queue;r,c];
                choice = list(randi(length(list)));
                switch choice
                    case 'U'
                        maze.up(r,c) = 1;
                        r = r-1;
                        maze.down(r,c) = 1;
                    case 'L'
                        maze.left(r,c) = 1;
                        c = c-1;
                        maze.right(r,c) = 1;
                    case 'D'
                        maze.down(r,c) = 1;
                        r = r+1;
                        maze.up(r,c) = 1;
                    case 'R'
                        maze.right(r,c) = 1;
                        c = c+1;
                        maze.left(r,c) = 1;
                end
                % ��ʵ״̬
                if showflag
                    ShowMaze(maze,block,Axes)
                end
            else
                % ��·����
                if isempty(queue)
                    break
                end
                % ����辶ȡ
                r = queue(end,1);
                c = queue(end,2);
                queue(end,:) = [];
            end
        end
        
    end

    function GenerateAlgorithm2(~,~)
        % ״̬
        r = randi(Rows);
        c = randi(Cols);
        queue = [r,c];
        
        while 1
            if isempty(queue)
                break
            end
            % ����Ұ
            idx = randi(size(queue,1));
            r = queue(idx,1);
            c = queue(idx,2);
            queue(idx,:) = [];
            maze.state(r,c) = 1;
            % �ܱ�
            list = '';
            if r > 1
                if maze.state(r-1,c)==1
                    list = [list,'U'];
                elseif maze.state(r-1,c)==0
                    queue = [queue;r-1,c];
                    maze.state(r-1,c) = 2;
                end
            end
            if c > 1
                if maze.state(r,c-1)==1
                    list = [list,'L'];
                elseif maze.state(r,c-1)==0
                    queue = [queue;r,c-1];
                    maze.state(r,c-1) = 2;
                end
            end
            if r < Rows
                if maze.state(r+1,c)==1
                    list = [list,'D'];
                elseif maze.state(r+1,c)==0
                    queue = [queue;r+1,c];
                    maze.state(r+1,c) = 2;
                end
            end
            if c < Cols
                if maze.state(r,c+1)==1
                    list = [list,'R'];
                elseif maze.state(r,c+1)==0
                    queue = [queue;r,c+1];
                    maze.state(r,c+1) = 2;
                end
            end
            
            if ~isempty(list)
                % ��
                choice = list(randi(length(list)));
                switch choice
                    case 'U'
                        maze.up(r,c) = 1;
                        r = r-1;
                        maze.down(r,c) = 1;
                    case 'L'
                        maze.left(r,c) = 1;
                        c = c-1;
                        maze.right(r,c) = 1;
                    case 'D'
                        maze.down(r,c) = 1;
                        r = r+1;
                        maze.up(r,c) = 1;
                    case 'R'
                        maze.right(r,c) = 1;
                        c = c+1;
                        maze.left(r,c) = 1;
                end
                % ��ʵ״̬
                if showflag
                    ShowMaze(maze,block,Axes)
                end
            end
        end
        
    end

    function GenerateAlgorithm3(~,~)
        maze = Recursive_division(1, Rows, 1, Cols, maze, block,Axes);
    end

    function GenerateAlgorithm4(~,~)
        
        queue = [randi([2,Rows-1]),randi([2,Rows-1])];
        while 1
            r = queue(end,1);
            c = queue(end,2);
            
            list = [];
            if r > 2 && c>1 && c<Cols && maze(r-1,c)==0
                if maze(r-1,c-1)+maze(r-1,c+1)==0
                    list = [list; r-1,c];
                end
            end
            if c > 2 && r>1 && r<Rows && maze(r,c-1)==0
                if maze(r+1,c-1)+maze(r-1,c-1)==0
                    list = [list; r,c-1];
                end
            end
            if r < Rows-1 && c>1 && c<Cols && maze(r+1,c)==0
                if maze(r+1,c-1)+maze(r+1,c+1)==0
                    list = [list; r+1,c];
                end
            end
            if c < Cols-1 && r>1 && r<Rows && maze(r,c+1)==0
                if maze(r+1,c+1)+maze(r-1,c+1)==0
                    list = [list; r,c+1];
                end
            end
            
            if ~isempty(list)
                % ��
                choice = list(randi(size(list,1)),:);
                queue = [queue;choice];
                maze(choice(1),choice(2)) = 1;
            if showflag
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
            end
            else
                queue(end,:) = [];
            end

            % ��·����
            if isempty(queue)
                break
            end
            
        end
        
    end


    function GenerateAlgorithm5(~,~)
        
        queue = [randi([2,Rows-1]),randi([2,Rows-1])];
        while 1
            r = queue(end,1);
            c = queue(end,2);
            
            list = [];
            if r > 2 && c>1 && c<Cols && maze(r-1,c)==0
                if maze(r-1,c-1)+maze(r-1,c+1)+maze(r-2,c)==0
                    list = [list; r-1,c];
                end
            end
            if c > 2 && r>1 && r<Rows && maze(r,c-1)==0
                if maze(r+1,c-1)+maze(r-1,c-1)+maze(r,c-2)==0
                    list = [list; r,c-1];
                end
            end
            if r < Rows-1 && c>1 && c<Cols && maze(r+1,c)==0
                if maze(r+1,c-1)+maze(r+1,c+1)+maze(r+2,c)==0
                    list = [list; r+1,c];
                end
            end
            if c < Cols-1 && r>1 && r<Rows && maze(r,c+1)==0
                if maze(r+1,c+1)+maze(r-1,c+1)+maze(r,c+2)==0
                    list = [list; r,c+1];
                end
            end
            
            if ~isempty(list)
                % ��
                choice = list(randi(size(list,1)),:);
                queue = [queue;choice];
                maze(choice(1),choice(2)) = 1;
            if showflag
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
            end
            else
                queue(end,:) = [];
            end

            % ��·����
            if isempty(queue)
                break
            end
            
        end
        
    end


    function GenerateAlgorithm6(~,~)
        
        queue = [randi([2,Rows-1]),randi([2,Rows-1])];
        while 1
            r = queue(end,1);
            c = queue(end,2);
            
            list = [];
            if r > 2 && c>1 && c<Cols && maze(r-1,c)==0
                if maze(r-1,c-1)+maze(r-1,c+1)+maze(r-2,c)+maze(r-2,c-1)+maze(r-2,c+1)==0
                    list = [list; r-1,c];
                end
            end
            if c > 2 && r>1 && r<Rows && maze(r,c-1)==0
                if maze(r+1,c-1)+maze(r-1,c-1)+maze(r,c-2)+maze(r+1,c-2)+maze(r-1,c-2)==0
                    list = [list; r,c-1];
                end
            end
            if r < Rows-1 && c>1 && c<Cols && maze(r+1,c)==0
                if maze(r+1,c-1)+maze(r+1,c+1)+maze(r+2,c)+maze(r+2,c-1)+maze(r+2,c+1)==0
                    list = [list; r+1,c];
                end
            end
            if c < Cols-1 && r>1 && r<Rows && maze(r,c+1)==0
                if maze(r+1,c+1)+maze(r-1,c+1)+maze(r,c+2)+maze(r+1,c+2)+maze(r-1,c+2)==0
                    list = [list; r,c+1];
                end
            end
            
            if ~isempty(list)
                % ��
                choice = list(randi(size(list,1)),:);
                queue = [queue;choice];
                maze(choice(1),choice(2)) = 1;
            if showflag
                imagesc(maze),colormap(gray)
                axis equal,axis off
                drawnow
            end
            else
                queue(end,:) = [];
            end

            % ��·����
            if isempty(queue)
                break
            end
            
        end
        
    end



    function GenerateAlgorithm7(~,~)
        queue = [randi([2,Rows-1]),randi([2,Rows-1])];

        while 1
            
            idx = randi(size(queue,1));
            r = queue(idx,1);
            c = queue(idx,2);
            
            list = [];
            if r > 2 && c>1 && c<Cols && maze(r-1,c)==0
                if maze(r-1,c-1)+maze(r-1,c+1)+maze(r-2,c)+maze(r-2,c-1)+maze(r-2,c+1)==0
                    list = [list; r-1,c];
                end
            end
            if c > 2 && r>1 && r<Rows && maze(r,c-1)==0
                if maze(r+1,c-1)+maze(r-1,c-1)+maze(r,c-2)+maze(r+1,c-2)+maze(r-1,c-2)==0
                    list = [list; r,c-1];
                end
            end
            if r < Rows-1 && c>1 && c<Cols && maze(r+1,c)==0
                if maze(r+1,c-1)+maze(r+1,c+1)+maze(r+2,c)+maze(r+2,c-1)+maze(r+2,c+1)==0
                    list = [list; r+1,c];
                end
            end
            if c < Cols-1 && r>1 && r<Rows && maze(r,c+1)==0
                if maze(r+1,c+1)+maze(r-1,c+1)+maze(r,c+2)+maze(r+1,c+2)+maze(r-1,c+2)==0
                    list = [list; r,c+1];
                end
            end
            
            if ~isempty(list)
                % ��
                choice = list(randi(size(list,1)),:);
                queue = [queue;choice];
                maze(choice(1),choice(2)) = 1;
                
                if showflag
                    imagesc(maze),colormap(gray)
                    axis equal,axis off
                    drawnow
                 end
            else
                queue(idx,:) = [];
            end
            

            % ��·����
            if isempty(queue)
                break
            end
            
        end
        
    end

    function maze = Recursive_division(r1, r2, c1, c2, maze,block,H)
        if r1 < r2 && c1 < c2
            rm = randi([r1, r2-1]);
            cm = randi([c1, c2-1]);
            cd1 = randi([c1,cm]);
            cd2 = randi([cm+1,c2]);
            rd1 = randi([r1,rm]);
            rd2 = randi([rm+1,r2]);
            d = randi(4);
            switch d
                case 1
                    maze.right(rd2, cm) = 1;
                    maze.left(rd2, cm+1) = 1;
                    maze.down(rm, cd1) = 1;
                    maze.up(rm+1, cd1) = 1;
                    maze.down(rm, cd2) = 1;
                    maze.up(rm+1, cd2) = 1;
                case 2
                    maze.right(rd1, cm) = 1;
                    maze.left(rd1, cm+1) = 1;
                    maze.down(rm, cd1) = 1;
                    maze.up(rm+1, cd1) = 1;
                    maze.down(rm, cd2) = 1;
                    maze.up(rm+1, cd2) = 1;
                case 3
                    maze.right(rd1, cm) = 1;
                    maze.left(rd1, cm+1) = 1;
                    maze.right(rd2, cm) = 1;
                    maze.left(rd2, cm+1) = 1;
                    maze.down(rm, cd2) = 1;
                    maze.up(rm+1, cd2) = 1;
                case 4
                    maze.right(rd1, cm) = 1;
                    maze.left(rd1, cm+1) = 1;
                    maze.right(rd2, cm) = 1;
                    maze.left(rd2, cm+1) = 1;
                    maze.down(rm, cd1) = 1;
                    maze.up(rm+1, cd1) = 1;
            end
            maze = Recursive_division(r1, rm, c1, cm, maze,block,H);
            maze = Recursive_division(r1, rm, cm+1, c2, maze,block,H);
            maze = Recursive_division(rm+1, r2, cm+1, c2, maze,block,H);
            maze = Recursive_division(rm+1, r2, c1, cm, maze,block,H);
            
        elseif r1 < r2
            rm = randi([r1, r2-1]);
            maze.down(rm,c1) = 1;
            maze.up(rm+1,c1) = 1;
            maze = Recursive_division(r1, rm, c1, c1, maze,block,H);
            maze = Recursive_division(rm+1, r2, c1, c1, maze,block,H);
        elseif c1 < c2
            cm = randi([c1,c2-1]);
            maze.right(r1,cm) = 1;
            maze.left(r1,cm+1) = 1;
            maze = Recursive_division(r1, r1, c1, cm, maze,block,H);
            maze = Recursive_division(r1, r1, cm+1, c2, maze,block,H);
        end
        if showflag
            ShowMaze(maze,block,H)
        end
    end




    function ShowMaze(maze,block,Axes)
        state = maze.up*8 + maze.left*4 + maze.down*2 + maze.right;
        [Rows,Cols] = size(state);
        len = size(block,1);
        for r = 1:Rows
            for c = 1:Cols
                a = (r-1)*len;
                b = (c-1)*len;
                maze.image(a+1:a+len,b+1:b+len) = block(:,:,state(r,c)+1);
            end
        end
        imshow(maze.image,[],'Parent',Axes),drawnow
    end


    function ResizeWindow(~, ~)
        FigSize = Fig.Position(3:4);
        FigSize(1) = max(FigSize(1),WW);
        FigSize(2) = max(FigSize(2),WH);
        Fig.Position(3:4) = FigSize;
        
        % ��Ȳ���
        PnlG.Position = [band,band,PW,FigSize(2)-2*band];
        PnlGSize = PnlG.Position(3:4);
        PnlP.Position = [FigSize(1)-band-PW,band,PW,FigSize(2)-2*band];
        PnlPSize = PnlP.Position(3:4);
        % Pnl2�ȱ�����
        PnlS.Position = [band*2+PnlGSize(1),band,FigSize(1)-4*band-PnlGSize(1)-PnlPSize(1),FigSize(2)-2*band];
        PnlSSize = PnlS.Position(3:4);
    end

end


function [maze,block] = InitMaze(Rows,Cols,L)
maze.state = zeros(Rows,Cols);
maze.up = zeros(Rows,Cols);
maze.left = zeros(Rows,Cols);
maze.down = zeros(Rows,Cols);
maze.right = zeros(Rows,Cols);
maze.image = zeros(Rows*L,Cols*L);
block = getblock(L);
end

function block = getblock(L)

block = ones(L,L,16);

for n = 1:16
    tmp = dec2bin(n-1,4);
    if tmp(1)=='0'
        block(1,:,n) = 0;
    end
    if tmp(2)=='0'
        block(:,1,n) = 0;
    end
    if tmp(3)=='0'
        block(end,:,n) = 0;
    end
    if tmp(4)=='0'
        block(:,end,n) = 0;
    end
    block(1,1,n) = 0;
    block(end,end,n) = 0;
    block(end,1,n) = 0;
    block(1,end,n) = 0;
end

end


