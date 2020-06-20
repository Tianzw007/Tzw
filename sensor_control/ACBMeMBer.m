function ACBMeMBer
close all;
%clear all;
clc;
p=2; c=100;
K= 35;
X_s = 10;
Y_s = 10;
global x_dim clutterpdf Tmax T_threshold Lmax Lmin lambda_c P_S T sigma_vel B2 C_posn Sen bar_q lambda_b bar_x bar_B;
Sen=[X_s;Y_s];
x_dim=4;
range_c= [ 0 1000; 0 1000 ];
clutterpdf=1/prod(range_c(:,2)-range_c(:,1));
P_S= 0.99;
Tmax= 300;
T_threshold= 1e-3;
Lmax= 1500;
Lmin= 300;
lambda_c = 0.5;
T = 1;
sigma_vel = 0.05;
B2 = sigma_vel*kron(eye(2),[T^3/3 T^2/2;T^2/2 T]);
C_posn = [ 1 0 0 0 ; 0 0 1 0 ];

L_b= 5;
bar_q= zeros(L_b,1);
lambda_b= cell(L_b,1);
bar_x= cell(L_b,1);
bar_B= cell(L_b,1);

bar_q(1)=0.05;
lambda_b{1}(1)= 1;
bar_x{1}(:,1)= [ 800; 0; 600; 0 ];
bar_B{1}(:,:,1)= diag([ 1.0; 0.00005; 1.0; 0.00005 ]);

bar_q(2)=0.05;
lambda_b{2}(1)= 1;
bar_x{2}(:,1)= [ 650; 0; 500; 0 ];
bar_B{2}(:,:,1)= diag([ 1.0; 0.00005; 1.0; 0.00005 ]);

bar_q(3)=0.05;
lambda_b{3}(1)= 1;
bar_x{3}(:,1)= [ 620; 0; 700; 0 ];
bar_B{3}(:,:,1)= diag([ 1.0; 0.00005; 1.0; 0.00005 ]);

bar_q(4)=0.05;
lambda_b{4}(1)= 1;
bar_x{4}(:,1)= [ 750; 0; 800; 0 ];
bar_B{4}(:,:,1)= diag([ 1.0; 0.00005; 1.0; 0.00005 ]);

bar_q(5)=0.05;
lambda_b{5}(1)= 1;
bar_x{5}(:,1)= [ 700; 0; 400; 0 ];
bar_B{5}(:,:,1)= diag([ 1.0; 0.00005; 1.0; 0.00005 ]);

X=cell(K,1);
track_list= cell(K,1);
N_true= zeros(K,1);
nbirths = 5;

xstart(:,1) = [800+0.38676; 0.25; 600-1.17457; 0.35]; tbirth(1) = 1; tdeath(1) = K;
xstart(:,2) = [650-0.58857; 0.35; 500+1.14102; 0.2]; tbirth(2) = 1;tdeath(2) = K;
xstart(:,3) = [620+0.38676; 0.25; 700-1.17457; -0.4]; tbirth(3) = 1;tdeath(3) = K;
xstart(:,4) = [750-0.58857; 0.2; 800+1.14102; -0.35]; tbirth(4) = 1;tdeath(4) = K;
xstart(:,5) = [700-0.58857; 0.15; 400+1.14102; -0.4]; tbirth(5) = 1;tdeath(5) = K;

for targetnum=1:nbirths
    targetstate = xstart(:,targetnum);
    for k=tbirth(targetnum):min(tdeath(targetnum),K)
        targetstate = gen_newstate_fn(targetstate,zeros(4,1));
        X{k} = [X{k} targetstate];
        track_list{k} = [track_list{k} targetnum];
        N_true(k) = N_true(k)+1;
    end
end
total_tracks = nbirths;

hat_N= zeros(K,1);
hat_X= cell(K,1);
Sen_cell=cell(K,1);
Z= cell(K,1);

for k=1:K
    if k==1
        [L_predict,q_predict,N_predict,w_predict,X_predict]=Prediction_1(L_b);
    else
        [L_predict,q_predict,N_predict,w_predict,X_predict]=Prediction_2(L_b,L_update,w_update,q_update,N_update,X_update);
    end
        
    [X_s,Y_s,~] = Sensor_Control(L_predict,q_predict,N_predict,w_predict,X_predict,k);
    Sen=[X_s;Y_s];
    Sen_cell{k}=Sen;
    if N_true(k)> 0
        idx= rand(N_true(k),1) <= compute_pD(X{k});
        Z{k}= gen_observation(X{k}(:,idx));
    end
    C= Clutter_meas;
    Z{k}= [Z{k} C];
    [X_pseudo,N_update,q_update,w_update,L_update]=Update(k,N_predict,L_predict,w_predict,X_predict,q_predict,Z);
    
    [X_update,N_update,w_update]=Resampling_fn(q_update,w_update,X_predict,N_update,X_pseudo,L_update,L_predict);
    
    [L_update,N_update,q_update,w_update,X_update]=Tun_Mer_Pur(N_update,q_update,w_update,X_update);
    
    [hat_X,hat_N]=Card_Stat_Est(q_update,X_update,w_update,hat_N,hat_X,k);
    
    [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks);
        figure(1); subplot(2,1,1); box on;
        for i=1:total_tracks
            P= C_posn*X_track(:,k_birth(i):1:k_death(i),i);
            hline1= line(k_birth(i):1:k_death(i),P(1,:),'LineStyle','-','Marker','none',...
                'LineWidth',1,'Color',0*ones(1,3));
        end
        if ~isempty(hat_X{k})
            P= C_posn*hat_X{k};
            hline2= line(k*ones(size(hat_X{k},2),1),P(1,:),'LineStyle','none','Marker','.',...
                  'Markersize',8,'Color',0*ones(1,3));
        end
        figure(1); subplot(2,1,2); box on;
        for i=1:total_tracks
            P= C_posn*X_track(:,k_birth(i):1:k_death(i),i);
            line(k_birth(i):1:k_death(i),P(2,:),'LineStyle','-','Marker','none',...
            'LineWidth',1,'Color',0*ones(1,3));
        end
        if ~isempty(hat_X{k})
            P= C_posn*hat_X{k};
            line(k*ones(size(hat_X{k},2),1),P(2,:),'LineStyle','none','Marker','.',...
                 'Markersize',8,'Color',0*ones(1,3));
        end
        figure(1);subplot(2,1,1); xlabel('Time'); ylabel('x-coordinate (m)');
        set(gca, 'XLim',[1 K]); set(gca, 'YLim',[0 1000]);
        legend([hline2 hline1],'Filter estimates ','True tracks');
        figure(1); subplot(2,1,2);xlabel('Time'); ylabel('y-coordinate (m)');
        set(gca, 'XLim',[1 K]); set(gca, 'YLim',[0 1000]);

        limit2= 1000*[ 0 1 0 1 ];
        [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks);
        figure(2); 
        subplot (2,1,1);
        box on;
        for i=1:total_tracks
            P= C_posn*X_track(:,k_birth(i):1:k_death(i),i);
            plot(P(1,:),P(2,:),'k-x'); hold on;
            plot( P(1,1), P(2,1), 'ko','MarkerFaceColor','k' );
            plot( P(1,(k_death(i)-k_birth(i)+1)), P(2,(k_death(i)-k_birth(i)+1)), 'ks','MarkerFaceColor','k');
            temp= round((k_death(i)-k_birth(i)+1)/2);
            str= ['Target ',num2str(i)];
            text(P(1,temp)+10,P(2,temp),str);
        end
        if ~isempty(hat_X{k})
            plot(hat_X{k}(1,:),hat_X{k}(3,:),'LineStyle','none','Marker','o','Markersize',4,'Color','r');
        end
        xlabel('x coordinate (m)','fontsize',15); ylabel('y coordinate (m)','fontsize',15);
        axis(limit2); axis equal;
        plot(Sen_cell{k}(1,:),Sen_cell{k}(2,:),'LineStyle','none','Marker','S','Markersize',4,'Color','r');
        if k > 1
            plot([Sen_cell{k-1}(1,:) Sen_cell{k}(1,:)],[Sen_cell{k-1}(2,:) Sen_cell{k}(2,:)],'m');
        end
        figure(2); subplot(2,1,2); box on;
        plot(1:K,N_true,'k');
        line (1:K,hat_N,'Color','r','LineWidth',0.25,'Marker','.','LineStyle','-');
        set(gca, 'XLim',[1 K]);
        set(gca, 'YLim',[0 max(N_true)+1]);
        legend(gca,'True','Mean');
        figure(2);subplot(2,1,2);xlabel('Time'); ylabel('CardinalityStatistics');
        [SD_mem(k,1,1),SD_mem_pos(k,1,1),SD_mem_crd(k,1,1)]= ospa_dist(get_comps(X{k},[1 3]),get_comps(hat_X{k},[1 3]),c,p);
        figure (3);
        subplot(3,1,1); box on;
        plot(mean(SD_mem(:,:,1),2),'k');
        xlabel('Time'); ylabel(['OSPA (m)(c=' num2str(c) ', p=' num2str(p) ')']);
        legend('CBMeMBer');
        axis([1 K -c c]); axis auto;
        subplot(3,1,2); box on;
        plot(mean(SD_mem_pos(:,:,1),2),'k');
        xlabel('Time'); ylabel(['OSPA Loc (m)(c=' num2str(c) ', p=' num2str(p) ')']);
        legend('CBMeMBer');
        axis([1 K -c c]); axis auto;
        subplot(3,1,3); box on;
        plot(mean(SD_mem_crd(:,:,1),2),'k');
        xlabel('Time'); ylabel(['OSPA Card (m)(c=' num2str(c) ', p=' num2str(p) ')']);
        legend('CBMeMBer');
        axis([1 K -c c]);axis auto;
        save SD_mem.mat SD_mem; save SD_mem_pos.mat SD_mem_pos; save SD_mem_crd.mat SD_mem_crd;

end
end

function Xc= get_comps(X,c)

if isempty(X)
    Xc= [];
else
    Xc= X(c,:);
end
end

