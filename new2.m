clear; close all; clc

figure('position',[150,150,1000,600])
% 1
% 尺寸
rows = 20;
cols = 20;
%
maze = zeros(rows,cols);

%
queue = [randi([2,rows-1]),randi([2,rows-1])];
dt = 1/12;
imwrite(uint8(maze*255),'test2.gif','LoopCount',Inf,'DelayTime',dt);


while 1
    r = queue(end,1);
    c = queue(end,2);   

    list = [];
        if r > 2 && c>1 && c<cols && maze(r-1,c)==0
        if maze(r-1,c-1)+maze(r-1,c+1)==0
           list = [list; r-1,c];
        end
    end
    if c > 2 && r>1 && r<rows && maze(r,c-1)==0
        if maze(r+1,c-1)+maze(r-1,c-1)==0
           list = [list; r,c-1];
        end
    end
    if r < rows-1 && c>1 && c<cols && maze(r+1,c)==0
        if maze(r+1,c-1)+maze(r+1,c+1)==0
           list = [list; r+1,c];
        end
    end
    if c < cols-1 && r>1 && r<rows && maze(r,c+1)==0
       if maze(r+1,c+1)+maze(r-1,c+1)==0
           list = [list; r,c+1];
        end
    end
    
    if ~isempty(list)
        % 走        
        choice = list(randi(size(list,1)),:);
        queue = [queue;choice];
        maze(choice(1),choice(2)) = 1;
       
        imwrite(uint8(maze*255),'test2.gif','WriteMode','append','DelayTime',dt);
        
    else
        queue(end,:) = [];
    end        
%     imagesc(maze),drawnow
    % 无路可走
    if isempty(queue)        
        break
    end
    
end
imagesc(maze),colormap(gray)
axis equal, axis off