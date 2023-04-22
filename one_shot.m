clc 
clear
close all


save_output = false;  % If you want to save each frame change it to True

videoReader = vision.VideoFileReader('C:\Users\Younes\Desktop\2eagles.mp4');  % Read sample matlab video
writerObj = VideoWriter('C:\Users\Younes\Desktop\best_model.mp4','MPEG-4');        % Create video writer object
writerObj.FrameRate = 24;             
open(writerObj);
frameStart = 1;
frameEnd = 100;
fcount = 0; 
frames = {};


address = 'C:\Users\shokoohy\Desktop\frames\function\';
hBlob = vision.BlobAnalysis( ...
            'AreaOutputPort',false, ...
            'BoundingBoxOutputPort',false, ...
            'OutputDataType','single');



for count = 1:frameEnd                  % The number of frames to process
    disp(count);                        % Display the current frame number
    frame = step(videoReader);          % Read the next video frame
    frameGray = rgb2gray(frame);        % Convert the frame to grayscale
    frames{count} = frameGray;
    frameSize = size(frameGray);        % Get the dimensions of the frame
    if count ==frameStart
        bkFrame = frameGray;            % Get the first frame as background frame
    end
    
    if count>=frameStart
        if count ~= 1
        bkFrame = frames{count-1};
        end
        fcount = fcount+1;
        frameDif = abs(bkFrame - frameGray);    % The difference between the two frames
        frameBW = imbinarize(frameDif , 0.08); % Covert the frame to binary  0.1
%         frameBW2 = bwareaopen(frameBW,50);      % Remove blobs smaller than 50 (Turn dark foreground to white)
%         se = strel('disk',2);                  % Use a disk of radius 10 to dialte and erode object shape
        se = strel('disk',1); 
        frameBW3 = imdilate(frameBW,se);       % Dialate the object shape
        frameBW3 = imerode(frameBW3,se);        % Erode the object shape
        frameBW3 = bwareaopen(frameBW3,50);
        frameBW3 = imclose(frameBW3, strel('disk', 5));
%         tring(im2double(frame), im2double(frameBW3), count, save_output);


    strel_size = 22;
    Im = imdilate(im2double(frameBW3), strel('square', strel_size));
    th = multithresh(Im);
    BW = Im > th;
    Centroids = step(hBlob,BW); 
    StaplesCount = int32(size(Centroids,1));  
    s=regionprops(BW,'BoundingBox');

    props = regionprops(BW,'centroid');
    blbCentroids = cat(1,props.Centroid);
    corners = corner(BW);
    seed = [blbCentroids;corners];
    

    figure(1);
    imshow(frame);
    title([num2str(StaplesCount) ' objects']);
    hold on;
%     text(1050, 50, ['Number of objects: ' num2str(StaplesCount)], 'Color', 'g', 'FontSize',18);
    hold on;
    plot(Centroids(:,1), Centroids(:,2), 'g*', 'MarkerSize', 8);
    hold on;
    for j = 1:size(Centroids,1)
        del_points = [];
        currbb=s(j).BoundingBox;
%         rectangle('position',[currbb(1),currbb(2),currbb(3),currbb(4)],'EdgeColor','g', 'LineWidth',2)
        hold on;
        x1 = currbb(1);
        x2 = currbb(1) + currbb(3);
        y1 = currbb(2);
        y2 = currbb(2) + currbb(4);
        for Z = 1:size(seed,1)
            x = seed(Z,1);
            y = seed(Z,2);

            if x>=x1 && x<=x2 && y>=y1 && y<=y2 
                del_points = [x y;del_points];

            end
        end
        
        if size(del_points, 1) > 3
        delaunay_tri=delaunay(del_points(:,1),del_points(:,2));
        x_tri=[]; 
        y_tri=[];
        facecntr =[];
        for i=1:size(delaunay_tri,1)
            x_tri(:,i)=del_points(delaunay_tri(i,:),1)';
            y_tri(:,i)=del_points(delaunay_tri(i,:),2)';
        end   
       
        faceclr='green';           
            faceopac=0.35;               
            vrtxmrkr='o';               
            vrtxmrkrsize=3;             
            vrtxmrkrclr='r';            
            mrkredgeclr=[0 0 0];        
            edgeclr=[0.3 0.3 0.3];      
            edgewidth=1;                      
            patch(x_tri,y_tri,faceclr,'FaceAlpha',faceopac,'Marker',vrtxmrkr,'MarkerFaceColor',vrtxmrkrclr ...
                ,'MarkerSize',vrtxmrkrsize,'MarkerEdgeColor',mrkredgeclr,'EdgeColor',edgeclr,'LineWidth',edgewidth);  

        end
    end


    hold off;
    writeFrame = getframe(gca);    

        writeFrame.cdata = imresize(writeFrame.cdata, [size(frame,1),size(frame,2)]);
        writeVideo(writerObj,writeFrame.cdata); % 

    if save_output
    saveas(1, [address num2str(counter) '.png'])
    end

    close();
    end
end
close(writerObj);
